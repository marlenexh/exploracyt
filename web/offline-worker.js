/* global exploraOffline */
'use strict';

importScripts('offline-manifest.js');
const scope = new URL(self.registration.scope);
const prefix = 'explora:' + scope.pathname + ':';
const cacheName = prefix + exploraOffline.version;
const files = new Set(exploraOffline.files.map(file => new URL(file, scope).href));
const index = new URL('index.html', scope).href;

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(cacheName);
    try {
      // Keep concurrency bounded on slow connections.
      const entries = [...files];
      for (let offset = 0; offset < entries.length; offset += 8) {
        await cache.addAll(entries.slice(offset, offset + 8).map(
          url => new Request(url, {cache: 'reload'})
        ));
      }
    } catch (error) {
      await caches.delete(cacheName);
      throw error;
    }
  })());
});

self.addEventListener('activate', event => {
  event.waitUntil((async () => {
    const previous = (await caches.keys()).filter(
      name => name.startsWith(prefix) && name !== cacheName
    );
    await Promise.all(previous.map(name => caches.delete(name)));
    await self.clients.claim();
  })());
});

self.addEventListener('message', event => {
  if (event.data !== 'check-offline' || !event.ports[0]) return;
  event.waitUntil((async () => {
    const cache = await caches.open(cacheName);
    const names = new Set((await cache.keys()).map(request => request.url));
    event.ports[0].postMessage([...files].every(file => names.has(file)));
  })().catch(() => event.ports[0].postMessage(false)));
});

self.addEventListener('fetch', event => {
  const request = event.request;
  const url = new URL(request.url);
  if (request.method !== 'GET' || !url.href.startsWith(scope.href)) return;
  url.search = '';
  const entry = request.mode === 'navigate' && url.href === scope.href ? index : url.href;
  if (!files.has(entry)) return;

  event.respondWith((async () => {
    const cache = await caches.open(cacheName);
    const cached = await cache.match(entry);
    if (!cached) return fetch(request);
    const range = request.headers.get('range');
    if (!range) return cached;

    // Local MP4 playback can issue byte-range requests even while offline.
    const bytes = await cached.blob();
    const match = /^bytes=(\d*)-(\d*)$/.exec(range);
    const start = match && (match[1] ? Number(match[1]) : Math.max(0, bytes.size - Number(match[2])));
    const end = match && match[1] && match[2] ? Math.min(Number(match[2]), bytes.size - 1) : bytes.size - 1;
    if (!match || (!match[1] && !match[2]) || start > end || start >= bytes.size) {
      return new Response(null, {status: 416, headers: {'Content-Range': 'bytes */' + bytes.size}});
    }
    return new Response(bytes.slice(start, end + 1), {
      status: 206,
      headers: {
        'Content-Type': cached.headers.get('Content-Type') || 'application/octet-stream',
        'Content-Range': `bytes ${start}-${end}/${bytes.size}`,
        'Content-Length': String(end - start + 1),
        'Accept-Ranges': 'bytes',
      },
    });
  })());
});
