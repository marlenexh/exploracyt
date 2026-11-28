import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../ciencia/visor_3d.dart';
import '../electronica/comun.dart';

/// Simulación 3D: una red neuronal pequeña que decide si un animal es ave o
/// mamífero. El alumno marca las características del animal (entradas) y ve
/// cómo la señal viaja por las neuronas hasta la respuesta (salidas).
class SimRedNeuronal3D extends StatefulWidget {
  const SimRedNeuronal3D({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimRedNeuronal3D> createState() => SimRedNeuronal3DState();
}

/// Entradas de la red (características del animal).
const entradasRed = [('🪶', 'Tiene plumas'), ('🦅', 'Vuela'), ('🐾', 'Tiene pelo'), ('🍼', 'Toma leche de su mamá')];

/// Animales de ejemplo: características y lo que son en verdad.
const animalesRed = [
  ('🕊️', 'Paloma', [true, true, false, false], 'Ave'),
  ('🐄', 'Vaca', [false, false, true, true], 'Mamífero'),
  ('🐧', 'Pingüino', [true, false, false, false], 'Ave'),
  ('🦇', 'Murciélago', [false, true, true, true], 'Mamífero'),
];

// Pesos de la red (ya entrenada): 4 entradas → 5 neuronas ocultas → 2 salidas.
const _pesosOcultas = [
  [2.0, 0.5, -1.0, -1.0],
  [0.5, 2.0, 0.0, 0.0],
  [-1.0, 0.0, 2.0, 0.5],
  [-1.0, 0.0, 0.5, 2.0],
  [1.5, 0.0, -1.5, -1.5],
];
const _pesosSalida = [
  [2.0, 1.0, -2.0, -2.0, 2.0], // Ave
  [-2.0, 0.0, 2.0, 2.0, -2.0], // Mamífero
];

double _sig(double z) => 1 / (1 + math.exp(-z));

/// Calcula la red: activaciones de las capas oculta y de salida.
(List<double>, List<double>) calcularRed(List<bool> entradas) {
  final x = [for (final e in entradas) e ? 1.0 : 0.0];
  final h = [
    for (final w in _pesosOcultas) _sig(2.5 * ([for (var i = 0; i < 4; i++) w[i] * x[i]].reduce((a, b) => a + b) - 0.8)),
  ];
  final o = [
    for (final w in _pesosSalida) _sig([for (var j = 0; j < 5; j++) w[j] * h[j]].reduce((a, b) => a + b)),
  ];
  return (h, o);
}

/// Respuesta de la red: 'Ave', 'Mamífero' o null si no está segura.
String? respuestaRed(List<bool> entradas) {
  final (_, o) = calcularRed(entradas);
  if ((o[0] - o[1]).abs() < 0.25) return null;
  return o[0] > o[1] ? 'Ave' : 'Mamífero';
}

class SimRedNeuronal3DState extends State<SimRedNeuronal3D> {
  final entradas = [false, false, false, false];
  String? sel;
  String? animal;
  final capasVistas = <String>{};
  final logros = <int>{};
  bool _terminado = false;

  static const objetivos = [
    'Haz que la red diga «Ave»',
    'Haz que la red diga «Mamífero»',
    'Prueba con el murciélago 🦇',
    'Toca una neurona de cada capa',
  ];

  // Posiciones de las neuronas
  static V3 posEntrada(int i) => V3(-1.9, 1.2 - i * 0.8, 0);
  static V3 posOculta(int j) => V3(0, 1.6 - j * 0.8, 0);
  static V3 posSalida(int k) => V3(1.9, 0.4 - k * 0.8 + 0.4, 0);

  late final Escena3D escena = _crearEscena();

  Escena3D _crearEscena() {
    final objs = <Objeto3D>[];
    Objeto3D neurona(String id, V3 pos, Color color, {double r = 0.2, bool sel = true}) =>
        Objeto3D(id: id, malla: Malla.esfera(lat: 10, lon: 14), color: color, posicion: pos, escala: V3(r, r, r), brillo: 0.6, seleccionable: sel);
    // Conexiones
    for (var i = 0; i < 4; i++) {
      for (var j = 0; j < 5; j++) {
        objs.add(Objeto3D(
            id: 'conexion',
            malla: Malla.tubo([posEntrada(i), posOculta(j)], 0.012, segmentos: 4),
            color: _pesosOcultas[j][i] > 0 ? const Color(0xFF4FC3F7) : const Color(0xFFEF9A9A),
            seleccionable: false));
      }
    }
    for (var j = 0; j < 5; j++) {
      for (var k = 0; k < 2; k++) {
        objs.add(Objeto3D(
            id: 'conexion',
            malla: Malla.tubo([posOculta(j), posSalida(k)], 0.012, segmentos: 4),
            color: _pesosSalida[k][j] > 0 ? const Color(0xFF4FC3F7) : const Color(0xFFEF9A9A),
            seleccionable: false));
      }
    }
    // Neuronas (apagadas y encendidas)
    for (var i = 0; i < 4; i++) {
      objs
        ..add(neurona('entrada$i', posEntrada(i), const Color(0xFF78909C)))
        ..add(neurona('entrada${i}_on', posEntrada(i), const Color(0xFFFFEB3B), r: 0.215, sel: false));
    }
    for (var j = 0; j < 5; j++) {
      objs
        ..add(neurona('oculta$j', posOculta(j), const Color(0xFF7E57C2)))
        ..add(neurona('oculta${j}_on', posOculta(j), const Color(0xFFE1BEE7), r: 0.215, sel: false));
    }
    for (var k = 0; k < 2; k++) {
      objs
        ..add(neurona('salida$k', posSalida(k), const Color(0xFF26A69A), r: 0.28))
        ..add(neurona('salida${k}_on', posSalida(k), k == 0 ? const Color(0xFF64B5F6) : const Color(0xFFFFB74D), r: 0.295, sel: false));
    }
    return Escena3D(
      distancia: 7,
      fondo: const [Color(0xFF1A0B2E), Color(0xFF3B1E6B)],
      objetos: objs,
      particulas: (t) {
        final (h, o) = calcularRed(entradas);
        final ps = <Particula3D>[];
        for (var i = 0; i < 4; i++) {
          if (!entradas[i]) continue;
          for (var j = 0; j < 5; j++) {
            if (_pesosOcultas[j][i] <= 0) continue;
            final u = (t * 0.6 + i * 0.13 + j * 0.21) % 1;
            ps.add(Particula3D(V3.lerp(posEntrada(i), posOculta(j), u), const Color(0xFFFFF59D), 0.045));
          }
        }
        for (var j = 0; j < 5; j++) {
          if (h[j] < 0.5) continue;
          for (var k = 0; k < 2; k++) {
            if (_pesosSalida[k][j] <= 0) continue;
            final u = (t * 0.6 + j * 0.17 + k * 0.4) % 1;
            ps.add(Particula3D(V3.lerp(posOculta(j), posSalida(k), u), const Color(0xFFCE93D8), 0.05));
          }
        }
        for (var k = 0; k < 2; k++) {
          if (o[k] > 0.7) ps.add(Particula3D(posSalida(k), Color.fromRGBO(255, 255, 255, 0.25), 0.5));
        }
        return ps;
      },
    );
  }

  Map<String, double> get opacidad {
    final (h, o) = calcularRed(entradas);
    return {
      for (var i = 0; i < 4; i++) 'entrada${i}_on': entradas[i] ? 1 : 0,
      for (var j = 0; j < 5; j++) 'oculta${j}_on': h[j] > 0.5 ? h[j] : 0,
      for (var k = 0; k < 2; k++) 'salida${k}_on': o[k] > 0.5 ? o[k] : 0,
    };
  }

  static const _infoCapas = {
    'entrada': '🟡 Neurona de ENTRADA: recibe un dato, por ejemplo «¿tiene plumas?». Se enciende si la respuesta es sí.',
    'oculta':
        '🟣 Neurona OCULTA: junta las señales que le llegan. Las líneas azules suman (ayudan) y las rojas restan (frenan). Si suma lo suficiente, se enciende.',
    'salida': '🟢 Neurona de SALIDA: da la respuesta final de la red. La que más se enciende gana: «Ave» o «Mamífero».',
  };

  String get mensaje {
    if (sel != null) return _infoCapas[sel]!;
    if (logros.length == objetivos.length) return '¡Increíble! 🎉 Así “piensa” una red neuronal: suma señales capa por capa. Presiona «Terminar».';
    final r = respuestaRed(entradas);
    if (!entradas.contains(true)) {
      return 'Esta es una red neuronal en 3D: así “piensa” una IA. Marca abajo cómo es un animal (o elige uno) y mira cómo viaja la señal. ¡Gírala con el dedo!';
    }
    if (animal == 'Murciélago' && r == 'Mamífero') {
      return '🦇 ¡El murciélago vuela, pero tiene pelo y toma leche! La red lo clasificó como mamífero. ¡No se dejó engañar!';
    }
    if (r == null) return '🤔 La red no está segura: le faltan datos o los datos se contradicen. Prueba cambiando las características.';
    return 'La señal viajó de izquierda a derecha y la red decidió: ${r == 'Ave' ? '🐦 ¡es un AVE!' : '🐄 ¡es un MAMÍFERO!'}';
  }

  void alternar(int i) {
    HapticFeedback.selectionClick();
    setState(() {
      entradas[i] = !entradas[i];
      animal = null;
      sel = null;
      _revisar();
    });
  }

  void elegirAnimal(int a) {
    HapticFeedback.selectionClick();
    setState(() {
      final (_, nombre, caracteristicas, _) = animalesRed[a];
      for (var i = 0; i < 4; i++) {
        entradas[i] = caracteristicas[i];
      }
      animal = nombre;
      sel = null;
      _revisar();
    });
  }

  void tocar(String? id) {
    if (id == null) return setState(() => sel = null);
    final capa = id.startsWith('entrada')
        ? 'entrada'
        : id.startsWith('oculta')
            ? 'oculta'
            : id.startsWith('salida')
                ? 'salida'
                : null;
    if (capa == null) return;
    HapticFeedback.selectionClick();
    setState(() {
      sel = capa;
      capasVistas.add(capa);
      _revisar();
    });
  }

  void _revisar() {
    final r = respuestaRed(entradas);
    if (r == 'Ave') logros.add(0);
    if (r == 'Mamífero') logros.add(1);
    if (animal == 'Murciélago') logros.add(2);
    if (capasVistas.length == 3) logros.add(3);
  }

  void terminar() {
    if (_terminado) return;
    _terminado = true;
    terminarPaso(context,
        actividad: widget.actividad,
        estrellas: 3,
        titulo: '¡Red neuronal 3D!',
        mensaje: 'Las neuronas artificiales reciben datos, los suman con distintos pesos y pasan la señal a la siguiente capa hasta dar una respuesta.');
  }

  @override
  Widget build(BuildContext context) {
    final (_, o) = calcularRed(entradas);
    final total = o[0] + o[1];
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación 3D', 'Así piensa una red neuronal', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 170, child: GloboZatiEle(mensaje, tam: 12.5)),
        Positioned(
          left: 8,
          top: 236,
          width: 230,
          height: 238,
          child: PanelEle(
            titulo: 'Objetivos ${logros.length}/${objetivos.length}',
            icono: Icons.flag_rounded,
            color: widget.color,
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                for (var i = 0; i < objetivos.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Icon(logros.contains(i) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 18, color: logros.contains(i) ? ColoresJuego.correcto : Colors.black38),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Text(i == 3 ? '${objetivos[i]} (${capasVistas.length}/3)' : objetivos[i],
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.15))),
                    ]),
                  ),
                const SizedBox(height: 4),
                const Text('Animales:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
                Wrap(spacing: 4, runSpacing: 4, children: [
                  for (var a = 0; a < animalesRed.length; a++)
                    ChipEle(
                        texto: '${animalesRed[a].$1} ${animalesRed[a].$2}',
                        activo: animal == animalesRed[a].$2,
                        color: widget.color,
                        onTap: () => elegirAnimal(a)),
                ]),
              ]),
            ),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 300,
          child: Visor3D(
            escena: escena,
            opacidad: opacidad,
            seleccionado: sel == null ? null : '${sel}0',
            onTocar: tocar,
            yaw: 0.25,
            pitch: -0.15,
            etiquetas: {
              for (var i = 0; i < 4; i++) 'entrada$i': entradasRed[i].$1,
              'salida0': '🐦 Ave',
              'salida1': '🐄 Mamífero',
            },
            ayuda: 'Arrastra para girar · toca una neurona',
          ),
        ),
        Positioned(
          left: 244,
          top: 366,
          width: 608,
          child: Row(children: [
            Expanded(
              child: Wrap(spacing: 4, runSpacing: 4, children: [
                for (var i = 0; i < 4; i++)
                  ChipEle(texto: '${entradasRed[i].$1} ${entradasRed[i].$2}', activo: entradas[i], color: const Color(0xFFF9A825), onTap: () => alternar(i)),
              ]),
            ),
          ]),
        ),
        Positioned(
          left: 244,
          top: 430,
          width: 440,
          child: Text(
            !entradas.contains(true)
                ? 'Marca cómo es el animal 👆'
                : 'La red piensa: 🐦 Ave ${(o[0] / total * 100).round()}% · 🐄 Mamífero ${(o[1] / total * 100).round()}%',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(blurRadius: 4)]),
          ),
        ),
        if (logros.length == objetivos.length) Positioned(left: 690, top: 420, child: BotonSiguiente(texto: 'Terminar', onTap: terminar)),
        const BotonVolverEscena(),
      ],
    );
  }
}
