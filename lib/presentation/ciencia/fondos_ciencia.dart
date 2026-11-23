import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Fondos animados de Química y Física (uno por tema y uno para cada mapa).
enum FondoCiencia {
  // Química
  laboratorio,
  materiales,
  gases,
  transforma,
  cocina,
  fuego,
  // Física
  valle,
  magnetismo,
  gravedad,
  calor,
  energia,
  espacio,
}

EstiloMundo estiloCiencia(FondoCiencia f) {
  final (a, b, borde) = switch (f) {
    FondoCiencia.laboratorio => (const Color(0xFFCE93D8), const Color(0xFF8E24AA), const Color(0xFF4A148C)),
    FondoCiencia.materiales => (const Color(0xFFBCAAA4), const Color(0xFF795548), const Color(0xFF3E2723)),
    FondoCiencia.gases => (const Color(0xFF81D4FA), const Color(0xFF039BE5), const Color(0xFF01579B)),
    FondoCiencia.transforma => (const Color(0xFF80DEEA), const Color(0xFF00ACC1), const Color(0xFF006064)),
    FondoCiencia.cocina => (const Color(0xFFFFCC80), const Color(0xFFFB8C00), const Color(0xFFBF360C)),
    FondoCiencia.fuego => (const Color(0xFFFFAB91), const Color(0xFFE64A19), const Color(0xFF7F1D00)),
    FondoCiencia.valle => (const Color(0xFF90CAF9), const Color(0xFF1E88E5), const Color(0xFF0D47A1)),
    FondoCiencia.magnetismo => (const Color(0xFFEF9A9A), const Color(0xFFD32F2F), const Color(0xFF7F0000)),
    FondoCiencia.gravedad => (const Color(0xFFA5D6A7), const Color(0xFF43A047), const Color(0xFF1B5E20)),
    FondoCiencia.calor => (const Color(0xFFFFE082), const Color(0xFFFF8F00), const Color(0xFFBF360C)),
    FondoCiencia.energia => (const Color(0xFFC5E1A5), const Color(0xFF7CB342), const Color(0xFF33691E)),
    FondoCiencia.espacio => (const Color(0xFF9FA8DA), const Color(0xFF3949AB), const Color(0xFF1A237E)),
  };
  return EstiloMundo(
      fondo: (_) => FondoCienciaWidget(f),
      letrero: [a, b],
      bordeLetrero: borde,
      sombraLetrero: Color.lerp(borde, Colors.black, 0.4)!,
      textoLetrero: Colors.white);
}

class FondoCienciaWidget extends StatelessWidget {
  const FondoCienciaWidget(this.tipo, {super.key});
  final FondoCiencia tipo;
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _Pintor(tipo, t), child: const SizedBox.expand())));
}

class _Pintor extends CustomPainter {
  _Pintor(this.tipo, this.t);
  final FondoCiencia tipo;
  final double t;

  void _grad(Canvas c, Size s, List<Color> cols) => c.drawRect(
      Offset.zero & s, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: cols).createShader(Offset.zero & s));

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    switch (tipo) {
      case FondoCiencia.laboratorio:
        _grad(c, s, const [Color(0xFF4A148C), Color(0xFF7B1FA2), Color(0xFFBA68C8)]);
        _repisa(c, s, u, 0.35, ['⚗️', '🧪', '🧫', '⚗️', '🧪']);
        _repisa(c, s, u, 0.68, ['🧴', '🧪', '🔬', '⚗️', '🧂']);
        _burbujas(c, s, u, const Color(0x66E1BEE7));
      case FondoCiencia.materiales:
        _grad(c, s, const [Color(0xFFD7CCC8), Color(0xFFBCAAA4)]);
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
        _flotan(c, s, u, ['🪨', '🧽', '🔩', '🪵', '🧱', '🥄'], 0.06);
      case FondoCiencia.gases:
        _grad(c, s, const [Color(0xFF4FC3F7), Color(0xFFB3E5FC), Color(0xFFE1F5FE)]);
        for (var k = 0; k < 4; k++) {
          final x = ((t * 0.02 + k * 0.27) % 1.2 - 0.1) * s.width;
          dibujarEmoji(c, '☁️', Offset(x, s.height * (0.12 + k * 0.08)), 12 * u);
        }
        for (var k = 0; k < 6; k++) {
          final f = (t * 0.05 + k / 6) % 1;
          final x = s.width * ((k * 0.19 + 0.08) % 1) + math.sin(t + k) * 3 * u;
          dibujarEmoji(c, ['🎈', '🎈', '🪁', '🎈', '🫧', '🎈'][k], Offset(x, s.height * (1.05 - f * 1.1)), 8 * u);
        }
        _burbujas(c, s, u, const Color(0x5581D4FA));
      case FondoCiencia.transforma:
        _grad(c, s, const [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)]);
        // Cubos de hielo que se derriten y vuelven a congelar
        for (var k = 0; k < 5; k++) {
          final f = (math.sin(t * 0.4 + k) * 0.5 + 0.5);
          final x = s.width * (0.1 + k * 0.2), y = s.height * 0.86;
          final h = 8 * u * (0.4 + 0.6 * f);
          c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x - 4 * u, y - h, 8 * u, h), Radius.circular(1.5 * u)), relleno(const Color(0xAAE1F5FE)));
          c.drawOval(Rect.fromCenter(center: Offset(x, y + u), width: 14 * u * (1.2 - f * 0.4), height: 2.4 * u), relleno(const Color(0x6629B6F6)));
        }
        _vapor(c, s, u, s.width * 0.82, s.height * 0.5);
        _flotan(c, s, u, ['🧊', '💧', '🍫', '🕯️', '🥚'], 0.04);
      case FondoCiencia.cocina:
        _grad(c, s, const [Color(0xFFFFF3E0), Color(0xFFFFE0B2)]);
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
        _vapor(c, s, u, s.width * 0.12, s.height * 0.58);
        dibujarEmoji(c, '🧊', Offset(s.width * 0.9, s.height * 0.55), 10 * u);
        _flotan(c, s, u, ['🍞', '🥛', '🍎', '🧀', '🥕'], 0.04);
      case FondoCiencia.fuego:
        _grad(c, s, const [Color(0xFF1A0A2E), Color(0xFF4A1A3A), Color(0xFF7A2E1E)]);
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
      case FondoCiencia.valle:
        _grad(c, s, const [Color(0xFF64B5F6), Color(0xFFBBDEFB), Color(0xFFE3F2FD)]);
        _montes(c, s, u, const Color(0xFF81C784), 0.7, 0.18);
        _montes(c, s, u, const Color(0xFF66BB6A), 0.82, 0.12);
        _molino(c, Offset(s.width * 0.84, s.height * 0.62), u);
        dibujarEmoji(c, '🧲', Offset(s.width * 0.1, s.height * 0.2 + math.sin(t) * u), 9 * u);
        dibujarEmoji(c, '🍎', Offset(s.width * 0.55, s.height * (0.15 + (t * 0.3 % 1) * 0.5)), 6 * u);
        dibujarEmoji(c, '☀️', Offset(s.width * 0.72, s.height * 0.12), 10 * u);
      case FondoCiencia.magnetismo:
        _grad(c, s, const [Color(0xFF311B92), Color(0xFF4527A0), Color(0xFF5E35B1)]);
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
        _flotan(c, s, u, ['🧲', '🧭', '📎', '🔩'], 0.05);
      case FondoCiencia.gravedad:
        _grad(c, s, const [Color(0xFF81D4FA), Color(0xFFE1F5FE)]);
        _montes(c, s, u, const Color(0xFFA5D6A7), 0.76, 0.1);
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
      case FondoCiencia.calor:
        _grad(c, s, const [Color(0xFFFFE0B2), Color(0xFFFFCC80), Color(0xFFFF8A65)]);
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
        _flotan(c, s, u, ['🌡️', '☕', '🔥', '🧊', '🍳'], 0.04);
      case FondoCiencia.energia:
        _grad(c, s, const [Color(0xFF4FC3F7), Color(0xFFE1F5FE)]);
        _montes(c, s, u, const Color(0xFF9CCC65), 0.72, 0.14);
        for (var k = 0; k < 3; k++) {
          _molino(c, Offset(s.width * (0.62 + k * 0.13), s.height * (0.58 + k * 0.03)), u * (0.8 + k * 0.1), fase: k.toDouble());
        }
        // Paneles solares
        for (var k = 0; k < 3; k++) {
          final r = Rect.fromLTWH(s.width * (0.06 + k * 0.1), s.height * 0.8, 8 * u, 5 * u);
          c.drawRect(r, relleno(const Color(0xFF1A237E)));
          c.drawLine(r.topCenter, r.bottomCenter, linea(const Color(0x88BBDEFB), 0.3 * u));
          c.drawLine(r.centerLeft, r.centerRight, linea(const Color(0x88BBDEFB), 0.3 * u));
        }
        dibujarEmoji(c, '☀️', Offset(s.width * 0.15, s.height * 0.14), 10 * u);
        _flotan(c, s, u, ['⚡', '💡', '🔋'], 0.03);
      case FondoCiencia.espacio:
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

  void _repisa(Canvas c, Size s, double u, double y, List<String> cosas) {
    c.drawRect(Rect.fromLTWH(0, s.height * y, s.width, 1.6 * u), relleno(const Color(0x66311B92)));
    for (var k = 0; k < cosas.length; k++) {
      dibujarEmoji(c, cosas[k], Offset(s.width * (0.1 + k * 0.2), s.height * y - 4 * u), 7 * u);
    }
  }

  void _burbujas(Canvas c, Size s, double u, Color col) {
    for (var k = 0; k < 14; k++) {
      final f = (t * 0.07 + k / 14) % 1;
      final x = s.width * ((k * 0.37) % 1) + math.sin(t * 1.5 + k) * 2 * u;
      c.drawCircle(Offset(x, s.height * (1 - f)), (1 + k % 3) * u, linea(col, 0.4 * u));
    }
  }

  void _vapor(Canvas c, Size s, double u, double x, double y) {
    for (var k = 0; k < 3; k++) {
      final f = (t * 0.4 + k / 3) % 1;
      c.drawCircle(Offset(x + math.sin(t * 2 + k) * 2 * u, y - f * 18 * u), (2 + f * 4) * u, relleno(Color.fromARGB((90 * (1 - f)).round(), 255, 255, 255)));
    }
  }

  void _flotan(Canvas c, Size s, double u, List<String> cosas, double alfa) {
    c.saveLayer(null, Paint()..color = Color.fromRGBO(255, 255, 255, 0.2 + alfa * 4));
    for (var k = 0; k < cosas.length; k++) {
      final p = Offset(s.width * (0.05 + (k * 0.23) % 0.9), s.height * (0.15 + (k * 0.31) % 0.5) + math.sin(t + k) * 2 * u);
      dibujarEmoji(c, cosas[k], p, 7 * u);
    }
    c.restore();
  }

  void _montes(Canvas c, Size s, double u, Color col, double base, double alt) {
    final p = Path()..moveTo(0, s.height);
    for (var x = 0.0; x <= s.width; x += 4 * u) {
      p.lineTo(x, s.height * base - (math.sin(x / s.width * 6 + base * 9) * 0.5 + 0.5) * alt * s.height);
    }
    p.lineTo(s.width, s.height);
    p.close();
    c.drawPath(p, relleno(col));
  }

  void _molino(Canvas c, Offset base, double u, {double fase = 0}) {
    c.drawLine(base, base - Offset(0, 22 * u), linea(Colors.white, 1.2 * u));
    final cen = base - Offset(0, 22 * u);
    for (var k = 0; k < 3; k++) {
      final a = t * 1.5 + fase + k * 2 * math.pi / 3;
      c.drawLine(cen, cen + Offset(math.cos(a), math.sin(a)) * 10 * u, linea(Colors.white, 1 * u)..strokeCap = StrokeCap.round);
    }
    c.drawCircle(cen, 1 * u, relleno(const Color(0xFFB0BEC5)));
  }

  @override
  bool shouldRepaint(_Pintor old) => old.t != t || old.tipo != tipo;
}
