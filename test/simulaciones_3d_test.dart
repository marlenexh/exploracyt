import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/tema1/estilo_mundo.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/electronica/sim_3d_circuito.dart';
import 'package:explora_ciencia/presentation/fisica/fis_tema5.dart';
import 'package:explora_ciencia/presentation/fisica/sim_3d_sistema_solar.dart';
import 'package:explora_ciencia/presentation/quimica/qui_tema2.dart';
import 'package:explora_ciencia/presentation/quimica/sim_3d_estados.dart';
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

  testWidgets('Sistema Solar 3D: el Sol, la Tierra, Júpiter y 6 planetas', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(_app(SimSistemaSolar3D(key: ValueKey(s), actividad: 'x', color: Colors.orange), ProgresoJuego()));
      await cuadros(tester, 4);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    final st = tester.state<SimSistemaSolar3DState>(find.byType(SimSistemaSolar3D));
    st.tocar('sol');
    await tester.pump();
    expect(find.textContaining('El Sol es una estrella'), findsOneWidget);
    for (final i in [2, 4, 0, 1, 3, 5]) {
      st.tocar(SimSistemaSolar3DState.idPlaneta(i));
    }
    await tester.tap(find.text('🚀 Más rápido'));
    await cuadros(tester, 4);
    expect(st.logros.length, SimSistemaSolar3DState.objetivos.length);
    expect(find.text('Terminar'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Estados de la materia 3D: sólido, líquido, gas y la pregunta', (tester) async {
    for (final s in _tamanos) {
      pantalla(tester, s);
      await tester.pumpWidget(_app(SimEstados3D(key: ValueKey(s), actividad: 'x', color: Colors.blue), ProgresoJuego()));
      await cuadros(tester, 4);
      expect(tester.takeException(), isNull, reason: '$s');
    }
    await tester.tap(find.text('🌡️ Templado (25 °C)'));
    await cuadros(tester, 6);
    expect(find.textContaining('se deslizan'), findsOneWidget);
    await tester.tap(find.text('🔥 Calentar (110 °C)'));
    await cuadros(tester, 6);
    expect(find.text(SimEstados3DState.pregunta), findsOneWidget);
    await tester.tap(find.text('En el sólido'));
    await tester.pump();
    expect(find.text('Terminar'), findsNothing);
    await tester.tap(find.text('En el gas'));
    await tester.pump();
    expect(find.text('Terminar'), findsOneWidget);
    // Las partículas del gas se quedan dentro de la caja
    for (var i = 0; i < 27; i++) {
      final p = SimEstados3DState.posEn(EstadoMateria.gas, i, i * 1.37);
      expect([p.x.abs(), p.y.abs(), p.z.abs()].every((v) => v < 0.9), isTrue);
    }
    expect(tester.takeException(), isNull);
  });

  test('Los 5 pasos 3D están en sus mundos y esos mundos tienen su propio fondo', () {
    bool tiene(TemaBio t, String id) => t.misiones.any((m) => m.pasos.any((p) => p.id == id));
    expect(tiene(fisTema5, 'f5_m1_3d'), isTrue);
    expect(tiene(quiTema2, 'q2_m1_3d'), isTrue);
    expect(fisTema5.estilo, isA<EstiloMundo>());
    expect(quiTema2.estilo, isA<EstiloMundo>());
  });
}
