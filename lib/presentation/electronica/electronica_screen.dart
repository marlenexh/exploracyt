import 'package:flutter/material.dart';

import '../../data/ele_topics.dart';
import '../../data/models.dart';
import '../mundo_temas_screen.dart';
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
        descripcion: 'Conoce cómo funcionan los aparatos electrónicos y cómo sus componentes trabajan juntos.',
      );
}
