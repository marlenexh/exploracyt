import 'dart:io';

import 'package:flutter/services.dart';
import 'package:explora_ciencia/core/theme.dart';
import 'package:explora_ciencia/data/body_topic.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology_lab_screen.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart';
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/tema1_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _fuentes() async {
  for (final (familia, archivo) in [
    ('Fredoka', 'assets/fonts/Fredoka.ttf'),
    ('LilitaOne', 'assets/fonts/LilitaOne-Regular.ttf')
  ]) {
    final f = FontLoader(familia)
      ..addFont(
          Future.value(ByteData.sublistView(File(archivo).readAsBytesSync())));
    await f.load();
  }
}

void main() {
  setUpAll(_fuentes);
  testWidgets(
      'El Tema 1 abre el juego nuevo y sincroniza la misión 1 con la app',
      (tester) async {
    tester.view.physicalSize = const Size(844 * 3, 390 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // El alumno ya completó la Misión 1 dentro del juego.
    final previo = ProgresoJuego();
    for (final paso in misionesTema1.first.pasos) {
      previo.registrar(paso.actividad, 3);
    }
    SharedPreferences.setMockInitialValues({
      'v1.nombre': 'Luz',
      Tema1Screen.claveProgreso:
          '{"estrellas":${_json(previo)},"insignias":[]}',
    });
    await store.cargar();

    await tester.pumpWidget(const MaterialApp(home: Tema1Screen()));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Misión del tema'), findsOneWidget);
    expect(find.textContaining('Luz'), findsWidgets);
    expect(store.completadas, contains(bodyMissions.first.id));
    expect(store.recompensas.where((r) => r.startsWith('bio-t1')), isEmpty);
    expect(store.completadas, isNot(contains(bodyMissions[1].id)));
    await tester.pumpWidget(const SizedBox());
  });

  test('Los ids del Tema 1 se conservan para no perder el avance guardado', () {
    expect(bodyMissions.map((m) => m.id),
        ['bio-t1-m1', 'bio-t1-m2', 'bio-t1-m3', 'bio-t1-integration']);
    expect(bodyMissions.length, misionesTema1.length);
  });

  testWidgets('Desde el laboratorio de Biología, el Tema 1 abre el juego nuevo',
      (tester) async {
    tester.view.physicalSize = const Size(1280 * 2, 800 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    SharedPreferences.setMockInitialValues(
        {'v1.nombre': 'Luz', 'v1.reducirAnim': true});
    await store.cargar();
    await tester.pumpWidget(MaterialApp(
        theme: buildTheme(), home: BiologyLabScreen(mundo: mundos.first)));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final explorar = find.text('¡EXPLORAR!').first;
    await tester.ensureVisible(explorar);
    await tester.pump();
    await tester.tap(explorar);
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text('Misión del tema'), findsOneWidget);
    expect(find.text('Comenzar'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}

String _json(ProgresoJuego p) {
  final e = p.toJson()['estrellas'] as Map<String, int>;
  return '{${e.entries.map((x) => '"${x.key}":${x.value}').join(',')}}';
}
