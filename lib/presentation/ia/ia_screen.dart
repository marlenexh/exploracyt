import 'package:flutter/material.dart';

import '../../data/ia_topics.dart';
import '../../data/models.dart';
import '../../main.dart' show store;
import '../biology/tema1/comunes.dart' show temaJuego;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart';
import '../mundo_temas_screen.dart';
import 'fondos_ia.dart';
import 'ia_tema1.dart';
import 'ia_tema2.dart';
import 'ia_tema3.dart';
import 'ia_tema4.dart';
import 'ia_tema5.dart';
import 'laboratorio_ia.dart';

/// Juegos de los temas de Inteligencia Artificial, por número de tema.
final temasIA = <int, TemaBio>{1: iaTema1, 2: iaTema2, 3: iaTema3, 4: iaTema4, 5: iaTema5};

const _emojisTema = {1: '🤖', 2: '🔍', 3: '🎓', 4: '📱', 5: '🛡️'};

/// Mapa del mundo de IA: "La estación de las máquinas inteligentes".
class InteligenciaArtificialScreen extends StatelessWidget {
  const InteligenciaArtificialScreen({super.key, required this.mundo});
  final Mundo mundo;

  @override
  Widget build(BuildContext context) => MundoTemasScreen(
        mundo: mundo,
        temas: temasIA,
        infos: iaTopics,
        contenidos: iaContenidos,
        emojis: _emojisTema,
        colorFondo: const Color(0xFF4A1259),
        fondo: const FondoInteligencia(FondoIA.estacion),
        descripcion: 'Descubre cómo piensan, aprenden y ayudan las máquinas inteligentes… y cómo usarlas con cuidado.',
        extra: (context, ancho, enFila) => TarjetaLaboratorioIA(ancho: ancho, enFila: enFila),
      );
}

/// Tarjeta del laboratorio final: construir una IA.
class TarjetaLaboratorioIA extends StatelessWidget {
  const TarjetaLaboratorioIA({super.key, required this.ancho, this.enFila = false});
  final bool ancho, enFila;

  static const _titulo = 'Laboratorio de IA';
  static const _texto = 'Reúne datos, etiquétalos, entrena y publica tu propia IA.';

  @override
  Widget build(BuildContext context) {
    final hecho = store.recompensas.contains(iaLabBadgeId);
    final temasHechos = iaTopics.values.where((i) => store.completadas.contains(i.missionIds.last)).length;
    const cafe = Color(0xFF4A148C);
    final sub = TextStyle(fontFamily: 'Fredoka', fontSize: 13, fontWeight: FontWeight.w600, color: hecho ? const Color(0xFFB8860B) : const Color(0xFF6A1B9A));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ancho ? 6 : 0, vertical: enFila ? 0 : 6),
      child: Material(
        borderRadius: BorderRadius.circular(22),
        elevation: 6,
        color: const Color(0xFFF3E5F5),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaboratorioIAScreen())),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFAB47BC), width: 3.5),
              gradient: const LinearGradient(colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)]),
            ),
            child: enFila
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SizedBox(
                      width: 150,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('🧪', style: TextStyle(fontSize: 42)),
                        const Text(_titulo, textAlign: TextAlign.center, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: cafe, height: 1.05)),
                        const SizedBox(height: 4),
                        Text(hecho ? '🏅 $iaLabBadge' : _texto, textAlign: TextAlign.center, style: sub.copyWith(fontSize: 12.5)),
                        const SizedBox(height: 8),
                        const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF8E24AA), size: 40),
                      ]),
                    ),
                  )
                : Row(children: [
                    const Text('🧪', style: TextStyle(fontSize: 40)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                        const Text('$_titulo: construye tu IA', style: TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: cafe, height: 1.05)),
                        Text(
                          hecho
                              ? '🏅 $iaLabBadge · 🧭 ¡Pieza de la Inteligencia recuperada!'
                              : '🧭 Aquí está la Pieza de la Inteligencia. $_texto ${temasHechos < 5 ? 'Recomendado al terminar los 5 temas ($temasHechos de 5).' : '¡Ya estás listo!'}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: sub,
                        ),
                      ]),
                    ),
                    const Icon(Icons.play_circle_fill_rounded, color: Color(0xFF8E24AA), size: 40),
                  ]),
          ),
        ),
      ),
    );
  }
}

/// Pantalla del laboratorio; al publicar la IA se gana la insignia.
class LaboratorioIAScreen extends StatelessWidget {
  const LaboratorioIAScreen({super.key});
  @override
  Widget build(BuildContext context) => FondoJuego(
        estilo: estiloIA(FondoIA.laboratorio),
        child: Theme(
          data: temaJuego(),
          child: LaboratorioIA(onTerminar: (_) => store.completar(iaLabId, recompensaId: iaLabBadgeId)),
        ),
      );
}
