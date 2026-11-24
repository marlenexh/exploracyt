import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show linea, relleno, textoEn;
import '../ciencia/escena.dart';

/// Ilustraciones animadas del mundo de Inteligencia Artificial.

const _noche = [Color(0xFF1A1037), Color(0xFF2E1A5E)];

// Tema 1 ----------------------------------------------------------------------

/// Capacidades que necesita una máquina inteligente (según la prueba de Turing).
final ilQueEsIA = escena(const [
  ObjEscena('robot', '🤖', 0.5, 0.48, tam: 0.3, anim: Anim.latir),
  ObjEscena('lenguaje', '💬', 0.2, 0.16, tam: 0.14),
  ObjEscena('razonar', '🧠', 0.8, 0.16, tam: 0.14),
  ObjEscena('aprender', '📚', 0.16, 0.8, tam: 0.14),
  ObjEscena('vision', '👀', 0.84, 0.8, tam: 0.14),
  ObjEscena('actuar', '🦾', 0.5, 0.9, tam: 0.12),
], fondo: _noche, antes: _rayosAlRobot);

void _rayosAlRobot(Canvas c, Rect r, double t, double s) {
  final cen = en(r, 0.5, 0.48);
  for (final p in const [Offset(0.2, 0.16), Offset(0.8, 0.16), Offset(0.16, 0.8), Offset(0.84, 0.8), Offset(0.5, 0.9)]) {
    final a = en(r, p.dx, p.dy);
    c.drawLine(a, cen, linea(const Color(0x55B388FF), 2 * s));
    final f = (t * 0.5 + p.dx + p.dy) % 1;
    c.drawCircle(Offset.lerp(a, cen, f)!, 3 * s, relleno(const Color(0xFFFF80AB)));
  }
}

/// La prueba de Turing: un juez conversa con una persona y una máquina ocultas.
final ilTuring = escena(const [
  ObjEscena('juez', '🧑‍⚖️', 0.5, 0.82, tam: 0.2, anim: Anim.nada),
  ObjEscena('persona', '🧑', 0.22, 0.22, tam: 0.18),
  ObjEscena('maquina', '🤖', 0.78, 0.22, tam: 0.18),
  ObjEscena('pantalla', '💻', 0.5, 0.56, tam: 0.14, anim: Anim.nada),
], fondo: const [
  Color(0xFFEDE7F6),
  Color(0xFFD1C4E9)
], antes: _turing);

void _turing(Canvas c, Rect r, double t, double s) {
  // Pared que separa las habitaciones
  c.drawRect(Rect.fromLTRB(r.left + 8 * s, en(r, 0, 0.4).dy, r.right - 8 * s, en(r, 0, 0.42).dy), relleno(const Color(0xFF7E57C2)));
  c.drawLine(en(r, 0.5, 0.05), en(r, 0.5, 0.4), linea(const Color(0xFF7E57C2), 3 * s));
  textoEn(c, '?', en(r, 0.22, 0.06), tam: 14 * s, color: const Color(0xFF5E35B1));
  textoEn(c, '?', en(r, 0.78, 0.06), tam: 14 * s, color: const Color(0xFF5E35B1));
  // Mensajes que viajan
  for (final x in const [0.22, 0.78]) {
    final f = (t * 0.4 + x) % 1;
    final a = en(r, x, 0.3), b = en(r, 0.5, 0.56);
    c.drawCircle(Offset.lerp(a, b, f)!, 4 * s, relleno(const Color(0xFFFF4081)));
  }
}

/// Un agente inteligente: percibe con sensores, decide con su conocimiento y
/// actúa sobre su ambiente.
final ilAgente = escena(const [
  ObjEscena('ambiente', '🏞️', 0.5, 0.12, tam: 0.2, anim: Anim.nada),
  ObjEscena('sensores', '📷', 0.18, 0.42, tam: 0.14),
  ObjEscena('conocimiento', '🧠', 0.5, 0.58, tam: 0.16, anim: Anim.latir),
  ObjEscena('actuadores', '🦾', 0.82, 0.42, tam: 0.14),
  ObjEscena('robot', '🤖', 0.5, 0.86, tam: 0.18),
], fondo: const [
  Color(0xFFE8F5E9),
  Color(0xFFC8E6C9)
], antes: _cicloAgente);

void _cicloAgente(Canvas c, Rect r, double t, double s) {
  final pts = [en(r, 0.5, 0.18), en(r, 0.18, 0.42), en(r, 0.5, 0.58), en(r, 0.82, 0.42)];
  for (var k = 0; k < 4; k++) {
    flechaEn(c, pts[k], pts[(k + 1) % 4], const Color(0xFF43A047), ancho: 2.5 * s);
  }
  final f = (t * 0.25) % 1;
  final k = (f * 4).floor();
  c.drawCircle(Offset.lerp(pts[k], pts[(k + 1) % 4], f * 4 - k)!, 5 * s, relleno(const Color(0xFFFFB300)));
}

// Tema 2 ----------------------------------------------------------------------

/// Rasgos que sirven para comparar: forma, color, tamaño y textura.
final ilPatrones = escena(const [
  ObjEscena('lupa', '🔍', 0.5, 0.5, tam: 0.22, anim: Anim.girar),
  ObjEscena('forma', '🔺', 0.2, 0.18, tam: 0.14),
  ObjEscena('color', '🎨', 0.8, 0.18, tam: 0.14),
  ObjEscena('tamano', '📏', 0.2, 0.82, tam: 0.14),
  ObjEscena('textura', '🧶', 0.8, 0.82, tam: 0.14),
], fondo: const [
  Color(0xFFFFF8E1),
  Color(0xFFFFE0B2)
], antes: _figuras);

void _figuras(Canvas c, Rect r, double t, double s) {
  const cols = [Color(0xFFE53935), Color(0xFF1E88E5), Color(0xFF43A047), Color(0xFFFFB300)];
  for (var k = 0; k < 8; k++) {
    final a = k / 8 * 2 * math.pi + t * 0.3;
    final p = en(r, 0.5, 0.5) + Offset(math.cos(a) * r.width * 0.3, math.sin(a) * r.height * 0.2);
    final col = relleno(cols[k % 4].withValues(alpha: 0.6));
    if (k.isEven) {
      c.drawCircle(p, 7 * s, col);
    } else {
      c.drawRect(Rect.fromCenter(center: p, width: 12 * s, height: 12 * s), col);
    }
  }
}

/// Una computadora ve una imagen como una cuadrícula de pixeles con números.
final ilPixeles = escena(const [
  ObjEscena('foto', '🐱', 0.25, 0.2, tam: 0.22, anim: Anim.nada),
  ObjEscena('camara', '📸', 0.78, 0.12, tam: 0.12),
  ObjEscena('computadora', '💻', 0.5, 0.88, tam: 0.16, anim: Anim.nada),
], fondo: const [
  Color(0xFFE3F2FD),
  Color(0xFFBBDEFB)
], antes: _pixeles);

void _pixeles(Canvas c, Rect r, double t, double s) {
  final g = Rect.fromCenter(center: en(r, 0.5, 0.56), width: r.width * 0.7, height: r.width * 0.7 * 0.8);
  const n = 8, m = 10;
  final cw = g.width / m, ch = g.height / n;
  for (var i = 0; i < n; i++) {
    for (var j = 0; j < m; j++) {
      final v = ((math.sin(i * 0.9 + 1) + math.cos(j * 0.7)) * 0.25 + 0.5).clamp(0.0, 1.0);
      final cell = Rect.fromLTWH(g.left + j * cw, g.top + i * ch, cw, ch);
      c.drawRect(cell, relleno(Color.lerp(const Color(0xFFFFE0B2), const Color(0xFF6D4C41), v)!));
      c.drawRect(cell, linea(const Color(0x22000000), 0.5));
    }
  }
  final fila = (t * 2).floor() % n;
  c.drawRect(Rect.fromLTWH(g.left, g.top + fila * ch, g.width, ch), linea(const Color(0xFFFF4081), 2 * s));
  textoEn(c, '0 · 128 · 255', en(r, 0.5, 0.76), tam: 10 * s, color: const Color(0xFF1565C0));
}

// Tema 3 ----------------------------------------------------------------------

/// Aprendizaje supervisado: datos con etiqueta → entrenar → modelo → predicción.
final ilAprendizaje = escena(const [
  ObjEscena('datos', '🗂️', 0.22, 0.12, tam: 0.14),
  ObjEscena('etiquetas', '🏷️', 0.78, 0.12, tam: 0.14),
  ObjEscena('entrenar', '🏋️', 0.5, 0.36, tam: 0.14),
  ObjEscena('modelo', '🤖', 0.5, 0.6, tam: 0.18, anim: Anim.latir),
  ObjEscena('nuevo', '🍎', 0.16, 0.86, tam: 0.12),
  ObjEscena('prediccion', '✅', 0.84, 0.86, tam: 0.12),
], fondo: const [
  Color(0xFFE8F5E9),
  Color(0xFFC8E6C9)
], antes: _tuberia);

void _tuberia(Canvas c, Rect r, double t, double s) {
  const col = Color(0xFF2E7D32);
  flechaEn(c, en(r, 0.26, 0.18), en(r, 0.46, 0.32), col, ancho: 2.5 * s);
  flechaEn(c, en(r, 0.74, 0.18), en(r, 0.54, 0.32), col, ancho: 2.5 * s);
  flechaEn(c, en(r, 0.5, 0.42), en(r, 0.5, 0.52), col, ancho: 2.5 * s);
  flechaEn(c, en(r, 0.22, 0.84), en(r, 0.42, 0.68), col, ancho: 2.5 * s);
  flechaEn(c, en(r, 0.58, 0.68), en(r, 0.78, 0.84), col, ancho: 2.5 * s);
}

/// El perceptrón: entradas con pesos que se suman y comparan con un umbral.
final ilNeurona = escena(const [
  ObjEscena('entradas', '🔢', 0.14, 0.12, tam: 0.12, anim: Anim.nada),
  ObjEscena('pesos', '⚖️', 0.4, 0.12, tam: 0.12, anim: Anim.nada),
  ObjEscena('neurona', '🟣', 0.6, 0.5, tam: 0.16, anim: Anim.latir),
  ObjEscena('salida', '💡', 0.9, 0.5, tam: 0.12),
  ObjEscena('cerebro', '🧠', 0.5, 0.88, tam: 0.14),
], fondo: _noche, antes: _perceptron);

void _perceptron(Canvas c, Rect r, double t, double s) {
  final n = en(r, 0.6, 0.5);
  for (var k = 0; k < 3; k++) {
    final x = en(r, 0.12, 0.3 + k * 0.2);
    c.drawCircle(x, 9 * s, relleno(const Color(0xFF7C4DFF)));
    textoEn(c, 'x${k + 1}', x, tam: 9 * s, color: Colors.white);
    c.drawLine(x, n, linea(const Color(0xAAB388FF), (1 + k) * 1.2 * s));
    textoEn(c, 'w${k + 1}', Offset.lerp(x, n, 0.45)! - Offset(0, 8 * s), tam: 8 * s, color: const Color(0xFFFFE082));
    final f = (t * 0.6 + k / 3) % 1;
    c.drawCircle(Offset.lerp(x, n, f)!, 3 * s, relleno(const Color(0xFFFF80AB)));
  }
  flechaEn(c, n + Offset(14 * s, 0), en(r, 0.84, 0.5), const Color(0xFFFFE082), ancho: 2.5 * s);
  textoEn(c, 'Σ > umbral', n + Offset(0, 22 * s), tam: 9 * s, color: Colors.white);
}

// Tema 4 ----------------------------------------------------------------------

/// La IA en aparatos y servicios de todos los días.
final ilAplicaciones = escena(const [
  ObjEscena('celular', '📱', 0.5, 0.5, tam: 0.2, anim: Anim.latir),
  ObjEscena('asistente', '🗣️', 0.18, 0.14, tam: 0.13),
  ObjEscena('mapa', '🗺️', 0.82, 0.14, tam: 0.13),
  ObjEscena('traductor', '🌐', 0.14, 0.5, tam: 0.13),
  ObjEscena('recomendador', '🎬', 0.86, 0.5, tam: 0.13),
  ObjEscena('camara', '📸', 0.18, 0.86, tam: 0.13),
  ObjEscena('coche', '🚗', 0.82, 0.86, tam: 0.13),
], fondo: const [
  Color(0xFFE0F7FA),
  Color(0xFFB2EBF2)
], antes: _ondas);

void _ondas(Canvas c, Rect r, double t, double s) {
  final cen = en(r, 0.5, 0.5);
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.4 + k / 3) % 1;
    c.drawCircle(cen, (30 + f * 90) * s, linea(Color.fromARGB((120 * (1 - f)).round(), 0, 131, 143), 2 * s));
  }
}

/// Cómo funciona un asistente de voz.
final ilAsistente = escena(const [
  ObjEscena('microfono', '🎙️', 0.2, 0.14, tam: 0.13),
  ObjEscena('texto', '📝', 0.8, 0.14, tam: 0.13),
  ObjEscena('entender', '🧠', 0.8, 0.62, tam: 0.13, anim: Anim.latir),
  ObjEscena('responder', '🔊', 0.2, 0.62, tam: 0.13),
  ObjEscena('bocina', '📻', 0.5, 0.88, tam: 0.14, anim: Anim.nada),
], fondo: const [
  Color(0xFFE0F2F1),
  Color(0xFFB2DFDB)
], antes: _cicloAsistente);

void _cicloAsistente(Canvas c, Rect r, double t, double s) {
  final pts = [en(r, 0.2, 0.2), en(r, 0.8, 0.2), en(r, 0.8, 0.56), en(r, 0.2, 0.56)];
  for (var k = 0; k < 3; k++) {
    flechaEn(c, pts[k], pts[k + 1], const Color(0xFF00897B), ancho: 2.5 * s);
  }
  final f = (t * 0.3) % 1;
  final k = (f * 3).floor();
  c.drawCircle(Offset.lerp(pts[k], pts[k + 1], f * 3 - k)!, 5 * s, relleno(const Color(0xFFFF4081)));
}

// Tema 5 ----------------------------------------------------------------------

/// Riesgos y límites de la IA, y la persona que decide.
final ilRiesgos = escena(const [
  ObjEscena('persona', '🧑', 0.5, 0.5, tam: 0.2, anim: Anim.nada),
  ObjEscena('sesgo', '⚖️', 0.2, 0.14, tam: 0.13, anim: Anim.temblar),
  ObjEscena('privacidad', '🔒', 0.8, 0.14, tam: 0.13),
  ObjEscena('falsas', '🎭', 0.16, 0.86, tam: 0.13),
  ObjEscena('errores', '❌', 0.84, 0.86, tam: 0.13),
], fondo: const [
  Color(0xFFE3F2FD),
  Color(0xFFBBDEFB)
], antes: _escudoPersona);

void _escudoPersona(Canvas c, Rect r, double t, double s) {
  final cen = en(r, 0.5, 0.5);
  c.drawCircle(cen, (48 + 3 * math.sin(t * 2)) * s, relleno(const Color(0x331565C0)));
  c.drawCircle(cen, (48 + 3 * math.sin(t * 2)) * s, linea(const Color(0xFF1565C0), 2.5 * s));
}
