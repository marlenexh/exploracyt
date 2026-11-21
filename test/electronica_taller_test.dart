import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/electronica/circuito.dart';
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
}
