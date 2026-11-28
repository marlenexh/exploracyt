import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/ia_topics.dart';
import 'package:explora_ciencia/data/worlds.dart';
import 'package:explora_ciencia/presentation/biology/tema1/comunes.dart' show temaJuego;
import 'package:explora_ciencia/presentation/ia/ia_screen.dart';
import 'package:explora_ciencia/presentation/ia/laboratorio_ia.dart';
import 'package:explora_ciencia/presentation/ia/proyectos_ia.dart';
import 'package:explora_ciencia/presentation/ia/sims_ia.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  probarMundo(
    w: 'ia',
    nombre: 'Inteligencia Artificial',
    temas: temasIA,
    infos: iaTopics,
    titulos: const ['Máquinas inteligentes', 'Encuentra el patrón', 'Enseña a una máquina', 'Inteligencia en acción', 'Usa la IA con cuidado'],
    mapa: (m) => InteligenciaArtificialScreen(mundo: m),
  );

  test('La insignia del laboratorio de IA tiene nombre', () {
    expect(nombreRecompensa(iaLabBadgeId), 'Ingeniero de IA');
  });

  testWidgets('El mapa de IA muestra el laboratorio', (tester) async {
    final m = mundos.firstWhere((x) => x.id == 'ia');
    for (final s in const [Size(390, 844), Size(844, 390), Size(1280, 800)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(home: InteligenciaArtificialScreen(mundo: m)));
      await cuadros(tester, 4);
      if (s.width < 720) {
        await tester.scrollUntilVisible(find.textContaining('Laboratorio de IA'), 200, scrollable: find.byType(Scrollable).first);
      }
      expect(find.textContaining('Laboratorio de IA'), findsOneWidget, reason: '$s');
      expect(tester.takeException(), isNull, reason: '$s');
    }
  });

  testWidgets('Simulaciones de IA: Turing, patrones y pixeles', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasIA, 'i1_m2_sim', () async {
      for (var r = 0; r < rondasTuring.length; r++) {
        await tester.tap(find.byTooltip(rondasTuring[r].maquinaEsA ? 'Respuesta A' : 'Respuesta B'));
        await tester.pump();
        if (r < rondasTuring.length - 1) {
          await tester.tap(find.byTooltip('Siguiente pregunta'));
          await tester.pump();
        }
      }
      expect(tester.state<SimTuringState>(find.byType(SimTuring)).aciertos, rondasTuring.length);
    });
    await resolver(tester, temasIA, 'i2_m2_sim', () async {
      for (var r = 0; r < retosPatrones.length; r++) {
        await tester.tap(find.text(retosPatrones[r].opciones[retosPatrones[r].correcta]).last);
        await tester.pump();
        if (r < retosPatrones.length - 1) {
          await tester.tap(find.byTooltip('Siguiente reto'));
          await tester.pump();
        }
      }
      expect(tester.state<SimPatronesState>(find.byType(SimPatrones)).errores, 0);
    });
    await resolver(tester, temasIA, 'i2_m3_sim', () async {
      final st = tester.state<SimPixelesState>(find.byType(SimPixeles));
      for (final n in ['Cruz', 'Cuadro', 'Letra L']) {
        await tester.tap(find.byTooltip('Dibujar $n'));
        await tester.pump();
      }
      await tester.tap(find.byTooltip('Borrar'));
      await tester.pump();
      for (final (i, j) in const [(0, 0), (0, 1), (1, 0), (1, 1)]) {
        st.alternar(i, j);
      }
      await tester.pump();
      expect(st.hechas.length, SimPixelesState.metas.length);
    });
  });

  testWidgets('Simulaciones de IA: entrenar, neurona y sesgo', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasIA, 'i3_m2_sim', () async {
      final p = proyectoMamiferoAve;
      for (final e in p.banco) {
        await tester.tap(find.byTooltip('Ejemplo ${e.nombre}'));
        await tester.pump();
        await tester.tap(find.byTooltip('${e.nombre}: ${p.etiquetas[e.etiqueta].nombre}'));
        await tester.pump();
      }
      await tester.tap(find.byTooltip('Entrenar'));
      await cuadros(tester, 30, 60);
      final st = tester.state<SimEntrenarState>(find.byType(SimEntrenar));
      expect(st.precision, 1.0);
      expect(st.hechas.length, st.metas.length);
    });
    await resolver(tester, temasIA, 'i3_m3_sim', () async {
      final st = tester.state<SimNeuronaState>(find.byType(SimNeurona));
      expect(st.listo, isFalse);
      st.cambiar(w0: 2, w1: -2, w2: 1, u: 1.5);
      expect(st.listo, isTrue);
    });
    await resolver(tester, temasIA, 'i5_m1_sim', () async {
      final st = tester.state<SimEntrenarState>(find.byType(SimEntrenar));
      await tester.tap(find.byTooltip('Entrenar'));
      await cuadros(tester, 30, 60);
      expect(st.precision, lessThan(1));
      await tester.tap(find.byTooltip('Agregar datos variados'));
      await tester.pump();
      await tester.tap(find.byTooltip('Entrenar'));
      await cuadros(tester, 30, 60);
      expect(st.precision, 1.0);
      expect(st.hechas.length, st.metas.length);
    });
  });

  testWidgets('Simulaciones de IA: asistente y recomendador', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasIA, 'i4_m1_sim', () async {
      for (final o in ordenesVoz.take(3)) {
        await tester.tap(find.byTooltip(o.texto));
        await cuadros(tester, 12, 300);
      }
      expect(tester.state<SimAsistenteState>(find.byType(SimAsistente)).hechas.length, SimAsistenteState.metas.length);
    });
    await resolver(tester, temasIA, 'i4_m2_sim', () async {
      for (final i in [0, 4, 1, 2]) {
        await tester.tap(find.byTooltip('Me gusta ${catalogoVideos[i].$2}'));
        await tester.pump();
      }
      expect(tester.state<SimRecomendadorState>(find.byType(SimRecomendador)).hechas.length, SimRecomendadorState.metas.length);
    });
  });

  testWidgets('Laboratorio: escoge 6, etiqueta, entrena, prueba y publica', (tester) async {
    pantalla(tester, const Size(844, 390));
    var publicado = 0;
    await tester.pumpWidget(MaterialApp(home: Theme(data: temaJuego(), child: LaboratorioIA(onTerminar: (e) => publicado = e))));
    await cuadros(tester, 4);
    final st = tester.state<LaboratorioIAState>(find.byType(LaboratorioIA));
    Future<void> tocar(String t) async {
      await tester.tap(find.byTooltip(t).first);
      await tester.pump();
    }

    final p = problemasLab[2]; // Reciclaje
    await tocar('Problema ${p.titulo}');
    expect(st.paso, 1);
    // Con 5 no se puede avanzar; con 6 cualesquiera, sí (aunque sean del mismo grupo)
    final mismos = [
      for (var i = 0; i < p.objetos.length; i++)
        if (p.objetos[i].grupo == 0) i
    ];
    for (final i in mismos.take(5)) {
      await tocar('Objeto ${p.objetos[i].nombre}');
    }
    expect(st.puedeAvanzar, isFalse);
    await tocar('Objeto ${p.objetos[1].nombre}');
    expect(st.elegidos.length, 6);
    expect(st.puedeAvanzar, isTrue);
    await tocar('Siguiente paso');
    // Etiqueta todo al revés a propósito
    while (st.porEtiquetar != null) {
      final o = p.objetos[st.porEtiquetar!];
      await tocar('Etiqueta ${p.grupos[1 - o.grupo].$1}');
    }
    await tocar('Siguiente paso');
    await tocar('Entrenar');
    await cuadros(tester, 30, 60);
    await tocar('Siguiente paso');
    expect(st.paso, 4);
    // La prueba usa objetos del mismo estante que no se eligieron
    expect(st.prueba.every((r) => !st.elegidos.contains(r.$1)), isTrue);
    expect(st.precision, lessThan(1));
    expect(find.textContaining('etiquetas estaban mal'), findsOneWidget);
    // Corrige las etiquetas y vuelve a entrenar
    await tocar('Corregir etiquetas');
    while (st.porEtiquetar != null) {
      await tocar('Etiqueta ${p.grupos[p.objetos[st.porEtiquetar!].grupo].$1}');
    }
    await tocar('Siguiente paso');
    await tocar('Entrenar');
    await cuadros(tester, 30, 60);
    await tocar('Siguiente paso');
    expect(st.precision, 1.0);
    await tocar('Publicar IA');
    await cuadros(tester, 12);
    await tester.tap(find.text('¡Genial!').first);
    await cuadros(tester, 6);
    expect(publicado, greaterThan(0));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Laboratorio: cada problema se puede resolver y se ve bien en cada paso', (tester) async {
    for (final s in const [Size(844, 390), Size(1280, 800)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(home: Theme(data: temaJuego(), child: LaboratorioIA(key: ValueKey(s), onTerminar: (_) {}))));
      await cuadros(tester, 3);
      final st = tester.state<LaboratorioIAState>(find.byType(LaboratorioIA));
      for (var k = 0; k < problemasLab.length; k++) {
        st.elegirProblema(k);
        // 3 de cada grupo
        final p = problemasLab[k];
        for (final g in [0, 1]) {
          for (final i in [
            for (var i = 0; i < p.objetos.length; i++)
              if (p.objetos[i].grupo == g) i
          ].take(3)) {
            st.alternar(i);
          }
        }
        for (var paso = 1; paso <= 2; paso++) {
          st.irA(paso);
          await cuadros(tester, 2);
          expect(tester.takeException(), isNull, reason: '$s ${p.titulo} paso $paso');
        }
        while (st.porEtiquetar != null) {
          st.etiquetar(p.objetos[st.porEtiquetar!].grupo);
        }
        st.irA(3);
        st.entrenar();
        await cuadros(tester, 30, 60);
        st.irA(4);
        await cuadros(tester, 2);
        expect(st.precision, 1.0, reason: p.titulo);
        expect(tester.takeException(), isNull, reason: '$s prueba');
      }
      await tester.pumpWidget(const SizedBox());
    }
  });
}
