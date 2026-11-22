import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno, textoEn;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/tema1/ui_divertida.dart' show oscurecer;
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Fondos animados del mundo de Programación: "El reino de los algoritmos".

enum FondoPro { castillo, tablero, bloques, bucles, bichos, reino }

EstiloMundo estiloPro(FondoPro f) {
  final (a, b, borde, sombra, texto) = switch (f) {
    FondoPro.castillo => (const Color(0xFFB39DDB), const Color(0xFF5E35B1), const Color(0xFF311B92), const Color(0xFF1A0E52), Colors.white),
    FondoPro.tablero => (const Color(0xFFA5D6A7), const Color(0xFF388E3C), const Color(0xFF1B5E20), const Color(0xFF0B3010), Colors.white),
    FondoPro.bloques => (const Color(0xFFFFE082), const Color(0xFFFFAB19), const Color(0xFFCF8B17), const Color(0xFF7A5108), const Color(0xFF4E342E)),
    FondoPro.bucles => (const Color(0xFF80DEEA), const Color(0xFF00838F), const Color(0xFF004D57), const Color(0xFF002A30), Colors.white),
    FondoPro.bichos => (const Color(0xFF90A4AE), const Color(0xFF37474F), const Color(0xFF1C262B), const Color(0xFF0B1013), const Color(0xFFA5D6A7)),
    FondoPro.reino => (const Color(0xFF81D4FA), const Color(0xFF1A91AC), const Color(0xFF0B5566), const Color(0xFF053341), Colors.white),
  };
  return EstiloMundo(fondo: (_) => FondoProgramacion(f), letrero: [a, b], bordeLetrero: borde, sombraLetrero: sombra, textoLetrero: texto);
}

class FondoProgramacion extends StatelessWidget {
  const FondoProgramacion(this.tipo, {super.key});
  final FondoPro tipo;
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorFondoPro(tipo, t), child: const SizedBox.expand())));
}

class _PintorFondoPro extends CustomPainter {
  _PintorFondoPro(this.tipo, this.t);
  final FondoPro tipo;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    switch (tipo) {
      case FondoPro.castillo:
        _castillo(c, s);
      case FondoPro.tablero:
        _tablero(c, s);
      case FondoPro.bloques:
        _bloques(c, s);
      case FondoPro.bucles:
        _bucles(c, s);
      case FondoPro.bichos:
        _bichos(c, s);
      case FondoPro.reino:
        _castillo(c, s, mapa: true);
    }
  }

  void _degradado(Canvas c, Size s, List<Color> cols) => c.drawRect(
      Offset.zero & s, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: cols).createShader(Offset.zero & s));

  /// Cuadrito de "pixel art".
  void _px(Canvas c, double x, double y, double u, Color col) => c.drawRect(Rect.fromLTWH(x, y, u + 0.5, u + 0.5), relleno(col));

  // Reino pixelado: cielo al atardecer, montañas, castillo y símbolos de código.
  void _castillo(Canvas c, Size s, {bool mapa = false}) {
    _degradado(c, s, mapa ? const [Color(0xFF4FC3F7), Color(0xFFB3E5FC), Color(0xFFFFF59D)] : const [Color(0xFF3B1E6E), Color(0xFF8E3B8E), Color(0xFFFF9E6B)]);
    final u = s.shortestSide / 64;
    final rnd = math.Random(4);
    if (!mapa) {
      for (var k = 0; k < 40; k++) {
        final x = rnd.nextDouble() * s.width, y = rnd.nextDouble() * s.height * 0.45;
        if ((t * 1.5 + k * 0.3) % 2 < 1.6) _px(c, x, y, u * 0.5, Colors.white.withValues(alpha: 0.8));
      }
    }
    // Montañas escalonadas
    for (final (base, alt, col) in [(0.78, 0.3, mapa ? const Color(0xFF81C784) : const Color(0xFF5E3A8C)), (0.86, 0.2, mapa ? const Color(0xFF66BB6A) : const Color(0xFF462A6E))]) {
      for (var x = 0.0; x < s.width; x += u) {
        final h = (math.sin(x / s.width * 7 + base * 10) * 0.5 + 0.5) * alt * s.height;
        final y = (s.height * base - h) ~/ u * u;
        c.drawRect(Rect.fromLTWH(x, y.toDouble(), u + 0.5, s.height - y), relleno(col));
      }
    }
    // Castillo
    final cx = s.width * 0.8, base = s.height * 0.8;
    final muro = mapa ? const Color(0xFFBCAAA4) : const Color(0xFF2A1748);
    c.drawRect(Rect.fromLTWH(cx - 14 * u, base - 14 * u, 28 * u, 14 * u), relleno(muro));
    for (final dx in [-14.0, 8.0]) {
      c.drawRect(Rect.fromLTWH(cx + dx * u, base - 22 * u, 6 * u, 22 * u), relleno(muro));
      for (var k = 0; k < 3; k++) {
        _px(c, cx + (dx + k * 2) * u, base - 24 * u, u, muro);
      }
    }
    c.drawRect(Rect.fromLTWH(cx - 3 * u, base - 30 * u, 6 * u, 30 * u), relleno(muro));
    final ondea = math.sin(t * 4) * u;
    c.drawPath(Path()..moveTo(cx, base - 30 * u)..lineTo(cx, base - 37 * u)..lineTo(cx + 6 * u, base - 35 * u + ondea)..lineTo(cx, base - 33 * u)..close(),
        relleno(const Color(0xFFFFD600)));
    for (var k = 0; k < 4; k++) {
      final on = (t * 0.7 + k * 0.4) % 2 < 1.4;
      _px(c, cx + (-10 + k * 6) * u, base - 9 * u, 2 * u, on ? const Color(0xFFFFEB3B) : oscurecer(muro, 0.2));
    }
    // Símbolos de código flotando
    const simbolos = ['{ }', '< />', ';', '( )', 'if', '01', '=', '[ ]'];
    for (var k = 0; k < simbolos.length; k++) {
      final f = (t * 0.04 + k / simbolos.length) % 1;
      final x = s.width * ((k * 0.37 + 0.05) % 1);
      final y = s.height * (0.9 - f * 0.9);
      textoEn(c, simbolos[k], Offset(x, y), tam: s.shortestSide * 0.045, color: Colors.white.withValues(alpha: 0.18 + 0.4 * math.sin(f * math.pi)), peso: FontWeight.w800);
    }
    c.drawRect(Rect.fromLTWH(0, s.height * 0.9, s.width, s.height * 0.1), relleno(mapa ? const Color(0xFF43A047) : const Color(0xFF2E1A4F)));
  }

  // Tablero con un camino de flechas y un robot que lo recorre.
  void _tablero(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFFB2EBF2), Color(0xFFE0F7FA)]);
    final u = s.shortestSide / 9;
    for (var y = 0.0; y < s.height; y += u) {
      for (var x = 0.0; x < s.width; x += u) {
        final par = ((x / u).round() + (y / u).round()).isEven;
        c.drawRect(Rect.fromLTWH(x, y, u, u), relleno(par ? const Color(0x22388E3C) : const Color(0x11388E3C)));
      }
    }
    // Camino en zigzag
    final pts = <Offset>[];
    for (var k = 0; k < 12; k++) {
      pts.add(Offset(u * (0.5 + k), s.height * 0.82 - (k.isEven ? 0 : u)));
    }
    for (var k = 0; k < pts.length - 1; k++) {
      c.drawLine(pts[k], pts[k + 1], linea(const Color(0x55F9A825), u * 0.5)..strokeCap = StrokeCap.round);
    }
    final f = (t * 0.25) % 1 * (pts.length - 1);
    final i = f.floor().clamp(0, pts.length - 2);
    dibujarEmoji(c, '🤖', Offset.lerp(pts[i], pts[i + 1], f - i)! - Offset(0, u * 0.3), u * 0.7);
    // Flechas de instrucciones flotando
    const flechas = ['⬆️', '➡️', '↩️', '🔁', '⬆️', '➡️'];
    for (var k = 0; k < flechas.length; k++) {
      final y = s.height * 0.18 + math.sin(t * 1.2 + k) * u * 0.2;
      final x = s.width * (0.08 + k * 0.16);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(x, y), width: u * 0.9, height: u * 0.9), Radius.circular(u * 0.2)), relleno(const Color(0x55FFFFFF)));
      dibujarEmoji(c, flechas[k], Offset(x, y), u * 0.55);
    }
    dibujarEmoji(c, '🏁', pts.last - Offset(0, u * 0.4), u * 0.7);
  }

  // Bloques de colores que flotan y se encajan.
  void _bloques(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)]);
    final u = s.shortestSide / 16;
    const cols = [Color(0xFFFFBF00), Color(0xFF4C97FF), Color(0xFF9966FF), Color(0xFFFFAB19), Color(0xFF59C059), Color(0xFFCF63CF), Color(0xFF5CB1D6)];
    final rnd = math.Random(9);
    for (var k = 0; k < 16; k++) {
      final w = u * (2.5 + rnd.nextDouble() * 3);
      final x = rnd.nextDouble() * s.width;
      final y0 = rnd.nextDouble() * s.height;
      final y = (y0 - t * u * (0.3 + rnd.nextDouble() * 0.4)) % (s.height + 2 * u) - u;
      final col = cols[k % cols.length].withValues(alpha: 0.35);
      final r = Rect.fromLTWH(x, y, w, u * 0.9);
      c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u * 0.2)), relleno(col));
      c.drawRect(Rect.fromLTWH(x + u * 0.5, y + u * 0.9, u * 0.7, u * 0.2), relleno(col));
    }
    // Torre de bloques que se arma en la esquina
    final base = Offset(s.width * 0.88, s.height * 0.92);
    final n = ((t * 0.8) % 7).floor() + 1;
    for (var k = 0; k < n; k++) {
      final r = Rect.fromLTWH(base.dx - u * 2, base.dy - (k + 1) * u * 0.95, u * 4, u * 0.9);
      c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u * 0.15)), relleno(cols[k % cols.length]));
      c.drawRect(Rect.fromLTWH(r.left + u * 0.5, r.bottom - u * 0.05, u * 0.7, u * 0.15), relleno(cols[k % cols.length]));
    }
  }

  // Flechas que giran (ciclos) y rombos de decisión.
  void _bucles(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFF004D57), Color(0xFF00838F), Color(0xFF26A69A)]);
    final u = s.shortestSide / 10;
    for (final (fx, fy, r, v) in const [(0.12, 0.25, 1.4, 1.0), (0.9, 0.7, 1.8, -0.7), (0.55, 0.12, 0.9, 1.4), (0.3, 0.85, 1.1, -1.1)]) {
      final cen = Offset(s.width * fx, s.height * fy);
      final a = t * v;
      c.drawArc(Rect.fromCircle(center: cen, radius: r * u), a, math.pi * 1.6, false, linea(const Color(0x55E0F7FA), u * 0.18)..strokeCap = StrokeCap.round);
      final fin = a + math.pi * 1.6;
      final p = cen + Offset(math.cos(fin), math.sin(fin)) * r * u;
      final tg = Offset(-math.sin(fin), math.cos(fin)) * (v > 0 ? 1 : -1);
      final n = Offset(-tg.dy, tg.dx);
      c.drawPath(Path()..moveTo((p + tg * u * 0.35).dx, (p + tg * u * 0.35).dy)..lineTo((p + n * u * 0.25).dx, (p + n * u * 0.25).dy)..lineTo((p - n * u * 0.25).dx, (p - n * u * 0.25).dy)..close(),
          relleno(const Color(0x88E0F7FA)));
    }
    for (final (fx, fy, k) in const [(0.75, 0.25, 0), (0.2, 0.6, 1), (0.6, 0.8, 2)]) {
      final cen = Offset(s.width * fx, s.height * fy + math.sin(t + k) * u * 0.1);
      final r = u * 0.55;
      final p = Path()..moveTo(cen.dx, cen.dy - r)..lineTo(cen.dx + r * 1.3, cen.dy)..lineTo(cen.dx, cen.dy + r)..lineTo(cen.dx - r * 1.3, cen.dy)..close();
      c.drawPath(p, relleno(const Color(0x44FFD54F)));
      c.drawPath(p, linea(const Color(0x88FFD54F), 2));
      textoEn(c, (t * 0.5 + k).floor().isEven ? 'sí' : 'no', cen, tam: u * 0.3, color: const Color(0xCCFFFFFF));
    }
  }

  // Pantalla de código con bichos que caminan y una lupa que los busca.
  void _bichos(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFF1B2631)));
    final u = s.shortestSide / 30;
    final rnd = math.Random(2);
    const cols = [Color(0x5580CBC4), Color(0x55FFCC80), Color(0x55B3E5FC), Color(0x55CE93D8)];
    final desp = (t * u * 0.6) % (u * 1.6);
    for (var y = -u * 1.6 + desp, k = 0; y < s.height; y += u * 1.6, k++) {
      var x = u * (1 + (k % 4));
      final n = 2 + rnd.nextInt(4);
      for (var j = 0; j < n; j++) {
        final w = u * (2 + rnd.nextDouble() * 6);
        c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, u * 0.6), Radius.circular(u * 0.3)), relleno(cols[(k + j) % cols.length]));
        x += w + u * 0.8;
      }
    }
    final bichos = [(0.2, 0.3, 0.07), (0.7, 0.6, -0.05), (0.45, 0.85, 0.09), (0.85, 0.2, -0.08)];
    for (final (fx, fy, v) in bichos) {
      final x = ((fx + t * v) % 1.1 - 0.05) * s.width;
      dibujarEmoji(c, '🐞', Offset(x, s.height * fy + math.sin(t * 6 + fx * 10) * u * 0.2), u * 1.4);
    }
    final lupa = Offset(s.width * (0.5 + 0.35 * math.sin(t * 0.4)), s.height * (0.5 + 0.3 * math.cos(t * 0.3)));
    c.drawCircle(lupa, u * 4, Paint()..shader = RadialGradient(colors: const [Color(0x33FFF59D), Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: lupa, radius: u * 4)));
  }

  @override
  bool shouldRepaint(_PintorFondoPro old) => old.t != t || old.tipo != tipo;
}
