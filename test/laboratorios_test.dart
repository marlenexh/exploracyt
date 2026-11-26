import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/laboratorios.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/laboratorio_bio.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart' show temaJuego;
import 'package:explora_ciencia/presentation/electronica/circuito.dart';
import 'package:explora_ciencia/presentation/electronica/electronica_screen.dart';
import 'package:explora_ciencia/presentation/electronica/laboratorio_ele.dart';
import 'package:explora_ciencia/presentation/electronica/taller.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';
import 'package:explora_ciencia/presentation/fisica/laboratorio_fis.dart';
import 'package:explora_ciencia/presentation/quimica/laboratorio_qui.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';

import 'mundo_temas_util.dart';

Widget _app(Widget w) => MaterialApp(home: Theme(data: temaJuego(), child: w));

Future<void> _tocar(WidgetTester t, String tooltip) async {
  await t.tap(find.byTooltip(tooltip).first);
  await t.pump();
}

/// Arma un circuito con cables y revisa una condición.
EstadoCircuito _circuito(RetoCircuito r, List<(String, String)> cables, {void Function(Map<String, Pieza>)? ajustar, double luz = 1}) {
  final piezas = r.piezas();
  final mapa = {for (final p in piezas) p.id: p};
  ajustar?.call(mapa);
  final cs = [for (final (a, b) in cables) Cable(a, b)];
  return EstadoCircuito(mapa, cs, resolverCircuito(piezas, cs, luz: luz), luz: luz);
}

void main() {
  setUpAll(fuentes);

  test('Los laboratorios tienen nombre de insignia', () {
    for (final l in laboratoriosMundos.values) {
      expect(nombreRecompensa(l.badgeId), l.insignia);
    }
    expect(laboratoriosMundos.keys.toSet(), {'bio', 'qui', 'fis', 'ele'});
  });

  group('Biología', () {
    test('Solo un ecosistema completo y proporcionado se mantiene en equilibrio', () {
      expect(simularTerrario(sol: true, agua: true, n: [9, 3, 1, 2]).equilibrado, isTrue);
      final casos = {
        'sin sol': simularTerrario(sol: false, agua: true, n: [9, 3, 1, 2]),
        'sin plantas': simularTerrario(sol: true, agua: true, n: [0, 3, 1, 2]),
        'muchos zorros': simularTerrario(sol: true, agua: true, n: [12, 3, 2, 2]),
        'pocas plantas': simularTerrario(sol: true, agua: true, n: [5, 3, 1, 2]),
        'sin zorros': simularTerrario(sol: true, agua: true, n: [9, 3, 0, 2]),
        'sin hongos': simularTerrario(sol: true, agua: true, n: [9, 3, 1, 0]),
      };
      for (final MapEntry(:key, :value) in casos.entries) {
        expect(value.equilibrado, isFalse, reason: key);
        expect(value.serie.every((s) => s.length == 31), isTrue);
      }
      // Sin zorros, los conejos primero aumentan y luego desaparecen
      final s = casos['sin zorros']!.serie[1];
      expect(s[18], greaterThan(s[0]));
      expect(s[30], 0);
    });

    testWidgets('Se arma el terrario, se corrige y se termina', (tester) async {
      pantalla(tester, const Size(844, 390));
      var fin = 0;
      await tester.pumpWidget(_app(LaboratorioBio(onTerminar: (e) => fin = e)));
      await cuadros(tester, 3);
      final st = tester.state<LaboratorioBioState>(find.byType(LaboratorioBio));
      await _tocar(tester, 'Sol');
      await _tocar(tester, 'Agua');
      for (final (k, veces) in [(0, 9), (1, 3), (3, 2)]) {
        for (var i = 0; i < veces; i++) {
          await _tocar(tester, 'Agregar ${especiesTerrario[k].$2}');
        }
      }
      // Primero sin zorros: los conejos se comen todo
      await _tocar(tester, 'Simular 30 días');
      await cuadros(tester, 35, 100);
      expect(st.exito, isFalse);
      expect(st.mensaje, contains('depredadores'));
      await _tocar(tester, 'Cambiar el terrario');
      await _tocar(tester, 'Agregar Zorros');
      await _tocar(tester, 'Simular 30 días');
      await cuadros(tester, 35, 100);
      expect(st.exito, isTrue);
      await tester.tap(find.text('¡Lo logré!'));
      await cuadros(tester, 12);
      await tester.tap(find.text('¡Genial!').first);
      await cuadros(tester, 6);
      expect(fin, 3);
      expect(tester.takeException(), isNull);
    });
  });

  group('Química', () {
    testWidgets('Se hacen los tres experimentos con el método científico', (tester) async {
      pantalla(tester, const Size(844, 390));
      var fin = 0;
      await tester.pumpWidget(_app(LaboratorioQui(onTerminar: (e) => fin = e)));
      await cuadros(tester, 3);
      final st = tester.state<LaboratorioQuiState>(find.byType(LaboratorioQui));
      // Equipo: primero con sandalias (error) y luego bien
      for (final i in [0, 1, 2, 3, 4]) {
        await _tocar(tester, equipoSeguridad[i].$2);
      }
      await _tocar(tester, 'Comprobar equipo');
      expect(st.equipado, isFalse);
      expect(st.mensaje, contains('Sandalias'));
      await _tocar(tester, equipoSeguridad[4].$2);
      await _tocar(tester, 'Comprobar equipo');
      expect(st.equipado, isTrue);
      for (var x = 0; x < experimentosQui.length; x++) {
        final e = experimentosQui[x];
        await _tocar(tester, 'Experimento ${e.titulo}');
        await _tocar(tester, 'Hipótesis 1');
        for (final i in e.correctos) {
          await _tocar(tester, 'Material ${e.estante[i].$2}');
        }
        await _tocar(tester, 'Materiales listos');
        expect(st.paso, 2, reason: e.titulo);
        for (var k = 0; k < e.medidas.length; k++) {
          st.medir(k, (e.medidas[k].$5 + e.medidas[k].$6) / 2);
        }
        await _tocar(tester, 'Medidas listas');
        expect(st.paso, 3, reason: e.titulo);
        await _tocar(tester, 'Experimentar');
        await cuadros(tester, 50, 60);
        expect(st.paso, 4);
        await _tocar(tester, 'Observación ${e.observacionCorrecta + 1}');
        await _tocar(tester, e.permanente ? 'Cambio permanente' : 'Cambio temporal');
        expect(st.conclusionLista, isTrue);
        await _tocar(tester, 'Guardar en la bitácora');
      }
      expect(st.terminado, isTrue);
      await tester.tap(find.text('Publicar bitácora'));
      await cuadros(tester, 12);
      await tester.tap(find.text('¡Genial!').first);
      await cuadros(tester, 6);
      expect(fin, 3);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Medir mal o elegir materiales de más avisa', (tester) async {
      pantalla(tester, const Size(844, 390));
      await tester.pumpWidget(_app(LaboratorioQui(onTerminar: (_) {})));
      await cuadros(tester, 3);
      final st = tester.state<LaboratorioQuiState>(find.byType(LaboratorioQui));
      for (final i in [0, 1, 2, 3]) {
        st.alternarEquipo(i);
      }
      st.comprobarEquipo();
      st.elegirExperimento(0);
      st.elegirHipotesis(0);
      st.alternarMaterial(2); // hielo
      st.confirmarMateriales();
      expect(st.paso, 1);
      expect(st.mensaje, contains('Hielo'));
      st.alternarMaterial(2);
      for (final i in experimentosQui[0].correctos) {
        st.alternarMaterial(i);
      }
      st.confirmarMateriales();
      st.medir(0, 5);
      st.confirmarMedidas();
      expect(st.paso, 2);
      expect(st.mensaje, contains('entre'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  group('Física', () {
    test('La trayectoria respeta la gravedad de cada lugar', () {
      final tierra = calcularTiro(25, 45, misionesLanzamiento[0]);
      expect(tierra.alcance, closeTo(63.8, 0.2));
      final luna = calcularTiro(25, 45, misionesLanzamiento[1]);
      expect(luna.alcance, greaterThan(tierra.alcance * 5));
      expect(calcularTiro(25, 20, misionesLanzamiento[2]).chocoMuro, isTrue);
      final marte = calcularTiro(17, 50, misionesLanzamiento[2]);
      expect(marte.chocoMuro, isFalse);
      expect((marte.alcance - 75).abs(), lessThanOrEqualTo(5));
    });

    testWidgets('Se cumplen las tres misiones de lanzamiento', (tester) async {
      pantalla(tester, const Size(844, 390));
      var fin = 0;
      await tester.pumpWidget(_app(LaboratorioFis(onTerminar: (e) => fin = e)));
      await cuadros(tester, 3);
      final st = tester.state<LaboratorioFisState>(find.byType(LaboratorioFis));
      // Un tiro corto primero
      st.fijar(f: 10, a: 45);
      await _tocar(tester, 'Lanzar');
      await cuadros(tester, 45, 30);
      expect(st.acerto, isFalse);
      expect(st.mensaje, contains('faltaron'));
      for (final (f, a) in [(25.0, 45.0), (12.0, 45.0), (17.0, 50.0)]) {
        st.fijar(f: f, a: a);
        await _tocar(tester, 'Lanzar');
        await cuadros(tester, 45, 30);
        expect(st.acerto, isTrue, reason: '${st.m.lugar}: ${st.tiro!.alcance}');
        if (!st.terminado) await _tocar(tester, 'Siguiente misión');
      }
      await tester.tap(find.text('Terminar'));
      await cuadros(tester, 12);
      await tester.tap(find.text('¡Genial!').first);
      await cuadros(tester, 6);
      expect(fin, 3);
      expect(tester.takeException(), isNull);
    });
  });

  group('Electrónica', () {
    test('Cada proyecto de la casa inteligente se puede armar', () {
      final r = retosCasaInteligente;
      // 1. Dos focos en paralelo con un interruptor
      const luces = [('pila.0', 'sw.0'), ('sw.1', 'f1.0'), ('sw.1', 'f2.0'), ('f1.1', 'pila.1'), ('f2.1', 'pila.1')];
      expect(r[0].condiciones[0].cumple(_circuito(r[0], luces, ajustar: (m) => m['sw']!.cerrado = true)), isTrue);
      expect(r[0].condiciones[1].cumple(_circuito(r[0], luces, ajustar: (m) => m['sw']!.cerrado = false)), isTrue);
      // 2. Timbre con luz
      const timbre = [('pila.0', 'b.0'), ('b.1', 'z.0'), ('z.1', 'pila.1'), ('b.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')];
      expect(r[1].condiciones[0].cumple(_circuito(r[1], timbre, ajustar: (m) => m['b']!.presionado = true)), isTrue);
      expect(r[1].condiciones[1].cumple(_circuito(r[1], timbre)), isTrue);
      // 3. Sensor de luz
      const sensor = [('pila.0', 'ldr.0'), ('ldr.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')];
      expect(r[2].condiciones[0].cumple(_circuito(r[2], sensor, luz: 1)), isTrue);
      expect(r[2].condiciones[1].cumple(_circuito(r[2], sensor, luz: 0)), isTrue);
      // 4. Ventilador con potenciómetro
      const ventilador = [('pila.0', 'sw.0'), ('sw.1', 'pot.0'), ('pot.1', 'm.0'), ('m.1', 'pila.1')];
      expect(
          r[3].condiciones[0].cumple(_circuito(r[3], ventilador, ajustar: (m) {
                m['sw']!.cerrado = true;
                m['pot']!.posicion = 0;
              })),
          isTrue);
      final lento = [
        for (final p in [0.5, 0.6, 0.7, 0.8, 0.9])
          r[3].condiciones[1].cumple(_circuito(r[3], ventilador, ajustar: (m) {
                m['sw']!.cerrado = true;
                m['pot']!.posicion = p;
              }))
      ];
      expect(lento, contains(true));
    });

    testWidgets('El laboratorio del inventor abre el taller', (tester) async {
      pantalla(tester, const Size(844, 390));
      await tester.pumpWidget(_app(LaboratorioEle(onTerminar: (_) {})));
      await cuadros(tester, 4);
      expect(find.byType(TallerCircuitos), findsOneWidget);
      expect(find.textContaining('Reto 1 de 4'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('Los mapas muestran su laboratorio', (tester) async {
    for (final (w, mapa) in [
      ('qui', (m) => QuimicaScreen(mundo: m)),
      ('fis', (m) => FisicaScreen(mundo: m)),
      ('ele', (m) => ElectronicaScreen(mundo: m)),
    ]) {
      final m = mundos.firstWhere((x) => x.id == w);
      for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800)]) {
        pantalla(tester, s);
        await tester.pumpWidget(MaterialApp(home: mapa(m)));
        await cuadros(tester, 4);
        final titulo = laboratoriosMundos[w]!.titulo;
        if (s.width < 720) await tester.scrollUntilVisible(find.textContaining(titulo), 200, scrollable: find.byType(Scrollable).first);
        expect(find.textContaining(titulo), findsOneWidget, reason: '$w $s');
        expect(tester.takeException(), isNull, reason: '$w $s');
      }
    }
  });
}
