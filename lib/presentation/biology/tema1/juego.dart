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

  @override
  Widget build(BuildContext context) => ConfiguracionJuego(
        desbloquearTodo: widget.desbloquearTodo,
        videos: widget.videos,
        child: ProgresoScope(
          progreso: _progreso,
          child: Theme(
            data: temaJuego(),
            child: PantallaIntroTema(nombre: widget.nombreAlumno),
          ),
        ),
      );
}
