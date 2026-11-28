import 'package:flutter/material.dart';

import '../../data/predicciones.dart';
import '../biology/tema1/escenario.dart';
import '../biology/tema1/pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import '../biology/tema1/ui_divertida.dart' show BotonJuego;
import '../electronica/comun.dart';
import 'barajar.dart';

const _morado = Color(0xFF7C4DFF);

/// Muestra la pantalla de un paso; si el paso tiene predicción, primero
/// pregunta “¿Qué crees que pasará?” para que el alumno piense antes.
Widget conPrediccion(String paso, Widget pantalla) {
  final p = predicciones[paso];
  return p == null ? pantalla : PiensaAntes(prediccion: p, child: pantalla);
}

/// “Piensa antes de empezar”: el alumno elige qué cree que pasará (no se
/// califica) y luego hace la actividad. Durante la actividad puede tocar
/// 🤔 para ver su idea y compararla con lo que en verdad pasa.
class PiensaAntes extends StatefulWidget {
  const PiensaAntes({super.key, required this.prediccion, required this.child});
  final Prediccion prediccion;
  final Widget child;
  @override
  State<PiensaAntes> createState() => PiensaAntesState();
}

class PiensaAntesState extends State<PiensaAntes> {
  /// Opción elegida (índice original).
  int? elegida;
  bool empezo = false;
  bool verIdea = false;

  Prediccion get p => widget.prediccion;

  void elegir(int i) => setState(() => elegida = i);
  void empezar() => setState(() => empezo = true);

  @override
  Widget build(BuildContext context) {
    if (empezo) {
      return Stack(children: [
        Positioned.fill(child: widget.child),
        Positioned(
          right: 6,
          top: 6,
          child: SafeArea(child: _idea()),
        ),
      ]);
    }
    final orden = ordenOpciones(p.pregunta, p.opciones.length);
    return Escenario(
      velo: 0.1,
      colorVelo: _morado,
      children: [
        encabezadoEle('Piensa antes', '🤔 ¿Qué crees que pasará?', _morado),
        Positioned(
          left: 8,
          top: 64,
          width: 230,
          height: 200,
          child: GloboZatiEle(
              elegida == null
                  ? 'Antes de empezar, ¡piensa como en la ciencia! Elige lo que crees que va a pasar. No hay calificación: es tu idea (tu hipótesis).'
                  : '¡Buena idea! 💡 Ahora haz la actividad y compruébalo. Si quieres ver tu idea otra vez, toca el botón 🤔.',
              tam: 14),
        ),
        Positioned(
          left: 250,
          top: 64,
          width: 600,
          height: 340,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _morado, width: 4),
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(p.pregunta, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, height: 1.2)),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    for (final (pos, i) in orden.indexed)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BotonOpcion(
                          letra: 'ABCD'[pos],
                          texto: p.opciones[i],
                          estado: elegida == i ? EstadoOpcion.correcta : EstadoOpcion.normal,
                          onTap: () => elegir(i),
                        ),
                      ),
                  ]),
                ),
              ),
            ]),
          ),
        ),
        if (elegida != null)
          Positioned(
            left: 560,
            top: 414,
            child: Tooltip(
              message: '¡A comprobarlo!',
              child: BotonJuego(texto: '¡A comprobarlo!', icono: Icons.science_rounded, color: const Color(0xFF2DB84C), onTap: empezar),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  /// Botón 🤔 que muestra la idea del alumno y lo que en verdad pasa.
  Widget _idea() {
    final acerto = elegida == p.correcta;
    return Material(
      color: Colors.transparent,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        alignment: Alignment.topRight,
        child: verIdea
            ? Container(
                width: 300,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _morado, width: 3),
                  boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    const Expanded(child: Text('🤔 Tu idea', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: _morado))),
                    InkWell(
                      onTap: () => setState(() => verIdea = false),
                      child: const Padding(padding: EdgeInsets.all(2), child: Icon(Icons.close_rounded, size: 20)),
                    ),
                  ]),
                  Text('“${p.opciones[elegida ?? 0]}”', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(acerto ? '✅ ¡Tu idea era correcta!' : '🔎 Lo que en verdad pasa: ${p.opciones[p.correcta]}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: acerto ? const Color(0xFF2E7D32) : const Color(0xFFE65100))),
                  const SizedBox(height: 4),
                  Text(p.porque, style: const TextStyle(fontSize: 13.5, height: 1.25)),
                  if (!acerto)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text('¡Equivocarse también es aprender! Así trabajan los científicos.',
                          style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic)),
                    ),
                ]),
              )
            : Tooltip(
                message: 'Ver mi idea',
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => setState(() => verIdea = true),
                  child: Container(
                    width: 46,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF59D),
                      shape: BoxShape.circle,
                      border: Border.all(color: _morado, width: 3),
                      boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 8, offset: Offset(0, 3))],
                    ),
                    child: const Text('🤔', style: TextStyle(fontSize: 23)),
                  ),
                ),
              ),
      ),
    );
  }
}
