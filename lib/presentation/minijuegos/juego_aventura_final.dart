import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import '../../data/brujula.dart';
import '../../data/worlds.dart';
import 'base.dart';

/// Aventura final · “Zati recupera la Brújula”: toca para que Zati vuele con
/// su globo, esquiva las nubes de tormenta y atrapa las 6 piezas de la
/// Brújula de la Ciencia, una de cada mundo.
class CosaVoladora {
  CosaVoladora(this.pos, {this.pieza});
  Offset pos;

  /// Índice de la pieza (null = nube de tormenta).
  final int? pieza;
}

Color colorMundo(String id) => mundos.firstWhere((m) => m.id == id).color;

class ModeloAventura extends ModeloJuego {
  static const vidasMax = 3;
  double y = 170, vy = 0, tiempo = 0, _nube = 0, _pieza = 0, inmune = 0;
  int vidas = vidasMax, siguientePieza = 0;
  final cosas = <CosaVoladora>[];
  static const xZati = 110.0;

  @override
  void reiniciar() {
    y = 170;
    vy = 0;
    tiempo = inmune = 0;
    _nube = 1.2;
    _pieza = 2.0;
    vidas = vidasMax;
    siguientePieza = 0;
    cosas.clear();
  }

  /// Un toque: Zati sube.
  void volar() {
    if (!jugando) return;
    vy = -210;
  }

  @override
  void paso(double dt) {
    tiempo += dt;
    inmune = math.max(0, inmune - dt);
    vy = math.min(vy + 520 * dt, 260);
    y += vy * dt;
    if (y < 30) {
      y = 30;
      vy = 0;
    }
    if (y > altoJuego - 30) {
      y = altoJuego - 30;
      vy = -160;
    }
    final vel = 150 + siguientePieza * 12.0;
    _nube -= dt;
    if (_nube <= 0) {
      cosas.add(CosaVoladora(Offset(anchoJuego + 40, 40 + azar.nextDouble() * (altoJuego - 80))));
      _nube = math.max(0.8, 1.5 - tiempo * 0.01);
    }
    _pieza -= dt;
    if (_pieza <= 0 && !cosas.any((c) => c.pieza != null) && siguientePieza < piezasBrujula.length) {
      cosas.add(CosaVoladora(Offset(anchoJuego + 40, 60 + azar.nextDouble() * (altoJuego - 120)), pieza: siguientePieza));
      _pieza = 2.2;
    }
    final zati = Offset(xZati, y);
    for (final c in [...cosas]) {
      c.pos = c.pos.translate(-vel * dt, c.pieza == null ? 0 : math.sin(tiempo * 3) * 30 * dt);
      final d = (c.pos - zati).distance;
      if (c.pieza != null && d < 38) {
        cosas.remove(c);
        siguientePieza++;
        puntos++;
        final p = piezasBrujula[c.pieza!];
        efecto(c.pos, colorMundo(p.mundo), '${p.emoji} ${p.nombre}');
        if (siguientePieza >= piezasBrujula.length) return terminar(true);
        notifyListeners();
      } else if (c.pieza == null && d < 36 && inmune <= 0) {
        cosas.remove(c);
        vidas--;
        errores++;
        inmune = 1.2;
        efecto(zati, const Color(0xFF90A4AE), '⛈️ ¡Tormenta!');
        if (vidas <= 0) return terminar(false);
        notifyListeners();
      } else if (c.pos.dx < -50) {
        cosas.remove(c);
      }
    }
  }

  @override
  int get estrellas => errores == 0 ? 3 : (errores == 1 ? 2 : 1);

  @override
  String get marcador => '🧭 Piezas: $siguientePieza/${piezasBrujula.length}\n${[
        for (var i = 0; i < piezasBrujula.length; i++) i < siguientePieza ? piezasBrujula[i].emoji : '❔'
      ].join(' ')}\n🎈 Vidas: ${'❤️' * vidas}${'🤍' * (vidasMax - vidas)}';

  @override
  String get mensaje {
    if (terminado) {
      return gano
          ? '🎉 ¡Recuperaste las 6 piezas en pleno vuelo! La Brújula de la Ciencia brilla otra vez gracias a todo lo que aprendiste.'
          : 'Las tormentas te alcanzaron. ¡Respira hondo y vuelve a volar!';
    }
    if (!jugando) {
      return '¡La aventura final! Toca la pantalla para que Zati vuele con su globo 🎈. Atrapa las 6 piezas de la Brújula y esquiva las nubes de tormenta ⛈️.';
    }
    final p = piezasBrujula[math.min(siguientePieza, piezasBrujula.length - 1)];
    return 'Busca la ${p.nombre} ${p.emoji} del mundo de ${p.nombreMundo}.';
  }
}

List<Component> capasAventura(ModeloAventura m) => [
      CapaJuego((c) {
        // Cielo con nubes que pasan
        c.drawRect(const Rect.fromLTWH(0, 0, anchoJuego, altoJuego), Paint()..color = const Color(0x5581D4FA));
        for (var k = 0; k < 6; k++) {
          final x = (anchoJuego + 80) - ((m.tiempo * (30 + k * 6) + k * 130) % (anchoJuego + 160));
          final y = 40.0 + (k * 57) % 260;
          for (final (dx, r) in const [(0.0, 18.0), (18.0, 24.0), (40.0, 17.0)]) {
            c.drawCircle(Offset(x + dx, y), r, Paint()..color = Colors.white.withValues(alpha: 0.55));
          }
        }
      }),
      CapaJuego((c) {
        for (final o in m.cosas) {
          if (o.pieza == null) {
            emojiEn(c, '⛈️', o.pos, 44);
          } else {
            final p = piezasBrujula[o.pieza!];
            final color = colorMundo(p.mundo);
            c.drawCircle(o.pos, 26 + math.sin(m.tiempo * 6) * 2, Paint()..color = color.withValues(alpha: 0.35));
            // Pieza en forma de rebanada de la brújula
            c.drawArc(Rect.fromCircle(center: o.pos + const Offset(0, 12), radius: 30), -math.pi / 2 - 0.5, 1.0, true, Paint()..color = color);
            emojiEn(c, p.emoji, o.pos, 18);
          }
        }
      }, priority: 5),
      ZatiConGlobo(m)..priority = 10,
    ];

/// Zati colgado de su globo. La imagen de Zati se carga como *sprite* de Flame.
class ZatiConGlobo extends PositionComponent {
  ZatiConGlobo(this.m);
  final ModeloAventura m;
  Sprite? _zati;

  @override
  Future<void> onLoad() async {
    try {
      _zati = await Sprite.load('biology/zati.png');
    } catch (_) {
      _zati = null; // si no carga, se dibuja un emoji
    }
  }

  @override
  void update(double dt) => position.setValues(ModeloAventura.xZati, m.y);

  @override
  void render(Canvas canvas) {
    final c = canvas;
    if (m.inmune > 0 && (m.tiempo * 12).floor().isEven) return;
    final hilo = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5;
    c.drawLine(const Offset(-6, -22), const Offset(0, -4), hilo);
    c.drawLine(const Offset(6, -22), const Offset(0, -4), hilo);
    c.drawOval(Rect.fromCenter(center: const Offset(0, -42), width: 40, height: 46), Paint()..color = const Color(0xFFFF7043));
    c.drawOval(Rect.fromCenter(center: const Offset(-8, -50), width: 10, height: 14), Paint()..color = Colors.white38);
    final z = _zati;
    if (z != null) {
      z.render(c, position: Vector2(-22, -6), size: Vector2(44, 52));
    } else {
      emojiEn(c, '🦌', const Offset(0, 14), 30);
    }
  }
}
