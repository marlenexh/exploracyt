import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import '../biology/temas/motor.dart' show dibujarEmoji;
import 'profesiones_datos.dart';

/// Imagen animada de una profesión: una pequeña escena de su lugar de
/// trabajo que se mueve (en lugar de una tarjeta fija).
class EscenaAnimadaProfesion extends StatelessWidget {
  const EscenaAnimadaProfesion({super.key, required this.profesion, this.radio = 20});
  final ProfesionInfo profesion;
  final double radio;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(radio),
        child: Reloj(builder: (_, t) => CustomPaint(size: Size.infinite, painter: PintorEscenaProfesion(profesion, t))),
      );
}

/// Persona (sin indicar si es hombre o mujer) de cada escena.
const _personas = {
  EscenaProfesion.naturaleza: '🧑‍🌾',
  EscenaProfesion.adn: '🧑‍🔬',
  EscenaProfesion.salud: '🧑‍⚕️',
  EscenaProfesion.laboratorio: '🧑‍🔬',
  EscenaProfesion.comida: '🧑‍🍳',
  EscenaProfesion.atomos: '🧑‍🔬',
  EscenaProfesion.cerebro: '🧑‍⚕️',
  EscenaProfesion.computadora: '🧑‍💻',
  EscenaProfesion.taller: '🧑‍🔧',
  EscenaProfesion.fabrica: '🧑‍🏭',
  EscenaProfesion.construccion: '👷',
  EscenaProfesion.espacio: '🧑‍🚀',
  EscenaProfesion.energia: '🧑‍🔧',
  EscenaProfesion.datos: '🧑‍💻',
  EscenaProfesion.ia: '🧑‍💻',
  EscenaProfesion.red: '🧑‍🔧',
};

class PintorEscenaProfesion extends CustomPainter {
  PintorEscenaProfesion(this.p, this.t);
  final ProfesionInfo p;
  final double t;

  Paint _p(Color c) => Paint()..color = c;
  Paint _l(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height, u = math.min(w, h);
    final base = p.color;
    // Fondo con el color del área
    c.drawRect(
        Offset.zero & s,
        Paint()
          ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.lerp(base, Colors.white, 0.55)!, Color.lerp(base, Colors.white, 0.15)!]).createShader(Offset.zero & s));
    switch (p.escena) {
      case EscenaProfesion.naturaleza:
        c.drawCircle(Offset(w * 0.8, h * 0.2), u * 0.1, _p(const Color(0xFFFFD54F)));
        for (var k = 0; k < 8; k++) {
          final a = t * 0.6 + k * math.pi / 4;
          c.drawLine(Offset(w * 0.8, h * 0.2) + Offset.fromDirection(a, u * 0.13), Offset(w * 0.8, h * 0.2) + Offset.fromDirection(a, u * 0.18),
              _l(const Color(0xFFFFB300), u * 0.015));
        }
        c.drawOval(Rect.fromCenter(center: Offset(w * 0.3, h * 1.02), width: w * 1.0, height: h * 0.55), _p(const Color(0xFF66BB6A)));
        c.drawOval(Rect.fromCenter(center: Offset(w * 0.85, h * 1.05), width: w * 0.9, height: h * 0.5), _p(const Color(0xFF43A047)));
        for (var k = 0; k < 3; k++) {
          final x = w * (0.45 + k * 0.17), y = h * 0.78;
          final balanceo = math.sin(t * 2 + k) * u * 0.015;
          c.drawRect(Rect.fromCenter(center: Offset(x, y), width: u * 0.03, height: u * 0.12), _p(const Color(0xFF6D4C41)));
          c.drawCircle(Offset(x + balanceo, y - u * 0.1), u * 0.08, _p(const Color(0xFF2E7D32)));
        }
        dibujarEmoji(c, '🦋', Offset(w * (0.5 + 0.25 * math.sin(t * 0.8)), h * (0.35 + 0.08 * math.sin(t * 2.3))), u * 0.1);
      case EscenaProfesion.adn:
        c.drawRect(Offset.zero & s, _p(const Color(0x55000000)));
        for (var k = 0; k <= 24; k++) {
          final y = h * 0.08 + k * h * 0.84 / 24;
          final f = k * 0.5 + t * 2;
          final x1 = w * 0.6 + math.sin(f) * w * 0.17, x2 = w * 0.6 - math.sin(f) * w * 0.17;
          if (k.isEven) c.drawLine(Offset(x1, y), Offset(x2, y), _l(Colors.white54, u * 0.012));
          c.drawCircle(Offset(x1, y), u * 0.022, _p(math.cos(f) > 0 ? const Color(0xFF4FC3F7) : const Color(0xFF0288D1)));
          c.drawCircle(Offset(x2, y), u * 0.022, _p(math.cos(f) > 0 ? const Color(0xFFF06292) : const Color(0xFFC2185B)));
        }
      case EscenaProfesion.salud || EscenaProfesion.cerebro:
        // Monitor con el latido o la actividad del cerebro
        final r = Rect.fromLTWH(w * 0.36, h * 0.14, w * 0.58, h * 0.46);
        c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u * 0.04)), _p(const Color(0xFF102027)));
        final camino = Path();
        for (var k = 0; k <= 60; k++) {
          final x = r.left + r.width * k / 60;
          final fase = (k / 60 * 3 - t * 0.8) % 1;
          final pico = p.escena == EscenaProfesion.salud
              ? (fase > 0.45 && fase < 0.5 ? -0.8 : (fase > 0.5 && fase < 0.55 ? 0.5 : 0.0))
              : math.sin(k * 0.9 + t * 6) * 0.25 * math.sin(k * 0.13 + t);
          final y = r.center.dy + pico * r.height * 0.4;
          k == 0 ? camino.moveTo(x, y) : camino.lineTo(x, y);
        }
        c.drawPath(camino, _l(const Color(0xFF69F0AE), u * 0.012));
        if (p.escena == EscenaProfesion.cerebro) dibujarEmoji(c, '🧠', Offset(w * 0.65, h * 0.78), u * 0.2 * (1 + 0.05 * math.sin(t * 4)));
        if (p.escena == EscenaProfesion.salud) dibujarEmoji(c, '❤️', Offset(w * 0.66, h * 0.78), u * 0.16 * (1 + 0.12 * math.sin(t * 7).abs()));
      case EscenaProfesion.laboratorio || EscenaProfesion.comida:
        c.drawRect(Rect.fromLTWH(0, h * 0.78, w, h * 0.22), _p(const Color(0xFF8D6E63)));
        final matraz = Path()
          ..moveTo(w * 0.6, h * 0.3)
          ..lineTo(w * 0.6, h * 0.48)
          ..lineTo(w * 0.48, h * 0.78)
          ..lineTo(w * 0.86, h * 0.78)
          ..lineTo(w * 0.74, h * 0.48)
          ..lineTo(w * 0.74, h * 0.3)
          ..close();
        c.drawPath(matraz, _p(const Color(0x99E1F5FE)));
        c.drawPath(
            Path()
              ..moveTo(w * 0.53, h * 0.66)
              ..lineTo(w * 0.48, h * 0.78)
              ..lineTo(w * 0.86, h * 0.78)
              ..lineTo(w * 0.81, h * 0.66)
              ..close(),
            _p(p.escena == EscenaProfesion.comida ? const Color(0xFFFFB74D) : base));
        c.drawPath(matraz, _l(Colors.white, u * 0.012));
        for (var k = 0; k < 5; k++) {
          final f = (t * 0.6 + k / 5) % 1;
          c.drawCircle(Offset(w * (0.62 + 0.1 * math.sin(k * 2.0 + t)), h * (0.74 - f * 0.55)), u * 0.02 * (1 - f) + u * 0.006, _p(Colors.white70));
        }
        if (p.escena == EscenaProfesion.comida) {
          dibujarEmoji(c, '🍎', Offset(w * 0.9, h * 0.25 + math.sin(t * 2) * 4), u * 0.12);
          dibujarEmoji(c, '🥕', Offset(w * 0.4, h * 0.22 + math.sin(t * 2 + 1) * 4), u * 0.12);
        }
      case EscenaProfesion.atomos:
        c.drawRect(Offset.zero & s, _p(const Color(0x33000033)));
        final ce = Offset(w * 0.62, h * 0.45);
        for (var k = 0; k < 3; k++) {
          c.save();
          c.translate(ce.dx, ce.dy);
          c.rotate(k * math.pi / 3);
          c.drawOval(Rect.fromCenter(center: Offset.zero, width: u * 0.62, height: u * 0.2), _l(Colors.white70, u * 0.01));
          final a = t * (1.5 + k * 0.4) + k;
          c.drawCircle(Offset(math.cos(a) * u * 0.31, math.sin(a) * u * 0.1), u * 0.03, _p(const Color(0xFFFFEB3B)));
          c.restore();
        }
        c.drawCircle(ce, u * 0.07, _p(const Color(0xFFE53935)));
        c.drawCircle(ce + Offset(u * 0.03, -u * 0.02), u * 0.04, _p(const Color(0xFF1E88E5)));
      case EscenaProfesion.computadora || EscenaProfesion.datos || EscenaProfesion.ia:
        final r = Rect.fromLTWH(w * 0.34, h * 0.12, w * 0.6, h * 0.5);
        c.drawRRect(RRect.fromRectAndRadius(r.inflate(u * 0.015), Radius.circular(u * 0.04)), _p(const Color(0xFF37474F)));
        c.drawRect(r, _p(const Color(0xFF1E272C)));
        c.drawRect(Rect.fromLTWH(w * 0.58, h * 0.62, w * 0.12, h * 0.1), _p(const Color(0xFF37474F)));
        c.save();
        c.clipRect(r);
        if (p.escena == EscenaProfesion.computadora) {
          // Código que avanza
          const colores = [Color(0xFF4FC3F7), Color(0xFFFFD54F), Color(0xFFA5D6A7), Color(0xFFF48FB1)];
          for (var k = 0; k < 9; k++) {
            final y = r.top + ((k * 0.11 - t * 0.12) % 1.0) * r.height;
            final sangria = (k % 3) * u * 0.04;
            c.drawRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTWH(r.left + u * 0.03 + sangria, y, r.width * (0.3 + (k * 37 % 40) / 100), u * 0.025), Radius.circular(u * 0.01)),
                _p(colores[k % 4]));
          }
        } else if (p.escena == EscenaProfesion.datos) {
          for (var k = 0; k < 5; k++) {
            final alto = r.height * (0.25 + 0.5 * (0.5 + 0.5 * math.sin(t * 1.5 + k)));
            c.drawRect(Rect.fromLTWH(r.left + r.width * (0.08 + k * 0.18), r.bottom - alto, r.width * 0.12, alto),
                _p(const [Color(0xFF4FC3F7), Color(0xFFFFD54F), Color(0xFFA5D6A7), Color(0xFFF48FB1), Color(0xFFCE93D8)][k]));
          }
        } else {
          // Red neuronal con señales
          final capas = [3, 4, 2];
          Offset nodo(int i, int j) => Offset(r.left + r.width * (0.18 + i * 0.32), r.top + r.height * ((j + 1) / (capas[i] + 1)));
          for (var i = 0; i < 2; i++) {
            for (var a = 0; a < capas[i]; a++) {
              for (var b = 0; b < capas[i + 1]; b++) {
                c.drawLine(nodo(i, a), nodo(i + 1, b), _l(Colors.white24, u * 0.006));
                final f = (t * 0.7 + a * 0.3 + b * 0.2) % 1;
                c.drawCircle(Offset.lerp(nodo(i, a), nodo(i + 1, b), f)!, u * 0.012, _p(const Color(0xFFFFEB3B)));
              }
            }
          }
          for (var i = 0; i < 3; i++) {
            for (var j = 0; j < capas[i]; j++) {
              c.drawCircle(nodo(i, j), u * 0.028, _p(const Color(0xFFCE93D8)));
            }
          }
        }
        c.restore();
      case EscenaProfesion.taller:
        void engrane(Offset ce, double r, double giro, Color col) {
          final path = Path();
          for (var k = 0; k < 24; k++) {
            final a = giro + k * math.pi / 12;
            final rr = k.isEven ? r : r * 0.8;
            final pt = ce + Offset.fromDirection(a, rr);
            k == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
          }
          path.close();
          c.drawPath(path, _p(col));
          c.drawCircle(ce, r * 0.3, _p(Colors.white70));
        }
        engrane(Offset(w * 0.55, h * 0.45), u * 0.2, t, const Color(0xFF78909C));
        engrane(Offset(w * 0.55 + u * 0.33, h * 0.45 - u * 0.12), u * 0.13, -t * 1.5 + 0.13, const Color(0xFFFFA726));
        dibujarEmoji(c, '⚡', Offset(w * 0.85, h * 0.75), u * 0.1 * (0.8 + 0.4 * math.sin(t * 8).abs()));
      case EscenaProfesion.fabrica:
        c.drawRect(Rect.fromLTWH(w * 0.35, h * 0.32, w * 0.6, h * 0.36), _p(const Color(0xFF8D6E63)));
        for (var k = 0; k < 3; k++) {
          c.drawPath(
              Path()
                ..moveTo(w * (0.35 + k * 0.2), h * 0.32)
                ..lineTo(w * (0.45 + k * 0.2), h * 0.2)
                ..lineTo(w * (0.55 + k * 0.2), h * 0.32)
                ..close(),
              _p(const Color(0xFF6D4C41)));
        }
        for (var k = 0; k < 3; k++) {
          final f = (t * 0.3 + k / 3) % 1;
          c.drawCircle(Offset(w * 0.9 + f * w * 0.05, h * (0.18 - f * 0.15)), u * (0.03 + f * 0.04), _p(Colors.white.withValues(alpha: 0.6 * (1 - f))));
        }
        c.drawRect(Rect.fromLTWH(0, h * 0.78, w, h * 0.05), _p(const Color(0xFF455A64)));
        for (var k = 0; k < 4; k++) {
          final x = ((t * 0.15 + k / 4) % 1) * w;
          c.drawRect(Rect.fromLTWH(x, h * 0.7, u * 0.08, u * 0.08), _p(const Color(0xFFFFB74D)));
        }
      case EscenaProfesion.construccion:
        c.drawRect(Rect.fromLTWH(w * 0.7, h * 0.15, u * 0.03, h * 0.7), _p(const Color(0xFFFFB300)));
        c.drawRect(Rect.fromLTWH(w * 0.4, h * 0.15, w * 0.45, u * 0.03), _p(const Color(0xFFFFB300)));
        final xg = w * (0.5 + 0.08 * math.sin(t * 1.2));
        c.drawLine(Offset(xg, h * 0.17), Offset(xg, h * 0.45), _l(const Color(0xFF424242), u * 0.008));
        c.drawRect(Rect.fromCenter(center: Offset(xg, h * 0.48), width: u * 0.1, height: u * 0.06), _p(const Color(0xFFE53935)));
        final pisos = 2 + (t * 0.5).floor() % 3;
        for (var k = 0; k < pisos; k++) {
          c.drawRect(Rect.fromLTWH(w * 0.38, h * (0.82 - (k + 1) * 0.1), w * 0.24, h * 0.09), _p(k.isEven ? const Color(0xFF90A4AE) : const Color(0xFFB0BEC5)));
        }
        c.drawRect(Rect.fromLTWH(0, h * 0.82, w, h * 0.18), _p(const Color(0xFF8D6E63)));
      case EscenaProfesion.espacio:
        c.drawRect(Offset.zero & s, _p(const Color(0xCC0B1238)));
        for (var k = 0; k < 18; k++) {
          c.drawCircle(Offset((k * 53 % 100) / 100 * w, (k * 37 % 100) / 100 * h), u * 0.008 * (1 + math.sin(t * 3 + k).abs()), _p(Colors.white));
        }
        c.drawCircle(Offset(w * 0.85, h * 0.85), u * 0.18, _p(const Color(0xFF42A5F5)));
        final f = (t * 0.25) % 1;
        dibujarEmoji(c, '🚀', Offset(w * (0.45 + f * 0.45), h * (0.9 - f * 0.85)), u * 0.16);
      case EscenaProfesion.energia:
        c.drawCircle(Offset(w * 0.15, h * 0.18), u * 0.08, _p(const Color(0xFFFFD54F)));
        final ce = Offset(w * 0.65, h * 0.35);
        c.drawLine(ce, Offset(ce.dx, h * 0.92), _l(Colors.white, u * 0.025));
        for (var k = 0; k < 3; k++) {
          final a = t * 2.5 + k * 2 * math.pi / 3;
          c.drawLine(ce, ce + Offset.fromDirection(a, u * 0.24), _l(Colors.white, u * 0.03));
        }
        c.drawCircle(ce, u * 0.025, _p(const Color(0xFF90A4AE)));
        // Panel solar
        c.save();
        c.translate(w * 0.88, h * 0.78);
        c.skew(-0.4, 0);
        c.drawRect(Rect.fromCenter(center: Offset.zero, width: u * 0.22, height: u * 0.12), _p(const Color(0xFF1A237E)));
        c.drawRect(Rect.fromCenter(center: Offset.zero, width: u * 0.22, height: u * 0.12), _l(Colors.white70, u * 0.006));
        c.restore();
      case EscenaProfesion.red:
        final base0 = Offset(w * 0.62, h * 0.9);
        c.drawPath(
            Path()
              ..moveTo(base0.dx - u * 0.1, base0.dy)
              ..lineTo(base0.dx, h * 0.3)
              ..lineTo(base0.dx + u * 0.1, base0.dy),
            _l(const Color(0xFF546E7A), u * 0.015));
        for (var k = 0; k < 3; k++) {
          final f = (t * 0.6 + k / 3) % 1;
          final r = u * (0.08 + f * 0.35);
          c.drawArc(Rect.fromCircle(center: Offset(base0.dx, h * 0.3), radius: r), -math.pi * 0.85, math.pi * 0.7, false,
              _l(Colors.white.withValues(alpha: 1 - f), u * 0.012));
        }
        dibujarEmoji(c, '🛰️', Offset(w * 0.5 + math.cos(t * 0.6) * w * 0.35, h * 0.15 + math.sin(t * 0.6) * h * 0.05), u * 0.11);
    }
    // La herramienta principal flota arriba a la izquierda y la persona trabaja abajo
    dibujarEmoji(c, p.emoji, Offset(w * 0.16, h * 0.2 + math.sin(t * 2) * u * 0.02), u * 0.16);
    dibujarEmoji(c, _personas[p.escena]!, Offset(w * 0.2, h * 0.72 + math.sin(t * 3) * u * 0.008), u * 0.34);
  }

  @override
  bool shouldRepaint(PintorEscenaProfesion old) => true;
}
