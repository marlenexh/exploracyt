import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/electronica/sim_3d_circuito.dart';
import 'package:explora_ciencia/presentation/ia/sim_3d_red.dart';
import 'package:explora_ciencia/presentation/programacion/sim_3d_robot.dart';

import 'mundo_temas_util.dart';

Widget _app(Widget w, ProgresoJuego p) => MaterialApp(
      builder: (_, child) => ConfiguracionJuego(desbloquearTodo: true, child: ProgresoScope(progreso: p, child: Theme(data: temaJuego(), child: child!))),
      home: w,
    );

const _tamanos = [Size(844, 390), Size(1280, 800), Size(390, 844)];

void main() {
  setUpAll(fuentes);

  test('La red neuronal clasifica bien a los animales de ejemplo', () {
    for (final (_, nombre, caracteristicas, clase) in animalesRed) {
      expect(respuestaRed(caracteristicas), clase, reason: nombre);
    }
    expect(respuestaRed([false, false, false, false]), isNull, reason: 'Sin datos no está segura');
  });

  test('Cada nivel del robot 3D tiene solución y detecta choques', () {
    const soluciones = [
      [Orden.avanzar, Orden.avanzar, Orden.avanzar],
      [Orden.avanzar, Orden.avanzar, Orden.derecha, Orden.avanzar, Orden.avanzar],
      [Orden.avanzar, Orden.derecha, Orden.avanzar, Orden.avanzar, Orden.izquierda, Orden.avanzar, Orden.avanzar, Orden.avanzar],
    ];
    for (var k = 0; k < nivelesRobot3D.length; k++) {
      final (rec, choco) = recorrerRobot(nivelesRobot3D[k], soluciones[k]);
      expect(choco, isFalse, reason: nivelesRobot3D[k].titulo);
      expect((rec.last.$1, rec.last.$2), nivelesRobot3D[k].meta, reason: nivelesRobot3D[k].titulo);
    }
    // En el nivel 3 hay una roca en (2, 0)
    expect(recorrerRobot(nivelesRobot3D[2], [Orden.avanzar, Orden.avanzar]).$2, isTrue);
    // Salirse del tablero cuenta como choque
    expect(recorrerRobot(nivelesRobot3D[0], [Orden.izquierda, Orden.avanzar]).$2, isTrue);
  });

  testWidgets('Circuito 3D: piezas, encender, dos pilas y cable cortado', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(_app(SimCircuito3D(key: ValueKey(s), actividad: 'x', color: Colors.blue), ProgresoJuego()));
      await cuadros(tester, 4);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<SimCircuito3DState>(find.byType(SimCircuito3D));
    for (final id in ['pila', 'cable_entero', 'interruptor_abierto', 'foco']) {
      st.tocar(id);
    }
    await tester.tap(find.textContaining('Interruptor: abierto'));
    await cuadros(tester, 3);
    expect(st.encendido, isTrue);
    await tester.tap(find.text('🔋 1 pila'));
    await cuadros(tester, 3);
    await tester.tap(find.text('〰️ Cable completo'));
    await cuadros(tester, 3);
    expect(st.encendido, isFalse);
    expect(find.textContaining('camino abierto'), findsOneWidget);
    expect(st.logros.length, SimCircuito3DState.objetivos.length);
    expect(find.text('Terminar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Red neuronal 3D: ave, mamífero, murciélago y capas', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(_app(SimRedNeuronal3D(key: ValueKey(s), actividad: 'x', color: Colors.purple), ProgresoJuego()));
      await cuadros(tester, 4);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<SimRedNeuronal3DState>(find.byType(SimRedNeuronal3D));
    await tester.tap(find.text('🕊️ Paloma'));
    await cuadros(tester, 2);
    expect(find.textContaining('es un AVE'), findsOneWidget);
    await tester.tap(find.text('🐄 Vaca'));
    await cuadros(tester, 2);
    await tester.tap(find.text('🦇 Murciélago'));
    await cuadros(tester, 2);
    expect(find.textContaining('No se dejó engañar'), findsOneWidget);
    for (final id in ['entrada0', 'oculta2', 'salida1']) {
      st.tocar(id);
    }
    await cuadros(tester, 2);
    expect(st.logros.length, SimRedNeuronal3DState.objetivos.length);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Robot 3D: arma el programa, ejecútalo y pasa los 3 niveles', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(_app(SimRobot3D(key: ValueKey(s), actividad: 'x', color: Colors.blue), ProgresoJuego()));
      await cuadros(tester, 4);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<SimRobot3DState>(find.byType(SimRobot3D));
    Future<void> correr(List<String> ordenes) async {
      for (final o in ordenes) {
        await tester.tap(find.byTooltip(o));
        await tester.pump();
      }
      await tester.tap(find.byTooltip('Ejecutar'));
      for (var i = 0; i < 40 && st.ejecutando; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    // Un error primero: se sale del tablero
    await correr(['Girar a la izquierda', 'Avanzar']);
    expect(find.textContaining('salir del tablero'), findsOneWidget);
    await tester.tap(find.byTooltip('Borrar todo'));
    await tester.pump();
    await correr(['Avanzar', 'Avanzar', 'Avanzar']);
    expect(st.logrado, isTrue);
    await tester.tap(find.text('Siguiente nivel'));
    await cuadros(tester, 2);
    await correr(['Avanzar', 'Avanzar', 'Girar a la derecha', 'Avanzar', 'Avanzar']);
    expect(st.logrado, isTrue);
    await tester.tap(find.text('Siguiente nivel'));
    await cuadros(tester, 2);
    await correr(['Avanzar', 'Girar a la derecha', 'Avanzar', 'Avanzar', 'Girar a la izquierda', 'Avanzar', 'Avanzar', 'Avanzar']);
    expect(st.logrado, isTrue);
    expect(find.text('Terminar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
