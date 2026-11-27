import 'dart:io';

import 'package:explora_ciencia/presentation/videos/video_youtube.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/integradora.dart';
import 'package:explora_ciencia/presentation/biology/tema1/juego.dart';
import 'package:explora_ciencia/presentation/biology/tema1/juegos.dart';
import 'package:explora_ciencia/presentation/biology/tema1/mision1.dart';
import 'package:explora_ciencia/presentation/biology/tema1/mision2.dart';
import 'package:explora_ciencia/presentation/biology/tema1/mision3.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart';
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _cargarFuentes() async {
  final f = FontLoader('Fredoka')
    ..addFont(Future.value(ByteData.sublistView(
        File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await f.load();
}

Widget _envolver(Widget w, {ProgresoJuego? progreso}) => MaterialApp(
      home: ConfiguracionJuego(
        desbloquearTodo: false,
        nombreAlumno: 'Luz',
        child: ProgresoScope(
          progreso: progreso ?? ProgresoJuego(),
          child: Theme(data: temaJuego(), child: w),
        ),
      ),
    );

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

Future<void> _cerrarCelebracion(WidgetTester tester) async {
  await _cuadros(tester, 12);
  expect(find.text('¡Genial!'), findsOneWidget);
  await tester.tap(find.text('¡Genial!'));
  await _cuadros(tester, 10);
}

/// Arrastra la tarjeta [texto] (la de la bandeja) al primer recuadro vacío "?".
Future<void> _arrastrarAlPrimerHueco(WidgetTester tester, String texto) async {
  final origen = tester.getCenter(find.text(texto).last);
  final destino = tester.getCenter(find.text('?').first);
  await tester.dragFrom(origen, destino - origen);
  await _cuadros(tester, 3);
}

const _tamanos = [Size(844, 390), Size(1280, 800), Size(1920, 1080)];

void main() {
  setUpAll(_cargarFuentes);

  for (final tam in _tamanos) {
    final n = '${tam.width.toInt()}×${tam.height.toInt()}';

    testWidgets('M2 explicación con pestañas ($n)', (tester) async {
      _pantalla(tester, tam);
      await tester
          .pumpWidget(_envolver(const PantallaRespiratorioExplicacion()));
      await _cuadros(tester, 10);
      for (final t in [
        '¿Para qué sirve?',
        '¿Cómo funciona?',
        'En la vida diaria'
      ]) {
        await tester.tap(find.text(t));
        await _cuadros(tester, 4);
      }
      await tester.tap(find.text('Alvéolos'));
      await _cuadros(tester, 6);
      await tester.tap(find.text('¡Entendido!'));
      await _cuadros(tester, 6);
      await tester.tap(find.byTooltip('Siguiente'));
      await _cerrarCelebracion(tester);
    });

    testWidgets('M2 intercambio de gases ($n)', (tester) async {
      _pantalla(tester, tam);
      final p = ProgresoJuego();
      await tester
          .pumpWidget(_envolver(const PantallaIntercambioGases(), progreso: p));
      await _cuadros(tester, 5);
      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byTooltip('Adelante'));
        await _cuadros(tester, 3);
      }
      await tester.tap(
          find.text('Porque se mueven de donde hay más hacia donde hay menos'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Siguiente'));
      await _cerrarCelebracion(tester);
      expect(p.estrellasDe(Actividades.m2Intercambio), 3);
    });

    testWidgets('M2 cómo cambia tu respiración y ambiente ($n)',
        (tester) async {
      _pantalla(tester, tam);
      await tester.pumpWidget(_envolver(const PantallaComoCambiaRespiracion()));
      await _cuadros(tester, 5);
      for (final s in ['Dormir', 'Correr', 'Subir una montaña']) {
        await tester.tap(find.text(s).first);
        await _cuadros(tester, 3);
      }
      await tester.pumpWidget(_envolver(const PantallaAmbienteRespiracion()));
      await _cuadros(tester, 5);
      await tester.tap(find.text('Humo de cigarro'));
      await _cuadros(tester, 4);
      // La tarjeta se abre en grande: se responde y se cierra
      await tester.tap(find.textContaining('¡No lo sabía!'));
      await _cuadros(tester, 6);
      if (find.byTooltip('Cerrar').evaluate().isNotEmpty) await tester.tap(find.byTooltip('Cerrar'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Siguiente'));
      await _cerrarCelebracion(tester);
    });

    testWidgets('M2 laboratorio completo ($n)', (tester) async {
      _pantalla(tester, tam);
      final p = ProgresoJuego();
      await tester
          .pumpWidget(_envolver(const PantallaLabRespiracion(), progreso: p));
      await _cuadros(tester, 6);
      // 1. Arma el recorrido (los recuadros están numerados en orden)
      for (final x in [
        'Nariz',
        'Faringe',
        'Laringe',
        'Tráquea',
        'Bronquios',
        'Bronquiolos',
        'Alvéolos'
      ]) {
        await _arrastrarAlPrimerHueco(tester, x);
      }
      await tester.tap(find.byTooltip('Comprobar etiquetas'));
      await _cuadros(tester, 15);
      // 2. Simula 3 respiraciones
      for (var k = 0; k < 3; k++) {
        final g = await tester
            .startGesture(tester.getCenter(find.byTooltip('Inhalar')));
        await _cuadros(tester, 30, 50);
        await g.up();
        await _cuadros(tester, 34, 50);
      }
      expect(find.text('Respiraciones completas: 3/3'), findsOneWidget);
      await tester.tap(find.text('Siguiente experimento'));
      await _cuadros(tester, 4);
      // 3. Compara y analiza (con ejemplos)
      await tester.tap(find.textContaining('Usar un ejemplo'));
      await _cuadros(tester, 2);
      await tester.tap(find.text('Guardar'));
      await _cuadros(tester, 2);
      await tester.tap(find.text('Ya me moví'));
      await _cuadros(tester, 2);
      await tester.tap(find.textContaining('Usar un ejemplo'));
      await _cuadros(tester, 2);
      await tester.tap(find.text('Guardar'));
      await _cuadros(tester, 4);
      await tester.tap(find.textContaining('Porque tus músculos necesitaban'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Terminar'));
      await _cerrarCelebracion(tester);
      expect(p.estrellasDe(Actividades.m2Lab), 3);
    });

    testWidgets('M2 mini misión: nombrar, relacionar y cuidar ($n)',
        (tester) async {
      _pantalla(tester, tam);
      final p = ProgresoJuego();
      await tester.pumpWidget(
          _envolver(const PantallaMiniMisionRespiratorio(), progreso: p));
      await _cuadros(tester, 6);
      // Orden de los recuadros: nariz, faringe, laringe, tráquea, bronquios, pulmones, alvéolos, diafragma
      for (final x in [
        'Nariz',
        'Faringe',
        'Laringe',
        'Tráquea',
        'Bronquios',
        'Pulmones',
        'Alvéolos',
        'Diafragma'
      ]) {
        await _arrastrarAlPrimerHueco(tester, x);
      }
      await tester.tap(find.byTooltip('Comprobar etiquetas'));
      await _cuadros(tester, 15);
      const parejas = {
        'Nariz': 'Limpia, calienta y humedece el aire que entra.',
        'Laringe': 'Tiene las cuerdas vocales que producen la voz.',
        'Tráquea': 'Tubo con anillos que lleva el aire al pecho.',
        'Pulmones': 'Se llenan de aire; ahí el oxígeno pasa a la sangre.',
        'Diafragma': 'Músculo que baja al inhalar y sube al exhalar.',
      };
      for (final e in parejas.entries) {
        await tester.tap(find.text(e.key));
        await _cuadros(tester, 2);
        await tester.tap(find.text(e.value));
        await _cuadros(tester, 2);
      }
      await _cuadros(tester, 12);
      for (final a in [
        'Jugar al aire libre en lugares con árboles',
        'Alejarse del humo de cigarro',
        'Respirar por la nariz',
        'Taparse al toser o estornudar',
      ]) {
        await tester.tap(find.text(a));
        await _cuadros(tester, 2);
      }
      await tester.tap(find.byTooltip('Comprobar acciones'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Terminar'));
      await _cerrarCelebracion(tester);
      expect(p.estrellasDe(Actividades.m2Mini), 3);
    });

    testWidgets('M3 explicación, partes y hábitos ($n)', (tester) async {
      _pantalla(tester, tam);
      await tester.pumpWidget(_envolver(const PantallaInmuneExplicacion()));
      await _cuadros(tester, 6);
      for (final t in [
        '¿Para qué sirve?',
        '¿Cómo funciona?',
        'En la vida diaria'
      ]) {
        await tester.tap(find.text(t));
        await _cuadros(tester, 4);
      }
      await tester.pumpWidget(_envolver(const PantallaInmunePartes()));
      await _cuadros(tester, 6);
      await tester.tap(find.text('Médula ósea'));
      await _cuadros(tester, 6);
      await tester.tap(find.text('¡Entendido!'));
      await _cuadros(tester, 6);
      await tester.pumpWidget(_envolver(const PantallaHabitosDefensas()));
      await _cuadros(tester, 6);
      await tester.tap(find.text('Dormir poco'));
      await _cuadros(tester, 4);
      // La tarjeta se abre en grande: se responde y se cierra
      await tester.tap(find.textContaining('¡No lo sabía!'));
      await _cuadros(tester, 6);
      if (find.byTooltip('Cerrar').evaluate().isNotEmpty) await tester.tap(find.byTooltip('Cerrar'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Siguiente'));
      await _cerrarCelebracion(tester);
    });

    testWidgets('M3 rompecabezas ($n)', (tester) async {
      _pantalla(tester, tam);
      final p = ProgresoJuego();
      await tester
          .pumpWidget(_envolver(const PantallaMiniMisionInmune(), progreso: p));
      await _cuadros(tester, 6);
      const funciones = [
        'Barrera que impide la entrada de microbios.',
        'Atacan y se “comen” a los microbios.',
        'Marcan a los microbios para destruirlos.',
        'Filtran la linfa y reúnen a los defensores.',
        'Fabrica las células de la sangre.',
        'Entrenan al cuerpo para reconocer microbios.',
      ];
      for (var i = 0; i < funciones.length; i++) {
        final f = funciones[i];
        final origen = tester.getCenter(find.text(f));
        final destino = tester.getCenter(find.byKey(ValueKey('hueco_$i')));
        await tester.dragFrom(origen, destino - origen);
        await _cuadros(tester, 4);
      }
      await _cerrarCelebracion(tester);
      expect(p.estrellasDe(Actividades.m3Mini), 3);
    });

    testWidgets('Integradora: la excursión al cerro ($n)', (tester) async {
      _pantalla(tester, tam);
      final p = ProgresoJuego();
      await tester.pumpWidget(
          _envolver(const PantallaSituacionIntegradora(), progreso: p));
      await _cuadros(tester, 6);
      for (var i = 0; i < escenasExcursion.length; i++) {
        final e = escenasExcursion[i];
        await tester.tap(find.text(e.opciones[e.correcta]));
        await _cuadros(tester, 6);
        await tester.tap(find.byTooltip(
            i < escenasExcursion.length - 1 ? 'Siguiente escena' : 'Terminar'));
        await _cuadros(tester, 6);
      }
      await _cerrarCelebracion(tester);
      expect(p.estrellasDe(Actividades.intSituacion), 3);
    });

    testWidgets('Juegos de las misiones 1 y 2 ($n)', (tester) async {
      _pantalla(tester, tam);
      await tester.pumpWidget(_envolver(const JuegoRepartidorOxigeno()));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Jugar'));
      await _cuadros(tester, 4);
      final centro = tester.getCenter(find.byType(CustomPaint).first);
      await tester.dragFrom(centro, const Offset(-200, 0));
      await _cuadros(tester, 40, 50);
      await tester.pumpWidget(_envolver(const JuegoAtrapaAire()));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Jugar'));
      await _cuadros(tester, 40, 50);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Videos de las misiones 2 y 3 ($n)', (tester) async {
      _pantalla(tester, tam);
      final m2 =
          misionesTema1[1].pasos.firstWhere((x) => x.tipo == TipoPaso.video);
      final m3 =
          misionesTema1[2].pasos.firstWhere((x) => x.tipo == TipoPaso.video);
      for (final paso in [m2, m3]) {
        await tester.pumpWidget(_envolver(paso.pantalla()));
        await _cuadros(tester, 8);
        expect(find.byType(PortadaYoutube), findsOneWidget);
        expect(find.byTooltip('Continuar con mi aventura'), findsOneWidget);
      }
    });

    testWidgets('Insignia final del Tema 1 ($n)', (tester) async {
      _pantalla(tester, tam);
      await tester.pumpWidget(_envolver(const PantallaInsigniaFinal()));
      await _cuadros(tester, 15);
      expect(find.text('Explorador del Cuerpo Humano'), findsOneWidget);
      expect(find.textContaining('Luz'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Cada misión tiene video y una mini misión al final',
      (tester) async {
    for (final m in misionesTema1.take(3)) {
      expect(m.pasos.where((x) => x.tipo == TipoPaso.video), isNotEmpty,
          reason: m.titulo);
      expect(m.pasos.last.titulo, 'Pon a prueba lo que aprendiste');
    }
  });

  for (final tam in [
    const Size(390, 844),
    const Size(360, 740),
    const Size(800, 1280)
  ]) {
    testWidgets(
        'En pantalla vertical el juego se gira (${tam.width.toInt()}×${tam.height.toInt()})',
        (tester) async {
      _pantalla(tester, tam);
      await tester.pumpWidget(
          const MaterialApp(home: CuerpoHumanoJuego(horizontal: false)));
      await _cuadros(tester, 20);
      expect(find.text('Misión del tema'), findsOneWidget);
      final giro = tester.widget<RotatedBox>(find.byType(RotatedBox).first);
      expect(giro.quarterTurns, 1);
      await tester.tap(find.text('Comenzar'));
      await _cuadros(tester, 20);
      expect(find.text('Misión 1'), findsOneWidget);
      await tester.tap(find.text('Misión 1'));
      await _cuadros(tester, 20);
      expect(find.text('¿Qué es el cuerpo humano?'), findsWidgets);
      // Abre y cierra una ventana dentro del juego girado
      await tester.tap(find.byTooltip('Siguiente'));
      await _cuadros(tester, 10);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Pantalla de la simulación del corazón se abre en la misión 1',
      (tester) async {
    _pantalla(tester, const Size(844, 390));
    final paso = misionesTema1.first.pasos
        .firstWhere((x) => x.actividad == Actividades.m1Sim3d);
    expect(paso.tipo, TipoPaso.sim3d);
    await tester.pumpWidget(_envolver(paso.pantalla()));
    await _cuadros(tester, 6);
    expect(find.byType(PantallaSim3DCorazon), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
