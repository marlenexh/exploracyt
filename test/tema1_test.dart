import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/videos/video_youtube.dart';
import 'package:explora_ciencia/presentation/biology/tema1/aventura.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/juego.dart';
import 'package:explora_ciencia/presentation/biology/tema1/contenido.dart';
import 'package:explora_ciencia/presentation/biology/tema1/laboratorio.dart';
import 'package:explora_ciencia/presentation/biology/tema1/mision1.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart';
import 'package:explora_ciencia/presentation/biology/tema1/pantalla_3d.dart';
import 'package:explora_ciencia/presentation/biology/tema1/pantalla_recorrido.dart';
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/biology/tema1/retos.dart';

Widget _envolver(Widget w, {ProgresoJuego? progreso}) => MaterialApp(
      home: ConfiguracionJuego(
        desbloquearTodo: false,
        child: ProgresoScope(
          progreso: progreso ?? ProgresoJuego(),
          child: Theme(
            data: temaJuego(),
            child: FondoAnimado(color: ColoresJuego.primario, child: w),
          ),
        ),
      ),
    );

/// Teléfono en horizontal (como en los bocetos).
void _telefono(WidgetTester tester, {Size tam = const Size(844, 390)}) {
  tester.view.physicalSize = tam * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

Future<void> _cuadros(WidgetTester tester, int n, [int ms = 100]) async {
  for (var f = 0; f < n; f++) {
    await tester.pump(Duration(milliseconds: ms));
  }
}

Future<void> _recorrerCapitulo(WidgetTester tester, CapituloTour cap) async {
  await tester.pumpWidget(_envolver(PantallaRecorrido(capitulo: cap)));
  for (var i = 0; i < cap.escenas.length; i++) {
    await _cuadros(tester, 15);
    final e = cap.escenas[i];
    final ultima = i == cap.escenas.length - 1;
    await tester.tap(find.byTooltip(ultima ? 'Terminar' : 'Siguiente'));
    await _cuadros(tester, 8);
    if (e.pregunta != null) {
      await tester.tap(
        find.text(e.pregunta!.opciones[e.pregunta!.correcta]).last,
      );
      await _cuadros(tester, 8);
      await tester.tap(find.text('Continuar'));
      await _cuadros(tester, 8);
    }
  }
  // Celebración final
  expect(find.text('¡Genial!'), findsOneWidget);
  await tester.tap(find.text('¡Genial!'));
  await _cuadros(tester, 10);
}

Future<void> _cargarFuentes() async {
  final fredoka = FontLoader('Fredoka');
  fredoka.addFont(Future.value(ByteData.sublistView(
      File('assets/fonts/Fredoka.ttf').readAsBytesSync())));
  await fredoka.load();
}

/// Una parte del dibujo: por su nombre, o la etiqueta “¿?” que la oculta.
Finder _parte(String t) => find.byWidgetPredicate((w) => (w is Text && w.data == t) || (w is Semantics && w.properties.label == 'Descubre: $t')).first;

void main() {
  setUpAll(_cargarFuentes);
  testWidgets('Intro del tema → menú de misiones', (tester) async {
    _telefono(tester);
    await tester.pumpWidget(
        const MaterialApp(home: CuerpoHumanoJuego(horizontal: false)));
    await _cuadros(tester, 30);
    expect(find.text('Misión del tema'), findsOneWidget);
    await tester.tap(find.text('Comenzar'));
    await _cuadros(tester, 20);
    for (final t in [
      'Misión 1',
      'Misión 2',
      'Misión 3',
      'Actividad Integradora',
    ]) {
      expect(find.text(t), findsOneWidget);
    }
    // La misión 2 está bloqueada al principio.
    await tester.tap(find.text('Misión 2'));
    await _cuadros(tester, 8);
    expect(find.textContaining('Primero completa'), findsOneWidget);
  });

  testWidgets('La misión 1 empieza con “¿Qué es el cuerpo humano?”', (
    tester,
  ) async {
    _telefono(tester);
    await tester.pumpWidget(_envolver(const PantallaMisiones()));
    await _cuadros(tester, 20);
    await tester.tap(find.text('Misión 1'));
    await _cuadros(tester, 20);
    expect(find.text('¿Qué es el cuerpo humano?'), findsWidgets);
  });

  test('Las misiones se desbloquean en orden', () {
    final p = ProgresoJuego();
    expect(misionDesbloqueada(p, 1), isFalse);
    for (final paso in misionesTema1[0].pasos) {
      p.registrar(paso.actividad, 2);
    }
    expect(misionesTema1[0].completa(p), isTrue);
    expect(misionDesbloqueada(p, 1), isTrue);
    expect(misionDesbloqueada(p, 2), isFalse);
  });

  test('Solo hay una insignia y se gana al completar todo el Tema 1', () {
    final p = ProgresoJuego();
    expect(p.registrar(Actividades.labPulso, 2), isTrue);
    expect(p.registrar(Actividades.labPulso, 1), isFalse);
    expect(insigniasJuego.length, 1);
    final todas = Actividades.todas;
    for (final a in todas.take(todas.length - 1)) {
      p.registrar(a, 2);
    }
    expect(p.insignias, isEmpty);
    p.registrar(todas.last, 3);
    expect(p.insignias, {'explorador_cuerpo_humano'});
    final copia = ProgresoJuego.fromJson(p.toJson());
    expect(copia.totalEstrellas, p.totalEstrellas);
  });

  test('Las actividades del tema son exactamente los pasos de las misiones',
      () {
    final pasos = [
      for (final m in misionesTema1)
        for (final x in m.pasos) x.actividad
    ];
    expect(pasos, Actividades.todas);
  });

  for (final tam in [const Size(844, 390), const Size(1180, 820)]) {
    for (final cap in capitulosTour) {
      testWidgets(
        'Recorrido ${cap.titulo} en ${tam.width.toInt()}×${tam.height.toInt()}',
        (tester) async {
          _telefono(tester, tam: tam);
          await _recorrerCapitulo(tester, cap);
        },
      );
    }
  }

  for (var i = 0; i < misionesTema1.length; i++) {
    testWidgets('Pantalla de la misión ${i + 1}', (tester) async {
      _telefono(tester);
      await tester.pumpWidget(
        _envolver(PantallaMision(mision: misionesTema1[i])),
      );
      await _cuadros(tester, 20);
      expect(find.text(misionesTema1[i].pasos.first.titulo), findsOneWidget);
    });
  }

  for (var i = 0; i < 4; i++) {
    testWidgets('Simulación 3D #$i', (tester) async {
      _telefono(tester);
      await tester.pumpWidget(
        _envolver(PantallaSimulacion3D(inicial: i, soloModelo: i.isEven)),
      );
      await _cuadros(tester, 15);
      await tester.tapAt(const Offset(260, 220));
      await _cuadros(tester, 3);
    });
  }

  final pantallas = <String, Widget>{
    'LabPulso': const LabPulso(),
    'LabPulmon': const LabPulmon(),
    'LabMicroscopio': const LabMicroscopio(),
    'LabVacunas': const LabVacunas(),
    'RetoQuiz': const RetoQuiz(),
    'RetoArma': const RetoArmaCuerpo(),
    'RetoRuta sangre': const RetoRuta(nivel: 0),
    'RetoRuta aire': const RetoRuta(nivel: 1),
    'RetoDefensa': const RetoDefensa(),
    'Logros': const PantallaLogrosAventura(),
  };
  pantallas.forEach((nombre, w) {
    testWidgets('Pantalla $nombre', (tester) async {
      _telefono(tester);
      await tester.pumpWidget(_envolver(w));
      await _cuadros(tester, 10);
      await tester.pumpWidget(const SizedBox());
    });
  });

  testWidgets('Defensa inmune se puede jugar', (tester) async {
    _telefono(tester);
    await tester.pumpWidget(_envolver(const RetoDefensa()));
    await tester.tap(find.text('¡A defender!'));
    for (var f = 0; f < 60; f++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (f % 5 == 0) await tester.tapAt(const Offset(422, 220));
    }
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('La celebración con confeti e insignia se muestra', (
    tester,
  ) async {
    _telefono(tester);
    await tester.pumpWidget(
      _envolver(
        Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => mostrarCelebracion(
                context,
                titulo: '¡Muy bien!',
                mensaje: 'Prueba',
                estrellas: 3,
                insignias: [insigniasJuego.first],
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await _cuadros(tester, 20);
    expect(find.text('¡Genial!'), findsOneWidget);
    await tester.tap(find.text('¡Genial!'));
    await _cuadros(tester, 12);
    expect(find.text('¡Genial!'), findsNothing);
  });

  // ---------------------------------------------------------------------
  // Misión 1: pantallas según los bocetos
  // ---------------------------------------------------------------------

  Future<void> cerrarCelebracion(WidgetTester tester) async {
    await _cuadros(tester, 12);
    expect(find.text('¡Genial!'), findsOneWidget);
    await tester.tap(find.text('¡Genial!'));
    await _cuadros(tester, 10);
  }

  for (final tam in [const Size(844, 390), const Size(1180, 820)]) {
    final n = '${tam.width.toInt()}×${tam.height.toInt()}';

    testWidgets('Cuerpo humano ($n)', (tester) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(_envolver(const PantallaCuerpoHumano()));
      await _cuadros(tester, 10);
      for (final t in [
        '¿Para qué sirve?',
        '¿Cómo funciona?',
        'En la vida diaria',
      ]) {
        await tester.tap(find.text(t));
        await _cuadros(tester, 5);
      }
      await tester.tap(_parte('Nariz'));
      await _cuadros(tester, 8);
      await tester.tap(find.text('¡Entendido!'));
      await _cuadros(tester, 8);
      await tester.tap(find.byTooltip('Siguiente'));
      await cerrarCelebracion(tester);
    });

    testWidgets('Sistema circulatorio ($n)', (tester) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(
        _envolver(const PantallaCirculatorioExplicacion()),
      );
      await _cuadros(tester, 10);
      for (final t in [
        '¿Para qué sirve?',
        '¿Cómo funciona?',
        'En la vida diaria',
      ]) {
        await tester.tap(find.text(t));
        await _cuadros(tester, 5);
      }
      await tester.tap(find.byTooltip('Siguiente'));
      await cerrarCelebracion(tester);
    });

    testWidgets('Vasos sanguíneos ($n)', (tester) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(_envolver(const PantallaVasosSanguineos()));
      await _cuadros(tester, 50);
      await tester.tap(_parte('Capilares'));
      await _cuadros(tester, 8);
      await tester.tap(find.text('¡Entendido!'));
      await _cuadros(tester, 8);
      await tester.tap(find.byTooltip('Siguiente'));
      await cerrarCelebracion(tester);
    });

    testWidgets('Viaje de la sangre ($n)', (tester) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(_envolver(const PantallaViajeSangre()));
      await _cuadros(tester, 5);
      // El viaje se ve paso a paso (4 pasos)
      for (var k = 0; k < 4; k++) {
        await tester.tap(find.byTooltip('Siguiente paso del viaje'));
        await _cuadros(tester, 40);
      }
      await tester.tap(find.byTooltip('Siguiente'));
      await cerrarCelebracion(tester);
    });

    testWidgets('Video complementario con carátula y Continuar con mi aventura ($n)', (
      tester,
    ) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(_envolver(const PantallaVideoTema()));
      await _cuadros(tester, 10);
      // Video complementario: carátula con Reproducir y siempre se puede seguir
      expect(find.textContaining('¿Te quedaron dudas?'), findsOneWidget);
      expect(find.byType(PortadaYoutube), findsOneWidget);
      await tester.tap(find.byTooltip('Continuar con mi aventura'));
      await cerrarCelebracion(tester);
    });

    testWidgets('Simulación 3D: partes del corazón ($n)', (tester) async {
      _telefono(tester, tam: tam);
      await tester.pumpWidget(_envolver(const PantallaSim3DCorazon()));
      await _cuadros(tester, 10);
      await tester.tap(find.byTooltip('Nombres'));
      await _cuadros(tester, 3);
      await tester.drag(find.byType(Slider), const Offset(120, 0));
      await _cuadros(tester, 5);
      expect(find.textContaining('Partes descubiertas'), findsOneWidget);
    });

    testWidgets('Laboratorio de frecuencia cardiaca completo ($n)',
        (tester) async {
      _telefono(tester, tam: tam);
      final progreso = ProgresoJuego();
      await tester.pumpWidget(
          _envolver(const PantallaLabFrecuencia(), progreso: progreso));
      await _cuadros(tester, 10);
      await tester.tap(find.text('Va a aumentar'));
      await _cuadros(tester, 3);
      await tester.tap(find.text('¡A experimentar!'));
      await _cuadros(tester, 5);
      await tester.tap(find.textContaining('usar un ejemplo'));
      await _cuadros(tester, 3);
      await tester.tap(find.text('Guardar y seguir'));
      await _cuadros(tester, 3);
      await tester.tap(find.text('Ya me moví, continuar'));
      await _cuadros(tester, 3);
      await tester.tap(find.textContaining('usar un ejemplo'));
      await _cuadros(tester, 3);
      await tester.tap(find.text('Guardar y seguir'));
      await _cuadros(tester, 5);
      expect(find.textContaining('Tu frecuencia subió de 84 a 128'),
          findsOneWidget);
      await tester.tap(find.text('Sacar conclusión'));
      await _cuadros(tester, 5);
      await tester.tap(
          find.textContaining('Porque los músculos necesitan más oxígeno'));
      await _cuadros(tester, 5);
      await tester.tap(find.byTooltip('Terminar'));
      await cerrarCelebracion(tester);
      expect(progreso.estrellasDe(Actividades.m1Lab), 3);
    });

    testWidgets('Mini misión: unir y responder ($n)', (tester) async {
      _telefono(tester, tam: tam);
      final progreso = ProgresoJuego();
      await tester.pumpWidget(
        _envolver(const PantallaMiniMisionCirculatorio(), progreso: progreso),
      );
      await _cuadros(tester, 10);
      // Primero un intento equivocado
      for (final nombre in ['Corazón', 'Venas', 'Arterias', 'Capilares']) {
        await tester.dragFrom(
          tester.getCenter(find.text(nombre)),
          tester.getCenter(find.text('?').first) -
              tester.getCenter(find.text(nombre)),
        );
        await _cuadros(tester, 3);
      }
      await tester.tap(find.byTooltip('Comprobar'));
      await _cuadros(tester, 15);
      // Coloca las que regresaron en el orden correcto: venas, corazón, arterias, capilares
      for (final nombre in ['Venas', 'Corazón', 'Arterias', 'Capilares']) {
        final f = find.text(nombre);
        if (f.evaluate().isEmpty || find.text('?').evaluate().isEmpty) continue;
        final enTarjeta = f.last;
        await tester.dragFrom(
          tester.getCenter(enTarjeta),
          tester.getCenter(find.text('?').first) - tester.getCenter(enTarjeta),
        );
        await _cuadros(tester, 3);
      }
      await tester.tap(find.byTooltip('Comprobar'));
      await _cuadros(tester, 20);
      final correctas = [
        'Para bombear la sangre a todo el cuerpo',
        'Para llevar la sangre con oxígeno desde el corazón al cuerpo',
        'Para regresar la sangre al corazón',
        'Para entregar oxígeno y nutrientes a las células y recoger desechos',
      ];
      for (var i = 0; i < 4; i++) {
        await tester.tap(find.text(correctas[i]));
        await _cuadros(tester, 5);
        await tester.tap(
          find.text(i < 3 ? 'Siguiente pregunta' : 'Terminar mini misión'),
        );
        await _cuadros(tester, 8);
      }
      // Fase final: acciones saludables para el corazón
      for (final a in [
        'Hacer ejercicio o jugar activamente',
        'Comer frutas y verduras',
        'Tomar agua simple',
        'Dormir de 9 a 11 horas'
      ]) {
        await tester.tap(find.text(a));
        await _cuadros(tester, 2);
      }
      await tester.tap(find.byTooltip('Comprobar acciones'));
      await _cuadros(tester, 4);
      await tester.tap(find.byTooltip('Terminar'));
      await cerrarCelebracion(tester);
      expect(progreso.estrellasDe(Actividades.m1Mini), greaterThan(0));
    });
  }

  test('La misión 1 sigue el orden de los bocetos', () {
    expect(misionesTema1.first.pasos.map((x) => x.actividad).toList(), [
      Actividades.tourIntro,
      Actividades.m1Cuerpo,
      Actividades.m1Circulatorio,
      Actividades.m1Vasos,
      Actividades.m1Viaje,
      Actividades.m1Video,
      Actividades.m1Sim3d,
      Actividades.m1Lab,
      Actividades.m1Juego,
      Actividades.m1Mini,
    ]);
  });
}
