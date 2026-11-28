import 'dart:math' as math;

/// Orden en que se muestran las opciones de una pregunta.
///
/// Las opciones se escriben con la correcta donde sea (casi siempre la
/// primera), pero el alumno las ve mezcladas para que no aprenda que “la
/// buena es la A”. El orden depende del texto de la pregunta: siempre es el
/// mismo para la misma pregunta (no cambia al redibujar la pantalla) y es
/// distinto entre preguntas. Devuelve los índices originales en el orden en
/// que se muestran.
List<int> ordenOpciones(String semilla, int n) {
  // FNV-1a: el mismo resultado en web, Android e iOS.
  var h = 0x811c9dc5;
  for (final c in semilla.codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0x7fffffff;
  }
  final orden = List<int>.generate(n, (i) => i)..shuffle(math.Random(h));
  return orden;
}
