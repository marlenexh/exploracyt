import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/glosario.dart';
import 'package:explora_ciencia/presentation/ciencia/glosario_chips.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);

  test('Glosario: palabras únicas, explicaciones cortas y expresiones válidas', () {
    expect(glosario.length, greaterThanOrEqualTo(80));
    expect(glosario.map((p) => p.palabra).toSet().length, glosario.length);
    for (final p in glosario) {
      expect(p.regex.hasMatch(p.palabra) || p.palabra.contains(' y '), isTrue, reason: 'El patrón de ${p.palabra} no la encuentra');
      expect(p.significado.length, inInclusiveRange(30, 260), reason: p.palabra);
    }
  });

  test('Glosario: encuentra las palabras en un texto (plural, mayúsculas y acentos)', () {
    final ps = palabrasEn('Las RESISTENCIAS protegen al LED. La corriente viaja por el circuito.', maximo: 5).map((p) => p.palabra).toList();
    expect(ps, ['Resistencia', 'LED', 'Corriente', 'Circuito']);
    expect(palabrasEn('Las células forman tejidos').map((p) => p.palabra), ['Célula', 'Tejido']);
    // No confunde partes de otras palabras
    expect(palabrasEn('La materia del piso y la materialista').map((p) => p.palabra), ['Materia']);
    expect(palabrasEn('El ledo y la tía').isEmpty, isTrue);
  });

  testWidgets('Las palabras difíciles se explican al tocarlas', (tester) async {
    pantalla(tester, const Size(844, 390));
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: ChipsGlosario(texto: 'La fotosíntesis ocurre en las hojas.', color: Colors.green))));
    expect(find.text('📖 Palabras difíciles'), findsOneWidget);
    await tester.tap(find.text('🌿 Fotosíntesis'));
    await cuadros(tester, 6);
    expect(find.textContaining('fabrican su alimento'), findsOneWidget);
  });
}
