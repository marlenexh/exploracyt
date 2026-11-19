import 'models.dart';
import 'worlds.dart';

bool isTopicInvestigated(Tema topic, Set<String> completed) =>
    topic.misiones.isNotEmpty &&
    topic.misiones.every((mission) => completed.contains(mission.id));

/// Piece IDs are world IDs and are derived from local mission completions.
/// Placeholder missions cannot grant a piece.
Set<String> recoveredCompassPieces(Set<String> completed) => {
  for (final world in mundos)
    if (world.temas.isNotEmpty &&
        world.temas.every(
          (topic) =>
              topic.misiones.every((mission) => mission.implementada) &&
              isTopicInvestigated(topic, completed),
        ))
      world.id,
};
