import 'package:explora_ciencia/data/body_topic.dart';
import 'package:explora_ciencia/data/science_compass.dart';
import 'package:explora_ciencia/domain/progress_store.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'legacy profiles, badges and completed missions survive coin migration',
    () async {
      SharedPreferences.setMockInitialValues({
        'v1.nombre': 'Luz',
        'v1.grado': 6,
        'v1.monedas': 45,
        'v1.recompensas': ['robot-brazo-izq'],
        'v1.completadas': ['ele-t1-m1'],
        'v1.textoGrande': true,
      });
      final progress = ProgressStore();
      await progress.cargar();
      expect(progress.nombre, 'Luz');
      expect(progress.grado, 6);
      expect(progress.textoGrande, isTrue);
      expect(progress.recompensas, {'robot-brazo-izq'});
      expect(
        (await SharedPreferences.getInstance()).containsKey('v1.monedas'),
        isFalse,
      );

      await expectLater(
        progress.completeBodyInvestigation(1),
        throwsStateError,
      );
      expect(progress.completadas, {'ele-t1-m1'});
      await progress.completeBodyInvestigation(0);
      await progress.completeBodyInvestigation(0);
      final reopened = ProgressStore();
      await reopened.cargar();
      expect(reopened.completadas, {'ele-t1-m1', bodyMissions.first.id});
      // La misión 1 ya no da insignia: solo se entrega al terminar el Tema 1.
      expect(reopened.recompensas, {'robot-brazo-izq'});
      expect(bodyMissionUnlocked(1, reopened.completadas), isTrue);
      expect(bodyMissionUnlocked(2, reopened.completadas), isFalse);
      expect(
        recoveredCompassPieces(
          bodyMissions.map((mission) => mission.id).toSet(),
        ),
        isEmpty,
      );
    },
  );

  test(
      'La insignia del Tema 1 solo se entrega al terminar todo y se quitan las anteriores',
      () async {
    SharedPreferences.setMockInitialValues({
      'v1.completadas': ['bio-t1-m1'],
      'v1.recompensas': ['bio-t1-m1-badge', 'robot-brazo-izq'],
    });
    final progress = ProgressStore();
    await progress.cargar();
    expect(progress.recompensas, {'robot-brazo-izq'});
    for (var i = 1; i < bodyMissions.length; i++) {
      await progress.completeBodyInvestigation(i);
    }
    expect(
        progress.recompensas, {'robot-brazo-izq', 'bio-t1-integration-badge'});
    expect(bodyBadgeName('bio-t1-integration-badge'),
        'Explorador del Cuerpo Humano');
  });
}
