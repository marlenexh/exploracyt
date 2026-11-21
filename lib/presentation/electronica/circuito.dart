import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// Modelo y simulación de circuitos de corriente directa, inspirado en los
/// componentes de Tinkercad Circuits. La solución usa análisis nodal: cada
/// terminal es un nodo, los cables son resistencias muy pequeñas y los LED se
/// modelan como interruptores ideales con una caída de voltaje.

enum TipoPieza {
  pila9v('Pila de 9 V', 'Fuente de energía: empuja la corriente del polo + al polo −.'),
  pila3v('Portapilas 3 V', 'Dos pilas AA juntas: dan 3 voltios.'),
  led('LED', 'Diodo emisor de luz. Solo enciende si la corriente entra por el ánodo (pata doblada, +).'),
  resistencia('Resistencia', 'Limita la corriente para proteger a otros componentes. Sus franjas de colores indican su valor.'),
  interruptor('Interruptor', 'Abre o cierra el circuito. Tócalo durante la simulación para cambiarlo.'),
  boton('Botón pulsador', 'Cierra el circuito solo mientras lo mantienes presionado.'),
  zumbador('Zumbador', 'Convierte la electricidad en sonido. Tiene polo + y polo −.'),
  motor('Motor CD', 'Convierte la electricidad en movimiento: su eje gira. Si inviertes la pila, gira al revés.'),
  foco('Foco', 'Bombilla que da luz cuando pasa corriente. No tiene polaridad.'),
  ldr('Fotorresistencia', 'Sensor de luz: con mucha luz deja pasar más corriente; a oscuras, casi nada.'),
  potenciometro('Potenciómetro', 'Resistencia que cambia al girar su perilla. La pata central es el limpiador.');

  const TipoPieza(this.nombre, this.descripcion);
  final String nombre, descripcion;
}

enum ColorLed {
  rojo('rojo', Color(0xFFE53935), 1.8),
  verde('verde', Color(0xFF43A047), 2.1),
  amarillo('amarillo', Color(0xFFFDD835), 2.0),
  azul('azul', Color(0xFF1E88E5), 3.0);

  const ColorLed(this.nombre, this.color, this.vf);
  final String nombre;
  final Color color;

  /// Voltaje necesario para encender.
  final double vf;
}

class Pieza {
  Pieza(
    this.id,
    this.tipo,
    this.pos, {
    this.ohms = 220,
    this.colorLed = ColorLed.rojo,
    this.cerrado = false,
    this.posicion = 0.5,
    this.editable = false,
    this.escala = 1,
  });

  /// Tamaño con el que se dibuja en el área de trabajo.
  final double escala;

  final String id;
  final TipoPieza tipo;

  /// Centro de la pieza en el área de trabajo.
  Offset pos;

  /// Resistencia (o resistencia total del potenciómetro).
  double ohms;
  ColorLed colorLed;

  /// Interruptor cerrado.
  bool cerrado;

  /// Perilla del potenciómetro (0 a 1).
  double posicion;

  /// Si el alumno puede cambiar su valor o color.
  final bool editable;

  bool presionado = false;
  bool quemado = false;

  int get nTerminales => tipo == TipoPieza.potenciometro ? 3 : 2;

  static const _offsets = <TipoPieza, List<Offset>>{
    TipoPieza.pila9v: [Offset(-12, -40), Offset(12, -40)],
    TipoPieza.pila3v: [Offset(-14, -36), Offset(14, -36)],
    TipoPieza.led: [Offset(9, 30), Offset(-9, 30)],
    TipoPieza.resistencia: [Offset(-36, 0), Offset(36, 0)],
    TipoPieza.interruptor: [Offset(-34, 0), Offset(34, 0)],
    TipoPieza.boton: [Offset(-30, 0), Offset(30, 0)],
    TipoPieza.zumbador: [Offset(-10, 32), Offset(10, 32)],
    TipoPieza.motor: [Offset(-12, 34), Offset(12, 34)],
    TipoPieza.foco: [Offset(-10, 32), Offset(10, 32)],
    TipoPieza.ldr: [Offset(-9, 28), Offset(9, 28)],
    TipoPieza.potenciometro: [Offset(-18, 32), Offset(0, 32), Offset(18, 32)],
  };

  List<Offset> get terminales => [for (final o in _offsets[tipo]!) pos + o * escala];

  List<String> get nombresTerminales => switch (tipo) {
        TipoPieza.pila9v || TipoPieza.pila3v || TipoPieza.zumbador => const ['+', '−'],
        TipoPieza.led => const ['Ánodo (+)', 'Cátodo (−)'],
        TipoPieza.potenciometro => const ['Extremo 1', 'Limpiador', 'Extremo 2'],
        TipoPieza.motor => const ['Terminal 1', 'Terminal 2'],
        _ => const ['Terminal 1', 'Terminal 2'],
      };

  /// Rectángulo aproximado para tocar la pieza.
  Rect get cuerpo {
    final (dx, dy, w, h) = switch (tipo) {
      TipoPieza.resistencia => (0.0, 0.0, 60.0, 22.0),
      TipoPieza.interruptor || TipoPieza.boton => (0.0, 0.0, 56.0, 40.0),
      TipoPieza.pila3v => (0.0, 4.0, 84.0, 54.0),
      TipoPieza.pila9v => (0.0, 6.0, 54.0, 80.0),
      _ => (0.0, 0.0, 50.0, 54.0),
    };
    return Rect.fromCenter(center: pos + Offset(dx, dy) * escala, width: w * escala, height: h * escala);
  }

  String terminal(int k) => '$id.$k';

  /// Resistencia de la fotorresistencia según la luz (0 oscuro, 1 mucha luz).
  static double ohmsLdr(double luz) => 200 * math.pow(500, 1 - luz.clamp(0, 1)).toDouble();
}

class Cable {
  const Cable(this.a, this.b, {this.color = const Color(0xFF2E7D32), this.fijo = false});
  final String a, b;
  final Color color;

  /// Cable puesto por el reto (no se puede quitar).
  final bool fijo;

  bool une(String x, String y) => (a == x && b == y) || (a == y && b == x);
}

class Resultado {
  Resultado(this.voltajes, this.corrientes, this.corrienteCables, this.corrientePilas, this.cortocircuito, this.quemadosAhora);

  /// Voltaje de cada terminal.
  final Map<String, double> voltajes;

  /// Corriente de cada pieza, del terminal 0 al 1 por dentro de la pieza
  /// (para el potenciómetro, del extremo 1 al limpiador).
  final Map<String, double> corrientes;

  /// Corriente de cada cable, de `a` hacia `b`.
  final List<double> corrienteCables;

  /// Corriente que entrega cada pila por su polo +.
  final Map<String, double> corrientePilas;
  final bool cortocircuito;

  /// LED que se quemaron en esta simulación.
  final Set<String> quemadosAhora;

  static final vacio = Resultado(const {}, const {}, const [], const {}, false, const {});

  double v(String terminal) => voltajes[terminal] ?? 0;
  double i(String pieza) => corrientes[pieza] ?? 0;
}

const _gCable = 100.0; // 0.01 Ω
const _gAbierto = 1e-9;
const _gFuga = 1e-7;
const _rLed = 10.0;
const _iQuema = 0.06; // 60 mA
const _iCorto = 1.5;

double _rPila(TipoPieza t) => t == TipoPieza.pila9v ? 1.0 : 0.5;
double _vPila(TipoPieza t) => t == TipoPieza.pila9v ? 9.0 : 3.0;

Resultado resolverCircuito(List<Pieza> piezas, List<Cable> cables, {double luz = 1}) {
  final idx = <String, int>{};
  for (final p in piezas) {
    for (var k = 0; k < p.nTerminales; k++) {
      idx[p.terminal(k)] = idx.length;
    }
  }
  final n = idx.length;
  final leds = [for (final p in piezas) if (p.tipo == TipoPieza.led) p];
  final encendido = {for (final l in leds) l.id: false};
  final quemadosAhora = <String>{};
  late List<double> v;

  List<double> resolver() {
    final a = List.generate(n, (_) => List.filled(n, 0.0));
    final b = List.filled(n, 0.0);
    void g(int i, int j, double gg, [double e = 0]) {
      a[i][i] += gg;
      a[j][j] += gg;
      a[i][j] -= gg;
      a[j][i] -= gg;
      b[i] += gg * e;
      b[j] -= gg * e;
    }

    for (var i = 0; i < n; i++) {
      a[i][i] += _gFuga;
    }
    for (final c in cables) {
      final i = idx[c.a], j = idx[c.b];
      if (i != null && j != null && i != j) g(i, j, _gCable);
    }
    for (final p in piezas) {
      final t0 = idx[p.terminal(0)]!, t1 = idx[p.terminal(1)]!;
      switch (p.tipo) {
        case TipoPieza.pila9v || TipoPieza.pila3v:
          g(t0, t1, 1 / _rPila(p.tipo), _vPila(p.tipo));
        case TipoPieza.led:
          if (encendido[p.id]! && !p.quemado) {
            g(t0, t1, 1 / _rLed, p.colorLed.vf);
          } else {
            g(t0, t1, _gAbierto);
          }
        case TipoPieza.resistencia:
          g(t0, t1, 1 / p.ohms);
        case TipoPieza.interruptor:
          g(t0, t1, p.cerrado ? 20 : _gAbierto);
        case TipoPieza.boton:
          g(t0, t1, p.presionado ? 20 : _gAbierto);
        case TipoPieza.zumbador:
          g(t0, t1, 1 / 300);
        case TipoPieza.motor:
          g(t0, t1, 1 / 50);
        case TipoPieza.foco:
          g(t0, t1, 1 / 90);
        case TipoPieza.ldr:
          g(t0, t1, 1 / Pieza.ohmsLdr(luz));
        case TipoPieza.potenciometro:
          final t2 = idx[p.terminal(2)]!;
          g(t0, t1, 1 / (1 + p.ohms * p.posicion));
          g(t1, t2, 1 / (1 + p.ohms * (1 - p.posicion)));
      }
    }
    return _gauss(a, b);
  }

  double vt(String t) => v[idx[t]!];

  for (var vuelta = 0; vuelta < 4; vuelta++) {
    for (var it = 0; it < 30; it++) {
      v = resolver();
      var cambio = false;
      for (final l in leds) {
        if (l.quemado) continue;
        final vak = vt(l.terminal(0)) - vt(l.terminal(1));
        final on = encendido[l.id]!;
        if (!on && vak > l.colorLed.vf + 1e-6) {
          encendido[l.id] = true;
          cambio = true;
        } else if (on && vak < l.colorLed.vf - 1e-6) {
          encendido[l.id] = false;
          cambio = true;
        }
      }
      if (!cambio) break;
    }
    // ¿Se quemó algún LED? (como la explosión de Tinkercad)
    var nuevo = false;
    for (final l in leds) {
      if (l.quemado || !encendido[l.id]!) continue;
      final i = (vt(l.terminal(0)) - vt(l.terminal(1)) - l.colorLed.vf) / _rLed;
      if (i > _iQuema) {
        l.quemado = true;
        encendido[l.id] = false;
        quemadosAhora.add(l.id);
        nuevo = true;
      }
    }
    if (!nuevo) break;
  }

  final corrientes = <String, double>{};
  final pilas = <String, double>{};
  var corto = false;
  for (final p in piezas) {
    final d = vt(p.terminal(0)) - vt(p.terminal(1));
    switch (p.tipo) {
      case TipoPieza.pila9v || TipoPieza.pila3v:
        final i = (_vPila(p.tipo) - d) / _rPila(p.tipo);
        pilas[p.id] = i;
        corrientes[p.id] = -i;
        if (i.abs() > _iCorto) corto = true;
      case TipoPieza.led:
        corrientes[p.id] = encendido[p.id]! && !p.quemado ? (d - p.colorLed.vf) / _rLed : 0;
      case TipoPieza.resistencia:
        corrientes[p.id] = d / p.ohms;
      case TipoPieza.interruptor:
        corrientes[p.id] = p.cerrado ? d * 20 : 0;
      case TipoPieza.boton:
        corrientes[p.id] = p.presionado ? d * 20 : 0;
      case TipoPieza.zumbador:
        corrientes[p.id] = d / 300;
      case TipoPieza.motor:
        corrientes[p.id] = d / 50;
      case TipoPieza.foco:
        corrientes[p.id] = d / 90;
      case TipoPieza.ldr:
        corrientes[p.id] = d / Pieza.ohmsLdr(luz);
      case TipoPieza.potenciometro:
        corrientes[p.id] = d / (1 + p.ohms * p.posicion);
    }
  }
  final enCables = [
    for (final c in cables)
      idx.containsKey(c.a) && idx.containsKey(c.b) ? (vt(c.a) - vt(c.b)) * _gCable : 0.0,
  ];
  return Resultado({for (final e in idx.entries) e.key: v[e.value]}, corrientes, enCables, pilas, corto, quemadosAhora);
}

List<double> _gauss(List<List<double>> a, List<double> b) {
  final n = b.length;
  for (var c = 0; c < n; c++) {
    var piv = c;
    for (var r = c + 1; r < n; r++) {
      if (a[r][c].abs() > a[piv][c].abs()) piv = r;
    }
    if (piv != c) {
      final t = a[c];
      a[c] = a[piv];
      a[piv] = t;
      final tb = b[c];
      b[c] = b[piv];
      b[piv] = tb;
    }
    final d = a[c][c];
    if (d.abs() < 1e-18) continue;
    for (var r = c + 1; r < n; r++) {
      final f = a[r][c] / d;
      if (f == 0) continue;
      for (var k = c; k < n; k++) {
        a[r][k] -= f * a[c][k];
      }
      b[r] -= f * b[c];
    }
  }
  final x = List.filled(n, 0.0);
  for (var r = n - 1; r >= 0; r--) {
    var s = b[r];
    for (var k = r + 1; k < n; k++) {
      s -= a[r][k] * x[k];
    }
    x[r] = a[r][r].abs() < 1e-18 ? 0 : s / a[r][r];
  }
  return x;
}

/// Lecturas fáciles de usar en los retos.
class EstadoCircuito {
  EstadoCircuito(this.piezas, this.cables, this.r, {this.luz = 1});
  final Map<String, Pieza> piezas;
  final List<Cable> cables;
  final Resultado r;
  final double luz;

  double corriente(String id) => r.i(id);
  double voltaje(String id) {
    final p = piezas[id]!;
    return r.v(p.terminal(0)) - r.v(p.terminal(1));
  }

  /// Brillo del LED (0 a 1). 20 mA es el brillo completo.
  double brillo(String id) => piezas[id]!.quemado ? 0 : (corriente(id) / 0.02).clamp(0, 1);
  bool encendido(String id) => brillo(id) > 0.05;
  bool quemado(String id) => piezas[id]!.quemado;

  /// LED conectado al revés: tiene voltaje en contra y no enciende.
  bool invertido(String id) => !quemado(id) && voltaje(id) < -1.0;

  /// Velocidad del motor (-1 a 1); el signo indica el sentido de giro.
  double velocidad(String id) => (corriente(id) / 0.15).clamp(-1, 1);
  bool gira(String id) => velocidad(id).abs() > 0.1;
  bool suena(String id) => corriente(id) > 0.003;
  double luzFoco(String id) => (corriente(id).abs() / 0.08).clamp(0, 1);
  bool get cortocircuito => r.cortocircuito;
}
