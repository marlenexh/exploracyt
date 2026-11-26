import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/progreso.dart';

import 'package:explora_ciencia/data/qui_topics.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';
import 'package:explora_ciencia/presentation/quimica/sims_qui.dart';
import 'package:explora_ciencia/presentation/ciencia/juego_rapido.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  probarMundo(
    w: 'qui',
    nombre: 'Química',
    temas: temasQui,
    infos: quiTopics,
    titulos: const [
      'El mundo de los materiales',
      'Los gases y sus propiedades',
      'Todo se transforma',
      'Cocción y descomposición de los alimentos',
      'Combustión y oxidación'
    ],
    mapa: (m) => QuimicaScreen(mundo: m),
    minTablas: 3,
  );

  testWidgets('Simulaciones de Química', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasQui, 'q2_m2_sim', () async {
      final st = tester.state<SimGasesState>(find.byType(SimGases));
      st.cambiar(v: 0.5);
      st.cambiar(t: 0.9);
      st.cambiar(v: 1);
      await tester.tap(find.byTooltip('Pesar globos'));
      await tester.pump();
      expect(st.hechas.length, SimGasesState.metas.length);
    });
    await resolver(tester, temasQui, 'q4_m2_sim', () async {
      final st = tester.state<SimConservacionState>(find.byType(SimConservacion));
      st.cambiar(a: 0, m: 0, d: 6);
      st.cambiar(a: 1, m: 1, d: 7);
      st.cambiar(m: 2);
      st.cambiar(m: 3);
      expect(st.hechas.length, SimConservacionState.metas.length);
    });
    await resolver(tester, temasQui, 'q5_m1_sim', () async {
      final st = tester.state<SimCombustionState>(find.byType(SimCombustion));
      await tester.tap(find.byTooltip('Frasco chico'));
      await cuadros(tester, 50, 100);
      await tester.tap(find.byTooltip('Frasco grande'));
      await cuadros(tester, 100, 100);
      await tester.tap(find.byTooltip('Sin frasco'));
      await tester.pump();
      await tester.tap(find.byTooltip('Oxígeno'));
      await tester.pump();
      expect(st.hayFuego, isFalse);
      expect(st.hechas.length, SimCombustionState.metas.length);
    });
  });

  testWidgets('La máquina de los cambios: se completa sin errores', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasQui, 'q3_m2_mem', () async {
      final st = tester.state<JuegoRapidoState>(find.byType(JuegoRapido));
      await tester.tap(find.byTooltip('Empezar'));
      await tester.pump();
      while (!st.terminado) {
        await tester.tap(find.byTooltip(st.actual!.correcta == 0 ? 'Opción Temporal' : 'Opción Permanente'));
        await cuadros(tester, 10, 100);
      }
      expect(st.estrellas, 3);
      expect(st.mejorRacha, st.widget.objetos.length);
    });
  });

  testWidgets('La máquina de los cambios: los errores y el tiempo agotado cuentan', (tester) async {
    pantalla(tester, const Size(844, 390));
    final (tema, paso) = pasosDe(temasQui).firstWhere((e) => e.$2.id == 'q3_m2_mem');
    await tester.pumpWidget(lanzar(tema, paso.pantalla(paso.id), ProgresoJuego()));
    await cuadros(tester, 6);
    final st = tester.state<JuegoRapidoState>(find.byType(JuegoRapido));
    await tester.tap(find.byTooltip('Empezar'));
    // Respuesta equivocada: cuenta error y el objeto vuelve al final
    final primero = st.actual!;
    await tester.tap(find.byTooltip(primero.correcta == 0 ? 'Opción Permanente' : 'Opción Temporal'));
    await cuadros(tester, 16, 100);
    expect(st.errores, 1);
    expect(identical(st.actual, primero), isFalse);
    // Sin responder: se acaba el tiempo
    await cuadros(tester, 120, 100);
    expect(st.errores, greaterThanOrEqualTo(2));
    expect(st.estrellas, lessThan(3));
    await tester.pumpWidget(const SizedBox());
  });
}
