import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/escenario.dart';
import '../biology/tema1/pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import '../biology/temas/pasos.dart' show estrellasPorErrores;
import '../electronica/comun.dart';

/// Una línea de un algoritmo o programa. Si tiene error, trae las opciones
/// para corregirla (la primera es la correcta; se muestran revueltas).
class LineaCodigo {
  const LineaCodigo(this.texto, {this.opciones = const [], this.tipo = '', this.explicacion = '', this.sangria = 0});
  final String texto;
  final List<String> opciones;
  final String tipo, explicacion;
  final int sangria;
  bool get conError => opciones.isNotEmpty;
}

class ProgramaConErrores {
  const ProgramaConErrores({required this.titulo, required this.objetivo, required this.lineas, required this.logro});
  final String titulo, objetivo, logro;
  final List<LineaCodigo> lineas;
}

/// Actividad: encontrar las líneas con errores y elegir cómo corregirlas.
class CazaErrores extends StatefulWidget {
  const CazaErrores({super.key, required this.actividad, required this.seccion, required this.titulo, required this.color, required this.programas, required this.mensajeFinal});
  final String actividad, seccion, titulo, mensajeFinal;
  final Color color;
  final List<ProgramaConErrores> programas;
  @override
  State<CazaErrores> createState() => CazaErroresState();
}

class CazaErroresState extends State<CazaErrores> {
  int _p = 0;
  final _corregidas = <int>{};
  int? _linea;
  int? _elegida;
  int _errores = 0;
  late String _mensaje;

  ProgramaConErrores get prog => widget.programas[_p];
  int get _total => prog.lineas.where((l) => l.conError).length;
  bool get completo => _corregidas.length == _total;

  @override
  void initState() {
    super.initState();
    _mensaje = _inicio();
  }

  String _inicio() => '🐞 Este algoritmo debería: ${prog.objetivo}\nTiene $_total error${_total == 1 ? '' : 'es'}. Toca la línea que creas que está mal.';

  List<String> _opciones(int i) {
    final o = [...prog.lineas[i].opciones];
    // Revuelve siempre igual para cada línea.
    if (o.length > 1) o.insert(o.length - 1 - (i % (o.length - 1)), o.removeAt(0));
    return o;
  }

  void tocarLinea(int i) {
    if (_corregidas.contains(i) || completo) return;
    HapticFeedback.selectionClick();
    setState(() {
      _elegida = null;
      if (prog.lineas[i].conError) {
        _linea = i;
        _mensaje = '¡Encontraste un error en la línea ${i + 1}! ¿Cómo la corriges?';
      } else {
        _linea = null;
        _errores++;
        _mensaje = 'La línea ${i + 1} está bien. Sigue buscando: piensa qué debe pasar en cada paso.';
      }
    });
  }

  void elegir(String opcion) {
    final i = _linea;
    if (i == null) return;
    final l = prog.lineas[i];
    setState(() {
      _elegida = _opciones(i).indexOf(opcion);
      if (opcion == l.opciones.first) {
        HapticFeedback.mediumImpact();
        _corregidas.add(i);
        _linea = null;
        _mensaje = completo ? '¡Programa depurado! 🎉 ${prog.logro}' : '✅ ${l.tipo}: ${l.explicacion} Te faltan ${_total - _corregidas.length}.';
      } else {
        HapticFeedback.heavyImpact();
        _errores++;
        _mensaje = 'Esa corrección no resuelve el problema. Piensa otra vez.';
      }
    });
  }

  void _siguiente() {
    if (_p < widget.programas.length - 1) {
      setState(() {
        _p++;
        _corregidas.clear();
        _linea = null;
        _mensaje = _inicio();
      });
    } else {
      terminarPaso(context, actividad: widget.actividad, estrellas: estrellasPorErrores(_errores), titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i = _linea;
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.seccion, widget.programas.length > 1 ? '${widget.titulo} · ${_p + 1} de ${widget.programas.length}' : widget.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 200, child: GloboZatiEle(_mensaje, tam: 13)),
        Positioned(
          left: 8,
          top: 266,
          width: 230,
          height: 206,
          child: PanelEle(
            titulo: 'Tipos de error',
            icono: Icons.bug_report_rounded,
            color: const Color(0xFFE53935),
            child: const SingleChildScrollView(
              child: Text(
                '• De orden: un paso está antes de tiempo.\n• Falta o sobra un paso.\n• De condición: el “si” o el “mientras” revisan algo equivocado.\n• De sintaxis: está mal escrito.\n• Ciclo infinito: nunca termina.',
                style: TextStyle(fontSize: 12, height: 1.25),
              ),
            ),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: i == null ? 608 : 340,
          height: 352,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF263238), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF546E7A), width: 2)),
            child: Column(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: const BoxDecoration(color: Color(0xFF37474F), borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                child: Text('📄 ${prog.titulo}   ·   Errores corregidos: ${_corregidas.length} de $_total',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
              Expanded(
                child: ListView(padding: const EdgeInsets.all(6), children: [
                  for (var k = 0; k < prog.lineas.length; k++) _fila(k),
                ]),
              ),
            ]),
          ),
        ),
        if (i != null)
          Positioned(
            left: 592,
            top: 60,
            width: 260,
            height: 352,
            child: PanelEle(
              titulo: 'Corrige la línea ${i + 1}',
              icono: Icons.build_rounded,
              color: widget.color,
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  for (final (k, o) in _opciones(i).indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: BotonOpcion(
                        letra: 'ABCD'[k],
                        texto: o,
                        estado: _elegida == k ? EstadoOpcion.incorrecta : EstadoOpcion.normal,
                        onTap: () => elegir(o),
                      ),
                    ),
                ]),
              ),
            ),
          ),
        if (completo) Positioned(left: 690, top: 420, child: BotonSiguiente(texto: _p < widget.programas.length - 1 ? 'Siguiente programa' : 'Terminar', onTap: _siguiente)),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _fila(int k) {
    final l = prog.lineas[k];
    final ok = _corregidas.contains(k);
    final sel = _linea == k;
    final texto = ok ? l.opciones.first : l.texto;
    return Tooltip(
      message: 'Línea ${k + 1}',
      child: GestureDetector(
        onTap: () => tocarLinea(k),
        child: Container(
          margin: const EdgeInsets.only(bottom: 3),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: sel ? const Color(0x55FFD600) : (ok ? const Color(0x3343A047) : Colors.transparent),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(width: 22, child: Text('${k + 1}', style: const TextStyle(fontSize: 12.5, color: Color(0xFF90A4AE), fontWeight: FontWeight.w700))),
            SizedBox(width: 14.0 * l.sangria),
            Expanded(
              child: Text(texto,
                  style: TextStyle(fontSize: 13.5, height: 1.2, fontWeight: FontWeight.w600, color: ok ? const Color(0xFFA5D6A7) : const Color(0xFFECEFF1))),
            ),
            if (ok) const Text(' ✅', style: TextStyle(fontSize: 12)),
          ]),
        ),
      ),
    );
  }

  // Para pruebas.
  int get programa => _p;
  int get errores => _errores;
}
