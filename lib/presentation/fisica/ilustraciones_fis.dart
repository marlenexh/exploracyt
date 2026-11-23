import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show linea, relleno, textoEn;
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../ciencia/escena.dart';

/// Ilustraciones de Física.

void _iman(Canvas c, Offset centro, double w, double h, {bool vertical = false}) {
  c.save();
  c.translate(centro.dx, centro.dy);
  if (vertical) c.rotate(-math.pi / 2);
  c.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(-w / 2, -h / 2, w / 2, h), topLeft: const Radius.circular(6), bottomLeft: const Radius.circular(6)),
      relleno(const Color(0xFFE53935)));
  c.drawRRect(RRect.fromRectAndCorners(Rect.fromLTWH(0, -h / 2, w / 2, h), topRight: const Radius.circular(6), bottomRight: const Radius.circular(6)),
      relleno(const Color(0xFF1E88E5)));
  textoEn(c, 'N', Offset(-w / 4, 0), tam: h * 0.5, color: Colors.white);
  textoEn(c, 'S', Offset(w / 4, 0), tam: h * 0.5, color: Colors.white);
  c.restore();
}

// Tema 1 ----------------------------------------------------------------------

final ilImanes = escena(const [
  ObjEscena('clip', '📎', 0.2, 0.8, tam: 0.11, anim: Anim.temblar, etiqueta: 'atrae'),
  ObjEscena('clavo', '🔩', 0.8, 0.8, tam: 0.11, anim: Anim.temblar, etiqueta: 'atrae'),
], antes: (c, r, t, s) {
  final cen = en(r, 0.5, 0.3);
  for (var k = 1; k <= 4; k++) {
    for (final lado in [-1.0, 1.0]) {
      c.drawOval(Rect.fromCenter(center: cen + Offset(0, lado * k * 9 * s), width: (110 + k * 34) * s, height: k * 18 * s),
          linea(Color.fromARGB(90 - k * 15, 126, 87, 194), 1.6));
    }
  }
  _iman(c, cen, 120 * s, 36 * s);
  // Atracción y repulsión
  final ya = en(r, 0.5, 0.58).dy;
  _iman(c, Offset(r.left + 70 * s, ya), 80 * s, 24 * s);
  final sep = 4 * s + (math.sin(t * 3) * 0.5 + 0.5) * 4 * s;
  c.save();
  c.translate(r.left + 152 * s + sep, ya);
  c.rotate(math.pi);
  _iman(c, Offset.zero, 80 * s, 24 * s);
  c.restore();
  textoEn(c, 'N S — N S: se atraen', en(r, 0.5, 0.67), tam: 10 * s, color: const Color(0xFF2E7D32));
}, despues: (c, r, t, s) {
  textoEn(c, 'polo norte', en(r, 0.3, 0.18), tam: 10 * s, color: const Color(0xFFC62828));
  textoEn(c, 'polo sur', en(r, 0.7, 0.18), tam: 10 * s, color: const Color(0xFF1565C0));
});

final ilTierraIman = escena(const [
  ObjEscena('tierra', '🌍', 0.5, 0.45, tam: 0.4, anim: Anim.nada),
  ObjEscena('brujula', '🧭', 0.18, 0.84, tam: 0.14),
  ObjEscena('aurora', '🌌', 0.5, 0.07, tam: 0.14),
  ObjEscena('ave', '🐦', 0.85, 0.82, tam: 0.12),
], fondo: const [
  Color(0xFF1A237E),
  Color(0xFF283593)
], antes: (c, r, t, s) {
  final cen = en(r, 0.5, 0.45);
  for (var k = 1; k <= 4; k++) {
    for (final lado in [-1.0, 1.0]) {
      c.drawOval(
          Rect.fromCenter(center: cen + Offset(lado * k * 14 * s, 0), width: k * 28 * s, height: (130 + k * 24) * s), linea(const Color(0x4480DEEA), 1.4));
    }
  }
}, despues: (c, r, t, s) {
  textoEn(c, 'Norte', en(r, 0.5, 0.17), tam: 11 * s, color: Colors.white, fondo: const Color(0xAAE53935));
  textoEn(c, 'Sur', en(r, 0.5, 0.74), tam: 11 * s, color: Colors.white, fondo: const Color(0xAA1E88E5));
});

// Tema 2 ----------------------------------------------------------------------

final ilGravedad = escena(const [
  ObjEscena('tierra', '🌍', 0.5, 0.55, tam: 0.38, anim: Anim.nada),
  ObjEscena('manzana', '🍎', 0.5, 0.12, tam: 0.1, anim: Anim.caer),
  ObjEscena('nino', '🧒', 0.15, 0.55, tam: 0.11),
  ObjEscena('luna', '🌕', 0.85, 0.15, tam: 0.12),
  ObjEscena('balanza', '⚖️', 0.82, 0.88, tam: 0.12),
], fondo: const [
  Color(0xFF0D1B3E),
  Color(0xFF1A2A5A)
], antes: (c, r, t, s) {
  final cen = en(r, 0.5, 0.55);
  for (var k = 0; k < 8; k++) {
    final a = k * math.pi / 4;
    flechaEn(c, cen + Offset(math.cos(a), math.sin(a)) * 105 * s, cen + Offset(math.cos(a), math.sin(a)) * 72 * s, const Color(0xAAFFD54F), ancho: 2);
  }
  c.drawCircle(cen, 120 * s, linea(const Color(0x33FFFFFF), 1));
});

final ilCaida = escena(const [
  ObjEscena('torre', '🗼', 0.22, 0.45, tam: 0.3, anim: Anim.nada),
  ObjEscena('piedra', '🪨', 0.55, 0.3, tam: 0.1, anim: Anim.caer),
  ObjEscena('pluma', '🪶', 0.78, 0.3, tam: 0.1),
  ObjEscena('paracaidas', '🪂', 0.78, 0.7, tam: 0.14),
  ObjEscena('galileo', '👨‍🔬', 0.2, 0.86, tam: 0.12),
], fondo: const [
  Color(0xFFB3E5FC),
  Color(0xFFE1F5FE)
], despues: (c, r, t, s) {
  for (var k = 0; k < 4; k++) {
    final p = en(r, 0.72 + k * 0.04, 0.36 + (t * 0.5 + k * 0.2) % 0.2);
    c.drawLine(p, p - Offset(0, 8 * s), linea(const Color(0x8890A4AE), 1.5));
  }
  textoEn(c, 'el aire frena', en(r, 0.78, 0.42), tam: 9 * s, color: const Color(0xFF455A64));
});

// Tema 3 ----------------------------------------------------------------------

final ilTemperatura = escena(const [
  ObjEscena('termometro', '🌡️', 0.5, 0.42, tam: 0.3, anim: Anim.nada),
  ObjEscena('caliente', '☕', 0.18, 0.22, etiqueta: 'caliente'),
  ObjEscena('frio', '🧊', 0.82, 0.22, etiqueta: 'frío'),
  ObjEscena('cuerpo', '🧒', 0.18, 0.75, etiqueta: '36.5 °C'),
  ObjEscena('hervir', '♨️', 0.82, 0.75, etiqueta: '100 °C'),
], despues: (c, r, t, s) {
  flechaEn(c, en(r, 0.28, 0.3), en(r, 0.72, 0.3), const Color(0xFFFF7043));
  textoEn(c, 'el calor pasa de lo caliente a lo frío', en(r, 0.5, 0.94), tam: 10 * s, color: Colors.white, fondo: const Color(0xFFE64A19));
});

final ilTransferencia = escena(const [
  ObjEscena('conduccion', '🥄', 0.25, 0.2, tam: 0.14, etiqueta: 'conducción'),
  ObjEscena('convencion', '🍲', 0.75, 0.25, tam: 0.18, etiqueta: 'convección'),
  ObjEscena('radiacion', '☀️', 0.25, 0.68, tam: 0.18, anim: Anim.latir, etiqueta: 'radiación'),
  ObjEscena('fogata', '🔥', 0.75, 0.72, tam: 0.16, anim: Anim.latir),
], despues: (c, r, t, s) {
  // Calor que avanza por la cuchara
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.6 + k / 3) % 1;
    c.drawCircle(en(r, 0.17 + f * 0.16, 0.26 - f * 0.08), 3 * s, relleno(Color.fromARGB((255 * (1 - f)).round(), 255, 87, 34)));
  }
  // Corrientes en la olla
  final o = en(r, 0.75, 0.15);
  c.drawArc(Rect.fromCenter(center: o, width: 40 * s, height: 30 * s), t * 2, 4.5, false, linea(const Color(0xFFFF7043), 2));
  // Rayos del Sol
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.5 + k / 3) % 1;
    flechaEn(c, en(r, 0.33 + f * 0.1, 0.62), en(r, 0.37 + f * 0.1, 0.62), const Color(0xFFFFB300), ancho: 2);
  }
});

// Tema 4 ----------------------------------------------------------------------

final ilEnergia = escena(const [
  ObjEscena('central', '🏭', 0.18, 0.18, tam: 0.18, etiqueta: 'central eléctrica'),
  ObjEscena('torre', '🗼', 0.5, 0.28, tam: 0.16, anim: Anim.nada),
  ObjEscena('casa', '🏠', 0.82, 0.45, tam: 0.2, etiqueta: 'tu casa'),
  ObjEscena('foco', '💡', 0.82, 0.74, tam: 0.12, anim: Anim.latir),
  ObjEscena('solar', '☀️', 0.2, 0.65, tam: 0.14, etiqueta: 'solar'),
  ObjEscena('eolica', '🌬️', 0.45, 0.8, tam: 0.14, etiqueta: 'viento'),
], despues: (c, r, t, s) {
  final pts = [en(r, 0.25, 0.2), en(r, 0.5, 0.2), en(r, 0.75, 0.38)];
  for (var i = 0; i < pts.length - 1; i++) {
    c.drawLine(pts[i], pts[i + 1], linea(const Color(0xFF455A64), 2));
    final f = (t * 0.7) % 1;
    c.drawCircle(Offset.lerp(pts[i], pts[i + 1], f)!, 3.5 * s, relleno(const Color(0xFFFFEB3B)));
  }
});

// Tema 5 ----------------------------------------------------------------------

void _orbitas(Canvas c, Rect r, double t, double s) {
  c.drawRect(r, relleno(const Color(0x00000000)));
  final sol = en(r, 0.5, 0.15);
  c.drawCircle(sol, 26 * s,
      Paint()..shader = RadialGradient(colors: const [Color(0xFFFFF59D), Color(0xFFFF8F00)]).createShader(Rect.fromCircle(center: sol, radius: 26 * s)));
  for (var k = 0; k < 8; k++) {
    final y = r.top + (78 + k * 34) * s;
    c.drawLine(Offset(r.left + 20 * s, y), Offset(r.right - 20 * s, y), linea(const Color(0x22FFFFFF), 1));
  }
}

final ilSistemaSolar = escena(const [
  ObjEscena('sol', '☀️', 0.5, 0.12, tam: 0.18, anim: Anim.latir),
  ObjEscena('mercurio', '⚫', 0.3, 0.23, tam: 0.06),
  ObjEscena('venus', '🟡', 0.64, 0.32, tam: 0.07),
  ObjEscena('tierra', '🌍', 0.36, 0.41, tam: 0.08),
  ObjEscena('marte', '🔴', 0.66, 0.5, tam: 0.07),
  ObjEscena('jupiter', '🟠', 0.3, 0.62, tam: 0.14),
  ObjEscena('saturno', '🪐', 0.7, 0.72, tam: 0.14),
  ObjEscena('urano', '🔵', 0.33, 0.84, tam: 0.1),
  ObjEscena('neptuno', '🔷', 0.68, 0.92, tam: 0.1),
], fondo: const [
  Color(0xFF0B0D2A),
  Color(0xFF1A1F4D)
], antes: _orbitas);

final ilMovimientos = escena(const [
  ObjEscena('sol', '☀️', 0.5, 0.5, tam: 0.2, anim: Anim.latir),
  ObjEscena('luna', '🌙', 0.86, 0.2, tam: 0.08),
], fondo: const [
  Color(0xFF0B0D2A),
  Color(0xFF1A1F4D)
], antes: (c, r, t, s) {
  final sol = en(r, 0.5, 0.5);
  c.drawOval(Rect.fromCenter(center: sol, width: 200 * s, height: 300 * s), linea(const Color(0x55FFFFFF), 1.5));
  // La Tierra recorre su órbita (traslación) y gira (rotación)
  final a = t * 0.35;
  final p = sol + Offset(math.cos(a) * 100 * s, math.sin(a) * 150 * s);
  c.save();
  c.translate(p.dx, p.dy);
  c.rotate(t * 2);
  dibujarEmoji(c, '🌍', Offset.zero, 26 * s);
  c.restore();
  final lu = p + Offset(math.cos(t * 2.5), math.sin(t * 2.5)) * 24 * s;
  c.drawCircle(lu, 4 * s, relleno(const Color(0xFFE0E0E0)));
  textoEn(c, 'traslación: 1 año', en(r, 0.5, 0.06), tam: 10 * s, color: Colors.white, fondo: const Color(0x8843A047));
  textoEn(c, 'rotación: 1 día', en(r, 0.5, 0.94), tam: 10 * s, color: Colors.white, fondo: const Color(0x881E88E5));
});

/// Puntos para señalar la Tierra en movimiento (se usan en la explicación).
const puntosMovimiento = {'traslacion': Offset(0.5, 0.06), 'rotacion': Offset(0.5, 0.94)};
