/* global exploraOffline */
'use strict';

importScripts('offline-manifest.js');
const scope = new URL(self.registration.scope);
const prefix = 'explora:' + scope.pathname + ':';
const cacheName = prefix + exploraOffline.version;
const files = new Set(exploraOffline.files.map(file => new URL(file, scope).href));
const index = new URL('index.html', scope).href;

// Files the app cannot start without. Everything else is saved when possible,
// so a single missing or blocked file no longer breaks offline preparation.
const required = new Set((exploraOffline.required || ['index.html', 'main.dart.js', 'flutter_bootstrap.js'])
  .map(file => new URL(file, scope).href));

async function save(cache, url) {
  for (let attempt = 0; attempt < 2; attempt++) {
    try {
      const response = await fetch(new Request(url, {cache: 'reload'}));
      if (response.ok) {
        await cache.put(url, response);
        return true;
      }
    } catch (error) {
      // Retry once, then continue with the rest.
    }
  }
  return false;
}

self.addEventListener('install', event => {
  event.waitUntil((async () => {
    const cache = await caches.open(cacheName);
    const entries = [...files];
    const failed = [];
    // Keep concurrency bounded on slow connections.
    for (let offset = 0; offset < entries.length; offset += 6) {
      const batch = entries.slice(offset, offset + 6);
      const results = await Promise.all(batch.map(url => save(cache, url)));
      results.forEach((ok, i) => { if (!ok) failed.push(batch[i]); });
    }
    if (failed.some(url => required.has(url))) {
      await caches.delete(cacheName);
      throw new Error('Required offline files could not be saved');
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
    const saved = [...files].filter(file => names.has(file)).length;
    const ready = [...required].every(file => names.has(file));
    event.ports[0].postMessage({ready, saved, total: files.size});
  })().catch(() => event.ports[0].postMessage({ready: false, saved: 0, total: files.size})));
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
