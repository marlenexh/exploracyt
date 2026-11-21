import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'animaciones_tour.dart'
    show dibujarBacteria, dibujarGloboBlanco, dibujarAnticuerpo;
import 'aventura.dart';
import 'comunes.dart';
import 'componentes.dart';
import 'dibujos_m1.dart' show dibujarCaraNino;
import 'escenario.dart';
import 'progreso.dart';

/// Pantallas de la Misión 3 "¡Defensores del cuerpo!" (sistema inmunológico).

const _verde = Color(0xFF2DB84C);
const _morado = ColoresJuego.inmune;

// ===========================================================================
// Dibujo: niño con las partes del sistema inmunológico
// ===========================================================================

const puntosInmune = {
  'amigdalas': Offset(0.5, 0.118),
  'timo': Offset(0.5, 0.2),
  'ganglios': Offset(0.57, 0.15),
  'vasos': Offset(0.33, 0.4),
  'bazo': Offset(0.64, 0.37),
  'medula': Offset(0.385, 0.74),
  'globulos': Offset(0.8, 0.36),
  'piel': Offset(0.12, 0.5),
  'anticuerpos': Offset(0.2, 0.34),
};

Offset puntoInmune(Rect caja, String id) =>
    Silueta.punto(caja, puntosInmune[id]!);

void dibujarNinoInmune(Canvas c, Rect caja, double t,
    {String? resaltar, bool microbios = false}) {
  final w = caja.width;
  Offset p(double x, double y) => Silueta.punto(caja, Offset(x, y));
  if (resaltar != null && puntosInmune.containsKey(resaltar)) {
    if (resaltar == 'piel') {
      c.drawPath(Silueta.ruta(caja.inflate(4)),
          Paint()..color = const Color(0x66FFEB3B));
    } else {
      c.drawCircle(
          puntoInmune(caja, resaltar),
          w * 0.14 * (1 + 0.08 * math.sin(t * 5)),
          Paint()..color = const Color(0x66FFEB3B));
    }
  }
  Silueta.dibujar(c, caja, borde: const Color(0xFFE0A88A));
  dibujarCaraNino(c, caja, t);
  // Médula ósea: hueso del muslo con su interior rojo
  final hueso = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: p(0.385, 0.74), width: w * 0.07, height: caja.height * 0.17),
      Radius.circular(w * 0.04));
  c.drawRRect(hueso, Paint()..color = const Color(0xFFFFF8E1));
  c.drawRRect(
      hueso.deflate(w * 0.017), Paint()..color = const Color(0xFFE57373));
  c.drawRRect(hueso, linea(const Color(0xFFBCAAA4), 1.5));
  // Vasos linfáticos
  final verdes = linea(const Color(0xFF81C784), w * 0.014);
  final ruta = Path()
    ..moveTo(p(0.43, 0.15).dx, p(0.43, 0.15).dy)
    ..lineTo(p(0.3, 0.2).dx, p(0.3, 0.2).dy)
    ..lineTo(p(0.36, 0.38).dx, p(0.36, 0.38).dy)
    ..lineTo(p(0.42, 0.55).dx, p(0.42, 0.55).dy)
    ..moveTo(p(0.57, 0.15).dx, p(0.57, 0.15).dy)
    ..lineTo(p(0.7, 0.2).dx, p(0.7, 0.2).dy)
    ..lineTo(p(0.64, 0.38).dx, p(0.64, 0.38).dy)
    ..lineTo(p(0.58, 0.55).dx, p(0.58, 0.55).dy)
    ..moveTo(p(0.42, 0.55).dx, p(0.42, 0.55).dy)
    ..lineTo(p(0.4, 0.68).dx, p(0.4, 0.68).dy)
    ..moveTo(p(0.58, 0.55).dx, p(0.58, 0.55).dy)
    ..lineTo(p(0.61, 0.68).dx, p(0.61, 0.68).dy);
  c.drawPath(ruta, verdes);
  // Timo
  final timo = p(0.5, 0.2);
  for (final lado in [-1.0, 1.0]) {
    c.drawOval(
        Rect.fromCenter(
            center: timo + Offset(lado * w * 0.03, 0),
            width: w * 0.06,
            height: w * 0.09),
        Paint()..color = const Color(0xFFCE93D8));
  }
  // Amígdalas
  for (final lado in [-1.0, 1.0]) {
    c.drawOval(
        Rect.fromCenter(
            center: p(0.5, 0.118) + Offset(lado * w * 0.03, 0),
            width: w * 0.035,
            height: w * 0.025),
        Paint()..color = const Color(0xFFF48FB1));
  }
  // Bazo
  c.drawOval(
      Rect.fromCenter(center: p(0.64, 0.37), width: w * 0.1, height: w * 0.065),
      Paint()..color = const Color(0xFF7B1FA2));
  // Ganglios
  for (final g in const [
    Offset(0.43, 0.15),
    Offset(0.57, 0.15),
    Offset(0.3, 0.2),
    Offset(0.7, 0.2),
    Offset(0.42, 0.55),
    Offset(0.58, 0.55)
  ]) {
    c.drawCircle(
        p(g.dx, g.dy),
        w * 0.032 * (1 + 0.15 * math.sin(t * 3 + g.dx * 9)),
        Paint()..color = const Color(0x552DB84C));
    c.drawCircle(p(g.dx, g.dy), w * 0.02, Paint()..color = _verde);
  }
  // Glóbulos blancos patrullando el brazo
  final brazo = [p(0.7, 0.22), p(0.79, 0.35), p(0.87, 0.5)];
  c.drawLine(brazo[0], brazo[1], linea(const Color(0x66E53935), w * 0.03));
  c.drawLine(brazo[1], brazo[2], linea(const Color(0x66E53935), w * 0.03));
  for (var k = 0; k < 2; k++) {
    final u = (t * 0.15 + k * 0.5) % 1;
    final q = u < 0.5
        ? Offset.lerp(brazo[0], brazo[1], u * 2)!
        : Offset.lerp(brazo[1], brazo[2], (u - 0.5) * 2)!;
    dibujarGloboBlanco(c, q, w * 0.04, t);
  }
  // Anticuerpos en el otro brazo
  for (var k = 0; k < 3; k++) {
    final q = p(0.2 + k * 0.025, 0.31 + k * 0.035);
    dibujarAnticuerpo(c, q, w * 0.05, 0.3 + k);
  }
  if (microbios) {
    for (var k = 0; k < 4; k++) {
      final a = t * 0.6 + k * 1.6;
      final d = 1 - ((t * 0.5 + k * 0.25) % 1);
      final q = p(0.5, 0.45) +
          Offset(math.cos(a), math.sin(a)) * (w * (0.75 + 0.35 * d));
      dibujarBacteria(c, q, w * 0.035, a, t);
    }
  }
}

class PintorNinoInmune extends CustomPainter {
  PintorNinoInmune(this.t, this.caja, {this.resaltar, this.microbios = false});
  final double t;
  final Rect caja;
  final String? resaltar;
  final bool microbios;
  @override
  void paint(Canvas c, Size s) =>
      dibujarNinoInmune(c, caja, t, resaltar: resaltar, microbios: microbios);
  @override
  bool shouldRepaint(PintorNinoInmune old) => true;
}

Widget _ic(IconData i, Color c) => Icon(i, color: c, size: 28);

// ===========================================================================
// 1. ¿Qué es el sistema inmunológico? (pestañas)
// ===========================================================================

final _cajaExplicacion = Rect.fromCenter(
    center: const Offset(452, 262),
    width: 380 * Silueta.proporcion,
    height: 380);

class PantallaInmuneExplicacion extends StatelessWidget {
  const PantallaInmuneExplicacion({super.key});
  @override
  Widget build(BuildContext context) {
    final caja = _cajaExplicacion;
    return PantallaExplicacion(
      actividad: Actividades.m3Explicacion,
      seccion: '1. El sistema inmunológico',
      titulo: 'Sistema inmunológico',
      color: _morado,
      textos: const [
        'El sistema inmunológico es el equipo de defensa de tu cuerpo. Lo forman barreras como la piel, órganos como los ganglios y la médula ósea, y células como los glóbulos blancos.',
        'Sirve para protegerte de los microbios (bacterias y virus) que pueden enfermarte, y para ayudar a sanar heridas.',
        'Primero, la piel y el moco evitan que entren los microbios. Si alguno entra, los glóbulos blancos lo atacan y los anticuerpos lo marcan. ¡Y tu cuerpo lo recuerda para la próxima vez!',
        'Cuando te da fiebre o se te inflama una herida, tu sistema inmunológico está trabajando. Las vacunas le enseñan a reconocer microbios sin que te enfermes.',
      ],
      resaltar: const {
        1: {'globulos', 'anticuerpos'},
        2: {'piel', 'globulos', 'anticuerpos'},
        3: {'ganglios'},
      },
      pintor: (t, pestana, sel) =>
          PintorNinoInmune(t, caja, resaltar: sel, microbios: pestana == 2),
      etiquetas: [
        EtiquetaExplicacion(
          id: 'piel',
          titulo: 'Piel y mucosas',
          subtitulo: '(primera barrera)',
          color: const Color(0xFFFF8A00),
          icono: _ic(Icons.back_hand_rounded, const Color(0xFFFF8A00)),
          pos: const Offset(244, 290),
          punto: puntoInmune(caja, 'piel'),
          detalle:
              'La piel sana es como una muralla. El moco de la nariz, las lágrimas y la saliva atrapan y arrastran microbios.',
        ),
        EtiquetaExplicacion(
          id: 'anticuerpos',
          titulo: 'Anticuerpos',
          subtitulo: '(marcan microbios)',
          color: const Color(0xFFFFB300),
          icono: _ic(Icons.call_split_rounded, const Color(0xFFFFB300)),
          pos: const Offset(244, 120),
          punto: puntoInmune(caja, 'anticuerpos'),
          detalle:
              'Proteínas con forma de “Y” que fabrican los linfocitos. Se pegan a un microbio para que los glóbulos blancos lo encuentren.',
        ),
        EtiquetaExplicacion(
          id: 'globulos',
          titulo: 'Glóbulos blancos',
          subtitulo: '(soldados que atacan)',
          color: _morado,
          icono: _ic(Icons.bubble_chart_rounded, _morado),
          pos: const Offset(500, 300),
          punto: puntoInmune(caja, 'globulos'),
          detalle:
              'Células que patrullan tu sangre. Los fagocitos se “comen” a los microbios y los linfocitos fabrican anticuerpos y recuerdan a los invasores.',
        ),
        EtiquetaExplicacion(
          id: 'ganglios',
          titulo: 'Ganglios',
          subtitulo: '(cuarteles de defensa)',
          color: _verde,
          icono: _ic(Icons.hub_rounded, _verde),
          pos: const Offset(500, 70),
          punto: puntoInmune(caja, 'ganglios'),
          detalle:
              'Bolitas en el cuello, las axilas y la ingle donde se reúnen los glóbulos blancos. Por eso se inflaman cuando estás enfermo.',
        ),
      ],
      panel: (pestana) => PanelPuntos(
        titulo: [
          '¿Qué es?',
          '¿Para qué sirve?',
          '¿Cómo funciona?',
          'En la vida diaria'
        ][pestana],
        color: _morado,
        icono: Icons.shield_rounded,
        puntos: const [
          [
            (Icons.shield_rounded, 'Es tu sistema de defensa.'),
            (Icons.groups_rounded, 'Lo forman barreras, órganos y células.'),
            (
              Icons.bloodtype_rounded,
              'Sus células viajan por la sangre y la linfa.'
            ),
          ],
          [
            (Icons.coronavirus_rounded, 'Te protege de bacterias y virus.'),
            (Icons.healing_rounded, 'Ayuda a sanar heridas.'),
            (Icons.memory_rounded, 'Recuerda a los microbios que ya conoce.'),
          ],
          [
            (
              Icons.looks_one_rounded,
              'Barreras: piel, moco, lágrimas y saliva.'
            ),
            (
              Icons.looks_two_rounded,
              'Ataque: los glóbulos blancos destruyen microbios.'
            ),
            (
              Icons.looks_3_rounded,
              'Memoria: los anticuerpos reconocen al invasor.'
            ),
          ],
          [
            (Icons.thermostat_rounded, 'La fiebre ayuda a combatir microbios.'),
            (Icons.vaccines_rounded, 'Las vacunas entrenan tus defensas.'),
            (Icons.wash_rounded, 'Lavarte las manos le ayuda mucho.'),
          ],
        ][pestana],
      ),
      mensajeFinal:
          '¡Ya sabes qué es tu sistema de defensa! Ahora conoce sus partes.',
    );
  }
}

// ===========================================================================
// 2. Las partes del sistema inmunológico
// ===========================================================================

final _cajaPartes = Rect.fromCenter(
    center: const Offset(512, 262),
    width: 380 * Silueta.proporcion,
    height: 380);

class PantallaInmunePartes extends StatelessWidget {
  const PantallaInmunePartes({super.key});
  @override
  Widget build(BuildContext context) {
    final caja = _cajaPartes;
    EtiquetaExplicacion e(String id, String titulo, String sub, Offset pos,
            IconData ic, Color col, String detalle) =>
        EtiquetaExplicacion(
          id: id,
          titulo: titulo,
          subtitulo: sub,
          color: col,
          icono: _ic(ic, col),
          pos: pos,
          punto: puntoInmune(caja, id),
          detalle: detalle,
          ancho: 150,
        );
    return PantallaExplicacion(
      actividad: Actividades.m3Partes,
      seccion: '2. Sus partes',
      titulo: 'Las partes de tus defensas',
      color: _morado,
      conPestanas: false,
      textos: const [
        'Tu sistema inmunológico tiene órganos repartidos por todo el cuerpo. Toca cada etiqueta para conocer qué hace cada parte.',
        '',
        '',
        '',
      ],
      pintor: (t, _, sel) => PintorNinoInmune(t, caja, resaltar: sel),
      etiquetas: [
        e(
            'amigdalas',
            'Amígdalas',
            '(en la garganta)',
            const Offset(244, 62),
            Icons.record_voice_over_rounded,
            const Color(0xFFEC407A),
            'Están al fondo de tu garganta y atrapan microbios que entran por la boca y la nariz.'),
        e(
            'timo',
            'Timo',
            '(en el pecho)',
            const Offset(244, 146),
            Icons.favorite_border_rounded,
            const Color(0xFFAB47BC),
            'Órgano pequeño detrás del esternón. Ahí “entrenan” unos glóbulos blancos llamados linfocitos T. Trabaja mucho en la infancia.'),
        e(
            'vasos',
            'Vasos linfáticos',
            '(caminos de la linfa)',
            const Offset(244, 230),
            Icons.timeline_rounded,
            const Color(0xFF66BB6A),
            'Tubitos que llevan la linfa, un líquido transparente, y transportan glóbulos blancos por todo el cuerpo.'),
        e(
            'medula',
            'Médula ósea',
            '(dentro de los huesos)',
            const Offset(244, 330),
            Icons.construction_rounded,
            const Color(0xFFE53935),
            'Está dentro de huesos como el fémur. ¡Es la fábrica de las células de la sangre, incluidos los glóbulos blancos!'),
        e(
            'ganglios',
            'Ganglios linfáticos',
            '(cuello, axilas, ingle)',
            const Offset(690, 62),
            Icons.hub_rounded,
            _verde,
            'Pequeñas bolitas que filtran la linfa. Ahí se reúnen los glóbulos blancos para atacar a los microbios.'),
        e(
            'bazo',
            'Bazo',
            '(a la izquierda del abdomen)',
            const Offset(690, 160),
            Icons.filter_alt_rounded,
            const Color(0xFF7B1FA2),
            'Filtra la sangre, elimina glóbulos rojos viejos y guarda glóbulos blancos listos para defenderte.'),
        e(
            'globulos',
            'Glóbulos blancos',
            '(viajan en la sangre)',
            const Offset(690, 258),
            Icons.bubble_chart_rounded,
            _morado,
            'Son los soldados del cuerpo. Hay varios tipos: unos se comen a los microbios y otros fabrican anticuerpos.'),
      ],
      mensajeFinal:
          'Conociste los órganos de tus defensas. ¡Ahora veamos cómo atacan a los microbios!',
    );
  }
}

// ===========================================================================
// 4. Hábitos que fortalecen tus defensas y los que ponen en riesgo tu salud
// ===========================================================================

class PantallaHabitosDefensas extends StatelessWidget {
  const PantallaHabitosDefensas({super.key});
  @override
  Widget build(BuildContext context) => const PantallaTarjetas(
        actividad: Actividades.m3Habitos,
        seccion: '4. Hábitos',
        titulo: 'Hábitos y defensas',
        color: _morado,
        textoZati:
            'Lo que haces cada día puede hacer más fuertes tus defensas… o ponerlas en riesgo. Toca cada tarjeta para descubrir por qué.',
        grupos: [
          GrupoTarjetas(
              'Fortalecen tus defensas', _verde, Icons.shield_rounded, [
            TarjetaInfo(Icons.eco_rounded, 'Frutas y verduras',
                'Sus vitaminas, como la C, ayudan a tus glóbulos blancos.'),
            TarjetaInfo(Icons.bedtime_rounded, 'Dormir bien',
                'Mientras duermes tu cuerpo fabrica defensas y se repara.'),
            TarjetaInfo(Icons.directions_run_rounded, 'Hacer ejercicio',
                'Ayuda a que tus defensas circulen por el cuerpo.'),
            TarjetaInfo(Icons.wash_rounded, 'Lavarte las manos',
                'Con agua y jabón eliminas muchos microbios.'),
            TarjetaInfo(Icons.vaccines_rounded, 'Ponerte tus vacunas',
                'Entrenan a tu cuerpo para reconocer microbios peligrosos.'),
            TarjetaInfo(Icons.water_drop_rounded, 'Tomar agua',
                'Mantiene húmedas las mucosas que atrapan microbios.'),
          ]),
          GrupoTarjetas('Ponen en riesgo tu salud', ColoresJuego.incorrecto,
              Icons.warning_rounded, [
            TarjetaInfo(Icons.front_hand_rounded, 'No lavarse las manos',
                'Los microbios pasan de tus manos a tu boca, nariz y ojos.'),
            TarjetaInfo(
                Icons.local_drink_rounded,
                'Compartir vasos y cubiertos',
                'Así se pasan los microbios de una persona a otra.'),
            TarjetaInfo(Icons.nights_stay_rounded, 'Dormir poco',
                'Tus defensas se debilitan y te enfermas más fácil.'),
            TarjetaInfo(Icons.fastfood_rounded, 'Comer mucha comida chatarra',
                'No le da a tu cuerpo las vitaminas que necesita.'),
            TarjetaInfo(Icons.sick_rounded, 'Toser sin taparse',
                'Esparces microbios a tu alrededor. Usa el codo o un pañuelo.'),
            TarjetaInfo(Icons.medication_rounded, 'Tomar medicinas sin receta',
                'Solo un médico sabe qué medicina necesitas.'),
          ]),
        ],
        mensajeFinal: '¡Ya sabes cómo cuidar tus defensas! Hora del video.',
      );
}

// ===========================================================================
// 10. Mini misión: rompecabezas (nombre ↔ función)
// ===========================================================================

const _piezas = [
  ('Piel', 'Barrera que impide la entrada de microbios.'),
  ('Glóbulos blancos', 'Atacan y se “comen” a los microbios.'),
  ('Anticuerpos', 'Marcan a los microbios para destruirlos.'),
  ('Ganglios linfáticos', 'Filtran la linfa y reúnen a los defensores.'),
  ('Médula ósea', 'Fabrica las células de la sangre.'),
  ('Vacunas', 'Entrenan al cuerpo para reconocer microbios.'),
];

const _coloresPiezas = [
  Color(0xFFFF8A00),
  Color(0xFF8B5CF6),
  Color(0xFFFFB300),
  Color(0xFF2DB84C),
  Color(0xFFE53935),
  Color(0xFF00A6FB)
];

class PantallaMiniMisionInmune extends StatefulWidget {
  const PantallaMiniMisionInmune({super.key});
  @override
  State<PantallaMiniMisionInmune> createState() =>
      _PantallaMiniMisionInmuneState();
}

class _PantallaMiniMisionInmuneState extends State<PantallaMiniMisionInmune>
    with SingleTickerProviderStateMixin {
  final _unidas = <int>{};
  int _errores = 0;
  int? _mala;
  String _mensaje =
      'Arrastra cada pieza de función hasta el nombre que le corresponde para armar el rompecabezas.';
  late final List<int> _bandeja = List.generate(_piezas.length, (i) => i)
    ..shuffle(math.Random(11));
  late final AnimationController _temblor = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  static const _yBase = 64.0, _paso = 66.0, _alto = 58.0;

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  void _soltar(int nombre, int funcion) {
    if (nombre == funcion) {
      HapticFeedback.mediumImpact();
      setState(() {
        _unidas.add(nombre);
        _mensaje = _unidas.length == _piezas.length
            ? '¡Armaste todo el rompecabezas! 🎉'
            : '¡Encaja perfecto! Sigue con otra pieza.';
      });
      if (_unidas.length == _piezas.length) {
        Future.delayed(const Duration(milliseconds: 1100), () {
          if (!mounted) return;
          terminarPaso(
            context,
            actividad: Actividades.m3Mini,
            estrellas: _errores == 0 ? 3 : (_errores <= 2 ? 2 : 1),
            titulo: '¡Rompecabezas completo!',
            mensaje:
                'Uniste cada defensor con su función. ¡Tu sistema inmunológico es un gran equipo!',
          );
        });
      }
    } else {
      HapticFeedback.heavyImpact();
      _errores++;
      _temblor.forward(from: 0);
      setState(() {
        _mala = nombre;
        _mensaje = 'Esa pieza no encaja ahí. ¡Prueba con otra!';
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _mala = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final restantes = [
      for (final f in _bandeja)
        if (!_unidas.contains(f)) f
    ];
    return Escenario(
      velo: 0.1,
      colorVelo: _morado,
      children: [
        const BotonVolverEscena(),
        const Positioned(
            left: 64, top: 14, child: EtiquetaSeccion('Mini misión')),
        const Positioned(
            left: 270,
            top: 4,
            child: BannerTitulo('Pon a prueba lo que aprendiste',
                tam: 22, color: _morado)),
        Positioned(
            left: 8,
            top: 66,
            width: 214,
            child: GloboTexto(
                colita: false,
                child: Text(_mensaje,
                    style: const TextStyle(fontSize: 14.5, height: 1.25)))),
        const Positioned(
            left: 20,
            top: 270,
            child: SizedBox(
                width: 150, height: 200, child: ZatiMascota(tam: 200))),
        for (var i = 0; i < _piezas.length; i++) ...[
          Positioned(
            left: 232,
            top: _yBase + i * _paso,
            child: CustomPaint(
              painter: _PintorPieza(
                  color: _unidas.contains(i) ? _coloresPiezas[i] : _morado,
                  perilla: true),
              child: SizedBox(
                width: 170,
                height: _alto,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 22),
                  child: Center(
                    child: Text(_piezas[i].$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            height: 1.05)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 392,
            top: _yBase + i * _paso,
            child: AnimatedBuilder(
              animation: _temblor,
              builder: (_, child) => Transform.translate(
                offset: Offset(
                    _mala == i
                        ? math.sin(_temblor.value * math.pi * 6) *
                            8 *
                            (1 - _temblor.value)
                        : 0,
                    0),
                child: child,
              ),
              child: DragTarget<int>(
                onWillAcceptWithDetails: (_) => !_unidas.contains(i),
                onAcceptWithDetails: (d) => _soltar(i, d.data),
                builder: (context, cand, _) => _unidas.contains(i)
                    ? _piezaFuncion(i, colocada: true)
                    : CustomPaint(
                        painter: _PintorHueco(cand.isNotEmpty
                            ? const Color(0xFFFFAA00)
                            : (_mala == i
                                ? ColoresJuego.incorrecto
                                : Colors.white)),
                        child: SizedBox(
                            key: ValueKey('hueco_$i'),
                            width: 240,
                            height: _alto),
                      ),
              ),
            ),
          ),
        ],
        Positioned(
          left: 646,
          top: 64,
          width: 210,
          height: 400,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _verde, width: 2.5)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final f in restantes)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Draggable<int>(
                        data: f,
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        feedback: Material(
                            color: Colors.transparent,
                            child: Transform.translate(
                                offset: const Offset(-100, -29),
                                child: _piezaFuncion(f, ancho: 200))),
                        childWhenDragging: Opacity(
                            opacity: 0.3, child: _piezaFuncion(f, ancho: 196)),
                        child: _piezaFuncion(f, ancho: 196),
                      ),
                    ),
                  if (restantes.isEmpty)
                    const Padding(
                        padding: EdgeInsets.all(20),
                        child: Icon(Icons.extension_rounded,
                            size: 60, color: _verde)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _piezaFuncion(int f, {bool colocada = false, double ancho = 240}) =>
      CustomPaint(
        painter: _PintorPieza(
            color: colocada ? _coloresPiezas[f] : _verde, perilla: false),
        child: SizedBox(
          width: ancho,
          height: _alto,
          child: Padding(
            padding: const EdgeInsets.only(left: 22, right: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(_piezas[f].$2,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.8,
                          fontWeight: FontWeight.w600,
                          height: 1.1)),
                ),
                if (colocada)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      );
}

/// Pieza de rompecabezas: [perilla] = sobresale a la derecha; si no, tiene la
/// muesca a la izquierda.
class _PintorPieza extends CustomPainter {
  _PintorPieza({required this.color, required this.perilla});
  final Color color;
  final bool perilla;
  @override
  void paint(Canvas c, Size s) {
    final r = s.height * 0.2;
    final cuerpo = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, perilla ? s.width - r * 1.4 : s.width, s.height),
          const Radius.circular(12)));
    Path forma;
    if (perilla) {
      forma = Path.combine(
          PathOperation.union,
          cuerpo,
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(s.width - r * 1.4, s.height / 2), radius: r)));
    } else {
      forma = Path.combine(
          PathOperation.difference,
          cuerpo,
          Path()
            ..addOval(Rect.fromCircle(
                center: Offset(0, s.height / 2), radius: r * 1.05)));
    }
    c.drawPath(forma.shift(const Offset(0, 3)),
        Paint()..color = oscurecer(color, 0.35));
    c.drawPath(forma, Paint()..color = color);
    c.drawPath(forma, linea(Colors.white.withValues(alpha: 0.6), 2));
  }

  @override
  bool shouldRepaint(_PintorPieza old) => old.color != color;
}

class _PintorHueco extends CustomPainter {
  _PintorHueco(this.color);
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final r = s.height * 0.2;
    final forma = Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromRectAndRadius(
              Offset.zero & s, const Radius.circular(12))),
        Path()
          ..addOval(Rect.fromCircle(
              center: Offset(0, s.height / 2), radius: r * 1.05)));
    c.drawPath(forma, Paint()..color = Colors.white.withValues(alpha: 0.55));
    for (final m in forma.computeMetrics()) {
      for (var d = 0.0; d < m.length; d += 12) {
        c.drawPath(m.extractPath(d, d + 7),
            linea(color == Colors.white ? _morado : color, 2.5));
      }
    }
    textoEn(c, '?', s.center(Offset.zero), tam: 20, color: Colors.black26);
  }

  @override
  bool shouldRepaint(_PintorHueco old) => old.color != color;
}
