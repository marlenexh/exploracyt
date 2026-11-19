import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:explora_ciencia/main.dart' show store;
import 'package:explora_ciencia/presentation/biology/body_topic_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'Recorre el laboratorio, muestra el espacio de video y termina las tres misiones',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({'v1.reducirAnim': true});
      await store.cargar();
      await tester.pumpWidget(const MaterialApp(home: BodyTopicScreen()));
      await tester.pumpAndSettle();

      Future<void> tocar(String texto) async {
        final finder = find.text(texto);
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        await tester.tap(finder);
        await tester.pumpAndSettle();
      }

      Future<void> compararExtremos() async {
        final slider = find.byType(Slider);
        await tester.ensureVisible(slider);
        await tester.pumpAndSettle();
        final rect = tester.getRect(slider);
        await tester.tapAt(Offset(rect.right - 8, rect.center.dy));
        await tester.pumpAndSettle();
      }

      await tocar('Jugar Misión Cuerpo Humano');
      await tocar('Circulatorio');
      await tocar('Siguiente');
      expect(find.text('Parada en los pulmones'), findsOneWidget);
      await tocar('Siguiente');
      await tocar('Ir al laboratorio');
      await tocar('El corazón late más rápido.');
      await compararExtremos();
      expect(find.text('144 latidos/min en el modelo'), findsOneWidget);
      expect(find.text('TU PREDICCIÓN COINCIDE'), findsOneWidget);
      await tocar('Video');
      expect(find.text('Cómo circula la sangre'), findsOneWidget);

      Future<void> superar(String primera, String segunda) async {
        await tocar('Retos');
        await tocar(primera);
        await tocar('Siguiente reto');
        await tocar(segunda);
        await tocar('Terminar');
        await tester.pageBack();
        await tester.pumpAndSettle();
      }

      await tocar('Retos');
      await tocar('Al cerebro');
      expect(find.textContaining('Inténtalo de nuevo.'), findsOneWidget);
      await superar('A los pulmones', 'En los capilares');
      await tocar('Respiratorio');
      await tocar('Laboratorio');
      await tocar('El volumen disminuye.');
      await compararExtremos();
      expect(find.text('100 % del volumen máximo del modelo'), findsOneWidget);
      expect(find.text('REVISA TU PREDICCIÓN'), findsOneWidget);
      await superar('Nariz → tráquea → bronquios', 'Del aire a la sangre');
      await tocar('Inmunológico');
      await tocar('Laboratorio');
      await tocar('La del reencuentro.');
      await compararExtremos();
      expect(find.text('Respuesta a las 3 unidades de tiempo'), findsOneWidget);
      await superar('La piel', 'Las células de memoria');
      expect(find.text('3 de 3 insignias'), findsOneWidget);
      await tocar('Reto final');
      await tocar(
        'Los pulmones lo pasan a la sangre y el corazón bombea esa sangre.',
      );
      await tocar('Terminar');
      expect(find.textContaining('¡Misión cumplida!'), findsOneWidget);
      expect(store.completadas, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
}
