import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../ciencia/sim_comun.dart';
import '../electronica/comun.dart';
import 'modelo_ia.dart';

Widget _siguiente(BuildContext context, String actividad, String titulo, String mensaje, {int estrellas = 3}) => Positioned(
      left: 690,
      top: 420,
      child: BotonSiguiente(onTap: () => terminarPaso(context, actividad: actividad, estrellas: estrellas, titulo: titulo, mensaje: mensaje)),
    );

/// Tarjeta blanca con borde de color.
Widget _caja(Color color, Widget child, {EdgeInsets padding = const EdgeInsets.all(10)}) => Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2.5),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: child,
    );

/// Botón grande con un emoji o texto, para elegir una opción.
class OpcionIA extends StatelessWidget {
  const OpcionIA({super.key, required this.texto, required this.onTap, required this.color, this.estado, this.tam = 30, this.ancho = 110, this.alto = 74});
  final String texto;
  final VoidCallback? onTap;
  final Color color;

  /// null: normal, true: correcta, false: incorrecta.
  final bool? estado;
  final double tam, ancho, alto;
  @override
  Widget build(BuildContext context) {
    final borde = estado == null ? color : (estado! ? ColoresJuego.correcto : const Color(0xFFE53935));
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: ancho,
        height: alto,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: estado == null ? Colors.white : borde.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borde, width: 3),
          boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 4, offset: Offset(0, 3))],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(texto, textAlign: TextAlign.center, style: TextStyle(fontSize: tam, fontWeight: FontWeight.w700, color: ColoresJuego.texto, height: 1.1)),
        ),
      ),
    );
  }
}

// ===========================================================================
// Tema 1 · La prueba de Turing
// ===========================================================================

class RondaTuring {
  const RondaTuring(this.pregunta, this.a, this.b, {required this.maquinaEsA, required this.pista});
  final String pregunta, a, b, pista;
  final bool maquinaEsA;
}

const rondasTuring = [
  RondaTuring('¿Cuál es tu comida favorita?', 'Los tacos de mi abuela, sobre todo los domingos con toda la familia.',
      'Yo no como, pero según mis datos a muchas personas les gusta la pizza.',
      maquinaEsA: false, pista: 'La máquina dijo que no come: no tiene cuerpo ni gustos propios.'),
  RondaTuring('¿Cuánto es 3 847 × 29?', 'Mmm… déjame pensar… ¿como 111 mil?', '111 563.',
      maquinaEsA: false, pista: 'Respondió al instante y exacto: las computadoras calculan muchísimo más rápido que nosotros.'),
  RondaTuring('¿Qué sentiste el día que ganaste tu primer premio?', 'No tengo sentimientos, pero puedo decirte que las personas suelen sentir orgullo.',
      '¡Me temblaban las piernas y casi lloro de la emoción!',
      maquinaEsA: true, pista: 'Las máquinas no sienten emociones; solo pueden describirlas con lo que aprendieron de textos.'),
  RondaTuring('Cuéntame un chiste.', '¿Qué le dijo un pez a otro? ¡Nada!', '¿Por qué la computadora fue al doctor? ¡Porque tenía un virus!',
      maquinaEsA: false, pista: '¡Era difícil! Hoy algunas IA conversan tan bien que cuesta distinguirlas. Por eso hay que pensar críticamente.'),
];

class SimTuring extends StatefulWidget {
  const SimTuring({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimTuring> createState() => SimTuringState();
}

class SimTuringState extends State<SimTuring> {
  int ronda = 0, aciertos = 0;

  /// Respuesta que el alumno señaló como la de la máquina (0 = A, 1 = B).
  int? elegida;
  bool get listo => ronda == rondasTuring.length - 1 && elegida != null;

  void elegir(int lado) {
    if (elegida != null) return;
    setState(() {
      elegida = lado;
      if ((lado == 0) == rondasTuring[ronda].maquinaEsA) aciertos++;
    });
  }

  void siguienteRonda() => setState(() {
        if (ronda < rondasTuring.length - 1) {
          ronda++;
          elegida = null;
        }
      });

  @override
  Widget build(BuildContext context) {
    final r = rondasTuring[ronda];
    final acerto = elegida != null && (elegida == 0) == r.maquinaEsA;
    final msg = elegida == null
        ? 'Eres el juez de la prueba de Turing. Detrás de la pared hay una persona y una máquina. Lee las dos respuestas y toca la que crees que escribió la MÁQUINA.'
        : '${acerto ? '¡Correcto!' : '¡Casi! Era la otra.'} ${r.pista}${listo ? '\n\nDescubriste $aciertos de ${rondasTuring.length}. Si un juez no puede distinguirlas, Turing diría que la máquina es inteligente.' : ''}';
    Widget respuesta(int lado, String texto) {
      final esMaquina = (lado == 0) == r.maquinaEsA;
      return Expanded(
        child: Tooltip(
          message: 'Respuesta ${lado == 0 ? 'A' : 'B'}',
          child: GestureDetector(
            onTap: () => elegir(lado),
            child: _caja(
              elegida == null ? widget.color : (esMaquina ? const Color(0xFFE91E63) : const Color(0xFF43A047)),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Text(elegida == null ? '❓ ${lado == 0 ? 'A' : 'B'}' : (esMaquina ? '🤖 Máquina' : '🧑 Persona'),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('“$texto”', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, height: 1.2)),
              ]),
            ),
          ),
        ),
      );
    }

    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'La prueba de Turing', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 300, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(
          left: 8,
          top: 366,
          width: 230,
          height: 106,
          child: PanelEle(
            titulo: 'Pregunta ${ronda + 1} de ${rondasTuring.length}',
            icono: Icons.gavel_rounded,
            color: widget.color,
            child: Center(child: Text('Aciertos: $aciertos', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 350,
          child: Column(children: [
            _caja(
                widget.color,
                Row(children: [
                  const Text('🧑‍⚖️', style: TextStyle(fontSize: 34)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(r.pregunta, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
                ])),
            const SizedBox(height: 10),
            Expanded(
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                respuesta(0, r.a),
                const SizedBox(width: 10),
                respuesta(1, r.b),
              ]),
            ),
          ]),
        ),
        if (elegida != null && !listo)
          Positioned(
            left: 450,
            top: 420,
            child: Tooltip(
                message: 'Siguiente pregunta',
                child: BotonJuego(texto: 'Siguiente pregunta', icono: Icons.arrow_forward_rounded, color: widget.color, onTap: siguienteRonda)),
          ),
        if (listo)
          _siguiente(context, widget.actividad, '¡Juez de Turing!',
              'Conociste la prueba de Turing: si no distinguimos a la máquina de una persona, decimos que actúa con inteligencia.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 2 · Encuentra el patrón
// ===========================================================================

class RetoPatron {
  const RetoPatron(this.instruccion, this.secuencia, this.opciones, this.correcta, this.explicacion, {this.incognita = true});
  final String instruccion, explicacion;
  final List<String> secuencia, opciones;
  final int correcta;

  /// Si se muestra un “?” al final de la secuencia.
  final bool incognita;
}

const retosPatrones = [
  RetoPatron('¿Qué sigue?', ['🔴', '🔵', '🔴', '🔵', '🔴'], ['🔵', '🔴', '🟢'], 0, 'Se repite rojo, azul, rojo, azul…'),
  RetoPatron('¿Qué sigue?', ['⭐', '⭐⭐', '⭐⭐⭐'], ['⭐⭐⭐⭐', '⭐', '⭐⭐'], 0, 'Cada vez hay una estrella más.'),
  RetoPatron('¿Qué número sigue?', ['2', '4', '6', '8'], ['10', '9', '12'], 0, 'Se suma 2 cada vez.'),
  RetoPatron('¿Cuál NO pertenece al grupo?', ['🐶', '🐱', '🚗', '🐰'], ['🐶', '🚗', '🐰'], 1, 'Todos son animales, menos el coche.', incognita: false),
  RetoPatron('¿Qué tienen en común?', ['🍎', '🍓', '🍒', '🌶️'], ['Son rojos', 'Son dulces', 'Son verdes'], 0, 'Su característica común es el color rojo.',
      incognita: false),
  RetoPatron('¿Qué sigue?', ['🌑', '🌓', '🌕', '🌗', '🌑', '🌓'], ['🌕', '🌑', '🌗'], 0, 'Las fases de la Luna se repiten en el mismo orden.'),
];

class SimPatrones extends StatefulWidget {
  const SimPatrones({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimPatrones> createState() => SimPatronesState();
}

class SimPatronesState extends State<SimPatrones> {
  int reto = 0, errores = 0;
  int? fallo;
  bool resuelto = false;
  bool get listo => reto == retosPatrones.length - 1 && resuelto;

  void elegir(int i) => setState(() {
        if (resuelto) return;
        if (i == retosPatrones[reto].correcta) {
          resuelto = true;
          fallo = null;
        } else {
          fallo = i;
          errores++;
        }
      });

  void siguienteReto() => setState(() {
        if (reto < retosPatrones.length - 1) {
          reto++;
          resuelto = false;
          fallo = null;
        }
      });

  @override
  Widget build(BuildContext context) {
    final r = retosPatrones[reto];
    final msg = resuelto
        ? '¡Bien! ${r.explicacion} Tu cerebro es experto en encontrar patrones; las IA aprenden a hacerlo con muchos ejemplos.'
        : fallo != null
            ? 'Mmm, observa otra vez. ¿Qué se repite o qué cambia?'
            : 'Encontrar patrones es buscar lo que se repite, lo que cambia y lo que se parece. ${r.instruccion}';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'Detective de patrones', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 300, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(
          left: 8,
          top: 366,
          width: 230,
          height: 106,
          child: PanelEle(
            titulo: 'Reto ${reto + 1} de ${retosPatrones.length}',
            icono: Icons.search_rounded,
            color: widget.color,
            child: LinearProgressIndicator(value: (reto + (resuelto ? 1 : 0)) / retosPatrones.length, color: widget.color, minHeight: 12),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 350,
          child: _caja(
            widget.color,
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text(r.instruccion, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              FittedBox(
                child: Row(children: [
                  for (final s in r.secuencia)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(s, style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                    ),
                  if (r.incognita)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFFF59D), borderRadius: BorderRadius.circular(12), border: Border.all(color: widget.color, width: 2)),
                      child: Text(resuelto ? r.opciones[r.correcta] : '?', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800)),
                    ),
                ]),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var i = 0; i < r.opciones.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Tooltip(
                      message: 'Opción ${i + 1}',
                      child: OpcionIA(
                        texto: r.opciones[i],
                        color: widget.color,
                        ancho: r.opciones[i].length > 4 ? 150 : 110,
                        tam: r.opciones[i].length > 4 ? 18 : 30,
                        estado: resuelto && i == r.correcta ? true : (fallo == i ? false : null),
                        onTap: () => elegir(i),
                      ),
                    ),
                  ),
              ]),
            ]),
          ),
        ),
        if (resuelto && !listo)
          Positioned(
            left: 470,
            top: 420,
            child: Tooltip(
                message: 'Siguiente reto',
                child: BotonJuego(texto: 'Siguiente reto', icono: Icons.arrow_forward_rounded, color: widget.color, onTap: siguienteReto)),
          ),
        if (listo)
          _siguiente(context, widget.actividad, '¡Detective de patrones!', 'Encontraste secuencias, intrusos y semejanzas: así empiezan a “pensar” las IA.',
              estrellas: errores <= 1 ? 3 : (errores <= 3 ? 2 : 1)),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 2 · La máquina reconoce figuras en una cuadrícula de pixeles
// ===========================================================================

/// Figuras de 5 × 5 pixeles que la máquina conoce.
const figurasPixeles = <(String, String, List<String>)>[
  ('Cruz', '➕', ['..#..', '..#..', '#####', '..#..', '..#..']),
  ('Cuadro', '⬜', ['#####', '#...#', '#...#', '#...#', '#####']),
  ('Letra L', '🅻', ['#....', '#....', '#....', '#....', '#####']),
  ('Letra T', '🆃', ['#####', '..#..', '..#..', '..#..', '..#..']),
  ('Equis', '✖️', ['#...#', '.#.#.', '..#..', '.#.#.', '#...#']),
];

class SimPixeles extends StatefulWidget {
  const SimPixeles({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimPixeles> createState() => SimPixelesState();
}

class SimPixelesState extends State<SimPixeles> with ObjetivosSim {
  final pix = List.generate(5, (_) => List.filled(5, false));
  final reconocidas = <int>{};
  static const metas = [
    'Dibuja una figura y deja que la máquina la reconozca',
    'Haz que reconozca 3 figuras diferentes',
    'Dibuja algo que la máquina NO conozca'
  ];

  /// Parecido (0 a 1) con cada figura conocida.
  List<double> parecidos() => [
        for (final (_, _, f) in figurasPixeles)
          () {
            var n = 0;
            for (var i = 0; i < 5; i++) {
              for (var j = 0; j < 5; j++) {
                if ((f[i][j] == '#') == pix[i][j]) n++;
              }
            }
            return n / 25;
          }()
      ];

  int get encendidos => pix.fold(0, (a, f) => a + f.where((x) => x).length);

  void alternar(int i, int j) => setState(() {
        pix[i][j] = !pix[i][j];
        _revisar();
      });

  void dibujar(List<String> f) => setState(() {
        for (var i = 0; i < 5; i++) {
          for (var j = 0; j < 5; j++) {
            pix[i][j] = f[i][j] == '#';
          }
        }
        _revisar();
      });

  void borrar() => setState(() {
        for (final f in pix) {
          f.fillRange(0, 5, false);
        }
      });

  void _revisar() {
    if (encendidos < 4) return;
    final p = parecidos();
    final mejor = p.reduce(math.max);
    if (mejor >= 0.88) {
      reconocidas.add(p.indexOf(mejor));
      lograr(0);
      if (reconocidas.length >= 3) lograr(1);
    } else if (mejor < 0.72) {
      lograr(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = parecidos();
    final mejor = p.reduce(math.max);
    final k = p.indexOf(mejor);
    final listo = hechas.length == metas.length;
    final msg = encendidos < 4
        ? 'Para una computadora, una imagen es una cuadrícula de pixeles: cada cuadrito vale 0 (apagado) o 1 (encendido). Toca los cuadritos para dibujar una figura.'
        : mejor >= 0.88
            ? 'Reconozco: ${figurasPixeles[k].$2} ${figurasPixeles[k].$1}. Se parece en un ${(mejor * 100).round()} % a la figura que aprendí. Comparo pixel por pixel: ¡busco el patrón!'
            : mejor >= 0.72
                ? 'Mmm… creo que es ${figurasPixeles[k].$1}, pero no estoy segura (${(mejor * 100).round()} %).'
                : 'No reconozco esta figura: no se parece a ninguna que conozca. Una IA solo reconoce lo que aprendió.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'La máquina que reconoce figuras', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 250,
          top: 64,
          width: 290,
          height: 290,
          child: _caja(
            widget.color,
            Column(children: [
              for (var i = 0; i < 5; i++)
                Expanded(
                  child: Row(children: [
                    for (var j = 0; j < 5; j++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () => alternar(i, j),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 120),
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: pix[i][j] ? widget.color : const Color(0xFFF1F1F6),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black12),
                            ),
                            alignment: Alignment.center,
                            child: Text(pix[i][j] ? '1' : '0',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: pix[i][j] ? Colors.white : Colors.black26)),
                          ),
                        ),
                      ),
                  ]),
                ),
            ]),
            padding: const EdgeInsets.all(6),
          ),
        ),
        Positioned(
          left: 552,
          top: 64,
          width: 300,
          height: 290,
          child: PanelEle(
            titulo: 'Parecido con lo que aprendí',
            icono: Icons.compare_rounded,
            color: widget.color,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (var i = 0; i < figurasPixeles.length; i++)
                Row(children: [
                  SizedBox(
                      width: 100,
                      child: Text('${figurasPixeles[i].$2} ${figurasPixeles[i].$1}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                          value: encendidos < 4 ? 0 : p[i],
                          minHeight: 14,
                          color: i == k && mejor >= 0.88 ? ColoresJuego.correcto : widget.color.withValues(alpha: 0.6)),
                    ),
                  ),
                  SizedBox(
                      width: 44,
                      child: Text(encendidos < 4 ? '–' : '${(p[i] * 100).round()} %', textAlign: TextAlign.right, style: const TextStyle(fontSize: 12.5))),
                ]),
            ]),
          ),
        ),
        Positioned(
          left: 250,
          top: 366,
          width: 600,
          child: Wrap(spacing: 6, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
            const Text('Ejemplos:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white, shadows: [Shadow(blurRadius: 4)])),
            for (final (n, e, f) in figurasPixeles)
              Tooltip(message: 'Dibujar $n', child: ChipEle(texto: '$e $n', activo: false, color: widget.color, onTap: () => dibujar(f))),
            Tooltip(message: 'Borrar', child: ChipEle(texto: '🧽 Borrar', activo: false, color: const Color(0xFF757575), onTap: borrar)),
          ]),
        ),
        if (listo)
          _siguiente(
              context, widget.actividad, '¡Figuras reconocidas!', 'La máquina compara los pixeles con los patrones que aprendió y elige el más parecido.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 3 · La neurona artificial (perceptrón)
// ===========================================================================

/// Casos de entrenamiento: (¿hace sol?, ¿hay tarea?, ¿es fin de semana?) → ¿vamos al parque?
const casosNeurona = [
  ([1, 0, 1], true),
  ([1, 1, 0], false),
  ([0, 0, 1], false),
  ([1, 0, 0], true),
];
const entradasNeurona = [('☀️', 'Hace sol'), ('📚', 'Hay tarea'), ('🎉', 'Fin de semana')];

class SimNeurona extends StatefulWidget {
  const SimNeurona({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimNeurona> createState() => SimNeuronaState();
}

class SimNeuronaState extends State<SimNeurona> {
  final pesos = [0.5, 0.5, 0.5];
  double umbral = 1;
  bool tocado = false;

  double suma(List<int> x) => [for (var i = 0; i < 3; i++) x[i] * pesos[i]].fold(0.0, (a, b) => a + b);
  bool salida(List<int> x) => suma(x) > umbral;
  int get correctos => casosNeurona.where((c) => salida(c.$1) == c.$2).length;
  bool get listo => correctos == casosNeurona.length;

  void cambiar({double? w0, double? w1, double? w2, double? u}) => setState(() {
        tocado = true;
        if (w0 != null) pesos[0] = w0;
        if (w1 != null) pesos[1] = w1;
        if (w2 != null) pesos[2] = w2;
        if (u != null) umbral = u;
      });

  @override
  Widget build(BuildContext context) {
    final msg = listo
        ? '¡Entrenaste la neurona! Ahora acierta todos los casos. Aprender, para una red neuronal, es justo eso: ajustar los pesos hasta equivocarse lo menos posible.'
        : !tocado
            ? 'Esta neurona artificial decide si vamos al parque. Cada entrada tiene un PESO (su importancia). Si la suma pasa el UMBRAL, la neurona dice “sí”. Mueve los pesos hasta que acierte los 4 casos.'
            : 'Acierta $correctos de 4. Pista: el sol debe pesar mucho, la tarea debe restar (peso negativo) y el umbral debe ser alto.';
    String f(double v) => v.toStringAsFixed(1);
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'Entrena una neurona', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 300, child: GloboZatiEle(msg, tam: 12)),
        Positioned(
          left: 8,
          top: 366,
          width: 230,
          height: 106,
          child: PanelEle(
            titulo: 'Casos correctos',
            icono: Icons.check_circle_rounded,
            color: widget.color,
            child: Center(child: Text('$correctos de ${casosNeurona.length}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
          ),
        ),
        Positioned(
          left: 244,
          top: 300,
          width: 608,
          height: 112,
          child: PanelEle(
            titulo: 'Pesos y umbral · mueve los controles',
            icono: Icons.tune_rounded,
            color: widget.color,
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  for (var i = 0; i < 2; i++)
                    Expanded(
                      child: deslizador(context, entradasNeurona[i].$1, 'Peso ${f(pesos[i])}', pesos[i],
                          (v) => cambiar(w0: i == 0 ? v : null, w1: i == 1 ? v : null), widget.color,
                          min: -3, max: 3),
                    ),
                ]),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(children: [
                  Expanded(
                      child: deslizador(context, entradasNeurona[2].$1, 'Peso ${f(pesos[2])}', pesos[2], (v) => cambiar(w2: v), widget.color, min: -3, max: 3)),
                  Expanded(child: deslizador(context, '🚧', 'Umbral ${f(umbral)}', umbral, (v) => cambiar(u: v), const Color(0xFFE53935), min: 0, max: 3)),
                ]),
              ),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 234,
          child: _caja(
            widget.color,
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
            Column(children: [
              const Row(children: [
                Expanded(flex: 3, child: Text('☀️ Sol   📚 Tarea   🎉 Finde', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                Expanded(flex: 2, child: Text('Suma', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                Expanded(flex: 2, child: Text('Neurona', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
                Expanded(flex: 2, child: Text('Correcto', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800))),
              ]),
              const Divider(height: 8),
              for (final (x, y) in casosNeurona)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: (salida(x) == y ? ColoresJuego.correcto : const Color(0xFFE53935)).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: Text('   ${x[0] == 1 ? '✅' : '⬜'}          ${x[1] == 1 ? '✅' : '⬜'}          ${x[2] == 1 ? '✅' : '⬜'}',
                            style: const TextStyle(fontSize: 18)),
                      ),
                      Expanded(
                          flex: 2, child: Text(f(suma(x)), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
                      Expanded(flex: 2, child: Text(salida(x) ? '🌳 Sí' : '🏠 No', textAlign: TextAlign.center, style: const TextStyle(fontSize: 17))),
                      Expanded(
                          flex: 2,
                          child: Text('${y ? '🌳 Sí' : '🏠 No'} ${salida(x) == y ? '✔️' : '❌'}',
                              textAlign: TextAlign.center, style: const TextStyle(fontSize: 17))),
                    ]),
                  ),
                ),
            ]),
          ),
        ),
        if (listo)
          _siguiente(context, widget.actividad, '¡Neurona entrenada!', 'Una neurona artificial suma sus entradas por sus pesos y se activa si pasa el umbral.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 3 y 5 · Entrena una IA con ejemplos (y descubre el sesgo)
// ===========================================================================

/// Tarjeta de un ejemplo con su etiqueta.
class TarjetaEjemplo extends StatelessWidget {
  const TarjetaEjemplo({super.key, required this.ejemplo, this.etiqueta, this.color = const Color(0xFF7C4DFF), this.onTap, this.marca, this.ancho = 92});
  final EjemploIA ejemplo;
  final EtiquetaIA? etiqueta;
  final Color color;
  final VoidCallback? onTap;

  /// Texto pequeño abajo (por ejemplo ✔️ o ❌).
  final String? marca;
  final double ancho;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: ancho,
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
          decoration: BoxDecoration(
            color: etiqueta == null ? Colors.white : etiqueta!.color.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: etiqueta?.color ?? color.withValues(alpha: 0.5), width: 2.5),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(ejemplo.emoji, style: const TextStyle(fontSize: 26)),
            Text(ejemplo.nombre, maxLines: 2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, height: 1.05)),
            const SizedBox(height: 2),
            Text(etiqueta == null ? '🏷️ ?' : '${etiqueta!.emoji} ${etiqueta!.nombre}${marca == null ? '' : ' $marca'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: etiqueta?.color ?? Colors.black45)),
          ]),
        ),
      );
}

class SimEntrenar extends StatefulWidget {
  const SimEntrenar({super.key, required this.actividad, required this.color, required this.proyecto, this.sesgo = false});
  final String actividad;
  final Color color;
  final ProyectoIA proyecto;

  /// Los datos ya vienen etiquetados y les falta variedad.
  final bool sesgo;
  @override
  State<SimEntrenar> createState() => SimEntrenarState();
}

class SimEntrenarState extends State<SimEntrenar> with ObjetivosSim {
  late final datos = [...widget.proyecto.banco];
  late final etiquetas = <int?>[for (final e in widget.proyecto.banco) widget.sesgo ? e.etiqueta : null];
  int? elegido;
  double progreso = 0;
  bool entrenando = false, entrenado = false, extraAgregado = false;
  ModeloIA? modelo;
  Timer? _timer;

  List<String> get metas => widget.sesgo
      ? const [
          'Entrena la IA con los datos que hay',
          'Prueba la IA y descubre su error',
          'Agrega datos variados y vuelve a entrenar',
          'Logra 100 % de aciertos'
        ]
      : ['Etiqueta los ${widget.proyecto.banco.length} ejemplos', 'Entrena a la IA', 'Prueba con ejemplos nuevos: 100 % de aciertos'];

  bool get todoEtiquetado => etiquetas.every((e) => e != null);
  double get precision => modelo?.precision(widget.proyecto.prueba) ?? 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void etiquetar(int i, int etiqueta) => setState(() {
        etiquetas[i] = etiqueta;
        elegido = null;
        entrenado = false;
        modelo = null;
        if (!widget.sesgo && todoEtiquetado) lograr(0);
      });

  void elegir(int i) => setState(() => elegido = elegido == i ? null : i);

  void entrenar() {
    if (!todoEtiquetado || entrenando) return;
    _timer?.cancel();
    setState(() {
      entrenando = true;
      progreso = 0;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 60), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        progreso += 0.05;
        if (progreso >= 1) {
          tm.cancel();
          progreso = 1;
          entrenando = false;
          entrenado = true;
          modelo = ModeloIA([for (var i = 0; i < datos.length; i++) (datos[i], etiquetas[i]!)], {for (final r in widget.proyecto.rasgos) r.id});
          if (widget.sesgo) {
            lograr(0);
            if (precision < 1) lograr(1);
            if (extraAgregado) lograr(2);
            if (extraAgregado && precision == 1) lograr(3);
          } else {
            lograr(1);
            if (precision == 1) lograr(2);
          }
        }
      });
    });
  }

  void agregarExtra() => setState(() {
        if (extraAgregado) return;
        extraAgregado = true;
        datos.addAll(widget.proyecto.extra);
        etiquetas.addAll([for (final e in widget.proyecto.extra) e.etiqueta]);
        entrenado = false;
        modelo = null;
      });

  @override
  Widget build(BuildContext context) {
    final p = widget.proyecto;
    final listo = hechas.length == metas.length;
    final malos = modelo == null
        ? <EjemploIA>[]
        : [
            for (final x in p.prueba)
              if (modelo!.predecir(x).etiqueta != x.etiqueta) x
          ];
    final msg = listo
        ? widget.sesgo
            ? '¡Corregiste el sesgo! La IA solo había visto manzanas rojas, por eso creía que todo lo verde no era manzana. Con datos variados aprendió mejor.'
            : '¡Tu IA aprendió! Con ejemplos bien etiquetados descubrió el patrón y acierta con animales que nunca había visto.'
        : entrenando
            ? 'Entrenando… La IA busca qué rasgos tienen en común los ejemplos de cada grupo.'
            : entrenado
                ? malos.isEmpty
                    ? '¡Acierta todo!'
                    : widget.sesgo
                        ? '¡La IA se equivocó con ${malos.map((e) => e.nombre).join(', ')}! Todas las manzanas que vio eran rojas: los datos no eran variados. Eso se llama SESGO. Agrega datos variados.'
                        : 'Se equivocó con ${malos.map((e) => e.nombre).join(', ')}. Revisa tus etiquetas: toca un ejemplo para cambiarla y vuelve a entrenar.'
                : widget.sesgo
                    ? '${p.descripcion} Alguien ya le puso etiqueta a estos datos. Presiona “Entrenar” y luego observa cómo le va.'
                    : !todoEtiquetado
                        ? '${p.descripcion} Toca cada ejemplo y elige su etiqueta. ¡Tú eres la maestra o el maestro de la IA!'
                        : '¡Todos tienen etiqueta! Ahora presiona “Entrenar”.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.sesgo ? 'Simulación' : 'Laboratorio', p.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 200, child: GloboZatiEle(msg, tam: 12)),
        Positioned(left: 8, top: 266, width: 230, height: 206, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 196,
          child: PanelEle(
            titulo: 'Datos de entrenamiento (${datos.length}) · La IA observa: ${p.rasgos.map((r) => '${r.emoji} ${r.nombre.toLowerCase()}').join(', ')}',
            icono: Icons.dataset_rounded,
            color: widget.color,
            child: SingleChildScrollView(
              child: Wrap(spacing: 6, runSpacing: 6, children: [
                for (var i = 0; i < datos.length; i++)
                  Tooltip(
                    message: 'Ejemplo ${datos[i].nombre}',
                    child: TarjetaEjemplo(
                      ejemplo: datos[i],
                      etiqueta: etiquetas[i] == null ? null : p.etiquetas[etiquetas[i]!],
                      color: widget.color,
                      ancho: 84,
                      onTap: widget.sesgo ? null : () => elegir(i),
                    ),
                  ),
              ]),
            ),
          ),
        ),
        if (elegido != null)
          Positioned(
            left: 244,
            top: 262,
            width: 608,
            child: _caja(
              widget.color,
              Row(children: [
                Text('${datos[elegido!].emoji} ${datos[elegido!].nombre} es…', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                const Spacer(),
                for (var k = 0; k < p.etiquetas.length; k++)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Tooltip(
                      message: '${datos[elegido!].nombre}: ${p.etiquetas[k].nombre}',
                      child: BotonJuego(
                          texto: '${p.etiquetas[k].emoji} ${p.etiquetas[k].nombre}', color: p.etiquetas[k].color, onTap: () => etiquetar(elegido!, k)),
                    ),
                  ),
              ]),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
          )
        else
          Positioned(
            left: 244,
            top: 262,
            width: 608,
            height: 150,
            child: PanelEle(
              titulo: modelo == null
                  ? (entrenando ? 'Entrenando… ${(progreso * 100).round()} %' : 'Prueba con ejemplos nuevos')
                  : 'Prueba: ${(precision * 100).round()} % de aciertos',
              icono: Icons.science_rounded,
              color: widget.color,
              child: entrenando
                  ? Center(child: LinearProgressIndicator(value: progreso, minHeight: 16, color: widget.color))
                  : Wrap(spacing: 6, runSpacing: 4, children: [
                      for (final x in p.prueba)
                        () {
                          final pr = modelo?.predecir(x);
                          return TarjetaEjemplo(
                            ejemplo: x,
                            etiqueta: pr == null || pr.etiqueta < 0 ? null : p.etiquetas[pr.etiqueta],
                            marca: pr == null ? null : (pr.etiqueta == x.etiqueta ? '✔️' : '❌'),
                            color: widget.color,
                            ancho: 118,
                          );
                        }(),
                    ]),
            ),
          ),
        Positioned(
          left: 300,
          top: 420,
          child: Row(children: [
            Tooltip(
              message: 'Entrenar',
              child: BotonJuego(
                  texto: entrenado ? 'Volver a entrenar' : 'Entrenar',
                  icono: Icons.model_training_rounded,
                  color: todoEtiquetado ? widget.color : Colors.grey,
                  onTap: entrenar),
            ),
            if (widget.sesgo && entrenado && !extraAgregado) ...[
              const SizedBox(width: 8),
              Tooltip(
                  message: 'Agregar datos variados',
                  child: BotonJuego(
                      texto: 'Agregar datos variados', icono: Icons.add_photo_alternate_rounded, color: const Color(0xFF43A047), onTap: agregarExtra)),
            ],
          ]),
        ),
        if (listo)
          _siguiente(
              context,
              widget.actividad,
              widget.sesgo ? '¡Sesgo corregido!' : '¡IA entrenada!',
              widget.sesgo
                  ? 'Una IA aprende de sus datos: si los datos no son variados, sus respuestas tampoco serán justas.'
                  : 'Le enseñaste con ejemplos y etiquetas: eso es aprendizaje supervisado.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 4 · Así funciona un asistente de voz
// ===========================================================================

class OrdenVoz {
  const OrdenVoz(this.emoji, this.texto, this.intencion, this.respuesta);
  final String emoji, texto, intencion, respuesta;
}

const ordenesVoz = [
  OrdenVoz('🌦️', '¿Va a llover hoy?', 'Consultar el clima', 'Hoy hay 70 % de probabilidad de lluvia. ¡Lleva paraguas!'),
  OrdenVoz('🎵', 'Pon música para bailar', 'Reproducir música', 'Reproduciendo tu lista de canciones para bailar.'),
  OrdenVoz('🌐', '¿Cómo se dice “gato” en inglés?', 'Traducir', '“Gato” en inglés se dice “cat”.'),
  OrdenVoz('⏰', 'Despiértame a las 7', 'Poner una alarma', 'Listo: alarma a las 7:00 de la mañana.'),
];
const etapasVoz = [('🎙️', 'Escucha'), ('📝', 'Voz a texto'), ('🧠', 'Entiende'), ('🔊', 'Responde')];

class SimAsistente extends StatefulWidget {
  const SimAsistente({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimAsistente> createState() => SimAsistenteState();
}

class SimAsistenteState extends State<SimAsistente> with ObjetivosSim {
  int? orden;

  /// Etapa del proceso: 0 a 4 (4 = terminó).
  int etapa = 0;
  final probadas = <int>{};
  Timer? _timer;
  static const metas = ['Dale una orden al asistente', 'Observa las 4 etapas: escuchar, convertir, entender y responder', 'Prueba 3 órdenes diferentes'];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void pedir(int i) {
    _timer?.cancel();
    setState(() {
      orden = i;
      etapa = 0;
      lograr(0);
    });
    _timer = Timer.periodic(const Duration(milliseconds: 700), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        etapa++;
        if (etapa >= 4) {
          tm.cancel();
          etapa = 4;
          probadas.add(i);
          lograr(1);
          if (probadas.length >= 3) lograr(2);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final o = orden == null ? null : ordenesVoz[orden!];
    final msg = o == null
        ? 'Los asistentes de voz usan IA para entender el lenguaje que hablamos (procesamiento del lenguaje natural). Toca una orden para dársela al asistente.'
        : etapa < 4
            ? [
                '1. Escucha: el micrófono capta las ondas de tu voz.',
                '2. Voz a texto: la IA reconoce las palabras.',
                '3. Entiende: busca qué quieres hacer (tu intención).',
                '4. Responde: hace la acción y te contesta con una voz artificial.'
              ][etapa]
            : listo
                ? '¡Muy bien! Escuchar, convertir la voz en texto, entender y responder: todo en un par de segundos.'
                : 'Respuesta: “${o.respuesta}” Prueba otra orden.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'El asistente de voz', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 280,
          child: _caja(
            widget.color,
            Column(children: [
              Row(children: [
                Text(o == null ? '🗣️ …' : '🗣️ “${o.texto}”', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 10),
              Expanded(
                child: Row(children: [
                  for (var k = 0; k < 4; k++) ...[
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: o != null && etapa >= k ? widget.color.withValues(alpha: etapa == k ? 0.3 : 0.14) : const Color(0xFFF3F3F7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: o != null && etapa == k ? widget.color : Colors.black12, width: 2.5),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(etapasVoz[k].$1, style: const TextStyle(fontSize: 30)),
                          Text(etapasVoz[k].$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          if (o != null && etapa > k || (o != null && etapa == 4))
                            Text(
                              switch (k) {
                                0 => '〰️〰️〰️',
                                1 => o.texto,
                                2 => o.intencion,
                                _ => o.respuesta,
                              },
                              textAlign: TextAlign.center,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11.5, height: 1.1),
                            ),
                        ]),
                      ),
                    ),
                    if (k < 3) Icon(Icons.arrow_forward_rounded, color: widget.color),
                  ],
                ]),
              ),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 350,
          width: 608,
          child: Wrap(spacing: 6, runSpacing: 6, children: [
            for (var i = 0; i < ordenesVoz.length; i++)
              Tooltip(
                message: ordenesVoz[i].texto,
                child: ChipEle(
                    texto: '${ordenesVoz[i].emoji} ${ordenesVoz[i].texto}${probadas.contains(i) ? ' ✔️' : ''}',
                    activo: orden == i,
                    color: widget.color,
                    onTap: () => pedir(i)),
              ),
          ]),
        ),
        if (listo)
          _siguiente(context, widget.actividad, '¡Asistente entendido!', 'Un asistente escucha, convierte la voz en texto, entiende tu intención y responde.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Tema 4 y 5 · El recomendador de videos (y la burbuja)
// ===========================================================================

const categoriasVideo = [
  ('Animales', '🐾', Color(0xFF8D6E63)),
  ('Deportes', '⚽', Color(0xFF43A047)),
  ('Ciencia', '🔬', Color(0xFF1E88E5)),
  ('Música', '🎵', Color(0xFFD81B60))
];

/// Videos: (emoji, título, categoría).
const catalogoVideos = [
  ('🐼', 'Pandas bebés', 0),
  ('⚽', 'Los mejores goles', 1),
  ('🌋', '¿Cómo nace un volcán?', 2),
  ('🎸', 'Aprende guitarra', 3),
  ('🐬', 'Delfines que juegan', 0),
  ('🏀', 'Trucos de básquet', 1),
  ('🚀', 'Viaje a Marte', 2),
  ('🥁', 'Ritmos de tambor', 3),
];
const sugerenciasVideo = [
  ('🦁', 'La vida del león', 0),
  ('🐘', 'Elefantes en familia', 0),
  ('🐙', 'El pulpo genio', 0),
  ('🏊', 'Natación olímpica', 1),
  ('🚴', 'Carrera de bicis', 1),
  ('⚾', 'Béisbol para niños', 1),
  ('🦕', 'Dinosaurios', 2),
  ('🧪', 'Experimentos en casa', 2),
  ('🔭', 'Mira las estrellas', 2),
  ('🎹', 'Piano fácil', 3),
  ('🎤', 'Canta conmigo', 3),
  ('🎻', 'El violín', 3),
];

class SimRecomendador extends StatefulWidget {
  const SimRecomendador({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimRecomendador> createState() => SimRecomendadorState();
}

class SimRecomendadorState extends State<SimRecomendador> with ObjetivosSim {
  final gustos = <int>{};
  static const metas = ['Da “me gusta” a 3 videos', 'Observa: te recomienda más de lo mismo', 'Sal de la burbuja: dale “me gusta” a 3 temas distintos'];

  List<int> get conteo => [for (var c = 0; c < categoriasVideo.length; c++) gustos.where((i) => catalogoVideos[i].$3 == c).length];

  /// Las 4 sugerencias con más puntos según los gustos.
  List<(String, String, int)> get recomendados {
    final cuenta = conteo;
    final orden = [...sugerenciasVideo]
      ..sort((a, b) => cuenta[b.$3] != cuenta[a.$3] ? cuenta[b.$3] - cuenta[a.$3] : sugerenciasVideo.indexOf(a) - sugerenciasVideo.indexOf(b));
    return orden.take(4).toList();
  }

  void meGusta(int i) => setState(() {
        if (!gustos.add(i)) gustos.remove(i);
        final c = conteo;
        if (gustos.length >= 3) lograr(0);
        if (gustos.length >= 2 && c.any((n) => n >= 2)) lograr(1);
        if (c.where((n) => n > 0).length >= 3 && hechas.contains(1)) lograr(2);
      });

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final c = conteo;
    final msg = listo
        ? '¡Excelente! Los recomendadores aprenden de lo que ves y te sugieren más de lo mismo. Si solo ves un tema, quedas en una “burbuja”. ¡Explorar cosas nuevas te hace más libre!'
        : gustos.isEmpty
            ? 'Las apps de videos usan IA para recomendarte qué ver. Toca 👍 en los videos que te gusten y mira cómo cambian las recomendaciones.'
            : hechas.contains(1)
                ? 'Mira: casi todo lo que te recomienda es del mismo tema. Ahora dale “me gusta” a otros temas para salir de la burbuja.'
                : 'La IA cuenta tus “me gusta” por tema. ¡Sigue!';
    Widget video((String, String, int) v, {bool gusta = false, VoidCallback? onTap, bool recomendacion = false}) {
      final cat = categoriasVideo[v.$3];
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: recomendacion ? 136 : 140,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: gusta ? cat.$3.withValues(alpha: 0.18) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cat.$3, width: 2),
          ),
          child: Row(children: [
            Text(v.$1, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 4),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(v.$2, maxLines: 2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, height: 1.05)),
                Text('${cat.$2} ${cat.$1}${recomendacion ? '' : (gusta ? '  👍' : '  👍?')}',
                    style: TextStyle(fontSize: 9.5, color: cat.$3, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
      );
    }

    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'El recomendador de videos', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 182,
          child: PanelEle(
            titulo: 'Videos · toca 👍 si te gusta',
            icono: Icons.smart_display_rounded,
            color: widget.color,
            child: Wrap(spacing: 6, runSpacing: 6, children: [
              for (var i = 0; i < catalogoVideos.length; i++)
                Tooltip(message: 'Me gusta ${catalogoVideos[i].$2}', child: video(catalogoVideos[i], gusta: gustos.contains(i), onTap: () => meGusta(i))),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 248,
          width: 608,
          height: 166,
          child: PanelEle(
            titulo: gustos.isEmpty
                ? 'Recomendados para ti'
                : 'Recomendados para ti · ${[
                    for (var k = 0; k < c.length; k++)
                      if (c[k] > 0) '${categoriasVideo[k].$2} ${c[k]}'
                  ].join('  ')}',
            icono: Icons.auto_awesome_rounded,
            color: widget.color,
            child: gustos.isEmpty
                ? const Center(child: Text('La IA todavía no sabe qué te gusta.', style: TextStyle(fontSize: 14)))
                : Wrap(spacing: 6, runSpacing: 6, children: [for (final v in recomendados) video(v, recomendacion: true)]),
          ),
        ),
        if (listo)
          _siguiente(context, widget.actividad, '¡Recomendador descubierto!',
              'Las recomendaciones aprenden de tus gustos. Explora temas distintos para no quedarte en una burbuja.'),
        const BotonVolverEscena(),
      ],
    );
  }
}
