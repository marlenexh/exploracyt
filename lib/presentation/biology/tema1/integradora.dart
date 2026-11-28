import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'componentes.dart';
import 'escenario.dart';
import 'misiones.dart' show ConfiguracionJuego;
import 'pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'progreso.dart';
import '../../ciencia/barajar.dart';

/// Actividad integradora: una situación que se resuelve con lo aprendido de
/// los 3 sistemas, y la pantalla final con la insignia del Tema 1.

enum Sistema {
  circulatorio(
      'Circulatorio', Icons.favorite_rounded, ColoresJuego.circulatorio),
  respiratorio('Respiratorio', Icons.air_rounded, ColoresJuego.respiratorio),
  inmunologico('Inmunológico', Icons.shield_rounded, Color(0xFF2DB84C));

  const Sistema(this.nombre, this.icono, this.color);
  final String nombre;
  final IconData icono;
  final Color color;
}

class EscenaSituacion {
  const EscenaSituacion({
    required this.titulo,
    required this.narracion,
    required this.iconos,
    required this.pregunta,
    required this.opciones,
    required this.correcta,
    required this.explicacion,
    required this.sistemas,
  });
  final String titulo;
  final String narracion;
  final List<IconData> iconos;
  final String pregunta;
  final List<String> opciones;
  final int correcta;
  final String explicacion;
  final Set<Sistema> sistemas;
}

const escenasExcursion = [
  EscenaSituacion(
    titulo: 'La subida',
    narracion:
        'Luz y sus amigos suben corriendo el cerro. Luz siente que su corazón late muy rápido y respira agitada.',
    iconos: [
      Icons.landscape_rounded,
      Icons.directions_run_rounded,
      Icons.favorite_rounded
    ],
    pregunta: '¿Qué le está pasando al cuerpo de Luz?',
    opciones: [
      'Sus músculos necesitan más oxígeno: respira más rápido y su corazón bombea más sangre',
      'Se le está acabando la sangre',
      'Sus pulmones dejaron de trabajar',
    ],
    correcta: 0,
    explicacion:
        'Los pulmones toman más oxígeno y el corazón lo reparte más rápido a los músculos. ¡Trabajan en equipo!',
    sistemas: {Sistema.circulatorio, Sistema.respiratorio},
  ),
  EscenaSituacion(
    titulo: 'El humo de la fogata',
    narracion:
        'En la cima, alguien prende una fogata con basura. Hay mucho humo y Luz empieza a toser.',
    iconos: [
      Icons.local_fire_department_rounded,
      Icons.cloud_rounded,
      Icons.sick_rounded
    ],
    pregunta: '¿Qué es lo mejor que puede hacer Luz?',
    opciones: [
      'Acercarse para ver mejor el fuego',
      'Alejarse del humo y respirar aire limpio por la nariz',
      'Aguantar la respiración todo el día',
    ],
    correcta: 1,
    explicacion:
        'El humo irrita las vías respiratorias y daña los alvéolos. Alejarse y respirar aire limpio protege sus pulmones.',
    sistemas: {Sistema.respiratorio},
  ),
  EscenaSituacion(
    titulo: 'La raspadura',
    narracion:
        'Al bajar, Luz se tropieza y se raspa la rodilla. Sale un poquito de sangre.',
    iconos: [
      Icons.directions_walk_rounded,
      Icons.healing_rounded,
      Icons.coronavirus_rounded
    ],
    pregunta: '¿Qué la protege de los microbios y qué debe hacer?',
    opciones: [
      'Nada la protege; debe tocar la herida con tierra',
      'Sus plaquetas forman una costra y sus defensas atacan microbios; debe lavarla con agua y jabón y cubrirla',
      'Su estómago la protege; no debe hacer nada',
    ],
    correcta: 1,
    explicacion:
        'Las plaquetas (sistema circulatorio) tapan la herida y los glóbulos blancos (sistema inmunológico) atacan a los microbios. Limpiarla ayuda mucho.',
    sistemas: {Sistema.circulatorio, Sistema.inmunologico},
  ),
  EscenaSituacion(
    titulo: 'Un amigo con gripa',
    narracion:
        'Unos días después, Mateo, su amigo de la excursión, tiene gripa y estornuda mucho.',
    iconos: [
      Icons.masks_rounded,
      Icons.wash_rounded,
      Icons.local_drink_rounded
    ],
    pregunta: '¿Cómo puede Luz cuidarse para no enfermarse?',
    opciones: [
      'Compartir su botella de agua con Mateo',
      'Lavarse las manos, no compartir vasos y pedirle a Mateo que se tape al estornudar',
      'Tallarse los ojos con las manos sin lavar',
    ],
    correcta: 1,
    explicacion:
        'Estos hábitos evitan que los virus entren al cuerpo. Si alguno entra, ¡sus defensas están listas!',
    sistemas: {Sistema.inmunologico, Sistema.respiratorio},
  ),
  EscenaSituacion(
    titulo: 'Todo un equipo',
    narracion:
        'De regreso en casa, Luz le cuenta a su familia todo lo que vivió en la excursión.',
    iconos: [Icons.favorite_rounded, Icons.air_rounded, Icons.shield_rounded],
    pregunta: '¿Cómo trabajaron juntos sus 3 sistemas en la excursión?',
    opciones: [
      'Cada sistema trabajó solo, sin ayudar a los demás',
      'Solo trabajó el corazón',
      'Los pulmones tomaron oxígeno, el corazón lo repartió con la sangre y las defensas la protegieron de microbios',
    ],
    correcta: 2,
    explicacion:
        '¡Exacto! El cuerpo humano es un gran equipo: los sistemas dependen unos de otros.',
    sistemas: {
      Sistema.circulatorio,
      Sistema.respiratorio,
      Sistema.inmunologico
    },
  ),
];

class PantallaSituacionIntegradora extends StatefulWidget {
  const PantallaSituacionIntegradora({super.key});
  @override
  State<PantallaSituacionIntegradora> createState() =>
      _PantallaSituacionIntegradoraState();
}

class _PantallaSituacionIntegradoraState
    extends State<PantallaSituacionIntegradora> {
  int _i = 0;
  int? _elegida;
  final _intentadas = <int>{};
  int _primer = 0;

  @override
  Widget build(BuildContext context) {
    final e = escenasExcursion[_i];
    final acerto = _elegida == e.correcta;
    final ultima = _i == escenasExcursion.length - 1;
    return Escenario(
      velo: 0.05,
      children: [
        const BotonVolverEscena(),
        const Positioned(
            left: 64, top: 14, child: EtiquetaSeccion('Situación')),
        const Positioned(
            left: 280,
            top: 4,
            child: BannerTitulo('La excursión al cerro',
                tam: 23, color: Color(0xFF8B5CF6))),
        Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto: '${e.titulo}\n\n${e.narracion}',
            tamZati: 165,
            anchoGlobo: 236,
            altoGlobo: 200,
            tamLetra: 14.5,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 248,
          top: 62,
          width: 606,
          height: 356,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: const Color(0xFF8B5CF6), width: 4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Escena ${_i + 1} de ${escenasExcursion.length}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6))),
                    const Spacer(),
                    for (final ic in e.iconos)
                      Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Icon(ic,
                              size: 30, color: const Color(0xFF6A3FC8))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(e.pregunta,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (posK, k) in ordenOpciones(e.pregunta, e.opciones.length).indexed)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: BotonOpcion(
                              letra: 'ABCD'[posK],
                              texto: e.opciones[k],
                              estado: _elegida == k
                                  ? (k == e.correcta
                                      ? EstadoOpcion.correcta
                                      : EstadoOpcion.incorrecta)
                                  : EstadoOpcion.normal,
                              onTap: acerto
                                  ? null
                                  : () => setState(() {
                                        if (!_intentadas.contains(_i) &&
                                            k == e.correcta) {
                                          _primer++;
                                        }
                                        _intentadas.add(_i);
                                        _elegida = k;
                                      }),
                            ),
                          ),
                        if (_elegida != null && !acerto)
                          const Text(
                              '🤔 Piensa en lo que aprendiste de cada sistema e inténtalo otra vez.',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: ColoresJuego.incorrecto)),
                        if (acerto) ...[
                          Text('✅ ${e.explicacion}',
                              style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: ColoresJuego.correcto)),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 6,
                            children: [
                              const Text('Sistemas en acción:',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w700)),
                              for (final s in e.sistemas)
                                Chip(
                                  avatar: Icon(s.icono,
                                      color: Colors.white, size: 16),
                                  label: Text(s.nombre,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12.5)),
                                  backgroundColor: s.color,
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (acerto)
          Positioned(
            left: 660,
            top: 424,
            child: BotonSiguiente(
              texto: ultima ? 'Terminar' : 'Siguiente escena',
              onTap: () {
                if (!ultima) {
                  setState(() {
                    _i++;
                    _elegida = null;
                  });
                  return;
                }
                terminarPaso(
                  context,
                  actividad: Actividades.intSituacion,
                  estrellas: _primer >= 5 ? 3 : (_primer >= 3 ? 2 : 1),
                  titulo: '¡Situación resuelta!',
                  mensaje:
                      'Usaste lo que sabes de los sistemas circulatorio, respiratorio e inmunológico para ayudar a Luz.',
                );
              },
            ),
          ),
        if (acerto && !ultima)
          Positioned.fill(child: ExplosionConfeti(key: ValueKey('esc$_i'))),
      ],
    );
  }
}

// ===========================================================================
// Pantalla final: insignia "Explorador del Cuerpo Humano"
// ===========================================================================

class PantallaInsigniaFinal extends StatelessWidget {
  const PantallaInsigniaFinal({super.key});
  @override
  Widget build(BuildContext context) {
    final p = ProgresoScope.of(context);
    final nombre = ConfiguracionJuego.of(context).nombreAlumno;
    return Escenario(
      velo: 0.25,
      colorVelo: const Color(0xFF3B2A6B),
      children: [
        const Positioned.fill(child: LluviaConfeti(cantidad: 80)),
        const Positioned(
            left: 230,
            top: 6,
            child: BannerTitulo('¡Completaste el Tema 1!',
                tam: 26, color: Color(0xFFFF8A00))),
        const Positioned(
            left: 20,
            top: 150,
            child: SizedBox(
                width: 200, height: 300, child: ZatiMascota(tam: 300))),
        Positioned(
          left: 250,
          top: 76,
          width: 360,
          height: 390,
          child: Column(
            children: [
              SizedBox(
                width: 230,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Movimiento(
                      tipo: TipoMovimiento.girar,
                      intensidad: 0.3,
                      child: SizedBox(
                          width: 230,
                          height: 230,
                          child: CustomPaint(painter: _PintorRayos())),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) =>
                          Transform.scale(scale: v, child: child),
                      child: const SizedBox(
                          width: 170,
                          height: 200,
                          child: CustomPaint(painter: _PintorMedalla())),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFC107), width: 4),
                ),
                child: Column(
                  children: [
                    Text(
                        '${nombre == null || nombre.isEmpty ? 'Ganaste' : '$nombre, ganaste'} la insignia',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    const Text('Explorador del Cuerpo Humano',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE67E00))),
                    Text(
                        '⭐ ${p.totalEstrellas} de ${p.estrellasPosibles} estrellas',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 624,
          top: 90,
          width: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final s in Sistema.values)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: s.color, width: 3)),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: s.color,
                          child: Icon(s.icono, color: Colors.white)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text('Sistema ${s.nombre.toLowerCase()}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700))),
                      const Icon(Icons.check_circle_rounded,
                          color: ColoresJuego.correcto),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Tooltip(
                message: 'Volver a las misiones',
                child: BotonJuego(
                  texto: '¡Terminar!',
                  icono: Icons.emoji_events_rounded,
                  color: const Color(0xFFFF8A00),
                  grande: true,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PintorRayos extends CustomPainter {
  const _PintorRayos();
  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset.zero);
    for (var i = 0; i < 14; i++) {
      final a = i / 14 * 2 * math.pi;
      final p = Path()
        ..moveTo(centro.dx, centro.dy)
        ..lineTo(centro.dx + math.cos(a - 0.12) * s.width / 2,
            centro.dy + math.sin(a - 0.12) * s.width / 2)
        ..lineTo(centro.dx + math.cos(a + 0.12) * s.width / 2,
            centro.dy + math.sin(a + 0.12) * s.width / 2)
        ..close();
      c.drawPath(
          p,
          Paint()
            ..color =
                (i.isEven ? const Color(0xFFFFE082) : const Color(0xFFFFF3C4)));
    }
  }

  @override
  bool shouldRepaint(_PintorRayos old) => false;
}

class _PintorMedalla extends CustomPainter {
  const _PintorMedalla();
  @override
  void paint(Canvas c, Size s) {
    final w = s.width;
    // Listones
    for (final (dx, col) in [
      (-0.18, const Color(0xFFE53950)),
      (0.18, const Color(0xFF00A6FB))
    ]) {
      final p = Path()
        ..moveTo(w * (0.5 + dx) - 18, 0)
        ..lineTo(w * (0.5 + dx) + 18, 0)
        ..lineTo(w * (0.5 + dx * 0.4) + 14, s.height * 0.5)
        ..lineTo(w * (0.5 + dx * 0.4) - 14, s.height * 0.5)
        ..close();
      c.drawPath(p, Paint()..color = col);
    }
    final centro = Offset(w / 2, s.height * 0.62);
    final r = w * 0.36;
    c.drawCircle(centro + const Offset(0, 4), r,
        Paint()..color = const Color(0xFFB8860B));
    c.drawCircle(
        centro,
        r,
        Paint()
          ..shader = const RadialGradient(colors: [
            Color(0xFFFFF59D),
            Color(0xFFFFC107),
            Color(0xFFF57F17)
          ], stops: [
            0,
            0.6,
            1
          ]).createShader(Rect.fromCircle(center: centro, radius: r)));
    c.drawCircle(
        centro, r * 0.8, linea(Colors.white.withValues(alpha: 0.7), 3));
    // Cuerpo humano estilizado en la medalla
    final caja =
        Rect.fromCenter(center: centro, width: r * 0.62, height: r * 1.15);
    c.drawPath(Silueta.ruta(caja), Paint()..color = const Color(0xFFB26A00));
    c.drawCircle(Silueta.punto(caja, const Offset(0.55, 0.32)), r * 0.09,
        Paint()..color = const Color(0xFFE53950));
  }

  @override
  bool shouldRepaint(_PintorMedalla old) => false;
}
