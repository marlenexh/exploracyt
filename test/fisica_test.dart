import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/fis_topics.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';
import 'package:explora_ciencia/presentation/fisica/sims_fis.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  probarMundo(
    w: 'fis',
    nombre: 'Física',
    temas: temasFis,
    infos: fisTopics,
    titulos: const [
      'El magnetismo y sus misterios',
      'La gravedad en acción',
      'Calor y energía térmica',
      'La energía que nos rodea',
      'Explorando el Sistema Solar'
    ],
    mapa: (m) => FisicaScreen(mundo: m),
    minTablas: 3,
  );

  testWidgets('Simulaciones de Física', (tester) async {
    pantalla(tester, const Size(844, 390));
    await resolver(tester, temasFis, 'f1_m1_sim', () async {
      final st = tester.state<SimImanesState>(find.byType(SimImanes));
      st.cambiar(d: 0.1);
      await tester.tap(find.byTooltip('Voltear imán'));
      await tester.pump();
      st.cambiar(d: 0.2);
      await tester.tap(find.byTooltip('Brújula'));
      await tester.pump();
      expect(st.hechas.length, SimImanesState.metas.length);
    });
    await resolver(tester, temasFis, 'f2_m2_sim', () async {
      final st = tester.state<SimCaidaState>(find.byType(SimCaida));
      st.elegir(i: 0, d: 1, l: false);
      await tester.tap(find.byTooltip('Soltar'));
      await cuadros(tester, 60, 50);
      st.elegir(l: true);
      st.soltar();
      await cuadros(tester, 60, 50);
      st.elegir(i: 2, d: 3, l: false);
      st.soltar();
      await cuadros(tester, 60, 50);
      expect(st.hechas.length, SimCaidaState.metas.length);
    });
    await resolver(tester, temasFis, 'f3_m2_sim', () async {
      final st = tester.state<SimCalorState>(find.byType(SimCalor));
      st.elegir(0);
      await tester.tap(find.byTooltip('Juntar'));
      await cuadros(tester, 90, 100);
      st.elegir(2);
      st.juntar();
      await cuadros(tester, 90, 100);
      expect(st.hechas.length, SimCalorState.metas.length);
    });
    await resolver(tester, temasFis, 'f4_m3_sim', () async {
      final st = tester.state<SimAhorroState>(find.byType(SimAhorro));
      for (var i = 0; i < aparatosCasa.length; i++) {
        if (!aparatosCasa[i].necesario && aparatosCasa[i].emoji != '💡') st.alternar(i);
      }
      await tester.tap(find.byTooltip('Cambiar a focos LED'));
      await tester.pump();
      expect(st.consumo, lessThan(300));
      expect(st.hechas.length, SimAhorroState.metas.length);
    });
    await resolver(tester, temasFis, 'f5_m1_sim', () async {
      final st = tester.state<SimSistemaSolarState>(find.byType(SimSistemaSolar));
      for (final p in planetas) {
        await tester.tap(find.byTooltip(p.nombre).first);
        await tester.pump();
      }
      expect(st.visitados.length, 8);
    });
  });
}
