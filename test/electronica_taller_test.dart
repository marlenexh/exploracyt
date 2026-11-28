import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/electronica/bloques.dart';
import 'package:explora_ciencia/presentation/electronica/circuito.dart';
import 'package:explora_ciencia/presentation/electronica/ele_tema5.dart';
import 'package:explora_ciencia/presentation/electronica/taller.dart';

Future<void> _fuentes() async {
  final f = FontLoader('Fredoka')..addFont(Future.value(ByteData.sublistView(File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await f.load();
}

Future<void> _cuadros(WidgetTester t, int n) async {
  for (var i = 0; i < n; i++) {
    await t.pump(const Duration(milliseconds: 80));
  }
}

/// Toca una terminal del área de trabajo (coordenadas del área → pantalla).
Future<void> tocarTerminal(WidgetTester tester, String terminal) async {
  final st = tester.state<TallerCircuitosState>(find.byType(TallerCircuitos));
  final area = find.byKey(const ValueKey('area_taller'));
  final esc = (tester.getBottomRight(area).dx - tester.getTopLeft(area).dx) / anchoArea;
  await tester.tapAt(tester.getTopLeft(area) + st.terminalPos(terminal) * esc);
  await tester.pump(const Duration(milliseconds: 50));
}

Future<void> conectar(WidgetTester tester, String a, String b) async {
  await tocarTerminal(tester, a);
  await tocarTerminal(tester, b);
}

void main() {
  setUpAll(_fuentes);
  testWidgets('Taller: el LED sin resistencia se quema y con resistencia enciende', (tester) async {
    tester.view.physicalSize = const Size(844, 390) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final p = ProgresoJuego();
    await tester.pumpWidget(MaterialApp(
      builder: (_, child) => ConfiguracionJuego(desbloquearTodo: true, child: ProgresoScope(progreso: p, child: Theme(data: temaJuego(), child: child!))),
      home: Builder(builder: (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => TallerCircuitos(
                      actividad: 'x',
                      seccion: 'Lab',
                      titulo: 'Enciende',
                      color: Colors.blue,
                      mensajeFinal: 'Bien',
                      retos: [
                        RetoCircuito(
                          titulo: 'LED',
                          instruccion: 'Conecta',
                          piezas: () => [
                            Pieza('pila', TipoPieza.pila9v, const Offset(100, 200)),
                            Pieza('r', TipoPieza.resistencia, const Offset(300, 80)),
                            Pieza('led', TipoPieza.led, const Offset(450, 180)),
                          ],
                          condiciones: [Condicion('LED encendido', (e) => e.encendido('led'))],
                          logro: 'ok',
                        ),
                      ],
                    )));
          }
        });
        return const SizedBox.expand();
      }),
    ));
    await _cuadros(tester, 10);
    // Sin resistencia: se quema
    await conectar(tester, 'pila.0', 'led.0');
    await conectar(tester, 'led.1', 'pila.1');
    await tester.tap(find.byTooltip('Iniciar simulación'));
    await _cuadros(tester, 5);
    final st = tester.state<TallerCircuitosState>(find.byType(TallerCircuitos));
    expect(st.piezas.firstWhere((x) => x.id == 'led').quemado, isTrue);
    expect(st.errores, 1);
    await tester.tap(find.byTooltip('Detener simulación'));
    await tester.tap(find.byTooltip('Quitar cables'));
    await _cuadros(tester, 3);
    await conectar(tester, 'pila.0', 'r.0');
    await conectar(tester, 'r.1', 'led.0');
    await conectar(tester, 'led.1', 'pila.1');
    expect(st.cables.length, 3);
    await tester.tap(find.byTooltip('Iniciar simulación'));
    await _cuadros(tester, 5);
    expect(st.completo, isTrue);
    await tester.tap(find.text('Terminar'));
    await _cuadros(tester, 15);
    expect(p.estrellasDe('x'), 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pista: guía cable por cable, quita los que sobran y explica en palabras sencillas', (tester) async {
    tester.view.physicalSize = const Size(844, 390) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final p = ProgresoJuego();
    await tester.pumpWidget(MaterialApp(
      builder: (_, child) => ConfiguracionJuego(desbloquearTodo: true, child: ProgresoScope(progreso: p, child: Theme(data: temaJuego(), child: child!))),
      home: TallerCircuitos(
        actividad: 'x',
        seccion: 'Lab',
        titulo: 'Enciende',
        color: Colors.blue,
        mensajeFinal: 'Bien',
        retos: [
          RetoCircuito(
            titulo: 'Tu primer LED',
            instruccion: 'Conecta',
            piezas: () => [
              Pieza('pila', TipoPieza.pila9v, const Offset(100, 200)),
              Pieza('r', TipoPieza.resistencia, const Offset(300, 80)),
              Pieza('led', TipoPieza.led, const Offset(450, 180)),
            ],
            condiciones: [Condicion('LED encendido', (e) => e.encendido('led'))],
            logro: 'ok',
          ),
        ],
      ),
    ));
    await _cuadros(tester, 4);
    final st = tester.state<TallerCircuitosState>(find.byType(TallerCircuitos));
    // Un cable que no va: la pista lo señala y luego lo quita
    await conectar(tester, 'pila.0', 'led.1');
    await tester.tap(find.byTooltip('Pista'));
    await _cuadros(tester, 2);
    expect(st.cableSobrante, isNotNull);
    await tester.tap(find.byTooltip('Pista'));
    await _cuadros(tester, 2);
    expect(st.cables, isEmpty);
    // Primera pista: señala el cable y lo explica
    await tester.tap(find.byTooltip('Pista'));
    await _cuadros(tester, 2);
    expect(st.pista, ('pila.0', 'r.0'));
    expect(find.textContaining('el + de la pila'), findsOneWidget);
    // El alumno lo conecta solo y la señal desaparece
    await conectar(tester, 'pila.0', 'r.0');
    expect(st.pista, isNull);
    // Las demás, pidiendo la pista dos veces (la segunda conecta el cable)
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byTooltip('Pista'));
      await _cuadros(tester, 1);
      await tester.tap(find.byTooltip('Pista'));
      await _cuadros(tester, 1);
    }
    expect(st.cables.length, 3);
    await tester.tap(find.byTooltip('Pista'));
    await _cuadros(tester, 1);
    expect(find.textContaining('Iniciar simulación'), findsWidgets);
    await tester.tap(find.byTooltip('Iniciar simulación'));
    await _cuadros(tester, 4);
    expect(st.completo, isTrue);
    expect(tester.takeException(), isNull);
  });

  test('Cada terminal tiene un nombre fácil de entender', () {
    final ps = [
      Pieza('pila', TipoPieza.pila9v, Offset.zero),
      Pieza('a', TipoPieza.led, Offset.zero),
      Pieza('b', TipoPieza.led, Offset.zero),
      Pieza('pot', TipoPieza.potenciometro, Offset.zero),
    ];
    expect(nombreTerminal(ps, 'pila.1'), contains('−'));
    expect(nombreTerminal(ps, 'b.0'), contains('LED 2'));
    expect(nombreTerminal(ps, 'pot.1'), contains('central'));
  });

  test('Pista de bloques: siempre encuentra una solución para cada invento', () {
    for (final r in [retoLampara, retoVentilador, retoAlarma, retoBarrera, retoInvernadero]) {
      final reglas = List.generate(r.reglas, (i) => Regla()..salida = i % r.salidas.length);
      expect(solucionCercana(r, reglas), isNotNull, reason: r.titulo);
    }
  });

  testWidgets('Pista de bloques: guía hasta que el invento funciona', (tester) async {
    tester.view.physicalSize = const Size(844, 390) * 2;
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      builder: (_, child) =>
          ConfiguracionJuego(desbloquearTodo: true, child: ProgresoScope(progreso: ProgresoJuego(), child: Theme(data: temaJuego(), child: child!))),
      home: ProgramaBloques(actividad: 'x', seccion: 'Programa', titulo: 'Invernadero', color: Colors.teal, retos: [retoInvernadero], mensajeFinal: 'ok'),
    ));
    await _cuadros(tester, 3);
    for (var i = 0; i < 20 && find.textContaining('ya están bien').evaluate().isEmpty; i++) {
      await tester.tap(find.byTooltip('Pista'));
      await _cuadros(tester, 1);
    }
    expect(find.textContaining('ya están bien'), findsOneWidget);
    await tester.tap(find.byTooltip('Probar programa'));
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    expect(find.textContaining('Tu invento funciona'), findsOneWidget);
  });
}
