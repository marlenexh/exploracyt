import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/ele_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show BotonSiguiente;
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/electronica/bloques.dart';
import 'package:explora_ciencia/presentation/electronica/electronica_screen.dart';
import 'package:explora_ciencia/presentation/electronica/sims_ele.dart';
import 'package:explora_ciencia/presentation/electronica/taller.dart';

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

Iterable<(TemaBio, PasoBio)> _pasos() sync* {
  for (final t in temasEle.values) {
    for (final m in t.misiones) {
      for (final p in m.pasos) {
        yield (t, p);
      }
    }
  }
}

// --- Taller ------------------------------------------------------------------

TallerCircuitosState _taller(WidgetTester t) => t.state<TallerCircuitosState>(find.byType(TallerCircuitos));

Offset _global(WidgetTester t, Offset local) {
  final area = find.byKey(const ValueKey('area_taller'));
  final esc = (t.getBottomRight(area).dx - t.getTopLeft(area).dx) / anchoArea;
  return t.getTopLeft(area) + local * esc;
}

Future<void> _cable(WidgetTester t, String a, String b) async {
  for (final x in [a, b]) {
    await t.tapAt(_global(t, _taller(t).terminalPos(x)));
    await t.pump(const Duration(milliseconds: 40));
  }
}

Future<void> _tocarPieza(WidgetTester t, String id) async {
  await t.tapAt(_global(t, _taller(t).piezas.firstWhere((p) => p.id == id).pos));
  await t.pump(const Duration(milliseconds: 60));
}

Future<void> _presionar(WidgetTester t, String id) async {
  final g = await t.startGesture(_global(t, _taller(t).piezas.firstWhere((p) => p.id == id).pos));
  await _cuadros(t, 3);
  await g.up();
  await _cuadros(t, 3);
}

Future<void> _simular(WidgetTester t) async {
  await t.tap(find.byTooltip('Iniciar simulación'));
  await _cuadros(t, 3);
}

Future<void> _detener(WidgetTester t) async {
  await t.tap(find.byTooltip('Detener simulación'));
  await t.tap(find.byTooltip('Quitar cables'));
  await _cuadros(t, 2);
}

Future<void> _todos(WidgetTester t, List<(String, String)> cs) async {
  for (final (a, b) in cs) {
    await _cable(t, a, b);
  }
}

Future<void> _deslizar(WidgetTester t, int indice, double dx) async {
  await t.drag(find.byType(Slider).at(indice), Offset(dx, 0));
  await _cuadros(t, 2);
}

const _circuitoLed = [('pila.0', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')];

/// Cómo resolver cada reto del taller, por título.
final Map<String, Future<void> Function(WidgetTester)> _soluciones = {
  'Tu primer LED': (t) async {
    await _todos(t, _circuitoLed);
    await _simular(t);
  },
  '¿Y si lo volteas?': (t) async {
    await _todos(t, [('r.1', 'led.1'), ('led.0', 'pila.1')]);
    await _simular(t);
    await _detener(t);
    await _todos(t, [('r.1', 'led.0'), ('led.1', 'pila.1')]);
    await _simular(t);
  },
  'Elige la resistencia': (t) async {
    await _todos(t, _circuitoLed);
    await _simular(t);
    await _tocarPieza(t, 'r');
    await t.tap(find.text('220 Ω').last);
    await _cuadros(t, 2);
  },
  'Linterna': (t) async {
    await _todos(t, [('pila.0', 'sw.0'), ('sw.1', 'foco.0'), ('foco.1', 'pila.1')]);
    await _simular(t);
    await _tocarPieza(t, 'sw');
    await _tocarPieza(t, 'sw');
  },
  'Timbre': (t) async {
    await _todos(t, [('pila.0', 'b.0'), ('b.1', 'z.0'), ('z.1', 'pila.1')]);
    await _simular(t);
    await _presionar(t, 'b');
  },
  'Circuito con interruptor': (t) async {
    await _todos(t, [('pila.0', 'sw.0'), ('sw.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]);
    await _simular(t);
    await _tocarPieza(t, 'sw');
    await _tocarPieza(t, 'sw');
  },
  'Encuentra la falla': (t) async {
    await _cable(t, 'r.1', 'led.0');
    await _simular(t);
  },
  'En serie': (t) async {
    await _todos(t, [('pila.0', 'r.0'), ('r.1', 'a.0'), ('a.1', 'b.0'), ('b.1', 'pila.1')]);
    await _simular(t);
  },
  'En paralelo': (t) async {
    await _todos(t, [('pila.0', 'r1.0'), ('pila.0', 'r2.0'), ('r1.1', 'a.0'), ('r2.1', 'b.0'), ('a.1', 'pila.1'), ('b.1', 'pila.1')]);
    await _simular(t);
  },
  'Cortocircuito': (t) async {
    await _cable(t, 'pila.0', 'pila.1');
    await _simular(t);
    await _detener(t);
    await _todos(t, _circuitoLed);
    await _simular(t);
  },
  'Fotorresistencia': (t) async {
    await _todos(t, [('pila.0', 'ldr.0'), ('ldr.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]);
    await _simular(t);
    await _deslizar(t, 0, -400);
  },
  'Enciende el motor': (t) async {
    await _todos(t, [('pila.0', 'sw.0'), ('sw.1', 'm.0'), ('m.1', 'pila.1')]);
    await _simular(t);
    await _tocarPieza(t, 'sw');
  },
  'Cambia el sentido': (t) async {
    await _todos(t, [('pila.0', 'm.0'), ('m.1', 'pila.1')]);
    await _simular(t);
    await _detener(t);
    await _todos(t, [('pila.0', 'm.1'), ('m.0', 'pila.1')]);
    await _simular(t);
  },
  'Control de velocidad': (t) async {
    await _todos(t, [('pila.0', 'pot.0'), ('pot.1', 'm.0'), ('m.1', 'pila.1')]);
    await _simular(t);
    await _deslizar(t, 0, -400);
  },
  'Ventilador': (t) async {
    await _todos(t, [('pila.0', 'sw.0'), ('sw.1', 'm.0'), ('m.1', 'pila.1'), ('sw.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]);
    await _simular(t);
    await _tocarPieza(t, 'sw');
  },
  'Alarma con luz': (t) async {
    await _todos(t, [('pila.0', 'b.0'), ('b.1', 'z.0'), ('z.1', 'pila.1'), ('b.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]);
    await _simular(t);
    await _presionar(t, 'b');
  },
};

// --- Programas ---------------------------------------------------------------

void _regla(Regla r, {required int sensor, required bool mayor, int umbral = 0, required int salida}) {
  r
    ..sensor = sensor
    ..mayor = mayor
    ..umbral = umbral
    ..salida = salida
    ..encender = true;
}

final Map<String, void Function(List<Regla>)> _programas = {
  'Ventilador inteligente': (rs) => _regla(rs[0], sensor: 1, mayor: true, umbral: 1, salida: 0),
  'Alarma del museo': (rs) => _regla(rs[0], sensor: 1, mayor: true, salida: 1),
  'Barrera del estacionamiento': (rs) => _regla(rs[0], sensor: 1, mayor: false, umbral: 1, salida: 0),
  'Invernadero automático': (rs) {
    _regla(rs[0], sensor: 0, mayor: false, umbral: 1, salida: 0);
    _regla(rs[1], sensor: 1, mayor: false, umbral: 1, salida: 1);
  },
};

void main() {
  setUpAll(_fuentes);

  test('Los 5 temas de Electrónica están completos y con ids únicos', () {
    expect(temasEle.keys, [1, 2, 3, 4, 5]);
    for (final tema in temasEle.values) {
      expect(tema.id, 'ele-t${tema.numero}');
      expect(tema.misiones.length, 4);
      final ids = [for (final m in tema.misiones) for (final p in m.pasos) p.id];
      expect(ids.toSet().length, ids.length, reason: tema.titulo);
      for (final m in tema.misiones.take(3)) {
        expect(m.pasos.any((p) => p.tipo == TipoPasoBio.video), isTrue, reason: m.subtitulo);
        expect(m.pasos.last.titulo, 'Pon a prueba lo que aprendiste', reason: m.subtitulo);
      }
      final info = eleTopics[tema.numero]!;
      expect(info.missionIds, tema.idsMisiones);
      expect(info.missions, [for (final m in tema.misiones) m.subtitulo]);
      expect(info.badge, tema.insignia);
    }
  });

  test('El mapa de Electrónica tiene los 5 temas con sus misiones e insignias', () {
    final ele = mundos.firstWhere((m) => m.id == 'ele');
    expect(ele.temas.map((t) => t.titulo).toList(),
        ['Conoce los componentes', 'Conecta y enciende', 'Detectives electrónicos', 'Máquinas en movimiento', 'Crea tu invento']);
    for (var n = 1; n <= 5; n++) {
      final t = ele.temas[n - 1];
      expect(t.misiones.length, 4);
      expect(t.misiones.every((m) => m.implementada), isTrue);
      expect(t.misiones.last.recompensa?.id, 'ele-t$n-integration-badge');
      expect(nombreRecompensa('ele-t$n-integration-badge'), eleTopics[n]!.badge);
    }
  });

  testWidgets('El mapa de Electrónica muestra los 5 temas (celular y computadora)', (tester) async {
    final ele = mundos.firstWhere((m) => m.id == 'ele');
    for (final s in const [Size(390, 844), Size(1280, 800)]) {
      _pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(home: ElectronicaScreen(mundo: ele)));
      await _cuadros(tester, 5);
      for (final t in temasEle.values) {
        expect(find.text(t.titulo), findsOneWidget);
      }
      expect(tester.takeException(), isNull);
    }
  });

  for (final tema in temasEle.values) {
    testWidgets('Electrónica tema ${tema.numero}: intro → misiones', (tester) async {
      _pantalla(tester, const Size(844, 390));
      await tester.pumpWidget(MaterialApp(home: TemaBioJuego(tema: tema, horizontal: false)));
      await _cuadros(tester, 15);
      expect(find.textContaining(tema.titulo), findsWidgets);
      await tester.tap(find.text('Comenzar').first);
      await _cuadros(tester, 15);
      for (final m in tema.misiones) {
        expect(find.textContaining(m.subtitulo), findsWidgets);
      }
      expect(find.byIcon(Icons.lock_rounded), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    });

    for (final s in const [Size(844, 390), Size(1280, 800)]) {
      testWidgets('Electrónica tema ${tema.numero}: pantallas sin errores (${s.width.toInt()}×${s.height.toInt()})', (tester) async {
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

  testWidgets('Se resuelven todos los retos del taller de circuitos', (tester) async {
    _pantalla(tester, const Size(844, 390));
    final resueltos = <String>[];
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! TallerCircuitos) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 6);
      for (var i = 0; i < w.retos.length; i++) {
        final reto = w.retos[i];
        final sol = _soluciones[reto.titulo];
        expect(sol, isNotNull, reason: 'Falta solución para ${reto.titulo}');
        await sol!(tester);
        expect(_taller(tester).completo, isTrue, reason: reto.titulo);
        resueltos.add(reto.titulo);
        await tester.tap(find.byType(BotonSiguiente));
        await _cuadros(tester, 12);
      }
      expect(p.estrellasDe(paso.id), 3, reason: '${paso.titulo} sin errores');
      if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
      await _cuadros(tester, 6);
      expect(tester.takeException(), isNull);
    }
    expect(resueltos.toSet(), _soluciones.keys.toSet());
  });

  testWidgets('Se resuelven todos los programas de bloques', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var n = 0;
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! ProgramaBloques) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 6);
      for (final reto in w.retos) {
        final st = tester.state<ProgramaBloquesState>(find.byType(ProgramaBloques));
        if (reto.titulo == 'Lámpara automática') {
          // Con los bloques, como lo haría el alumno: "si luz es menor que 50 % entonces encender foco".
          await tester.tap(find.byTooltip('Regla 1 comparar'));
          await tester.pump();
          await tester.tap(find.byTooltip('Regla 1 valor'));
          await tester.pump();
        } else {
          _programas[reto.titulo]!(st.reglas);
        }
        await tester.tap(find.byTooltip('Probar programa'));
        await _cuadros(tester, reto.momentos.length + 2, 950);
        expect(st.completo, isTrue, reason: reto.titulo);
        n++;
        await tester.tap(find.byType(BotonSiguiente));
        await _cuadros(tester, 12);
      }
      expect(p.estrellasDe(paso.id), 3, reason: paso.titulo);
      if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
      await _cuadros(tester, 6);
    }
    expect(n, 5);
  });

  testWidgets('Un programa equivocado se marca y no avanza', (tester) async {
    _pantalla(tester, const Size(844, 390));
    final tema = temasEle[5]!;
    final paso = tema.misiones[0].pasos.firstWhere((x) => x.id == 'e5_m1_prog');
    await tester.pumpWidget(_lanzar(tema, paso.pantalla(paso.id), ProgresoJuego()));
    await _cuadros(tester, 6);
    await tester.tap(find.byTooltip('Probar programa'));
    await _cuadros(tester, 8, 950);
    final st = tester.state<ProgramaBloquesState>(find.byType(ProgramaBloques));
    expect(st.completo, isFalse);
    expect(st.errores, 1);
    expect(st.resultado(0), isFalse);
  });

  testWidgets('Laboratorios: colores de resistencias, sensores y engranes', (tester) async {
    _pantalla(tester, const Size(844, 390));
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! SimBandasResistencia && w is! LabSensores && w is! SimEngranes) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 6);
      if (w is SimBandasResistencia) {
        final bandas = [1, 0, 0];
        for (final meta in const [
          [2, 2, 1],
          [1, 0, 2],
          [1, 0, 3]
        ]) {
          for (var i = 0; i < 3; i++) {
            while (bandas[i] != meta[i]) {
              await tester.tap(find.byTooltip('Franja ${i + 1}'));
              await tester.pump();
              bandas[i] = (bandas[i] + 1) % (i == 2 ? 7 : 10);
              if (i == 0 && bandas[0] == 0) bandas[0] = 1;
            }
          }
          await tester.tap(find.byTooltip('Comprobar resistencia'));
          await _cuadros(tester, 2);
        }
      } else if (w is LabSensores) {
        final st = tester.state<LabSensoresState>(find.byType(LabSensores));
        for (final (k, id, a, b) in const [(0, 'luz', 1.0, 0.0), (1, 'temperatura', 45.0, -5.0), (2, 'movimiento', 0.6, 0.1), (3, 'distancia', 10.0, 180.0)]) {
          st.elegir(k);
          st.cambiar(id, a);
          st.cambiar(id, b);
          await _cuadros(tester, 2);
        }
        expect(st.metas, 8);
      } else if (w is SimEngranes) {
        final st = tester.state<SimEngranesState>(find.byType(SimEngranes));
        await tester.tap(find.text('30 dientes').first);
        await tester.pump();
        await tester.tap(find.text('10 dientes').last);
        await tester.pump();
        st.cambiar(m: 10, s: 30);
        await tester.tap(find.text('⚙️ Agregar rueda loca'));
        await _cuadros(tester, 2);
        expect(st.logros, 3);
      }
      await tester.tap(find.byType(BotonSiguiente));
      await _cuadros(tester, 12);
      expect(p.estrellasDe(paso.id), 3, reason: paso.titulo);
      if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
      await _cuadros(tester, 6);
      expect(tester.takeException(), isNull);
    }
  });
}
