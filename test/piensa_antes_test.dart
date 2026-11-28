import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/predicciones.dart';
import 'package:explora_ciencia/presentation/biology/tema_bio_screen.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/ciencia/barajar.dart';
import 'package:explora_ciencia/presentation/ciencia/piensa_antes.dart';
import 'package:explora_ciencia/presentation/electronica/electronica_screen.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';
import 'package:explora_ciencia/presentation/ia/ia_screen.dart';
import 'package:explora_ciencia/presentation/programacion/programacion_screen.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  test('Las opciones se muestran mezcladas: la correcta no siempre es la primera', () {
    // Siempre el mismo orden para la misma pregunta
    expect(ordenOpciones('¿Qué es?', 3), ordenOpciones('¿Qué es?', 3));
    var primera = 0;
    const n = 300;
    for (var i = 0; i < n; i++) {
      final o = ordenOpciones('Pregunta número $i', 3);
      expect(o.toSet(), {0, 1, 2});
      if (o.first == 0) primera++;
    }
    // Con 3 opciones, la correcta (índice 0) queda primero cerca de 1 de cada 3 veces.
    expect(primera, inInclusiveRange(n ~/ 5, n ~/ 2));
  });

  test('Cada simulación y experimento importante tiene su pregunta para pensar antes', () {
    final pasos = <String, PasoBio>{
      for (final temas in [temasBio, temasQui, temasFis, temasEle, temasIA, temasPro])
        for (final t in temas.values)
          for (final m in t.misiones)
            for (final p in m.pasos) p.id: p,
    };
    const labs = {'bio-lab', 'fis-lab', 'ele-lab', 'ia-lab', 'pro-lab'};
    for (final e in predicciones.entries) {
      expect(pasos.containsKey(e.key) || labs.contains(e.key), isTrue, reason: 'Paso inexistente: ${e.key}');
      expect(e.value.opciones.length, 3, reason: e.key);
      expect(e.value.correcta, inInclusiveRange(0, 2), reason: e.key);
      expect(e.value.porque.length, greaterThan(20), reason: e.key);
    }
    // Todas las simulaciones de Electrónica, IA y Programación la tienen
    for (final temas in [temasEle, temasIA, temasPro]) {
      for (final t in temas.values) {
        for (final m in t.misiones) {
          for (final p in m.pasos.where((p) => p.tipo == TipoPasoBio.simulacion)) {
            expect(predicciones.containsKey(p.id), isTrue, reason: 'Falta la predicción de ${p.id} (${p.titulo})');
          }
        }
      }
    }
  });

  testWidgets('Piensa antes: elige su idea, hace la actividad y la compara', (tester) async {
    for (final s in const [Size(844, 390), Size(1280, 800), Size(390, 844)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(key: ValueKey(s), home: conPrediccion('f1_m1_sim', const Scaffold(body: Center(child: Text('ACTIVIDAD'))))));
      await cuadros(tester, 6);
      expect(find.textContaining('Si acercas el polo norte'), findsOneWidget);
      expect(find.text('ACTIVIDAD'), findsNothing);
      expect(find.byTooltip('¡A comprobarlo!'), findsNothing);
      await tester.tap(find.text('Se pegan'));
      await cuadros(tester, 3);
      await tester.tap(find.byTooltip('¡A comprobarlo!'));
      await cuadros(tester, 3);
      expect(find.text('ACTIVIDAD'), findsOneWidget);
      await tester.tap(find.byTooltip('Ver mi idea'));
      await cuadros(tester, 6);
      expect(find.textContaining('Lo que en verdad pasa: Se empujan'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    // Si el paso no tiene predicción, abre directo la actividad
    await tester.pumpWidget(MaterialApp(home: conPrediccion('no_existe', const Scaffold(body: Text('DIRECTO')))));
    expect(find.text('DIRECTO'), findsOneWidget);
  });
}
