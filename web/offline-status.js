'use strict';

const statusPanel = document.querySelector('#offline-status');
const detail = statusPanel.querySelector('p');
const prepare = statusPanel.querySelector('button');
const summary = statusPanel.querySelector('summary');
const setStatus = (label, explanation) => {
  summary.textContent = label;
  detail.textContent = explanation;
};

async function checkOffline(worker) {
  if (!worker) return;
  const channel = new MessageChannel();
  const valid = await new Promise(resolve => {
    const timeout = setTimeout(() => {
      channel.port1.close();
      resolve(false);
    }, 5000);
    channel.port1.onmessage = event => {
      clearTimeout(timeout);
      channel.port1.close();
      resolve(event.data === true);
    };
    worker.postMessage('check-offline', [channel.port2]);
  });
  if (valid) {
    setStatus('Disponible sin conexión', 'Los recursos de la aplicación se guardaron en este navegador.');
  } else {
    setStatus('Caché incompleta', 'Vuelve a preparar la aplicación con Internet antes de usarla sin conexión.');
  }
}

async function prepareOffline() {
  if (!('serviceWorker' in navigator)) {
    prepare.disabled = true;
    setStatus('Modo offline no disponible', 'Usa un navegador compatible en un sitio HTTPS.');
    return;
  }
  if (!navigator.onLine && navigator.serviceWorker.controller) {
    await checkOffline(navigator.serviceWorker.controller);
    return;
  }
  prepare.disabled = true;
  setStatus('Preparando uso sin conexión…', 'Mantén esta pestaña abierta mientras se guardan los recursos.');
  try {
    const registration = await navigator.serviceWorker.register('offline-worker.js', {updateViaCache: 'none'});
    const worker = registration.installing || registration.waiting;
    if (worker) {
      await new Promise((resolve, reject) => {
        const onState = () => {
          if (worker.state === 'activated' || (worker.state === 'installed' && registration.active)) {
            worker.removeEventListener('statechange', onState);
            resolve();
          } else if (worker.state === 'redundant') {
            worker.removeEventListener('statechange', onState);
            reject(new Error('Offline worker could not be installed'));
          }
        };
        worker.addEventListener('statechange', onState);
        onState();
      });
    }
    await checkOffline(registration.active);
    if (registration.waiting) {
      detail.textContent += ' Hay una actualización preparada. Cierra las pestañas de Explora Ciencia y vuelve a abrirla.';
    }
  } catch (error) {
    setStatus('Error al preparar uso sin conexión', 'Comprueba la conexión y el espacio del navegador. Luego vuelve a intentar.');
  } finally {
    prepare.disabled = false;
  }
}

prepare.addEventListener('click', () => {
  if (navigator.onLine && 'serviceWorker' in navigator) {
    void navigator.serviceWorker.getRegistration().then(async registration => {
      if (registration) await registration.update().catch(() => {});
      await prepareOffline();
    });
  } else void prepareOffline();
});
void prepareOffline();
