import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tema1/componentes.dart' show EtiquetaExplicacion;
import '../tema1/comunes.dart';
import 'motor.dart';

/// Ilustraciones animadas de los temas 2 a 5. Cada una tiene un mapa de
/// puntos (fracciones del rectángulo) para que las etiquetas señalen bien.

typedef Dibujo = void Function(Canvas c, Rect r, double t, String? resaltar);

class Ilustracion {
  const Ilustracion(this.dibujar, this.puntos);
  final Dibujo dibujar;
  final Map<String, Offset> puntos;
  Offset punto(Rect r, String id) {
    final f = puntos[id]!;
    return Offset(r.left + f.dx * r.width, r.top + f.dy * r.height);
  }
}

class PintorIlustracion extends CustomPainter {
  PintorIlustracion(this.ilustracion, this.r, this.t, {this.resaltar});
  final Ilustracion ilustracion;
  final Rect r;
  final double t;
  final String? resaltar;
  @override
  void paint(Canvas c, Size s) {
    if (resaltar != null && ilustracion.puntos.containsKey(resaltar)) {
      c.drawCircle(ilustracion.punto(r, resaltar!), r.shortestSide * 0.13 * (1 + 0.08 * math.sin(t * 5)), Paint()..color = const Color(0x66FFEB3B));
    }
    ilustracion.dibujar(c, r, t, resaltar);
  }

  @override
  bool shouldRepaint(PintorIlustracion old) => true;
}

/// Definición corta de una etiqueta para [etiquetasPara].
class Parte {
  const Parte(this.id, this.titulo, this.subtitulo, this.emoji, this.color, this.detalle);
  final String id, titulo, subtitulo, emoji, detalle;
  final Color color;
}

/// Coloca etiquetas en dos columnas a los lados de la ilustración.
List<EtiquetaExplicacion> etiquetasPara(Ilustracion il, Rect r, List<Parte> izquierda, List<Parte> derecha, {double xDerecha = 660}) {
  List<EtiquetaExplicacion> columna(List<Parte> partes, double x) {
    final n = partes.length;
    final paso = n <= 1 ? 0.0 : math.min(92.0, 300 / (n - 1));
    final y0 = 66 + (330 - paso * (n - 1)) / 2 - 20;
    return [
      for (var i = 0; i < n; i++)
        EtiquetaExplicacion(
          id: partes[i].id,
          titulo: partes[i].titulo,
          subtitulo: partes[i].subtitulo,
          color: partes[i].color,
          icono: Emoji(partes[i].emoji, tam: 24),
          pos: Offset(x, y0 + i * paso),
          punto: il.punto(r, partes[i].id),
          detalle: partes[i].detalle,
          ancho: 142,
        ),
    ];
  }

  return [...columna(izquierda, 244), ...columna(derecha, xDerecha)];
}

Offset _p(Rect r, double x, double y) => Offset(r.left + x * r.width, r.top + y * r.height);

Path _blob(Offset c, double rx, double ry, double t, {int lobulos = 5, double amp = 0.06}) {
  final p = Path();
  for (var i = 0; i <= 60; i++) {
    final a = i / 60 * 2 * math.pi;
    final k = 1 + amp * math.sin(a * lobulos + t * 1.5) + amp * 0.5 * math.sin(a * 3 - t);
    final q = c + Offset(math.cos(a) * rx * k, math.sin(a) * ry * k);
    i == 0 ? p.moveTo(q.dx, q.dy) : p.lineTo(q.dx, q.dy);
  }
  return p..close();
}

void _mitocondria(Canvas c, Offset p, double w, double ang) {
  c.save();
  c.translate(p.dx, p.dy);
  c.rotate(ang);
  final r = Rect.fromCenter(center: Offset.zero, width: w, height: w * 0.5);
  c.drawOval(r, Paint()..color = const Color(0xFFFF8A65));
  c.drawOval(r, linea(const Color(0xFFD84315), 1.5));
  final z = Path()..moveTo(-w * 0.38, 0);
  for (var i = 0; i < 6; i++) {
    z.lineTo(-w * 0.38 + (i + 0.5) * w * 0.127, (i.isEven ? -1 : 1) * w * 0.15);
  }
  c.drawPath(z, linea(const Color(0xFFBF360C), 1.2));
  c.restore();
}

// ---------------------------------------------------------------------------
// Tema 2: células
// ---------------------------------------------------------------------------

void _celulaAnimal(Canvas c, Rect r, double t, String? sel) {
  final centro = _p(r, 0.5, 0.5);
  final cuerpo = _blob(centro, r.width * 0.44, r.height * 0.42, t);
  c.drawPath(cuerpo, Paint()..color = const Color(0xFFFFD6E2));
  c.drawPath(cuerpo, linea(const Color(0xFFE0608B), sel == 'membrana' ? 7 : 4.5));
  final rnd = math.Random(4);
  for (var i = 0; i < 40; i++) {
    final a = rnd.nextDouble() * 2 * math.pi, d = 0.15 + rnd.nextDouble() * 0.7;
    c.drawCircle(centro + Offset(math.cos(a) * r.width * 0.38 * d, math.sin(a) * r.height * 0.36 * d), 1.8, Paint()..color = const Color(0xFF8E7CC3));
  }
  for (final (x, y, a) in const [(0.75, 0.65, 0.5), (0.3, 0.3, -0.4), (0.25, 0.7, 1.2), (0.7, 0.3, 0.2)]) {
    _mitocondria(c, _p(r, x, y), r.width * 0.15, a + math.sin(t + x * 9) * 0.1);
  }
  for (final (x, y, s) in const [(0.62, 0.78, 0.05), (0.4, 0.68, 0.035)]) {
    c.drawCircle(_p(r, x, y), r.width * s, Paint()..color = const Color(0xFFB3E5FC));
  }
  final nuc = _p(r, 0.52, 0.45);
  c.drawCircle(nuc, r.width * 0.13 * (1 + 0.02 * math.sin(t * 2)), Paint()..color = const Color(0xFF9575CD));
  c.drawCircle(nuc, r.width * 0.13, linea(const Color(0xFF5E35B1), 2.5));
  c.drawCircle(nuc + Offset(r.width * 0.03, -r.width * 0.02), r.width * 0.045, Paint()..color = const Color(0xFF4527A0));
}

const ilCelulaAnimal = Ilustracion(_celulaAnimal, {
  'membrana': Offset(0.08, 0.45),
  'citoplasma': Offset(0.42, 0.82),
  'nucleo': Offset(0.52, 0.45),
  'mitocondria': Offset(0.75, 0.65),
  'vacuola': Offset(0.62, 0.78),
});

void _celulaVegetal(Canvas c, Rect r, double t, String? sel) {
  final caja = Rect.fromLTWH(r.left + r.width * 0.06, r.top + r.height * 0.1, r.width * 0.88, r.height * 0.8);
  final pared = RRect.fromRectAndRadius(caja, Radius.circular(r.width * 0.06));
  c.drawRRect(pared, Paint()..color = const Color(0xFF8BC34A));
  final interior = pared.deflate(r.width * 0.035);
  c.drawRRect(interior, Paint()..color = const Color(0xFFE8F5C8));
  c.drawRRect(interior, linea(const Color(0xFF558B2F), sel == 'membrana' ? 4 : 2));
  if (sel == 'pared') c.drawRRect(pared, linea(const Color(0xFFFFEB3B), 5));
  final vac = RRect.fromRectAndRadius(
      Rect.fromLTWH(r.left + r.width * 0.25, r.top + r.height * 0.25, r.width * 0.46 * (1 + 0.02 * math.sin(t)), r.height * 0.5), Radius.circular(r.width * 0.12));
  c.drawRRect(vac, Paint()..color = const Color(0xFFB3E5FC));
  c.drawRRect(vac, linea(const Color(0xFF4FC3F7), 2));
  final nuc = _p(r, 0.8, 0.25);
  c.drawCircle(nuc, r.width * 0.08, Paint()..color = const Color(0xFF9575CD));
  c.drawCircle(nuc, r.width * 0.08, linea(const Color(0xFF5E35B1), 2));
  c.drawCircle(nuc, r.width * 0.03, Paint()..color = const Color(0xFF4527A0));
  final cloro = [(0.18, 0.2), (0.14, 0.45), (0.17, 0.7), (0.4, 0.84), (0.62, 0.84), (0.84, 0.6), (0.84, 0.8), (0.45, 0.17)];
  for (var i = 0; i < cloro.length; i++) {
    final p = _p(r, cloro[i].$1, cloro[i].$2) + Offset(math.sin(t * 0.8 + i) * 2, 0);
    c.save();
    c.translate(p.dx, p.dy);
    c.rotate(i * 0.7);
    final o = Rect.fromCenter(center: Offset.zero, width: r.width * 0.1, height: r.width * 0.055);
    c.drawOval(o, Paint()..color = const Color(0xFF2E7D32));
    for (var k = -1; k <= 1; k++) {
      c.drawLine(Offset(k * r.width * 0.025, -r.width * 0.015), Offset(k * r.width * 0.025, r.width * 0.015), linea(const Color(0xFF81C784), 1.5));
    }
    c.restore();
  }
}

const ilCelulaVegetal = Ilustracion(_celulaVegetal, {
  'pared': Offset(0.06, 0.3),
  'membrana': Offset(0.1, 0.86),
  'citoplasma': Offset(0.86, 0.45),
  'vacuola': Offset(0.48, 0.5),
  'nucleo': Offset(0.8, 0.25),
  'cloroplasto': Offset(0.14, 0.45),
});

void _uniPluri(Canvas c, Rect r, double t, String? sel) {
  // Gota de agua con seres unicelulares
  final gota = _p(r, 0.25, 0.42);
  final rg = r.width * 0.22;
  c.drawCircle(gota, rg, Paint()..color = const Color(0xFFE1F5FE));
  c.drawCircle(gota, rg, linea(const Color(0xFF4FC3F7), 3));
  final ameba = _blob(gota + Offset(-rg * 0.3, -rg * 0.2), rg * 0.32, rg * 0.26, t * 1.5, lobulos: 4, amp: 0.18);
  c.drawPath(ameba, Paint()..color = const Color(0xFFCE93D8));
  c.drawCircle(gota + Offset(-rg * 0.3, -rg * 0.2), rg * 0.09, Paint()..color = const Color(0xFF7B1FA2));
  c.save();
  c.translate(gota.dx + rg * 0.35 + math.sin(t) * 4, gota.dy + rg * 0.35);
  c.rotate(0.4);
  c.drawOval(Rect.fromCenter(center: Offset.zero, width: rg * 0.6, height: rg * 0.26), Paint()..color = const Color(0xFFA5D6A7));
  for (var i = 0; i < 12; i++) {
    final a = i / 12 * 2 * math.pi;
    c.drawLine(Offset(math.cos(a) * rg * 0.3, math.sin(a) * rg * 0.13), Offset(math.cos(a) * rg * 0.36, math.sin(a) * rg * 0.18 + math.sin(t * 9 + i) * 2),
        linea(const Color(0xFF43A047), 1));
  }
  c.restore();
  for (var i = 0; i < 4; i++) {
    c.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: gota + Offset(-rg * 0.35 + i * 12, rg * 0.55), width: 9, height: 5), const Radius.circular(3)),
        Paint()..color = const Color(0xFF8D6E63));
  }
  textoEn(c, 'Una gota de agua', gota + Offset(0, -rg - 12), tam: 12, color: const Color(0xFF0277BD), fondo: Colors.white);
  // Organismos pluricelulares
  dibujarEmoji(c, '🌳', _p(r, 0.64, 0.33), r.width * 0.2);
  dibujarEmoji(c, '🧒', _p(r, 0.86, 0.36), r.width * 0.17);
  // Lupa con tejido
  final lupa = _p(r, 0.76, 0.78);
  final rl = r.width * 0.15;
  c.drawLine(_p(r, 0.86, 0.48), lupa, linea(const Color(0xFF7E57C2), 2));
  c.save();
  c.clipPath(Path()..addOval(Rect.fromCircle(center: lupa, radius: rl)));
  c.drawCircle(lupa, rl, Paint()..color = const Color(0xFFFFE0E9));
  for (var y = -2; y <= 2; y++) {
    for (var x = -2; x <= 2; x++) {
      final q = lupa + Offset(x * rl * 0.42 + (y.isOdd ? rl * 0.21 : 0), y * rl * 0.38);
      c.drawCircle(q, rl * 0.18, Paint()..color = const Color(0xFFF8BBD0));
      c.drawCircle(q, rl * 0.18, linea(const Color(0xFFE0608B), 1));
      c.drawCircle(q, rl * 0.06, Paint()..color = const Color(0xFF8E24AA));
    }
  }
  c.restore();
  c.drawCircle(lupa, rl, linea(const Color(0xFF7E57C2), 4));
}

const ilUniPluri = Ilustracion(_uniPluri, {
  'unicelular': Offset(0.18, 0.35),
  'bacteria': Offset(0.2, 0.62),
  'pluricelular': Offset(0.64, 0.33),
  'tejido': Offset(0.76, 0.78),
});

// ---------------------------------------------------------------------------
// Tema 3: alimentación
// ---------------------------------------------------------------------------

const _nutrientes = [
  ('carbohidratos', '🍞', Color(0xFFFFB74D), 0.5, 0.12),
  ('proteinas', '🥚', Color(0xFFE57373), 0.88, 0.38),
  ('grasas', '🥑', Color(0xFF9CCC65), 0.76, 0.86),
  ('vitaminas', '🍎', Color(0xFFBA68C8), 0.24, 0.86),
  ('agua', '💧', Color(0xFF4FC3F7), 0.12, 0.38),
];

void _nutrientesDibujo(Canvas c, Rect r, double t, String? sel) {
  final centro = _p(r, 0.5, 0.5);
  for (var i = 0; i < _nutrientes.length; i++) {
    final (_, e, col, x, y) = _nutrientes[i];
    final q = _p(r, x, y);
    c.drawLine(centro, q, linea(col.withValues(alpha: 0.6), 4));
    final u = (t * 0.4 + i / 5) % 1;
    c.drawCircle(Offset.lerp(q, centro, u)!, 4, Paint()..color = col);
    final rr = r.width * 0.12 * (1 + 0.04 * math.sin(t * 2 + i));
    c.drawCircle(q, rr, Paint()..color = Colors.white);
    c.drawCircle(q, rr, linea(col, 4));
    dibujarEmoji(c, e, q, rr * 1.1);
  }
  c.drawCircle(centro, r.width * 0.16, Paint()..color = Colors.white);
  c.drawCircle(centro, r.width * 0.16, linea(const Color(0xFFFF8A00), 4));
  dibujarEmoji(c, '🧒', centro, r.width * 0.2);
}

const ilNutrientes = Ilustracion(_nutrientesDibujo, {
  'carbohidratos': Offset(0.5, 0.12),
  'proteinas': Offset(0.88, 0.38),
  'grasas': Offset(0.76, 0.86),
  'vitaminas': Offset(0.24, 0.86),
  'agua': Offset(0.12, 0.38),
});

/// Plato del Bien Comer: (id, nombre, color, ángulo inicial, ángulo, emojis).
const sectoresPlato = [
  ('verduras', 'Verduras y frutas', Color(0xFF66BB6A), -math.pi / 2 - 0.15, math.pi * 0.95, ['🥦', '🥕', '🍎', '🍌', '🥬']),
  ('cereales', 'Cereales', Color(0xFFFFB74D), -math.pi / 2 + math.pi * 0.8, math.pi * 0.62, ['🌽', '🍞', '🍚', '🥔']),
  ('leguminosas', 'Leguminosas', Color(0xFFFFE082), math.pi * 0.92, math.pi * 0.25, ['🫘', '🥜']),
  ('origen_animal', 'Origen animal', Color(0xFFEF5350), math.pi * 1.17, math.pi * 0.18, ['🥚', '🐟', '🥛']),
];

void _plato(Canvas c, Rect r, double t, String? sel) {
  final centro = _p(r, 0.5, 0.5);
  final radio = r.shortestSide * 0.46;
  c.drawCircle(centro + const Offset(0, 5), radio + 8, Paint()..color = const Color(0x33000000));
  c.drawCircle(centro, radio + 8, Paint()..color = Colors.white);
  for (final (id, _, col, ini, ang, emojis) in sectoresPlato) {
    final rect = Rect.fromCircle(center: centro, radius: radio);
    c.drawArc(rect, ini, ang, true, Paint()..color = sel == id ? aclarar(col, 0.25) : col);
    c.drawArc(rect, ini, ang, true, linea(Colors.white, 4));
    for (var k = 0; k < emojis.length; k++) {
      final a = ini + ang * (k + 0.5) / emojis.length;
      final d = radio * (k.isEven ? 0.62 : 0.4);
      dibujarEmoji(c, emojis[k], centro + Offset(math.cos(a) * d, math.sin(a) * d), radio * 0.2 * (1 + 0.04 * math.sin(t * 2 + k)));
    }
  }
}

// Puntos en el centro de cada sector (verduras a la derecha, cereales abajo,
// leguminosas a la izquierda y origen animal arriba a la izquierda).
const ilPlato = Ilustracion(_plato, {
  'verduras': Offset(0.77, 0.46),
  'cereales': Offset(0.41, 0.68),
  'leguminosas': Offset(0.23, 0.47),
  'origen_animal': Offset(0.31, 0.36),
});

// ---------------------------------------------------------------------------
// Tema 4: seres vivos y plantas
// ---------------------------------------------------------------------------

void _cielo(Canvas c, Rect r, {double suelo = 0.68}) {
  final cielo = Rect.fromLTRB(r.left, r.top, r.right, r.top + r.height * suelo);
  c.drawRRect(RRect.fromRectAndCorners(cielo, topLeft: const Radius.circular(20), topRight: const Radius.circular(20)),
      Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF81D4FA), Color(0xFFE1F5FE)]).createShader(cielo));
  final tierra = Rect.fromLTRB(r.left, cielo.bottom, r.right, r.bottom);
  c.drawRRect(RRect.fromRectAndCorners(tierra, bottomLeft: const Radius.circular(20), bottomRight: const Radius.circular(20)),
      Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9CCC65), Color(0xFF8D6E63)]).createShader(tierra));
}

void _seresVivos(Canvas c, Rect r, double t, String? sel) {
  _cielo(c, r);
  final sol = _p(r, 0.85, 0.15);
  for (var i = 0; i < 10; i++) {
    final a = i / 10 * 2 * math.pi + t * 0.3;
    c.drawLine(sol + Offset(math.cos(a), math.sin(a)) * r.width * 0.08, sol + Offset(math.cos(a), math.sin(a)) * r.width * 0.12, linea(const Color(0xFFFFC107), 3));
  }
  c.drawCircle(sol, r.width * 0.07, Paint()..color = const Color(0xFFFFD54F));
  dibujarEmoji(c, '☁️', _p(r, 0.3 + math.sin(t * 0.3) * 0.03, 0.12), r.width * 0.13);
  c.drawOval(Rect.fromCenter(center: _p(r, 0.62, 0.86), width: r.width * 0.3, height: r.height * 0.08), Paint()..color = const Color(0xFF4FC3F7));
  dibujarEmoji(c, '🌳', _p(r, 0.2, 0.5), r.width * 0.28);
  dibujarEmoji(c, '🌻', _p(r, 0.42, 0.62 + math.sin(t * 2) * 0.005), r.width * 0.12);
  dibujarEmoji(c, '🐇', _p(r, 0.56 + math.sin(t * 1.3) * 0.02, 0.72), r.width * 0.13);
  dibujarEmoji(c, '🐦', _p(r, 0.6 + math.sin(t * 0.8) * 0.06, 0.3 + math.cos(t * 1.6) * 0.03), r.width * 0.1);
  dibujarEmoji(c, '🍄', _p(r, 0.32, 0.8), r.width * 0.09);
  dibujarEmoji(c, '🪨', _p(r, 0.84, 0.8), r.width * 0.13);
}

const ilSeresVivos = Ilustracion(_seresVivos, {
  'planta': Offset(0.2, 0.5),
  'animal': Offset(0.56, 0.72),
  'ave': Offset(0.6, 0.3),
  'hongo': Offset(0.32, 0.8),
  'roca': Offset(0.84, 0.8),
  'sol': Offset(0.85, 0.15),
  'agua': Offset(0.62, 0.86),
});

/// Dibuja una planta. [crecimiento] 0–1, [salud] 0–1 (1 = verde y erguida).
void dibujarPlanta(Canvas c, Rect r, double t, {double crecimiento = 1, double salud = 1, bool flor = true, bool fruto = true, bool raices = true, String? sel}) {
  final base = _p(r, 0.5, 0.72);
  final alto = r.height * 0.55 * crecimiento;
  final caida = (1 - salud) * 0.6;
  final verde = Color.lerp(const Color(0xFF9E9D24), const Color(0xFF43A047), salud)!;
  // Raíces
  if (raices) {
    final pr = linea(const Color(0xFFD7CCC8), 3);
    for (final (dx, dy) in const [(-0.18, 0.22), (-0.06, 0.26), (0.08, 0.25), (0.2, 0.2), (0.0, 0.18)]) {
      final q = Path()
        ..moveTo(base.dx, base.dy)
        ..quadraticBezierTo(base.dx + dx * r.width * 0.5, base.dy + dy * r.height * 0.4, base.dx + dx * r.width, base.dy + dy * r.height);
      c.drawPath(q, pr);
    }
  }
  if (crecimiento <= 0.02) {
    c.drawOval(Rect.fromCenter(center: base, width: r.width * 0.06, height: r.width * 0.04), Paint()..color = const Color(0xFF8D6E63));
    return;
  }
  // Tallo
  final punta = base + Offset(math.sin(caida + math.sin(t) * 0.03) * alto * 0.5, -alto * math.cos(caida));
  final tallo = Path()
    ..moveTo(base.dx, base.dy)
    ..quadraticBezierTo(base.dx, base.dy - alto * 0.5, punta.dx, punta.dy);
  c.drawPath(tallo, linea(Color.lerp(const Color(0xFF827717), const Color(0xFF388E3C), salud)!, sel == 'tallo' ? 9 : 6));
  // Hojas
  final hojas = crecimiento > 0.3 ? 4 : 2;
  for (var i = 0; i < hojas; i++) {
    final u = 0.35 + i * 0.16;
    final q = Offset.lerp(base, punta, u)!;
    final lado = i.isEven ? 1.0 : -1.0;
    c.save();
    c.translate(q.dx, q.dy);
    c.rotate(lado * (0.9 + caida) + math.sin(t * 1.5 + i) * 0.05);
    final h = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(r.width * 0.07, -r.width * 0.05, r.width * 0.16 * crecimiento.clamp(0.5, 1), 0)
      ..quadraticBezierTo(r.width * 0.07, r.width * 0.05, 0, 0);
    c.scale(lado, 1);
    c.drawPath(h, Paint()..color = verde);
    c.drawLine(Offset.zero, Offset(r.width * 0.14 * crecimiento.clamp(0.5, 1), 0), linea(oscurecer(verde, 0.3), 1.2));
    c.restore();
  }
  if (flor && crecimiento > 0.75) {
    for (var k = 0; k < 6; k++) {
      final a = k / 6 * 2 * math.pi + t * 0.2;
      c.drawCircle(punta + Offset(math.cos(a), math.sin(a)) * r.width * 0.045, r.width * 0.035, Paint()..color = Color.lerp(const Color(0xFFBDBDBD), const Color(0xFFFF80AB), salud)!);
    }
    c.drawCircle(punta, r.width * 0.03, Paint()..color = const Color(0xFFFFD54F));
  }
  if (fruto && crecimiento > 0.9) {
    final f = Offset.lerp(base, punta, 0.62)! + Offset(r.width * 0.12, r.height * 0.02);
    c.drawLine(Offset.lerp(base, punta, 0.6)!, f, linea(const Color(0xFF388E3C), 2));
    c.drawCircle(f, r.width * 0.055, Paint()..color = const Color(0xFFE53935));
    c.drawCircle(f + Offset(-r.width * 0.015, -r.width * 0.015), r.width * 0.012, Paint()..color = Colors.white);
    for (var k = 0; k < 3; k++) {
      c.drawOval(Rect.fromCenter(center: f + Offset((k - 1) * r.width * 0.02, r.width * 0.015), width: 4, height: 6), Paint()..color = const Color(0xFFFFF59D));
    }
  }
}

void _planta(Canvas c, Rect r, double t, String? sel) {
  _cielo(c, r, suelo: 0.72);
  final sol = _p(r, 0.15, 0.12);
  c.drawCircle(sol, r.width * 0.07, Paint()..color = const Color(0xFFFFD54F));
  for (var i = 0; i < 3; i++) {
    final u = (t * 0.4 + i / 3) % 1;
    c.drawCircle(Offset.lerp(sol, _p(r, 0.42, 0.36), u)!, 3, Paint()..color = const Color(0xFFFFC107));
  }
  dibujarPlanta(c, r, t, sel: sel);
}

const ilPlanta = Ilustracion(_planta, {
  'raiz': Offset(0.42, 0.86),
  'tallo': Offset(0.5, 0.55),
  'hoja': Offset(0.38, 0.44),
  'flor': Offset(0.52, 0.18),
  'fruto': Offset(0.64, 0.38),
  'sol': Offset(0.15, 0.12),
});

// ---------------------------------------------------------------------------
// Tema 5: ecosistemas
// ---------------------------------------------------------------------------

void _ecosistema(Canvas c, Rect r, double t, String? sel) {
  _cielo(c, r, suelo: 0.62);
  final m = Path()
    ..moveTo(r.left, r.top + r.height * 0.62)
    ..lineTo(r.left + r.width * 0.25, r.top + r.height * 0.32)
    ..lineTo(r.left + r.width * 0.45, r.top + r.height * 0.62)
    ..lineTo(r.left + r.width * 0.65, r.top + r.height * 0.38)
    ..lineTo(r.right, r.top + r.height * 0.62)
    ..close();
  c.drawPath(m, Paint()..color = const Color(0xFFA5D6A7));
  final sol = _p(r, 0.86, 0.12);
  c.drawCircle(sol, r.width * 0.065, Paint()..color = const Color(0xFFFFD54F));
  for (var i = 0; i < 3; i++) {
    final y = r.top + r.height * (0.18 + i * 0.06);
    final x0 = r.left + r.width * (0.2 + ((t * 0.05 + i * 0.3) % 0.5));
    c.drawLine(Offset(x0, y), Offset(x0 + r.width * 0.12, y), linea(Colors.white.withValues(alpha: 0.8), 2.5));
  }
  final lago = Rect.fromCenter(center: _p(r, 0.68, 0.8), width: r.width * 0.42, height: r.height * 0.16);
  c.drawOval(lago, Paint()..color = const Color(0xFF4FC3F7));
  dibujarEmoji(c, '🐟', _p(r, 0.62 + math.sin(t) * 0.05, 0.81), r.width * 0.07);
  dibujarEmoji(c, '🌲', _p(r, 0.12, 0.52), r.width * 0.16);
  dibujarEmoji(c, '🌳', _p(r, 0.3, 0.55), r.width * 0.18);
  dibujarEmoji(c, '🌿', _p(r, 0.44, 0.7), r.width * 0.09);
  dibujarEmoji(c, '🦌', _p(r, 0.24 + math.sin(t * 0.5) * 0.02, 0.75), r.width * 0.13);
  dibujarEmoji(c, '🦊', _p(r, 0.45, 0.86), r.width * 0.1);
  dibujarEmoji(c, '🦅', _p(r, 0.5 + math.sin(t * 0.7) * 0.1, 0.2), r.width * 0.09);
  dibujarEmoji(c, '🍄', _p(r, 0.08, 0.86), r.width * 0.08);
  dibujarEmoji(c, '🪨', _p(r, 0.92, 0.66), r.width * 0.08);
}

const ilEcosistema = Ilustracion(_ecosistema, {
  'sol': Offset(0.86, 0.12),
  'aire': Offset(0.32, 0.2),
  'agua': Offset(0.75, 0.8),
  'suelo': Offset(0.6, 0.95),
  'plantas': Offset(0.3, 0.55),
  'animales': Offset(0.24, 0.75),
  'hongos': Offset(0.08, 0.86),
  'roca': Offset(0.92, 0.66),
});

const eslabones = [
  ('sol', '☀️', 'Sol'),
  ('productor', '🌿', 'Pasto'),
  ('consumidor1', '🦗', 'Chapulín'),
  ('consumidor2', '🐸', 'Rana'),
  ('consumidor3', '🐍', 'Serpiente'),
  ('consumidor4', '🦅', 'Águila'),
];

void _cadena(Canvas c, Rect r, double t, String? sel) {
  final rr = RRect.fromRectAndRadius(r, const Radius.circular(22));
  c.drawRRect(rr, Paint()..color = Colors.white.withValues(alpha: 0.85));
  final pts = [for (var i = 0; i < eslabones.length; i++) _p(r, 0.5 + (i.isEven ? -0.22 : 0.22), 0.1 + i * 0.13)];
  for (var i = 0; i < pts.length - 1; i++) {
    c.drawLine(pts[i], pts[i + 1], linea(const Color(0xFF8BC34A), 4));
    final u = (t * 0.5 + i * 0.15) % 1;
    c.drawCircle(Offset.lerp(pts[i], pts[i + 1], u)!, 4.5, Paint()..color = const Color(0xFFFFB300));
  }
  final hongo = _p(r, 0.5, 0.92);
  for (var i = 1; i < pts.length; i++) {
    final path = Path()
      ..moveTo(pts[i].dx, pts[i].dy)
      ..lineTo(hongo.dx, hongo.dy);
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 10) {
        c.drawPath(m.extractPath(d, d + 5), linea(const Color(0xFFA1887F), 1.5));
      }
    }
  }
  for (var i = 0; i < pts.length; i++) {
    final rad = r.width * 0.085 * (1 + 0.04 * math.sin(t * 2 + i));
    c.drawCircle(pts[i], rad, Paint()..color = Colors.white);
    c.drawCircle(pts[i], rad, linea(sel == eslabones[i].$1 ? const Color(0xFFFFB300) : const Color(0xFF66BB6A), 3));
    dibujarEmoji(c, eslabones[i].$2, pts[i], rad * 1.1);
  }
  c.drawCircle(hongo, r.width * 0.07, Paint()..color = Colors.white);
  c.drawCircle(hongo, r.width * 0.07, linea(const Color(0xFF8D6E63), 3));
  dibujarEmoji(c, '🍄', hongo, r.width * 0.08);
}

const ilCadena = Ilustracion(_cadena, {
  'sol': Offset(0.28, 0.1),
  'productor': Offset(0.72, 0.23),
  'consumidor1': Offset(0.28, 0.36),
  'consumidor2': Offset(0.72, 0.49),
  'consumidor3': Offset(0.28, 0.62),
  'consumidor4': Offset(0.72, 0.75),
  'descomponedor': Offset(0.5, 0.92),
});
