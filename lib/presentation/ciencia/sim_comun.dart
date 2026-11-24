import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/comunes.dart';
import '../electronica/comun.dart';

/// Piezas comunes de las simulaciones de los mundos de ciencia.

/// Lista de objetivos con palomitas.
Widget objetivosPanel(List<String> metas, Set<int> hechas, Color color, {String titulo = 'Objetivos'}) => PanelEle(
      titulo: titulo,
      icono: Icons.flag_rounded,
      color: color,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (var k = 0; k < metas.length; k++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(hechas.contains(k) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 18, color: hechas.contains(k) ? ColoresJuego.correcto : Colors.black38),
                const SizedBox(width: 4),
                Expanded(child: Text(metas[k], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.15))),
              ]),
            ),
        ]),
      ),
    );

Widget deslizador(BuildContext context, String emoji, String texto, double v, ValueChanged<double> cambio, Color color, {double min = 0, double max = 1}) =>
    Row(children: [
      SizedBox(width: 30, child: Text(emoji, style: const TextStyle(fontSize: 20))),
      SizedBox(width: 96, child: Text(texto, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
      Expanded(
        child: Tooltip(
          message: texto,
          child: Slider(value: v, min: min, max: max, onChanged: cambio, activeColor: color),
        ),
      ),
    ]);

/// Base para simulaciones con objetivos: muestra Siguiente al lograrlos todos.
mixin ObjetivosSim<T extends StatefulWidget> on State<T> {
  final hechas = <int>{};
  void lograr(int k) {
    if (hechas.add(k)) HapticFeedback.mediumImpact();
  }
}
