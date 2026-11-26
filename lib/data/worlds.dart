import 'package:flutter/material.dart';
import 'models.dart';
import 'body_topic.dart';
import 'bio_topics.dart';
import 'ele_topics.dart';
import 'pro_topics.dart';
import 'qui_topics.dart';
import 'fis_topics.dart';
import 'ia_topics.dart';
import 'laboratorios.dart';

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
  final info = switch (w) {
    'bio' => bioTopics[n],
    'ele' => eleTopics[n],
    'pro' => proTopics[n],
    'qui' => quiTopics[n],
    'fis' => fisTopics[n],
    'ia' => iaTopics[n],
    _ => null,
  };
  if (info != null) {
    final ids = info.missionIds;
    return Tema(id, titulo, [
      for (var i = 0; i < ids.length; i++)
        Mision(ids[i], info.missions[i],
            implementada: true,
            recompensa: i == ids.length - 1 ? Recompensa(info.badgeId, info.badge) : null),
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
  if (id == proLabBadgeId) return proLabBadge;
  if (id == iaLabBadgeId) return iaLabBadge;
  for (final l in laboratoriosMundos.values) {
    if (id == l.badgeId) return l.insignia;
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
    'El mundo de los materiales', 'Los gases y sus propiedades', 'Todo se transforma',
    'Cocción y descomposición de los alimentos', 'Combustión y oxidación'])),
  Mundo('fis', 'Física', 'El valle de las fuerzas y la energía', Icons.bubble_chart, const Color.fromARGB(255, 2, 108, 255), _temas('fis', [
    'El magnetismo y sus misterios', 'La gravedad en acción', 'Calor y energía térmica',
    'La energía que nos rodea', 'Explorando el Sistema Solar'])),
  Mundo('ele', 'Electrónica', 'La ciudad de los circuitos', Icons.memory, const Color.fromARGB(255, 255, 174, 0), _temas('ele', [
    'Conoce los componentes', 'Conecta y enciende', 'Detectives electrónicos',
    'Máquinas en movimiento', 'Crea tu invento'])),
  Mundo('ia', 'Inteligencia Artificial', 'La estación de las máquinas inteligentes', Icons.psychology, const Color.fromARGB(255, 255, 18, 188), _temas('ia', [
    'Máquinas inteligentes', 'Encuentra el patrón', 'Enseña a una máquina',
    'Inteligencia en acción', 'Usa la IA con cuidado'])),
  Mundo('pro', 'Programación', 'El reino de los algoritmos', Icons.code, const Color.fromARGB(255, 26, 145, 172), _temas('pro', [
    'Piensa como programador', 'Sigue las instrucciones', 'Programa con bloques',
    'Repite y decide', 'Encuentra el error'])),
];
