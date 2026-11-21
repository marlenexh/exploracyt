import 'package:flutter/material.dart';
import 'models.dart';
import 'body_topic.dart';
import 'bio_topics.dart';

Tema _t(String w, int n, String titulo) {
  final id = '$w-t$n';
  if (id == 'bio-t1') {
    return Tema(id, titulo, [
      for (final mission in bodyMissions)
        Mision(mission.id, mission.title,
            implementada: true,
            recompensa: mission.badge == null
                ? null
                : Recompensa(mission.badgeId!, mission.badge!)),
    ]);
  }
  final bio = w == 'bio' ? bioTopics[n] : null;
  if (bio != null) {
    final ids = bio.missionIds;
    return Tema(id, titulo, [
      for (var i = 0; i < ids.length; i++)
        Mision(ids[i], bio.missions[i],
            implementada: true,
            recompensa: i == ids.length - 1 ? Recompensa(bio.badgeId, bio.badge) : null),
    ]);
  }
  if (id == 'ele-t1') {
    // Única misión jugable por ahora (Fase 2 la generaliza con datos).
    return Tema(id, titulo, [
      Mision('$id-m1', '¡Que vuelva la luz!',
          implementada: true, recompensa: const Recompensa('robot-brazo-izq', 'Brazo izquierdo', piezaRobot: 'brazo_izq'))
    ]);
  }
  return Tema(id, titulo, [Mision('$id-m1', 'Misión 1: $titulo')]);
}

/// Nombre visible de una recompensa (insignia o pieza) a partir de su id.
String nombreRecompensa(String id) {
  for (final m in mundos) {
    for (final t in m.temas) {
      for (final x in t.misiones) {
        if (x.recompensa?.id == id) return x.recompensa!.nombre;
      }
    }
  }
  return bodyBadgeName(id);
}

(Mundo, Mision)? buscarMision(String id) {
  for (final m in mundos) {
    for (final t in m.temas) {
      for (final x in t.misiones) {
        if (x.id == id) return (m, x);
      }
    }
  }
  return null;
}

List<Tema> _temas(String w, List<String> ts) =>
    [for (var i = 0; i < ts.length; i++) _t(w, i + 1, ts[i])];

final mundos = <Mundo>[
  Mundo('bio', 'Biología', 'Laboratorio de la Vida', Icons.eco, const Color.fromARGB(255, 0, 187, 45), _temas('bio', [
    'El cuerpo humano y sus sistemas', 'El mundo de las células', 'Alimentación saludable',
    'La vida a nuestro alrededor', 'Biodiversidad y ecosistemas'])),
  Mundo('qui', 'Química', 'El laboratorio de los materiales misteriosos', Icons.science, const Color.fromARGB(255, 141, 19, 255), _temas('qui', [
    'Los tres estados', 'La mezcla perfecta', 'Materiales con poderes',
    'La transformación misteriosa', 'Detectives del agua'])),
  Mundo('fis', 'Física', 'El valle de las fuerzas y la energía', Icons.bubble_chart, const Color.fromARGB(255, 2, 108, 255), _temas('fis', [
    'Fuerzas en acción', 'La montaña rusa', 'El poder de la energía',
    'Luz, sombras y sonido', 'El desafío de las máquinas'])),
  Mundo('ele', 'Electrónica', 'La ciudad de los circuitos', Icons.memory, const Color.fromARGB(255, 255, 174, 0), _temas('ele', [
    '¡Que vuelva la luz!', 'Guardianes de la corriente', 'Interruptores secretos',
    'Sensores exploradores', 'Construye un invento'])),
  Mundo('ia', 'Inteligencia Artificial', 'La estación de las máquinas inteligentes', Icons.psychology, const Color.fromARGB(255, 255, 18, 188), _temas('ia', [
    '¿Cómo aprende un robot?', 'La máquina detective', 'Cazadores de errores',
    '¿Podemos confiar en la IA?', 'IA para ayudar a la comunidad'])),
  Mundo('pro', 'Programación', 'El reino de los algoritmos', Icons.code, const Color.fromARGB(255, 26, 145, 172), _temas('pro', [
    'Las instrucciones mágicas', 'El laberinto de Zati', 'El poder de repetir',
    'El robot que decide', 'Crea tu propio minijuego'])),
];
