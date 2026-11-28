import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// Biología · “Glóbulo blanco al ataque”: mueve al glóbulo blanco con el dedo
/// por el vaso sanguíneo y atrapa a los virus antes de que avancen por el
/// cuerpo. Los anticuerpos 🛡️ lo hacen más grande por un rato.
class Bicho {
  Bicho(this.pos, this.vel, {this.anticuerpo = false});
  Offset pos;
  final double vel;
  final bool anticuerpo;
}

class ModeloGlobulo extends ModeloJuego {
  static const meta = 15, infeccionMax = 5;
  Offset globulo = const Offset(120, 175);
  Offset destino = const Offset(120, 175);
  final bichos = <Bicho>[];
  int infeccion = 0;
  double _aparecer = 0, poder = 0, tiempo = 0;

  double get radio => poder > 0 ? 34 : 22;

  @override
  void reiniciar() {
    globulo = destino = const Offset(120, 175);
    bichos.clear();
    infeccion = 0;
    _aparecer = 0.5;
    poder = 0;
    tiempo = 0;
  }

  void moverA(Offset p) => destino = Offset(p.dx.clamp(20, anchoJuego - 20), p.dy.clamp(70, 280));

  @override
  void paso(double dt) {
    tiempo += dt;
    poder = math.max(0, poder - dt);
    // El glóbulo nada hacia el dedo
    final d = destino - globulo;
    final v = 260 * dt;
    globulo = d.distance <= v ? destino : globulo + d / d.distance * v;
    // Aparecen virus (y a veces anticuerpos) por la derecha
    _aparecer -= dt;
    if (_aparecer <= 0) {
      final rapido = 55 + math.min(tiempo, 40) * 2.2;
      final escudo = azar.nextDouble() < 0.12;
      bichos.add(Bicho(Offset(anchoJuego + 20, 80 + azar.nextDouble() * 190), rapido + azar.nextDouble() * 30, anticuerpo: escudo));
      _aparecer = math.max(0.55, 1.4 - tiempo * 0.015);
    }
    for (final b in [...bichos]) {
      b.pos = Offset(b.pos.dx - b.vel * dt, b.pos.dy + math.sin(tiempo * 3 + b.vel) * 20 * dt);
      if ((b.pos - globulo).distance < radio + 12) {
        bichos.remove(b);
        if (b.anticuerpo) {
          poder = 5;
          efecto(b.pos, const Color(0xFF42A5F5), '🛡️ ¡Anticuerpos!');
        } else {
          puntos++;
          efecto(b.pos, const Color(0xFF66BB6A), '+1');
          if (puntos >= meta) return terminar(true);
        }
        notifyListeners();
      } else if (b.pos.dx < -20) {
        bichos.remove(b);
        if (!b.anticuerpo) {
          infeccion++;
          errores++;
          efecto(const Offset(30, 175), const Color(0xFFE53935), '🤒');
          if (infeccion >= infeccionMax) return terminar(false);
          notifyListeners();
        }
      }
    }
  }

  @override
  int get estrellas => errores <= 1 ? 3 : (errores <= 3 ? 2 : 1);

  @override
  String get marcador =>
      '🦠 Virus atrapados: $puntos/$meta\n🤒 Infección: ${'🟥' * infeccion}${'⬜' * (infeccionMax - infeccion)}${poder > 0 ? '\n🛡️ ¡Anticuerpos activos!' : ''}';

  @override
  String get mensaje {
    if (terminado) {
      return gano
          ? '¡Defendiste el cuerpo! Los glóbulos blancos atrapan y destruyen a los microbios. A eso se le llama fagocitosis.'
          : 'Pasaron demasiados virus y el cuerpo se enfermó. ¡Inténtalo otra vez!';
    }
    if (!jugando) {
      return 'Eres un glóbulo blanco 🛡️. Arrastra el dedo para moverte y atrapa los virus 🦠 antes de que pasen. ¡Toca los anticuerpos para crecer!';
    }
    return poder > 0 ? '¡Los anticuerpos te ayudan! Ahora atrapas virus más fácilmente.' : 'Atrapa los virus 🦠. Si pasan 5, el cuerpo se enferma.';
  }
}

List<Component> capasGlobulo(ModeloGlobulo m) => [
      CapaJuego((c) {
        // El vaso sanguíneo
        c.drawRect(const Rect.fromLTWH(0, 55, anchoJuego, 240), Paint()..color = const Color(0x99B71C1C));
        c.drawRect(const Rect.fromLTWH(0, 45, anchoJuego, 12), Paint()..color = const Color(0xFFEF9A9A));
        c.drawRect(const Rect.fromLTWH(0, 293, anchoJuego, 12), Paint()..color = const Color(0xFFEF9A9A));
        // Glóbulos rojos que fluyen
        for (var k = 0; k < 9; k++) {
          final x = (anchoJuego + 60) - ((m.tiempo * 70 + k * 80) % (anchoJuego + 120));
          final y = 85.0 + (k * 37) % 190;
          c.drawOval(Rect.fromCenter(center: Offset(x, y), width: 26, height: 16), Paint()..color = const Color(0xFFE53935));
          c.drawOval(Rect.fromCenter(center: Offset(x, y), width: 12, height: 6), Paint()..color = const Color(0xFFC62828));
        }
        textoJuego(c, '← hacia el cuerpo', const Offset(80, 320), fondo: const Color(0x99000000));
      }),
      CapaJuego((c) {
        for (final b in m.bichos) {
          if (b.anticuerpo) {
            emojiEn(c, '🛡️', b.pos, 26);
            continue;
          }
          // Virus: bolita verde con picos
          final pico = Paint()
            ..color = const Color(0xFF2E7D32)
            ..strokeWidth = 3;
          for (var k = 0; k < 8; k++) {
            final a = k * math.pi / 4 + m.tiempo * 2;
            c.drawLine(b.pos + Offset(math.cos(a), math.sin(a)) * 10, b.pos + Offset(math.cos(a), math.sin(a)) * 17, pico);
          }
          c.drawCircle(b.pos, 11, Paint()..color = const Color(0xFF7CB342));
          c.drawCircle(b.pos + const Offset(-3, -3), 3, Paint()..color = const Color(0xFFC5E1A5));
        }
      }, priority: 5),
      ActorJuego(() => m.globulo, (c) {
        final r = m.radio + math.sin(m.tiempo * 6) * 1.5;
        if (m.poder > 0) c.drawCircle(Offset.zero, r + 8, Paint()..color = const Color(0x5542A5F5));
        c.drawCircle(Offset.zero, r, Paint()..color = const Color(0xFFF5F5F5));
        c.drawCircle(
            Offset.zero,
            r,
            Paint()
              ..color = const Color(0xFFBDBDBD)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
        c.drawCircle(const Offset(4, -2), r * 0.38, Paint()..color = const Color(0xFFB39DDB));
        // Ojitos
        c.drawCircle(Offset(-r * 0.3, -r * 0.2), 3, Paint()..color = Colors.black87);
        c.drawCircle(Offset(-r * 0.05, -r * 0.25), 3, Paint()..color = Colors.black87);
      }, priority: 10),
    ];
