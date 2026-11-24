import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../data/qui_topics.dart';
import '../biology/temas/motor.dart';
import 'fondos_qui.dart';
import '../mundo_temas_screen.dart';
import 'qui_tema1.dart';
import 'qui_tema2.dart';
import 'qui_tema3.dart';
import 'qui_tema4.dart';
import 'qui_tema5.dart';

/// Juegos de los temas de Química, por número de tema.
final temasQui = <int, TemaBio>{1: quiTema1, 2: quiTema2, 3: quiTema3, 4: quiTema4, 5: quiTema5};

const _emojisTema = {1: '🧱', 2: '🎈', 3: '🔄', 4: '🍲', 5: '🔥'};

/// Mapa del mundo de Química: "El laboratorio de los materiales misteriosos".
class QuimicaScreen extends StatelessWidget {
  const QuimicaScreen({super.key, required this.mundo});
  final Mundo mundo;

  @override
  Widget build(BuildContext context) => MundoTemasScreen(
        mundo: mundo,
        temas: temasQui,
        infos: quiTopics,
        contenidos: quiContenidos,
        emojis: _emojisTema,
        colorFondo: const Color(0xFF8D13FF),
        fondo: const FondoQuimica(FondoQui.laboratorio),
        descripcion: 'Investiga los materiales, los gases y cómo se transforma todo a tu alrededor.',
      );
}
