import 'package:flutter/material.dart';

import '../biology/tema1/aventura.dart' show BannerTitulo;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';

/// Piezas de pantalla compartidas por las simulaciones de Electrónica.

Widget encabezadoEle(String seccion, String titulo, Color color) => Positioned(
      left: 64,
      top: 10,
      right: 8,
      child: Row(
        children: [
          EtiquetaSeccion(seccion),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: BannerTitulo(titulo, tam: 22, color: oscurecer(color, 0.05)),
            ),
          ),
        ],
      ),
    );

/// Globo de Zati con el mensaje del momento (Zati pequeño a la izquierda).
class GloboZatiEle extends StatelessWidget {
  const GloboZatiEle(this.texto, {super.key, this.tam = 13.5});
  final String texto;
  final double tam;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF7C4DFF), width: 2.5),
          boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 50, height: 62, child: ZatiMascota(tam: 62)),
            const SizedBox(width: 4),
            Expanded(
              child: SingleChildScrollView(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(texto, key: ValueKey(texto), style: TextStyle(fontSize: tam, height: 1.2, color: ColoresJuego.texto)),
                ),
              ),
            ),
          ],
        ),
      );
}

/// Panel blanco con título de color.
class PanelEle extends StatelessWidget {
  const PanelEle({super.key, required this.titulo, required this.color, required this.child, this.icono});
  final String titulo;
  final Color color;
  final Widget child;
  final IconData? icono;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: 2.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              if (icono != null) ...[Icon(icono, size: 18, color: color), const SizedBox(width: 4)],
              Expanded(child: Text(titulo, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: oscurecer(color, 0.15)))),
            ]),
            const SizedBox(height: 4),
            Expanded(child: child),
          ],
        ),
      );
}

/// Chip para elegir una opción.
class ChipEle extends StatelessWidget {
  const ChipEle({super.key, required this.texto, required this.activo, required this.onTap, this.color = const Color(0xFF7C4DFF), this.punto});
  final String texto;
  final bool activo;
  final VoidCallback onTap;
  final Color color;
  final Color? punto;
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: activo ? color : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (punto != null) ...[
              Container(width: 10, height: 10, decoration: BoxDecoration(color: punto, shape: BoxShape.circle, border: Border.all(color: Colors.black26))),
              const SizedBox(width: 4),
            ],
            Text(texto, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: activo ? Colors.white : oscurecer(color, 0.2))),
          ]),
        ),
      );
}
