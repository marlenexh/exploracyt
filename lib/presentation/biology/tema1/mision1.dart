import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'contenido.dart';
import 'dibujos_m1.dart';
import 'escenario.dart';
import 'escenas_3d.dart';
import 'misiones.dart';
import 'motor_3d.dart';
import 'pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'progreso.dart';

/// Pantallas de la Misión 1 "¡El corazón en acción!" según los bocetos:
/// cuerpohumano → sistemacirculatorio_explicacion1 → vasos_sanguineos →
/// circulacion → video → laboratorio (3D + reto + dato) → mini misión.

int _estrellasExploracion(int vistos, int total) =>
    vistos >= total ? 3 : (vistos * 2 >= total ? 2 : 1);

Future<void> _terminarPaso(
  BuildContext context, {
  required String actividad,
  required int estrellas,
  required String titulo,
  required String mensaje,
}) async {
  await otorgarEstrellas(
    context,
    actividad: actividad,
    estrellas: estrellas,
    titulo: titulo,
    mensaje: mensaje,
  );
  if (context.mounted) Navigator.of(context).pop();
}

// ===========================================================================
// 1. El cuerpo humano (boceto "cuerpohumano")
// ===========================================================================

class PantallaCuerpoHumano extends StatefulWidget {
  const PantallaCuerpoHumano({super.key});
  @override
  State<PantallaCuerpoHumano> createState() => _PantallaCuerpoHumanoState();
}

class _PantallaCuerpoHumanoState extends State<PantallaCuerpoHumano> {
  int _pestana = 0;
  final _vistas = <int>{0};
  final _partesVistas = <String>{};

  static const _textos = [
    'Nuestro cuerpo es una máquina impresionante, formada por órganos que trabajan en equipo en distintos sistemas.',
    'Cada sistema tiene un trabajo especial: unos nos ayudan a respirar, otros a repartir la sangre y otros a defendernos. ¡Gracias a ellos podemos crecer, jugar y aprender!',
    'Todo está conectado: los pulmones toman el oxígeno del aire, el corazón lo reparte con la sangre y las defensas cuidan que no entren microbios.',
    'Cuando corres, respiras más rápido y tu corazón late más fuerte. Si te raspas la rodilla, ¡tus defensas trabajan para que sane!',
  ];

  // (id, título, subtítulo, color, punto en la silueta, izquierda?)
  static const _partes = [
    (
      'nariz',
      'Nariz',
      '(entrada del aire)',
      ColoresJuego.respiratorio,
      PuntosNino.nariz,
      true,
    ),
    (
      'traquea',
      'Tráquea',
      '(lleva el aire a los pulmones)',
      ColoresJuego.respiratorio,
      PuntosNino.traquea,
      true,
    ),
    (
      'pulmones',
      'Pulmones',
      '(toman oxígeno y eliminan CO₂)',
      ColoresJuego.respiratorio,
      Offset(0.38, 0.25),
      true,
    ),
    (
      'defensas',
      'Defensas',
      '(te protegen de enfermedades)',
      Color(0xFF2DB84C),
      Offset(0.42, 0.55),
      true,
    ),
    (
      'corazon',
      'Corazón',
      '(bombea la sangre por todo el cuerpo)',
      ColoresJuego.circulatorio,
      PuntosNino.corazon,
      false,
    ),
    (
      'arterias',
      'Arterias',
      '(llevan la sangre desde el corazón)',
      rojoArteria,
      PuntosNino.arteriaBrazo,
      false,
    ),
    (
      'venas',
      'Venas',
      '(regresan la sangre al corazón)',
      azulVena,
      Offset(0.66, 0.72),
      false,
    ),
  ];

  static const _detalles = {
    'nariz':
        'Por la nariz entra el aire. Sus pelitos y su moco atrapan el polvo y los microbios.',
    'traquea':
        'Tubo con anillos que lleva el aire de la garganta hasta los pulmones.',
    'pulmones':
        'Se inflan como globos. Ahí el oxígeno pasa a la sangre y sale el dióxido de carbono (CO₂).',
    'defensas':
        'Los glóbulos blancos y los ganglios forman tu sistema inmunológico: ¡un ejército que te cuida!',
    'corazon':
        'Es un músculo del tamaño de tu puño que bombea la sangre sin descansar.',
    'arterias':
        'Tubitos que llevan la sangre con oxígeno desde el corazón a todo el cuerpo.',
    'venas':
        'Tubitos que regresan la sangre al corazón para que vuelva a empezar su viaje.',
  };

  static final _caja = Rect.fromCenter(
    center: const Offset(452, 262),
    width: 380 * Silueta.proporcion,
    height: 380,
  );

  void _irA(int i) => setState(() {
        _pestana = i.clamp(0, 3);
        _vistas.add(_pestana);
      });

  bool _resaltada(String id) => switch (_pestana) {
        3 => id == 'corazon' || id == 'pulmones',
        2 => id == 'pulmones' || id == 'corazon' || id == 'defensas',
        _ => false,
      };

  @override
  Widget build(BuildContext context) {
    final lineas = <(Offset, Offset, Color)>[];
    final etiquetas = <Widget>[];
    var iz = 0, de = 0;
    for (final (id, titulo, sub, color, punto, izquierda) in _partes) {
      final y = izquierda ? 64.0 + iz++ * 88 : 76.0 + de++ * 108;
      final x = izquierda ? 244.0 : 506.0;
      const ancho = 142.0;
      etiquetas.add(
        Positioned(
          left: x,
          top: y,
          child: EtiquetaParte(
            titulo: titulo,
            subtitulo: sub,
            color: color,
            ancho: ancho,
            resaltar: _resaltada(id) || _partesVistas.contains(id),
            icono: _iconoParte(id),
            onTap: () {
              setState(() => _partesVistas.add(id));
              ventanaZati(
                context,
                titulo: titulo,
                texto: _detalles[id]!,
                color: color,
              );
            },
          ),
        ),
      );
      lineas.add((
        Offset(izquierda ? x + ancho : x, y + 24),
        Silueta.punto(_caja, punto),
        color,
      ));
    }
    return Escenario(
      velo: 0.12,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        Positioned.fill(
          child: Reloj(
            builder: (_, t) =>
                CustomPaint(painter: _PintorNinoSistemas(t, _caja)),
          ),
        ),
        Conectores(lineas, animar: _pestana == 2),
        ...etiquetas,
        const BotonVolverEscena(),
        Positioned(
          left: 68,
          top: 12,
          width: 574,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  Pestana(
                    texto: pestanasExplicacion[i].texto,
                    icono: pestanasExplicacion[i].icono,
                    color: pestanasExplicacion[i].color,
                    activa: i == _pestana,
                    vista: _vistas.contains(i),
                    onTap: () => _irA(i),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto: _textos[_pestana],
            tamZati: 196,
            anchoGlobo: 238,
            altoGlobo: 172,
            tamLetra: 15,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 650,
          top: 8,
          width: 204,
          height: 402,
          child: _TresSistemas(resaltar: _pestana == 1),
        ),
        Positioned(
          left: 300,
          top: 436,
          child: PuntosAvance(
            total: 4,
            actual: _pestana,
            onAnterior: _pestana > 0 ? () => _irA(_pestana - 1) : null,
            onSiguiente: _pestana < 3 ? () => _irA(_pestana + 1) : null,
          ),
        ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: () => _terminarPaso(
              context,
              actividad: Actividades.m1Cuerpo,
              estrellas: _estrellasExploracion(
                _vistas.length + _partesVistas.length,
                4 + _partes.length,
              ),
              titulo: '¡Conoces tu cuerpo!',
              mensaje:
                  'Ya sabes que tu cuerpo es un gran equipo de sistemas. ¡Ahora vamos con el sistema circulatorio!',
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconoParte(String id) => switch (id) {
        'corazon' => const IconoVaso(TipoIconoVaso.corazon),
        'arterias' => const IconoVaso(TipoIconoVaso.arteria),
        'venas' => const IconoVaso(TipoIconoVaso.vena),
        'pulmones' || 'traquea' => const IconoOrgano('pulmones', tam: 38),
        'defensas' => const Icon(
            Icons.shield_rounded,
            color: Color(0xFF2DB84C),
            size: 34,
          ),
        _ => const Icon(
            Icons.air_rounded,
            color: ColoresJuego.respiratorio,
            size: 32,
          ),
      };
}

class _PintorNinoSistemas extends CustomPainter {
  _PintorNinoSistemas(this.t, this.caja);
  final double t;
  final Rect caja;
  @override
  void paint(Canvas c, Size s) {
    dibujarNinoCirculatorio(c, caja, t);
    Offset p(Offset f) => Silueta.punto(caja, f);
    final w = caja.width;
    // Vía del aire y pulmones
    c.drawLine(
      p(const Offset(0.5, 0.09)),
      p(const Offset(0.5, 0.2)),
      linea(const Color(0xFF90CAF9), w * 0.05),
    );
    final lp = Rect.fromCenter(
      center: p(const Offset(0.5, 0.25)),
      width: w * 0.5,
      height: w * 0.5,
    );
    c.saveLayer(
      lp.inflate(10),
      Paint()..color = Colors.white.withValues(alpha: 0.75),
    );
    DibujoOrganos.pulmones(c, lp, inflado: (1 - math.cos(t * 1.5)) / 2);
    c.restore();
    corazonAnatomico(
      c,
      Rect.fromCenter(
        center: p(PuntosNino.corazon),
        width: w * 0.24,
        height: w * 0.24,
      ),
      latido:
          math.exp(-math.pow((((t * 1.2) % 1) - 0.15) / 0.07, 2)).toDouble(),
    );
    // Ganglios
    for (final g in const [
      Offset(0.42, 0.14),
      Offset(0.58, 0.14),
      Offset(0.31, 0.2),
      Offset(0.69, 0.2),
      Offset(0.42, 0.55),
      Offset(0.58, 0.55),
    ]) {
      c.drawCircle(
        p(g),
        w * 0.03 * (1 + 0.2 * math.sin(t * 3 + g.dx * 10)),
        Paint()..color = const Color(0x552DB84C),
      );
      c.drawCircle(p(g), w * 0.018, Paint()..color = const Color(0xFF2DB84C));
    }
  }

  @override
  bool shouldRepaint(_PintorNinoSistemas old) => true;
}

class _TresSistemas extends StatelessWidget {
  const _TresSistemas({required this.resaltar});
  final bool resaltar;
  @override
  Widget build(BuildContext context) {
    Widget tarjeta(
      String titulo,
      String texto,
      Color color,
      Widget icono,
      Color fondo,
    ) =>
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: fondo,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: resaltar ? color : Colors.white,
                width: resaltar ? 3 : 2,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 46, height: 46, child: icono),
                const SizedBox(width: 6),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 128,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titulo,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5,
                              color: oscurecer(color, 0.15),
                              height: 1.05,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            texto,
                            style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.15,
                              color: ColoresJuego.texto,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
        color: const Color(0xFF6A3FC8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF3B2A6B), offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Los 3 sistemas clave',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          tarjeta(
            'Sistema respiratorio',
            'Te permite obtener oxígeno del aire.',
            ColoresJuego.respiratorio,
            const IconoOrgano('pulmones', tam: 46),
            const Color(0xFFE3F2FD),
          ),
          tarjeta(
            'Sistema circulatorio',
            'Transporta la sangre, el oxígeno y los nutrientes por todo tu cuerpo.',
            ColoresJuego.circulatorio,
            const IconoVaso(TipoIconoVaso.corazon),
            const Color(0xFFFFEBEE),
          ),
          tarjeta(
            'Sistema inmunológico',
            'Te defiende de microbios que pueden enfermarte.',
            const Color(0xFF2DB84C),
            const Icon(
              Icons.shield_rounded,
              color: Color(0xFF2DB84C),
              size: 42,
            ),
            const Color(0xFFE8F5E9),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// 2. Sistema circulatorio: explicación (boceto "sistemacirculatorio_explicacion1")
// ===========================================================================

class PantallaCirculatorioExplicacion extends StatefulWidget {
  const PantallaCirculatorioExplicacion({super.key});
  @override
  State<PantallaCirculatorioExplicacion> createState() =>
      _PantallaCirculatorioExplicacionState();
}

class _PantallaCirculatorioExplicacionState
    extends State<PantallaCirculatorioExplicacion> {
  int _pestana = 0;
  final _vistas = <int>{0};

  static const _textos = [
    '¡Ahora conozcamos el sistema circulatorio!\n\nEs una red de órganos y vasos que mueve la sangre por todo tu cuerpo para llevar oxígeno y nutrientes y retirar desechos.',
    'Sirve para repartir. La sangre es como un camión de reparto: lleva oxígeno y comida a cada parte del cuerpo y se lleva la basura (los desechos) para que el cuerpo la saque.',
    'El corazón es una bomba: se aprieta y empuja la sangre por las arterias. Después, la sangre regresa por las venas. ¡Cada latido es un empujón!',
    'Puedes sentir a tu corazón trabajar: pon dos dedos en tu muñeca o en tu cuello. Cuando corres o juegas late más rápido, porque tu cuerpo necesita más oxígeno y energía.',
  ];

  void _irA(int i) => setState(() {
        _pestana = i.clamp(0, 3);
        _vistas.add(_pestana);
      });

  @override
  Widget build(BuildContext context) {
    final resaltar = switch (_pestana) {
      1 => 'arterias',
      2 => 'corazon',
      _ => null,
    };
    const rHeart = Rect.fromLTWH(290, 100, 186, 200);
    return Escenario(
      velo: 0.12,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        const BotonVolverEscena(),
        Positioned(
          left: 66,
          top: 10,
          child: Container(
            padding: const EdgeInsets.fromLTRB(6, 4, 16, 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF3D68), Color(0xFFE0284D)],
              ),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(color: Color(0xFF9E1028), offset: Offset(0, 4)),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: ColoresJuego.circulatorio,
                    size: 22,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Sistema circulatorio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 330,
          top: 14,
          width: 524,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                for (var i = 0; i < 4; i++) ...[
                  Pestana(
                    texto: pestanasExplicacion[i].texto,
                    icono: pestanasExplicacion[i].icono,
                    color: pestanasExplicacion[i].color,
                    activa: i == _pestana,
                    vista: _vistas.contains(i),
                    onTap: () => _irA(i),
                  ),
                  const SizedBox(width: 5),
                ],
              ],
            ),
          ),
        ),
        // Corazón grande
        Positioned.fromRect(
          rect: rHeart,
          child: Reloj(
            builder: (_, t) => CustomPaint(
              painter: PintorCorazonAnatomico(
                t,
                resaltar: resaltar,
                bpm: _pestana == 2 ? 100 : 70,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto: _textos[_pestana],
            tamZati: 168,
            anchoGlobo: 162,
            altoGlobo: 300,
            tamLetra: 13.5,
          ),
        ),
        Conectores([
          (
            const Offset(474, 120),
            const Offset(402, 219),
            ColoresJuego.circulatorio,
          ),
          (const Offset(474, 192), const Offset(398, 122), rojoArteria),
          (const Offset(474, 272), const Offset(348, 132), azulVena),
        ], animar: _pestana == 2),
        Positioned(
          left: 474,
          top: 96,
          child: EtiquetaParte(
            titulo: 'Corazón',
            subtitulo: '(bombea la sangre)',
            color: ColoresJuego.circulatorio,
            ancho: 102,
            resaltar: _pestana == 2,
          ),
        ),
        Positioned(
          left: 474,
          top: 170,
          child: EtiquetaParte(
            titulo: 'Arterias',
            subtitulo: '(llevan la sangre desde el corazón)',
            color: rojoArteria,
            ancho: 102,
            resaltar: _pestana == 1,
          ),
        ),
        Positioned(
          left: 474,
          top: 250,
          child: EtiquetaParte(
            titulo: 'Venas',
            subtitulo: '(regresan la sangre al corazón)',
            color: azulVena,
            ancho: 102,
            resaltar: _pestana == 1,
          ),
        ),
        // Tu pulso
        Positioned(
          left: 584,
          top: 62,
          width: 134,
          height: 300,
          child: PanelInfo(
            titulo: 'Tu pulso: la señal de tu corazón',
            icono: Icons.monitor_heart_rounded,
            color: const Color(0xFF8B5CF6),
            resaltar: _pestana == 3,
            child: Reloj(
              builder: (_, t) => Column(
                children: [
                  const Text(
                    'Puedes sentirlo en tu muñeca o en tu cuello.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, height: 1.15),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: CustomPaint(
                          painter: PintorMuneca(t),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'En la muñeca',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1.25,
                        child: CustomPaint(
                          painter: PintorCuello(t),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'En el cuello',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Ejercicio
        Positioned(
          left: 724,
          top: 62,
          width: 132,
          height: 300,
          child: PanelInfo(
            titulo: '¿Cómo cambia con el ejercicio?',
            color: const Color(0xFF00A6FB),
            resaltar: _pestana == 3,
            child: const _CambioEjercicio(),
          ),
        ),
        Positioned(
          left: 290,
          top: 380,
          child: PuntosAvance(
            total: 4,
            actual: _pestana,
            onAnterior: _pestana > 0 ? () => _irA(_pestana - 1) : null,
            onSiguiente: _pestana < 3 ? () => _irA(_pestana + 1) : null,
          ),
        ),
        Positioned(
          left: 680,
          top: 418,
          child: BotonSiguiente(
            onTap: () => _terminarPaso(
              context,
              actividad: Actividades.m1Circulatorio,
              estrellas: _estrellasExploracion(_vistas.length, 4),
              titulo: '¡Sistema circulatorio!',
              mensaje:
                  'Ya sabes qué es, para qué sirve y cómo funciona. ¡Vamos a conocer el corazón y los vasos sanguíneos!',
            ),
          ),
        ),
        Positioned(
          left: 262,
          top: 432,
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              '🔍 Explora las 4 pestañas de arriba: ¿Qué es?, ¿Para qué sirve?, ¿Cómo funciona? y En la vida diaria.',
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _CambioEjercicio extends StatelessWidget {
  const _CambioEjercicio();
  @override
  Widget build(BuildContext context) {
    Widget nino(
      IconData icono,
      String titulo,
      String lpm,
      double bpm,
      Color color,
    ) =>
        Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: aclarar(color, 0.75),
                  ),
                  child: Icon(icono, color: color, size: 38),
                ),
                Reloj(
                  builder: (_, t) {
                    final b = math
                        .pow(math.max(0, math.sin(t * bpm / 60 * math.pi * 2)),
                            8)
                        .toDouble();
                    return Transform.scale(
                      scale: 1 + 0.3 * b,
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: ColoresJuego.circulatorio,
                        size: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
            Text(
              titulo,
              style:
                  const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
            ),
            Text(
              lpm,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: oscurecer(color, 0.1),
              ),
            ),
          ],
        );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            nino(
              Icons.self_improvement_rounded,
              'En reposo',
              '≈ 70 lpm',
              70,
              const Color(0xFF00A6FB),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Color(0xFF2DB84C)),
          ],
        ),
        nino(
          Icons.directions_run_rounded,
          'Después de moverte',
          '≈ 120 lpm',
          120,
          const Color(0xFFFF6B3D),
        ),
        const SizedBox(height: 4),
        const Expanded(
          child: SingleChildScrollView(
            child: Text(
              'Late más rápido porque tu cuerpo necesita más oxígeno.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, height: 1.15),
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// 3. El corazón y los vasos sanguíneos (boceto "vasos_sanguineos")
// ===========================================================================

class PantallaVasosSanguineos extends StatefulWidget {
  const PantallaVasosSanguineos({super.key});
  @override
  State<PantallaVasosSanguineos> createState() =>
      _PantallaVasosSanguineosState();
}

class _PantallaVasosSanguineosState extends State<PantallaVasosSanguineos> {
  int _paso = 0;
  bool _auto = true;
  Timer? _timer;
  final _pasosVistos = <int>{0};
  final _partesVistas = <String>{};
  String? _parteElegida;

  static const _textoZati =
      '¿Qué es? El sistema circulatorio es el conjunto del corazón, los vasos sanguíneos (arterias, venas y capilares) y la sangre.\n\n'
      '¿Para qué sirve? Transporta la sangre por todo el cuerpo para llevar oxígeno y nutrientes, y recoger desechos como el dióxido de carbono.';

  // (parte, color, texto)
  static const _pasos = [
    (
      'corazon',
      ColoresJuego.circulatorio,
      'El corazón se aprieta (late) y empuja la sangre con fuerza.',
    ),
    (
      'arterias',
      rojoArteria,
      'Las arterias (rojas) llevan la sangre con oxígeno desde el corazón hacia todo el cuerpo.',
    ),
    (
      'capilares',
      moradoCapilar,
      'Los capilares son tubitos más delgados que un cabello. Ahí la sangre entrega oxígeno y nutrientes a las células y recoge los desechos.',
    ),
    (
      'venas',
      azulVena,
      'Las venas (azules) regresan la sangre al corazón… ¡y el viaje vuelve a empezar!',
    ),
  ];

  static const _partes = [
    (
      'corazon',
      'Corazón',
      '(bombea la sangre)',
      ColoresJuego.circulatorio,
      TipoIconoVaso.corazon,
      PuntosNino.corazon,
    ),
    (
      'arterias',
      'Arterias',
      '(salen del corazón)',
      rojoArteria,
      TipoIconoVaso.arteria,
      PuntosNino.arteriaBrazo,
    ),
    (
      'capilares',
      'Capilares',
      '(tubitos finísimos)',
      moradoCapilar,
      TipoIconoVaso.capilar,
      PuntosNino.capilaresMano,
    ),
    (
      'venas',
      'Venas',
      '(regresan al corazón)',
      azulVena,
      TipoIconoVaso.vena,
      Offset(0.655, 0.74),
    ),
  ];

  static const _detalles = {
    'corazon':
        'Es el centro del sistema circulatorio. Es un músculo hueco que funciona como bomba: late unas 70 a 110 veces por minuto en un niño en reposo.',
    'arterias':
        'Tienen paredes gruesas y fuertes porque la sangre sale del corazón con mucha fuerza. La más grande se llama aorta.',
    'capilares':
        'Son los vasos más pequeños: unen las arterias con las venas. Sus paredes son tan delgadas que el oxígeno y los nutrientes pasan a las células.',
    'venas':
        'Llevan la sangre de regreso al corazón. Tienen válvulas, como puertitas, para que la sangre no se regrese. ¡Por eso las de tu muñeca se ven azules!',
  };

  static final _caja = Rect.fromCenter(
    center: const Offset(372, 278),
    width: 390 * Silueta.proporcion,
    height: 390,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 4500), (_) {
      if (_auto && mounted) {
        setState(() {
          _paso = (_paso + 1) % 4;
          _pasosVistos.add(_paso);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resaltar = _parteElegida ?? _pasos[_paso].$1;
    final lineas = <(Offset, Offset, Color)>[];
    final etiquetas = <Widget>[];
    for (var i = 0; i < _partes.length; i++) {
      final (id, titulo, sub, color, icono, punto) = _partes[i];
      final y = 88.0 + i * 84;
      lineas.add((Offset(506, y + 22), Silueta.punto(_caja, punto), color));
      etiquetas.add(
        Positioned(
          left: 506,
          top: y,
          child: EtiquetaParte(
            titulo: titulo,
            subtitulo: sub,
            color: color,
            ancho: 130,
            resaltar: resaltar == id,
            icono: IconoVaso(icono),
            onTap: () {
              setState(() {
                _parteElegida = id;
                _partesVistas.add(id);
                _auto = false;
              });
              ventanaZati(
                context,
                titulo: titulo,
                texto: _detalles[id]!,
                color: color,
              );
            },
          ),
        ),
      );
    }
    return Escenario(
      velo: 0.12,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        Positioned.fill(
          child: Reloj(
            builder: (_, t) => CustomPaint(
              painter: PintorNinoCirculatorio(t, _caja, resaltar: resaltar),
            ),
          ),
        ),
        Conectores(lineas),
        ...etiquetas,
        const BotonVolverEscena(),
        const Positioned(
          left: 64,
          top: 14,
          child: EtiquetaSeccion('2. Conoce el corazón y los vasos'),
        ),
        const Positioned(
          left: 360,
          top: 4,
          child: BannerTitulo('El corazón y los vasos sanguíneos', tam: 22),
        ),
        const Positioned(
          left: 2,
          top: 62,
          child: ZatiConGlobo(
            texto: _textoZati,
            tamZati: 150,
            anchoGlobo: 222,
            altoGlobo: 250,
            tamLetra: 14,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 640,
          top: 54,
          width: 214,
          height: 370,
          child: PanelInfo(
            titulo: '¿Cómo funciona?',
            icono: Icons.settings_rounded,
            color: const Color(0xFF8B5CF6),
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
            child: Column(
              children: [
                for (var i = 0; i < 4; i++)
                  Expanded(
                    child: Rebote(
                      escala: 0.97,
                      onTap: () => setState(() {
                        _paso = i;
                        _pasosVistos.add(i);
                        _parteElegida = null;
                        _auto = false;
                      }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: i == _paso
                              ? aclarar(_pasos[i].$2, 0.82)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: i == _paso ? _pasos[i].$2 : Colors.black12,
                            width: i == _paso ? 2.5 : 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: _pasos[i].$2,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                _pasos[i].$3,
                                style: const TextStyle(
                                  fontSize: 12.2,
                                  height: 1.12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 640,
          top: 428,
          child: Row(
            children: [
              BotonRedondo(
                icono: _auto ? Icons.pause_rounded : Icons.play_arrow_rounded,
                tam: 42,
                etiqueta: 'Repetir pasos',
                onTap: () => setState(() {
                  _auto = !_auto;
                  _parteElegida = null;
                }),
              ),
              const SizedBox(width: 8),
              BotonSiguiente(
                onTap: () => _terminarPaso(
                  context,
                  actividad: Actividades.m1Vasos,
                  estrellas: _estrellasExploracion(
                    _pasosVistos.length + _partesVistas.length,
                    8,
                  ),
                  titulo: '¡Experto en vasos sanguíneos!',
                  mensaje:
                      'Corazón, arterias, capilares y venas: ¡ya conoces todo el camino! Ahora veamos el viaje de la sangre.',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// 4. El viaje de la sangre (boceto "circulacion")
// ===========================================================================

class PantallaViajeSangre extends StatefulWidget {
  const PantallaViajeSangre({super.key});
  @override
  State<PantallaViajeSangre> createState() => _PantallaViajeSangreState();
}

class _PantallaViajeSangreState extends State<PantallaViajeSangre>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(seconds: 12))
        ..addListener(() => setState(() {}))
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed) setState(() => _vista = true);
        });
  bool _vista = false;

  static const _textos = [
    'El corazón manda a los pulmones la sangre que ya tiene poco oxígeno.',
    'En los pulmones, la sangre se recarga de oxígeno del aire y suelta el dióxido de carbono. ¡Es el intercambio de gases!',
    'La sangre con oxígeno vuelve al corazón, y él la empuja por las arterias a todo el cuerpo.',
    'Las células toman el oxígeno para tener energía y le dan a la sangre su “basura”: el CO₂. La sangre regresa al corazón por las venas.',
  ];

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  int get _fase =>
      _anim.isAnimating ? (_anim.value * 4).floor().clamp(0, 3) : -1;

  @override
  Widget build(BuildContext context) {
    Widget callout(int i, double left, double top, double ancho, Color color) =>
        Positioned(
          left: left,
          top: top,
          width: ancho,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: _fase == i ? 1.08 : 1,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _fase == i ? color : Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: oscurecer(color, 0.3).withValues(alpha: 0.6),
                    offset: const Offset(0, 4),
                  ),
                  if (_fase == i)
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 14,
                    ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundColor: color,
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _textos[i],
                      style: const TextStyle(fontSize: 13, height: 1.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    return Escenario(
      velo: 0.15,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        Positioned.fill(
          child: Reloj(
            builder: (_, t) => CustomPaint(
              painter: _PintorViaje(t, _anim.isAnimating ? _anim.value : null),
            ),
          ),
        ),
        const BotonVolverEscena(),
        const Positioned(
          left: 64,
          top: 14,
          child: EtiquetaSeccion('3. Viaje de la sangre'),
        ),
        const Positioned(
          left: 330,
          top: 4,
          child: BannerTitulo('El viaje de la sangre', tam: 24),
        ),
        callout(0, 64, 60, 232, azulVena),
        callout(1, 6, 210, 142, ColoresJuego.respiratorio),
        callout(2, 586, 56, 268, rojoArteria),
        callout(3, 712, 176, 142, const Color(0xFF8B5CF6)),
        Positioned(
          left: 56,
          top: 384,
          width: 580,
          child: Container(
            padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A3FC8), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 46,
                  height: 46,
                  child: IconoOrgano('pulmones', tam: 46),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '¡El sistema circulatorio y el respiratorio trabajan en equipo!\n',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Los pulmones meten el oxígeno a la sangre y la sangre lo lleva a tus células. Luego se lleva el CO₂ para que lo saques al respirar.',
                          style: TextStyle(fontSize: 12.5),
                        ),
                      ],
                    ),
                    style: TextStyle(color: Colors.white, height: 1.2),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 660,
          top: 372,
          child: Tooltip(
            message: 'Ver animación',
            child: BotonJuego(
              texto: _anim.isAnimating ? 'Mirando…' : 'Ver animación',
              icono: Icons.movie_filter_rounded,
              color: const Color(0xFFFF8A00),
              onTap: _anim.isAnimating ? null : () => _anim.forward(from: 0),
            ),
          ),
        ),
        Positioned(
          left: 680,
          top: 428,
          child: BotonSiguiente(
            latir: _vista,
            onTap: () => _terminarPaso(
              context,
              actividad: Actividades.m1Viaje,
              estrellas: _vista ? 3 : 2,
              titulo: '¡Qué gran viaje!',
              mensaje: _vista
                  ? 'Seguiste a la sangre por todo su recorrido. ¡Ahora veamos un video!'
                  : 'Tip: presiona “Ver animación” para ganar 3 estrellas.',
            ),
          ),
        ),
      ],
    );
  }
}

class _PintorViaje extends CustomPainter {
  _PintorViaje(this.t, this.anim);
  final double t;
  final double? anim;

  static const _corazon = Rect.fromLTWH(338, 120, 190, 200);
  static const _pulmones = Rect.fromLTWH(150, 150, 150, 150);
  static const _celulas = Rect.fromLTWH(560, 168, 145, 140);

  // Circuito como lista de puntos: corazón → pulmones → corazón → células → corazón
  static final _ruta = <(Offset, double)>[
    (const Offset(400, 175), 0.0), // sale del corazón (sin oxígeno)
    (const Offset(330, 140), 0.0),
    (const Offset(260, 170), 0.0),
    (const Offset(225, 225), 0.5), // pulmones: intercambio
    (const Offset(260, 285), 1.0),
    (const Offset(330, 310), 1.0),
    (const Offset(420, 260), 1.0), // regresa al corazón
    (const Offset(500, 175), 1.0),
    (const Offset(565, 150), 1.0),
    (const Offset(630, 200), 0.5), // células
    (const Offset(620, 290), 0.0),
    (const Offset(540, 320), 0.0),
    (const Offset(450, 290), 0.0), // regresa por las venas
    (const Offset(400, 175), 0.0),
  ];

  Color _color(double ox) => Color.lerp(azulVena, rojoArteria, ox)!;

  @override
  void paint(Canvas c, Size s) {
    // Bucles de flechas
    void bucle(Offset centro, double rx, double ry, bool izquierdo) {
      final r = Rect.fromCenter(center: centro, width: rx * 2, height: ry * 2);
      c.drawArc(
        r,
        math.pi,
        math.pi,
        false,
        linea(izquierdo ? azulVena : rojoArteria, 16),
      );
      c.drawArc(
        r,
        0,
        math.pi,
        false,
        linea(izquierdo ? rojoArteria : azulVena, 16),
      );
      c.drawArc(
        r,
        math.pi,
        math.pi,
        false,
        linea(Colors.white.withValues(alpha: 0.35), 4),
      );
      for (var k = 0; k < 6; k++) {
        final a = (t * 0.6 + k / 6) * math.pi * 2 * (izquierdo ? -1 : 1);
        final p = centro + Offset(math.cos(a) * rx, math.sin(a) * ry);
        c.drawCircle(p, 4, Paint()..color = Colors.white);
      }
    }

    bucle(const Offset(305, 230), 115, 95, true);
    bucle(const Offset(545, 235), 115, 95, false);
    // Pulmones, intercambio de gases y células
    DibujoOrganos.pulmones(c, _pulmones, inflado: (1 - math.cos(t * 1.6)) / 2);
    final inter = RRect.fromRectAndRadius(
      const Rect.fromLTWH(165, 300, 130, 62),
      const Radius.circular(18),
    );
    c.drawRRect(inter, Paint()..color = Colors.white.withValues(alpha: 0.95));
    c.drawRRect(inter, linea(const Color(0xFFB39DDB), 2.5));
    textoEn(
      c,
      'Intercambio de gases',
      const Offset(230, 314),
      tam: 12.5,
      color: const Color(0xFF6A3FC8),
    );
    burbujaGas(c, Offset(195 + 4 * math.sin(t * 2), 342), 13, true);
    textoEn(
      c,
      '⇄',
      const Offset(230, 342),
      tam: 18,
      color: const Color(0xFF6A3FC8),
    );
    burbujaGas(c, Offset(265 - 4 * math.sin(t * 2), 342), 13, false);
    final celulas = RRect.fromRectAndRadius(
      _celulas,
      const Radius.circular(30),
    );
    c.drawRRect(celulas, Paint()..color = const Color(0xFFFFE4EE));
    c.save();
    c.clipRRect(celulas);
    dibujarCelulas(c, _celulas, t);
    c.restore();
    c.drawRRect(celulas, linea(const Color(0xFFD16A9A), 3));
    burbujaGas(c, const Offset(585, 190), 15, true);
    burbujaGas(c, Offset(560, 320 + 3 * math.sin(t * 3)), 15, false);
    textoEn(
      c,
      'Células del cuerpo',
      const Offset(632, 160),
      tam: 12,
      color: const Color(0xFFAD1457),
      fondo: Colors.white,
    );
    // Corazón
    final fase = (t * 1.2) % 1.0;
    corazonAnatomico(
      c,
      _corazon,
      latido: math.exp(-math.pow((fase - 0.15) / 0.07, 2)).toDouble(),
    );

    textoEn(
      c,
      'Corazón (bomba de la sangre)',
      const Offset(433, 96),
      tam: 14,
      color: ColoresJuego.circulatorio,
      fondo: Colors.white,
    );
    // Glóbula viajera durante la animación
    if (anim != null) {
      final total = _ruta.length - 1;
      final pos = anim! * total;
      final i = pos.floor().clamp(0, total - 1);
      final u = pos - i;
      final p = Offset.lerp(_ruta[i].$1, _ruta[i + 1].$1, u)!;
      final ox = _ruta[i].$2 + (_ruta[i + 1].$2 - _ruta[i].$2) * u;
      c.drawCircle(p, 22, Paint()..color = Colors.white.withValues(alpha: 0.5));
      c.drawCircle(p, 16, Paint()..color = _color(ox));
      c.drawCircle(p, 7, Paint()..color = oscurecer(_color(ox), 0.25));
      c.drawCircle(
        p + const Offset(-5, -5),
        2.5,
        Paint()..color = Colors.white,
      );
      c.drawCircle(p + const Offset(5, -5), 2.5, Paint()..color = Colors.white);
      // Gases que entran y salen
      if (i >= 2 && i <= 4) burbujaGas(c, p + const Offset(0, -30), 11, true);
      if (i >= 9 && i <= 11) burbujaGas(c, p + const Offset(0, -30), 11, false);
    }
  }

  @override
  bool shouldRepaint(_PintorViaje old) => true;
}

// ===========================================================================
// 5. Video del tema
// ===========================================================================

class PantallaVideoTema extends StatefulWidget {
  const PantallaVideoTema({
    super.key,
    this.clave = 'circulatorio',
    this.titulo = 'Video: el sistema circulatorio',
  });
  final String clave;
  final String titulo;
  @override
  State<PantallaVideoTema> createState() => _PantallaVideoTemaState();
}

class _PantallaVideoTemaState extends State<PantallaVideoTema> {
  VideoPlayerController? _video;
  bool _cargando = true;
  bool _sinVideo = false;
  bool _visto = false;
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_iniciado) {
      _iniciado = true;
      _cargar(ConfiguracionJuego.of(context).videos[widget.clave]);
    }
  }

  Future<void> _cargar(String? fuente) async {
    if (fuente == null || fuente.isEmpty) {
      setState(() {
        _cargando = false;
        _sinVideo = true;
      });
      return;
    }
    if (!fuente.startsWith('http')) {
      try {
        final manifiesto = await AssetManifest.loadFromAssetBundle(rootBundle);
        if (!manifiesto.listAssets().contains(fuente)) {
          throw StateError('sin video');
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _cargando = false;
            _sinVideo = true;
          });
        }
        return;
      }
    }
    final ctrl = fuente.startsWith('http')
        ? VideoPlayerController.networkUrl(Uri.parse(fuente))
        : VideoPlayerController.asset(fuente);
    try {
      await ctrl.initialize().timeout(const Duration(seconds: 20));
      ctrl.addListener(() {
        final v = ctrl.value;
        if (!_visto &&
            v.duration > Duration.zero &&
            v.position.inMilliseconds >= v.duration.inMilliseconds * 0.8) {
          setState(() => _visto = true);
        } else if (mounted) {
          setState(() {});
        }
      });
      if (!mounted) {
        ctrl.dispose();
        return;
      }
      setState(() {
        _video = ctrl;
        _cargando = false;
      });
    } catch (_) {
      ctrl.dispose();
      if (mounted) {
        setState(() {
          _cargando = false;
          _sinVideo = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _video?.dispose();
    super.dispose();
  }

  String _tiempo(Duration d) =>
      '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final v = _video;
    Widget pantalla;
    if (_cargando) {
      pantalla = const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (_sinVideo || v == null) {
      pantalla = Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Movimiento(
              tipo: TipoMovimiento.flotar,
              child: Icon(
                Icons.movie_creation_rounded,
                size: 80,
                color: Color(0xFFFFD54F),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Aquí va el video del tema',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Docente: agrega un video en assets/videos/ o una dirección de internet con el parámetro '
              '“videos: {\'${widget.clave}\': …}” de CuerpoHumanoJuego.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 13.5),
            ),
          ],
        ),
      );
    } else {
      final val = v.value;
      pantalla = Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: val.aspectRatio,
              child: VideoPlayer(v),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(
                      val.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: () => val.isPlaying ? v.pause() : v.play(),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: const Icon(Icons.replay_rounded),
                    onPressed: () => v.seekTo(Duration.zero),
                  ),
                  Expanded(
                    child: VideoProgressIndicator(
                      v,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Color(0xFFFF3D68),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_tiempo(val.position)} / ${_tiempo(val.duration)}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (!val.isPlaying && val.position == Duration.zero)
            Center(
              child: BotonRedondo(
                icono: Icons.play_arrow_rounded,
                tam: 80,
                color: const Color(0xFFFF3D68),
                onTap: v.play,
              ),
            ),
        ],
      );
    }
    final puedeSeguir = _visto || _sinVideo;
    return Escenario(
      velo: 0.2,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        const BotonVolverEscena(),
        const Positioned(
          left: 64,
          top: 14,
          child: EtiquetaSeccion('4. Video del tema'),
        ),
        Positioned(
          left: 300,
          top: 4,
          child: BannerTitulo(widget.titulo, tam: 22),
        ),
        const Positioned(
          left: 0,
          top: 80,
          child: ZatiConGlobo(
            texto:
                '¡Hora del cine científico! 🎬\n\nMira este video para repasar cómo viaja la sangre por tu cuerpo. ¡Pon mucha atención!',
            tamZati: 170,
            anchoGlobo: 200,
            altoGlobo: 190,
            tamLetra: 15,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 270,
          top: 64,
          width: 576,
          height: 340,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B1446),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x88000000),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: pantalla,
          ),
        ),
        Positioned(
          left: 660,
          top: 420,
          child: BotonSiguiente(
            latir: puedeSeguir,
            texto: _sinVideo ? 'Continuar' : 'Siguiente',
            onTap: puedeSeguir
                ? () => _terminarPaso(
                      context,
                      actividad: Actividades.m1Video,
                      estrellas: _sinVideo ? 2 : 3,
                      titulo: _sinVideo ? '¡Seguimos!' : '¡Video completado!',
                      mensaje:
                          '¡Ahora a experimentar en el laboratorio del corazón!',
                    )
                : null,
          ),
        ),
        if (!puedeSeguir && !_cargando)
          const Positioned(
            left: 300,
            top: 428,
            child: Text(
              'Mira el video hasta el final para continuar.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4)],
              ),
            ),
          ),
      ],
    );
  }
}

// ===========================================================================
// 6. Laboratorio del corazón: 3D + reto + dato interesante
// ===========================================================================

/// Pulsos medidos en el laboratorio (se comparten entre las actividades).
class _DatosPulso {
  static int? pulso;
  static int? reposo;
}

class PantallaLabCorazon extends StatefulWidget {
  const PantallaLabCorazon({super.key});
  @override
  State<PantallaLabCorazon> createState() => _PantallaLabCorazonState();
}

class _PantallaLabCorazonState extends State<PantallaLabCorazon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reloj = AnimationController(
    vsync: this,
    duration: const Duration(days: 1),
  );
  final _cache = CacheSeleccion();
  late final Escena3D _escena = escenaPartesCorazon(
    separar: () => _separar,
    bpm: () => 60,
  );
  double _t = 0, _ultimo = 0, _yaw = 0.3, _pitch = 0.05, _separar = 0.5;
  bool _autoGiro = true, _nombres = true;
  String? _sel;
  final _descubiertas = <String>{};
  final _hechas = <int>{};
  bool _preguntaPrimer = false;

  static const _nombresPartes = {
    'auricula_der': 'Aurícula derecha',
    'auricula_izq': 'Aurícula izquierda',
    'ventriculo_der': 'Ventrículo derecho',
    'ventriculo_izq': 'Ventrículo izquierdo',
    'valvulas': 'Válvulas',
    'tabique': 'Tabique',
    'aorta': 'Aorta',
    'pulmonar': 'Arteria pulmonar',
    'cavas': 'Venas cavas',
    'venas_pulmonares': 'Venas pulmonares',
  };

  @override
  void initState() {
    super.initState();
    _reloj.addListener(() {
      final ahora = (_reloj.lastElapsedDuration?.inMicroseconds ?? 0) / 1e6;
      final dt = (ahora - _ultimo).clamp(0.0, 0.1);
      _ultimo = ahora;
      _t += dt;
      if (_autoGiro) _yaw += dt * 0.4;
      setState(() {});
    });
    _reloj.forward();
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  Future<void> _actividad(int i) async {
    final Widget w = switch (i) {
      0 => const PantallaMidePulso(),
      1 => const PantallaRegistraCompara(),
      _ => const PantallaFrecuenciaIdeal(),
    };
    final r = await Navigator.of(context).push<bool>(
      RutaJuego(
        builder: (_) => ProgresoScope(
          progreso: ProgresoScope.read(context),
          child: Theme(data: temaJuego(), child: w),
        ),
      ),
    );
    if (r != null && mounted) {
      setState(() {
        _hechas.add(i);
        if (i == 0 && r) _preguntaPrimer = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _sel == null ? null : infoOrganos[_sel];
    final listo = _hechas.length == 3;
    Widget actividad(
      int i,
      String titulo,
      String sub,
      IconData icono,
      Color color,
    ) =>
        Rebote(
          onTap: () => _actividad(i),
          child: Container(
            height: 62,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [aclarar(color, 0.15), color]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: oscurecer(color, 0.35),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: Colors.white,
                  child: Icon(icono, color: color, size: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                        ),
                      ),
                      Text(
                        sub,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.5,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  _hechas.contains(i)
                      ? Icons.check_circle_rounded
                      : Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        );
    return Escenario(
      velo: 0.18,
      colorVelo: const Color(0xFF3D5AFE),
      children: [
        const BotonVolverEscena(),
        const Positioned(
          left: 64,
          top: 14,
          child: EtiquetaSeccion('5. Laboratorio'),
        ),
        const Positioned(
          left: 260,
          top: 4,
          child: BannerTitulo('Laboratorio del corazón', tam: 24),
        ),
        // Visor 3D
        Positioned(
          left: 10,
          top: 64,
          width: 462,
          height: 406,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTapUp: (d) {
                      final id = _cache.objetoEn(d.localPosition);
                      setState(() {
                        _sel = id;
                        _autoGiro = false;
                        if (id != null) _descubiertas.add(id);
                      });
                    },
                    onPanUpdate: (d) => setState(() {
                      _autoGiro = false;
                      _yaw += d.delta.dx * 0.012;
                      _pitch = (_pitch + d.delta.dy * 0.012).clamp(-1.2, 1.2);
                    }),
                    child: CustomPaint(
                      painter: Pintor3D(
                        escena: _escena,
                        t: _t,
                        yaw: _yaw,
                        pitch: _pitch,
                        zoom: 1.05,
                        cache: _cache,
                        seleccionado: _sel,
                        etiquetas: _nombres ? _nombresPartes : const {},
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Partes descubiertas: ${_descubiertas.length}/${_nombresPartes.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Column(
                    children: [
                      BotonRedondo(
                        icono: _autoGiro
                            ? Icons.pause_rounded
                            : Icons.threesixty_rounded,
                        tam: 40,
                        etiqueta: 'Girar',
                        color: const Color(0xFF4361EE),
                        onTap: () => setState(() => _autoGiro = !_autoGiro),
                      ),
                      const SizedBox(height: 6),
                      BotonRedondo(
                        icono: _nombres
                            ? Icons.label_rounded
                            : Icons.label_off_rounded,
                        tam: 40,
                        etiqueta: 'Nombres',
                        color: const Color(0xFF4361EE),
                        onTap: () => setState(() => _nombres = !_nombres),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.open_with_rounded,
                              size: 18,
                              color: Color(0xFF4361EE),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Separar partes',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                              ),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context)
                                    .copyWith(trackHeight: 6),
                                child: Slider(
                                  value: _separar,
                                  onChanged: (v) =>
                                      setState(() => _separar = v),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          info == null
                              ? 'Gira el corazón con tu dedo y toca cada parte para saber qué hace.'
                              : '${info.nombre}: ${info.descripcion}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12.5, height: 1.15),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Actividades
        Positioned(
          left: 484,
          top: 64,
          width: 370,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              actividad(
                0,
                'Reto interactivo: Mide tu pulso',
                'Siente tu corazón y responde la pregunta',
                Icons.play_arrow_rounded,
                const Color(0xFF8B5CF6),
              ),
              const SizedBox(height: 8),
              actividad(
                1,
                'Registra y compara',
                'Antes y después del movimiento',
                Icons.assignment_rounded,
                const Color(0xFFF5A700),
              ),
              const SizedBox(height: 8),
              actividad(
                2,
                'Descubre tu frecuencia cardiaca ideal',
                '¿Cuántos latidos son normales para tu edad?',
                Icons.monitor_heart_rounded,
                const Color(0xFFFF3D68),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFFFC107),
                    width: 2.5,
                  ),
                ),
                child: const Row(
                  children: [
                    Movimiento(
                      tipo: TipoMovimiento.latir,
                      child: Text('💡', style: TextStyle(fontSize: 30)),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Dato interesante: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  'en un solo día tu corazón late unas 100,000 veces y bombea más de 7,000 litros de sangre. ¡Eso llenaría unas 35 tinas de baño!',
                            ),
                          ],
                        ),
                        style: TextStyle(fontSize: 13, height: 1.2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 484,
          top: 424,
          child: Text(
            listo
                ? '¡Completaste las 3 actividades!'
                : 'Actividades: ${_hechas.length}/3',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 4)],
            ),
          ),
        ),
        Positioned(
          left: 690,
          top: 418,
          child: BotonSiguiente(
            latir: listo,
            onTap: listo
                ? () => _terminarPaso(
                      context,
                      actividad: Actividades.m1Lab,
                      estrellas: 1 +
                          (_descubiertas.length >= 5 ? 1 : 0) +
                          (_preguntaPrimer ? 1 : 0),
                      titulo: '¡Laboratorio completado!',
                      mensaje:
                          'Conociste las partes del corazón y mediste tu propio pulso. ¡Ahora la mini misión final!',
                    )
                : null,
          ),
        ),
      ],
    );
  }
}

/// Mide el pulso tocando el corazón en cada latido durante 15 segundos.
class MedidorPulso extends StatefulWidget {
  const MedidorPulso({
    super.key,
    required this.onResultado,
    this.color = ColoresJuego.circulatorio,
  });
  final ValueChanged<int> onResultado;
  final Color color;
  @override
  State<MedidorPulso> createState() => _MedidorPulsoState();
}

class _MedidorPulsoState extends State<MedidorPulso> {
  int _toques = 0, _restante = 0;
  int? _resultado;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciar() {
    _timer?.cancel();
    setState(() {
      _toques = 0;
      _restante = 15;
      _resultado = null;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _restante--);
      if (_restante <= 0) {
        t.cancel();
        setState(() => _resultado = _toques * 4);
        widget.onResultado(_toques * 4);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_restante > 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$_restante s · $_toques latidos',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          GestureDetector(
            onTapDown: (_) {
              HapticFeedback.selectionClick();
              setState(() => _toques++);
            },
            child: TweenAnimationBuilder<double>(
              key: ValueKey(_toques),
              tween: Tween(begin: 1.25, end: 1),
              duration: const Duration(milliseconds: 220),
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Icon(
                Icons.favorite_rounded,
                size: 110,
                color: widget.color,
                shadows: const [
                  Shadow(color: Color(0x66000000), offset: Offset(0, 4)),
                ],
              ),
            ),
          ),
          const Text(
            '¡Toca el corazón cada vez que sientas un latido!',
            style: TextStyle(fontSize: 13.5),
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_resultado != null) ...[
          Text(
            '$_toques × 4 = $_resultado',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: widget.color,
            ),
          ),
          const Text(
            'latidos por minuto',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
        ],
        BotonJuego(
          texto: _resultado == null
              ? 'Comenzar a contar (15 s)'
              : 'Medir otra vez',
          icono: Icons.timer_rounded,
          color: widget.color,
          onTap: _iniciar,
        ),
      ],
    );
  }
}

/// Reto interactivo: mide tu pulso + 1 pregunta con opciones.
class PantallaMidePulso extends StatefulWidget {
  const PantallaMidePulso({super.key});
  @override
  State<PantallaMidePulso> createState() => _PantallaMidePulsoState();
}

class _PantallaMidePulsoState extends State<PantallaMidePulso> {
  int? _pulso;
  int? _elegida;
  bool _intento = false, _primer = false;

  static const _pregunta = PreguntaQuiz(
    pregunta: '¿Qué es lo que sientes cuando te tomas el pulso?',
    opciones: [
      'La sangre que el corazón empuja por las arterias',
      'El aire que entra a los pulmones',
      'La comida que viaja al estómago',
    ],
    correcta: 0,
    explicacion:
        'Cada latido empuja la sangre por las arterias. Ese empujón es el pulso que sientes.',
  );

  @override
  Widget build(BuildContext context) {
    final acerto = _elegida == _pregunta.correcta;
    return Escenario(
      velo: 0.2,
      colorVelo: const Color(0xFF8B5CF6),
      children: [
        const BotonVolverEscena(),
        const Positioned(
          left: 240,
          top: 4,
          child: BannerTitulo('Reto interactivo: Mide tu pulso', tam: 22),
        ),
        Positioned(
          left: 14,
          top: 66,
          width: 300,
          height: 400,
          child: PanelInfo(
            titulo: '1. Encuentra tu pulso',
            icono: Icons.touch_app_rounded,
            color: const Color(0xFF8B5CF6),
            child: Reloj(
              builder: (_, t) => Column(
                children: [
                  const Text(
                    'Pon dos dedos (no el pulgar) en tu muñeca o a un lado de tu cuello. Quédate quieto hasta sentir el “tum-tum”.',
                    style: TextStyle(fontSize: 14, height: 1.25),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.25,
                              child: CustomPaint(
                                painter: PintorMuneca(t),
                                size: Size.infinite,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: AspectRatio(
                              aspectRatio: 1.25,
                              child: CustomPaint(
                                painter: PintorCuello(t),
                                size: Size.infinite,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'En la muñeca',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        'En el cuello',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 326,
          top: 66,
          width: 230,
          height: 400,
          child: PanelInfo(
            titulo: '2. Cuenta tus latidos',
            icono: Icons.timer_rounded,
            color: ColoresJuego.circulatorio,
            child: Center(
              child: MedidorPulso(
                onResultado: (v) {
                  setState(() => _pulso = v);
                  _DatosPulso.pulso = v;
                },
              ),
            ),
          ),
        ),
        Positioned(
          left: 568,
          top: 66,
          width: 286,
          height: 400,
          child: PanelInfo(
            titulo: '3. Pregunta del reto',
            icono: Icons.psychology_alt_rounded,
            color: const Color(0xFFFF8A00),
            child: _pulso == null
                ? const Center(
                    child: Text(
                      'Primero mide tu pulso para desbloquear la pregunta. 🔒',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _pregunta.pregunta,
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        for (var i = 0; i < 3; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: BotonOpcion(
                              letra: 'ABC'[i],
                              texto: _pregunta.opciones[i],
                              estado: _elegida == i
                                  ? (i == _pregunta.correcta
                                      ? EstadoOpcion.correcta
                                      : EstadoOpcion.incorrecta)
                                  : EstadoOpcion.normal,
                              onTap: acerto
                                  ? null
                                  : () => setState(() {
                                        if (!_intento &&
                                            i == _pregunta.correcta) {
                                          _primer = true;
                                        }
                                        _intento = true;
                                        _elegida = i;
                                      }),
                            ),
                          ),
                        if (_elegida != null)
                          Text(
                            acerto
                                ? '✅ ${_pregunta.explicacion}'
                                : '🤔 ¡Inténtalo otra vez!',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: acerto
                                  ? ColoresJuego.correcto
                                  : ColoresJuego.incorrecto,
                            ),
                          ),
                        if (acerto) const SizedBox(height: 50),
                      ],
                    ),
                  ),
          ),
        ),
        if (acerto)
          Positioned(
            left: 600,
            top: 414,
            child: BotonJuego(
              texto: 'Terminar reto',
              icono: Icons.check_rounded,
              color: ColoresJuego.correcto,
              onTap: () => Navigator.of(context).pop(_primer),
            ),
          ),
        if (acerto)
          Positioned.fill(child: ExplosionConfeti(key: const ValueKey('reto'))),
      ],
    );
  }
}

/// Registra y compara: pulso en reposo y después del movimiento.
class PantallaRegistraCompara extends StatefulWidget {
  const PantallaRegistraCompara({super.key});
  @override
  State<PantallaRegistraCompara> createState() =>
      _PantallaRegistraComparaState();
}

class _PantallaRegistraComparaState extends State<PantallaRegistraCompara> {
  int _etapa = 0; // 0 reposo, 1 moverse, 2 después, 3 comparar
  int? _reposo = _DatosPulso.reposo, _despues;
  int _segMover = 30;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _moverse() {
    _timer?.cancel();
    setState(() => _segMover = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _segMover--);
      if (_segMover <= 0) {
        t.cancel();
        setState(() => _etapa = 2);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final etapas = ['1. En reposo', '2. ¡Muévete!', '3. Después', '4. Compara'];
    Widget contenido;
    switch (_etapa) {
      case 0:
        contenido = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Siéntate tranquilo un minuto y mide tu pulso en reposo.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            MedidorPulso(
              onResultado: (v) => setState(() {
                _reposo = v;
                _DatosPulso.reposo = v;
              }),
            ),
            if (_reposo != null) ...[
              const SizedBox(height: 8),
              BotonJuego(
                texto: 'Guardar y seguir',
                icono: Icons.arrow_forward_rounded,
                color: const Color(0xFF2DB84C),
                onTap: () => setState(() => _etapa = 1),
              ),
            ],
          ],
        );
      case 1:
        contenido = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Salta en tu lugar o haz sentadillas durante 30 segundos.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Reloj(
              builder: (_, t) {
                final salto = _timer?.isActive == true
                    ? (math.sin(t * 9)).abs() * 26
                    : 0.0;
                return Transform.translate(
                  offset: Offset(0, -salto),
                  child: const Icon(
                    Icons.sports_gymnastics_rounded,
                    size: 90,
                    color: Color(0xFFFF6B3D),
                  ),
                );
              },
            ),
            if (_timer?.isActive == true)
              Text(
                '$_segMover s',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFFF6B3D),
                ),
              )
            else
              BotonJuego(
                texto: '¡Empezar a moverme!',
                icono: Icons.directions_run_rounded,
                color: const Color(0xFFFF6B3D),
                onTap: _moverse,
              ),
            TextButton(
              onPressed: () {
                _timer?.cancel();
                setState(() => _etapa = 2);
              },
              child: const Text('Ya me moví, continuar'),
            ),
          ],
        );
      case 2:
        contenido = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '¡Rápido! Mide tu pulso justo después de moverte.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            MedidorPulso(
              color: const Color(0xFFFF6B3D),
              onResultado: (v) => setState(() {
                _despues = v;
              }),
            ),
            if (_despues != null) ...[
              const SizedBox(height: 8),
              BotonJuego(
                texto: 'Comparar',
                icono: Icons.bar_chart_rounded,
                color: const Color(0xFF2DB84C),
                onTap: () => setState(() => _etapa = 3),
              ),
            ],
          ],
        );
      default:
        final r = _reposo ?? 0, d = _despues ?? 0;
        final subio = d > r;
        contenido = Row(
          children: [
            SizedBox(
              width: 260,
              height: 230,
              child: CustomPaint(
                painter: _PintorComparar(r.toDouble(), d.toDouble()),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subio
                        ? '¡Tu corazón pasó de $r a $d latidos por minuto! Aumentó ${d - r}.'
                        : 'Tu pulso no subió. ¿Te moviste lo suficiente? Puedes intentarlo otra vez.',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Conclusión: al moverte, tus músculos necesitan más oxígeno y energía. Por eso el corazón late más rápido para llevarles más sangre.',
                    style: TextStyle(fontSize: 14.5, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      BotonJuego(
                        texto: 'Repetir',
                        icono: Icons.replay_rounded,
                        color: Colors.blueGrey,
                        onTap: () => setState(() {
                          _etapa = 0;
                          _despues = null;
                        }),
                      ),
                      BotonJuego(
                        texto: 'Terminar',
                        icono: Icons.check_rounded,
                        color: ColoresJuego.correcto,
                        onTap: () => Navigator.of(context).pop(true),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
    }
    return Escenario(
      velo: 0.2,
      colorVelo: const Color(0xFFF5A700),
      children: [
        const BotonVolverEscena(),
        const Positioned(
          left: 220,
          top: 4,
          child: BannerTitulo(
            'Registra y compara',
            tam: 24,
            color: Color(0xFFE08E00),
          ),
        ),
        Positioned(
          left: 70,
          top: 70,
          width: 720,
          child: Row(
            children: [
              for (var i = 0; i < 4; i++)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: i == _etapa
                          ? const Color(0xFFF5A700)
                          : (i < _etapa
                              ? const Color(0xFFFFE6A8)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: Text(
                      etapas[i],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: i == _etapa ? Colors.white : ColoresJuego.texto,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          left: 70,
          top: 122,
          width: 720,
          height: 340,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF5A700), width: 4),
            ),
            child: Center(child: SingleChildScrollView(child: contenido)),
          ),
        ),
      ],
    );
  }
}

class _PintorComparar extends CustomPainter {
  _PintorComparar(this.reposo, this.despues);
  final double reposo, despues;
  @override
  void paint(Canvas c, Size s) {
    final base = s.height - 28;
    c.drawLine(
      Offset(0, base),
      Offset(s.width, base),
      linea(Colors.black26, 2),
    );
    final maximo = math.max(160.0, math.max(reposo, despues) + 20);
    final datos = [
      ('En reposo', reposo, const Color(0xFF00A6FB)),
      ('Después', despues, const Color(0xFFFF6B3D)),
    ];
    for (var i = 0; i < 2; i++) {
      final (nombre, v, color) = datos[i];
      final h = v / maximo * (base - 30);
      final x = s.width * (0.15 + i * 0.45);
      final r = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, base - h, s.width * 0.3, h),
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      );
      c.drawRRect(r, Paint()..color = color);
      textoEn(
        c,
        '${v.round()}',
        Offset(x + s.width * 0.15, base - h - 14),
        tam: 18,
        color: color,
      );
      textoEn(c, nombre, Offset(x + s.width * 0.15, base + 14), tam: 13);
    }
  }

  @override
  bool shouldRepaint(_PintorComparar old) => true;
}

/// Descubre tu frecuencia cardiaca ideal según la edad.
class PantallaFrecuenciaIdeal extends StatefulWidget {
  const PantallaFrecuenciaIdeal({super.key});
  @override
  State<PantallaFrecuenciaIdeal> createState() =>
      _PantallaFrecuenciaIdealState();
}

class _PantallaFrecuenciaIdealState extends State<PantallaFrecuenciaIdeal> {
  int _edad = 11;

  (int, int) get _reposo => _edad >= 13 ? (60, 100) : (70, 110);
  int get _maximo => 220 - _edad;

  @override
  Widget build(BuildContext context) {
    final medido = _DatosPulso.reposo ?? _DatosPulso.pulso;
    final (min, max) = _reposo;
    String comentario;
    if (medido == null) {
      comentario = 'Mide tu pulso en el reto interactivo para compararlo aquí.';
    } else if (medido < min) {
      comentario =
          'Tu medición ($medido) quedó abajo de lo normal. Puede que no hayas contado todos los latidos: ¡inténtalo de nuevo!';
    } else if (medido <= max) {
      comentario =
          '¡Tu pulso ($medido) está dentro de lo normal para tu edad! Tu corazón está trabajando muy bien.';
    } else {
      comentario =
          'Tu medición ($medido) está alta para estar en reposo. ¿Te habías movido? Descansa y mide otra vez.';
    }
    return Escenario(
      velo: 0.2,
      colorVelo: const Color(0xFFFF3D68),
      children: [
        const BotonVolverEscena(),
        const Positioned(
          left: 180,
          top: 4,
          child: BannerTitulo(
            'Tu frecuencia cardiaca ideal',
            tam: 24,
            color: Color(0xFFE0284D),
          ),
        ),
        Positioned(
          left: 20,
          top: 70,
          width: 400,
          height: 390,
          child: PanelInfo(
            titulo: '¿Cuántos años tienes?',
            icono: Icons.cake_rounded,
            color: const Color(0xFFFF3D68),
            child: Column(
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [
                    for (var e = 6; e <= 14; e++)
                      ChoiceChip(
                        label: Text('$e'),
                        selected: e == _edad,
                        selectedColor: const Color(0xFFFFC2D1),
                        onSelected: (_) => setState(() => _edad = e),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: CustomPaint(
                    painter: _PintorMedidor(min, max, _maximo, medido),
                    size: Size.infinite,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 436,
          top: 70,
          width: 418,
          height: 390,
          child: PanelInfo(
            titulo: 'Lo que descubriste',
            icono: Icons.lightbulb_rounded,
            color: const Color(0xFF8B5CF6),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _fila(
                    Icons.self_improvement_rounded,
                    const Color(0xFF2DB84C),
                    'En reposo',
                    'Para un niño de $_edad años lo normal es de $min a $max latidos por minuto.',
                  ),
                  _fila(
                    Icons.directions_run_rounded,
                    const Color(0xFFFF8A00),
                    'Jugando o corriendo',
                    'Puede subir mucho, hasta unos $_maximo latidos por minuto (se calcula como 220 − tu edad).',
                  ),
                  _fila(
                    Icons.monitor_heart_rounded,
                    const Color(0xFFFF3D68),
                    'Tu medición',
                    comentario,
                  ),
                  _fila(
                    Icons.health_and_safety_rounded,
                    const Color(0xFF00A6FB),
                    'Recuerda',
                    'El ejercicio, dormir bien y comer sano mantienen fuerte a tu corazón. Si te sientes mareado o tu corazón late raro, avisa a un adulto.',
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: BotonJuego(
                      texto: '¡Lo descubrí!',
                      icono: Icons.check_rounded,
                      color: ColoresJuego.correcto,
                      onTap: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fila(IconData icono, Color color, String titulo, String texto) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: color,
              child: Icon(icono, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$titulo: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: oscurecer(color, 0.15),
                      ),
                    ),
                    TextSpan(text: texto),
                  ],
                ),
                style: const TextStyle(fontSize: 14, height: 1.25),
              ),
            ),
          ],
        ),
      );
}

class _PintorMedidor extends CustomPainter {
  _PintorMedidor(this.min, this.max, this.maximo, this.medido);
  final int min, max, maximo;
  final int? medido;
  @override
  void paint(Canvas c, Size s) {
    final centro = Offset(s.width / 2, s.height * 0.82);
    final r = math.min(s.width * 0.38, s.height * 0.7);
    const inicio = 40.0, fin = 220.0;
    double ang(num v) =>
        math.pi + (v.clamp(inicio, fin) - inicio) / (fin - inicio) * math.pi;
    final rect = Rect.fromCircle(center: centro, radius: r);
    void zona(num a, num b, Color col) => c.drawArc(
          rect,
          ang(a),
          ang(b) - ang(a),
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = r * 0.22
            ..color = col,
        );
    zona(inicio, min, const Color(0xFF90CAF9));
    zona(min, max, const Color(0xFF66D17A));
    zona(max, maximo, const Color(0xFFFFB74D));
    zona(maximo, fin, const Color(0xFFFF7A7A));
    for (final v in [min, max, maximo]) {
      final a = ang(v);
      textoEn(
        c,
        '$v',
        centro + Offset(math.cos(a), math.sin(a)) * (r * 1.2),
        tam: 12,
      );
    }
    textoEn(
      c,
      'reposo',
      centro +
          Offset(
                math.cos(ang((min + max) / 2)),
                math.sin(ang((min + max) / 2)),
              ) *
              r,
      tam: 11,
      color: Colors.white,
    );
    final v = medido ?? ((min + max) ~/ 2);
    final a = ang(v);
    c.drawLine(
      centro,
      centro + Offset(math.cos(a), math.sin(a)) * r * 0.85,
      linea(const Color(0xFF3B2A6B), 5),
    );
    c.drawCircle(centro, 10, Paint()..color = const Color(0xFF3B2A6B));
    textoEn(
      c,
      medido == null ? 'lpm' : '$medido lpm',
      centro + const Offset(0, -34),
      tam: 16,
      color: const Color(0xFF3B2A6B),
    );
  }

  @override
  bool shouldRepaint(_PintorMedidor old) => true;
}

// ===========================================================================
// 7. Mini misión: une cada parte con su nombre + ¿para qué sirve?
// ===========================================================================

class PantallaMiniMisionCirculatorio extends StatefulWidget {
  const PantallaMiniMisionCirculatorio({super.key});
  @override
  State<PantallaMiniMisionCirculatorio> createState() =>
      _PantallaMiniMisionCirculatorioState();
}

class _PantallaMiniMisionCirculatorioState
    extends State<PantallaMiniMisionCirculatorio>
    with SingleTickerProviderStateMixin {
  // Ranuras: (respuesta correcta, punto del dibujo)
  static const _ranuras = [
    ('venas', PuntosNino.venaCuello),
    ('corazon', PuntosNino.corazon),
    ('arterias', PuntosNino.arteriaBrazo),
    ('capilares', PuntosNino.capilaresMano),
  ];
  static const _nombres = {
    'corazon': 'Corazón',
    'arterias': 'Arterias',
    'venas': 'Venas',
    'capilares': 'Capilares',
  };
  static const _iconos = {
    'corazon': TipoIconoVaso.corazon,
    'arterias': TipoIconoVaso.arteria,
    'venas': TipoIconoVaso.vena,
    'capilares': TipoIconoVaso.capilar,
  };
  static const _preguntas = [
    (
      'corazon',
      PreguntaQuiz(
        pregunta: '¿Para qué sirve el corazón?',
        opciones: [
          'Para bombear la sangre a todo el cuerpo',
          'Para respirar el aire',
          'Para digerir la comida',
        ],
        correcta: 0,
        explicacion:
            'El corazón es una bomba que empuja la sangre sin descansar.',
      ),
    ),
    (
      'arterias',
      PreguntaQuiz(
        pregunta: '¿Para qué sirven las arterias?',
        opciones: [
          'Para regresar la sangre al corazón',
          'Para llevar la sangre con oxígeno desde el corazón al cuerpo',
          'Para defendernos de los microbios',
        ],
        correcta: 1,
        explicacion:
            'Las arterias salen del corazón y reparten la sangre con oxígeno.',
      ),
    ),
    (
      'venas',
      PreguntaQuiz(
        pregunta: '¿Para qué sirven las venas?',
        opciones: [
          'Para llevar aire a los pulmones',
          'Para bombear la sangre',
          'Para regresar la sangre al corazón',
        ],
        correcta: 2,
        explicacion: 'Las venas traen la sangre de regreso al corazón.',
      ),
    ),
    (
      'capilares',
      PreguntaQuiz(
        pregunta: '¿Para qué sirven los capilares?',
        opciones: [
          'Para entregar oxígeno y nutrientes a las células y recoger desechos',
          'Para mover los huesos',
          'Para producir la voz',
        ],
        correcta: 0,
        explicacion:
            'En los capilares la sangre deja oxígeno y nutrientes y recoge los desechos.',
      ),
    ),
  ];

  static final _caja = Rect.fromCenter(
    center: const Offset(300, 298),
    width: 360 * Silueta.proporcion,
    height: 360,
  );

  final List<String?> _colocadas = List.filled(4, null);
  final Set<int> _correctas = {};
  final Set<int> _incorrectas = {};
  int _erroresUnir = 0;
  bool _fase2 = false;
  int _pregunta = 0;
  int? _elegida;
  final Set<int> _intentadas = {};
  int _primerIntento = 0;
  String? _mensaje;
  late final AnimationController _temblor = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  List<String> get _disponibles => [
        for (final id in const ['corazon', 'arterias', 'venas', 'capilares'])
          if (!_colocadas.contains(id)) id,
      ];

  void _comprobar() {
    if (_colocadas.contains(null)) {
      setState(
        () => _mensaje = 'Primero coloca las 4 tarjetas en los recuadros.',
      );
      return;
    }
    final mal = <int>{};
    for (var i = 0; i < 4; i++) {
      if (_colocadas[i] == _ranuras[i].$1) {
        _correctas.add(i);
      } else {
        mal.add(i);
      }
    }
    if (mal.isEmpty) {
      HapticFeedback.mediumImpact();
      setState(() {
        _mensaje = '¡Perfecto! Ahora dime: ¿para qué sirve cada parte?';
        _incorrectas.clear();
      });
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (mounted) setState(() => _fase2 = true);
      });
    } else {
      _erroresUnir++;
      _temblor.forward(from: 0);
      setState(() {
        _incorrectas
          ..clear()
          ..addAll(mal);
        _mensaje = mal.length == 1
            ? 'Casi: 1 tarjeta no está en su lugar. ¡Inténtalo otra vez!'
            : '${mal.length} tarjetas no están en su lugar. ¡Tú puedes!';
      });
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          for (final i in mal) {
            _colocadas[i] = null;
          }
          _incorrectas.clear();
        });
      });
    }
  }

  Future<void> _terminar() async {
    final estrellas =
        1 + (_erroresUnir == 0 ? 1 : 0) + (_primerIntento == 4 ? 1 : 0);
    await _terminarPaso(
      context,
      actividad: Actividades.m1Mini,
      estrellas: estrellas,
      titulo: '¡Mini misión cumplida!',
      mensaje:
          'Uniste cada parte con su nombre y sabes para qué sirve. ¡Eres un experto del sistema circulatorio!',
    );
  }

  Widget _tarjeta(String id, {double tam = 108, bool arrastrando = false}) =>
      Container(
        width: tam,
        height: tam,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            const BoxShadow(color: Color(0x553B2A6B), offset: Offset(0, 4)),
            if (arrastrando)
              const BoxShadow(color: Color(0x553B2A6B), blurRadius: 16),
          ],
        ),
        child: Column(
          children: [
            Expanded(child: IconoVaso(_iconos[id]!)),
            FittedBox(
              child: Text(
                _nombres[id]!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B2A12),
                ),
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final hijos = <Widget>[
      Positioned.fill(
        child: Reloj(
          builder: (_, t) =>
              CustomPaint(painter: PintorNinoCirculatorio(t, _caja)),
        ),
      ),
      Conectores([
        for (var i = 0; i < 4; i++)
          (
            Offset(430, 132.0 + i * 78 + 23),
            Silueta.punto(_caja, _ranuras[i].$2),
            moradoBanner,
          ),
      ], animar: false),
    ];
    for (var i = 0; i < 4; i++) {
      final colocado = _colocadas[i];
      final estado =
          _correctas.contains(i) ? 1 : (_incorrectas.contains(i) ? -1 : 0);
      hijos.add(
        Positioned(
          left: 430,
          top: 132.0 + i * 78,
          child: AnimatedBuilder(
            animation: _temblor,
            builder: (_, child) => Transform.translate(
              offset: Offset(
                estado == -1
                    ? math.sin(_temblor.value * math.pi * 6) *
                        8 *
                        (1 - _temblor.value)
                    : 0,
                0,
              ),
              child: child,
            ),
            child: DragTarget<String>(
              onWillAcceptWithDetails: (_) => !_correctas.contains(i),
              onAcceptWithDetails: (d) => setState(() {
                final anterior = _colocadas.indexOf(d.data);
                if (anterior != -1) _colocadas[anterior] = null;
                _colocadas[i] = d.data;
                _mensaje = null;
              }),
              builder: (context, candidatos, _) => GestureDetector(
                onTap: colocado != null && !_correctas.contains(i)
                    ? () => setState(() => _colocadas[i] = null)
                    : null,
                child: CustomPaint(
                  painter: _PintorRanura(
                    color: estado == 1
                        ? ColoresJuego.correcto
                        : estado == -1
                            ? ColoresJuego.incorrecto
                            : (candidatos.isNotEmpty
                                ? const Color(0xFFFFAA00)
                                : moradoBanner),
                    punteada: colocado == null,
                  ),
                  child: Container(
                    width: 140,
                    height: 46,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colocado == null
                          ? Colors.white.withValues(
                              alpha: candidatos.isNotEmpty ? 0.95 : 0.75,
                            )
                          : (estado == 1
                              ? const Color(0xFFE6F8EA)
                              : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: colocado == null
                        ? const Text(
                            '?',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black26,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: IconoVaso(_iconos[colocado]!),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                _nombres[colocado]!,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (estado == 1)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: ColoresJuego.correcto,
                                  size: 20,
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Tarjetas para arrastrar
    final disponibles = _disponibles;
    hijos.add(
      Positioned(
        left: 600,
        top: 112,
        width: 254,
        height: 280,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE7FF).withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white, width: 3),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final id in disponibles)
                Draggable<String>(
                  data: id,
                  dragAnchorStrategy: pointerDragAnchorStrategy,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Transform.translate(
                      offset: const Offset(-45, -45),
                      child: _tarjeta(id, tam: 90, arrastrando: true),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: _tarjeta(id)),
                  child: _tarjeta(id),
                ),
              if (disponibles.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Text(
                    '¡Todas colocadas!\nPresiona “Comprobar”.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: moradoBanner,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    hijos.addAll([
      const BotonVolverEscena(),
      Positioned(
        left: 300,
        top: 6,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 4, 18, 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF3C77F), Color(0xFFD9A055)],
            ),
            border: Border.all(color: const Color(0xFF8A5A24), width: 3),
            boxShadow: const [
              BoxShadow(color: Color(0xFF6B4219), offset: Offset(0, 4)),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monitor_heart_rounded,
                color: ColoresJuego.circulatorio,
                size: 32,
              ),
              SizedBox(width: 6),
              Text(
                'Sistema circulatorio',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: moradoBanner,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        right: 8,
        top: 8,
        child: BotonRedondo(
          icono: Icons.question_mark_rounded,
          tam: 46,
          etiqueta: 'Ayuda',
          onTap: () => ventanaZati(
            context,
            titulo: '¿Cómo se juega?',
            texto:
                'Arrastra cada tarjeta al recuadro que señala esa parte del cuerpo. Cuando termines presiona “Comprobar”. Pista: las venas son azules, las arterias rojas y los capilares son la redecita de las manos.',
          ),
        ),
      ),
      Positioned(
        left: 260,
        top: 64,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E6),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFF8B5CF6), width: 2),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swipe_rounded, color: moradoBanner),
              SizedBox(width: 8),
              Text(
                'Une cada parte con su nombre.',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: 0,
        top: 290,
        child: SizedBox(
          width: 130,
          height: 185,
          child: ZatiMascota(
            tam: 185,
            emocion: _incorrectas.isNotEmpty
                ? EmocionCora.pensando
                : EmocionCora.feliz,
          ),
        ),
      ),
      if (_mensaje != null)
        Positioned(
          left: 110,
          top: 300,
          width: 170,
          child: GloboTexto(
            child: Text(_mensaje!, style: const TextStyle(fontSize: 13.5)),
          ),
        ),
      Positioned(
        left: 600,
        top: 410,
        child: Tooltip(
          message: 'Comprobar',
          child: BotonJuego(
            texto: 'Comprobar',
            icono: Icons.check_circle_rounded,
            color: const Color(0xFFF5B400),
            grande: true,
            onTap: _fase2 ? null : _comprobar,
          ),
        ),
      ),
    ]);
    if (_fase2) hijos.add(_capaPreguntas());
    return Escenario(velo: 0.05, children: hijos);
  }

  Widget _capaPreguntas() {
    final (id, q) = _preguntas[_pregunta];
    final acerto = _elegida == q.correcta;
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: Entrada(
          key: ValueKey(_pregunta),
          child: Container(
            width: 640,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: moradoBanner, width: 4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: _tarjeta(id, tam: 110),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pregunta ${_pregunta + 1} de 4',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: moradoBanner,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        q.pregunta,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (var i = 0; i < q.opciones.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: BotonOpcion(
                            letra: 'ABC'[i],
                            texto: q.opciones[i],
                            estado: _elegida == i
                                ? (i == q.correcta
                                    ? EstadoOpcion.correcta
                                    : EstadoOpcion.incorrecta)
                                : EstadoOpcion.normal,
                            onTap: acerto
                                ? null
                                : () => setState(() {
                                      if (!_intentadas.contains(_pregunta) &&
                                          i == q.correcta) {
                                        _primerIntento++;
                                      }
                                      _intentadas.add(_pregunta);
                                      _elegida = i;
                                    }),
                          ),
                        ),
                      if (_elegida != null)
                        Text(
                          acerto
                              ? '✅ ${q.explicacion}'
                              : '🤔 ¡Inténtalo otra vez!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: acerto
                                ? ColoresJuego.correcto
                                : ColoresJuego.incorrecto,
                          ),
                        ),
                      if (acerto)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: BotonJuego(
                              texto: _pregunta < 3
                                  ? 'Siguiente pregunta'
                                  : 'Terminar mini misión',
                              icono: Icons.arrow_forward_rounded,
                              color: ColoresJuego.correcto,
                              onTap: () {
                                if (_pregunta < 3) {
                                  setState(() {
                                    _pregunta++;
                                    _elegida = null;
                                  });
                                } else {
                                  _terminar();
                                }
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PintorRanura extends CustomPainter {
  _PintorRanura({required this.color, required this.punteada});
  final Color color;
  final bool punteada;
  @override
  void paint(Canvas c, Size s) {
    final r = RRect.fromRectAndRadius(
      Offset.zero & s,
      const Radius.circular(14),
    );
    if (!punteada) {
      c.drawRRect(
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = color,
      );
      return;
    }
    final path = Path()..addRRect(r);
    for (final m in path.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 12) {
        c.drawPath(
          m.extractPath(d, d + 7),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5
            ..color = color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_PintorRanura old) =>
      old.color != color || old.punteada != punteada;
}
