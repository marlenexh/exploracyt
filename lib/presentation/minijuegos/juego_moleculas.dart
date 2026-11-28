import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// Química · “Arma moléculas”: caen átomos; mueve el matraz y atrapa solo los
/// que necesitas para formar la molécula que se pide.
enum Atomo {
  h('H', 'hidrógeno', Color(0xFFF5F5F5), Color(0xFF263238), 13),
  o('O', 'oxígeno', Color(0xFFE53935), Colors.white, 16),
  c('C', 'carbono', Color(0xFF37474F), Colors.white, 16);

  const Atomo(this.simbolo, this.nombre, this.color, this.colorLetra, this.radio);
  final String simbolo, nombre;
  final Color color, colorLetra;
  final double radio;
}

class Molecula {
  const Molecula(this.formula, this.nombre, this.emoji, this.receta);
  final String formula, nombre, emoji;
  final Map<Atomo, int> receta;
}

const moleculas = [
  Molecula('H₂O', 'agua', '💧', {Atomo.h: 2, Atomo.o: 1}),
  Molecula('O₂', 'oxígeno que respiras', '💨', {Atomo.o: 2}),
  Molecula('CO₂', 'dióxido de carbono', '🌫️', {Atomo.c: 1, Atomo.o: 2}),
  Molecula('CH₄', 'metano (gas de la estufa)', '🔥', {Atomo.c: 1, Atomo.h: 4}),
];

class AtomoQueCae {
  AtomoQueCae(this.tipo, this.pos, this.vel);
  final Atomo tipo;
  Offset pos;
  final double vel;
}

class ModeloMoleculas extends ModeloJuego {
  int actual = 0;
  final tengo = <Atomo, int>{};
  final cayendo = <AtomoQueCae>[];
  double matraz = anchoJuego / 2, _aparecer = 0, tiempo = 0;
  static const yMatraz = 300.0;

  Molecula get molecula => moleculas[actual];

  @override
  void reiniciar() {
    actual = 0;
    tengo.clear();
    cayendo.clear();
    matraz = anchoJuego / 2;
    _aparecer = 0.3;
    tiempo = 0;
  }

  void moverA(Offset p) => matraz = p.dx.clamp(40, anchoJuego - 40);

  int falta(Atomo a) => (molecula.receta[a] ?? 0) - (tengo[a] ?? 0);

  @override
  void paso(double dt) {
    tiempo += dt;
    _aparecer -= dt;
    if (_aparecer <= 0) {
      // Con más frecuencia caen los átomos que hacen falta
      final faltan = [
        for (final a in Atomo.values)
          if (falta(a) > 0) a
      ];
      final tipo = faltan.isNotEmpty && azar.nextDouble() < 0.6 ? faltan[azar.nextInt(faltan.length)] : Atomo.values[azar.nextInt(3)];
      cayendo.add(AtomoQueCae(tipo, Offset(30 + azar.nextDouble() * (anchoJuego - 60), -20), 70 + azar.nextDouble() * 40 + actual * 12));
      _aparecer = 0.75;
    }
    for (final a in [...cayendo]) {
      a.pos = a.pos.translate(0, a.vel * dt);
      if (a.pos.dy > yMatraz - 18 && a.pos.dy < yMatraz + 8 && (a.pos.dx - matraz).abs() < 42) {
        cayendo.remove(a);
        atrapar(a.tipo, a.pos);
      } else if (a.pos.dy > altoJuego + 20) {
        cayendo.remove(a);
      }
    }
  }

  void atrapar(Atomo a, Offset donde) {
    if (falta(a) <= 0) {
      errores++;
      efecto(donde, const Color(0xFF9E9E9E), '¡No necesitas ${a.simbolo}!');
      notifyListeners();
      return;
    }
    tengo[a] = (tengo[a] ?? 0) + 1;
    efecto(donde, a.color, a.simbolo);
    if (molecula.receta.keys.every((x) => falta(x) == 0)) {
      puntos++;
      efecto(Offset(matraz, yMatraz - 40), const Color(0xFFFFD54F), '${molecula.emoji} ¡${molecula.formula}!');
      if (actual == moleculas.length - 1) return terminar(true);
      actual++;
      tengo.clear();
    }
    notifyListeners();
  }

  @override
  int get estrellas => errores <= 2 ? 3 : (errores <= 5 ? 2 : 1);

  String get receta => [for (final e in molecula.receta.entries) '${e.key.simbolo}: ${tengo[e.key] ?? 0}/${e.value}'].join('  ');

  @override
  String get marcador => '🧪 Molécula ${actual + 1}/${moleculas.length}: ${molecula.formula}\n$receta\n❌ Átomos de más: $errores';

  @override
  String get mensaje {
    if (terminado) return '¡Química pura! Los átomos se unen para formar moléculas: dos hidrógenos y un oxígeno forman el agua (H₂O).';
    if (!jugando) return 'Mueve el matraz 🧪 con el dedo y atrapa los átomos que caen. ¡Solo los que necesita la molécula!';
    final m = molecula;
    return 'Arma ${m.emoji} ${m.formula} (${m.nombre}): necesita ${[for (final e in m.receta.entries) '${e.value} de ${e.key.nombre}'].join(' y ')}.';
  }
}

void dibujarAtomo(Canvas c, Atomo a, Offset p, {double escala = 1}) {
  final r = a.radio * escala;
  c.drawCircle(p, r, Paint()..color = a.color);
  c.drawCircle(
      p,
      r,
      Paint()
        ..color = const Color(0x55000000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
  c.drawCircle(p + Offset(-r * 0.35, -r * 0.35), r * 0.25, Paint()..color = Colors.white54);
  textoJuego(c, a.simbolo, p, tam: 12 * escala, color: a.colorLetra);
}

List<Component> capasMoleculas(ModeloMoleculas m) => [
      CapaJuego((c) {
        // Receta de la molécula arriba
        final mol = m.molecula;
        textoJuego(c, '${mol.emoji} Arma: ${mol.formula}', const Offset(90, 22), tam: 15, fondo: const Color(0xCC4A148C));
        var x = 190.0;
        for (final e in mol.receta.entries) {
          for (var k = 0; k < e.value; k++) {
            final lleno = k < (m.tengo[e.key] ?? 0);
            if (lleno) {
              dibujarAtomo(c, e.key, Offset(x, 22), escala: 0.8);
            } else {
              c.drawCircle(
                  Offset(x, 22),
                  11,
                  Paint()
                    ..color = Colors.white70
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2);
              textoJuego(c, e.key.simbolo, Offset(x, 22), tam: 10, color: Colors.white70);
            }
            x += 30;
          }
        }
      }),
      CapaJuego((c) {
        for (final a in m.cayendo) {
          dibujarAtomo(c, a.tipo, a.pos);
        }
      }, priority: 5),
      ActorJuego(() => Offset(m.matraz, ModeloMoleculas.yMatraz), (c) {
        // Matraz con líquido y burbujas
        final cuerpo = Path()
          ..moveTo(-12, -26)
          ..lineTo(-12, -10)
          ..lineTo(-38, 26)
          ..lineTo(38, 26)
          ..lineTo(12, -10)
          ..lineTo(12, -26)
          ..close();
        c.drawPath(cuerpo, Paint()..color = const Color(0x99E1F5FE));
        final liquido = Path()
          ..moveTo(-24, 8)
          ..lineTo(-38, 26)
          ..lineTo(38, 26)
          ..lineTo(24, 8)
          ..close();
        c.drawPath(liquido, Paint()..color = const Color(0xCC7E57C2));
        c.drawPath(
            cuerpo,
            Paint()
              ..color = Colors.white
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5);
        for (var k = 0; k < 3; k++) {
          c.drawCircle(Offset(-10 + k * 10.0, 18 - ((m.tiempo * 30 + k * 7) % 14)), 2.5, Paint()..color = Colors.white70);
        }
        // Átomos ya atrapados, flotando sobre el matraz
        var i = 0;
        for (final e in m.tengo.entries) {
          for (var k = 0; k < e.value; k++) {
            dibujarAtomo(c, e.key, Offset(-24 + i * 16.0, -38 + math.sin(m.tiempo * 4 + i) * 2), escala: 0.6);
            i++;
          }
        }
      }, priority: 10),
    ];
