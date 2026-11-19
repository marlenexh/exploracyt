import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/body_topic.dart';
import 'body_diagram.dart';

class BodyExperiment extends StatefulWidget {
  const BodyExperiment({
    super.key,
    required this.system,
    required this.reduceMotion,
    required this.onObserved,
  });

  final BodySystem system;
  final bool reduceMotion;
  final VoidCallback onObserved;

  @override
  State<BodyExperiment> createState() => _BodyExperimentState();
}

class _BodyExperimentState extends State<BodyExperiment>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final conditions = <bool>{};
  final breathPhases = <bool>{};
  final decisions = <int, bool>{};
  bool active = false;
  bool inhaling = true;
  bool pulse = false;
  bool played = false;
  int scenario = 0;

  static const defenseTrials = [
    (
      'Antes de comer',
      'Lavarte las manos con agua y jabón',
      'Solo enjuagarlas rápidamente',
      'El jabón y el frotado ayudan a retirar microorganismos.',
      'Un enjuague rápido retira menos suciedad que lavarlas con jabón.',
    ),
    (
      'Al volver de jugar',
      'Limpiar las superficies que quedaron sucias',
      'Dejarlas sucias y preparar comida allí',
      'Limpiar reduce lo que puede pasar de la superficie a la comida.',
      'La suciedad puede transferirse a la comida y a las manos.',
    ),
    (
      'En un salón con aire cargado',
      'Ventilar si el aire exterior es adecuado',
      'Mantener todo cerrado',
      'Entra aire renovado y se diluye lo que se acumula en el interior.',
      'Con poca ventilación el aire se renueva menos.',
    ),
    (
      'Si te haces un raspón',
      'Avisar a un adulto y limpiar la herida',
      'Tocar la herida con manos sucias',
      'Cuidar la herida ayuda a reducir el riesgo de infección.',
      'Las manos sucias pueden introducir más microorganismos.',
    ),
    (
      'Para prevenir ciertas enfermedades',
      'Revisar las vacunas con un adulto y el centro de salud',
      'Esperar protección inmediata de cualquier vacuna',
      'Las vacunas preparan defensas específicas con el tiempo.',
      'La protección tarda en desarrollarse y puede variar.',
    ),
    (
      'Después de un día de actividades',
      'Dormir y descansar lo suficiente',
      'Dormir muy poco con frecuencia',
      'El descanso apoya el funcionamiento normal del organismo.',
      'Dormir poco repetidamente dificulta recuperarse del cansancio.',
    ),
  ];

  bool get breathing => widget.system == BodySystem.breathing;
  bool get defense => widget.system == BodySystem.defense;
  bool get teamwork => widget.system == BodySystem.teamwork;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void observeCondition(bool value) {
    setState(() {
      active = value;
      conditions.add(value);
      if (pulse && !widget.reduceMotion) startPulse();
    });
  }

  void startPulse() {
    controller.repeat(period: Duration(milliseconds: active ? 480 : 830));
  }

  void changeBreath(bool value) {
    setState(() {
      inhaling = value;
      breathPhases.add(value);
      if (!widget.reduceMotion) controller.forward(from: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final trial = defenseTrials[scenario];
    final ready = defense
        ? decisions.length == defenseTrials.length
        : conditions.length == 2 &&
              (breathing ? breathPhases.length == 2 : teamwork || played);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (defense) ...[
          const Text(
            'Prueba una decisión en cada situación y compara sus consecuencias.',
          ),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final (index, item) in defenseTrials.indexed)
                ChoiceChip(
                  label: Text(item.$1),
                  selected: index == scenario,
                  avatar: decisions.containsKey(index)
                      ? const Icon(Icons.check, size: 16)
                      : null,
                  onSelected: (_) => setState(() => scenario = index),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(trial.$1, style: Theme.of(context).textTheme.titleLarge),
          for (final (decision, text) in [(true, trial.$2), (false, trial.$3)])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: OutlinedButton(
                onPressed: () => setState(() => decisions[scenario] = decision),
                child: Text(text),
              ),
            ),
          if (decisions[scenario] case final bool decision)
            Semantics(
              liveRegion: true,
              child: Text(decision ? trial.$4 : trial.$5),
            ),
        ] else ...[
          Text(
            teamwork
                ? 'Compara el descanso y la subida. Sigue el oxígeno hasta las piernas.'
                : 'Prueba las dos condiciones. Los valores del modelo son ilustrativos.',
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final value in [false, true])
                ChoiceChip(
                  label: Text(
                    value
                        ? (teamwork ? 'Subida' : 'Actividad física')
                        : 'Reposo',
                  ),
                  selected: active == value && conditions.contains(value),
                  onSelected: (_) => observeCondition(value),
                ),
            ],
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final progress = widget.reduceMotion ? 1.0 : controller.value;
              final motion = breathing
                  ? (breathPhases.isEmpty
                        ? 0.0
                        : inhaling
                        ? progress
                        : 1 - progress)
                  : pulse && !widget.reduceMotion
                  ? math.sin(progress * math.pi)
                  : active
                  ? .7
                  : .2;
              return BodyDiagram(
                system: widget.system,
                motion: motion,
                flow: progress,
                inhaling: inhaling,
              );
            },
          ),
          if (conditions.isNotEmpty)
            Semantics(
              liveRegion: true,
              child: Text(
                breathing
                    ? '${active ? 28 : 14} respiraciones por minuto'
                    : teamwork
                    ? active
                          ? 'Subida: los músculos usan más oxígeno.'
                          : 'Reposo: los músculos siguen usando oxígeno.'
                    : '${active ? 125 : 72} latidos por minuto',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (conditions.length == 2)
            Text(
              breathing
                  ? 'Registro: reposo 14 · actividad 28 respiraciones por minuto.'
                  : teamwork
                  ? 'Registro: durante la subida aumentó la demanda de oxígeno.'
                  : 'Registro: reposo 72 · actividad 125 latidos por minuto.',
            ),
          if (breathing) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                OutlinedButton(
                  onPressed: () => changeBreath(true),
                  child: const Text('Inhalar'),
                ),
                OutlinedButton(
                  onPressed: () => changeBreath(false),
                  child: const Text('Exhalar'),
                ),
              ],
            ),
            if (breathPhases.isNotEmpty)
              Text(
                inhaling
                    ? 'El aire entra, el diafragma baja y los pulmones se expanden.'
                    : 'El aire sale, el diafragma sube y los pulmones se reducen.',
              ),
          ] else if (!teamwork)
            OutlinedButton.icon(
              onPressed: () => setState(() {
                pulse = !pulse;
                played = true;
                if (pulse && !widget.reduceMotion) {
                  startPulse();
                } else {
                  controller.stop();
                }
              }),
              icon: Icon(pulse ? Icons.pause : Icons.play_arrow),
              label: Text(pulse ? 'Pausar latidos' : 'Activar latidos'),
            ),
        ],
        const SizedBox(height: 12),
        FilledButton(
          onPressed: ready ? widget.onObserved : null,
          child: const Text('Registrar observaciones'),
        ),
      ],
    );
  }
}
