import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// Programación · “Plataformas con bloques”: arma el programa del robot
/// (caminar, saltar, repetir) para que esquive hoyos y picos y llegue a la
/// bandera. El robot ejecuta las instrucciones una por una.
enum Bloque {
  caminar('➡️', 'Caminar', 1),
  saltar('⤴️', 'Saltar', 2),
  repetir('🔁', 'Repite 3: caminar', 3);

  const Bloque(this.emoji, this.nombre, this.avance);
  final String emoji, nombre;
  final int avance;
}

enum Casilla { suelo, hoyo, picos }

class NivelPlataformas {
  const NivelPlataformas(this.casillas, this.meta, this.pista);
  final List<Casilla> casillas;
  final int meta;
  final String pista;
}

const _s = Casilla.suelo, _h = Casilla.hoyo, _p = Casilla.picos;
const nivelesPlataformas = [
  NivelPlataformas([_s, _s, _s, _h, _s, _s, _s, _s, _s, _s, _s, _s], 6, 'Hay un hoyo: camina hasta la orilla y salta sobre él.'),
  NivelPlataformas([_s, _s, _p, _s, _s, _h, _s, _s, _s, _s, _s, _s], 8, 'Salta los picos y también el hoyo. ¡Cuenta las casillas!'),
  NivelPlataformas([_s, _s, _s, _s, _h, _s, _s, _s, _h, _s, _s, _s], 11, 'Usa 🔁 «Repite 3» para caminar menos bloques. ¡Hay dos hoyos!'),
];

const anchoCasilla = 50.0, ySuelo = 270.0;
double xCasilla(int i) => 25 + i * anchoCasilla;

class ModeloPlataformas extends ModeloJuego {
  int nivel = 0;
  final programa = <Bloque>[];

  /// Movimientos simples (cada repetir se convierte en 3 pasos de caminar).
  List<Bloque> pasos = [];
  int paso_ = -1; // paso que se está ejecutando
  double avance = 0; // 0..1 dentro del paso
  int casilla = 0;
  bool ejecutando = false, cayendo = false;
  double caida = 0, tiempo = 0;
  String? aviso;

  NivelPlataformas get n => nivelesPlataformas[nivel];

  @override
  void reiniciar() {
    nivel = 0;
    _nivel();
  }

  void _nivel() {
    programa.clear();
    _reset();
    aviso = null;
  }

  void _reset() {
    pasos = [];
    paso_ = -1;
    avance = 0;
    casilla = 0;
    ejecutando = cayendo = false;
    caida = 0;
  }

  void agregar(Bloque b) {
    if (!jugando || ejecutando || programa.length >= 10) return;
    programa.add(b);
    aviso = null;
    notifyListeners();
  }

  void borrar() {
    if (ejecutando || programa.isEmpty) return;
    programa.removeLast();
    notifyListeners();
  }

  void ejecutar() {
    if (!jugando || ejecutando || programa.isEmpty) return;
    _reset();
    pasos = [
      for (final b in programa) ...(b == Bloque.repetir ? List.filled(3, Bloque.caminar) : [b])
    ];
    ejecutando = true;
    paso_ = 0;
    aviso = null;
    notifyListeners();
  }

  /// Resultado de un programa sin animación: (casilla final, falló).
  static (int, bool) simular(NivelPlataformas n, List<Bloque> prog) {
    var c = 0;
    for (final b in prog) {
      final pasos = b == Bloque.repetir ? List.filled(3, Bloque.caminar) : [b];
      for (final p in pasos) {
        c += p.avance;
        if (c >= n.casillas.length || n.casillas[c] != Casilla.suelo) return (c, true);
      }
    }
    return (c, false);
  }

  /// Posición del robot (centro de los pies).
  Offset get robot {
    if (cayendo) return Offset(xCasilla(casilla), ySuelo + caida);
    if (!ejecutando || paso_ < 0 || paso_ >= pasos.length) return Offset(xCasilla(casilla), ySuelo);
    final b = pasos[paso_];
    final x = xCasilla(casilla) + b.avance * anchoCasilla * avance;
    final y = b == Bloque.saltar ? ySuelo - math.sin(avance * math.pi) * 70 : ySuelo - (math.sin(avance * math.pi * 2).abs() * 4);
    return Offset(x, y);
  }

  @override
  void paso(double dt) {
    tiempo += dt;
    if (cayendo) {
      caida += dt * 260;
      if (caida > 120) {
        cayendo = false;
        ejecutando = false;
        casilla = 0;
        caida = 0;
        notifyListeners();
      }
      return;
    }
    if (!ejecutando) return;
    final b = pasos[paso_];
    avance += dt / (b == Bloque.saltar ? 0.7 : 0.45);
    if (avance < 1) return;
    avance = 0;
    casilla += b.avance;
    final c = casilla < n.casillas.length ? n.casillas[casilla] : Casilla.hoyo;
    if (c != Casilla.suelo) {
      errores++;
      aviso = c == Casilla.hoyo ? '🕳️ ¡Se cayó en un hoyo! Revisa tu programa: ¿dónde debía saltar?' : '🌵 ¡Pisó los picos! Necesitaba saltar antes.';
      efecto(Offset(xCasilla(math.min(casilla, 11)), ySuelo), const Color(0xFFE53935), '¡Ay!');
      cayendo = c == Casilla.hoyo;
      if (!cayendo) {
        ejecutando = false;
        casilla = 0;
      }
      notifyListeners();
      return;
    }
    paso_++;
    if (paso_ >= pasos.length) {
      ejecutando = false;
      if (casilla == n.meta) {
        puntos++;
        efecto(Offset(xCasilla(casilla), ySuelo - 40), const Color(0xFFFFD54F), '🏁 ¡Meta!');
        if (nivel == nivelesPlataformas.length - 1) return terminar(true);
        nivel++;
        _nivel();
        aviso = '¡Muy bien! Nivel ${nivel + 1}: ${n.pista}';
      } else {
        errores++;
        aviso = casilla < n.meta
            ? '🤔 El robot se quedó antes de la bandera. ¿Qué instrucción falta?'
            : '🤔 El robot se pasó de la bandera. ¿Qué instrucción sobra?';
        casilla = 0;
      }
    }
    notifyListeners();
  }

  @override
  int get estrellas => errores <= 1 ? 3 : (errores <= 4 ? 2 : 1);

  @override
  String get marcador =>
      '🏁 Nivel ${nivel + 1}/${nivelesPlataformas.length}\n🧩 Programa: ${programa.isEmpty ? '(vacío)' : programa.map((b) => b.emoji).join(' ')}\n❌ Intentos fallidos: $errores';

  @override
  String get mensaje {
    if (terminado) return '¡Programaste al robot para superar los 3 niveles! Un programa es una secuencia de instrucciones y el orden importa.';
    if (!jugando) return 'Arma el programa con los bloques de abajo y presiona ▶ Ejecutar. El robot hace exactamente lo que le digas, ¡ni más ni menos!';
    return aviso ?? '💡 ${n.pista}';
  }
}

List<Component> capasPlataformas(ModeloPlataformas m) => [
      CapaJuego((c) {
        // Cielo suave para que los bloques del fondo del mundo no parezcan plataformas
        c.drawRect(const Rect.fromLTWH(0, 0, anchoJuego, altoJuego), Paint()..color = const Color(0xCCE3F2FD));
        final n = m.n;
        for (var i = 0; i < n.casillas.length; i++) {
          final x = xCasilla(i) - anchoCasilla / 2;
          final cas = n.casillas[i];
          if (cas != Casilla.hoyo) {
            c.drawRect(Rect.fromLTWH(x + 1, ySuelo, anchoCasilla - 2, 14), Paint()..color = const Color(0xFF66BB6A));
            c.drawRect(Rect.fromLTWH(x + 1, ySuelo + 14, anchoCasilla - 2, 66), Paint()..color = const Color(0xFF8D6E63));
          }
          if (cas == Casilla.picos) {
            for (var k = 0; k < 4; k++) {
              final px = x + 6 + k * 10.0;
              c.drawPath(
                  Path()
                    ..moveTo(px, ySuelo)
                    ..lineTo(px + 5, ySuelo - 16)
                    ..lineTo(px + 10, ySuelo)
                    ..close(),
                  Paint()..color = const Color(0xFF90A4AE));
            }
          }
          textoJuego(c, '$i', Offset(xCasilla(i), ySuelo + 40), tam: 11, color: Colors.white);
        }
        // Bandera
        final fx = xCasilla(n.meta);
        c.drawLine(
            Offset(fx, ySuelo),
            Offset(fx, ySuelo - 70),
            Paint()
              ..color = Colors.white
              ..strokeWidth = 3);
        c.drawPath(
            Path()
              ..moveTo(fx, ySuelo - 70)
              ..lineTo(fx + 30, ySuelo - 60 + math.sin(m.tiempo * 5) * 3)
              ..lineTo(fx, ySuelo - 50)
              ..close(),
            Paint()..color = const Color(0xFFE53935));
      }),
      ActorJuego(() => m.robot, (c) {
        // Robot de perfil, mirando a la derecha
        c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-13, -38, 26, 24), const Radius.circular(5)), Paint()..color = const Color(0xFF42A5F5));
        c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-11, -58, 22, 18), const Radius.circular(5)), Paint()..color = const Color(0xFFE3F2FD));
        c.drawCircle(const Offset(5, -50), 3, Paint()..color = Colors.black87);
        c.drawLine(
            const Offset(0, -58),
            const Offset(0, -66),
            Paint()
              ..color = const Color(0xFF90A4AE)
              ..strokeWidth = 2);
        c.drawCircle(const Offset(0, -67), 3, Paint()..color = const Color(0xFFE53935));
        c.drawCircle(const Offset(-7, -8), 7, Paint()..color = const Color(0xFF37474F));
        c.drawCircle(const Offset(7, -8), 7, Paint()..color = const Color(0xFF37474F));
      }, priority: 10),
    ];
