'use strict';

const statusPanel = document.querySelector('#offline-status');
const detail = statusPanel.querySelector('p');
const prepare = statusPanel.querySelector('button');
const summary = statusPanel.querySelector('summary');
let hideTimer;
// The panel only stays visible while preparing or when something needs attention.
const setStatus = (label, explanation, {hideAfter = 0} = {}) => {
  summary.textContent = label;
  detail.textContent = explanation;
  clearTimeout(hideTimer);
  statusPanel.hidden = false;
  if (hideAfter) hideTimer = setTimeout(() => { if (!statusPanel.open) statusPanel.hidden = true; }, hideAfter);
};

async function checkOffline(worker) {
  if (!worker) return;
  const channel = new MessageChannel();
  const state = await new Promise(resolve => {
    const timeout = setTimeout(() => {
      channel.port1.close();
      resolve(null);
    }, 5000);
    channel.port1.onmessage = event => {
      clearTimeout(timeout);
      channel.port1.close();
      resolve(event.data);
    };
    worker.postMessage('check-offline', [channel.port2]);
  });
  if (state && (state === true || (state.ready && state.saved === state.total))) {
    setStatus('Disponible sin conexión', 'Los recursos de la aplicación se guardaron en este navegador.', {hideAfter: 4000});
  } else if (state && state.ready) {
    setStatus('Disponible sin conexión', `Se guardaron ${state.saved} de ${state.total} recursos. Algunos extras necesitarán Internet.`, {hideAfter: 6000});
  } else {
    setStatus('Uso sin conexión pendiente', 'La aplicación funciona con Internet. Pulsa el botón para volver a intentar guardarla.');
  }
}

async function prepareOffline() {
  if (!('serviceWorker' in navigator)) {
    // Without HTTPS (or localhost) browsers do not allow offline mode: stay quiet.
    statusPanel.hidden = true;
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
    setStatus('Uso sin conexión pendiente', 'La aplicación funciona con Internet. Revisa la conexión o el espacio del navegador y pulsa el botón para reintentar.');
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
