import 'dart:js_interop';

@JS('window.open')
external void _open(JSString url, JSString target, JSString features);

void openBodyMedia(String url) =>
    _open(url.toJS, '_blank'.toJS, 'noopener,noreferrer'.toJS);
