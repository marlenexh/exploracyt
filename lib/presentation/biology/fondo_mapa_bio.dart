import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'tema1/comunes.dart' show Reloj, linea, relleno;
import 'temas/motor.dart' show dibujarEmoji;

/// Fondo animado del mapa de Biología: un valle de la selva al amanecer con
/// cascada, río, árboles gigantes, mariposas, aves y un claro de pasto donde
/// están los pedestales de los temas.
class FondoMapaBiologia extends StatelessWidget {
  const FondoMapaBiologia({super.key});
  @override
  Widget build(BuildContext context) => RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorValle(t), child: const SizedBox.expand())));
}

class _PintorValle extends CustomPainter {
  _PintorValle(this.t);
  final double t;

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    final w = s.width, h = s.height;

    // Cielo del amanecer
    c.drawRect(
        Offset.zero & s,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4FC3F7), Color(0xFFB3E5FC), Color(0xFFFFF3C4), Color(0xFFFFE0A3)],
            stops: [0, 0.35, 0.55, 0.62],
          ).createShader(Offset.zero & s));

    // Sol con rayos que giran despacio
    final sol = Offset(w * 0.5, h * 0.3);
    c.drawCircle(sol, 30 * u,
        Paint()..shader = RadialGradient(colors: const [Color(0x88FFF59D), Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: sol, radius: 30 * u)));
    for (var k = 0; k < 12; k++) {
      final a = t * 0.08 + k * math.pi / 6;
      c.drawLine(sol + Offset(math.cos(a), math.sin(a)) * 11 * u, sol + Offset(math.cos(a), math.sin(a)) * 18 * u,
          linea(const Color(0x66FFE082), 1.2 * u)..strokeCap = StrokeCap.round);
    }
    c.drawCircle(sol, 8 * u, relleno(const Color(0xFFFFE082)));

    // Nubes
    for (var k = 0; k < 4; k++) {
      final x = ((t * 0.012 + k * 0.29) % 1.3 - 0.15) * w;
      _nube(c, Offset(x, h * (0.08 + (k % 2) * 0.08)), u * (1 + (k % 3) * 0.2));
    }

    // Montañas lejanas y colinas de selva
    _colinas(c, s, const Color(0xFF90A4AE), 0.5, 0.2, 3, 0.4);
    _colinas(c, s, const Color(0xFF66BB6A), 0.58, 0.12, 5, 1.7);
    _colinas(c, s, const Color(0xFF388E3C), 0.64, 0.08, 8, 2.9);

    // Aves volando
    for (var k = 0; k < 3; k++) {
      final f = (t * 0.03 + k * 0.33) % 1;
      final p = Offset(w * (f * 1.2 - 0.1), h * (0.18 + k * 0.04) + math.sin(t * 2 + k) * u);
      final ala = math.sin(t * 8 + k) * 1.2 * u;
      c.drawPath(
          Path()
            ..moveTo(p.dx - 2.4 * u, p.dy - ala)
            ..quadraticBezierTo(p.dx - 1 * u, p.dy - 0.6 * u, p.dx, p.dy)
            ..quadraticBezierTo(p.dx + 1 * u, p.dy - 0.6 * u, p.dx + 2.4 * u, p.dy - ala),
          linea(const Color(0xFF37474F), 0.35 * u));
    }

    // Cascada a la derecha y río que cruza el valle
    final cx = w * 0.8;
    final roca = Path()
      ..moveTo(cx - 14 * u, h * 0.66)
      ..lineTo(cx - 9 * u, h * 0.42)
      ..lineTo(cx + 9 * u, h * 0.4)
      ..lineTo(cx + 15 * u, h * 0.66)
      ..close();
    c.drawPath(roca, relleno(const Color(0xFF5D6E5A)));
    for (var k = 0; k < 5; k++) {
      c.drawCircle(Offset(cx - 10 * u + k * 5 * u, h * 0.42 + (k % 2) * u), 3.2 * u, relleno(const Color(0xFF558B2F)));
    }
    final agua = Rect.fromLTRB(cx - 4 * u, h * 0.42, cx + 4 * u, h * 0.66);
    c.drawRect(
        agua,
        Paint()
          ..shader =
              const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFB3E5FC), Color(0xFF4FC3F7)]).createShader(agua));
    for (var k = 0; k < 5; k++) {
      final f = (t * 0.9 + k / 5) % 1;
      final y = agua.top + f * agua.height;
      c.drawLine(Offset(agua.left + (k + 0.5) * agua.width / 5, y), Offset(agua.left + (k + 0.5) * agua.width / 5, y + 3 * u),
          linea(const Color(0xCCFFFFFF), 0.35 * u));
    }
    final rio = Path()
      ..moveTo(cx - 6 * u, h * 0.66)
      ..cubicTo(w * 0.7, h * 0.7, w * 0.95, h * 0.74, w * 1.05, h * 0.72)
      ..lineTo(w * 1.05, h * 0.78)
      ..cubicTo(w * 0.9, h * 0.8, w * 0.68, h * 0.73, cx + 6 * u, h * 0.66)
      ..close();

    // Prado del claro (aquí descansan los pedestales)
    final prado = Path()..moveTo(0, h * 0.66);
    for (var x = 0.0; x <= w; x += 4 * u) {
      prado.lineTo(x, h * 0.66 - math.sin(x / w * 5) * 1.5 * u);
    }
    prado
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    c.drawPath(
        prado,
        Paint()
          ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF8BC34A), Color(0xFF558B2F)])
              .createShader(Rect.fromLTWH(0, h * 0.64, w, h * 0.36)));
    c.drawPath(rio, relleno(const Color(0xFF4FC3F7)));
    for (var k = 0; k < 6; k++) {
      final f = (t * 0.2 + k / 6) % 1;
      c.drawCircle(Offset(cx + f * (w * 0.25), h * (0.69 + f * 0.05)), 0.4 * u, relleno(const Color(0xAAFFFFFF)));
    }
    // Camino de piedras en el centro del claro
    final centro = Offset(w * 0.5, h * 0.86);
    c.drawOval(Rect.fromCenter(center: centro, width: w * 0.86, height: h * 0.16), relleno(const Color(0x33FFF8E1)));
    for (var k = 0; k < 14; k++) {
      final a = k / 14 * 2 * math.pi;
      final p = centro + Offset(math.cos(a) * w * 0.43, math.sin(a) * h * 0.08);
      c.drawOval(Rect.fromCenter(center: p, width: 5 * u, height: 2.4 * u), relleno(const Color(0x66D7CCC8)));
    }

    // Árboles gigantes a los lados con lianas
    _arbol(c, Offset(w * 0.06, h * 0.7), u, h, 0);
    _arbol(c, Offset(w * 0.95, h * 0.74), u, h, 1.3);

    // Flores que se mecen en el pasto
    const flores = ['🌼', '🌸', '🌺', '🌷', '🌻', '🍄'];
    for (var k = 0; k < 12; k++) {
      final x = w * ((k * 0.083 + 0.04) % 1);
      final y = h * (0.7 + (k * 37 % 25) / 100);
      c.save();
      c.translate(x, y);
      c.rotate(math.sin(t * 1.5 + k) * 0.12);
      dibujarEmoji(c, flores[k % flores.length], Offset.zero, 3.6 * u);
      c.restore();
    }

    // Mariposas en ocho
    for (var k = 0; k < 4; k++) {
      final a = t * 0.5 + k * 1.6;
      final p = Offset(w * (0.2 + k * 0.2) + math.sin(a) * 8 * u, h * (0.55 + 0.04 * k) + math.sin(a * 2) * 4 * u);
      c.save();
      c.translate(p.dx, p.dy);
      c.scale(0.7 + 0.3 * math.cos(t * 9 + k).abs(), 1);
      dibujarEmoji(c, '🦋', Offset.zero, 4 * u);
      c.restore();
    }
    dibujarEmoji(c, '🐦', Offset(w * 0.08, h * 0.3 + math.sin(t * 2) * 0.5 * u), 4 * u);
    dibujarEmoji(c, '🐒', Offset(w * 0.93, h * 0.38 + math.sin(t * 1.5) * u), 5 * u);
    dibujarEmoji(c, '🐸', Offset(w * 0.86, h * 0.75), 3.4 * u);

    // Polen y hojas que caen
    for (var k = 0; k < 16; k++) {
      final f = (t * 0.04 + k / 16) % 1;
      final p = Offset(w * ((k * 0.137) % 1) + math.sin(t + k) * 3 * u, h * f);
      if (k.isEven) {
        c.drawCircle(p, 0.45 * u, relleno(Color.fromARGB((180 * math.sin(f * math.pi)).round(), 255, 249, 196)));
      } else {
        c.save();
        c.translate(p.dx, p.dy);
        c.rotate(t + k);
        c.drawOval(Rect.fromCenter(center: Offset.zero, width: 1.8 * u, height: 0.9 * u),
            relleno(Color.fromARGB((200 * math.sin(f * math.pi)).round(), 124, 179, 66)));
        c.restore();
      }
    }
  }

  void _nube(Canvas c, Offset p, double u) {
    final pin = relleno(const Color(0xDDFFFFFF));
    c.drawCircle(p, 4 * u, pin);
    c.drawCircle(p + Offset(4 * u, -1.5 * u), 5 * u, pin);
    c.drawCircle(p + Offset(9 * u, 0), 4 * u, pin);
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(p.dx - 2 * u, p.dy, 13 * u, 4 * u), Radius.circular(2 * u)), pin);
  }

  void _colinas(Canvas c, Size s, Color col, double base, double alt, double frec, double fase) {
    final p = Path()..moveTo(0, s.height);
    for (var x = 0.0; x <= s.width; x += 6) {
      final v = math.sin(x / s.width * frec + fase) * 0.6 + math.sin(x / s.width * frec * 2.3 + fase * 2) * 0.4;
      p.lineTo(x, s.height * base - (v * 0.5 + 0.5) * alt * s.height);
    }
    p
      ..lineTo(s.width, s.height)
      ..close();
    c.drawPath(p, relleno(col));
  }

  void _arbol(Canvas c, Offset base, double u, double h, double fase) {
    final tronco = Path()
      ..moveTo(base.dx - 5 * u, base.dy)
      ..quadraticBezierTo(base.dx - 2 * u, base.dy - h * 0.3, base.dx - 3 * u, base.dy - h * 0.62)
      ..lineTo(base.dx + 3 * u, base.dy - h * 0.62)
      ..quadraticBezierTo(base.dx + 2 * u, base.dy - h * 0.3, base.dx + 5 * u, base.dy)
      ..close();
    c.drawPath(tronco, relleno(const Color(0xFF6D4C41)));
    final copa = base - Offset(0, h * 0.66);
    for (final (d, r, col) in [
      (const Offset(-9, 2), 13.0, const Color(0xFF2E7D32)),
      (const Offset(8, 4), 12.0, const Color(0xFF388E3C)),
      (const Offset(0, -6), 14.0, const Color(0xFF43A047)),
      (const Offset(-2, 6), 10.0, const Color(0xFF66BB6A)),
    ]) {
      c.drawCircle(copa + d * u + Offset(math.sin(t * 0.8 + fase) * 0.6 * u, 0), r * u, relleno(col));
    }
    // Lianas que se balancean
    for (var k = 0; k < 3; k++) {
      final x0 = copa.dx + (k - 1) * 7 * u;
      final largo = (18 + k * 6) * u;
      final b = math.sin(t * 1.2 + k + fase) * 2 * u;
      c.drawPath(
          Path()
            ..moveTo(x0, copa.dy + 6 * u)
            ..quadraticBezierTo(x0 + b, copa.dy + 6 * u + largo / 2, x0 + b * 1.5, copa.dy + 6 * u + largo),
          linea(const Color(0xFF558B2F), 0.6 * u));
      dibujarEmoji(c, '🍃', Offset(x0 + b * 1.5, copa.dy + 6 * u + largo), 2.2 * u);
    }
  }

  @override
  bool shouldRepaint(_PintorValle old) => old.t != t;
}
