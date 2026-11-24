import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/bio_topics.dart';
import 'package:explora_ciencia/data/models.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show BotonSiguiente;
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/ciencia/lab_matriz.dart';

/// Pruebas comunes para los mundos hechos con el motor de temas.

Future<void> fuentes() async {
  final f = FontLoader('Fredoka')..addFont(Future.value(ByteData.sublistView(File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await f.load();
}

void pantalla(WidgetTester t, Size s) {
  t.view.physicalSize = s * 2;
  t.view.devicePixelRatio = 2;
  addTearDown(t.view.reset);
}

Future<void> cuadros(WidgetTester t, int n, [int ms = 80]) async {
  for (var i = 0; i < n; i++) {
    await t.pump(Duration(milliseconds: ms));
  }
}

Widget lanzar(TemaBio tema, Widget pantalla, ProgresoJuego p) => MaterialApp(
      builder: (_, child) => ConfiguracionJuego(
        desbloquearTodo: true,
        videos: tema.videos,
        child: ProgresoScope(progreso: p, child: TemaScope(tema: tema, child: Theme(data: temaJuego(), child: child!))),
      ),
      home: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => pantalla));
        });
        return const SizedBox.expand();
      }),
    );

Iterable<(TemaBio, PasoBio)> pasosDe(Map<int, TemaBio> temas) sync* {
  for (final t in temas.values) {
    for (final m in t.misiones) {
      for (final p in m.pasos) {
        yield (t, p);
      }
    }
  }
}

/// Abre un paso, ejecuta [resolverPaso] y termina con el botón "Siguiente".
Future<void> resolver(WidgetTester tester, Map<int, TemaBio> temas, String id, Future<void> Function() resolverPaso) async {
  final (tema, paso) = pasosDe(temas).firstWhere((e) => e.$2.id == id);
  final p = ProgresoJuego();
  await tester.pumpWidget(lanzar(tema, KeyedSubtree(key: ValueKey(id), child: paso.pantalla(id)), p));
  await cuadros(tester, 6);
  await resolverPaso();
  await tester.pump();
  expect(find.byType(BotonSiguiente), findsOneWidget, reason: id);
  await tester.tap(find.byType(BotonSiguiente));
  await cuadros(tester, 12);
  expect(p.estrellasDe(id), 3, reason: id);
  if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
  await cuadros(tester, 6);
  expect(tester.takeException(), isNull, reason: id);
  await tester.pumpWidget(const SizedBox());
  await cuadros(tester, 2);
}

/// Datos, mapa, pantallas de cada tema y tablas de experimentos de un mundo.
void probarMundo({
  required String w,
  required String nombre,
  required Map<int, TemaBio> temas,
  required Map<int, TopicInfo> infos,
  required List<String> titulos,
  required Widget Function(Mundo) mapa,
  int minTablas = 0,
}) {
  test('Los 5 temas de $nombre están completos', () {
    expect(temas.keys, [1, 2, 3, 4, 5]);
    final todos = <String>{};
    for (final tema in temas.values) {
      expect(tema.id, '$w-t${tema.numero}');
      expect(tema.titulo, titulos[tema.numero - 1]);
      expect(tema.misiones.length, 4);
      expect(tema.estilo, isNotNull, reason: 'Cada tema tiene su fondo');
      final ids = [
        for (final m in tema.misiones)
          for (final p in m.pasos) p.id
      ];
      for (final id in ids) {
        expect(todos.add(id), isTrue, reason: 'Id repetido: $id');
      }
      for (final m in tema.misiones.take(3)) {
        final claves = [
          for (final p in m.pasos)
            if (p.tipo == TipoPasoBio.video) p
        ];
        expect(claves, isNotEmpty, reason: m.subtitulo);
        expect(m.pasos.last.titulo, 'Pon a prueba lo que aprendiste', reason: m.subtitulo);
      }
      expect(tema.videos.length, 3);
      final info = infos[tema.numero]!;
      expect(info.missionIds, tema.idsMisiones);
      expect(info.missions, [for (final m in tema.misiones) m.subtitulo]);
      expect(info.badge, tema.insignia);
    }
    // Fondos distintos en cada tema.
    expect({for (final t in temas.values) t.estilo}.length, 5);
  });

  test('El mapa registra los temas e insignias de $nombre', () {
    final m = mundos.firstWhere((m) => m.id == w);
    expect(m.temas.map((t) => t.titulo).toList(), titulos);
    for (var n = 1; n <= 5; n++) {
      expect(m.temas[n - 1].misiones.every((x) => x.implementada), isTrue);
      expect(m.temas[n - 1].misiones.last.recompensa?.id, '$w-t$n-integration-badge');
      expect(nombreRecompensa('$w-t$n-integration-badge'), infos[n]!.badge);
    }
  });

  for (final tema in temas.values) {
    testWidgets('$nombre tema ${tema.numero}: intro → misiones', (tester) async {
      pantalla(tester, const Size(844, 390));
      await tester.pumpWidget(MaterialApp(home: TemaBioJuego(tema: tema, horizontal: false)));
      await cuadros(tester, 15);
      await tester.tap(find.text('Comenzar').first);
      await cuadros(tester, 15);
      for (final m in tema.misiones) {
        expect(find.textContaining(m.subtitulo), findsWidgets);
      }
      expect(tester.takeException(), isNull);
    });
    for (final s in const [Size(844, 390), Size(1280, 800)]) {
      testWidgets('$nombre tema ${tema.numero}: pantallas (${s.width.toInt()}×${s.height.toInt()})', (tester) async {
        pantalla(tester, s);
        for (final m in tema.misiones) {
          for (final p in m.pasos) {
            await tester.pumpWidget(lanzar(tema, KeyedSubtree(key: ValueKey(p.id), child: p.pantalla(p.id)), ProgresoJuego()));
            await cuadros(tester, 8);
            expect(tester.takeException(), isNull, reason: p.titulo);
          }
        }
        await tester.pumpWidget(const SizedBox());
        await cuadros(tester, 3);
      });
    }
  }

  testWidgets('El mapa de $nombre se ve en celular y computadora', (tester) async {
    final m = mundos.firstWhere((x) => x.id == w);
    for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(home: mapa(m)));
      await cuadros(tester, 4);
      expect(find.textContaining(m.temas.first.titulo), findsWidgets, reason: '$s');
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });

  testWidgets('$nombre: se resuelven las tablas de experimentos tocando la tabla', (tester) async {
    pantalla(tester, const Size(844, 390));
    var n = 0;
    for (final (_, paso) in pasosDe(temas).toList()) {
      final lab = paso.pantalla(paso.id);
      if (lab is! LabMatriz) continue;
      n++;
      await resolver(tester, temas, paso.id, () async {
        for (final m in lab.muestras) {
          for (final p in lab.pruebas) {
            await tester.tap(find.byTooltip('Probar ${m.nombre} · ${p.nombre}'));
            await tester.pump();
          }
        }
        await tester.tap(find.byTooltip('Responder'));
        await cuadros(tester, 4);
        await tester.tap(find.text(lab.pregunta.opciones[lab.pregunta.correcta]).last);
        await cuadros(tester, 6);
        expect(tester.state<LabMatrizState>(find.byType(LabMatriz)).listo, isTrue, reason: paso.id);
      });
    }
    expect(n, greaterThanOrEqualTo(minTablas));
  });
}
