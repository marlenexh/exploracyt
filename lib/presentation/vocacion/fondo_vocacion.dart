import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Fondo animado de Vocación: “el camino al futuro”. Un cielo al atardecer
/// con una constelación de profesiones, un camino que brilla y una ciudad del
/// futuro en el horizonte.
class FondoVocacion extends StatelessWidget {
  const FondoVocacion({super.key, this.velo = 0});

  /// Oscurece un poco el fondo (0 a 1) para que el contenido se lea mejor.
  final double velo;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorVocacion(t, velo), child: const SizedBox.expand())),
      );
}

const _profesiones = ['🔬', '🧪', '⚡', '🤖', '💻', '🌿', '🚀', '🩺', '🛰️', '🧬', '🌋', '🎮'];

class _PintorVocacion extends CustomPainter {
  _PintorVocacion(this.t, this.velo);
  final double t, velo;

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    c.drawRect(
        Offset.zero & s,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1446), Color(0xFF3B1F6E), Color(0xFF8E3C8C), Color(0xFFFF8A65)],
            stops: [0, 0.4, 0.68, 0.86],
          ).createShader(Offset.zero & s));

    // Estrellas
    for (var k = 0; k < 70; k++) {
      final p = Offset((k * 211 % 1000) / 1000 * s.width, (k * 97 % 1000) / 1000 * s.height * 0.6);
      c.drawCircle(p, (k % 3 + 1) * 0.16 * u, Paint()..color = Colors.white.withValues(alpha: 0.25 + 0.5 * (math.sin(t * 2 + k) * 0.5 + 0.5)));
    }

    // Constelación de profesiones
    final pts = <Offset>[
      for (var k = 0; k < _profesiones.length; k++)
        Offset(s.width * (0.06 + (k * 0.083)), s.height * (0.12 + 0.16 * (math.sin(k * 1.7) * 0.5 + 0.5)) + math.sin(t * 0.8 + k) * 1.5 * u)
    ];
    final lineaConst = Paint()
      ..color = const Color(0x55FFFFFF)
      ..strokeWidth = 0.25 * u;
    for (var k = 0; k < pts.length - 1; k++) {
      c.drawLine(pts[k], pts[k + 1], lineaConst);
    }
    for (var k = 0; k < pts.length; k++) {
      final brillo = math.sin(t * 1.5 + k) * 0.5 + 0.5;
      c.drawCircle(pts[k], 4.2 * u, Paint()..color = Colors.white.withValues(alpha: 0.08 + 0.12 * brillo));
      c.saveLayer(null, Paint()..color = Color.fromRGBO(255, 255, 255, 0.55 + 0.35 * brillo));
      dibujarEmoji(c, _profesiones[k], pts[k], 4.6 * u);
      c.restore();
    }

    // Sol del atardecer
    final sol = Offset(s.width * 0.5, s.height * 0.74);
    c.drawCircle(sol, 24 * u,
        Paint()..shader = RadialGradient(colors: const [Color(0xAAFFE082), Color(0x00FFE082)]).createShader(Rect.fromCircle(center: sol, radius: 24 * u)));
    c.drawCircle(sol, 8 * u, Paint()..color = const Color(0xFFFFD180));

    // Ciudad del futuro
    final rnd = math.Random(4);
    var x = 0.0;
    final ciudad = Paint()..color = const Color(0xFF2A1650);
    while (x < s.width) {
      final w = (4 + rnd.nextDouble() * 7) * u;
      final h = (8 + rnd.nextDouble() * 22) * u;
      final r = Rect.fromLTWH(x, s.height * 0.8 - h, w, h);
      if (rnd.nextBool()) {
        c.drawRRect(RRect.fromRectAndCorners(r, topLeft: Radius.circular(w / 2), topRight: Radius.circular(w / 2)), ciudad);
      } else {
        c.drawRect(r, ciudad);
      }
      for (var y = r.top + 1.5 * u; y < r.bottom - u; y += 2.4 * u) {
        for (var xx = r.left + 0.8 * u; xx < r.right - u; xx += 1.8 * u) {
          if (rnd.nextDouble() < 0.4) {
            final on = (math.sin(t * 0.7 + xx * 0.3 + y) * 0.5 + 0.5) > 0.3;
            c.drawRect(Rect.fromLTWH(xx, y, 0.7 * u, 1 * u), Paint()..color = on ? const Color(0xFFFFE082) : const Color(0x33FFE082));
          }
        }
      }
      x += w + 0.6 * u;
    }

    // Suelo y camino que brilla hacia el futuro
    c.drawRect(Rect.fromLTWH(0, s.height * 0.8, s.width, s.height * 0.2), Paint()..color = const Color(0xFF1E1240));
    final camino = Path()
      ..moveTo(s.width * 0.36, s.height)
      ..quadraticBezierTo(s.width * 0.47, s.height * 0.88, s.width * 0.49, s.height * 0.8)
      ..lineTo(s.width * 0.51, s.height * 0.8)
      ..quadraticBezierTo(s.width * 0.53, s.height * 0.88, s.width * 0.64, s.height)
      ..close();
    c.drawPath(
        camino,
        Paint()
          ..shader = const LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xFF7C4DFF), Color(0xFFFFD180)])
              .createShader(Rect.fromLTWH(0, s.height * 0.8, s.width, s.height * 0.2)));
    for (var k = 0; k < 6; k++) {
      final f = (t * 0.25 + k / 6) % 1;
      final y = s.height - f * s.height * 0.2;
      c.drawCircle(Offset(s.width * 0.5, y), (1 - f) * 0.9 * u + 0.2 * u, Paint()..color = Colors.white.withValues(alpha: 0.8 * (1 - f)));
    }

    // Chispas que suben
    for (var k = 0; k < 16; k++) {
      final f = (t * 0.05 + k / 16) % 1;
      final p = Offset(s.width * ((k * 0.137) % 1) + math.sin(t + k) * 2 * u, s.height * (1 - f));
      c.drawCircle(p, 0.35 * u, Paint()..color = const Color(0xFFFFE082).withValues(alpha: math.sin(f * math.pi) * 0.8));
    }
    if (velo > 0) c.drawRect(Offset.zero & s, Paint()..color = Colors.black.withValues(alpha: velo));
  }

  @override
  bool shouldRepaint(_PintorVocacion old) => old.t != t || old.velo != velo;
}
