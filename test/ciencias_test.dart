import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/bio_topics.dart';
import 'package:explora_ciencia/data/fis_topics.dart';
import 'package:explora_ciencia/data/qui_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show BotonSiguiente;
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/ciencia/lab_matriz.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';
import 'package:explora_ciencia/presentation/fisica/sims_fis.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';
import 'package:explora_ciencia/presentation/quimica/sims_qui.dart';

Future<void> _fuentes() async {
  final f = FontLoader('Fredoka')..addFont(Future.value(ByteData.sublistView(File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await f.load();
}

void _pantalla(WidgetTester t, Size s) {
  t.view.physicalSize = s * 2;
  t.view.devicePixelRatio = 2;
  addTearDown(t.view.reset);
}

Future<void> _cuadros(WidgetTester t, int n, [int ms = 80]) async {
  for (var i = 0; i < n; i++) {
    await t.pump(Duration(milliseconds: ms));
  }
}

Widget _lanzar(TemaBio tema, Widget pantalla, ProgresoJuego p) => MaterialApp(
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

final _mundos = <String, (String, Map<int, TemaBio>, Map<int, TopicInfo>, List<String>)>{
  'qui': (
    'Química',
    temasQui,
    quiTopics,
    ['El mundo de los materiales', 'Los gases y sus propiedades', 'Todo se transforma', 'Cocción y descomposición de los alimentos', 'Combustión y oxidación'],
  ),
  'fis': (
    'Física',
    temasFis,
    fisTopics,
    ['El magnetismo y sus misterios', 'La gravedad en acción', 'Calor y energía térmica', 'La energía que nos rodea', 'Explorando el Sistema Solar'],
  ),
};

Iterable<(TemaBio, PasoBio)> _pasos() sync* {
  for (final (_, temas, _, _) in _mundos.values) {
    for (final t in temas.values) {
      for (final m in t.misiones) {
        for (final p in m.pasos) {
          yield (t, p);
        }
      }
    }
  }
}

/// Abre un paso, ejecuta [resolver] y termina con el botón "Siguiente".
Future<void> _resolver(WidgetTester tester, String id, Future<void> Function() resolver) async {
  final (tema, paso) = _pasos().firstWhere((e) => e.$2.id == id);
  final p = ProgresoJuego();
  await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(id), child: paso.pantalla(id)), p));
  await _cuadros(tester, 6);
  await resolver();
  await tester.pump();
  expect(find.byType(BotonSiguiente), findsOneWidget, reason: id);
  await tester.tap(find.byType(BotonSiguiente));
  await _cuadros(tester, 12);
  expect(p.estrellasDe(id), 3, reason: id);
  if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
  await _cuadros(tester, 6);
  expect(tester.takeException(), isNull, reason: id);
  await tester.pumpWidget(const SizedBox());
  await _cuadros(tester, 2);
}

void main() {
  setUpAll(_fuentes);

  for (final MapEntry(key: w, value: (nombre, temas, infos, titulos)) in _mundos.entries) {
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
        _pantalla(tester, const Size(844, 390));
        await tester.pumpWidget(MaterialApp(home: TemaBioJuego(tema: tema, horizontal: false)));
        await _cuadros(tester, 15);
        await tester.tap(find.text('Comenzar').first);
        await _cuadros(tester, 15);
        for (final m in tema.misiones) {
          expect(find.textContaining(m.subtitulo), findsWidgets);
        }
        expect(tester.takeException(), isNull);
      });
      for (final s in const [Size(844, 390), Size(1280, 800)]) {
        testWidgets('$nombre tema ${tema.numero}: pantallas (${s.width.toInt()}×${s.height.toInt()})', (tester) async {
          _pantalla(tester, s);
          for (final m in tema.misiones) {
            for (final p in m.pasos) {
              await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(p.id), child: p.pantalla(p.id)), ProgresoJuego()));
              await _cuadros(tester, 8);
              expect(tester.takeException(), isNull, reason: p.titulo);
            }
          }
          await tester.pumpWidget(const SizedBox());
          await _cuadros(tester, 3);
        });
      }
    }
  }

  testWidgets('Los mapas de Química y Física se ven en celular y computadora', (tester) async {
    for (final w in ['qui', 'fis']) {
      final m = mundos.firstWhere((x) => x.id == w);
      for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800)]) {
        _pantalla(tester, s);
        await tester.pumpWidget(MaterialApp(home: w == 'qui' ? QuimicaScreen(mundo: m) : FisicaScreen(mundo: m)));
        await _cuadros(tester, 4);
        expect(find.textContaining(m.temas.first.titulo), findsWidgets, reason: '$w $s');
        expect(tester.takeException(), isNull, reason: '$w $s');
      }
    }
  });

  testWidgets('Se resuelven todas las tablas de experimentos tocando la tabla', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var n = 0;
    for (final (_, paso) in _pasos().toList()) {
      final w = paso.pantalla(paso.id);
      if (w is! LabMatriz) continue;
      n++;
      await _resolver(tester, paso.id, () async {
        for (final m in w.muestras) {
          for (final p in w.pruebas) {
            await tester.tap(find.byTooltip('Probar ${m.nombre} · ${p.nombre}'));
            await tester.pump();
          }
        }
        await tester.tap(find.byTooltip('Responder'));
        await _cuadros(tester, 4);
        await tester.tap(find.text(w.pregunta.opciones[w.pregunta.correcta]).last);
        await _cuadros(tester, 6);
        expect(tester.state<LabMatrizState>(find.byType(LabMatriz)).listo, isTrue, reason: paso.id);
      });
    }
    expect(n, greaterThanOrEqualTo(6));
  });

  testWidgets('Simulaciones de Química', (tester) async {
    _pantalla(tester, const Size(844, 390));
    await _resolver(tester, 'q2_m2_sim', () async {
      final st = tester.state<SimGasesState>(find.byType(SimGases));
      st.cambiar(v: 0.5);
      st.cambiar(t: 0.9);
      st.cambiar(v: 1);
      await tester.tap(find.byTooltip('Pesar globos'));
      await tester.pump();
      expect(st.hechas.length, SimGasesState.metas.length);
    });
    await _resolver(tester, 'q4_m2_sim', () async {
      final st = tester.state<SimConservacionState>(find.byType(SimConservacion));
      st.cambiar(a: 0, m: 0, d: 6);
      st.cambiar(a: 1, m: 1, d: 7);
      st.cambiar(m: 2);
      st.cambiar(m: 3);
      expect(st.hechas.length, SimConservacionState.metas.length);
    });
    await _resolver(tester, 'q5_m1_sim', () async {
      final st = tester.state<SimCombustionState>(find.byType(SimCombustion));
      await tester.tap(find.byTooltip('Frasco chico'));
      await _cuadros(tester, 50, 100);
      await tester.tap(find.byTooltip('Frasco grande'));
      await _cuadros(tester, 100, 100);
      await tester.tap(find.byTooltip('Sin frasco'));
      await tester.pump();
      await tester.tap(find.byTooltip('Oxígeno'));
      await tester.pump();
      expect(st.hayFuego, isFalse);
      expect(st.hechas.length, SimCombustionState.metas.length);
    });
  });

  testWidgets('Simulaciones de Física', (tester) async {
    _pantalla(tester, const Size(844, 390));
    await _resolver(tester, 'f1_m1_sim', () async {
      final st = tester.state<SimImanesState>(find.byType(SimImanes));
      st.cambiar(d: 0.1);
      await tester.tap(find.byTooltip('Voltear imán'));
      await tester.pump();
      st.cambiar(d: 0.2);
      await tester.tap(find.byTooltip('Brújula'));
      await tester.pump();
      expect(st.hechas.length, SimImanesState.metas.length);
    });
    await _resolver(tester, 'f2_m2_sim', () async {
      final st = tester.state<SimCaidaState>(find.byType(SimCaida));
      st.elegir(i: 0, d: 1, l: false);
      await tester.tap(find.byTooltip('Soltar'));
      await _cuadros(tester, 60, 50);
      st.elegir(l: true);
      st.soltar();
      await _cuadros(tester, 60, 50);
      st.elegir(i: 2, d: 3, l: false);
      st.soltar();
      await _cuadros(tester, 60, 50);
      expect(st.hechas.length, SimCaidaState.metas.length);
    });
    await _resolver(tester, 'f3_m2_sim', () async {
      final st = tester.state<SimCalorState>(find.byType(SimCalor));
      st.elegir(0);
      await tester.tap(find.byTooltip('Juntar'));
      await _cuadros(tester, 90, 100);
      st.elegir(2);
      st.juntar();
      await _cuadros(tester, 90, 100);
      expect(st.hechas.length, SimCalorState.metas.length);
    });
    await _resolver(tester, 'f4_m3_sim', () async {
      final st = tester.state<SimAhorroState>(find.byType(SimAhorro));
      for (var i = 0; i < aparatosCasa.length; i++) {
        if (!aparatosCasa[i].necesario && aparatosCasa[i].emoji != '💡') st.alternar(i);
      }
      await tester.tap(find.byTooltip('Cambiar a focos LED'));
      await tester.pump();
      expect(st.consumo, lessThan(300));
      expect(st.hechas.length, SimAhorroState.metas.length);
    });
    await _resolver(tester, 'f5_m1_sim', () async {
      final st = tester.state<SimSistemaSolarState>(find.byType(SimSistemaSolar));
      for (final p in planetas) {
        await tester.tap(find.byTooltip(p.nombre).first);
        await tester.pump();
      }
      expect(st.visitados.length, 8);
    });
  });
}
