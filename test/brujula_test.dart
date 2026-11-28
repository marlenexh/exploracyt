import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:explora_ciencia/core/theme.dart';
import 'package:explora_ciencia/data/brujula.dart';
import 'package:explora_ciencia/data/ia_topics.dart';
import 'package:explora_ciencia/data/laboratorios.dart';
import 'package:explora_ciencia/data/pro_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/brujula/brujula.dart';
import 'package:explora_ciencia/presentation/home_screens.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await store.cargar();
    await store.reiniciar();
    store.piezaNueva.value = null;
  });

  test('Hay una pieza por mundo y cada una sale del laboratorio final', () {
    expect(piezasBrujula.map((p) => p.mundo).toList(), mundos.map((m) => m.id).toList());
    final labs = {for (final l in laboratoriosMundos.values) l.badgeId, proLabBadgeId, iaLabBadgeId};
    expect(piezasBrujula.map((p) => p.recompensaLab).toSet(), labs);
  });

  test('Al terminar un laboratorio final se recupera su pieza (una sola vez)', () async {
    expect(store.piezas, isEmpty);
    await store.completar('fis-lab', recompensaId: 'fis-lab-badge');
    expect(store.piezas, {'fis'});
    expect(store.piezaNueva.value, 'fis');
    store.piezaNueva.value = null;
    await store.completar('fis-lab', recompensaId: 'fis-lab-badge');
    expect(store.piezaNueva.value, isNull, reason: 'Repetir el laboratorio no vuelve a celebrar');
    await store.completar('fis-t1-m1', recompensaId: 'insignia-x');
    expect(store.piezaNueva.value, isNull, reason: 'Las misiones normales no dan piezas');
  });

  testWidgets('Celebración: aparece al recuperar la pieza y se cierra', (tester) async {
    pantalla(tester, const Size(390, 844));
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      builder: (_, child) => Stack(fit: StackFit.expand, children: [child!, const CelebracionPieza()]),
      home: const Scaffold(),
    ));
    expect(find.text('¡Seguir explorando!'), findsNothing);
    await store.completar(iaLabId, recompensaId: iaLabBadgeId);
    await cuadros(tester, 25);
    expect(find.textContaining('Pieza de la Inteligencia'), findsOneWidget);
    expect(find.textContaining('1 de 6'), findsOneWidget);
    await tester.tap(find.text('¡Seguir explorando!'));
    await cuadros(tester, 3);
    expect(find.text('¡Seguir explorando!'), findsNothing);
    expect(store.piezaNueva.value, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Celebración final: con las 6 piezas la brújula queda reconstruida', (tester) async {
    pantalla(tester, const Size(1280, 800));
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      builder: (_, child) => Stack(fit: StackFit.expand, children: [child!, const CelebracionPieza()]),
      home: const Scaffold(),
    ));
    for (final p in piezasBrujula) {
      await store.completar('${p.mundo}-lab', recompensaId: p.recompensaLab);
    }
    await cuadros(tester, 25);
    expect(find.textContaining('Brújula reconstruida'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Mapa: 3 mundos arriba y 3 abajo, con el botón de la brújula', (tester) async {
    for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800), Size(1920, 1080)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: const MapaMundos()));
      await cuadros(tester, 6);
      final ys = [for (final m in mundos) tester.getTopLeft(find.text(m.nombre, skipOffstage: false)).dy];
      for (var i = 1; i < 3; i++) {
        expect((ys[i] - ys[0]).abs(), lessThan(12), reason: '$s fila de arriba');
        expect((ys[3 + i] - ys[3]).abs(), lessThan(12), reason: '$s fila de abajo');
      }
      expect(ys[3], greaterThan(ys[0] + 40), reason: '$s');
      expect(find.byType(BotonBrujula), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    await tester.tap(find.byType(BotonBrujula));
    await cuadros(tester, 10);
    expect(find.byType(PantallaBrujula), findsOneWidget);
    expect(find.text('Pieza del Código'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
