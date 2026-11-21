import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'misiones.dart';
import 'progreso.dart';

/// Punto de entrada del juego "El cuerpo humano y sus sistemas".
///
/// Úsalo como una pantalla más de tu app:
/// ```dart
/// Navigator.push(context, MaterialPageRoute(builder: (_) => const CuerpoHumanoJuego()));
/// ```
///
/// Flujo: Intro del tema → Menú de misiones → Misión 1 (empieza con
/// "¿Qué es el cuerpo humano?") → Misión 2 → Misión 3 → Actividad integradora.
class CuerpoHumanoJuego extends StatefulWidget {
  const CuerpoHumanoJuego({
    super.key,
    this.progreso,
    this.nombreAlumno,
    this.horizontal = true,
    this.desbloquearTodo = false,
    this.videos = ConfiguracionJuego.videosPorDefecto,
  });

  /// Videos de los temas, por ejemplo
  /// `{'circulatorio': 'https://mi-escuela.mx/videos/circulatorio.mp4'}`.
  final Map<String, String> videos;

  /// Progreso propio (para guardarlo entre sesiones). Si es null se crea uno.
  final ProgresoJuego? progreso;
  final String? nombreAlumno;

  /// Gira la pantalla en horizontal mientras se juega (como en los bocetos).
  final bool horizontal;

  /// Modo docente: abre todas las misiones y pasos sin completarlos.
  final bool desbloquearTodo;

  @override
  State<CuerpoHumanoJuego> createState() => _CuerpoHumanoJuegoState();
}

class _CuerpoHumanoJuegoState extends State<CuerpoHumanoJuego> {
  late final ProgresoJuego _progreso = widget.progreso ?? ProgresoJuego();

  @override
  void initState() {
    super.initState();
    if (widget.horizontal) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    if (widget.horizontal) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (widget.progreso == null) _progreso.dispose();
    super.dispose();
  }

  final _navegador = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => ConfiguracionJuego(
        desbloquearTodo: widget.desbloquearTodo,
        videos: widget.videos,
        nombreAlumno: widget.nombreAlumno,
        child: ProgresoScope(
          progreso: _progreso,
          child: Theme(
            data: temaJuego(),
            child: PantallaGirable(
              child: NavigatorPopHandler(
                onPopWithResult: (_) => _navegador.currentState?.maybePop(),
                child: ScaffoldMessenger(
                  child: Navigator(
                    key: _navegador,
                    onGenerateRoute: (_) => MaterialPageRoute(
                      builder: (_) =>
                          PantallaIntroTema(nombre: widget.nombreAlumno),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

/// Muestra el juego siempre en horizontal (como los bocetos).
///
/// En una pantalla vertical (celular sin girar o navegador angosto) gira el
/// contenido 90° y ajusta [MediaQuery], así todo cabe y se puede tocar. En
/// pantallas horizontales (computadora, tableta, celular girado) no cambia nada.
class PantallaGirable extends StatelessWidget {
  const PantallaGirable({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final vertical = mq.size.height > mq.size.width * 1.05;
    final p = mq.padding;
    final datos = vertical
        ? mq.copyWith(
            size: Size(mq.size.height, mq.size.width),
            padding: EdgeInsets.only(
                left: p.top, right: p.bottom, top: p.right, bottom: p.left),
            viewPadding: EdgeInsets.only(
              left: mq.viewPadding.top,
              right: mq.viewPadding.bottom,
              top: mq.viewPadding.right,
              bottom: mq.viewPadding.left,
            ),
          )
        : mq;
    return ColoredBox(
      color: const Color(0xFF183E73),
      child: RotatedBox(
        quarterTurns: vertical ? 1 : 0,
        child: MediaQuery(data: datos, child: child),
      ),
    );
  }
}
