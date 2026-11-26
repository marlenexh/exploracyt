import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/biology/tema1/componentes.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  testWidgets('Las tarjetas se abren en grande, se responde y se avanza a la siguiente', (tester) async {
    for (final s in const [Size(844, 390), Size(1280, 800)]) {
      pantalla(tester, s);
      await resolver(tester, temasFis, 'f1_m2_tarj', () async {
        final st = tester.state<PantallaTarjetasState>(find.byType(PantallaTarjetas));
        await tester.tap(find.text('La magnetita').first);
        await cuadros(tester, 6);
        expect(st.abierta, isNotNull);
        expect(find.textContaining('Magnesia'), findsOneWidget);
        expect(find.text('¿Ya lo sabías?'), findsOneWidget);
        // Responde todas: cada respuesta abre la siguiente sin ver
        for (var k = 0; k < 4; k++) {
          await tester.tap(find.textContaining(k.isEven ? '¡No lo sabía!' : '¡Ya lo sabía!'));
          await cuadros(tester, 6);
        }
        expect(st.vistas, 4);
        expect(st.abierta, isNull);
        expect(find.textContaining('4 de 4'), findsOneWidget);
        expect(find.textContaining('2 datos nuevos'), findsOneWidget);
      });
    }
  });
}
