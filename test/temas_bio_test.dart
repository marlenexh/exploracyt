import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/bio_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/tema_bio_screen.dart' show temasBio;
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/biology/temas/pasos.dart';
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show BotonSiguiente;

Widget _envolver(TemaBio tema, Widget w, {ProgresoJuego? progreso}) {
  final p = progreso ?? ProgresoJuego();
  return MaterialApp(
    // Como en el juego: el progreso y el tema envuelven a todas las rutas.
    builder: (context, child) => ConfiguracionJuego(
      desbloquearTodo: true,
      videos: tema.videos,
      child: ProgresoScope(
        progreso: p,
        child: TemaScope(tema: tema, child: Theme(data: temaJuego(), child: child!)),
      ),
    ),
    home: FondoAnimado(color: tema.color, child: w),
  );
}

void _pantalla(WidgetTester tester, Size tam) {
  tester.view.physicalSize = tam * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

Future<void> _cuadros(WidgetTester tester, int n, [int ms = 100]) async {
  for (var f = 0; f < n; f++) {
    await tester.pump(Duration(milliseconds: ms));
  }
}

Future<void> _cargarFuentes() async {
  final fredoka = FontLoader('Fredoka');
  fredoka.addFont(Future.value(ByteData.sublistView(File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await fredoka.load();
}

/// Abre [pantalla] encima de una página base (como lo hace el juego).
Widget _lanzar(TemaBio tema, Widget pantalla, ProgresoJuego progreso) => _envolver(
      tema,
      Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) Navigator.of(context).push(MaterialPageRoute(builder: (_) => pantalla));
        });
        return const SizedBox.expand();
      }),
      progreso: progreso,
    );

Future<void> _arrastrar(WidgetTester tester, Finder desde, Finder hasta) async {
  final g = await tester.startGesture(tester.getCenter(desde));
  await tester.pump(const Duration(milliseconds: 50));
  final destino = tester.getCenter(hasta);
  for (var k = 1; k <= 6; k++) {
    await g.moveTo(Offset.lerp(tester.getCenter(desde), destino, k / 6)!);
    await tester.pump(const Duration(milliseconds: 30));
  }
  await g.up();
  await tester.pump(const Duration(milliseconds: 100));
}

/// Termina la actividad: botón Siguiente y la celebración.
Future<void> _terminar(WidgetTester tester, ProgresoJuego p, String actividad) async {
  await tester.tap(find.byType(BotonSiguiente));
  await _cuadros(tester, 15);
  expect(p.estrellasDe(actividad), greaterThan(0), reason: actividad);
  if (find.text('¡Genial!').evaluate().isNotEmpty) {
    await tester.tap(find.text('¡Genial!').first);
    await _cuadros(tester, 10);
  }
}

Iterable<(TemaBio, PasoBio)> _pasos() sync* {
  for (final t in temasBio.values) {
    for (final m in t.misiones) {
      for (final p in m.pasos) {
        yield (t, p);
      }
    }
  }
}

const _tamanos = [Size(844, 390), Size(1280, 800)];

void main() {
  setUpAll(_cargarFuentes);

  test('Los temas 2 a 5 tienen 3 misiones + integradora y ids únicos', () {
    expect(temasBio.keys, [2, 3, 4, 5]);
    for (final tema in temasBio.values) {
      expect(tema.misiones.length, 4, reason: tema.titulo);
      final ids = [for (final m in tema.misiones) for (final p in m.pasos) p.id];
      expect(ids.toSet().length, ids.length, reason: 'ids repetidos en ${tema.titulo}');
      for (final m in tema.misiones.take(3)) {
        expect(m.pasos.last.titulo, 'Pon a prueba lo que aprendiste', reason: m.subtitulo);
      }
      // Un solo video complementario por tema, al final de la misión 3.
      expect([for (var k = 0; k < 3; k++) tema.misiones[k].pasos.any((p) => p.tipo == TipoPasoBio.video)], [false, false, true], reason: tema.titulo);
      final info = bioTopics[tema.numero]!;
      expect(info.missionIds, tema.idsMisiones);
      expect(info.missions, [for (final m in tema.misiones) m.subtitulo]);
      expect(info.badge, tema.insignia);
    }
  });

  test('El mapa de Biología registra las misiones e insignia de cada tema', () {
    final bio = mundos.firstWhere((m) => m.id == 'bio');
    expect(bio.temas.map((t) => t.titulo).toList(), [
      'El cuerpo humano y sus sistemas',
      'El mundo de las células',
      'Alimentación saludable',
      'La vida a nuestro alrededor',
      'Biodiversidad y ecosistemas',
    ]);
    for (var n = 2; n <= 5; n++) {
      final t = bio.temas[n - 1];
      expect(t.misiones.length, 4);
      expect(t.misiones.every((m) => m.implementada), isTrue);
      expect(t.misiones.take(3).every((m) => m.recompensa == null), isTrue);
      expect(t.misiones.last.recompensa?.id, 'bio-t$n-integration-badge');
      expect(nombreRecompensa('bio-t$n-integration-badge'), bioTopics[n]!.badge);
    }
    expect(nombreRecompensa('bio-t1-integration-badge'), 'Explorador del Cuerpo Humano');
  });

  for (final tema in temasBio.values) {
    testWidgets('Tema ${tema.numero}: intro → misiones con candado', (tester) async {
      _pantalla(tester, const Size(844, 390));
      await tester.pumpWidget(MaterialApp(home: TemaBioJuego(tema: tema, horizontal: false)));
      await _cuadros(tester, 20);
      expect(find.textContaining(tema.titulo), findsWidgets);
      await tester.tap(find.text('Comenzar').first);
      await _cuadros(tester, 20);
      for (final m in tema.misiones) {
        expect(find.textContaining(m.subtitulo), findsWidgets, reason: m.subtitulo);
      }
      expect(find.byIcon(Icons.lock_rounded), findsNWidgets(3));
    });

    for (final tam in _tamanos) {
      testWidgets('Tema ${tema.numero}: todas las pantallas se dibujan (${tam.width.toInt()}×${tam.height.toInt()})', (tester) async {
        _pantalla(tester, tam);
        for (final m in tema.misiones) {
          for (final p in m.pasos) {
            await tester.pumpWidget(_envolver(tema, KeyedSubtree(key: ValueKey(p.id), child: p.pantalla(p.id))));
            await _cuadros(tester, 12);
            expect(tester.takeException(), isNull, reason: '${tema.titulo} · ${p.titulo}');
          }
        }
        await tester.pumpWidget(const SizedBox());
        await _cuadros(tester, 5);
      });
    }
  }

  testWidgets('En vertical el tema se gira', (tester) async {
    _pantalla(tester, const Size(390, 844));
    await tester.pumpWidget(MaterialApp(home: TemaBioJuego(tema: temasBio[2]!, horizontal: false)));
    await _cuadros(tester, 20);
    expect(find.byType(RotatedBox), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Se completan todas las actividades de clasificar, ordenar y situación', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var hechas = 0;
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! PantallaClasificar && w is! PantallaOrdenar && w is! PantallaSituacionBio) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 12);
      if (w is PantallaClasificar) {
        for (final it in w.items) {
          await _arrastrar(tester, find.text(it.texto).last, find.text(w.grupos[it.grupo].nombre).first);
        }
        await _cuadros(tester, 6);
      } else if (w is PantallaOrdenar) {
        for (final (_, texto) in w.pasos) {
          await _arrastrar(tester, find.text(texto).last, find.text('?').first);
        }
        await tester.tap(find.byTooltip('Comprobar orden'));
        await _cuadros(tester, 6);
      } else if (w is PantallaSituacionBio) {
        for (var i = 0; i < w.escenas.length; i++) {
          final e = w.escenas[i];
          await tester.tap(find.text(e.opciones[e.correcta]).last);
          await _cuadros(tester, 6);
          if (i < w.escenas.length - 1) {
            await tester.tap(find.byType(BotonSiguiente));
            await _cuadros(tester, 8);
          }
        }
      }
      await _terminar(tester, p, paso.id);
      expect(p.estrellasDe(paso.id), 3, reason: '${paso.titulo}: sin errores deben ser 3 estrellas');
      expect(tester.takeException(), isNull);
      hechas++;
    }
    expect(hechas, 18);
  });
}
