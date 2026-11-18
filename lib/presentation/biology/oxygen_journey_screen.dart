
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'air_tunnel_screen.dart';
import 'oxygen_journey_game.dart';

class OxygenJourneyScreen extends StatefulWidget {
  const OxygenJourneyScreen({super.key});

  @override
  State<OxygenJourneyScreen> createState() =>
      _OxygenJourneyScreenState();
}

class _OxygenJourneyScreenState
    extends State<OxygenJourneyScreen> {
  late final OxygenJourneyGame game;

  int collectedBubbles = 0;
  bool completed = false;

  String zatiMessage =
      '¡Hola, explorador! Soy Zati. '
      'Ayuda a Oxi a recoger 5 burbujas brillantes. '
      '¡Pero cuidado con el polvo!';

  @override
  void initState() {
    super.initState();

    game = OxygenJourneyGame(
      onProgress: (count) {
        if (!mounted) return;

        setState(() {
          collectedBubbles = count;
          zatiMessage =
              '¡Muy bien! Ya tienes $count de 5. '
              '¡Sigue buscando!';
        });
      },
      onCompleted: () {
        if (!mounted) return;

        setState(() {
          completed = true;
          zatiMessage =
              '¡Fantástico! Tu nariz ayuda a detener '
              'el polvo antes de que el aire siga '
              'su camino hacia los pulmones.';
        });
      },
      onDustTouched: () {
        if (!mounted) return;

        setState(() {
          zatiMessage =
              '¡Ups, apareció polvo! No pasa nada. '
              '¡Intenta esquivarlo y sigue jugando!';
        });
      },
    );
  }

  void restartGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OxygenJourneyScreen(),
      ),
    );
  }

  void openNextAdventure() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AirTunnelScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: AppBar(
        title: const Text('¡Rescate de aire!'),
        backgroundColor: const Color(0xFF134C79),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 800;

          final gameArea = Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) {
                      game.movePlayerTo(
                        details.localPosition,
                      );
                    },
                    onPanUpdate: (details) {
                      game.movePlayerTo(
                        details.localPosition,
                      );
                    },
                    onTapDown: (details) {
                      game.movePlayerTo(
                        details.localPosition,
                      );
                    },
                    child: GameWidget<OxygenJourneyGame>(
                      game: game,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: collectedBubbles /
                    OxygenJourneyGame.targetBubbles,
                minHeight: 12,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF1CBF87),
                backgroundColor: const Color(0xFFD2E6F1),
              ),
              const SizedBox(height: 8),
              Text(
                '✨ Burbujas: $collectedBubbles / '
                '${OxygenJourneyGame.targetBubbles}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF164C73),
                ),
              ),
            ],
          );

          final information = completed
              ? buildCompletionCard()
              : buildInstructionsCard();

          if (isDesktop) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: gameArea,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: information,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              SizedBox(
                height: 410,
                child: gameArea,
              ),
              const SizedBox(height: 12),
              information,
            ],
          );
        },
      ),
    );
  }

  Widget buildInstructionsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/zati.png',
                  width: 80,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) {
                    return const Icon(
                      Icons.smart_toy,
                      size: 65,
                      color: Color(0xFF167D82),
                    );
                  },
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    '¡Zati te acompaña!',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF173F69),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE7F6FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                zatiMessage,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '🎮 ¿Cómo jugar?',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Mueve a Oxi con el mouse o el dedo.\n'
              '2. Recoge las burbujas brillantes.\n'
              '3. Esquiva las partículas de polvo.\n'
              '4. ¡Consigue 5 burbujas!',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '💡 ¿Sabías que...?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando respiras por la nariz, '
              'sus pequeños pelitos y la mucosidad '
              'ayudan a atrapar polvo y otras partículas.',
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCompletionCard() {
    return Card(
      color: const Color(0xFFE1F8E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              size: 75,
              color: Color(0xFFD49A12),
            ),
            const SizedBox(height: 12),
            const Text(
              '¡LO LOGRASTE!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Color(0xFF237A53),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              zatiMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '🏅 ¡Eres un explorador del aire!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Continue to the second minigame.
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: openNextAdventure,
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  '¡SIGUIENTE AVENTURA!',
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: restartGame,
                icon: const Icon(Icons.replay),
                label: const Text('VOLVER A JUGAR'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text(
                  'REGRESAR A BIOLOGÍA',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
