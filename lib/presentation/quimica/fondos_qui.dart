import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../ciencia/pinceles.dart';

/// Fondos animados del mundo de Química: uno para el mapa y uno por tema.
enum FondoQui { laboratorio, materiales, gases, transforma, cocina, fuego }

EstiloMundo estiloQui(FondoQui f) {
  final (a, b, borde) = switch (f) {
    FondoQui.laboratorio => (const Color(0xFFCE93D8), const Color(0xFF8E24AA), const Color(0xFF4A148C)),
    FondoQui.materiales => (const Color(0xFFBCAAA4), const Color(0xFF795548), const Color(0xFF3E2723)),
    FondoQui.gases => (const Color(0xFF81D4FA), const Color(0xFF039BE5), const Color(0xFF01579B)),
    FondoQui.transforma => (const Color(0xFF80DEEA), const Color(0xFF00ACC1), const Color(0xFF006064)),
    FondoQui.cocina => (const Color(0xFFFFCC80), const Color(0xFFFB8C00), const Color(0xFFBF360C)),
    FondoQui.fuego => (const Color(0xFFFFAB91), const Color(0xFFE64A19), const Color(0xFF7F1D00)),
  };
  return EstiloMundo(
      fondo: (_) => FondoQuimica(f), letrero: [a, b], bordeLetrero: borde, sombraLetrero: Color.lerp(borde, Colors.black, 0.4)!, textoLetrero: Colors.white);
}

class FondoQuimica extends StatelessWidget {
  const FondoQuimica(this.tipo, {super.key});
  final FondoQui tipo;
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _Pintor(tipo, t), child: const SizedBox.expand())));
}

class _Pintor extends CustomPainter {
  _Pintor(this.tipo, this.t);
  final FondoQui tipo;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    switch (tipo) {
      case FondoQui.laboratorio:
        gradiente(c, s, const [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)]);
        repisa(c, s, u, 0.35, ['⚗️', '🧪', '🧫', '⚗️', '🧪']);
        repisa(c, s, u, 0.68, ['🧴', '🧪', '🔬', '⚗️', '🧂']);
        burbujas(c, s, u, t, const Color(0x66E1BEE7));
      case FondoQui.materiales:
        gradiente(c, s, const [Color(0xFFD7CCC8), Color(0xFFBCAAA4)]);
        // Pared de ladrillos
        final lad = Paint()..color = const Color(0x22795548);
        for (var y = 0.0, f = 0; y < s.height * 0.7; y += 6 * u, f++) {
          for (var x = (f.isEven ? 0.0 : -6 * u); x < s.width; x += 12 * u) {
            c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 0.4 * u, y + 0.4 * u, 11.2 * u, 5.2 * u), Radius.circular(u)), lad);
          }
        }
        // Mesa de madera con vetas
        final mesa = Rect.fromLTWH(0, s.height * 0.72, s.width, s.height * 0.28);
        c.drawRect(mesa, relleno(const Color(0xFFA1887F)));
        for (var k = 0; k < 6; k++) {
          final y = mesa.top + k * mesa.height / 6 + 2 * u;
          c.drawPath(
              Path()
                ..moveTo(0, y)
                ..cubicTo(s.width * 0.3, y + 2 * u, s.width * 0.6, y - 2 * u, s.width, y),
              linea(const Color(0x336D4C41), 0.6 * u));
        }
        flotan(c, s, u, t, ['🪨', '🧽', '🔩', '🪵', '🧱', '🥄'], 0.06);
      case FondoQui.gases:
        gradiente(c, s, const [Color(0xFF4FC3F7), Color(0xFFB3E5FC), Color(0xFFE1F5FE)]);
        for (var k = 0; k < 4; k++) {
          final x = ((t * 0.02 + k * 0.27) % 1.2 - 0.1) * s.width;
          dibujarEmoji(c, '☁️', Offset(x, s.height * (0.12 + k * 0.08)), 12 * u);
        }
        for (var k = 0; k < 6; k++) {
          final f = (t * 0.05 + k / 6) % 1;
          final x = s.width * ((k * 0.19 + 0.08) % 1) + math.sin(t + k) * 3 * u;
          dibujarEmoji(c, ['🎈', '🎈', '🪁', '🎈', '🫧', '🎈'][k], Offset(x, s.height * (1.05 - f * 1.1)), 8 * u);
        }
        burbujas(c, s, u, t, const Color(0x5581D4FA));
      case FondoQui.transforma:
        gradiente(c, s, const [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)]);
        // Cubos de hielo que se derriten y vuelven a congelar
        for (var k = 0; k < 5; k++) {
          final f = (math.sin(t * 0.4 + k) * 0.5 + 0.5);
          final x = s.width * (0.1 + k * 0.2), y = s.height * 0.86;
          final h = 8 * u * (0.4 + 0.6 * f);
          c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x - 4 * u, y - h, 8 * u, h), Radius.circular(1.5 * u)), relleno(const Color(0xAAE1F5FE)));
          c.drawOval(Rect.fromCenter(center: Offset(x, y + u), width: 14 * u * (1.2 - f * 0.4), height: 2.4 * u), relleno(const Color(0x6629B6F6)));
        }
        vapor(c, u, t, s.width * 0.82, s.height * 0.5);
        flotan(c, s, u, t, ['🧊', '💧', '🍫', '🕯️', '🥚'], 0.04);
      case FondoQui.cocina:
        gradiente(c, s, const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)]);
        // Azulejos
        final az = linea(const Color(0x22E65100), 0.4 * u);
        for (var x = 0.0; x < s.width; x += 8 * u) {
          c.drawLine(Offset(x, 0), Offset(x, s.height * 0.7), az);
        }
        for (var y = 0.0; y < s.height * 0.7; y += 8 * u) {
          c.drawLine(Offset(0, y), Offset(s.width, y), az);
        }
        c.drawRect(Rect.fromLTWH(0, s.height * 0.7, s.width, s.height * 0.3), relleno(const Color(0xFF8D6E63)));
        c.drawRect(Rect.fromLTWH(0, s.height * 0.7, s.width, 1.5 * u), relleno(const Color(0xFFBCAAA4)));
        dibujarEmoji(c, '🍲', Offset(s.width * 0.12, s.height * 0.66), 12 * u);
        vapor(c, u, t, s.width * 0.12, s.height * 0.58);
        dibujarEmoji(c, '🧊', Offset(s.width * 0.9, s.height * 0.55), 10 * u);
        flotan(c, s, u, t, ['🍞', '🥛', '🍎', '🧀', '🥕'], 0.04);
      case FondoQui.fuego:
        gradiente(c, s, const [Color(0xFF1A0A2E), Color(0xFF4A1A3A), Color(0xFF7A2E1E)]);
        for (var k = 0; k < 30; k++) {
          c.drawCircle(Offset((k * 137 % 1000) / 1000 * s.width, (k * 71 % 400) / 1000 * s.height), 0.4 * u,
              relleno(Colors.white.withValues(alpha: 0.3 + 0.4 * (math.sin(t * 2 + k) * 0.5 + 0.5))));
        }
        // Siluetas de pinos
        for (var k = 0; k < 9; k++) {
          final x = s.width * k / 8, h = s.height * (0.25 + (k % 3) * 0.06);
          c.drawPath(
              Path()
                ..moveTo(x - 7 * u, s.height * 0.85)
                ..lineTo(x, s.height * 0.85 - h)
                ..lineTo(x + 7 * u, s.height * 0.85)
                ..close(),
              relleno(const Color(0xFF1B1020)));
        }
        c.drawRect(Rect.fromLTWH(0, s.height * 0.85, s.width, s.height * 0.15), relleno(const Color(0xFF2A1410)));
        // Fogata
        final f = Offset(s.width * 0.88, s.height * 0.84);
        c.drawCircle(
            f,
            20 * u,
            Paint()
              ..shader = RadialGradient(colors: [const Color(0x66FF6F00), const Color(0x00FF6F00)]).createShader(Rect.fromCircle(center: f, radius: 20 * u)));
        dibujarEmoji(c, '🔥', f - Offset(0, 4 * u + math.sin(t * 8) * 0.5 * u), 12 * u * (1 + 0.05 * math.sin(t * 9)));
        for (var k = 0; k < 10; k++) {
          final fr = (t * 0.4 + k / 10) % 1;
          c.drawCircle(f + Offset(math.sin(t * 3 + k) * 4 * u, -fr * 40 * u), 0.5 * u, relleno(Color.fromARGB((255 * (1 - fr)).round(), 255, 180, 60)));
        }
    }
  }

  @override
  bool shouldRepaint(_Pintor old) => old.t != t || old.tipo != tipo;
}
