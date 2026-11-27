import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:explora_ciencia/presentation/vocacion/creditos_retratos.dart';
import 'package:explora_ciencia/presentation/vocacion/explora_profesiones_screen.dart';
import 'package:explora_ciencia/presentation/vocacion/mis_descubrimientos_screen.dart';
import 'package:explora_ciencia/presentation/vocacion/personajes_datos.dart';
import 'package:explora_ciencia/presentation/vocacion/personas_transforman_screen.dart';
import 'package:explora_ciencia/presentation/vocacion/profesiones_datos.dart';
import 'package:explora_ciencia/presentation/vocacion/test_intereses_screen.dart';
import 'package:explora_ciencia/presentation/vocacion/vocacion_screen.dart';

import 'mundo_temas_util.dart';

const _tamanos = [Size(390, 844), Size(844, 390), Size(1280, 800)];

void main() {
  setUpAll(fuentes);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Profesiones: más de 20, completas y con reto válido', () {
    expect(profesiones.length, greaterThanOrEqualTo(20));
    expect(profesiones.map((p) => p.nombre).toSet().length, profesiones.length);
    final areas = {for (final a in areasProfesiones) a.$1};
    for (final p in profesiones) {
      expect(areas, contains(p.area), reason: p.nombre);
      expect(p.queHace.length, 3, reason: p.nombre);
      expect(p.herramientas.length, 4, reason: p.nombre);
      expect(p.dia.length, 4, reason: p.nombre);
      expect(p.dondeTrabaja.length, 3, reason: p.nombre);
      final (_, opciones, correcta, _) = p.reto;
      expect(correcta, inInclusiveRange(0, opciones.length - 1), reason: p.nombre);
      for (final m in p.mundos) {
        expect(areas, contains(m), reason: '${p.nombre}: $m');
      }
    }
    // Hay profesiones de áreas fuera de los mundos del juego
    expect(profesiones.where((p) => ['Salud', 'Espacio', 'Planeta', 'Ingeniería'].contains(p.area)).length, greaterThanOrEqualTo(6));
  });

  test('Museo: más de 20 personas en todas las salas', () {
    expect(personajes.length, greaterThanOrEqualTo(20));
    expect(personajes.map((p) => p.nombre).toSet().length, personajes.length);
    for (final s in salasMuseo) {
      expect(personajes.where((p) => p.sala == s.$1).length, greaterThanOrEqualTo(3), reason: s.$1);
    }
    for (final p in personajes) {
      expect(p.historia.length, 3, reason: p.nombre);
      expect(p.pista, isNot(contains(p.nombre)), reason: 'La pista no debe decir el nombre: ${p.nombre}');
    }
  });

  test('Museo: cada persona tiene retrato WebP ligero y crédito de la foto', () {
    for (final p in personajes) {
      final f = File(p.imagen);
      expect(f.existsSync(), isTrue, reason: p.imagen);
      expect(f.lengthSync(), lessThan(60 * 1024), reason: p.imagen);
      expect(creditosRetratos[archivoRetrato(p.nombre)], isNotNull, reason: p.nombre);
    }
    expect(creditosRetratos.length, personajes.length);
  });

  testWidgets('Vocación: el menú se ve en todos los tamaños y abre cada sección', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(const MaterialApp(home: VocacionScreen()));
      await cuadros(tester, 12);
      for (final o in VocacionScreen.opciones) {
        expect(find.text(o.titulo), findsOneWidget, reason: '$s');
      }
      expect(tester.takeException(), isNull, reason: '$s');
    }
    await tester.tap(find.byTooltip('Explora profesiones'));
    await cuadros(tester, 12);
    expect(find.byType(ExploraProfesionesScreen), findsOneWidget);
  });

  testWidgets('Explora profesiones: filtros, favoritas y detalle interactivo', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(const MaterialApp(home: ExploraProfesionesScreen()));
      await cuadros(tester, 12);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<ExploraProfesionesScreenState>(find.byType(ExploraProfesionesScreen));
    st.filtrar('Espacio');
    await cuadros(tester, 8);
    expect(st.visibles.every((p) => p.area == 'Espacio'), isTrue);
    expect(st.visibles, isNotEmpty);
    final astro = st.visibles.first;
    await tester.tap(find.byTooltip('Favorita ${astro.nombre}'));
    await cuadros(tester, 4);
    final pref = await SharedPreferences.getInstance();
    expect(pref.getStringList(ExploraProfesionesScreen.claveFavoritas), contains(astro.nombre));
    // Detalle
    await tester.tap(find.text(astro.nombre).first);
    await cuadros(tester, 12);
    final d = tester.state<DetalleProfesionScreenState>(find.byType(DetalleProfesionScreen));
    await tester.ensureVisible(find.byTooltip('Herramienta ${astro.herramientas[1].$2}'));
    await tester.tap(find.byTooltip('Herramienta ${astro.herramientas[1].$2}'));
    await cuadros(tester, 4);
    expect(d.herramienta, 1);
    d.vivirDia();
    await cuadros(tester, 70, 100);
    expect(d.momento, astro.dia.length - 1);
    expect(d.viviendoDia, isFalse);
    final (_, _, correcta, _) = astro.reto;
    d.responder((correcta + 1) % 3);
    await tester.pump();
    expect(find.textContaining('Inténtalo otra vez'), findsOneWidget);
    d.responder(correcta);
    await tester.pump();
    expect(find.textContaining('Reto superado'), findsOneWidget);
    d.voltear();
    await cuadros(tester, 8);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Museo: salas, visita con sello y ¿Quién soy?', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(const MaterialApp(home: PersonasTransformanScreen()));
      await cuadros(tester, 12);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<PersonasTransformanScreenState>(find.byType(PersonasTransformanScreen));
    await tester.tap(find.byTooltip('Sala Química'));
    await cuadros(tester, 10);
    expect(st.sala, 'Química');
    await tester.tap(find.byTooltip('Mario Molina'));
    await cuadros(tester, 10);
    expect(find.byType(DetallePersonajeScreen), findsOneWidget);
    expect(find.textContaining('SELLO DE VISITANTE'), findsOneWidget);
    await cuadros(tester, 30, 100);
    final pref = await SharedPreferences.getInstance();
    expect(pref.getStringList('personas_visitadas'), contains('Mario Molina'));
    await tester.tap(find.byTooltip('Volver al museo'));
    await cuadros(tester, 10);
    expect(st.visitadas, contains('Mario Molina'));
    expect(find.text('VISITADO'), findsOneWidget);
    // ¿Quién soy?
    await tester.pumpWidget(const MaterialApp(home: QuienSoyScreen(semilla: 3)));
    await cuadros(tester, 8);
    final q = tester.state<QuienSoyScreenState>(find.byType(QuienSoyScreen));
    for (var i = 0; i < q.preguntas.length; i++) {
      q.elegir(q.preguntas[q.actual].correcta);
      await cuadros(tester, 3);
      q.siguiente();
      await cuadros(tester, 3);
    }
    expect(q.terminado, isTrue);
    expect(q.aciertos, q.preguntas.length);
    await cuadros(tester, 10);
    expect(find.textContaining('¡Acertaste'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Test de intereses y Mis descubrimientos funcionan con el nuevo fondo', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(const MaterialApp(home: TestInteresesScreen()));
      await cuadros(tester, 8);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    pantalla(tester, const Size(1280, 800));
    await tester.pumpWidget(const MaterialApp(home: TestInteresesScreen()));
    await cuadros(tester, 8);
    for (var i = 0; i < preguntasIntereses.length; i++) {
      final texto = preguntasIntereses[i].respuestas.first.texto;
      await tester.ensureVisible(find.text(texto));
      await tester.tap(find.text(texto));
      await cuadros(tester, 4);
      final boton = find.text(i == preguntasIntereses.length - 1 ? 'Ver mis resultados' : 'Siguiente');
      await tester.ensureVisible(boton);
      await tester.tap(boton);
      await cuadros(tester, 8);
    }
    expect(find.byType(ResultadoInteresesScreen), findsOneWidget);
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(const MaterialApp(home: MisDescubrimientosScreen()));
      await cuadros(tester, 12);
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });
}
