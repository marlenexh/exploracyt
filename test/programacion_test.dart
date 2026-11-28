import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/pro_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/escenario.dart' show BotonSiguiente;
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/programacion/cazaerrores.dart';
import 'package:explora_ciencia/presentation/programacion/estudio.dart';
import 'package:explora_ciencia/presentation/programacion/programacion_screen.dart';
import 'package:explora_ciencia/presentation/programacion/robot.dart';
import 'package:explora_ciencia/presentation/programacion/robot_ui.dart';

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
  for (final t in temasPro.values) {
    for (final m in t.misiones) {
      for (final p in m.pasos) {
        yield (t, p);
      }
    }
  }
}

/// Programa que resuelve cada nivel, por título.
final Map<String, List<Bloque> Function()> soluciones = {
  'Hasta la meta': () => [av(), av(), av(), av()],
  'Da la vuelta': () => [av(), av(), gd(), av(), av(), gi(), av()],
  'El camino': () => [av(), gd(), av(), av(), gi(), av()],
  'La gema': () => [av(), av(), rc(), av(), av()],
  'Bajando': () => [av(), gi(), av(), gd(), av(), av(), rc(), gi(), av()],
  'El tesoro': () => [av(), av(), gd(), av(), av(), gi(), av(), rc(), av()],
  'El pasillo': () => [av(), av(), av(), av(), gd(), av(), av(), gi(), av()],
  'Las tres gemas': () => [av(), rc(), av(), av(), rc(), gd(), av(), av(), gd(), av(), rc(), av(), av()],
  'La letra L': () => [av(), av(), av(), gi(), av(), av()],
  'La escalera': () => [av(), gd(), av(), gi(), av(), gd(), av(), gi(), av(), gd(), av()],
  'El cuadrado': () => [av(), av(), gd(), av(), av(), gd(), av(), av(), gd(), av(), av()],
  'Las piezas': () => [av(), av(), rc(), gd(), av(), av(), gd(), av(), rc(), av()],
  'El logo': () => [av(), av(), gd(), av(), av(), av(), gd(), gd(), av(), av(), av(), gd(), av(), av()],
  '¿Hay gema?': () => [
        rep(6, [
          av(),
          si(Cond.gema, [rc()])
        ])
      ],
  '¿Hay camino?': () => [
        rep(9, [
          siNo(Cond.camino, [av()], [gd()])
        ])
      ],
  'El pasillo largo': () => [
        rep(7, [av()])
      ],
  'Escalera de piedra': () => [
        rep(3, [av(), gd(), av(), gi()]),
        av(),
        av()
      ],
  'Cuadrado con repetir': () => [
        rep(4, [av(), av(), gd()])
      ],
  'Mientras no llegue': () => [
        mientras(Cond.noMeta, [av()])
      ],
  'Recolector automático': () => [
        mientras(Cond.noMeta, [
          av(),
          si(Cond.gema, [rc()])
        ])
      ],
  'El laberinto': () => [
        mientras(Cond.noMeta, [
          siNo(Cond.camino, [av()], [gd()])
        ])
      ],
  'El escape': () => [
        mientras(Cond.noMeta, [
          si(Cond.gema, [rc()]),
          siNo(Cond.camino, [av()], [gd()])
        ])
      ],
  'Falta un paso': () => [av(), av(), av(), av()],
  'El giro equivocado': () => [av(), gd(), av(), av(), gi(), av()],
  'La gema olvidada': () => [av(), av(), rc(), av(), av()],
  'El ciclo infinito': () => [
        mientras(Cond.noMeta, [av()])
      ],
  'Al cuadrado le falta un lado': () => [
        rep(4, [av(), av(), gd()])
      ],
};

void main() {
  setUpAll(_fuentes);

  test('Los 5 temas de Programación están completos', () {
    expect(temasPro.keys, [1, 2, 3, 4, 5]);
    for (final tema in temasPro.values) {
      expect(tema.id, 'pro-t${tema.numero}');
      expect(tema.misiones.length, 4);
      final ids = [for (final m in tema.misiones) for (final p in m.pasos) p.id];
      expect(ids.toSet().length, ids.length, reason: tema.titulo);
      for (final m in tema.misiones.take(3)) {
        expect(m.pasos.last.titulo, 'Pon a prueba lo que aprendiste', reason: m.subtitulo);
      }
      // Un solo video complementario por tema, al final de la misión 3.
      expect([for (var k = 0; k < 3; k++) tema.misiones[k].pasos.any((p) => p.tipo == TipoPasoBio.video)], [false, false, true], reason: tema.titulo);
      final info = proTopics[tema.numero]!;
      expect(info.missionIds, tema.idsMisiones);
      expect(info.missions, [for (final m in tema.misiones) m.subtitulo]);
      expect(info.badge, tema.insignia);
    }
  });

  test('Cada nivel del robot tiene solución y ninguna supera el límite de bloques', () {
    final titulos = <String>{};
    for (final (_, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! ProgramaRobot) continue;
      for (final n in w.niveles) {
        expect(titulos.add(n.titulo), isTrue, reason: 'Título repetido: ${n.titulo}');
        final sol = soluciones[n.titulo];
        expect(sol, isNotNull, reason: 'Falta solución: ${n.titulo}');
        expect(ejecutarRobot(n, sol!()).resultado, Resultado.exito, reason: n.titulo);
        if (n.inicial != null) expect(ejecutarRobot(n, n.inicial!()).resultado, isNot(Resultado.exito), reason: '${n.titulo} debe empezar con error');
      }
    }
    expect(titulos.toSet(), soluciones.keys.toSet());
  });

  test('El mapa registra temas, insignias y el laboratorio', () {
    final pro = mundos.firstWhere((m) => m.id == 'pro');
    expect(pro.temas.map((t) => t.titulo).toList(),
        ['Piensa como programador', 'Sigue las instrucciones', 'Programa con bloques', 'Repite y decide', 'Encuentra el error']);
    for (var n = 1; n <= 5; n++) {
      expect(pro.temas[n - 1].misiones.last.recompensa?.id, 'pro-t$n-integration-badge');
      expect(nombreRecompensa('pro-t$n-integration-badge'), proTopics[n]!.badge);
    }
    expect(nombreRecompensa(proLabBadgeId), 'Desarrollador de Videojuegos');
  });

  testWidgets('El mapa de Programación se ve en celular y computadora', (tester) async {
    final pro = mundos.firstWhere((m) => m.id == 'pro');
    for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800)]) {
      _pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(home: ProgramacionScreen(mundo: pro)));
      await _cuadros(tester, 4);
      if (s.width < 720) {
        await tester.scrollUntilVisible(find.textContaining('Laboratorio del programador'), 200, scrollable: find.byType(Scrollable).first);
      }
      expect(find.textContaining('Laboratorio del programador'), findsOneWidget);
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });

  for (final tema in temasPro.values) {
    testWidgets('Programación tema ${tema.numero}: intro → misiones', (tester) async {
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
      testWidgets('Programación tema ${tema.numero}: pantallas (${s.width.toInt()}×${s.height.toInt()})', (tester) async {
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

  testWidgets('Se arma un programa tocando bloques y el robot llega', (tester) async {
    _pantalla(tester, const Size(844, 390));
    final tema = temasPro[1]!;
    final paso = tema.misiones[2].pasos.firstWhere((p) => p.id == 'p1_m3_robot');
    final p = ProgresoJuego();
    await tester.pumpWidget(_lanzar(tema, paso.pantalla(paso.id), p));
    await _cuadros(tester, 6);
    for (var k = 0; k < 3; k++) {
      await tester.tap(find.byTooltip('Agregar avanzar'));
      await tester.pump();
    }
    await tester.tap(find.byTooltip('Ejecutar programa'));
    await _cuadros(tester, 8, 330);
    final st = tester.state<ProgramaRobotState>(find.byType(ProgramaRobot));
    expect(st.completo, isFalse);
    expect(st.errores, 1);
    await tester.tap(find.byTooltip('Agregar avanzar'));
    await tester.pump();
    await tester.tap(find.byTooltip('Ejecutar programa'));
    await _cuadros(tester, 8, 330);
    expect(st.completo, isTrue);
  });

  testWidgets('Se resuelven todos los niveles del robot', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var n = 0;
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! ProgramaRobot) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 6);
      for (final nivel in w.niveles) {
        final st = tester.state<ProgramaRobotState>(find.byType(ProgramaRobot));
        st.programa
          ..clear()
          ..addAll(soluciones[nivel.titulo]!());
        st.ejecutar();
        final pasos = ejecutarRobot(nivel, st.programa).pasos.length;
        await _cuadros(tester, pasos + 2, 330);
        expect(st.completo, isTrue, reason: nivel.titulo);
        n++;
        await tester.tap(find.byType(BotonSiguiente));
        await _cuadros(tester, 12);
      }
      expect(p.estrellasDe(paso.id), 3, reason: paso.titulo);
      if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
      await _cuadros(tester, 6);
      expect(tester.takeException(), isNull);
    }
    expect(n, soluciones.length);
  });

  testWidgets('Se cazan todos los bichos de los programas', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var n = 0;
    for (final (tema, paso) in _pasos()) {
      final w = paso.pantalla(paso.id);
      if (w is! CazaErrores) continue;
      final p = ProgresoJuego();
      await tester.pumpWidget(_lanzar(tema, KeyedSubtree(key: ValueKey(paso.id), child: w), p));
      await _cuadros(tester, 6);
      for (final prog in w.programas) {
        for (var i = 0; i < prog.lineas.length; i++) {
          final l = prog.lineas[i];
          if (!l.conError) continue;
          await tester.tap(find.byTooltip('Línea ${i + 1}'));
          await tester.pump();
          await tester.tap(find.text(l.opciones.first).last);
          await tester.pump();
        }
        n++;
        await tester.tap(find.byType(BotonSiguiente));
        await _cuadros(tester, 12);
      }
      expect(p.estrellasDe(paso.id), 3, reason: paso.titulo);
      if (find.text('¡Genial!').evaluate().isNotEmpty) await tester.tap(find.text('¡Genial!').first);
      await _cuadros(tester, 6);
    }
    expect(n, 6);
  });

  testWidgets('Laboratorio: el juego con bugs se detecta y el correcto se publica', (tester) async {
    _pantalla(tester, const Size(844, 390));
    var publicado = 0;
    await tester.pumpWidget(MaterialApp(
      home: Theme(data: temaJuego(), child: EstudioVideojuegos(onTerminar: (e) => publicado = e)),
    ));
    await _cuadros(tester, 4);
    final st = tester.state<EstudioVideojuegosState>(find.byType(EstudioVideojuegos));
    // Prueba con el programa vacío: tiene bugs
    await tester.tap(find.byTooltip('Probar juego'));
    await _cuadros(tester, 10);
    await tester.tap(find.byTooltip('Detener prueba'));
    await _cuadros(tester, 3);
    expect(st.probado, isTrue);
    expect(st.listo, isFalse);
    expect(find.byTooltip('Publicar juego'), findsNothing);
    // Programa cada bloque tocando las fichas
    Future<void> tocar(String t, int veces) async {
      for (var k = 0; k < veces; k++) {
        await tester.ensureVisible(find.byTooltip(t, skipOffstage: false));
        await tester.pump();
        await tester.tap(find.byTooltip(t));
        await tester.pump();
      }
    }

    await tocar('Bloque al empezar', 1);
    await tocar('Bloque flecha izquierda', 1);
    await tocar('Bloque flecha derecha', 1);
    await tocar('Bloque premio', 1);
    await tocar('Bloque peligro', 1);
    await tocar('Bloque meta', 1);
    await tocar('Bloque perder', 1);
    expect(st.config.izquierda, 0);
    expect(st.config.puntosMeta, 5);
    await tester.tap(find.byTooltip('Probar juego'));
    await _cuadros(tester, 20);
    // Mover con las flechas
    final g = await tester.startGesture(tester.getCenter(find.byTooltip('Flecha izquierda')));
    await _cuadros(tester, 6);
    await g.up();
    for (var k = 0; k < 5; k++) {
      st.tocar(true);
    }
    await _cuadros(tester, 3);
    expect(st.ganado, isTrue);
    expect(st.jugando, isFalse);
    expect(st.listo, isTrue);
    await tester.tap(find.byTooltip('Publicar juego'));
    await _cuadros(tester, 12);
    await tester.tap(find.text('¡Genial!').first);
    await _cuadros(tester, 6);
    expect(publicado, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
