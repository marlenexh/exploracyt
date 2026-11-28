import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:explora_ciencia/data/imagenes_tarjetas.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show partesDeTexto;
import 'package:explora_ciencia/presentation/insignias/insignias_screen.dart';
import 'package:explora_ciencia/presentation/vocacion/personajes_datos.dart';
import 'package:explora_ciencia/presentation/vocacion/personas_transforman_screen.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await store.cargar();
    await store.reiniciar();
  });

  test('Zati lee los textos largos por partes cortas', () {
    const largo = '¿Qué es? El sistema circulatorio es el conjunto del corazón, los vasos sanguíneos y la sangre. '
        '¿Para qué sirve? Transporta la sangre por todo el cuerpo. Lleva oxígeno y nutrientes. Recoge desechos como el dióxido de carbono.';
    final partes = partesDeTexto(largo);
    expect(partes.length, greaterThan(1));
    expect(partes.every((p) => p.length <= 135 || !p.contains('. ')), isTrue);
    expect(partes.join(' ').replaceAll(RegExp(r'\s+'), ' '), largo.replaceAll(RegExp(r'\s+'), ' ').trim());
    expect(partesDeTexto('Un texto corto.'), ['Un texto corto.']);
  });

  test('Cada tarjeta interactiva tiene su imagen', () {
    final titulos = <String>[];
    for (final f in Directory('lib').listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'))) {
      for (final m in RegExp(r"TarjetaInfo\(\s*Icons\.\w+,\s*'((?:[^'\\]|\\.)*)'").allMatches(f.readAsStringSync())) {
        titulos.add(m.group(1)!);
      }
    }
    expect(titulos.length, greaterThan(250));
    for (final t in titulos) {
      expect(imagenDeTarjeta(t), isNotNull, reason: 'Falta la imagen de la tarjeta “$t”');
    }
  });

  test('Catálogo de insignias: ids únicos, todos los temas y laboratorios', () {
    final c = catalogoInsignias();
    expect(c.map((i) => i.id).toSet().length, c.length);
    expect(c.where((i) => i.laboratorio).length, 6);
    expect(c.length, greaterThanOrEqualTo(30));
  });

  testWidgets('Mis insignias: las ganadas se ven con su medalla y se abren en grande', (tester) async {
    final c = catalogoInsignias();
    await store.completar('x', recompensaId: c.first.id);
    for (final s in const [Size(390, 844), Size(1280, 800)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(key: ValueKey(s), home: const PantallaInsignias()));
      await cuadros(tester, 6);
      expect(find.textContaining('Mis insignias (1 de'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    await tester.tap(find.byTooltip(c.first.nombre));
    await cuadros(tester, 6);
    expect(find.text('Ganaste la insignia'), findsOneWidget);
  });

  testWidgets('Museo: una sala a la vez, se camina entre salas y la información se desliza de 1 en 1', (tester) async {
    pantalla(tester, const Size(1280, 800));
    await tester.pumpWidget(const MaterialApp(home: PersonasTransformanScreen()));
    await cuadros(tester, 10);
    final st = tester.state<PersonasTransformanScreenState>(find.byType(PersonasTransformanScreen));
    expect(st.sala, salasMuseo.first.$1);
    await tester.tap(find.byTooltip('Sala siguiente'));
    await cuadros(tester, 6);
    expect(st.sala, salasMuseo[1].$1);
    // Solo se ven los cuadros de esa sala
    for (final p in personajes) {
      expect(find.byTooltip(p.nombre).evaluate().isNotEmpty, p.sala == st.sala, reason: p.nombre);
    }
    final p = personajes.firstWhere((x) => x.sala == st.sala);
    await tester.tap(find.byTooltip(p.nombre));
    await cuadros(tester, 10);
    final d = tester.state<DetallePersonajeScreenState>(find.byType(DetallePersonajeScreen));
    expect(d.pagina, 0);
    await tester.drag(find.byType(PageView), const Offset(-700, 0));
    await cuadros(tester, 8);
    expect(d.pagina, 1);
    await tester.tap(find.byTooltip('Tarjeta siguiente'));
    await cuadros(tester, 8);
    expect(d.pagina, 2);
    await cuadros(tester, 30, 100); // termina el sello de visitante
    expect(tester.takeException(), isNull);
  });

  test('El museo no usa emojis: salas y objetos con íconos de Flutter y países sin bandera', () {
    for (final p in personajes) {
      expect(iconoObjeto(p.objeto.$2), isNot(Icons.star_rounded), reason: p.objeto.$2);
      expect(RegExp('[\u{1F1E6}-\u{1F1FF}]', unicode: true).hasMatch(paisSinBandera(p.pais)), isFalse, reason: p.pais);
    }
    final src = File('lib/presentation/vocacion/personas_transforman_screen.dart').readAsStringSync();
    expect(RegExp('[\u{1F300}-\u{1FAFF}]', unicode: true).hasMatch(src), isFalse, reason: 'La pantalla del museo no debe tener emojis');
  });
}
