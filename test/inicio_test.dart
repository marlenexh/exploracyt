import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:explora_ciencia/core/theme.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/home_screens.dart';

import 'mundo_temas_util.dart';

void main() {
  setUpAll(fuentes);
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await store.cargar();
  });

  testWidgets('Inicio: el botón Eventos está oculto y los demás siguen', (tester) async {
    expect(mostrarBotonEventos, isFalse);
    for (final s in const [Size(390, 844), Size(1280, 800)]) {
      pantalla(tester, s);
      await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: const Home()));
      await cuadros(tester, 6);
      expect(find.text('Eventos'), findsNothing, reason: '$s');
      expect(find.text('Vocación'), findsOneWidget, reason: '$s');
      expect(find.text('¡JUGAR!'), findsOneWidget, reason: '$s');
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Ajustes: ya no tiene la opción Música', (tester) async {
    pantalla(tester, const Size(1280, 800));
    await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: const Home()));
    await cuadros(tester, 6);
    await tester.tap(find.byTooltip('Ajustes').first);
    await cuadros(tester, 6);
    expect(find.text('Música'), findsNothing);
    expect(find.text('Efectos de sonido'), findsOneWidget);
    expect(find.text('Letra más grande'), findsOneWidget);
  });

  testWidgets('Mundos: sin Avatar ni Tienda; Insignias sigue', (tester) async {
    pantalla(tester, const Size(1280, 800));
    await tester.pumpWidget(MaterialApp(theme: buildTheme(), home: const MapaMundos()));
    await cuadros(tester, 6);
    expect(find.text('Avatar'), findsNothing);
    expect(find.text('Tienda'), findsNothing);
    expect(find.text('Insignias'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
