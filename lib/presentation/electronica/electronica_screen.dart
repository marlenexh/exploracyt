import 'package:flutter/material.dart';

import '../../data/ele_topics.dart';
import '../../data/models.dart';
import '../../data/laboratorios.dart';
import '../../main.dart' show store;
import '../laboratorio_mundo.dart';
import '../mundo_temas_screen.dart';
import 'laboratorio_ele.dart';
import '../biology/temas/motor.dart';
import 'ele_tema1.dart';
import 'ele_tema2.dart';
import 'ele_tema3.dart';
import 'ele_tema4.dart';
import 'ele_tema5.dart';
import 'fondos.dart';

/// Juegos de los temas de Electrónica, por número de tema.
final temasEle = <int, TemaBio>{1: eleTema1, 2: eleTema2, 3: eleTema3, 4: eleTema4, 5: eleTema5};

const _emojisTema = {1: '🔌', 2: '⚡', 3: '🕵️', 4: '⚙️', 5: '🤖'};

/// Mapa del mundo de Electrónica: "La ciudad de los circuitos".
class ElectronicaScreen extends StatelessWidget {
  const ElectronicaScreen({super.key, required this.mundo});
  final Mundo mundo;

  @override
  Widget build(BuildContext context) => MundoTemasScreen(
        mundo: mundo,
        temas: temasEle,
        infos: eleTopics,
        contenidos: eleContenidos,
        emojis: _emojisTema,
        fondo: const FondoElectronica(FondoEle.placa),
        extra: (context, ancho, enFila) => TarjetaLaboratorioMundo(
          lab: laboratoriosMundos['ele']!,
          color: const Color(0xFFFF8F00),
          ancho: ancho,
          enFila: enFila,
          temasHechos: eleTopics.values.where((i) => store.completadas.contains(i.missionIds.last)).length,
          pantalla: (_) => PantallaLaboratorioMundo(
            prediccion: 'ele-lab',
            estilo: estiloEle(FondoEle.taller),
            child: LaboratorioEle(onTerminar: (_) => completarLaboratorio(laboratoriosMundos['ele']!)),
          ),
        ),
        descripcion: 'Conoce cómo funcionan los aparatos electrónicos y cómo sus componentes trabajan juntos.',
      );
}
