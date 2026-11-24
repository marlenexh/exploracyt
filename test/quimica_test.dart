import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/qui_topics.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';
import 'package:explora_ciencia/presentation/quimica/sims_qui.dart';

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
}
