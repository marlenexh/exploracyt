'use strict';

const query = new URLSearchParams(location.search);
const type = query.get('type');
const media = document.querySelector('#media');
const message = document.querySelector('#message');
const source = query.get('asset') || '';
const assetPath = /^assets\/biology_media\/[a-z0-9_-]+\.(mp4|glb|vtt)$/;
const unavailable = () => {
  message.textContent = 'El recurso no está disponible. Vuelve a la misión para continuar con el modelo 2D.';
};

if (type === 'youtube' && /^[\w-]{11}$/.test(query.get('id') || '')) {
  if (navigator.onLine) {
    const frame = document.createElement('iframe');
    frame.title = 'Video educativo de YouTube';
    frame.src = 'https://www.youtube-nocookie.com/embed/' + query.get('id');
    frame.allowFullscreen = true;
    media.append(frame);
  } else unavailable();
} else if (assetPath.test(source) && type === 'video' && source.endsWith('.mp4')) {
  const player = document.createElement('video');
  player.controls = true;
  player.src = 'assets/' + source;
  player.addEventListener('error', unavailable);
  const captions = query.get('captions') || '';
  if (assetPath.test(captions) && captions.endsWith('.vtt')) {
    const track = document.createElement('track');
    track.kind = 'captions';
    track.srclang = 'es';
    track.label = 'Español';
    track.src = 'assets/' + captions;
    player.append(track);
  }
  media.append(player);
} else if (assetPath.test(source) && type === 'model' && source.endsWith('.glb')) {
  import('./assets/assets/biology_media/model-viewer.min.js').then(() => {
    const model = document.createElement('model-viewer');
    model.src = 'assets/' + source;
    model.alt = 'Modelo anatómico educativo';
    model.setAttribute('camera-controls', '');
    const animation = document.createElement('button');
    animation.textContent = 'Reproducir animación';
    animation.hidden = true;
    animation.addEventListener('click', () => {
      if (model.paused) {
        model.play();
        animation.textContent = 'Pausar animación';
      } else {
        model.pause();
        animation.textContent = 'Reproducir animación';
      }
    });
    model.addEventListener('load', () => { animation.hidden = !model.availableAnimations.length; });
    model.addEventListener('error', unavailable);
    media.append(model, animation);
  }).catch(unavailable);
} else unavailable();
