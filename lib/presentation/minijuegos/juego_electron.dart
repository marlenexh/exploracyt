import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// Electrónica · “El viaje del electrón”: la corriente da vueltas por el
/// circuito. Cierra los interruptores que se abren y quita los cortocircuitos
/// antes de que lleguen. Cada vuelta enciende el foco.

// El circuito es un rectángulo; s es la distancia recorrida sobre él.
const _x0 = 70.0, _y0 = 70.0, _x1 = 540.0, _y1 = 290.0;
const _ancho = _x1 - _x0, _alto = _y1 - _y0;
const perimetro = 2 * (_ancho + _alto);

/// Punto del circuito a la distancia [s] (sentido de las manecillas, desde la pila).
Offset puntoCircuito(double s) {
  s %= perimetro;
  // Empieza en la pila (lado izquierdo, a la mitad) y sube.
  s = (s + _alto / 2 + _ancho + _alto + _ancho) % perimetro;
  if (s < _ancho) return Offset(_x0 + s, _y0);
  s -= _ancho;
  if (s < _alto) return Offset(_x1, _y0 + s);
  s -= _alto;
  if (s < _ancho) return Offset(_x1 - s, _y1);
  s -= _ancho;
  return Offset(_x0, _y1 - s);
}

class Interruptor {
  Interruptor(this.s);
  final double s;
  bool cerrado = true;
  Offset get pos => puntoCircuito(s);
}

class Corto {
  Corto(this.a, this.b, this.tiempo);
  final Offset a, b;
  double tiempo; // segundos antes de que la pila se caliente
}

class ModeloElectron extends ModeloJuego {
  static const meta = 8, vidasMax = 3;
  double s = 0, velocidad = 110, tiempo = 0, _abrir = 0, _corto = 0, detenido = 0;
  int vidas = vidasMax;
  final interruptores = <Interruptor>[];
  Corto? corto;
  double _ultimoS = 0;

  /// El foco está a la mitad del lado derecho.
  static const sFoco = _alto / 2 + _ancho + _alto / 2;

  @override
  void reiniciar() {
    s = _ultimoS = 0;
    velocidad = 110;
    tiempo = detenido = 0;
    vidas = vidasMax;
    interruptores
      ..clear()
      ..addAll([Interruptor(_alto / 2 + _ancho * 0.45), Interruptor(_alto / 2 + _ancho + _alto + _ancho * 0.55)]);
    corto = null;
    _abrir = 2.5;
    _corto = 6;
  }

  /// Toca un interruptor para cerrarlo o un cortocircuito para quitarlo.
  void tocar(Offset p) {
    if (!jugando) return;
    for (final i in interruptores) {
      if (!i.cerrado && (i.pos - p).distance < 36) {
        i.cerrado = true;
        efecto(i.pos, const Color(0xFF66BB6A), '¡Cerrado!');
        notifyListeners();
        return;
      }
    }
    final c = corto;
    if (c != null && _distanciaASegmento(p, c.a, c.b) < 26) {
      corto = null;
      efecto(Offset.lerp(c.a, c.b, 0.5)!, const Color(0xFF42A5F5), '¡Corto quitado!');
      notifyListeners();
    }
  }

  static double _distanciaASegmento(Offset p, Offset a, Offset b) {
    final ab = b - a;
    final t = (((p - a).dx * ab.dx + (p - a).dy * ab.dy) / (ab.distanceSquared)).clamp(0.0, 1.0);
    return (p - (a + ab * t)).distance;
  }

  @override
  void paso(double dt) {
    tiempo += dt;
    // Abre un interruptor de vez en cuando
    _abrir -= dt;
    if (_abrir <= 0) {
      final cerrados = interruptores.where((i) => i.cerrado).toList();
      if (cerrados.isNotEmpty) cerrados[azar.nextInt(cerrados.length)].cerrado = false;
      _abrir = math.max(1.6, 3.2 - tiempo * 0.03);
      notifyListeners();
    }
    // Aparece un cortocircuito: un cable que une arriba con abajo
    _corto -= dt;
    if (_corto <= 0 && corto == null) {
      final x = 150 + azar.nextDouble() * 300;
      corto = Corto(Offset(x, _y0), Offset(x + 30, _y1), 3.2);
      _corto = 7;
      notifyListeners();
    }
    final c = corto;
    if (c != null) {
      c.tiempo -= dt;
      if (c.tiempo <= 0) {
        corto = null;
        _perder(Offset.lerp(c.a, c.b, 0.5)!, '🔥 ¡Cortocircuito!');
        if (!jugando) return;
      }
    }
    if (detenido > 0) {
      detenido -= dt;
      return;
    }
    // El electrón avanza, salvo que llegue a un interruptor abierto
    final nuevo = s + velocidad * dt;
    for (final i in interruptores) {
      final si = _proximo(i.s, s);
      if (!i.cerrado && si > s && si <= nuevo + 4) {
        s = si - 6;
        i.cerrado = true;
        detenido = 1.2;
        _perder(i.pos, '⛔ ¡Circuito abierto!');
        return;
      }
    }
    s = nuevo;
    // ¿Pasó por el foco?
    if (_proximo(sFoco, _ultimoS) <= s) {
      puntos++;
      velocidad += 12;
      efecto(puntoCircuito(sFoco), const Color(0xFFFFEB3B), '💡 +1');
      if (puntos >= meta) return terminar(true);
      notifyListeners();
    }
    _ultimoS = s;
  }

  /// La siguiente vez (después de [desde]) que el electrón llega a la posición [pos].
  double _proximo(double pos, double desde) {
    final vuelta = (desde / perimetro).floor() * perimetro;
    var x = vuelta + pos;
    if (x <= desde) x += perimetro;
    return x;
  }

  void _perder(Offset donde, String texto) {
    vidas--;
    errores++;
    efecto(donde, const Color(0xFFE53935), texto);
    if (vidas <= 0) return terminar(false);
    notifyListeners();
  }

  @override
  int get estrellas => errores == 0 ? 3 : (errores == 1 ? 2 : 1);

  @override
  String get marcador => '💡 Vueltas: $puntos/$meta\n🔋 Vidas: ${'❤️' * vidas}${'🤍' * (vidasMax - vidas)}';

  @override
  String get mensaje {
    if (terminado) {
      return gano
          ? '¡Circuito perfecto! La corriente necesita un camino cerrado y sin cortocircuitos para encender el foco.'
          : '¡Ups! Se abrió el circuito o hubo un cortocircuito. ¡Inténtalo otra vez!';
    }
    if (!jugando) {
      return 'El electrón ⚡ da vueltas por el circuito. Toca los interruptores abiertos 🔴 para cerrarlos y toca los cables rojos de cortocircuito para quitarlos.';
    }
    if (corto != null) return '⚠️ ¡Un cortocircuito! Tócalo rápido antes de que la pila se caliente.';
    if (interruptores.any((i) => !i.cerrado)) return '🔴 ¡Un interruptor se abrió! Ciérralo antes de que llegue el electrón.';
    return '¡Bien! El camino está cerrado y la corriente llega al foco 💡.';
  }
}

List<Component> capasElectron(ModeloElectron m) => [
      CapaJuego((c) {
        final cable = Paint()
          ..color = const Color(0xFF2E7D32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..strokeJoin = StrokeJoin.round;
        c.drawRect(
            const Rect.fromLTRB(_x0, _y0, _x1, _y1),
            Paint()
              ..color = const Color(0xFF1B5E20)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 12);
        c.drawRect(const Rect.fromLTRB(_x0, _y0, _x1, _y1), cable);
        // Pila a la izquierda
        final pila = Rect.fromCenter(center: const Offset(_x0, (_y0 + _y1) / 2), width: 44, height: 70);
        c.drawRRect(RRect.fromRectAndRadius(pila, const Radius.circular(6)), Paint()..color = const Color(0xFF37474F));
        c.drawRect(Rect.fromLTWH(pila.left, pila.top + 20, pila.width, 28), Paint()..color = const Color(0xFFFFA000));
        textoJuego(c, '+', pila.topCenter + const Offset(0, 10), color: Colors.white);
        textoJuego(c, '9V', pila.center, tam: 12, color: Colors.white);
        // Foco a la derecha (brilla cuando pasa el electrón)
        final pf = puntoCircuito(ModeloElectron.sFoco);
        final cerca = (m.puntos > 0 && (puntoCircuito(m.s) - pf).distance < 60) ? 1.0 : 0.25;
        c.drawCircle(pf, 34, Paint()..color = Color.fromRGBO(255, 235, 59, 0.35 * cerca));
        c.drawCircle(pf, 20, Paint()..color = Color.lerp(const Color(0xFFCFD8DC), const Color(0xFFFFEB3B), cerca)!);
        c.drawRect(Rect.fromCenter(center: pf + const Offset(0, 24), width: 18, height: 12), Paint()..color = const Color(0xFF9E9E9E));
        textoJuego(c, 'Foco', pf + const Offset(-50, 0), tam: 12, fondo: const Color(0x99000000));
      }),
      CapaJuego((c) {
        for (final i in m.interruptores) {
          final p = i.pos;
          c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: p, width: 50, height: 26), const Radius.circular(8)),
              Paint()..color = i.cerrado ? const Color(0xFF43A047) : const Color(0xFFE53935));
          final palanca = Paint()
            ..color = Colors.white
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round;
          if (i.cerrado) {
            c.drawLine(p + const Offset(-16, 0), p + const Offset(16, 0), palanca);
          } else {
            c.drawLine(p + const Offset(-16, 0), p + const Offset(10, -16), palanca);
            textoJuego(c, '¡Tócame!', p + const Offset(0, -30), tam: 11, fondo: const Color(0xCCE53935));
          }
        }
        final co = m.corto;
        if (co != null) {
          final parpadeo = (math.sin(m.tiempo * 14) + 1) / 2;
          c.drawLine(
              co.a,
              co.b,
              Paint()
                ..color = Color.lerp(const Color(0xFFE53935), const Color(0xFFFFEB3B), parpadeo)!
                ..strokeWidth = 7);
          textoJuego(c, '⚡ ${co.tiempo.ceil()}', Offset.lerp(co.a, co.b, 0.5)!, tam: 14, fondo: const Color(0xCCB71C1C));
        }
      }, priority: 5),
      ActorJuego(() => puntoCircuito(m.s), (c) {
        c.drawCircle(Offset.zero, 16, Paint()..color = const Color(0x66FFEB3B));
        c.drawCircle(Offset.zero, 11, Paint()..color = const Color(0xFFFFEB3B));
        textoJuego(c, '−', Offset.zero, tam: 14, color: const Color(0xFF5D4037));
      }, priority: 10),
    ];
