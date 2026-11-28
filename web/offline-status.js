'use strict';

// Prepares offline use silently in the background: no message is shown,
// so nothing covers the app's buttons. If it fails, the app keeps working online
// and it is retried the next time the page opens.
async function prepareOffline() {
  if (!('serviceWorker' in navigator) || !window.isSecureContext) return;
  try {
    const registration = await navigator.serviceWorker.register('offline-worker.js', {updateViaCache: 'none'});
    if (navigator.onLine) await registration.update().catch(() => {});
  } catch (error) {
    // Offline use stays unavailable; the online app is unaffected.
  }
}

void prepareOffline();
