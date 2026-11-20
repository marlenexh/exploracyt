/// Tema 1 de Biología: "El cuerpo humano y sus sistemas".
///
/// El contenido jugable vive en `lib/presentation/biology/tema1/`. Aquí solo
/// quedan los identificadores de las 4 misiones que usa el resto de la app
/// (mapa de mundos, progreso guardado, insignias y brújula de la ciencia).
/// Se conservan los mismos ids para no perder el avance de los alumnos.
class BodyMission {
  const BodyMission(
      {required this.numero,
      required this.title,
      required this.badge,
      this.isFinal = false});

  final int numero;
  final String title;
  final String badge;
  final bool isFinal;

  String get id => 'bio-t1-${isFinal ? 'integration' : 'm$numero'}';
  String get badgeId => '$id-badge';
}

bool bodyMissionUnlocked(int index, Set<String> completed) =>
    index >= 0 &&
    index < bodyMissions.length &&
    bodyMissions.take(index).every((mission) => completed.contains(mission.id));

String bodyBadgeName(String id) {
  for (final mission in bodyMissions) {
    if (mission.badgeId == id) return mission.badge;
  }
  return id;
}

/// En el mismo orden que `misionesTema1` del juego.
const bodyMissions = [
  BodyMission(
      numero: 1,
      title: '¡El corazón en acción!',
      badge: 'Explorador del Corazón'),
  BodyMission(
      numero: 2,
      title: '¡El viaje del aire!',
      badge: 'Explorador de la Respiración'),
  BodyMission(
      numero: 3,
      title: '¡Defensores del cuerpo!',
      badge: 'Guardián de las Defensas'),
  BodyMission(
      numero: 4,
      title: '¡Tu cuerpo trabaja en equipo!',
      badge: 'Investigador del Cuerpo Humano',
      isFinal: true),
];
