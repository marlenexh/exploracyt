import 'dart:math';

import 'package:flutter/material.dart';

import '../../data/body_topic.dart';
import '../../data/science_compass.dart';
import '../../data/worlds.dart';
import '../../main.dart' show store;
import 'body_diagram.dart';
import 'body_experiment.dart';
import 'body_resources.dart';

const _zati = 'assets/images/biology/zati.png';
const _background = 'assets/images/biology/biology_background.png';
const _navy = Color(0xFF183E49);

IconData _systemIcon(BodySystem system) => switch (system) {
  BodySystem.circulation => Icons.favorite,
  BodySystem.breathing => Icons.air,
  BodySystem.defense => Icons.shield,
  BodySystem.teamwork => Icons.explore,
};

class BodyTopicScreen extends StatelessWidget {
  const BodyTopicScreen({super.key});

  @override
  Widget build(BuildContext context) => _LaboratoryPage(
    title: 'Tema 1 · El cuerpo humano',
    child: ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final completed = bodyMissions
            .where((mission) => store.completadas.contains(mission.id))
            .length;
        final integrated = store.completadas.contains(bodyMissions.last.id);
        final biology = mundos.firstWhere((world) => world.id == 'bio');
        final explored = biology.temas
            .where((topic) => isTopicInvestigated(topic, store.completadas))
            .length;
        final recovered = recoveredCompassPieces(
          store.completadas,
        ).contains(biology.id);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Panel(
              child: Column(
                children: [
                  Text(
                    'El cuerpo humano',
                    style: TextStyle(
                      fontFamily: 'LilitaOne',
                      fontSize: 32,
                      color: _navy,
                    ),
                  ),
                  _ZatiLine(
                    '¿Qué cambia en tu cuerpo cuando juegas, corres o descansas? ¡Pongamos tus ideas a prueba!',
                  ),
                  BodyDiagram(system: BodySystem.teamwork),
                ],
              ),
            ),
            _Panel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$completed de ${bodyMissions.length} investigaciones completadas',
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: completed / bodyMissions.length,
                    semanticsLabel: 'Avance del tema',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Brújula de la Ciencia · Biología: $explored de ${biology.temas.length} temas completados.',
                  ),
                  Text(
                    recovered
                        ? 'Pieza de Biología recuperada.'
                        : integrated
                        ? 'El cuerpo humano investigado. La pieza se recupera al completar Biología.'
                        : 'Completa la investigación del cuerpo humano para avanzar hacia la pieza de Biología.',
                  ),
                ],
              ),
            ),
            for (final (index, mission) in bodyMissions.indexed)
              _Panel(
                child: _MissionCard(index: index, mission: mission),
              ),
          ],
        );
      },
    ),
  );
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.index, required this.mission});

  final int index;
  final BodyMission mission;

  @override
  Widget build(BuildContext context) {
    final locked = !bodyMissionUnlocked(index, store.completadas);
    final completed = store.completadas.contains(mission.id);
    final badge = store.recompensas.contains(mission.badgeId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(_systemIcon(mission.system), color: _navy),
            Text(
              mission.isFinal ? 'Actividad integradora' : 'Misión ${index + 1}',
            ),
          ],
        ),
        Text(mission.title, style: Theme.of(context).textTheme.headlineSmall),
        Text(mission.question),
        const SizedBox(height: 8),
        Text(
          badge
              ? 'Insignia obtenida: ${mission.badge}'
              : 'Insignia: ${mission.badge}',
        ),
        if (locked)
          Text('Para desbloquearla, completa ${bodyMissions[index - 1].title}'),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: locked
              ? null
              : () {
                  if (!bodyMissionUnlocked(index, store.completadas)) return;
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => _BodyMissionScreen(index: index),
                    ),
                  );
                },
          icon: Icon(
            locked
                ? Icons.lock
                : completed
                ? Icons.replay
                : Icons.play_arrow,
          ),
          label: Text(
            locked
                ? 'Bloqueada'
                : completed
                ? 'Repetir misión'
                : 'Investigar',
          ),
        ),
      ],
    );
  }
}

class _LaboratoryPage extends StatelessWidget {
  const _LaboratoryPage({
    required this.title,
    required this.child,
    this.controller,
  });

  final String title;
  final Widget child;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFDAEFE7),
    appBar: AppBar(
      title: Text(title),
      backgroundColor: _navy,
      foregroundColor: Colors.white,
    ),
    body: DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_background),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xBBDFF4E9), BlendMode.srcOver),
        ),
      ),
      child: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(12),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Theme(
    data: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF286B57)),
      fontFamily: 'Fredoka',
    ),
    child: Card(
      color: const Color(0xFFF8FFF9),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    ),
  );
}

class _ZatiLine extends StatelessWidget {
  const _ZatiLine(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Image.asset(_zati, width: 70, height: 78, semanticLabel: 'Zati'),
      const SizedBox(width: 10),
      Expanded(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xFFE7F2E9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF76A191)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(message),
          ),
        ),
      ),
    ],
  );
}

enum _Stage {
  prediction,
  exploration,
  experiment,
  challenge,
  reflection,
  complete,
}

class _BodyMissionScreen extends StatefulWidget {
  const _BodyMissionScreen({required this.index});

  final int index;

  @override
  State<_BodyMissionScreen> createState() => _BodyMissionScreenState();
}

class _BodyMissionScreenState extends State<_BodyMissionScreen> {
  final scroll = ScrollController();
  final reflection = TextEditingController();
  final visited = <int>{};
  final answers = <int, int>{};
  late final routeOptions = mission.route.toList()..shuffle(Random());
  _Stage stage = _Stage.prediction;
  int? prediction, selected;
  int routeIndex = 0;
  String routeFeedback = '';
  String? saveError;
  bool saving = false;

  BodyMission get mission => bodyMissions[widget.index];

  @override
  void dispose() {
    scroll.dispose();
    reflection.dispose();
    super.dispose();
  }

  void goTo(_Stage next) {
    setState(() => stage = next);
    if (scroll.hasClients) scroll.jumpTo(0);
  }

  void selectStructure(int index) => setState(() {
    selected = index;
    visited.add(index);
  });

  Future<void> finish() async {
    if (saving ||
        stage != _Stage.reflection ||
        reflection.text.trim().isEmpty ||
        !bodyMissionUnlocked(widget.index, store.completadas)) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      saving = true;
      saveError = null;
    });
    try {
      await store.completeBodyInvestigation(widget.index);
      if (mounted) goTo(_Stage.complete);
    } catch (_) {
      if (mounted) {
        setState(() => saveError = 'No se pudo guardar. Inténtalo de nuevo.');
      }
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final unlocked = bodyMissionUnlocked(widget.index, store.completadas);
    final heading = switch (stage) {
      _Stage.prediction => 'Haz una predicción',
      _Stage.exploration => 'Explora el modelo 2D',
      _Stage.experiment => 'Prueba en el laboratorio',
      _Stage.challenge => 'Compara y resuelve',
      _Stage.reflection => 'Explica tu descubrimiento',
      _Stage.complete => '¡Investigación completada!',
    };
    return _LaboratoryPage(
      title: mission.title,
      controller: scroll,
      child: _Panel(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!unlocked)
                const Text('Completa primero las investigaciones anteriores.')
              else ...[
                LinearProgressIndicator(
                  value: (stage.index + 1) / _Stage.values.length,
                  semanticsLabel: 'Etapa de la investigación',
                ),
                const SizedBox(height: 12),
                Text(heading, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                switch (stage) {
                  _Stage.prediction => buildPrediction(),
                  _Stage.exploration => buildExploration(),
                  _Stage.experiment => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ZatiLine(
                        'Observa con atención. ¿Qué cambió al probar otra condición?',
                      ),
                      BodyExperiment(
                        system: mission.system,
                        reduceMotion:
                            store.reducirAnim ||
                            MediaQuery.disableAnimationsOf(context),
                        onObserved: () => goTo(_Stage.challenge),
                      ),
                    ],
                  ),
                  _Stage.challenge => buildChallenge(),
                  _Stage.reflection => buildReflection(),
                  _Stage.complete => buildSummary(),
                },
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPrediction() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ZatiLine(mission.question),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final (index, text) in mission.predictions.indexed)
            ChoiceChip(
              label: Text(text),
              selected: prediction == index,
              onSelected: (_) => setState(() => prediction = index),
            ),
        ],
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: prediction == null ? null : () => goTo(_Stage.exploration),
        child: const Text('Explorar mi predicción'),
      ),
    ],
  );

  Widget buildExploration() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Selecciona cada estructura en el dibujo o en la lista.'),
      BodyDiagram(
        system: mission.system,
        structures: mission.structures,
        selected: selected,
        onSelect: selectStructure,
      ),
      Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          for (final (index, structure) in mission.structures.indexed)
            ChoiceChip(
              label: Text(structure.name),
              selected: selected == index,
              avatar: visited.contains(index)
                  ? const Icon(Icons.check, size: 16)
                  : null,
              onSelected: (_) => selectStructure(index),
            ),
        ],
      ),
      if (selected case final int index)
        Semantics(
          liveRegion: true,
          child: _ZatiLine(mission.structures[index].explanation),
        ),
      BodyResourcePanel(system: mission.system),
      const SizedBox(height: 8),
      FilledButton(
        onPressed: visited.length == mission.structures.length
            ? () => goTo(_Stage.experiment)
            : null,
        child: const Text('Ir al experimento'),
      ),
    ],
  );

  Widget buildChallenge() {
    final route = mission.route;
    final remaining = routeOptions.where(
      (step) => !route.take(routeIndex).contains(step),
    );
    final correct = mission.challenge.indexed.every(
      (item) => answers[item.$1] == item.$2.answer,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tu predicción: ${mission.predictions[prediction!]}'),
        Text(
          prediction == mission.expectedPrediction
              ? 'Lo observado coincide con tu predicción.'
              : 'Lo observado fue diferente de tu predicción. Revisar una idea también es investigar.',
        ),
        _ZatiLine(mission.comparison),
        if (route.isNotEmpty) ...[
          const Text('Ordena el recorrido seleccionando un paso a la vez.'),
          Text(route.take(routeIndex).join(' → ')),
          if (routeIndex < route.length)
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final step in remaining)
                  OutlinedButton(
                    onPressed: () => setState(() {
                      if (route[routeIndex] == step) {
                        routeIndex++;
                        routeFeedback = routeIndex == route.length
                            ? '¡Recorrido completo!'
                            : '¡Bien! Busca el siguiente paso.';
                      } else {
                        routeFeedback =
                            'Prueba otra opción. ¿A dónde va después?';
                      }
                    }),
                    child: Text(step),
                  ),
              ],
            ),
          Semantics(liveRegion: true, child: Text(routeFeedback)),
        ],
        for (final (index, question) in mission.challenge.indexed) ...[
          const SizedBox(height: 14),
          Text(
            question.prompt,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final (option, text) in question.options.indexed)
                ChoiceChip(
                  label: Text(text),
                  selected: answers[index] == option,
                  onSelected: (_) => setState(() => answers[index] = option),
                ),
            ],
          ),
          if (answers[index] case final int answer)
            Semantics(
              liveRegion: true,
              child: Text(
                answer == question.answer
                    ? '¡Bien! ${question.feedback}'
                    : 'Intenta otra opción. Pista: ${question.feedback}',
              ),
            ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: correct && routeIndex == route.length
              ? () => goTo(_Stage.reflection)
              : null,
          child: const Text('Escribir mi reflexión'),
        ),
      ],
    );
  }

  Widget buildReflection() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _ZatiLine(mission.reflection),
      TextField(
        controller: reflection,
        maxLength: 600,
        minLines: 2,
        maxLines: 5,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(
          labelText: 'Mi reflexión',
          border: OutlineInputBorder(),
        ),
      ),
      if (saveError case final String error)
        Semantics(liveRegion: true, child: Text(error)),
      FilledButton(
        onPressed: saving || reflection.text.trim().isEmpty ? null : finish,
        child: Text(saving ? 'Guardando…' : 'Completar investigación'),
      ),
    ],
  );

  Widget buildSummary() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const _ZatiLine(
        '¡Lo descubriste investigando! Puedes volver al laboratorio y repetir el experimento.',
      ),
      ListTile(
        leading: Icon(_systemIcon(mission.system), color: _navy),
        title: Text(mission.badge),
        subtitle: Text(mission.comparison),
      ),
      if (mission.isFinal)
        const Text(
          'Registramos el avance del cuerpo humano en la Brújula de la Ciencia.',
        ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Volver al tema'),
      ),
    ],
  );
}
