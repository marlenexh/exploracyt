import 'package:explora_ciencia/data/body_topic.dart';
import 'package:explora_ciencia/data/science_compass.dart';
import 'package:explora_ciencia/domain/progress_store.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/biology/body_topic_screen.dart';
import 'package:flutter/material.dart';
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
      expect(reopened.recompensas, {
        'robot-brazo-izq',
        bodyMissions.first.badgeId,
      });
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

  testWidgets('four investigations require evidence and unlock in order', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'v1.reducirAnim': true});
    await store.cargar();
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Future<void> tap(Finder finder) async {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Finder filled(String label) => find.widgetWithText(FilledButton, label);
    Finder choice(String label) => find.widgetWithText(ChoiceChip, label);
    Finder outlined(String label) => find.widgetWithText(OutlinedButton, label);

    await tester.pumpWidget(const MaterialApp(home: BodyTopicScreen()));
    await tester.pumpAndSettle();
    expect(filled('Bloqueada'), findsNWidgets(3));
    for (final (index, mission) in bodyMissions.indexed) {
      await tap(filled('Investigar'));
      expect(store.completadas.contains(mission.id), isFalse);
      await tap(choice(mission.predictions.first));
      await tap(filled('Explorar mi predicción'));
      for (final structure in mission.structures) {
        await tap(choice(structure.name));
      }
      await tap(filled('Ir al experimento'));
      expect(
        tester
            .widget<FilledButton>(filled('Registrar observaciones'))
            .onPressed,
        isNull,
      );
      if (mission.system == BodySystem.defense) {
        const decisions = {
          'Antes de comer': 'Lavarte las manos con agua y jabón',
          'Al volver de jugar': 'Limpiar las superficies que quedaron sucias',
          'En un salón con aire cargado':
              'Ventilar si el aire exterior es adecuado',
          'Si te haces un raspón': 'Avisar a un adulto y limpiar la herida',
          'Para prevenir ciertas enfermedades':
              'Revisar las vacunas con un adulto y el centro de salud',
          'Después de un día de actividades':
              'Dormir y descansar lo suficiente',
        };
        for (final decision in decisions.entries) {
          await tap(choice(decision.key));
          await tap(outlined(decision.value));
        }
      } else {
        await tap(choice('Reposo'));
        await tap(choice(mission.isFinal ? 'Subida' : 'Actividad física'));
        if (mission.system == BodySystem.breathing) {
          await tap(outlined('Inhalar'));
          await tap(outlined('Exhalar'));
        } else if (mission.system == BodySystem.circulation) {
          await tap(outlined('Activar latidos'));
        }
      }
      await tap(filled('Registrar observaciones'));
      if (mission.route.isNotEmpty) {
        await tap(outlined(mission.route.last));
        expect(
          find.text('Prueba otra opción. ¿A dónde va después?'),
          findsOneWidget,
        );
      }
      for (final step in mission.route) {
        await tap(outlined(step));
      }
      expect(
        tester.widget<FilledButton>(filled('Escribir mi reflexión')).onPressed,
        isNull,
      );
      for (final question in mission.challenge) {
        await tap(choice(question.options[question.answer]));
      }
      await tap(filled('Escribir mi reflexión'));
      expect(
        tester
            .widget<FilledButton>(filled('Completar investigación'))
            .onPressed,
        isNull,
      );
      await tester.enterText(
        find.byType(TextField),
        'Comparé lo que pasó en cada condición.',
      );
      await tester.pumpAndSettle();
      await tap(filled('Completar investigación'));
      expect(find.text('¡Investigación completada!'), findsOneWidget);
      await tap(filled('Volver al tema'));
      expect(filled('Repetir misión'), findsNWidgets(index + 1));
    }
    expect(store.completadas.length, 4);
    expect(store.recompensas.length, 4);
    expect(
      find.text('Brújula de la Ciencia · Biología: 1 de 5 temas completados.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
