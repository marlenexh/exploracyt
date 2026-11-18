
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'air_tunnel_game.dart';

class AirTunnelScreen extends StatefulWidget {
  const AirTunnelScreen({super.key});

  @override
  State<AirTunnelScreen> createState() =>
      _AirTunnelScreenState();
}

class _AirTunnelScreenState extends State<AirTunnelScreen> {
  late final AirTunnelGame game;

  int collectedStars = 0;
  bool completed = false;

  String zatiMessage =
      '¡Oxi llegó al túnel del aire! '
      'Ayúdalo a recoger 7 estrellas y esquivar '
      'las nubecitas de polvo.';

  @override
  void initState() {
    super.initState();

    game = AirTunnelGame(
      onProgress: (count) {
        if (!mounted) return;

        setState(() {
          collectedStars = count;
          zatiMessage =
              '¡Genial! Ya llevas $count de 7 estrellas.';
        });
      },
      onDustTouched: () {
        if (!mounted) return;

        setState(() {
          zatiMessage =
              '¡Ups, una nube de polvo! '
              '¡Sigue adelante, Oxi!';
        });
      },
      onCompleted: () {
        if (!mounted) return;

        setState(() {
          completed = true;
          zatiMessage =
              '¡Lo lograste! La tráquea es como '
              'un túnel que lleva el aire '
              'hacia los pulmones.';
        });
      },
    );
  }

  void restartGame() {
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
      backgroundColor: const Color(0xFFF1F7FF),
      appBar: AppBar(
        title: const Text('¡Por el túnel del aire!'),
        backgroundColor: const Color(0xFF624A9D),
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
                    child: GameWidget<AirTunnelGame>(
                      game: game,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: collectedStars /
                    AirTunnelGame.targetStars,
                minHeight: 12,
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFFFC64D),
                backgroundColor: const Color(0xFFDCE5F0),
              ),
              const SizedBox(height: 8),
              Text(
                '⭐ Estrellas: $collectedStars / '
                '${AirTunnelGame.targetStars}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF49377D),
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
                      Icons.pets,
                      size: 60,
                      color: Color(0xFF624A9D),
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
                      color: Color(0xFF49377D),
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
                color: const Color(0xFFF0E9FF),
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
              '🎮 ¡Tu desafío!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Mueve a Oxi con el mouse o el dedo.\n'
              'Recoge las estrellas amarillas.\n'
              'Esquiva las nubecitas de polvo.\n'
              '¡Sigue las corrientes de aire!',
              style: TextStyle(
                fontSize: 16,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              '💡 ¿Sabías que...?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Cuando respiras, el aire pasa '
              'por un conducto llamado tráquea. '
              'Es como un túnel que conecta '
              'la garganta con los bronquios.',
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
      color: const Color(0xFFE5F8E9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_events,
              color: Color(0xFFE3A921),
              size: 75,
            ),
            const SizedBox(height: 12),
            const Text(
              '¡TÚNEL SUPERADO!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF28774A),
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
            const SizedBox(height: 18),
            const Text(
              '🌟 ¡Oxi está más cerca de los pulmones!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: restartGame,
                icon: const Icon(Icons.replay),
                label: const Text('VOLVER A JUGAR'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
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
