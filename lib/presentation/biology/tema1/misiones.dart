import 'package:flutter/material.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'contenido.dart';
import 'laboratorio.dart';
import 'integradora.dart';
import 'juegos.dart';
import 'mision1.dart';
import 'mision2.dart';
import 'mision3.dart';
import 'pantalla_3d.dart';
import 'pantalla_recorrido.dart';
import 'progreso.dart';
import 'retos.dart';
import '../../minijuegos/minijuegos.dart';

/// Estructura de misiones del Tema 1. Cada misión se desbloquea al completar
/// la anterior, y sus pasos también se juegan en orden.

const rutaFondoTema1 = 'assets/images/biology/fondo_biologia_tema1.jpg';
const rutaZatiTema1 = 'assets/images/biology/zati.png';

enum TipoIconoMision { corazon, pulmones, escudo, equipo }

enum TipoPaso {
  explicacion('Explicación', Icons.menu_book_rounded, Color(0xFFFF8A00)),
  sim3d('Simulación 3D', Icons.view_in_ar_rounded, Color(0xFF4361EE)),
  laboratorio('Laboratorio', Icons.science_rounded, Color(0xFF06B6A4)),
  video('Video', Icons.ondemand_video_rounded, Color(0xFFFF3D68)),
  reto('Reto', Icons.emoji_events_rounded, Color(0xFFFFAA00));

  const TipoPaso(this.nombre, this.icono, this.color);
  final String nombre;
  final IconData icono;
  final Color color;
}

class PasoMision {
  const PasoMision(
    this.titulo,
    this.tipo,
    this.actividad,
    this.pantalla, {
    this.escenario = false,
  });
  final String titulo;
  final TipoPaso tipo;
  final String actividad;
  final Widget Function() pantalla;

  /// true si la pantalla dibuja su propio fondo (pantallas tipo boceto).
  final bool escenario;
}

class Mision {
  const Mision({
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.colorFondo,
    required this.intro,
    required this.mensajeFinal,
    required this.pasos,
  });
  final String titulo;
  final String subtitulo;
  final TipoIconoMision icono;
  final Color color;
  final Color colorFondo;
  final String intro;
  final String mensajeFinal;
  final List<PasoMision> pasos;

  bool completa(ProgresoJuego p) =>
      pasos.every((x) => p.estrellasDe(x.actividad) > 0);
  double avance(ProgresoJuego p) =>
      pasos.where((x) => p.estrellasDe(x.actividad) > 0).length / pasos.length;
}

CapituloTour _cap(String id) => capitulosTour.firstWhere((c) => c.id == id);

PasoMision _p(String t, TipoPaso tipo, String a, Widget Function() w) =>
    PasoMision(t, tipo, a, w, escenario: true);
PasoMision _v(String t, TipoPaso tipo, String a, Widget Function() w) =>
    PasoMision(t, tipo, a, w);

final misionesTema1 = <Mision>[
  Mision(
    titulo: 'Misión 1',
    subtitulo: '¡El corazón en acción!',
    icono: TipoIconoMision.corazon,
    color: ColoresJuego.circulatorio,
    colorFondo: const Color(0xFFFFC7D2),
    intro:
        'El sistema circulatorio de la Estación dejó de funcionar. ¡Vamos a descubrir cómo trabajan el corazón y la sangre para repararlo!',
    mensajeFinal: '¡El sistema circulatorio de la Estación vuelve a latir!',
    pasos: [
      _v(
          '¿Qué es el cuerpo humano?',
          TipoPaso.explicacion,
          Actividades.tourIntro,
          () => PantallaRecorrido(capitulo: _cap(Actividades.tourIntro))),
      _p('El cuerpo humano y sus sistemas', TipoPaso.explicacion,
          Actividades.m1Cuerpo, () => const PantallaCuerpoHumano()),
      _p(
          'Sistema circulatorio',
          TipoPaso.explicacion,
          Actividades.m1Circulatorio,
          () => const PantallaCirculatorioExplicacion()),
      _p('El corazón y los vasos sanguíneos', TipoPaso.explicacion,
          Actividades.m1Vasos, () => const PantallaVasosSanguineos()),
      _p('El viaje de la sangre', TipoPaso.explicacion, Actividades.m1Viaje,
          () => const PantallaViajeSangre()),
      _p('Video del tema', TipoPaso.video, Actividades.m1Video,
          () => const PantallaVideoTema()),
      _p('Las partes del corazón', TipoPaso.sim3d, Actividades.m1Sim3d,
          () => const PantallaSim3DCorazon()),
      _p('Tu frecuencia cardiaca', TipoPaso.laboratorio, Actividades.m1Lab,
          () => const PantallaLabFrecuencia()),
      _p('Repartidor de oxígeno', TipoPaso.reto, Actividades.m1Juego,
          () => const JuegoRepartidorOxigeno()),
      _p('Pon a prueba lo que aprendiste', TipoPaso.reto, Actividades.m1Mini,
          () => const PantallaMiniMisionCirculatorio()),
    ],
  ),
  Mision(
    titulo: 'Misión 2',
    subtitulo: '¡El viaje del aire!',
    icono: TipoIconoMision.pulmones,
    color: ColoresJuego.respiratorio,
    colorFondo: const Color(0xFFD3DDFF),
    intro:
        '¡Ahora falla el sistema respiratorio! Sigue el camino del aire y descubre cómo respiramos.',
    mensajeFinal: '¡El sistema respiratorio de la Estación vuelve a respirar!',
    pasos: [
      _p(
          'El sistema respiratorio',
          TipoPaso.explicacion,
          Actividades.m2Explicacion,
          () => const PantallaRespiratorioExplicacion()),
      _v(
          'El viaje del aire',
          TipoPaso.explicacion,
          Actividades.tourRespiratorio,
          () =>
              PantallaRecorrido(capitulo: _cap(Actividades.tourRespiratorio))),
      _p('El intercambio de gases', TipoPaso.explicacion,
          Actividades.m2Intercambio, () => const PantallaIntercambioGases()),
      _p(
          '¿Cómo cambia tu respiración?',
          TipoPaso.explicacion,
          Actividades.m2Respiracion,
          () => const PantallaComoCambiaRespiracion()),
      _p('El ambiente también influye', TipoPaso.explicacion,
          Actividades.m2Ambiente, () => const PantallaAmbienteRespiracion()),
      _p(
          'Video del tema',
          TipoPaso.video,
          Actividades.m2Video,
          () => const PantallaVideoTema(
                clave: 'respiratorio',
                titulo: 'Video: el sistema respiratorio',
                actividad: Actividades.m2Video,
                tema: 'cómo entra y sale el aire de tus pulmones',
                siguiente: '¡Ahora vamos a ver los pulmones en 3D!',
              )),
      _v('Los pulmones en 3D', TipoPaso.sim3d, Actividades.simPulmones,
          () => const PantallaSimulacion3D(inicial: 1, soloModelo: true)),
      _p('Laboratorio de la respiración', TipoPaso.laboratorio,
          Actividades.m2Lab, () => const PantallaLabRespiracion()),
      _p('Atrapa el aire limpio', TipoPaso.reto, Actividades.m2Juego,
          () => const JuegoAtrapaAire()),
      _p('Pon a prueba lo que aprendiste', TipoPaso.reto, Actividades.m2Mini,
          () => const PantallaMiniMisionRespiratorio()),
    ],
  ),
  Mision(
    titulo: 'Misión 3',
    subtitulo: '¡Defensores del cuerpo!',
    icono: TipoIconoMision.escudo,
    color: const Color(0xFF2DB84C),
    colorFondo: const Color(0xFFC9F0CF),
    intro:
        '¡Unos microbios invadieron la Estación! Conoce a los defensores del cuerpo y ayúdalos a protegerla.',
    mensajeFinal:
        '¡El sistema inmunológico de la Estación está listo para defenderla!',
    pasos: [
      _p('El sistema inmunológico', TipoPaso.explicacion,
          Actividades.m3Explicacion, () => const PantallaInmuneExplicacion()),
      _p('Las partes de tus defensas', TipoPaso.explicacion,
          Actividades.m3Partes, () => const PantallaInmunePartes()),
      _v('Así te defiende', TipoPaso.explicacion, Actividades.tourInmune,
          () => PantallaRecorrido(capitulo: _cap(Actividades.tourInmune))),
      _p('Hábitos y defensas', TipoPaso.explicacion, Actividades.m3Habitos,
          () => const PantallaHabitosDefensas()),
      _p(
          'Video del tema',
          TipoPaso.video,
          Actividades.m3Video,
          () => const PantallaVideoTema(
                clave: 'inmune',
                titulo: 'Video: el sistema inmunológico',
                actividad: Actividades.m3Video,
                tema: 'cómo te defiende tu cuerpo de los microbios',
                siguiente: '¡Ahora viaja dentro de la sangre en 3D!',
              )),
      _v('Dentro de la sangre 3D', TipoPaso.sim3d, Actividades.simInmune,
          () => const PantallaSimulacion3D(inicial: 3, soloModelo: true)),
      _v('El microscopio', TipoPaso.laboratorio, Actividades.labMicroscopio,
          () => const LabMicroscopio()),
      _v('Las vacunas', TipoPaso.laboratorio, Actividades.labVacunas,
          () => const LabVacunas()),
      _v('Defensa inmune', TipoPaso.reto, Actividades.retoDefensa,
          () => const RetoDefensa()),
      _v('Glóbulo blanco al ataque', TipoPaso.reto, Actividades.m3Flame,
          () => juegoGlobulo(Actividades.m3Flame)),
      _p('Pon a prueba lo que aprendiste', TipoPaso.reto, Actividades.m3Mini,
          () => const PantallaMiniMisionInmune()),
    ],
  ),
  Mision(
    titulo: 'Actividad Integradora',
    subtitulo: '¡Tu cuerpo trabaja en equipo!',
    icono: TipoIconoMision.equipo,
    color: const Color(0xFF8B5CF6),
    colorFondo: const Color(0xFFE2D3FF),
    intro:
        '¡Último desafío! Resuelve una situación usando lo que sabes de los tres sistemas.',
    mensajeFinal: '¡Todos los sistemas trabajan en equipo otra vez!',
    pasos: [
      _v('El cuerpo completo en 3D', TipoPaso.sim3d, Actividades.simCuerpo,
          () => const PantallaSimulacion3D(inicial: 2, soloModelo: true)),
      _p('La excursión al cerro', TipoPaso.reto, Actividades.intSituacion,
          () => const PantallaSituacionIntegradora()),
      _v('Arma el cuerpo', TipoPaso.reto, Actividades.retoArma,
          () => const RetoArmaCuerpo()),
      _v('Supercerebro', TipoPaso.reto, Actividades.retoQuiz,
          () => const RetoQuiz()),
    ],
  ),
];

bool misionDesbloqueada(ProgresoJuego p, int indice) =>
    indice == 0 || misionesTema1[indice - 1].completa(p);

/// Al entrar a una misión nueva se abre directamente su primera explicación
/// (en la Misión 1: "¿Qué es el cuerpo humano?"); al terminarla se muestran
/// los pasos de la misión.
Future<void> abrirMision(BuildContext context, Mision m) async {
  final p = ProgresoScope.read(context);
  bool hecho(PasoMision x) => p.estrellasDe(x.actividad) > 0;
  if (m.completa(p)) {
    await abrirPantalla(context, PantallaMision(mision: m), fondoBosque: true);
    return;
  }
  // Los pasos se juegan uno tras otro; si el alumno sale a la mitad,
  // se le muestra el mapa de pasos de la misión.
  var i = m.pasos.indexWhere((x) => !hecho(x));
  while (i != -1) {
    final paso = m.pasos[i];
    await abrirPantalla(
      context,
      paso.pantalla(),
      color: m.color,
      conFondo: !paso.escenario,
    );
    if (!context.mounted) return;
    if (!hecho(paso)) {
      await abrirPantalla(
        context,
        PantallaMision(mision: m),
        fondoBosque: true,
      );
      return;
    }
    i = m.pasos.indexWhere((x) => !hecho(x));
  }
  final indice = misionesTema1.indexOf(m);
  final siguiente =
      indice + 1 < misionesTema1.length ? misionesTema1[indice + 1] : null;
  await mostrarCelebracion(
    context,
    titulo: '¡${m.titulo} cumplida!',
    mensaje: '${m.mensajeFinal}'
        '${siguiente == null ? '\n¡Restauraste toda la Estación del Cuerpo Humano!' : '\n¡Ahora sigue “${siguiente.titulo}: ${siguiente.subtitulo}”!'}',
    estrellas: 3,
  );
  if (!context.mounted) return;
  if (siguiente != null) {
    await abrirMision(context, siguiente);
  } else {
    // Tema 1 completo: insignia "Explorador del Cuerpo Humano".
    await abrirPantalla(context, const PantallaInsigniaFinal(),
        conFondo: false);
  }
}

/// Opciones del juego disponibles en todas las pantallas.
class ConfiguracionJuego extends InheritedWidget {
  const ConfiguracionJuego({
    super.key,
    required this.desbloquearTodo,
    this.videos = videosPorDefecto,
    this.nombreAlumno,
    required super.child,
  });

  /// Nombre que se muestra en la insignia final.
  final String? nombreAlumno;

  /// Para docentes o pruebas: permite abrir cualquier misión o paso.
  final bool desbloquearTodo;

  /// Videos de cada tema: un archivo en assets ("assets/videos/…mp4") o una
  /// dirección de internet ("https://…mp4").
  final Map<String, String> videos;

  static const videosPorDefecto = {
    'circulatorio': 'assets/videos/sistema_circulatorio.mp4',
    'respiratorio': 'assets/videos/sistema_respiratorio.mp4',
    'inmune': 'assets/videos/sistema_inmunologico.mp4',
  };

  static ConfiguracionJuego of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ConfiguracionJuego>() ??
      const ConfiguracionJuego(desbloquearTodo: false, child: SizedBox());

  @override
  bool updateShouldNotify(ConfiguracionJuego old) =>
      old.desbloquearTodo != desbloquearTodo ||
      old.videos != videos ||
      old.nombreAlumno != nombreAlumno;
}
