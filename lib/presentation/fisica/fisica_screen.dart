import 'package:flutter/material.dart';

import '../../data/fis_topics.dart';
import '../../data/models.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fondos_ciencia.dart';
import '../mundo_temas_screen.dart';
import 'fis_tema1.dart';
import 'fis_tema2.dart';
import 'fis_tema3.dart';
import 'fis_tema4.dart';
import 'fis_tema5.dart';

/// Juegos de los temas de Física, por número de tema.
final temasFis = <int, TemaBio>{1: fisTema1, 2: fisTema2, 3: fisTema3, 4: fisTema4, 5: fisTema5};

const _emojisTema = {1: '🧲', 2: '🍎', 3: '🌡️', 4: '⚡', 5: '🪐'};

/// Mapa del mundo de Física: "El valle de las fuerzas y la energía".
class FisicaScreen extends StatelessWidget {
  const FisicaScreen({super.key, required this.mundo});
  final Mundo mundo;

  @override
  Widget build(BuildContext context) => MundoTemasScreen(
        mundo: mundo,
        temas: temasFis,
        infos: fisTopics,
        contenidos: fisContenidos,
        emojis: _emojisTema,
        colorFondo: const Color(0xFF026CFF),
        fondo: const FondoCienciaWidget(FondoCiencia.valle),
        descripcion: 'Descubre los imanes, la gravedad, el calor, la energía y el Sistema Solar.',
      );
}
