import 'package:flutter/material.dart';

import '../data/laboratorios.dart';
import 'ciencia/piensa_antes.dart';
import '../data/brujula.dart';
import '../main.dart' show store;
import 'biology/tema1/comunes.dart' show temaJuego;
import 'biology/tema1/estilo_mundo.dart';

/// Tarjeta del laboratorio final en el mapa de un mundo.
class TarjetaLaboratorioMundo extends StatelessWidget {
  const TarjetaLaboratorioMundo({
    super.key,
    required this.lab,
    required this.color,
    required this.pantalla,
    this.ancho = false,
    this.enFila = false,
    this.temasHechos = 0,
  });
  final LaboratorioMundo lab;
  final Color color;

  /// Construye la pantalla del laboratorio.
  final WidgetBuilder pantalla;
  final bool ancho, enFila;
  final int temasHechos;

  @override
  Widget build(BuildContext context) {
    final hecho = store.recompensas.contains(lab.badgeId);
    final claro = Color.lerp(color, Colors.white, 0.88)!;
    final medio = Color.lerp(color, Colors.white, 0.7)!;
    final oscuro = Color.lerp(color, Colors.black, 0.45)!;
    final sub = TextStyle(fontFamily: 'Fredoka', fontSize: 13, fontWeight: FontWeight.w600, color: hecho ? const Color(0xFFB8860B) : oscuro);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ancho ? 6 : 0, vertical: enFila ? 0 : 6),
      child: Material(
        borderRadius: BorderRadius.circular(22),
        elevation: 6,
        color: claro,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: pantalla)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: color, width: 3.5),
              gradient: LinearGradient(colors: [claro, medio]),
            ),
            child: enFila
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: 150,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(lab.emoji, style: const TextStyle(fontSize: 42)),
                        Text(lab.titulo, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: oscuro, height: 1.05)),
                        const SizedBox(height: 4),
                        Text(hecho ? '🏅 ${lab.insignia}' : lab.descripcion, textAlign: TextAlign.center, style: sub.copyWith(fontSize: 12.5)),
                        const SizedBox(height: 8),
                        Icon(Icons.play_circle_fill_rounded, color: color, size: 40),
                      ]),
                    ),
                  )
                : Row(children: [
                    Text(lab.emoji, style: const TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        Text(lab.titulo, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: oscuro, height: 1.05)),
                        Text(
                          hecho
                              ? '🏅 ${lab.insignia} · 🧭 ¡${piezaDelMundo(lab.mundo).nombre} recuperada!'
                              : '🧭 Aquí está la ${piezaDelMundo(lab.mundo).nombre}. ${lab.descripcion} ${temasHechos < 5 ? 'Recomendado al terminar los 5 temas ($temasHechos de 5).' : '¡Ya puedes hacerlo!'}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: sub,
                        ),
                      ]),
                    ),
                    Icon(Icons.play_circle_fill_rounded, color: color, size: 40),
                  ]),
          ),
        ),
      ),
    );
  }
}

/// Envoltura común de las pantallas de laboratorio: fondo del mundo y tema
/// del juego.
class PantallaLaboratorioMundo extends StatelessWidget {
  const PantallaLaboratorioMundo({super.key, required this.estilo, required this.child, this.prediccion});
  final EstiloMundo estilo;
  final Widget child;

  /// Id de la pregunta “Piensa antes de empezar” (se muestra con el fondo del mundo).
  final String? prediccion;
  @override
  Widget build(BuildContext context) =>
      FondoJuego(estilo: estilo, child: Theme(data: temaJuego(), child: prediccion == null ? child : conPrediccion(prediccion!, child)));
}

/// Registra el laboratorio como terminado y entrega su insignia.
void completarLaboratorio(LaboratorioMundo lab) => store.completar(lab.id, recompensaId: lab.badgeId);
