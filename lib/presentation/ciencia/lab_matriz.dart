import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/contenido.dart' show PreguntaQuiz;
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show Emoji;
import '../biology/temas/simulaciones.dart' show PreguntaPanel;
import '../electronica/comun.dart';

/// Una prueba del laboratorio (una columna de la tabla).
class Prueba {
  const Prueba(this.nombre, this.emoji, this.si, this.no);
  final String nombre, emoji;

  /// Texto del resultado positivo y negativo (por ejemplo "Duro" / "Blando").
  final String si, no;
}

/// Un material u objeto (una fila) con el resultado de cada prueba.
class Muestra {
  const Muestra(this.nombre, this.emoji, this.resultados, {this.datos = const []});
  final String nombre, emoji;
  final List<bool> resultados;

  /// Explicación de cada resultado (opcional).
  final List<String> datos;
}

/// Laboratorio de pruebas: el alumno experimenta con cada material y cada
/// prueba, anota el resultado en la tabla y al final contesta una pregunta.
class LabMatriz extends StatefulWidget {
  const LabMatriz({
    super.key,
    required this.actividad,
    required this.titulo,
    required this.color,
    required this.instruccion,
    required this.pruebas,
    required this.muestras,
    required this.pregunta,
    required this.mensajeFinal,
    this.seccion = 'Laboratorio',
  });
  final String actividad, titulo, instruccion, mensajeFinal, seccion;
  final Color color;
  final List<Prueba> pruebas;
  final List<Muestra> muestras;
  final PreguntaQuiz pregunta;
  @override
  State<LabMatriz> createState() => LabMatrizState();
}

class LabMatrizState extends State<LabMatriz> {
  final _hechas = <(int, int)>{};
  (int, int)? _ultima;
  bool _preguntando = false;
  bool _listo = false;
  bool _primera = true;
  int _vuelta = 0;

  int get total => widget.muestras.length * widget.pruebas.length;

  void probar(int fila, int col) {
    HapticFeedback.selectionClick();
    setState(() {
      _hechas.add((fila, col));
      _ultima = (fila, col);
      _vuelta++;
    });
  }

  String _mensaje() {
    final u = _ultima;
    if (_listo) return '¡Excelente investigación! ${widget.mensajeFinal}';
    if (_preguntando) return 'Usa tu tabla de resultados para contestar.';
    if (u == null) return widget.instruccion;
    final m = widget.muestras[u.$1], p = widget.pruebas[u.$2];
    final r = m.resultados[u.$2];
    final dato = m.datos.length > u.$2 ? m.datos[u.$2] : '';
    return '${p.emoji} ${p.nombre} · ${m.emoji} ${m.nombre}: ${r ? p.si : p.no}. $dato\n\nTe faltan ${total - _hechas.length} pruebas.';
  }

  @override
  Widget build(BuildContext context) {
    final completo = _hechas.length == total;
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.seccion, widget.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 200, child: GloboZatiEle(_mensaje(), tam: 12.5)),
        Positioned(
          left: 8,
          top: 266,
          width: 230,
          height: 206,
          child: PanelEle(
            titulo: 'Mesa de experimentos',
            icono: Icons.science_rounded,
            color: widget.color,
            child: _ultima == null
                ? const Center(child: Text('Toca un “?” de la tabla para hacer la prueba.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5)))
                : Reloj(builder: (_, t) => _escenario(t)),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 352,
          child: _preguntando
              ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.96), borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 3)),
                  child: SingleChildScrollView(
                    child: PreguntaPanel(
                      pregunta: widget.pregunta,
                      onAcierto: (p) => setState(() {
                        _primera = p;
                        _listo = true;
                      }),
                    ),
                  ),
                )
              : _tabla(),
        ),
        if (completo && !_preguntando)
          Positioned(
            left: 470,
            top: 418,
            child: Tooltip(
              message: 'Responder',
              child:
                  BotonJuego(texto: 'Responder', icono: Icons.quiz_rounded, color: const Color(0xFFF5B400), onTap: () => setState(() => _preguntando = true)),
            ),
          ),
        if (_listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
              onTap: () =>
                  terminarPaso(context, actividad: widget.actividad, estrellas: _primera ? 3 : 2, titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _escenario(double t) {
    final (f, c) = _ultima!;
    final m = widget.muestras[f], p = widget.pruebas[c];
    final r = m.resultados[c];
    // La herramienta se acerca al material durante el primer segundo.
    final avance = ((t * 1.5) % 3).clamp(0.0, 1.0);
    return LayoutBuilder(builder: (_, cons) {
      final w = cons.maxWidth;
      return Stack(children: [
        Positioned(left: w / 2 - 34, top: 22, child: Transform.rotate(angle: r ? 0 : math.sin(t * 20) * 0.05, child: Emoji(m.emoji, tam: 56))),
        Positioned(left: w * 0.08 + avance * (w * 0.3), top: 8, child: Emoji(p.emoji, tam: 34)),
        Positioned(
          left: 0,
          right: 0,
          bottom: 2,
          child: Center(
            child: Container(
              key: ValueKey(_vuelta),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: r ? ColoresJuego.correcto : const Color(0xFF78909C), borderRadius: BorderRadius.circular(12)),
              child: Text(r ? p.si : p.no, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      ]);
    });
  }

  Widget _tabla() {
    final n = widget.pruebas.length;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96), borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 3)),
      child: Column(children: [
        Row(children: [
          SizedBox(
              width: 150,
              child: Text('Resultados: ${_hechas.length} de $total',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: oscurecer(widget.color, 0.2)))),
          for (final p in widget.pruebas)
            Expanded(
              child: Column(children: [
                Emoji(p.emoji, tam: 22),
                Text(p.nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700)),
              ]),
            ),
        ]),
        const Divider(height: 8),
        Expanded(
          child: Column(children: [
            for (var f = 0; f < widget.muestras.length; f++)
              Expanded(
                child: Row(children: [
                  SizedBox(
                    width: 150,
                    child: Row(children: [
                      Emoji(widget.muestras[f].emoji, tam: 22),
                      const SizedBox(width: 4),
                      Expanded(child: Text(widget.muestras[f].nombre, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                    ]),
                  ),
                  for (var c = 0; c < n; c++) Expanded(child: Padding(padding: const EdgeInsets.all(2.5), child: _celda(f, c))),
                ]),
              ),
          ]),
        ),
      ]),
    );
  }

  Widget _celda(int f, int c) {
    final hecha = _hechas.contains((f, c));
    final r = widget.muestras[f].resultados[c];
    final p = widget.pruebas[c];
    final col = hecha ? (r ? ColoresJuego.correcto : const Color(0xFF78909C)) : widget.color;
    return Tooltip(
      message: 'Probar ${widget.muestras[f].nombre} · ${p.nombre}',
      child: GestureDetector(
        onTap: () => probar(f, c),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hecha ? aclarar(col, 0.8) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: col, width: _ultima == (f, c) ? 3 : 1.6),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(hecha ? (r ? '✔ ${p.si}' : '✖ ${p.no}') : '?',
                  style: TextStyle(fontSize: hecha ? 13 : 18, fontWeight: FontWeight.w700, color: hecha ? oscurecer(col, 0.25) : widget.color)),
            ),
          ),
        ),
      ),
    );
  }

  // Para pruebas.
  bool get listo => _listo;
  bool get preguntando => _preguntando;
}
