import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show textoEn, linea, relleno;
import '../biology/tema1/ui_divertida.dart' show oscurecer;
import '../biology/temas/ilustraciones.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Ilustraciones de Programación (basadas en los ejemplos del libro
/// "Fundamentos de programación": algoritmos, diagramas de flujo, etc.).

Offset _p(Rect r, double x, double y) => Offset(r.left + x * r.width, r.top + y * r.height);
double _s(Rect r) => r.width / 256;

void _hoja(Canvas c, Rect r) {
  final rr = RRect.fromRectAndRadius(r, const Radius.circular(20));
  c.drawRRect(rr.shift(const Offset(0, 5)), relleno(const Color(0x44000000)));
  c.drawRRect(rr, relleno(const Color(0xFFFDFDFE)));
  c.drawRRect(rr, linea(const Color(0xFF90A4AE), 3));
}

void _resalte(Canvas c, Offset p, double radio, bool on, double t) {
  if (on) c.drawCircle(p, radio + 3 * math.sin(t * 5), linea(const Color(0xFFFFA000), 3));
}

void _flecha(Canvas c, Offset a, Offset b, {Color color = const Color(0xFF455A64), double ancho = 2.5}) {
  c.drawLine(a, b, linea(color, ancho)..strokeCap = StrokeCap.round);
  final d = b - a;
  if (d.distance == 0) return;
  final u = d / d.distance, n = Offset(-u.dy, u.dx);
  c.drawPath(
      Path()
        ..moveTo(b.dx, b.dy)
        ..lineTo((b - u * 9 + n * 5).dx, (b - u * 9 + n * 5).dy)
        ..lineTo((b - u * 9 - n * 5).dx, (b - u * 9 - n * 5).dy)
        ..close(),
      relleno(color));
}

/// Símbolos de diagrama de flujo.
enum Forma { ovalo, rect, paralelo, rombo }

void dibujarForma(Canvas c, Forma f, Offset centro, double w, double h, String texto, Color color, {double tam = 11, bool brillo = false}) {
  final r = Rect.fromCenter(center: centro, width: w, height: h);
  final Path p;
  switch (f) {
    case Forma.ovalo:
      p = Path()..addRRect(RRect.fromRectAndRadius(r, Radius.circular(h / 2)));
    case Forma.rect:
      p = Path()..addRRect(RRect.fromRectAndRadius(r, const Radius.circular(3)));
    case Forma.paralelo:
      final k = h * 0.35;
      p = Path()
        ..moveTo(r.left + k, r.top)
        ..lineTo(r.right, r.top)
        ..lineTo(r.right - k, r.bottom)
        ..lineTo(r.left, r.bottom)
        ..close();
    case Forma.rombo:
      p = Path()
        ..moveTo(r.center.dx, r.top)
        ..lineTo(r.right, r.center.dy)
        ..lineTo(r.center.dx, r.bottom)
        ..lineTo(r.left, r.center.dy)
        ..close();
  }
  c.drawPath(p.shift(const Offset(0, 2.5)), relleno(const Color(0x33000000)));
  c.drawPath(p, relleno(brillo ? Color.lerp(color, Colors.white, 0.35)! : color));
  c.drawPath(p, linea(oscurecer(color, 0.35), 1.8));
  final tp = TextPainter(
    text: TextSpan(text: texto, style: TextStyle(fontSize: tam, fontWeight: FontWeight.w700, color: Colors.white, height: 1.05)),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  )..layout(maxWidth: f == Forma.rombo ? w * 0.62 : w - 10);
  tp.paint(c, centro - Offset(tp.width / 2, tp.height / 2));
}

// ---------------------------------------------------------------------------
// Tema 1
// ---------------------------------------------------------------------------

void _programar(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  // Programador y su idea (algoritmo)
  dibujarEmoji(c, '🧑‍💻', _p(r, 0.22, 0.12), 46 * s);
  final nube = RRect.fromRectAndRadius(Rect.fromCenter(center: _p(r, 0.66, 0.12), width: 120 * s, height: 62 * s), Radius.circular(16 * s));
  c.drawRRect(nube, relleno(const Color(0xFFFFF8E1)));
  c.drawRRect(nube, linea(const Color(0xFFFFB300), 2));
  for (var k = 0; k < 3; k++) {
    textoEn(c, '${k + 1}. ${['Avanzar', 'Girar', 'Llegar'][k]}', _p(r, 0.66, 0.06 + k * 0.055), tam: 11 * s, color: const Color(0xFF6D4C41));
  }
  _flecha(c, _p(r, 0.5, 0.22), _p(r, 0.5, 0.31));
  // Computadora con código
  final mon = Rect.fromCenter(center: _p(r, 0.5, 0.47), width: 190 * s, height: 110 * s);
  c.drawRRect(RRect.fromRectAndRadius(mon, Radius.circular(10 * s)), relleno(const Color(0xFF263238)));
  final cols = [const Color(0xFFFFAB19), const Color(0xFF4C97FF), const Color(0xFF59C059), const Color(0xFF4C97FF), const Color(0xFFFFAB19)];
  for (var k = 0; k < 5; k++) {
    final w = (60 + (k * 37 % 70)) * s;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(mon.left + (14 + (k % 3 == 1 ? 14 : 0)) * s, mon.top + (12 + k * 18) * s, w, 10 * s), Radius.circular(4 * s)), relleno(cols[k]));
  }
  if ((t * 2) % 1 < 0.5) c.drawRect(Rect.fromLTWH(mon.left + 120 * s, mon.top + 84 * s, 3 * s, 12 * s), relleno(Colors.white));
  c.drawRect(Rect.fromCenter(center: _p(r, 0.5, 0.645), width: 40 * s, height: 12 * s), relleno(const Color(0xFF546E7A)));
  _flecha(c, _p(r, 0.5, 0.67), _p(r, 0.5, 0.75));
  // Resultado: el robot se mueve
  final res = Rect.fromCenter(center: _p(r, 0.5, 0.87), width: 190 * s, height: 70 * s);
  c.drawRRect(RRect.fromRectAndRadius(res, Radius.circular(12 * s)), relleno(const Color(0xFFE8F5E9)));
  c.drawRRect(RRect.fromRectAndRadius(res, Radius.circular(12 * s)), linea(const Color(0xFF66BB6A), 2));
  final x = res.left + 26 * s + ((t * 0.3) % 1) * (res.width - 70 * s);
  dibujarEmoji(c, '🤖', Offset(x, res.center.dy), 34 * s);
  dibujarEmoji(c, '🏁', Offset(res.right - 22 * s, res.center.dy), 28 * s);
  for (final (id, x, y, rad) in const [('programador', 0.22, 0.12, 30.0), ('algoritmo', 0.66, 0.12, 60.0), ('programa', 0.5, 0.47, 70.0), ('resultado', 0.5, 0.87, 60.0)]) {
    _resalte(c, _p(r, x, y), rad * s, sel == id, t);
  }
}

const ilProgramar = Ilustracion(_programar, {
  'programador': Offset(0.22, 0.12),
  'algoritmo': Offset(0.89, 0.12),
  'programa': Offset(0.5, 0.47),
  'resultado': Offset(0.5, 0.87),
});

void _pensamiento(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  final cuadros = [
    ('descomposicion', 0.27, 0.24, const Color(0xFFE3F2FD), 'Descomponer'),
    ('patrones', 0.73, 0.24, const Color(0xFFFCE4EC), 'Patrones'),
    ('abstraccion', 0.27, 0.72, const Color(0xFFE8F5E9), 'Abstraer'),
    ('algoritmo', 0.73, 0.72, const Color(0xFFFFF8E1), 'Algoritmo'),
  ];
  for (final (id, x, y, col, nombre) in cuadros) {
    final q = Rect.fromCenter(center: _p(r, x, y), width: 112 * s, height: 160 * s);
    c.drawRRect(RRect.fromRectAndRadius(q, Radius.circular(14 * s)), relleno(col));
    textoEn(c, nombre, Offset(q.center.dx, q.bottom - 14 * s), tam: 12 * s, color: const Color(0xFF37474F));
    _resalte(c, q.center, 62 * s, sel == id, t);
  }
  // Descomponer: un pastel en rebanadas
  final pc = _p(r, 0.27, 0.21);
  for (var k = 0; k < 4; k++) {
    final sep = 4 * s * (0.5 + 0.5 * math.sin(t * 2));
    final a = k * math.pi / 2 + math.pi / 4;
    c.drawArc(Rect.fromCircle(center: pc + Offset(math.cos(a), math.sin(a)) * sep, radius: 34 * s), k * math.pi / 2, math.pi / 2, true,
        relleno([const Color(0xFFFFB74D), const Color(0xFFFF8A65), const Color(0xFFFFB74D), const Color(0xFFFF8A65)][k]));
  }
  // Patrones
  for (var k = 0; k < 6; k++) {
    final p = _p(r, 0.73, 0.14) + Offset((k % 3 - 1) * 30 * s, (k ~/ 3) * 34 * s);
    dibujarEmoji(c, k.isEven ? '⭐' : '🔺', p, 24 * s * (k == ((t * 2).floor() % 6) ? 1.25 : 1));
  }
  // Abstraer: mapa sencillo
  final m = _p(r, 0.27, 0.67);
  c.drawLine(m + Offset(-36 * s, 20 * s), m + Offset(36 * s, -20 * s), linea(const Color(0xFF8D6E63), 5 * s));
  dibujarEmoji(c, '🏠', m + Offset(-36 * s, 20 * s), 24 * s);
  dibujarEmoji(c, '🏫', m + Offset(36 * s, -20 * s), 24 * s);
  // Algoritmo
  for (var k = 0; k < 4; k++) {
    textoEn(c, '${k + 1}. ${['Inicio', 'Paso', 'Paso', 'Fin'][k]}', _p(r, 0.73, 0.6 + k * 0.05), tam: 11.5 * s, color: const Color(0xFF6D4C41));
  }
}

const ilPensamiento = Ilustracion(_pensamiento, {
  'descomposicion': Offset(0.27, 0.21),
  'patrones': Offset(0.73, 0.2),
  'abstraccion': Offset(0.27, 0.67),
  'algoritmo': Offset(0.94, 0.68),
});

/// Análisis del problema: área de un rectángulo (ejemplo del libro).
void _entradaProceso(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  dibujarForma(c, Forma.paralelo, _p(r, 0.5, 0.12), 190 * s, 52 * s, 'ENTRADA\nbase = 5   altura = 3', const Color(0xFF8E24AA), tam: 12 * s, brillo: sel == 'entrada');
  _flecha(c, _p(r, 0.5, 0.2), _p(r, 0.5, 0.27));
  dibujarForma(c, Forma.rect, _p(r, 0.5, 0.34), 190 * s, 52 * s, 'PROCESO\nárea = base × altura', const Color(0xFFEF6C00), tam: 12 * s, brillo: sel == 'proceso');
  _flecha(c, _p(r, 0.5, 0.42), _p(r, 0.5, 0.49));
  dibujarForma(c, Forma.paralelo, _p(r, 0.5, 0.56), 190 * s, 52 * s, 'SALIDA\nÁrea = 15', const Color(0xFF1E88E5), tam: 12 * s, brillo: sel == 'salida');
  // Rectángulo de 5 × 3
  final cel = 26 * s;
  final o = _p(r, 0.5, 0.8) - Offset(cel * 2.5, cel * 1.5);
  final llenas = ((t * 4) % 16).floor();
  for (var k = 0; k < 15; k++) {
    final q = Rect.fromLTWH(o.dx + (k % 5) * cel, o.dy + (k ~/ 5) * cel, cel, cel);
    c.drawRect(q, relleno(k < llenas ? const Color(0xFF81D4FA) : const Color(0xFFE1F5FE)));
    c.drawRect(q, linea(const Color(0xFF0277BD), 1));
  }
  textoEn(c, 'base = 5', _p(r, 0.5, 0.95), tam: 11 * s, color: const Color(0xFF0277BD));
  for (final (id, y) in [('entrada', 0.12), ('proceso', 0.34), ('salida', 0.56), ('rectangulo', 0.8)]) {
    _resalte(c, _p(r, 0.5, y), (id == 'rectangulo' ? 70 : 40) * s, sel == id && id == 'rectangulo', t);
  }
}

const ilEntradaProceso = Ilustracion(_entradaProceso, {
  'entrada': Offset(0.16, 0.12),
  'proceso': Offset(0.87, 0.34),
  'salida': Offset(0.83, 0.56),
  'rectangulo': Offset(0.5, 0.8),
});

// ---------------------------------------------------------------------------
// Tema 2
// ---------------------------------------------------------------------------

/// "Algoritmo para ir a la escuela" (ejemplo del libro).
void _algoritmo(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  const pasos = ['Me despierto', 'Me levanto', 'Me baño', 'Me visto', 'Me desayuno', 'Me lavo los dientes', 'Tomo el transporte', 'Llego a la escuela'];
  dibujarForma(c, Forma.ovalo, _p(r, 0.5, 0.07), 110 * s, 30 * s, 'Inicio', const Color(0xFF43A047), tam: 13 * s, brillo: sel == 'inicio');
  final actual = (t * 1.2).floor() % (pasos.length + 2);
  for (var k = 0; k < pasos.length; k++) {
    final y = 0.155 + k * 0.088;
    final q = Rect.fromCenter(center: _p(r, 0.54, y), width: 190 * s, height: 26 * s);
    c.drawRRect(RRect.fromRectAndRadius(q, Radius.circular(8 * s)), relleno(actual == k + 1 ? const Color(0xFFFFF59D) : const Color(0xFFF1F8E9)));
    c.drawRRect(RRect.fromRectAndRadius(q, Radius.circular(8 * s)), linea(const Color(0xFFAED581), 1.2));
    c.drawCircle(Offset(q.left - 14 * s, q.center.dy), 11 * s, relleno(const Color(0xFF4C97FF)));
    textoEn(c, '${k + 1}', Offset(q.left - 14 * s, q.center.dy), tam: 11 * s, color: Colors.white);
    textoEn(c, pasos[k], q.center, tam: 11.5 * s, color: const Color(0xFF33691E));
  }
  dibujarForma(c, Forma.ovalo, _p(r, 0.5, 0.88 + 0.06), 110 * s, 30 * s, 'Fin', const Color(0xFFE53935), tam: 13 * s, brillo: sel == 'fin');
  for (final (id, y) in [('paso', 0.33), ('orden', 0.6)]) {
    _resalte(c, _p(r, 0.54, y), 34 * s, sel == id, t);
  }
}

const ilAlgoritmo = Ilustracion(_algoritmo, {
  'inicio': Offset(0.29, 0.07),
  'paso': Offset(0.17, 0.33),
  'orden': Offset(0.91, 0.6),
  'fin': Offset(0.71, 0.94),
});

/// Diagrama de flujo con los símbolos básicos.
void _diagrama(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  final w = 150 * s, h = 34 * s;
  final ys = [0.07, 0.2, 0.36, 0.53, 0.71, 0.88];
  for (var k = 0; k < ys.length - 1; k++) {
    if (k == 3) continue;
    _flecha(c, _p(r, 0.42, ys[k]) + Offset(0, h / 2), _p(r, 0.42, ys[k + 1]) - Offset(0, h / 2 + 2));
  }
  // Decisión: sí → imprimir, no → fin directo
  _flecha(c, _p(r, 0.42, ys[3]) + Offset(0, h * 0.75), _p(r, 0.42, ys[4]) - Offset(0, h / 2 + 2));
  textoEn(c, 'Sí', _p(r, 0.48, 0.615), tam: 11 * s, color: const Color(0xFF2E7D32));
  final der = _p(r, 0.42, ys[3]) + Offset(w * 0.55, 0);
  c.drawLine(der, Offset(r.left + r.width * 0.9, der.dy), linea(const Color(0xFF455A64), 2.5));
  c.drawLine(Offset(r.left + r.width * 0.9, der.dy), Offset(r.left + r.width * 0.9, _p(r, 0, ys[5]).dy), linea(const Color(0xFF455A64), 2.5));
  _flecha(c, Offset(r.left + r.width * 0.9, _p(r, 0, ys[5]).dy), _p(r, 0.42, ys[5]) + Offset(w * 0.38, 0));
  textoEn(c, 'No', Offset(r.left + r.width * 0.84, der.dy - 9 * s), tam: 11 * s, color: const Color(0xFFC62828));
  dibujarForma(c, Forma.ovalo, _p(r, 0.42, ys[0]), w * 0.7, h, 'Inicio', const Color(0xFF43A047), tam: 12 * s, brillo: sel == 'inicioFin');
  dibujarForma(c, Forma.paralelo, _p(r, 0.42, ys[1]), w, h, 'Leer base y altura', const Color(0xFF8E24AA), tam: 11 * s, brillo: sel == 'entrada');
  dibujarForma(c, Forma.rect, _p(r, 0.42, ys[2]), w, h, 'área = base × altura', const Color(0xFFEF6C00), tam: 11 * s, brillo: sel == 'proceso');
  dibujarForma(c, Forma.rombo, _p(r, 0.42, ys[3]), w * 1.1, h * 1.5, '¿área > 0?', const Color(0xFF00897B), tam: 11 * s, brillo: sel == 'decision');
  dibujarForma(c, Forma.paralelo, _p(r, 0.42, ys[4]), w, h, 'Imprimir área', const Color(0xFF1E88E5), tam: 11 * s, brillo: sel == 'salida');
  dibujarForma(c, Forma.ovalo, _p(r, 0.42, ys[5]), w * 0.7, h, 'Fin', const Color(0xFFE53935), tam: 12 * s, brillo: sel == 'inicioFin');
  _resalte(c, _p(r, 0.42, 0.13), 10 * s, sel == 'flecha', t);
}

const ilDiagrama = Ilustracion(_diagrama, {
  'inicioFin': Offset(0.22, 0.07),
  'entrada': Offset(0.15, 0.2),
  'proceso': Offset(0.71, 0.36),
  'decision': Offset(0.74, 0.53),
  'salida': Offset(0.69, 0.71),
  'flecha': Offset(0.42, 0.13),
});

// ---------------------------------------------------------------------------
// Tema 3
// ---------------------------------------------------------------------------

void dibujarBloque(Canvas c, Offset o, double w, double h, Color col, String texto, double s, {bool sombrero = false, double tam = 11}) {
  final r = Rect.fromLTWH(o.dx, o.dy, w, h);
  final p = Path()
    ..moveTo(r.left, r.top + (sombrero ? 8 * s : 0))
    ..quadraticBezierTo(r.left + (sombrero ? 20 * s : 0), r.top - (sombrero ? 6 * s : 0), r.left + (sombrero ? 40 * s : 0), r.top)
    ..lineTo(r.left + 12 * s, r.top)
    ..lineTo(r.left + 16 * s, r.top + 4 * s)
    ..lineTo(r.left + 28 * s, r.top + 4 * s)
    ..lineTo(r.left + 32 * s, r.top)
    ..lineTo(r.right, r.top)
    ..lineTo(r.right, r.bottom)
    ..lineTo(r.left + 32 * s, r.bottom)
    ..lineTo(r.left + 28 * s, r.bottom + 4 * s)
    ..lineTo(r.left + 16 * s, r.bottom + 4 * s)
    ..lineTo(r.left + 12 * s, r.bottom)
    ..lineTo(r.left, r.bottom)
    ..close();
  c.drawPath(p, relleno(col));
  c.drawPath(p, linea(oscurecer(col, 0.25), 1.2));
  final tp = TextPainter(text: TextSpan(text: texto, style: TextStyle(fontSize: tam * s, fontWeight: FontWeight.w700, color: Colors.white)), textDirection: TextDirection.ltr)
    ..layout(maxWidth: w - 12 * s);
  tp.paint(c, Offset(r.left + 8 * s, r.center.dy - tp.height / 2));
}

void _bloques(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  final x = r.left + 34 * s;
  final w = 188 * s, h = 30 * s;
  final y0 = r.top + 34 * s;
  dibujarBloque(c, Offset(x, y0), w, h, const Color(0xFFFFBF00), 'al hacer clic en 🚩', s, sombrero: true);
  dibujarBloque(c, Offset(x, y0 + h), w, h, const Color(0xFF4C97FF), 'mover 10 pasos', s);
  dibujarBloque(c, Offset(x, y0 + 2 * h), w, h, const Color(0xFF9966FF), 'decir ¡Hola!', s);
  // Bloque repetir en forma de C
  final yc = y0 + 3 * h;
  final c1 = const Color(0xFFFFAB19);
  c.drawRect(Rect.fromLTWH(x, yc, w, h), relleno(c1));
  c.drawRect(Rect.fromLTWH(x, yc, 16 * s, h * 3), relleno(c1));
  c.drawRect(Rect.fromLTWH(x, yc + h * 2.4, w * 0.6, h * 0.6), relleno(c1));
  textoEn(c, 'repetir 4 veces', Offset(x + 70 * s, yc + h / 2), tam: 11 * s, color: Colors.white);
  dibujarBloque(c, Offset(x + 16 * s, yc + h), w - 16 * s, h, const Color(0xFF4C97FF), 'girar ↻ 90 grados', s);
  dibujarBloque(c, Offset(x, yc + 3 * h + 6 * s), w, h, const Color(0xFF5CB1D6), '¿tocando el borde?', s);
  dibujarBloque(c, Offset(x, yc + 4 * h + 6 * s), w, h, const Color(0xFFCF63CF), 'tocar sonido miau', s);
  // Gato que se mueve en el escenario
  final esc = Rect.fromLTWH(r.left + 24 * s, r.bottom - 92 * s, r.width - 48 * s, 72 * s);
  c.drawRRect(RRect.fromRectAndRadius(esc, Radius.circular(10 * s)), relleno(const Color(0xFFE3F2FD)));
  dibujarEmoji(c, '🐱', Offset(esc.left + 24 * s + ((t * 0.4) % 1) * (esc.width - 48 * s), esc.center.dy), 34 * s);
  for (final (id, k, alto) in [('eventos', 0.0, 1.0), ('movimiento', 1.0, 1.0), ('apariencia', 2.0, 1.0), ('control', 3.0, 3.0), ('sensores', 6.2, 1.0)]) {
    _resalte(c, Offset(x + w / 2, y0 + (k + alto / 2) * h), (alto > 1 ? 56 : 30) * s, sel == id, t);
  }
}

const ilBloques = Ilustracion(_bloques, {
  'eventos': Offset(0.14, 0.132),
  'movimiento': Offset(0.14, 0.213),
  'apariencia': Offset(0.14, 0.294),
  'control': Offset(0.86, 0.376),
  'sensores': Offset(0.86, 0.635),
  'escenario': Offset(0.8, 0.85),
});

// ---------------------------------------------------------------------------
// Tema 4
// ---------------------------------------------------------------------------

/// Decisión: si calificación >= 70 → "Aprobado", si no → "Reprobado".
void _decision(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  dibujarForma(c, Forma.paralelo, _p(r, 0.5, 0.09), 170 * s, 36 * s, 'Leer calificación', const Color(0xFF8E24AA), tam: 12 * s);
  _flecha(c, _p(r, 0.5, 0.14), _p(r, 0.5, 0.2));
  dibujarForma(c, Forma.rombo, _p(r, 0.5, 0.31), 190 * s, 74 * s, '¿calificación ≥ 70?', const Color(0xFF00897B), tam: 12 * s, brillo: sel == 'condicion');
  final izq = _p(r, 0.18, 0.31), der = _p(r, 0.82, 0.31);
  c.drawLine(_p(r, 0.5, 0.31) - Offset(95 * s, 0), izq, linea(const Color(0xFF455A64), 2.5));
  c.drawLine(_p(r, 0.5, 0.31) + Offset(95 * s, 0), der, linea(const Color(0xFF455A64), 2.5));
  _flecha(c, izq, _p(r, 0.18, 0.5));
  _flecha(c, der, _p(r, 0.82, 0.5));
  textoEn(c, 'Sí', _p(r, 0.2, 0.27), tam: 12 * s, color: const Color(0xFF2E7D32));
  textoEn(c, 'No', _p(r, 0.8, 0.27), tam: 12 * s, color: const Color(0xFFC62828));
  dibujarForma(c, Forma.paralelo, _p(r, 0.24, 0.56), 110 * s, 40 * s, 'Imprimir "Aprobado"', const Color(0xFF43A047), tam: 10.5 * s, brillo: sel == 'verdadero');
  dibujarForma(c, Forma.paralelo, _p(r, 0.76, 0.56), 110 * s, 40 * s, 'Imprimir "Reprobado"', const Color(0xFFE53935), tam: 10.5 * s, brillo: sel == 'falso');
  c.drawLine(_p(r, 0.24, 0.62), _p(r, 0.24, 0.7), linea(const Color(0xFF455A64), 2.5));
  c.drawLine(_p(r, 0.76, 0.62), _p(r, 0.76, 0.7), linea(const Color(0xFF455A64), 2.5));
  c.drawLine(_p(r, 0.24, 0.7), _p(r, 0.76, 0.7), linea(const Color(0xFF455A64), 2.5));
  _flecha(c, _p(r, 0.5, 0.7), _p(r, 0.5, 0.76));
  dibujarForma(c, Forma.ovalo, _p(r, 0.5, 0.8), 90 * s, 30 * s, 'Fin', const Color(0xFFE53935), tam: 12 * s);
  // Ejemplo animado
  final cal = (t * 0.5).floor().isEven ? 85 : 60;
  textoEn(c, 'Ejemplo: calificación = $cal → ${cal >= 70 ? 'Aprobado ✅' : 'Reprobado ❌'}', _p(r, 0.5, 0.93), tam: 11.5 * s, color: Colors.white,
      fondo: cal >= 70 ? const Color(0xFF43A047) : const Color(0xFFE53935));
}

const ilDecision = Ilustracion(_decision, {
  'condicion': Offset(0.14, 0.31),
  'verdadero': Offset(0.06, 0.56),
  'falso': Offset(0.95, 0.56),
  'ejemplo': Offset(0.9, 0.93),
});

/// Ciclo "mientras" del algoritmo para comprar zapatos (ejemplo del libro).
void _ciclo(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  dibujarForma(c, Forma.ovalo, _p(r, 0.45, 0.06), 100 * s, 28 * s, 'Inicio', const Color(0xFF43A047), tam: 12 * s);
  _flecha(c, _p(r, 0.45, 0.1), _p(r, 0.45, 0.15));
  dibujarForma(c, Forma.rombo, _p(r, 0.45, 0.24), 200 * s, 70 * s, '¿Todavía no compro zapatos?', const Color(0xFF00897B), tam: 11 * s, brillo: sel == 'condicion');
  _flecha(c, _p(r, 0.45, 0.335), _p(r, 0.45, 0.39));
  textoEn(c, 'Sí', _p(r, 0.5, 0.36), tam: 11 * s, color: const Color(0xFF2E7D32));
  final pasos = ['Elijo unos zapatos', 'Me los pruebo', 'Si me quedan, los compro'];
  for (var k = 0; k < 3; k++) {
    dibujarForma(c, Forma.rect, _p(r, 0.45, 0.43 + k * 0.1), 170 * s, 30 * s, pasos[k], const Color(0xFFEF6C00), tam: 11 * s, brillo: sel == 'cuerpo');
    if (k < 2) _flecha(c, _p(r, 0.45, 0.43 + k * 0.1) + Offset(0, 15 * s), _p(r, 0.45, 0.53 + k * 0.1) - Offset(0, 16 * s));
  }
  // Regreso
  final yb = _p(r, 0, 0.67).dy;
  c.drawLine(_p(r, 0.45, 0.63 + 0.04), Offset(_p(r, 0.45, 0).dx, yb), linea(const Color(0xFF7E57C2), 2.5));
  c.drawLine(Offset(_p(r, 0.45, 0).dx, yb), Offset(r.left + 14 * s, yb), linea(const Color(0xFF7E57C2), 2.5));
  c.drawLine(Offset(r.left + 14 * s, yb), Offset(r.left + 14 * s, _p(r, 0, 0.24).dy), linea(const Color(0xFF7E57C2), 2.5));
  _flecha(c, Offset(r.left + 14 * s, _p(r, 0, 0.24).dy), _p(r, 0.45, 0.24) - Offset(100 * s, 0), color: const Color(0xFF7E57C2));
  // Salida
  final xd = r.right - 16 * s;
  c.drawLine(_p(r, 0.45, 0.24) + Offset(100 * s, 0), Offset(xd, _p(r, 0, 0.24).dy), linea(const Color(0xFF455A64), 2.5));
  c.drawLine(Offset(xd, _p(r, 0, 0.24).dy), Offset(xd, _p(r, 0, 0.8).dy), linea(const Color(0xFF455A64), 2.5));
  textoEn(c, 'No', Offset(xd - 14 * s, _p(r, 0, 0.2).dy), tam: 11 * s, color: const Color(0xFFC62828));
  _flecha(c, Offset(xd, _p(r, 0, 0.8).dy), _p(r, 0.45, 0.8) + Offset(50 * s, 0));
  dibujarForma(c, Forma.rect, _p(r, 0.45, 0.8), 100 * s, 28 * s, 'Me los entregan', const Color(0xFF1E88E5), tam: 10.5 * s, brillo: sel == 'salida');
  _flecha(c, _p(r, 0.45, 0.83), _p(r, 0.45, 0.88));
  dibujarForma(c, Forma.ovalo, _p(r, 0.45, 0.92), 90 * s, 28 * s, 'Fin', const Color(0xFFE53935), tam: 12 * s);
  // Contador de vueltas
  final vuelta = (t * 0.6).floor() % 3 + 1;
  textoEn(c, 'Vuelta $vuelta 🔁', Offset(r.left + 40 * s, yb + 14 * s), tam: 11 * s, color: Colors.white, fondo: const Color(0xFF7E57C2));
  _resalte(c, Offset(r.left + 14 * s, _p(r, 0, 0.45).dy), 22 * s, sel == 'regreso', t);
}

const ilCiclo = Ilustracion(_ciclo, {
  'condicion': Offset(0.84, 0.24),
  'cuerpo': Offset(0.12, 0.53),
  'regreso': Offset(0.06, 0.4),
  'salida': Offset(0.65, 0.8),
});

// ---------------------------------------------------------------------------
// Tema 5
// ---------------------------------------------------------------------------

void _errores(Canvas c, Rect r, double t, String? sel) {
  _hoja(c, r);
  final s = _s(r);
  final ed = Rect.fromLTWH(r.left + 14 * s, r.top + 16 * s, r.width - 28 * s, 250 * s);
  c.drawRRect(RRect.fromRectAndRadius(ed, Radius.circular(12 * s)), relleno(const Color(0xFF263238)));
  for (final (k, col) in [(0, const Color(0xFFFF5F56)), (1, const Color(0xFFFFBD2E)), (2, const Color(0xFF27C93F))]) {
    c.drawCircle(Offset(ed.left + (14 + k * 14) * s, ed.top + 12 * s), 4.5 * s, relleno(col));
  }
  final lineas = [
    ('inicio', const Color(0xFF80CBC4), null),
    ('imprimir "Hola', const Color(0xFFFFCC80), 'sintaxis'),
    ('suma = 2 + 2', const Color(0xFFB3E5FC), null),
    ('imprimir suma × 2', const Color(0xFFFFCC80), 'logico'),
    ('total = 10 / 0', const Color(0xFFB3E5FC), 'ejecucion'),
    ('fin', const Color(0xFF80CBC4), null),
  ];
  for (var k = 0; k < lineas.length; k++) {
    final (txt, col, err) = lineas[k];
    final y = ed.top + (34 + k * 34) * s;
    textoEn(c, '${k + 1}', Offset(ed.left + 14 * s, y), tam: 10 * s, color: const Color(0xFF78909C));
    final tp = TextPainter(text: TextSpan(text: txt, style: TextStyle(fontSize: 12.5 * s, color: col, fontWeight: FontWeight.w600)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, Offset(ed.left + 30 * s, y - tp.height / 2));
    if (err != null) {
      final ondas = Path()..moveTo(ed.left + 30 * s, y + 9 * s);
      for (var x = 0.0; x < tp.width; x += 6 * s) {
        ondas.relativeLineTo(3 * s, (x ~/ (6 * s)).isEven ? 3 * s : -3 * s);
        ondas.relativeLineTo(3 * s, (x ~/ (6 * s)).isEven ? -3 * s : 3 * s);
      }
      c.drawPath(ondas, linea(const Color(0xFFFF5252), 1.5));
      final et = switch (err) { 'sintaxis' => 'falta "', 'logico' => '¿× 2?', _ => '÷ 0 💥' };
      textoEn(c, et, Offset(ed.right - 36 * s, y), tam: 10 * s, color: Colors.white, fondo: const Color(0xFFE53935));
      _resalte(c, Offset(ed.left + 30 * s + tp.width / 2, y), 26 * s, sel == err, t);
    }
  }
  // Bichos y lupa (depurar)
  final bx = ed.left + ((t * 0.15) % 1) * ed.width;
  dibujarEmoji(c, '🐞', Offset(bx, ed.bottom + 24 * s), 26 * s);
  final lupa = _p(r, 0.72, 0.86) + Offset(math.sin(t * 1.2) * 14 * s, 0);
  dibujarEmoji(c, '🔍', lupa, 44 * s);
  _resalte(c, lupa, 30 * s, sel == 'depurar', t);
}

const ilErrores = Ilustracion(_errores, {
  'sintaxis': Offset(0.15, 0.227),
  'logico': Offset(0.15, 0.41),
  'ejecucion': Offset(0.9, 0.503),
  'depurar': Offset(0.72, 0.86),
});
