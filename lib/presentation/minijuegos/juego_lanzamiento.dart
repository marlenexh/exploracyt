import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// Física · “Lanza con gravedad”: como una resortera, arrastra hacia atrás
/// para lanzar la pelota y derribar las cajas. Cada nivel es en un lugar con
/// distinta gravedad: la Tierra, la Luna y Marte.
class LugarGravedad {
  const LugarGravedad(this.nombre, this.emoji, this.g, this.cielo, this.suelo, this.blancos);
  final String nombre, emoji;

  /// Gravedad en m/s² (se convierte a pixeles por segundo²).
  final double g;
  final Color cielo, suelo;
  final List<Offset> blancos;
}

const lugaresGravedad = [
  LugarGravedad('la Tierra', '🌍', 9.8, Color(0x5539A0E8), Color(0xFF6D4C41), [Offset(420, 300), Offset(470, 300), Offset(445, 268)]),
  LugarGravedad('la Luna', '🌕', 1.6, Color(0x55101030), Color(0xFF9E9E9E), [Offset(500, 300), Offset(540, 300), Offset(560, 190)]),
  LugarGravedad('Marte', '🔴', 3.7, Color(0x55E07A3C), Color(0xFFB0472A), [Offset(380, 300), Offset(520, 300), Offset(450, 230)]),
];

const _escala = 18.0; // pixeles por metro
const origenLanzamiento = Offset(70, 290);
const _radioPelota = 9.0, _caja = 30.0;

class ModeloLanzamiento extends ModeloJuego {
  int nivel = 0, tiros = 0;
  static const tirosPorNivel = 5;
  Offset? pelota, velocidad;
  Offset? jalon; // hacia dónde jala el dedo (resortera)
  final blancos = <Offset>[];

  LugarGravedad get lugar => lugaresGravedad[nivel];
  double get g => lugar.g * _escala;

  @override
  void reiniciar() {
    nivel = 0;
    _nivel();
  }

  void _nivel() {
    tiros = 0;
    pelota = velocidad = jalon = null;
    blancos
      ..clear()
      ..addAll(lugar.blancos);
  }

  /// Velocidad de salida según el jalón (más jalón, más fuerza).
  static Offset velocidadDe(Offset jalonActual) {
    var d = origenLanzamiento - jalonActual;
    final largo = d.distance;
    if (largo > 110) d = d / largo * 110;
    return d * 3.4;
  }

  void apuntar(Offset p) {
    if (!jugando || pelota != null) return;
    jalon = p;
    notifyListeners();
  }

  void soltar() {
    if (!jugando || pelota != null || jalon == null) return;
    final v = velocidadDe(jalon!);
    jalon = null;
    if (v.distance < 40) return;
    lanzar(v);
  }

  void lanzar(Offset v) {
    pelota = origenLanzamiento;
    velocidad = v;
    tiros++;
    notifyListeners();
  }

  /// Puntos de la trayectoria que seguiría la pelota (para la guía punteada).
  List<Offset> trayectoria(Offset v, {int n = 14, double cada = 0.12}) => [
        for (var i = 1; i <= n; i++) origenLanzamiento + v * (i * cada) + Offset(0, 0.5 * g * math.pow(i * cada, 2)),
      ];

  @override
  void paso(double dt) {
    final p = pelota, v = velocidad;
    if (p == null || v == null) return;
    final nv = v + Offset(0, g * dt);
    final np = p + nv * dt;
    pelota = np;
    velocidad = nv;
    for (final b in [...blancos]) {
      if ((np - b).distance < _caja / 2 + _radioPelota) {
        blancos.remove(b);
        puntos++;
        efecto(b, const Color(0xFFFFB300), '+1');
        notifyListeners();
      }
    }
    if (np.dy > 312 || np.dx > anchoJuego + 20 || np.dx < -20) _finTiro();
  }

  void _finTiro() {
    pelota = velocidad = null;
    if (blancos.isEmpty) {
      if (nivel < lugaresGravedad.length - 1) {
        nivel++;
        _nivel();
        efecto(const Offset(300, 120), const Color(0xFF66BB6A), '¡Siguiente: ${lugaresGravedad.length > nivel ? lugaresGravedad[nivel].nombre : ''}!');
      } else {
        terminar(true);
        return;
      }
    } else if (tiros >= tirosPorNivel) {
      errores++;
      terminar(false);
      return;
    }
    notifyListeners();
  }

  @override
  int get estrellas => errores == 0 ? 3 : 2;

  @override
  String get marcador =>
      '${lugar.emoji} Nivel ${nivel + 1}/3: ${lugar.nombre}\n📦 Cajas: ${lugar.blancos.length - blancos.length}/${lugar.blancos.length}\n🎾 Tiros: $tiros/$tirosPorNivel';

  @override
  String get mensaje {
    if (terminado) {
      return gano
          ? '¡Excelente puntería! Viste que con menos gravedad la pelota vuela mucho más lejos.'
          : 'Se acabaron los tiros. ¡Ajusta la fuerza y vuelve a intentarlo!';
    }
    if (!jugando) return 'Arrastra la pelota hacia atrás, como una resortera, y suéltala para lanzarla. ¡Derriba todas las cajas!';
    return 'Estás en ${lugar.emoji} ${lugar.nombre}: la gravedad es ${lugar.g} m/s². ${nivel == 0 ? '' : '¿Notas que la pelota cae más despacio?'}';
  }
}

List<Component> capasLanzamiento(ModeloLanzamiento m) => [
      CapaJuego((c) {
        final l = m.lugar;
        c.drawRect(const Rect.fromLTWH(0, 0, anchoJuego, altoJuego), Paint()..color = l.cielo);
        if (l.g < 2) {
          for (var k = 0; k < 30; k++) {
            c.drawCircle(Offset((k * 97) % anchoJuego, (k * 53) % 250), 1.2, Paint()..color = Colors.white70);
          }
        }
        c.drawRect(const Rect.fromLTWH(0, 315, anchoJuego, 40), Paint()..color = l.suelo);
        emojiEn(c, l.emoji, const Offset(560, 40), 34);
        textoJuego(c, 'Gravedad: ${l.g} m/s²', const Offset(110, 22), fondo: const Color(0x99000000));
        // Resortera
        final madera = Paint()
          ..color = const Color(0xFF6D4C41)
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round;
        c.drawLine(const Offset(70, 315), const Offset(70, 296), madera);
        c.drawLine(const Offset(70, 298), const Offset(58, 280), madera);
        c.drawLine(const Offset(70, 298), const Offset(82, 280), madera);
      }),
      CapaJuego((c) {
        for (final b in m.blancos) {
          final r = Rect.fromCenter(center: b, width: _caja, height: _caja);
          c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(4)), Paint()..color = const Color(0xFFFFB74D));
          c.drawRRect(
              RRect.fromRectAndRadius(r, const Radius.circular(4)),
              Paint()
                ..color = const Color(0xFF8D6E63)
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2.5);
          c.drawLine(r.topLeft, r.bottomRight, Paint()..color = const Color(0xFF8D6E63));
        }
        // Guía punteada y ligas de la resortera
        final j = m.jalon;
        if (j != null) {
          final liga = Paint()
            ..color = const Color(0xFF4E342E)
            ..strokeWidth = 3;
          c.drawLine(const Offset(58, 280), j, liga);
          c.drawLine(const Offset(82, 280), j, liga);
          for (final p in m.trayectoria(ModeloLanzamiento.velocidadDe(j))) {
            c.drawCircle(p, 3, Paint()..color = Colors.white70);
          }
          c.drawCircle(j, _radioPelota, Paint()..color = const Color(0xFFE53935));
        } else if (m.pelota == null && m.jugando) {
          c.drawCircle(origenLanzamiento, _radioPelota, Paint()..color = const Color(0xFFE53935));
        }
      }, priority: 5),
      ActorJuego(() => m.pelota, (c) {
        c.drawCircle(Offset.zero, _radioPelota, Paint()..color = const Color(0xFFE53935));
        c.drawCircle(const Offset(-3, -3), 3, Paint()..color = Colors.white54);
      }, priority: 10),
    ];
