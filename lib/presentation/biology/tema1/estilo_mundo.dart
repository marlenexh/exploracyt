import 'package:flutter/material.dart';

/// Estilo visual de un mundo (fondo y letrero) para reutilizar las pantallas
/// del Tema 1 en otros mundos, por ejemplo Electrónica.
///
/// Si no hay [FondoJuego] arriba en el árbol se usa el bosque de Biología.
class EstiloMundo {
  const EstiloMundo({
    required this.fondo,
    this.letrero = const [Color(0xFFE9B36B), Color(0xFFC98A3E)],
    this.bordeLetrero = const Color(0xFF8A5A24),
    this.sombraLetrero = const Color(0xFF6B4219),
    this.textoLetrero = const Color(0xFF4A2A0C),
  });

  /// Fondo a pantalla completa (puede ser animado).
  final WidgetBuilder fondo;
  final List<Color> letrero;
  final Color bordeLetrero, sombraLetrero, textoLetrero;
}

class FondoJuego extends InheritedWidget {
  const FondoJuego({super.key, required this.estilo, required super.child});
  final EstiloMundo estilo;

  static EstiloMundo? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FondoJuego>()?.estilo;

  @override
  bool updateShouldNotify(FondoJuego old) => old.estilo != estilo;
}
