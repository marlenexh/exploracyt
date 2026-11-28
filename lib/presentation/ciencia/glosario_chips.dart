import 'package:flutter/material.dart';

import '../../data/glosario.dart';
import '../biology/tema1/escenario.dart' show ventanaZati;

/// “📖 Palabras difíciles” del texto: al tocar una, Zati la explica.
class ChipsGlosario extends StatelessWidget {
  const ChipsGlosario({super.key, required this.texto, required this.color});
  final String texto;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final palabras = palabrasEn(texto);
    if (palabras.isEmpty) return const SizedBox.shrink();
    return Wrap(spacing: 4, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xEE3E2723), borderRadius: BorderRadius.circular(10)),
        child: const Text('📖 Palabras difíciles', style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w800)),
      ),
      for (final p in palabras)
        Tooltip(
          message: '¿Qué es ${p.palabra}?',
          child: Material(
            color: Colors.white,
            shape: StadiumBorder(side: BorderSide(color: color, width: 2)),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () => ventanaZati(context, titulo: '${p.emoji} ${p.palabra}', texto: p.significado, color: color),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: Text('${p.emoji} ${p.palabra}', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: color)),
              ),
            ),
          ),
        ),
    ]);
  }
}
