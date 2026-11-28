import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../ciencia/visor_3d.dart';
import '../electronica/comun.dart';

/// Simulación 3D: el alumno arma un programa (avanzar, girar) y un robot lo
/// ejecuta paso a paso sobre un tablero 3D hasta llegar a la estrella.
class SimRobot3D extends StatefulWidget {
  const SimRobot3D({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimRobot3D> createState() => SimRobot3DState();
}

enum Orden {
  avanzar('⬆️', 'Avanzar'),
  izquierda('↪️', 'Girar a la izquierda'),
  derecha('↩️', 'Girar a la derecha');

  const Orden(this.emoji, this.nombre);
  final String emoji, nombre;
}

/// Un nivel: casilla de salida (columna, fila), meta y obstáculos.
class NivelRobot3D {
  const NivelRobot3D(this.titulo, this.meta, this.obstaculos, this.pista);
  final String titulo, pista;
  final (int, int) meta;
  final List<(int, int)> obstaculos;
}

const nivelesRobot3D = [
  NivelRobot3D('Nivel 1: derecho a la estrella', (3, 0), [], 'La estrella está derecho, a 3 casillas. ¿Cuántas veces debe avanzar?'),
  NivelRobot3D('Nivel 2: da la vuelta', (2, 2), [], 'Avanza, luego gira hacia abajo y vuelve a avanzar. ¡Cuenta las casillas!'),
  NivelRobot3D('Nivel 3: esquiva las rocas', (4, 2), [(2, 0), (2, 1)], 'Hay rocas en el camino. Baja antes de llegar a ellas y luego sigue derecho.'),
];

const _n = 5; // tablero de 5 × 5
const _tam = 0.8;

/// Direcciones: 0 = derecha, 1 = abajo, 2 = izquierda, 3 = arriba (vistas desde arriba).
const _pasos = [(1, 0), (0, 1), (-1, 0), (0, -1)];
const _angulos = [math.pi / 2, math.pi, -math.pi / 2, 0.0];

V3 _centro(int c, int f) => V3((c - (_n - 1) / 2) * _tam, 0, ((_n - 1) / 2 - f) * _tam);

/// Ejecuta el programa sin animación: posiciones por paso y si chocó.
(List<(int, int, int)>, bool) recorrerRobot(NivelRobot3D nivel, List<Orden> programa) {
  var c = 0, f = 0, d = 0;
  final recorrido = [(c, f, d)];
  for (final o in programa) {
    switch (o) {
      case Orden.izquierda:
        d = (d + 3) % 4;
      case Orden.derecha:
        d = (d + 1) % 4;
      case Orden.avanzar:
        final (dc, df) = _pasos[d];
        final nc = c + dc, nf = f + df;
        if (nc < 0 || nf < 0 || nc >= _n || nf >= _n || nivel.obstaculos.contains((nc, nf))) {
          return (recorrido, true);
        }
        c = nc;
        f = nf;
    }
    recorrido.add((c, f, d));
  }
  return (recorrido, false);
}

class SimRobot3DState extends State<SimRobot3D> with SingleTickerProviderStateMixin {
  int nivel = 0;
  final programa = <Orden>[];
  bool ejecutando = false, logrado = false, _terminado = false;
  int errores = 0;
  String? aviso;

  // Animación: del estado [_de] al [_a] según [_anim].
  late final AnimationController _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 550));
  (int, int, int) _de = (0, 0, 0), _a = (0, 0, 0);
  bool _choque = false;
  Timer? _timer;

  NivelRobot3D get n => nivelesRobot3D[nivel];

  late final Escena3D escena = _crearEscena();

  V3 get _posRobot {
    final u = Curves.easeInOut.transform(_anim.value);
    final p = V3.lerp(_centro(_de.$1, _de.$2), _centro(_a.$1, _a.$2), u);
    final salto = _choque ? 0.0 : 0.08 * math.sin(u * math.pi);
    return p + V3(0, salto, 0);
  }

  double get _angRobot {
    final a = _angulos[_de.$3], b = _angulos[_a.$3];
    var dif = b - a;
    while (dif > math.pi) {
      dif -= 2 * math.pi;
    }
    while (dif < -math.pi) {
      dif += 2 * math.pi;
    }
    return a + dif * Curves.easeInOut.transform(_anim.value);
  }

  Escena3D _crearEscena() {
    final objs = <Objeto3D>[];
    for (var c = 0; c < _n; c++) {
      for (var f = 0; f < _n; f++) {
        objs.add(Objeto3D(
          id: 'piso',
          malla: mallaCaja(),
          color: (c + f).isEven ? const Color(0xFF81C784) : const Color(0xFF66BB6A),
          escala: const V3(_tam / 2 - 0.02, 0.06, _tam / 2 - 0.02),
          posicion: _centro(c, f) + const V3(0, -0.06, 0),
          seleccionable: false,
        ));
      }
    }
    // Rocas de cada nivel (se muestran según el nivel)
    for (var k = 0; k < nivelesRobot3D.length; k++) {
      for (final (c, f) in nivelesRobot3D[k].obstaculos) {
        objs.add(Objeto3D(
          id: 'roca$k',
          malla: Malla.esfera(lat: 6, lon: 7),
          color: const Color(0xFF8D6E63),
          escala: const V3(0.3, 0.26, 0.3),
          posicion: _centro(c, f) + const V3(0, 0.18, 0),
        ));
      }
      final (mc, mf) = nivelesRobot3D[k].meta;
      objs.add(Objeto3D(
        id: 'meta$k',
        malla: Malla.esfera(lat: 8, lon: 5),
        color: const Color(0xFFFFD54F),
        escala: const V3(0.22, 0.22, 0.08),
        posicion: _centro(mc, mf) + const V3(0, 0.45, 0),
        brillo: 0.9,
        giro: (t) => V3(0, t * 2, 0),
        desplazamiento: (t) => V3(0, 0.05 * math.sin(t * 3), 0),
      ));
    }
    // El robot: cuerpo, cabeza, ojos, antena y ruedas
    V3 mov(double t) => _posRobot;
    V3 gir(double t) => V3(0, _angRobot, 0);
    Objeto3D pieza(Malla m, Color color, V3 escala, V3 pos, {double brillo = 0.5}) => Objeto3D(
          id: 'robot',
          malla: m.escalar(escala).mover(pos),
          color: color,
          desplazamiento: mov,
          giro: gir,
          brillo: brillo,
        );
    objs.addAll([
      pieza(mallaCaja(), const Color(0xFF42A5F5), const V3(0.2, 0.17, 0.17), const V3(0, 0.27, 0)),
      pieza(mallaCaja(), const Color(0xFFE3F2FD), const V3(0.16, 0.12, 0.14), const V3(0, 0.56, 0), brillo: 0.8),
      pieza(Malla.esfera(lat: 6, lon: 8), const Color(0xFF263238), const V3(0.035, 0.035, 0.02), const V3(-0.06, 0.58, 0.14)),
      pieza(Malla.esfera(lat: 6, lon: 8), const Color(0xFF263238), const V3(0.035, 0.035, 0.02), const V3(0.06, 0.58, 0.14)),
      pieza(mallaCilindro(segmentos: 6), const Color(0xFF90A4AE), const V3(0.012, 0.07, 0.012), const V3(0, 0.75, 0)),
      pieza(Malla.esfera(lat: 5, lon: 6), const Color(0xFFE53935), const V3(0.04, 0.04, 0.04), const V3(0, 0.83, 0), brillo: 0.9),
      // Ruedas (cilindros acostados)
      pieza(mallaCilindro(segmentos: 10).rotarZ(math.pi / 2), const Color(0xFF37474F), const V3(0.04, 0.09, 0.09), const V3(-0.23, 0.1, 0)),
      pieza(mallaCilindro(segmentos: 10).rotarZ(math.pi / 2), const Color(0xFF37474F), const V3(0.04, 0.09, 0.09), const V3(0.23, 0.1, 0)),
    ]);
    return Escena3D(distancia: 7.5, fondo: const [Color(0xC80D2B45), Color(0xC81E5A7A)], objetos: objs);
  }

  Map<String, double> get opacidad => {
        for (var k = 0; k < nivelesRobot3D.length; k++) ...{'roca$k': k == nivel ? 1 : 0, 'meta$k': k == nivel && !logrado ? 1 : 0},
      };

  @override
  void dispose() {
    _timer?.cancel();
    _anim.dispose();
    super.dispose();
  }

  void agregar(Orden o) {
    if (ejecutando || programa.length >= 12) return;
    HapticFeedback.selectionClick();
    setState(() {
      programa.add(o);
      aviso = null;
      _reiniciarRobot();
    });
  }

  void borrarUltimo() {
    if (ejecutando || programa.isEmpty) return;
    setState(() {
      programa.removeLast();
      _reiniciarRobot();
    });
  }

  void borrarTodo() {
    if (ejecutando) return;
    setState(() {
      programa.clear();
      _reiniciarRobot();
    });
  }

  void _reiniciarRobot() {
    _de = _a = (0, 0, 0);
    _choque = false;
    _anim.value = 1;
  }

  void ejecutar() {
    if (ejecutando || programa.isEmpty) return;
    HapticFeedback.lightImpact();
    final (recorrido, choco) = recorrerRobot(n, programa);
    setState(() {
      ejecutando = true;
      aviso = null;
      _reiniciarRobot();
    });
    var i = 0;
    void paso() {
      if (!mounted) return;
      if (i + 1 < recorrido.length) {
        setState(() {
          _de = recorrido[i];
          _a = recorrido[i + 1];
          _choque = false;
        });
        _anim.forward(from: 0);
        i++;
        _timer = Timer(const Duration(milliseconds: 650), paso);
        return;
      }
      if (choco) {
        // Pequeño “choque”: se asoma y regresa
        final (c, f, d) = recorrido.last;
        final (dc, df) = _pasos[d];
        setState(() {
          _de = (c, f, d);
          _a = (c, f, d);
          _choque = true;
        });
        HapticFeedback.heavyImpact();
        _anim.forward(from: 0);
        final dentro = c + dc >= 0 && f + df >= 0 && c + dc < _n && f + df < _n;
        setState(() {
          ejecutando = false;
          errores++;
          aviso = dentro
              ? '💥 ¡Bonk! El robot chocó con una roca. Revisa tu programa y corrígelo.'
              : '🚧 ¡Cuidado! El robot se iba a salir del tablero. Revisa tus instrucciones.';
        });
        return;
      }
      final (c, f, _) = recorrido.last;
      setState(() {
        ejecutando = false;
        if ((c, f) == n.meta) {
          logrado = true;
          aviso = '⭐ ¡Llegaste a la estrella! El robot siguió tus instrucciones en orden, una por una.';
          HapticFeedback.mediumImpact();
        } else {
          errores++;
          aviso = '🤔 El programa terminó, pero el robot no llegó a la estrella. ¿Qué instrucción falta o sobra?';
        }
      });
    }

    paso();
  }

  void siguienteNivel() {
    if (nivel < nivelesRobot3D.length - 1) {
      setState(() {
        nivel++;
        programa.clear();
        logrado = false;
        aviso = null;
        _reiniciarRobot();
      });
      return;
    }
    if (_terminado) return;
    _terminado = true;
    terminarPaso(context,
        actividad: widget.actividad,
        estrellas: errores <= 1 ? 3 : (errores <= 4 ? 2 : 1),
        titulo: '¡Programador 3D!',
        mensaje: 'Un programa es una lista de instrucciones en orden. El robot hace exactamente lo que le dices… ¡ni más ni menos!');
  }

  @override
  Widget build(BuildContext context) => Escenario(
        velo: 0.08,
        colorVelo: widget.color,
        children: [
          encabezadoEle('Simulación 3D', '${n.titulo} (${nivel + 1} de ${nivelesRobot3D.length})', widget.color),
          Positioned(
            left: 8,
            top: 60,
            width: 230,
            height: 200,
            child: GloboZatiEle(
                aviso ?? 'Arma el programa con los botones de abajo y presiona «Ejecutar». El robot empieza mirando a la derecha ➡️.\n\n💡 ${n.pista}',
                tam: 13),
          ),
          Positioned(
            left: 8,
            top: 266,
            width: 230,
            height: 208,
            child: PanelEle(
              titulo: 'Mi programa (${programa.length})',
              icono: Icons.code_rounded,
              color: widget.color,
              child: programa.isEmpty
                  ? const Text('Todavía está vacío. Toca ⬆️ ↪️ ↩️ para agregar instrucciones.', style: TextStyle(fontSize: 12.5))
                  : SingleChildScrollView(
                      child: Wrap(spacing: 4, runSpacing: 4, children: [
                        for (var i = 0; i < programa.length; i++)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF42A5F5))),
                            child: Text('${i + 1}. ${programa[i].emoji}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ),
                      ]),
                    ),
            ),
          ),
          Positioned(
            left: 244,
            top: 60,
            width: 608,
            height: 350,
            child: Visor3D(
              escena: escena,
              opacidad: opacidad,
              yaw: 0,
              pitch: -0.95,
              etiquetas: {'meta$nivel': '⭐ Meta'},
              ayuda: 'Arrastra para girar el tablero',
            ),
          ),
          Positioned(
            left: 244,
            top: 418,
            width: 440,
            child: Wrap(spacing: 6, runSpacing: 4, children: [
              for (final o in Orden.values)
                Tooltip(
                    message: o.nombre,
                    child: ChipEle(
                        texto: '${o.emoji} ${o == Orden.avanzar ? 'Avanzar' : (o == Orden.izquierda ? 'Izquierda' : 'Derecha')}',
                        activo: false,
                        color: widget.color,
                        onTap: () => agregar(o))),
              Tooltip(message: 'Borrar la última', child: ChipEle(texto: '⌫', activo: false, color: const Color(0xFF78909C), onTap: borrarUltimo)),
              Tooltip(message: 'Borrar todo', child: ChipEle(texto: '🗑️', activo: false, color: const Color(0xFF78909C), onTap: borrarTodo)),
            ]),
          ),
          Positioned(
            left: 690,
            top: 418,
            child: logrado
                ? BotonSiguiente(texto: nivel < nivelesRobot3D.length - 1 ? 'Siguiente nivel' : 'Terminar', onTap: siguienteNivel)
                : Tooltip(
                    message: 'Ejecutar',
                    child: BotonJuego(texto: 'Ejecutar', icono: Icons.play_arrow_rounded, color: const Color(0xFF2DB84C), onTap: ejecutando ? null : ejecutar),
                  ),
          ),
          const BotonVolverEscena(),
        ],
      );
}
