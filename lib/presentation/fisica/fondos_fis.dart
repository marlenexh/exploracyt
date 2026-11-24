import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../ciencia/pinceles.dart';

/// Fondos animados del mundo de Física: uno para el mapa y uno por tema.
enum FondoFis { fuerzas, magnetismo, gravedad, calor, energia, espacio }

EstiloMundo estiloFis(FondoFis f) {
  final (a, b, borde) = switch (f) {
    FondoFis.fuerzas => (const Color(0xFF80CBC4), const Color(0xFF00897B), const Color(0xFF004D40)),
    FondoFis.magnetismo => (const Color(0xFFEF9A9A), const Color(0xFFD32F2F), const Color(0xFF7F0000)),
    FondoFis.gravedad => (const Color(0xFFA5D6A7), const Color(0xFF43A047), const Color(0xFF1B5E20)),
    FondoFis.calor => (const Color(0xFFFFE082), const Color(0xFFFF8F00), const Color(0xFFBF360C)),
    FondoFis.energia => (const Color(0xFFC5E1A5), const Color(0xFF7CB342), const Color(0xFF33691E)),
    FondoFis.espacio => (const Color(0xFF9FA8DA), const Color(0xFF3949AB), const Color(0xFF1A237E)),
  };
  return EstiloMundo(
      fondo: (_) => FondoFisica(f), letrero: [a, b], bordeLetrero: borde, sombraLetrero: Color.lerp(borde, Colors.black, 0.4)!, textoLetrero: Colors.white);
}

class FondoFisica extends StatelessWidget {
  const FondoFisica(this.tipo, {super.key});
  final FondoFis tipo;
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _Pintor(tipo, t), child: const SizedBox.expand())));
}

class _Pintor extends CustomPainter {
  _Pintor(this.tipo, this.t);
  final FondoFis tipo;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    switch (tipo) {
      case FondoFis.fuerzas:
        _fuerzas(c, s, u);
      case FondoFis.magnetismo:
        gradiente(c, s, const [Color(0xFF311B92), Color(0xFF4527A0), Color(0xFF5E35B1)]);
        // Líneas de campo magnético
        final cen = Offset(s.width * 0.5, s.height * 0.55);
        for (var k = 1; k <= 7; k++) {
          final w = k * 12 * u, h = k * 7 * u;
          for (final lado in [-1.0, 1.0]) {
            c.drawOval(Rect.fromCenter(center: cen + Offset(0, lado * h / 2), width: w * 2, height: h),
                linea(Color.fromARGB(40 + (math.sin(t * 2 - k) * 20).round().clamp(0, 40), 255, 255, 255), 0.4 * u));
          }
        }
        c.drawRect(Rect.fromCenter(center: cen - Offset(6 * u, 0), width: 12 * u, height: 5 * u), relleno(const Color(0x88E53935)));
        c.drawRect(Rect.fromCenter(center: cen + Offset(6 * u, 0), width: 12 * u, height: 5 * u), relleno(const Color(0x881E88E5)));
        // Limaduras que se acercan y alejan
        for (var k = 0; k < 40; k++) {
          final a = k / 40 * 2 * math.pi;
          final d = (25 + (k % 5) * 6) * u * (1 + 0.08 * math.sin(t * 1.5 + k));
          final p = cen + Offset(math.cos(a) * d * 1.5, math.sin(a) * d * 0.8);
          c.drawLine(p, p + Offset(math.cos(a + 1.57) * u, math.sin(a + 1.57) * u), linea(const Color(0x88B0BEC5), 0.4 * u));
        }
        flotan(c, s, u, t, ['🧲', '🧭', '📎', '🔩'], 0.05);
      case FondoFis.gravedad:
        gradiente(c, s, const [Color(0xFF81D4FA), Color(0xFFE1F5FE)]);
        montes(c, s, u, const Color(0xFFA5D6A7), 0.76, 0.1);
        // Árbol con manzanas que caen
        final tr = Offset(s.width * 0.12, s.height * 0.6);
        c.drawRect(Rect.fromLTWH(tr.dx - 2 * u, tr.dy, 4 * u, s.height * 0.2), relleno(const Color(0xFF6D4C41)));
        c.drawCircle(tr, 16 * u, relleno(const Color(0xFF43A047)));
        for (var k = 0; k < 3; k++) {
          final f = (t * 0.35 + k / 3) % 1;
          dibujarEmoji(c, '🍎', Offset(tr.dx - 8 * u + k * 8 * u, tr.dy + f * f * (s.height * 0.22)), 4 * u);
        }
        // Paracaídas y pluma
        dibujarEmoji(c, '🪂', Offset(s.width * 0.7 + math.sin(t * 0.7) * 4 * u, (t * 0.03 % 1) * s.height), 9 * u);
        dibujarEmoji(c, '🪶', Offset(s.width * 0.9 + math.sin(t * 1.3) * 3 * u, ((t * 0.02 + 0.5) % 1) * s.height), 5 * u);
        dibujarEmoji(c, '🌍', Offset(s.width * 0.45, s.height * 0.14), 7 * u);
      case FondoFis.calor:
        gradiente(c, s, const [Color(0xFFFFE0B2), Color(0xFFFFCC80), Color(0xFFFF8A65)]);
        final sol = Offset(s.width * 0.85, s.height * 0.15);
        c.drawCircle(
            sol,
            22 * u,
            Paint()
              ..shader = RadialGradient(colors: [const Color(0xAAFFEB3B), const Color(0x00FFEB3B)]).createShader(Rect.fromCircle(center: sol, radius: 22 * u)));
        dibujarEmoji(c, '☀️', sol, 12 * u);
        // Ondas de calor
        for (var k = 0; k < 6; k++) {
          final x0 = s.width * (0.1 + k * 0.15);
          final p = Path()..moveTo(x0, s.height);
          for (var y = s.height; y > s.height * 0.4; y -= 2 * u) {
            p.lineTo(x0 + math.sin(y / (6 * u) + t * 3 + k) * 2 * u, y);
          }
          c.drawPath(p, linea(const Color(0x33FFFFFF), 0.8 * u));
        }
        flotan(c, s, u, t, ['🌡️', '☕', '🔥', '🧊', '🍳'], 0.04);
      case FondoFis.energia:
        gradiente(c, s, const [Color(0xFF4FC3F7), Color(0xFFE1F5FE)]);
        montes(c, s, u, const Color(0xFF9CCC65), 0.72, 0.14);
        for (var k = 0; k < 3; k++) {
          molino(c, t, Offset(s.width * (0.62 + k * 0.13), s.height * (0.58 + k * 0.03)), u * (0.8 + k * 0.1), fase: k.toDouble());
        }
        // Paneles solares
        for (var k = 0; k < 3; k++) {
          final r = Rect.fromLTWH(s.width * (0.06 + k * 0.1), s.height * 0.8, 8 * u, 5 * u);
          c.drawRect(r, relleno(const Color(0xFF1A237E)));
          c.drawLine(r.topCenter, r.bottomCenter, linea(const Color(0x88BBDEFB), 0.3 * u));
          c.drawLine(r.centerLeft, r.centerRight, linea(const Color(0x88BBDEFB), 0.3 * u));
        }
        dibujarEmoji(c, '☀️', Offset(s.width * 0.15, s.height * 0.14), 10 * u);
        flotan(c, s, u, t, ['⚡', '💡', '🔋'], 0.03);
      case FondoFis.espacio:
        c.drawRect(Offset.zero & s, relleno(const Color(0xFF0B0D2A)));
        for (var k = 0; k < 90; k++) {
          c.drawCircle(Offset((k * 211 % 1000) / 1000 * s.width, (k * 97 % 1000) / 1000 * s.height), (k % 3 + 1) * 0.15 * u,
              relleno(Colors.white.withValues(alpha: 0.3 + 0.5 * (math.sin(t * 2 + k) * 0.5 + 0.5))));
        }
        final sol = Offset(-10 * u, s.height * 0.5);
        c.drawCircle(
            sol,
            40 * u,
            Paint()
              ..shader = RadialGradient(colors: const [Color(0xFFFFF59D), Color(0xFFFF8F00), Color(0x00FF6F00)], stops: const [0.3, 0.6, 1])
                  .createShader(Rect.fromCircle(center: sol, radius: 40 * u)));
        const orbitas = [('🪐', 70.0, 0.08), ('🔴', 50.0, 0.2), ('🌍', 38.0, 0.3)];
        for (final (e, r, v) in orbitas) {
          c.drawOval(Rect.fromCenter(center: sol, width: r * u * 2.6, height: r * u * 1.4), linea(const Color(0x22FFFFFF), 0.3 * u));
          final a = t * v;
          dibujarEmoji(c, e, sol + Offset(math.cos(a) * r * u * 1.3, math.sin(a) * r * u * 0.7), 5 * u);
        }
        dibujarEmoji(c, '☄️', Offset(((t * 0.04) % 1.3) * s.width, s.height * 0.15 + ((t * 0.04) % 1.3) * s.height * 0.2), 5 * u);
    }
  }

  /// Mapa de Física: el taller de las fuerzas (engranes, péndulo de Newton,
  /// rampa con una canica, balancín y chispas de energía).
  void _fuerzas(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF004D40), Color(0xFF00796B), Color(0xFF4DB6AC), Color(0xFFFFE0B2)]);
    // Cuadrícula de plano técnico
    final cuad = linea(const Color(0x1AFFFFFF), 0.25 * u);
    for (var x = 0.0; x < s.width; x += 8 * u) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), cuad);
    }
    for (var y = 0.0; y < s.height; y += 8 * u) {
      c.drawLine(Offset(0, y), Offset(s.width, y), cuad);
    }
    // Engranes que giran juntos
    engrane(c, Offset(s.width * 0.06, s.height * 0.16), 14 * u, t * 0.6, const Color(0x55FFD54F), dientes: 12);
    engrane(c, Offset(s.width * 0.06 + 23 * u, s.height * 0.16 + 9 * u), 10 * u, -t * 0.84 + 0.2, const Color(0x55FFB300), dientes: 9);
    engrane(c, Offset(s.width * 0.95, s.height * 0.12), 12 * u, -t * 0.5, const Color(0x44FFFFFF), dientes: 11);
    // Péndulo de Newton
    final barra = Rect.fromLTWH(s.width * 0.06, s.height * 0.5, 34 * u, 1.4 * u);
    c.drawRect(barra, relleno(const Color(0xFF37474F)));
    c.drawLine(barra.bottomLeft, barra.bottomLeft + Offset(0, 26 * u), linea(const Color(0xFF37474F), 1.2 * u));
    c.drawLine(barra.bottomRight, barra.bottomRight + Offset(0, 26 * u), linea(const Color(0xFF37474F), 1.2 * u));
    final osc = math.sin(t * 3.2);
    for (var k = 0; k < 5; k++) {
      final top = Offset(barra.left + 5 * u + k * 6 * u, barra.bottom);
      var ang = 0.0;
      if (k == 0 && osc < 0) ang = osc * 0.6;
      if (k == 4 && osc > 0) ang = osc * 0.6;
      final bola = top + Offset(math.sin(ang), math.cos(ang)) * 16 * u;
      c.drawLine(top, bola, linea(const Color(0xCCECEFF1), 0.25 * u));
      c.drawCircle(bola, 3 * u, relleno(const Color(0xFFB0BEC5)));
      c.drawCircle(bola - Offset(u, u), 0.9 * u, relleno(const Color(0xCCFFFFFF)));
    }
    // Rampa con una canica que baja y sube
    final r0 = Offset(s.width * 0.62, s.height * 0.62), r1 = Offset(s.width * 0.97, s.height * 0.9);
    c.drawPath(
        Path()
          ..moveTo(r0.dx, r0.dy)
          ..lineTo(r1.dx, r1.dy)
          ..lineTo(r0.dx, r1.dy)
          ..close(),
        relleno(const Color(0xAA8D6E63)));
    final f = (math.sin(t * 1.3) * 0.5 + 0.5);
    final canica = Offset.lerp(r0, r1, f * f)! - Offset(0, 2.4 * u);
    c.drawCircle(canica, 2.4 * u, relleno(const Color(0xFFE53935)));
    // Balancín
    final pivote = Offset(s.width * 0.42, s.height * 0.88);
    c.drawPath(
        Path()
          ..moveTo(pivote.dx - 3 * u, pivote.dy + 5 * u)
          ..lineTo(pivote.dx, pivote.dy)
          ..lineTo(pivote.dx + 3 * u, pivote.dy + 5 * u)
          ..close(),
        relleno(const Color(0xFF5D4037)));
    final inc = math.sin(t * 0.9) * 0.18;
    final d = Offset(math.cos(inc), math.sin(inc)) * 20 * u;
    c.drawLine(pivote - d, pivote + d, linea(const Color(0xFF6D4C41), 1.4 * u)..strokeCap = StrokeCap.round);
    dibujarEmoji(c, '📦', pivote - d - Offset(0, 3 * u), 5 * u);
    dibujarEmoji(c, '⚽', pivote + d - Offset(0, 3 * u), 4 * u);
    // Chispas de energía
    for (var k = 0; k < 8; k++) {
      final fr = (t * 0.25 + k / 8) % 1;
      final p = Offset(s.width * (0.2 + (k * 0.11) % 0.6), s.height * (0.45 - fr * 0.35));
      c.drawCircle(p, 0.6 * u, relleno(Color.fromARGB((200 * (1 - fr)).round(), 255, 241, 118)));
    }
    flotan(c, s, u, t, const ['🧲', '🍎', '🌡️', '⚡', '🪐'], 0.06);
  }

  @override
  bool shouldRepaint(_Pintor old) => old.t != t || old.tipo != tipo;
}
