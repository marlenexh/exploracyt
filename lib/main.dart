import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'domain/progress_store.dart';
import 'presentation/brujula/brujula.dart';
import 'presentation/home_screens.dart';


final store = ProgressStore();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await store.cargar();
  runApp(const ExploraApp());
}

class ExploraApp extends StatelessWidget {
  const ExploraApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Explora Ciencia y Tecnología',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        builder: (context, child) => ListenableBuilder(
          listenable: store,
          builder: (_, __) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(store.textoGrande ? 1.25 : 1.0)),
            // La celebración de la Brújula de la Ciencia aparece sobre cualquier pantalla.
            child: Stack(fit: StackFit.expand, children: [child!, const CelebracionPieza()]),
          ),
        ),
        home: store.registrado ? const Home() : const Bienvenida(),
      );
}
