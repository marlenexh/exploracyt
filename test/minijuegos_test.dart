import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';
import 'package:explora_ciencia/presentation/minijuegos/base.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_aventura_final.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_electron.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_etiquetas.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_globulo.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_lanzamiento.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_moleculas.dart';
import 'package:explora_ciencia/presentation/minijuegos/juego_plataformas.dart';
import 'package:explora_ciencia/presentation/minijuegos/minijuegos.dart';

import 'mundo_temas_util.dart';

/// Juega [m] cuadro por cuadro (60 por segundo) con la estrategia [jugar].
void jugarHastaTerminar(ModeloJuego m, void Function() jugar, {double maxSegundos = 400}) {
  m.empezar();
  for (var t = 0.0; t < maxSegundos && !m.terminado; t += 1 / 60) {
    jugar();
    m.avanzar(1 / 60);
  }
}

/// Busca un jalón de la resortera que pegue en alguna caja.
Offset? jalonQuePega(ModeloLanzamiento m) {
  for (var dx = 10.0; dx <= 110; dx += 4) {
    for (var dy = -110.0; dy <= 110; dy += 4) {
      final v = ModeloLanzamiento.velocidadDe(origenLanzamiento - Offset(dx, dy));
      var p = origenLanzamiento, vel = v;
      for (var k = 0; k < 600; k++) {
        vel += Offset(0, m.g / 120);
        p += vel / 120;
        if (m.blancos.any((b) => (p - b).distance < 22)) return origenLanzamiento - Offset(dx, dy);
        if (p.dy > 312 || p.dx > 640) break;
      }
    }
  }
  return null;
}

void main() {
  setUpAll(fuentes);

  test('Lanza con gravedad: se pueden derribar todas las cajas en la Tierra, la Luna y Marte', () {
    final m = ModeloLanzamiento();
    jugarHastaTerminar(m, () {
      if (m.pelota == null && m.jugando) {
        final j = jalonQuePega(m);
        expect(j, isNotNull, reason: 'Hay una caja imposible en ${m.lugar.nombre}');
        m.apuntar(j!);
        m.soltar();
      }
    });
    expect(m.gano, isTrue);
    expect(m.puntos, 9);
    // En la Luna la misma fuerza llega más lejos que en la Tierra
    final tierra = ModeloLanzamiento()..nivel = 0;
    final luna = ModeloLanzamiento()..nivel = 1;
    const v = Offset(200, -200);
    expect(luna.trayectoria(v).last.dy, lessThan(tierra.trayectoria(v).last.dy));
  });

  test('Glóbulo blanco: atrapa 15 virus siguiendo al más cercano', () {
    final m = ModeloGlobulo();
    jugarHastaTerminar(m, () {
      final virus = m.bichos.where((b) => !b.anticuerpo).toList();
      if (virus.isNotEmpty) {
        virus.sort((a, b) => a.pos.dx.compareTo(b.pos.dx));
        m.moverA(virus.first.pos);
      }
    });
    expect(m.gano, isTrue);
    expect(m.puntos, ModeloGlobulo.meta);
  });

  test('Glóbulo blanco: si no te mueves, el cuerpo se enferma', () {
    final m = ModeloGlobulo();
    jugarHastaTerminar(m, () => m.moverA(const Offset(20, 290)));
    expect(m.gano, isFalse);
    expect(m.infeccion, ModeloGlobulo.infeccionMax);
  });

  test('Arma moléculas: atrapando solo los átomos que faltan se forman las 4 moléculas', () {
    final m = ModeloMoleculas();
    jugarHastaTerminar(m, () {
      final utiles = m.cayendo.where((a) => m.falta(a.tipo) > 0).toList()..sort((a, b) => b.pos.dy.compareTo(a.pos.dy));
      if (utiles.isNotEmpty) m.moverA(Offset(utiles.first.pos.dx, 0));
    });
    expect(m.gano, isTrue);
    expect(m.puntos, moleculas.length);
    // Atrapar un átomo que no se necesita cuenta como error
    final m2 = ModeloMoleculas()..empezar();
    m2.atrapar(Atomo.c, Offset.zero);
    expect(m2.errores, 1);
  });

  test('El viaje del electrón: cerrando interruptores y quitando cortos se enciende el foco 8 veces', () {
    final m = ModeloElectron();
    jugarHastaTerminar(m, () {
      for (final i in m.interruptores.where((i) => !i.cerrado).toList()) {
        m.tocar(i.pos);
      }
      final c = m.corto;
      if (c != null) m.tocar(Offset.lerp(c.a, c.b, 0.5)!);
    });
    expect(m.gano, isTrue);
    expect(m.errores, 0);
    // Sin hacer nada, el circuito se abre o hay cortocircuito
    final m2 = ModeloElectron();
    jugarHastaTerminar(m2, () {});
    expect(m2.gano, isFalse);
  });

  test('Etiqueta para entrenar: buenas etiquetas → buena IA; malas etiquetas → mala IA', () {
    final m = ModeloEtiquetas();
    jugarHastaTerminar(m, () {
      final o = m.enEscaner;
      if (o != null) m.etiquetar(o.esFruta);
    });
    expect(m.gano, isTrue);
    expect(m.calidad, 1);
    expect(m.prueba.length, pruebaIA.length);
    final mala = ModeloEtiquetas();
    jugarHastaTerminar(mala, () {
      final o = mala.enEscaner;
      if (o != null) mala.etiquetar(!o.esFruta);
    });
    expect(mala.gano, isFalse);
    expect(mala.calidad, 0);
  });

  test('Plataformas con bloques: cada nivel tiene solución y los errores se detectan', () {
    const soluciones = [
      [Bloque.caminar, Bloque.caminar, Bloque.saltar, Bloque.caminar, Bloque.caminar],
      [Bloque.caminar, Bloque.saltar, Bloque.caminar, Bloque.saltar, Bloque.caminar, Bloque.caminar],
      [Bloque.repetir, Bloque.saltar, Bloque.caminar, Bloque.caminar, Bloque.saltar, Bloque.caminar, Bloque.caminar],
    ];
    for (var k = 0; k < 3; k++) {
      final (c, fallo) = ModeloPlataformas.simular(nivelesPlataformas[k], soluciones[k]);
      expect(fallo, isFalse, reason: 'Nivel ${k + 1}');
      expect(c, nivelesPlataformas[k].meta, reason: 'Nivel ${k + 1}');
    }
    expect(ModeloPlataformas.simular(nivelesPlataformas[0], [Bloque.repetir, Bloque.caminar]).$2, isTrue, reason: 'Cae en el hoyo');
    final m = ModeloPlataformas();
    var nivel = -1;
    jugarHastaTerminar(m, () {
      if (!m.ejecutando && !m.cayendo && m.nivel != nivel) {
        nivel = m.nivel;
        soluciones[m.nivel].forEach(m.agregar);
        m.ejecutar();
      }
    });
    expect(m.gano, isTrue);
    expect(m.errores, 0);
  });

  test('Aventura final: Zati atrapa las 6 piezas de la brújula', () {
    final m = ModeloAventura();
    jugarHastaTerminar(m, () {
      m.inmune = 1; // en la prueba no nos preocupan las tormentas
      final piezas = m.cosas.where((c) => c.pieza != null);
      if (piezas.isNotEmpty) m.y = piezas.first.pos.dy;
    });
    expect(m.gano, isTrue);
    expect(m.siguientePieza, 6);
  });

  testWidgets('Las 7 pantallas de mini-juegos abren, se juegan y no fallan', (tester) async {
    final juegos = <String, Widget Function()>{
      'lanzamiento': () => juegoLanzamiento('x'),
      'globulo': () => juegoGlobulo('x'),
      'moleculas': () => juegoMoleculas('x'),
      'electron': () => juegoElectron('x'),
      'etiquetas': () => juegoEtiquetas('x'),
      'plataformas': () => juegoPlataformas('x'),
      'aventura': () => juegoAventuraFinal(onTerminar: (_) {}),
    };
    for (final s in const [Size(844, 390), Size(1280, 800)]) {
      pantalla(tester, s);
      for (final e in juegos.entries) {
        await tester.pumpWidget(MaterialApp(
          key: ValueKey('${e.key}$s'),
          builder: (_, child) =>
              ConfiguracionJuego(desbloquearTodo: true, child: ProgresoScope(progreso: ProgresoJuego(), child: Theme(data: temaJuego(), child: child!))),
          home: e.value(),
        ));
        await cuadros(tester, 3);
        await tester.tap(find.byTooltip('¡Jugar!'));
        await cuadros(tester, 10, 50);
        // Un toque y un arrastre en el área de juego
        final area = find.byKey(const ValueKey('area_minijuego'));
        await tester.tap(area);
        await tester.drag(area, const Offset(-60, 20));
        await cuadros(tester, 10, 50);
        expect(find.byTooltip('¡Jugar!'), findsNothing, reason: e.key);
        expect(tester.takeException(), isNull, reason: '${e.key} $s');
      }
    }
  });
}
