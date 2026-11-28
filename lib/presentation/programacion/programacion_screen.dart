import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/pro_topics.dart';
import '../../main.dart' show store;
import '../biology/tema1/comunes.dart' show temaJuego;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart';
import '../mundo_temas_screen.dart';
import 'estudio.dart';
import 'fondos_pro.dart';
import 'pro_tema1.dart';
import 'pro_tema2.dart';
import 'pro_tema3.dart';
import 'pro_tema4.dart';
import 'pro_tema5.dart';
import '../ciencia/piensa_antes.dart';

/// Juegos de los temas de Programación, por número de tema.
final temasPro = <int, TemaBio>{1: proTema1, 2: proTema2, 3: proTema3, 4: proTema4, 5: proTema5};

const _emojisTema = {1: '🧠', 2: '📜', 3: '🧩', 4: '🔁', 5: '🐞'};

/// Mapa del mundo de Programación: "El reino de los algoritmos".
class ProgramacionScreen extends StatelessWidget {
  const ProgramacionScreen({super.key, required this.mundo});
  final Mundo mundo;

  @override
  Widget build(BuildContext context) => MundoTemasScreen(
        mundo: mundo,
        temas: temasPro,
        infos: proTopics,
        contenidos: proContenidos,
        emojis: _emojisTema,
        colorFondo: const Color(0xFF1A91AC),
        fondo: const FondoProgramacion(FondoPro.reino),
        descripcion: 'Aprende a pensar como programador, crea algoritmos y programa con bloques.',
        extra: (context, ancho, enFila) => TarjetaLaboratorio(ancho: ancho, enFila: enFila),
      );
}

/// Tarjeta del laboratorio final: crear un videojuego.
class TarjetaLaboratorio extends StatelessWidget {
  const TarjetaLaboratorio({super.key, required this.ancho, this.enFila = false});
  final bool ancho, enFila;

  @override
  Widget build(BuildContext context) {
    final hecho = store.recompensas.contains(proLabBadgeId);
    final temasHechos = proTopics.values.where((i) => store.completadas.contains(i.missionIds.last)).length;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ancho ? 6 : 0, vertical: enFila ? 0 : 6),
      child: Material(
        borderRadius: BorderRadius.circular(22),
        elevation: 6,
        color: const Color(0xFFFFF8E1),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaboratorioProgramadorScreen())),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFFFB300), width: 3.5),
              gradient: const LinearGradient(colors: [Color(0xFFFFF8E1), Color(0xFFFFECB3)]),
            ),
            child: enFila
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: 150,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('🎮', style: TextStyle(fontSize: 42)),
                        const Text('Laboratorio del programador',
                            textAlign: TextAlign.center, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: Color(0xFF5D4037), height: 1.05)),
                        const SizedBox(height: 4),
                        Text(hecho ? '🏅 $proLabBadge' : 'Crea, prueba y publica tu propio videojuego.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: hecho ? const Color(0xFFB8860B) : const Color(0xFF6D4C41))),
                        const SizedBox(height: 8),
                        const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFF8F00), size: 40),
                      ]),
                    ),
                  )
                : Row(children: [
                    const Text('🎮', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        const Text('Laboratorio del programador: crea tu videojuego',
                            style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: Color(0xFF5D4037), height: 1.05)),
                        Text(
                            hecho
                                ? '🏅 $proLabBadge · 🧭 ¡Pieza del Código recuperada!'
                                : '🧭 Aquí está la Pieza del Código. Programa los eventos de tu propio juego, pruébalo, encuentra sus bugs y publícalo. ${temasHechos < 5 ? 'Recomendado al terminar los 5 temas ($temasHechos de 5).' : '¡Ya estás listo!'}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'Fredoka',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: hecho ? const Color(0xFFB8860B) : const Color(0xFF6D4C41))),
                      ]),
                    ),
                    const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFF8F00), size: 40),
                  ]),
          ),
        ),
      ),
    );
  }
}

/// Pantalla del laboratorio; al publicar el juego se gana la insignia.
class LaboratorioProgramadorScreen extends StatelessWidget {
  const LaboratorioProgramadorScreen({super.key});
  @override
  Widget build(BuildContext context) => FondoJuego(
        estilo: estiloPro(FondoPro.castillo),
        child: Theme(
          data: temaJuego(),
          child: conPrediccion(
            'pro-lab',
            EstudioVideojuegos(onTerminar: (_) => store.completar(proLabId, recompensaId: proLabBadgeId)),
          ),
        ),
      );
}
