import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'componentes.dart';
import 'contenido.dart' show PreguntaQuiz;
import 'dibujos_m1.dart';
import 'escenario.dart';
import 'pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'progreso.dart';
import '../../ciencia/barajar.dart';

/// Pantallas de la Misión 2 "¡El viaje del aire!" (sistema respiratorio).

const _azul = ColoresJuego.respiratorio;

// ===========================================================================
// Dibujo del sistema respiratorio (cabeza, vías, pulmones, diafragma)
// ===========================================================================

/// Puntos de las partes, en fracciones del rectángulo del dibujo.
const puntosRespiratorio = {
  'nariz': Offset(0.5, 0.13),
  'faringe': Offset(0.5, 0.235),
  'laringe': Offset(0.5, 0.3),
  'traquea': Offset(0.5, 0.4),
  'bronquios': Offset(0.62, 0.53),
  'bronquiolos': Offset(0.7, 0.66),
  'pulmones': Offset(0.27, 0.7),
  'alveolos': Offset(0.88, 0.8),
  'diafragma': Offset(0.5, 0.95),
};

Offset puntoResp(Rect r, String id) {
  final f = puntosRespiratorio[id]!;
  return Offset(r.left + f.dx * r.width, r.top + f.dy * r.height);
}

void dibujarSistemaRespiratorio(Canvas c, Rect r, double t,
    {double inflado = 0.5, String? resaltar, bool alveolos = true}) {
  final w = r.width, h = r.height;
  Offset p(double x, double y) => Offset(r.left + x * w, r.top + y * h);
  if (resaltar != null && puntosRespiratorio.containsKey(resaltar)) {
    c.drawCircle(
        puntoResp(r, resaltar),
        w * 0.14 * (1 + 0.08 * math.sin(t * 5)),
        Paint()..color = const Color(0x66FFEB3B));
  }
  // Pulmones (incluyen tráquea baja y bronquios)
  final lado = math.min(w * 1.0, h * 0.56) * (0.94 + 0.08 * inflado);
  DibujoOrganos.pulmones(
      c, Rect.fromCenter(center: p(0.5, 0.69), width: lado, height: lado),
      inflado: inflado);
  // Bronquiolos (ramitas)
  final ramita = linea(const Color(0xFFB8455B), w * 0.012);
  for (final lado2 in [-1.0, 1.0]) {
    final b = p(0.5 + lado2 * 0.15, 0.6);
    for (var k = 0; k < 4; k++) {
      final a = math.pi / 2 + lado2 * (0.3 + k * 0.28);
      c.drawLine(
          b,
          b +
              Offset(math.cos(a) * w * 0.12 * lado2.sign * -1,
                  math.sin(a) * w * 0.14),
          ramita);
    }
  }
  // Cabeza
  final cabeza = p(0.5, 0.13);
  final rc = h * 0.105;
  c.drawCircle(cabeza, rc, Paint()..color = ColoresJuego.piel);
  c.drawCircle(cabeza, rc, linea(const Color(0xFFE0A88A), 2));
  c.drawArc(
      Rect.fromCircle(center: cabeza + Offset(0, -rc * 0.1), radius: rc * 1.05),
      math.pi * 1.05,
      math.pi * 0.9,
      true,
      Paint()..color = const Color(0xFF6D3B1F));
  for (final dx in [-0.35, 0.35]) {
    c.drawCircle(cabeza + Offset(dx * rc, -rc * 0.12), rc * 0.1,
        Paint()..color = const Color(0xFF3B2416));
  }
  final nariz = Path()
    ..moveTo(cabeza.dx, cabeza.dy - rc * 0.05)
    ..lineTo(cabeza.dx - rc * 0.16, cabeza.dy + rc * 0.22)
    ..lineTo(cabeza.dx + rc * 0.16, cabeza.dy + rc * 0.22)
    ..close();
  c.drawPath(nariz, Paint()..color = const Color(0xFFF4B393));
  c.drawArc(
      Rect.fromCenter(
          center: cabeza + Offset(0, rc * 0.5),
          width: rc * 0.5,
          height: rc * 0.25),
      0,
      math.pi,
      false,
      linea(const Color(0xFFB0473A), 2));
  // Faringe, laringe y tráquea
  final via = Path()
    ..moveTo(cabeza.dx, cabeza.dy + rc * 0.2)
    ..quadraticBezierTo(
        cabeza.dx + rc * 0.25, p(0.5, 0.235).dy, cabeza.dx, p(0.5, 0.3).dy)
    ..lineTo(cabeza.dx, p(0.5, 0.5).dy);
  c.drawPath(via, linea(const Color(0xFFC5CAE9), w * 0.07));
  c.drawPath(via, linea(const Color(0xFFE8EAF6), w * 0.045));
  for (var i = 0; i < 6; i++) {
    final y = p(0.5, 0.34 + i * 0.025).dy;
    c.drawLine(Offset(cabeza.dx - w * 0.03, y), Offset(cabeza.dx + w * 0.03, y),
        linea(const Color(0xFF9FA8DA), 1.6));
  }
  c.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: p(0.5, 0.3), width: w * 0.12, height: h * 0.04),
          const Radius.circular(6)),
      Paint()..color = const Color(0xFFB39DDB));
  // Diafragma
  final yTop = p(0.5, 0.92 + 0.03 * inflado).dy, yBorde = p(0.5, 0.97).dy;
  final dia = Path()
    ..moveTo(p(0.08, 0).dx, yBorde)
    ..quadraticBezierTo(p(0.5, 0).dx, yTop - h * 0.06, p(0.92, 0).dx, yBorde)
    ..lineTo(p(0.92, 0).dx, yBorde + h * 0.025)
    ..quadraticBezierTo(
        p(0.5, 0).dx, yTop - h * 0.035, p(0.08, 0).dx, yBorde + h * 0.025)
    ..close();
  c.drawPath(dia, Paint()..color = const Color(0xFFC0504D));
  // Alvéolos (lupa)
  if (alveolos) {
    final lupa = puntoResp(r, 'alveolos');
    final rl = w * 0.12;
    c.drawLine(p(0.7, 0.72), lupa, linea(const Color(0xFF7E57C2), 2));
    c.drawCircle(lupa, rl, Paint()..color = Colors.white);
    for (final o in const [
      Offset(-0.35, -0.3),
      Offset(0.3, -0.3),
      Offset(0, 0.05),
      Offset(-0.35, 0.35),
      Offset(0.35, 0.35)
    ]) {
      c.drawCircle(lupa + o * rl, rl * 0.32 * (0.95 + 0.05 * inflado),
          Paint()..color = const Color(0xFFF8BBD0));
      c.drawCircle(
          lupa + o * rl, rl * 0.32, linea(const Color(0xFFEC407A), 1.2));
    }
    c.drawCircle(lupa, rl, linea(const Color(0xFF7E57C2), 3));
  }
}

class PintorRespiratorio extends CustomPainter {
  PintorRespiratorio(this.t, this.r, {this.resaltar, this.periodo = 4.5});
  final double t;
  final Rect r;
  final String? resaltar;
  final double periodo;
  @override
  void paint(Canvas c, Size s) => dibujarSistemaRespiratorio(c, r, t,
      inflado: (1 - math.cos(2 * math.pi * t / periodo)) / 2,
      resaltar: resaltar);
  @override
  bool shouldRepaint(PintorRespiratorio old) => true;
}

Widget _icono(IconData i, Color c) => Icon(i, color: c, size: 28);

// ===========================================================================
// 1. Explicación del sistema respiratorio (pestañas)
// ===========================================================================

const _rExplicacion = Rect.fromLTWH(390, 58, 240, 380);

class PantallaRespiratorioExplicacion extends StatelessWidget {
  const PantallaRespiratorioExplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    EtiquetaExplicacion e(String id, String titulo, String sub, Offset pos,
            IconData ic, String detalle,
            {Color color = _azul}) =>
        EtiquetaExplicacion(
          id: id,
          titulo: titulo,
          subtitulo: sub,
          color: color,
          icono: _icono(ic, color),
          pos: pos,
          punto: puntoResp(_rExplicacion, id),
          detalle: detalle,
          ancho: 140,
        );
    return PantallaExplicacion(
      actividad: Actividades.m2Explicacion,
      seccion: '1. El sistema respiratorio',
      titulo: 'Sistema respiratorio',
      color: _azul,
      textos: const [
        'El sistema respiratorio es el conjunto de órganos que nos permite respirar: la nariz, la faringe, la laringe, la tráquea, los bronquios y los pulmones, con ayuda del diafragma.',
        'Sirve para tomar el oxígeno del aire, que tus células necesitan para tener energía, y para sacar el dióxido de carbono, un desecho que produce tu cuerpo.',
        'Al inhalar, el diafragma baja y los pulmones se llenan de aire. En los alvéolos el oxígeno pasa a la sangre. Al exhalar, el diafragma sube y el aire sale con dióxido de carbono.',
        'Respiras unas 20 veces por minuto sin pensarlo. Al correr respiras más rápido y al dormir más despacio. ¡También usas el aire para hablar, cantar y soplar!',
      ],
      resaltar: const {
        1: {'pulmones', 'alveolos'},
        2: {'diafragma', 'alveolos', 'traquea'},
        3: {'nariz', 'laringe'},
      },
      pintor: (t, pestana, sel) => PintorRespiratorio(t, _rExplicacion,
          resaltar: sel, periodo: pestana == 3 ? 2.5 : 4.5),
      etiquetas: [
        e(
            'nariz',
            'Nariz',
            '(entrada del aire)',
            const Offset(244, 66),
            Icons.air_rounded,
            'El aire entra por la nariz. Sus pelitos y su moco atrapan polvo y microbios, y además lo calientan y humedecen.'),
        e(
            'laringe',
            'Laringe',
            '(aquí está tu voz)',
            const Offset(244, 150),
            Icons.record_voice_over_rounded,
            'En la laringe están las cuerdas vocales: vibran cuando pasa el aire y así produces tu voz.'),
        e(
            'traquea',
            'Tráquea',
            '(tubo con anillos)',
            const Offset(244, 232),
            Icons.linear_scale_rounded,
            'Tubo reforzado con anillos de cartílago que lleva el aire hacia el pecho y no deja que se aplaste.'),
        e(
            'pulmones',
            'Pulmones',
            '(se llenan de aire)',
            const Offset(244, 318),
            Icons.bubble_chart_rounded,
            'Dos órganos esponjosos que se inflan como globos. Ahí ocurre el intercambio de gases.'),
        e(
            'faringe',
            'Faringe',
            '(la garganta)',
            const Offset(660, 78),
            Icons.swap_vert_rounded,
            'Tubo detrás de la nariz y la boca. Por ella pasan el aire y también la comida.'),
        e(
            'bronquios',
            'Bronquios',
            '(dos ramas)',
            const Offset(660, 170),
            Icons.call_split_rounded,
            'La tráquea se divide en dos bronquios, uno para cada pulmón, y se ramifican en bronquiolos.'),
        e(
            'alveolos',
            'Alvéolos',
            '(bolsitas de aire)',
            const Offset(660, 262),
            Icons.scatter_plot_rounded,
            'Millones de bolsitas al final de los bronquiolos. Ahí el oxígeno pasa a la sangre.',
            color: const Color(0xFFEC407A)),
        e(
            'diafragma',
            'Diafragma',
            '(músculo para respirar)',
            const Offset(660, 352),
            Icons.expand_rounded,
            'Músculo con forma de cúpula debajo de los pulmones. Baja al inhalar y sube al exhalar.',
            color: const Color(0xFFC0504D)),
      ],
      mensajeFinal:
          'Ya conoces las partes del sistema respiratorio. ¡Sigamos el viaje del aire!',
    );
  }
}

// ===========================================================================
// 3. El intercambio de gases
// ===========================================================================

class PantallaIntercambioGases extends StatefulWidget {
  const PantallaIntercambioGases({super.key});
  @override
  State<PantallaIntercambioGases> createState() =>
      _PantallaIntercambioGasesState();
}

class _PantallaIntercambioGasesState extends State<PantallaIntercambioGases> {
  int _paso = 0;
  final _vistos = <int>{0};
  int? _respuesta;
  bool _intento = false, _primer = false;

  static const _pasos = [
    (
      'El aire llega',
      'Al inhalar, el aire llega hasta los alvéolos: bolsitas con paredes delgadísimas. Ese aire trae mucho oxígeno (O₂).'
    ),
    (
      'El oxígeno entra',
      'El oxígeno atraviesa la pared del alvéolo y la del capilar, que están pegaditas, y entra a la sangre.'
    ),
    (
      'Los glóbulos lo llevan',
      'Los glóbulos rojos atrapan el oxígeno y se ponen de un rojo brillante. ¡La sangre lo lleva a todo el cuerpo!'
    ),
    (
      'El CO₂ sale',
      'El dióxido de carbono (CO₂) hace el viaje contrario: sale de la sangre al alvéolo, y lo sacas al exhalar.'
    ),
  ];

  static const _pregunta = PreguntaQuiz(
    pregunta: '¿Por qué los gases pasan de un lado a otro?',
    opciones: [
      'Porque se mueven de donde hay más hacia donde hay menos',
      'Porque el estómago los empuja',
      'Porque los huesos los aplastan',
    ],
    correcta: 0,
    explicacion:
        'En el alvéolo hay más oxígeno que en la sangre, así que el oxígeno pasa a la sangre. Con el CO₂ pasa al revés.',
  );

  @override
  Widget build(BuildContext context) {
    final acerto = _respuesta == _pregunta.correcta;
    return Escenario(
      velo: 0.15,
      colorVelo: _azul,
      children: [
        Positioned(
          left: 250,
          top: 60,
          width: 380,
          height: 360,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Reloj(
                builder: (_, t) => CustomPaint(
                    painter: _PintorIntercambio(t, _paso),
                    size: Size.infinite)),
          ),
        ),
        const BotonVolverEscena(),
        const Positioned(
            left: 64,
            top: 14,
            child: EtiquetaSeccion('3. Intercambio de gases')),
        const Positioned(
            left: 330,
            top: 4,
            child: BannerTitulo('¿Cómo se intercambian los gases?', tam: 22)),
        const Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto:
                'En los pulmones ocurre algo increíble: el aire y la sangre cambian gases. Sigue los 4 pasos y mira la animación.',
            tamZati: 170,
            anchoGlobo: 236,
            altoGlobo: 170,
            tamLetra: 14.5,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 640,
          top: 60,
          width: 214,
          height: 250,
          child: PanelInfo(
            titulo: 'Paso ${_paso + 1}: ${_pasos[_paso].$1}',
            icono: Icons.bubble_chart_rounded,
            color: _azul,
            child: Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: Text(_pasos[_paso].$2,
                            style:
                                const TextStyle(fontSize: 14, height: 1.3)))),
                PuntosAvance(
                  total: 4,
                  actual: _paso,
                  onAnterior: _paso > 0 ? () => setState(() => _paso--) : null,
                  onSiguiente: _paso < 3
                      ? () => setState(() {
                            _paso++;
                            _vistos.add(_paso);
                          })
                      : null,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 640,
          top: 318,
          width: 214,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFC107), width: 2),
            ),
            child: const Text(
              '💡 Tienes cientos de millones de alvéolos. Si los extendieras, cubrirían el piso de un salón de clases.',
              style: TextStyle(fontSize: 12.5, height: 1.2),
            ),
          ),
        ),
        if (_vistos.length == 4)
          Positioned(
            left: 250,
            top: 226,
            width: 380,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF8B5CF6), width: 3)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_pregunta.pregunta,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  for (final (posI, i) in ordenOpciones(_pregunta.pregunta, 3).indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BotonOpcion(
                        letra: 'ABC'[posI],
                        texto: _pregunta.opciones[i],
                        estado: _respuesta == i
                            ? (i == _pregunta.correcta
                                ? EstadoOpcion.correcta
                                : EstadoOpcion.incorrecta)
                            : EstadoOpcion.normal,
                        onTap: acerto
                            ? null
                            : () => setState(() {
                                  if (!_intento && i == _pregunta.correcta) {
                                    _primer = true;
                                  }
                                  _intento = true;
                                  _respuesta = i;
                                }),
                      ),
                    ),
                ],
              ),
            ),
          ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: acerto
                ? () => terminarPaso(
                      context,
                      actividad: Actividades.m2Intercambio,
                      estrellas: 2 + (_primer ? 1 : 0),
                      titulo: '¡Intercambio completado!',
                      mensaje:
                          'El oxígeno entra a la sangre y el CO₂ sale al aire. ¡Ahora veamos cómo cambia tu respiración!',
                    )
                : null,
          ),
        ),
        if (!acerto)
          Positioned(
            left: 250,
            top: 432,
            child: Text(
              _vistos.length < 4
                  ? 'Mira los 4 pasos para continuar.'
                  : 'Responde la pregunta para continuar.',
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 4)]),
            ),
          ),
      ],
    );
  }
}

class _PintorIntercambio extends CustomPainter {
  _PintorIntercambio(this.t, this.paso);
  final double t;
  final int paso;
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFFFF5F8));
    // Alvéolo
    final alv = Offset(w * 0.33, h * 0.42);
    final ra = h * 0.27 * (1 + 0.04 * math.sin(t * 1.5));
    c.drawLine(Offset(w * 0.02, h * 0.02), alv + Offset(-ra * 0.6, -ra * 0.6),
        linea(const Color(0xFFF8BBD0), h * 0.1));
    c.drawCircle(alv, ra, Paint()..color = const Color(0xFFFCE4EC));
    c.drawCircle(alv, ra, linea(const Color(0xFFEC407A), paso == 1 ? 5 : 3));
    textoEn(c, 'Alvéolo', alv + Offset(0, -ra - 10),
        tam: 13, color: const Color(0xFFAD1457), fondo: Colors.white);
    // Capilar
    final cap = Rect.fromLTWH(w * 0.66, -10, w * 0.2, h + 20);
    c.drawRRect(RRect.fromRectAndRadius(cap, Radius.circular(w * 0.1)),
        Paint()..color = const Color(0xFFFFCDD2));
    c.drawRRect(RRect.fromRectAndRadius(cap, Radius.circular(w * 0.1)),
        linea(const Color(0xFFE57373), 2));
    textoEn(c, 'Capilar', Offset(cap.center.dx, h * 0.06),
        tam: 13, color: const Color(0xFFC62828), fondo: Colors.white);
    for (var i = 0; i < 5; i++) {
      final y = ((t * 0.12 + i / 5) % 1.0);
      final ox = paso >= 2 ? ((y - 0.15) / 0.6).clamp(0.0, 1.0) : 0.1;
      final rojo =
          Color.lerp(const Color(0xFF7E57C2), const Color(0xFFE53935), ox)!;
      final p = Offset(cap.center.dx, y * h);
      c.drawCircle(p, h * 0.045, Paint()..color = rojo);
      c.drawCircle(p, h * 0.022, Paint()..color = oscurecer(rojo, 0.2));
    }
    // Moléculas
    for (var i = 0; i < 6; i++) {
      final u = (t * 0.35 + i / 6) % 1.0;
      if (paso == 0) {
        final p = Offset.lerp(
            Offset(w * 0.05, h * 0.05),
            alv +
                Offset(
                    math.cos(i * 1.0) * ra * 0.5, math.sin(i * 1.0) * ra * 0.5),
            u)!;
        burbujaGas(c, p, h * 0.03, true);
      } else {
        final o2 = Offset.lerp(alv + Offset(ra * 0.3, -ra * 0.4 + i * 6),
            Offset(cap.center.dx, h * 0.3 + i * 8), u)!;
        burbujaGas(c, o2, h * 0.03, true);
      }
      if (paso >= 3) {
        final co2 = Offset.lerp(Offset(cap.center.dx, h * 0.62 + i * 6),
            alv + Offset(ra * 0.3, ra * 0.3), u)!;
        burbujaGas(c, co2, h * 0.032, false);
      }
    }
    textoEn(c, 'O₂ → sangre', Offset(w * 0.52, h * 0.24),
        tam: 12.5, color: const Color(0xFF1565C0), fondo: Colors.white);
    if (paso >= 3) {
      textoEn(c, 'CO₂ → aire', Offset(w * 0.52, h * 0.78),
          tam: 12.5, color: const Color(0xFF546E7A), fondo: Colors.white);
    }
  }

  @override
  bool shouldRepaint(_PintorIntercambio old) => true;
}

// ===========================================================================
// 4. ¿Cómo cambia tu respiración?
// ===========================================================================

class PantallaComoCambiaRespiracion extends StatefulWidget {
  const PantallaComoCambiaRespiracion({super.key});
  @override
  State<PantallaComoCambiaRespiracion> createState() =>
      _PantallaComoCambiaRespiracionState();
}

class _PantallaComoCambiaRespiracionState
    extends State<PantallaComoCambiaRespiracion> {
  int _sel = 1;
  final _vistas = <int>{1};

  static const _situaciones = [
    (
      Icons.bedtime_rounded,
      'Dormir',
      14,
      'Al dormir tu cuerpo descansa y gasta poca energía: respiras despacio y profundo.'
    ),
    (
      Icons.menu_book_rounded,
      'Leer sentado',
      20,
      'En reposo un niño respira unas 18 a 24 veces por minuto.'
    ),
    (
      Icons.directions_walk_rounded,
      'Caminar',
      26,
      'Tus piernas trabajan y piden más oxígeno: respiras un poco más rápido.'
    ),
    (
      Icons.directions_run_rounded,
      'Correr',
      42,
      'Tus músculos necesitan mucho oxígeno y producen más CO₂: ¡respiras rápido y profundo!'
    ),
    (
      Icons.sentiment_very_dissatisfied_rounded,
      'Un susto',
      32,
      'Cuando te asustas o te emocionas, tu cuerpo se prepara para actuar y respiras más rápido.'
    ),
    (
      Icons.landscape_rounded,
      'Subir una montaña',
      34,
      'En lo alto de una montaña el aire tiene menos oxígeno, así que respiras más veces.'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final (icono, nombre, rpm, texto) = _situaciones[_sel];
    final periodo = 60 / rpm;
    return Escenario(
      velo: 0.15,
      colorVelo: _azul,
      children: [
        const BotonVolverEscena(),
        const Positioned(
            left: 64, top: 14, child: EtiquetaSeccion('4. Tu respiración')),
        const Positioned(
            left: 320,
            top: 4,
            child: BannerTitulo('¿Cómo cambia tu respiración?', tam: 22)),
        const Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto:
                'Tu respiración no siempre es igual: cambia según lo que haces y lo que sientes. ¡Toca cada situación!',
            tamZati: 165,
            anchoGlobo: 236,
            altoGlobo: 160,
            tamLetra: 14.5,
            globoArriba: true,
          ),
        ),
        Positioned(
          left: 250,
          top: 62,
          width: 300,
          height: 360,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: _azul, width: 4)),
            child: Column(
              children: [
                Expanded(
                  child: Reloj(
                    builder: (_, t) => CustomPaint(
                      size: Size.infinite,
                      painter: PintorRespiratorio(
                          t, const Rect.fromLTWH(40, 6, 210, 290),
                          periodo: periodo),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: const BoxDecoration(
                      color: _azul,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(20))),
                  child: Text('🌬️ ≈ $rpm respiraciones por minuto',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 560,
          top: 62,
          width: 294,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var i = 0; i < _situaciones.length; i++)
                Rebote(
                  onTap: () => setState(() {
                    _sel = i;
                    _vistas.add(i);
                  }),
                  child: Container(
                    width: 144,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                      color: i == _sel ? _azul : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: _vistas.contains(i) ? _azul : Colors.black12,
                          width: 2),
                    ),
                    child: Row(
                      children: [
                        Icon(_situaciones[i].$1,
                            color: i == _sel ? Colors.white : _azul, size: 24),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(_situaciones[i].$2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: i == _sel
                                      ? Colors.white
                                      : ColoresJuego.texto)),
                        ),
                        if (_vistas.contains(i) && i != _sel)
                          const Icon(Icons.check_circle_rounded,
                              size: 16, color: ColoresJuego.correcto),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          left: 560,
          top: 250,
          width: 294,
          height: 160,
          child: PanelInfo(
            titulo: nombre,
            icono: icono,
            color: const Color(0xFF8B5CF6),
            child: SingleChildScrollView(
                child: Text(texto,
                    style: const TextStyle(fontSize: 14.5, height: 1.3))),
          ),
        ),
        Positioned(
          left: 250,
          top: 432,
          child: Text(
            'Situaciones vistas: ${_vistas.length}/${_situaciones.length}',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4)]),
          ),
        ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: () => terminarPaso(
              context,
              actividad: Actividades.m2Respiracion,
              estrellas:
                  estrellasPorExploracion(_vistas.length, _situaciones.length),
              titulo: '¡Tu respiración cambia!',
              mensaje:
                  'Respiras más rápido cuando tu cuerpo necesita más oxígeno. ¡Ahora veamos cómo influye el ambiente!',
            ),
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// 5. El ambiente también influye
// ===========================================================================

class PantallaAmbienteRespiracion extends StatelessWidget {
  const PantallaAmbienteRespiracion({super.key});
  @override
  Widget build(BuildContext context) => const PantallaTarjetas(
        actividad: Actividades.m2Ambiente,
        seccion: '5. El ambiente',
        titulo: 'El ambiente también influye',
        color: _azul,
        textoZati:
            'El aire que respiras no siempre está limpio. Lo que hay a tu alrededor puede ayudar o dañar a tus pulmones. Toca cada tarjeta para descubrir cómo.',
        grupos: [
          GrupoTarjetas('Te ayudan a respirar mejor', ColoresJuego.correcto,
              Icons.thumb_up_rounded, [
            TarjetaInfo(Icons.park_rounded, 'Árboles y plantas',
                'Producen oxígeno y limpian el aire. ¡Cuídalos y siembra uno!'),
            TarjetaInfo(Icons.sports_soccer_rounded, 'Jugar al aire libre',
                'En parques con árboles el aire suele estar más limpio.'),
            TarjetaInfo(Icons.window_rounded, 'Ventilar tu casa',
                'Abrir las ventanas cambia el aire y saca el polvo y los microbios.'),
            TarjetaInfo(Icons.smoke_free_rounded, 'Lugares sin humo',
                'Así tus pulmones no reciben sustancias dañinas.'),
          ]),
          GrupoTarjetas('Dañan o dificultan tu respiración',
              ColoresJuego.incorrecto, Icons.warning_rounded, [
            TarjetaInfo(Icons.smoking_rooms_rounded, 'Humo de cigarro',
                'Daña los alvéolos y los bronquios, aunque solo lo respires cerca de alguien.'),
            TarjetaInfo(
                Icons.directions_car_rounded,
                'Humo de autos y fábricas',
                'La contaminación irrita los pulmones y puede causar tos y asma.'),
            TarjetaInfo(Icons.local_fire_department_rounded, 'Quemar basura',
                'El humo de la quema y de los incendios tiene partículas que dañan los pulmones.'),
            TarjetaInfo(Icons.grain_rounded, 'Polvo y polen',
                'Pueden causar estornudos y alergias. Tu nariz los atrapa, ¡por eso estornudas!'),
            TarjetaInfo(Icons.ac_unit_rounded, 'Aire muy frío',
                'Puede irritar la garganta. Cubrir nariz y boca con una bufanda ayuda.'),
            TarjetaInfo(Icons.landscape_rounded, 'Mucha altura',
                'En lo alto de las montañas hay menos oxígeno y te cansas más rápido.'),
          ]),
        ],
        mensajeFinal:
            '¡Ya sabes cómo el ambiente cambia tu respiración! Hora del video.',
      );
}

// ===========================================================================
// Etiquetar un diagrama arrastrando nombres (laboratorio y mini misión)
// ===========================================================================

class Ranura {
  const Ranura(this.id, this.pos, this.punto, {this.numero});
  final String id;

  /// Esquina superior izquierda del recuadro (130×40) en el lienzo.
  final Offset pos;

  /// Punto del dibujo al que apunta.
  final Offset punto;
  final int? numero;
}

/// Ocupa todo el lienzo: dibujo de fondo, recuadros y tarjetas para arrastrar.
class EtiquetarPartes extends StatefulWidget {
  const EtiquetarPartes({
    super.key,
    required this.fondo,
    required this.ranuras,
    required this.nombres,
    required this.bandeja,
    required this.onCompleto,
    this.color = _azul,
  });
  final Widget fondo;
  final List<Ranura> ranuras;
  final Map<String, String> nombres;

  /// Área de la bandeja de tarjetas en el lienzo.
  final Rect bandeja;
  final ValueChanged<int> onCompleto;
  final Color color;
  @override
  State<EtiquetarPartes> createState() => _EtiquetarPartesState();
}

class _EtiquetarPartesState extends State<EtiquetarPartes>
    with SingleTickerProviderStateMixin {
  late final List<String?> _colocadas =
      List.filled(widget.ranuras.length, null);
  final _correctas = <int>{};
  final _malas = <int>{};
  int _errores = 0;
  bool _listo = false;
  late final List<String> _orden = [for (final r in widget.ranuras) r.id]
    ..shuffle(math.Random(7));
  late final AnimationController _temblor = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  void _comprobar() {
    final mal = <int>{};
    for (var i = 0; i < widget.ranuras.length; i++) {
      if (_colocadas[i] == widget.ranuras[i].id) {
        _correctas.add(i);
      } else {
        mal.add(i);
      }
    }
    if (mal.isEmpty) {
      HapticFeedback.mediumImpact();
      setState(() => _listo = true);
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) widget.onCompleto(_errores);
      });
      return;
    }
    _errores++;
    _temblor.forward(from: 0);
    setState(() => _malas
      ..clear()
      ..addAll(mal));
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        for (final i in mal) {
          _colocadas[i] = null;
        }
        _malas.clear();
      });
    });
  }

  Widget _tarjeta(String id, {bool flotando = false}) => Container(
        width: 118,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: widget.color, width: 2),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: flotando ? 0.3 : 0.15),
                blurRadius: flotando ? 12 : 3,
                offset: const Offset(0, 2))
          ],
        ),
        child: TextoSinCortar(widget.nombres[id]!,
            tam: 14.5, alineacion: TextAlign.center, color: ColoresJuego.texto),
      );

  @override
  Widget build(BuildContext context) {
    final disponibles = [
      for (final id in _orden)
        if (!_colocadas.contains(id)) id
    ];
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(child: widget.fondo),
          Conectores([
            for (final r in widget.ranuras)
              (
                r.pos.dx > r.punto.dx
                    ? r.pos + const Offset(0, 20)
                    : r.pos + const Offset(130, 20),
                r.punto,
                widget.color
              ),
          ], animar: false),
          for (var i = 0; i < widget.ranuras.length; i++) _ranura(i),
          Positioned.fromRect(
            rect: widget.bandeja,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.color, width: 2.5),
              ),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final id in disponibles)
                      Draggable<String>(
                        data: id,
                        dragAnchorStrategy: pointerDragAnchorStrategy,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Transform.translate(
                              offset: const Offset(-59, -18),
                              child: _tarjeta(id, flotando: true)),
                        ),
                        childWhenDragging:
                            Opacity(opacity: 0.3, child: _tarjeta(id)),
                        child: _tarjeta(id),
                      ),
                    if (disponibles.isEmpty && !_listo)
                      Tooltip(
                        message: 'Comprobar etiquetas',
                        child: BotonJuego(
                            texto: 'Comprobar',
                            icono: Icons.check_circle_rounded,
                            color: const Color(0xFFF5B400),
                            onTap: _comprobar),
                      ),
                    if (_listo)
                      const Text('¡Todo correcto! 🎉',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: ColoresJuego.correcto)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ranura(int i) {
    final r = widget.ranuras[i];
    final colocado = _colocadas[i];
    final estado = _correctas.contains(i) ? 1 : (_malas.contains(i) ? -1 : 0);
    final color = estado == 1
        ? ColoresJuego.correcto
        : (estado == -1 ? ColoresJuego.incorrecto : widget.color);
    return Positioned(
      left: r.pos.dx,
      top: r.pos.dy,
      child: AnimatedBuilder(
        animation: _temblor,
        builder: (_, child) => Transform.translate(
          offset: Offset(
              estado == -1
                  ? math.sin(_temblor.value * math.pi * 6) *
                      8 *
                      (1 - _temblor.value)
                  : 0,
              0),
          child: child,
        ),
        child: DragTarget<String>(
          onWillAcceptWithDetails: (_) => !_correctas.contains(i),
          onAcceptWithDetails: (d) => setState(() {
            final antes = _colocadas.indexOf(d.data);
            if (antes != -1) _colocadas[antes] = null;
            _colocadas[i] = d.data;
          }),
          builder: (context, candidatos, _) => GestureDetector(
            onTap: colocado != null && !_correctas.contains(i)
                ? () => setState(() => _colocadas[i] = null)
                : null,
            child: Container(
              width: 130,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colocado == null
                    ? Colors.white
                        .withValues(alpha: candidatos.isNotEmpty ? 1 : 0.8)
                    : aclarar(color, 0.85),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        candidatos.isNotEmpty ? const Color(0xFFFFAA00) : color,
                    width: colocado == null ? 2 : 3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (r.numero != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                          radius: 10,
                          backgroundColor: color,
                          child: Text('${r.numero}',
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.white))),
                    ),
                  Flexible(
                    child: Text(
                        colocado == null ? '?' : widget.nombres[colocado]!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: colocado == null
                                ? Colors.black26
                                : ColoresJuego.texto)),
                  ),
                  if (estado == 1)
                    const Icon(Icons.check_circle_rounded,
                        size: 18, color: ColoresJuego.correcto),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Relacionar cada parte con su función
// ===========================================================================

class RelacionarFunciones extends StatefulWidget {
  const RelacionarFunciones(
      {super.key,
      required this.parejas,
      required this.onCompleto,
      this.color = _azul,
      this.titulo = 'Relaciona cada parte con su función'});
  final List<(String, String)> parejas;
  final ValueChanged<int> onCompleto;
  final Color color;
  final String titulo;
  @override
  State<RelacionarFunciones> createState() => _RelacionarFuncionesState();
}

class _RelacionarFuncionesState extends State<RelacionarFunciones> {
  late final List<int> _derecha = List.generate(widget.parejas.length, (i) => i)
    ..shuffle(math.Random(5));
  final Map<int, int> _uniones = {}; // parte -> función
  int? _parte;
  final _bien = <int>{};
  int _errores = 0;
  String? _mensaje;

  void _tocarFuncion(int f) {
    final p = _parte;
    if (p == null) {
      setState(() => _mensaje = 'Primero toca una parte de la izquierda.');
      return;
    }
    setState(() {
      if (f == p) {
        _uniones[p] = f;
        _bien.add(p);
        _mensaje = '¡Correcto!';
        HapticFeedback.lightImpact();
      } else {
        _errores++;
        _mensaje = 'Esa no es su función. ¡Inténtalo de nuevo!';
        HapticFeedback.mediumImpact();
      }
      _parte = null;
    });
    if (_bien.length == widget.parejas.length) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) widget.onCompleto(_errores);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.parejas.length;
    final alto = 330 / n;
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            left: 250,
            top: 66,
            width: 600,
            child: Text(_mensaje ?? 'Toca una parte y después toca su función.',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    shadows: [Shadow(blurRadius: 4)])),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _PintorUniones([
                  for (final e in _uniones.entries)
                    (
                      Offset(420, 100 + e.key * alto + alto / 2),
                      Offset(480,
                          100 + _derecha.indexOf(e.value) * alto + alto / 2)
                    ),
                ], widget.color),
              ),
            ),
          ),
          for (var i = 0; i < n; i++)
            Positioned(
              left: 250,
              top: 100 + i * alto,
              width: 170,
              height: alto - 6,
              child: Rebote(
                onTap:
                    _bien.contains(i) ? null : () => setState(() => _parte = i),
                child: _caja(
                    widget.parejas[i].$1,
                    _bien.contains(i) ? ColoresJuego.correcto : widget.color,
                    _parte == i,
                    grande: true),
              ),
            ),
          for (var j = 0; j < n; j++)
            Positioned(
              left: 480,
              top: 100 + j * alto,
              width: 374,
              height: alto - 6,
              child: Rebote(
                onTap: _bien.contains(_derecha[j])
                    ? null
                    : () => _tocarFuncion(_derecha[j]),
                child: _caja(
                    widget.parejas[_derecha[j]].$2,
                    _bien.contains(_derecha[j])
                        ? ColoresJuego.correcto
                        : const Color(0xFF8B5CF6),
                    false),
              ),
            ),
        ],
      ),
    );
  }

  Widget _caja(String texto, Color color, bool activa, {bool grande = false}) =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: grande ? Alignment.center : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: activa ? aclarar(color, 0.75) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: activa ? 4 : 2.5),
        ),
        child: Text(texto,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: grande ? TextAlign.center : TextAlign.left,
            style: TextStyle(
                fontSize: grande ? 16 : 13,
                fontWeight: grande ? FontWeight.w700 : FontWeight.w600,
                height: 1.1)),
      );
}

class _PintorUniones extends CustomPainter {
  _PintorUniones(this.lineas, this.color);
  final List<(Offset, Offset)> lineas;
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    for (final (a, b) in lineas) {
      c.drawLine(a, b, linea(Colors.white, 7));
      c.drawLine(a, b, linea(ColoresJuego.correcto, 4));
    }
  }

  @override
  bool shouldRepaint(_PintorUniones old) => true;
}

// ===========================================================================
// 8. Laboratorio: recorrido del aire, simulación de la respiración y análisis
// ===========================================================================

const _rLab = Rect.fromLTWH(372, 64, 230, 370);

class PantallaLabRespiracion extends StatefulWidget {
  const PantallaLabRespiracion({super.key});
  @override
  State<PantallaLabRespiracion> createState() => _PantallaLabRespiracionState();
}

class _PantallaLabRespiracionState extends State<PantallaLabRespiracion> {
  int _etapa = 0; // 0 recorrido, 1 simulación, 2 comparar
  int _erroresRecorrido = 0;
  // Simulación
  bool _inhalando = false;
  double _aire = 0;
  int _respiraciones = 0;
  bool _lleno = false;
  Timer? _timer;
  // Comparar
  int _sub = 0; // 0 reposo, 1 moverse, 2 después, 3 analiza
  int? _rReposo, _rDespues;
  int _cuenta = 0, _restante = 0;
  int? _respuesta;
  bool _intento = false, _primer = false;

  static const _pregunta = PreguntaQuiz(
    pregunta: '¿Por qué respiraste más veces después de moverte?',
    opciones: [
      'Porque tus músculos necesitaban más oxígeno y producían más CO₂',
      'Porque el aire se acabó',
      'Porque los pulmones se hicieron más pequeños',
    ],
    correcta: 0,
    explicacion:
        'Al moverte, tu cuerpo usa más oxígeno; por eso respiras más rápido para obtenerlo y sacar el CO₂.',
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _simTick() {
    setState(() {
      if (_inhalando) {
        _aire = (_aire + 0.04).clamp(0.0, 1.0);
        if (_aire >= 0.95) _lleno = true;
      } else {
        _aire = (_aire - 0.035).clamp(0.0, 1.0);
        if (_lleno && _aire <= 0.05) {
          _lleno = false;
          _respiraciones++;
        }
      }
    });
  }

  void _contar() {
    _timer?.cancel();
    setState(() {
      _cuenta = 0;
      _restante = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _restante--);
      if (_restante <= 0) {
        t.cancel();
        setState(() {
          if (_sub == 0) {
            _rReposo = _cuenta * 2;
          } else {
            _rDespues = _cuenta * 2;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hijos = <Widget>[];
    final titulos = [
      '1. Arma el recorrido',
      '2. Simula la respiración',
      '3. Compara y analiza'
    ];
    if (_etapa == 0) {
      hijos.add(EtiquetarPartes(
        fondo: Reloj(
            builder: (_, t) =>
                CustomPaint(painter: PintorRespiratorio(t, _rLab))),
        color: _azul,
        nombres: const {
          'nariz': 'Nariz',
          'faringe': 'Faringe',
          'laringe': 'Laringe',
          'traquea': 'Tráquea',
          'bronquios': 'Bronquios',
          'bronquiolos': 'Bronquiolos',
          'alveolos': 'Alvéolos',
        },
        ranuras: [
          Ranura('nariz', const Offset(226, 80), puntoResp(_rLab, 'nariz'),
              numero: 1),
          Ranura('faringe', const Offset(226, 136), puntoResp(_rLab, 'faringe'),
              numero: 2),
          Ranura('laringe', const Offset(226, 192), puntoResp(_rLab, 'laringe'),
              numero: 3),
          Ranura('traquea', const Offset(226, 248), puntoResp(_rLab, 'traquea'),
              numero: 4),
          Ranura('bronquios', const Offset(626, 186),
              puntoResp(_rLab, 'bronquios'),
              numero: 5),
          Ranura('bronquiolos', const Offset(626, 254),
              puntoResp(_rLab, 'bronquiolos'),
              numero: 6),
          Ranura(
              'alveolos', const Offset(626, 322), puntoResp(_rLab, 'alveolos'),
              numero: 7),
        ],
        bandeja: const Rect.fromLTWH(10, 310, 350, 160),
        onCompleto: (e) => setState(() {
          _erroresRecorrido = e;
          _etapa = 1;
        }),
      ));
    } else if (_etapa == 1) {
      hijos.addAll([
        Positioned(
          left: 250,
          top: 64,
          width: 340,
          height: 400,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: _azul, width: 4)),
            child: Reloj(
              builder: (_, t) => CustomPaint(
                painter: _PintorSimulacion(t, _aire, _inhalando),
                size: Size.infinite,
              ),
            ),
          ),
        ),
        Positioned(
          left: 604,
          top: 70,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PanelInfo(
                titulo: _inhalando
                    ? 'Inhalando…'
                    : (_aire > 0.05 ? 'Exhalando…' : 'Listo para respirar'),
                icono: Icons.air_rounded,
                color: _azul,
                child: Text(
                  _inhalando
                      ? 'El diafragma baja y las costillas se abren. Entra aire con oxígeno y los pulmones se inflan.'
                      : 'El diafragma sube y los pulmones se desinflan: sale el aire con dióxido de carbono.',
                  style: const TextStyle(fontSize: 13.5, height: 1.25),
                ),
              ),
              const SizedBox(height: 10),
              Text('Aire en los pulmones: ${(_aire * 100).round()} %',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4)])),
              const SizedBox(height: 4),
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                      value: _aire, minHeight: 14, color: _azul)),
              const SizedBox(height: 10),
              Listener(
                onPointerDown: (_) {
                  setState(() => _inhalando = true);
                  _timer ??= Timer.periodic(
                      const Duration(milliseconds: 50), (_) => _simTick());
                },
                onPointerUp: (_) => setState(() => _inhalando = false),
                onPointerCancel: (_) => setState(() => _inhalando = false),
                child: Tooltip(
                  message: 'Inhalar',
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _inhalando ? _azul : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: _azul, width: 3),
                    ),
                    child: Text(
                        _inhalando
                            ? 'Inhalando…'
                            : 'Mantén presionado: INHALAR',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: _inhalando ? Colors.white : _azul)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Respiraciones completas: $_respiraciones/3',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 4)])),
              const SizedBox(height: 8),
              if (_respiraciones >= 3)
                BotonJuego(
                  texto: 'Siguiente experimento',
                  icono: Icons.arrow_forward_rounded,
                  color: const Color(0xFF2DB84C),
                  onTap: () {
                    _timer?.cancel();
                    _timer = null;
                    setState(() => _etapa = 2);
                  },
                ),
            ],
          ),
        ),
      ]);
    } else {
      hijos.add(Positioned(
        left: 250,
        top: 64,
        width: 604,
        height: 350,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _azul, width: 4)),
          child: Center(child: SingleChildScrollView(child: _comparar())),
        ),
      ));
    }
    final acerto = _etapa == 2 && _sub == 3 && _respuesta == _pregunta.correcta;
    final textosZati = [
      'Arrastra cada nombre al número que le toca para armar el recorrido del aire, desde la nariz hasta los alvéolos.',
      'Ahora simula la respiración: mantén presionado para inhalar y suelta para exhalar. Haz 3 respiraciones completas.',
      'Cuenta tus respiraciones en reposo y después de moverte. Luego compara y analiza los resultados.',
    ];
    return Escenario(
      velo: 0.15,
      colorVelo: _azul,
      children: [
        ...hijos,
        const BotonVolverEscena(),
        const Positioned(
            left: 64, top: 14, child: EtiquetaSeccion('Laboratorio')),
        Positioned(
            left: 300, top: 4, child: BannerTitulo(titulos[_etapa], tam: 22)),
        Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto: textosZati[_etapa],
            tamZati: _etapa == 0 ? 0.1 : 150,
            anchoGlobo: _etapa == 0 ? 210 : 236,
            altoGlobo: _etapa == 0 ? 160 : 190,
            tamLetra: 14,
            globoArriba: true,
          ),
        ),
        if (acerto)
          Positioned(
            left: 680,
            top: 422,
            child: BotonSiguiente(
              texto: 'Terminar',
              onTap: () => terminarPaso(
                context,
                actividad: Actividades.m2Lab,
                estrellas:
                    1 + (_erroresRecorrido == 0 ? 1 : 0) + (_primer ? 1 : 0),
                titulo: '¡Laboratorio completado!',
                mensaje:
                    'Armaste el recorrido del aire, simulaste la respiración y comprobaste que respiras más rápido al moverte.',
              ),
            ),
          ),
      ],
    );
  }

  Widget _comparar() {
    Widget medir(
            int? valor, String titulo, VoidCallback alGuardar, int ejemplo) =>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titulo,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            if (_restante > 0) ...[
              Text('$_restante s · $_cuenta respiraciones',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Tooltip(
                message: 'Contar respiración',
                child: BotonJuego(
                  texto: 'Toca cada vez que inhales',
                  icono: Icons.air_rounded,
                  color: _azul,
                  grande: true,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _cuenta++);
                  },
                ),
              ),
            ] else ...[
              if (valor != null)
                Text('$valor respiraciones por minuto',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _azul)),
              const SizedBox(height: 6),
              Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    BotonJuego(
                        texto: valor == null
                            ? 'Contar 30 segundos'
                            : 'Contar otra vez',
                        icono: Icons.timer_rounded,
                        color: _azul,
                        onTap: _contar),
                    if (valor != null)
                      BotonJuego(
                          texto: 'Guardar',
                          icono: Icons.check_rounded,
                          color: const Color(0xFF2DB84C),
                          onTap: alGuardar),
                  ]),
              TextButton(
                onPressed: () => setState(() {
                  if (_sub == 0) {
                    _rReposo = ejemplo;
                  } else {
                    _rDespues = ejemplo;
                  }
                }),
                child: Text('Usar un ejemplo ($ejemplo por minuto)'),
              ),
            ],
          ],
        );
    switch (_sub) {
      case 0:
        return medir(
            _rReposo,
            'En reposo: siéntate tranquilo y cuenta cuántas veces inhalas en 30 segundos.',
            () => setState(() => _sub = 1),
            20);
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sports_gymnastics_rounded,
                size: 90, color: Color(0xFFFF6B3D)),
            const Text('Ahora salta en tu lugar durante 30 segundos.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            BotonJuego(
                texto: 'Ya me moví',
                icono: Icons.arrow_forward_rounded,
                color: const Color(0xFFFF6B3D),
                onTap: () => setState(() => _sub = 2)),
          ],
        );
      case 2:
        return medir(
            _rDespues,
            'Después de moverte: cuenta otra vez tus respiraciones durante 30 segundos.',
            () => setState(() => _sub = 3),
            36);
      default:
        final r = _rReposo ?? 0, d = _rDespues ?? 0;
        final acerto = _respuesta == _pregunta.correcta;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 180,
                height: 200,
                child: CustomPaint(
                    painter: _PintorBarras2(r.toDouble(), d.toDouble()))),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      d > r
                          ? 'Pasaste de $r a $d respiraciones por minuto.'
                          : 'Tus respiraciones no aumentaron. ¿Te moviste lo suficiente?',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(_pregunta.pregunta,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  for (final (posI, i) in ordenOpciones(_pregunta.pregunta, 3).indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: BotonOpcion(
                        letra: 'ABC'[posI],
                        texto: _pregunta.opciones[i],
                        estado: _respuesta == i
                            ? (i == _pregunta.correcta
                                ? EstadoOpcion.correcta
                                : EstadoOpcion.incorrecta)
                            : EstadoOpcion.normal,
                        onTap: acerto
                            ? null
                            : () => setState(() {
                                  if (!_intento && i == _pregunta.correcta) {
                                    _primer = true;
                                  }
                                  _intento = true;
                                  _respuesta = i;
                                }),
                      ),
                    ),
                  if (_respuesta != null)
                    Text(
                        acerto
                            ? '✅ ${_pregunta.explicacion}'
                            : '🤔 ¡Inténtalo otra vez!',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: acerto
                                ? ColoresJuego.correcto
                                : ColoresJuego.incorrecto)),
                ],
              ),
            ),
          ],
        );
    }
  }
}

class _PintorSimulacion extends CustomPainter {
  _PintorSimulacion(this.t, this.aire, this.inhalando);
  final double t, aire;
  final bool inhalando;
  @override
  void paint(Canvas c, Size s) {
    final r = Rect.fromLTWH(s.width * 0.12, 8, s.width * 0.76, s.height - 20);
    // Costillas que se abren
    final abre = 1 + 0.05 * aire;
    for (var i = 0; i < 5; i++) {
      final y = r.top + r.height * (0.5 + i * 0.075);
      for (final lado in [-1.0, 1.0]) {
        final p = Path()
          ..moveTo(s.width / 2 + lado * 8, y)
          ..quadraticBezierTo(s.width / 2 + lado * s.width * 0.46 * abre,
              y - 18, s.width / 2 + lado * s.width * 0.42 * abre, y + 26);
        c.drawPath(p, linea(const Color(0xFFE6D3C3), 7));
      }
    }
    dibujarSistemaRespiratorio(c, r, t, inflado: aire, alveolos: false);
    // Partículas de aire
    final entra = inhalando;
    if (inhalando || aire > 0.05) {
      for (var i = 0; i < 6; i++) {
        var u = (t * 1.3 + i / 6) % 1.0;
        if (!entra) u = 1 - u;
        final p = Offset(s.width / 2 + math.sin(i * 2.0) * 5,
            r.top + r.height * (0.02 + 0.45 * u));
        burbujaGas(c, p, 9, entra);
      }
    }
    textoEn(c, entra ? 'El diafragma baja ↓' : 'El diafragma sube ↑',
        Offset(s.width / 2, s.height - 12),
        tam: 13, color: Colors.white, fondo: entra ? _azul : Colors.blueGrey);
  }

  @override
  bool shouldRepaint(_PintorSimulacion old) => true;
}

class _PintorBarras2 extends CustomPainter {
  _PintorBarras2(this.a, this.b);
  final double a, b;
  @override
  void paint(Canvas c, Size s) {
    final base = s.height - 28;
    c.drawLine(
        Offset(0, base), Offset(s.width, base), linea(Colors.black26, 2));
    final maximo = math.max(50.0, math.max(a, b) + 10);
    final datos = [
      ('En reposo', a, _azul),
      ('Después', b, const Color(0xFFFF6B3D))
    ];
    for (var i = 0; i < 2; i++) {
      final (n, v, col) = datos[i];
      final h = v / maximo * (base - 30);
      final x = s.width * (0.12 + i * 0.46);
      c.drawRRect(
          RRect.fromRectAndCorners(
              Rect.fromLTWH(x, base - h, s.width * 0.32, h),
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10)),
          Paint()..color = col);
      textoEn(c, '${v.round()}', Offset(x + s.width * 0.16, base - h - 12),
          tam: 16, color: col);
      textoEn(c, n, Offset(x + s.width * 0.16, base + 13), tam: 12);
    }
  }

  @override
  bool shouldRepaint(_PintorBarras2 old) => true;
}

// ===========================================================================
// 10. Mini misión: pon a prueba lo que aprendiste
// ===========================================================================

const _rMini = Rect.fromLTWH(372, 64, 230, 380);

const accionesRespiratorio = [
  Accion(Icons.park_rounded, 'Jugar al aire libre en lugares con árboles', true,
      'El aire limpio y el ejercicio fortalecen tus pulmones.'),
  Accion(Icons.smoke_free_rounded, 'Alejarse del humo de cigarro', true,
      'El humo daña los alvéolos aunque no seas tú quien fuma.'),
  Accion(Icons.air_rounded, 'Respirar por la nariz', true,
      'La nariz filtra, calienta y humedece el aire.'),
  Accion(Icons.masks_rounded, 'Taparse al toser o estornudar', true,
      'Con el codo o un pañuelo evitas contagiar a otras personas.'),
  Accion(Icons.local_fire_department_rounded, 'Quemar basura', false,
      'El humo de la basura tiene sustancias que dañan los pulmones.'),
  Accion(Icons.smoking_rooms_rounded, 'Estar cerca de quien fuma', false,
      'Respirar ese humo también daña tus pulmones.'),
  Accion(Icons.window_rounded, 'Mantener la casa siempre cerrada y con polvo',
      false, 'Ventilar y limpiar ayuda a respirar aire más limpio.'),
  Accion(Icons.ac_unit_rounded, 'Salir al frío sin cubrirse nariz y boca',
      false, 'El aire muy frío puede irritar tu garganta.'),
];

class PantallaMiniMisionRespiratorio extends StatefulWidget {
  const PantallaMiniMisionRespiratorio({super.key});
  @override
  State<PantallaMiniMisionRespiratorio> createState() =>
      _PantallaMiniMisionRespiratorioState();
}

class _PantallaMiniMisionRespiratorioState
    extends State<PantallaMiniMisionRespiratorio> {
  int _fase = 0;
  int _errores = 0;

  static const _textos = [
    '1. Identifica y nombra las partes del modelo: arrastra cada nombre a su lugar.',
    '2. Relaciona cada parte con su función.',
    '3. Elige las acciones que cuidan tu sistema respiratorio.',
  ];

  @override
  Widget build(BuildContext context) {
    final hijos = <Widget>[];
    switch (_fase) {
      case 0:
        hijos.add(EtiquetarPartes(
          fondo: Reloj(
              builder: (_, t) =>
                  CustomPaint(painter: PintorRespiratorio(t, _rMini))),
          nombres: const {
            'nariz': 'Nariz',
            'faringe': 'Faringe',
            'laringe': 'Laringe',
            'traquea': 'Tráquea',
            'bronquios': 'Bronquios',
            'pulmones': 'Pulmones',
            'alveolos': 'Alvéolos',
            'diafragma': 'Diafragma',
          },
          ranuras: [
            Ranura('nariz', const Offset(226, 92), puntoResp(_rMini, 'nariz')),
            Ranura('faringe', const Offset(626, 110),
                puntoResp(_rMini, 'faringe')),
            Ranura('laringe', const Offset(226, 146),
                puntoResp(_rMini, 'laringe')),
            Ranura('traquea', const Offset(626, 178),
                puntoResp(_rMini, 'traquea')),
            Ranura('bronquios', const Offset(626, 246),
                puntoResp(_rMini, 'bronquios')),
            Ranura('pulmones', const Offset(226, 200),
                puntoResp(_rMini, 'pulmones')),
            Ranura('alveolos', const Offset(626, 314),
                puntoResp(_rMini, 'alveolos')),
            Ranura('diafragma', const Offset(626, 392),
                puntoResp(_rMini, 'diafragma')),
          ],
          bandeja: const Rect.fromLTWH(10, 250, 350, 220),
          onCompleto: (e) => setState(() {
            _errores += e;
            _fase = 1;
          }),
        ));
      case 1:
        hijos.add(RelacionarFunciones(
          parejas: const [
            ('Nariz', 'Limpia, calienta y humedece el aire que entra.'),
            ('Laringe', 'Tiene las cuerdas vocales que producen la voz.'),
            ('Tráquea', 'Tubo con anillos que lleva el aire al pecho.'),
            ('Pulmones', 'Se llenan de aire; ahí el oxígeno pasa a la sangre.'),
            ('Diafragma', 'Músculo que baja al inhalar y sube al exhalar.'),
          ],
          onCompleto: (e) => setState(() {
            _errores += e;
            _fase = 2;
          }),
        ));
      default:
        hijos.add(CapaAcciones(
          titulo: 'Cuida tu sistema respiratorio',
          instruccion:
              'Toca todas las acciones que ayudan a cuidar tu sistema respiratorio y presiona “Comprobar”.',
          color: _azul,
          acciones: accionesRespiratorio,
          onTerminar: (e) => terminarPaso(
            context,
            actividad: Actividades.m2Mini,
            estrellas: (_errores + e) == 0 ? 3 : ((_errores + e) <= 3 ? 2 : 1),
            titulo: '¡Pusiste a prueba lo que aprendiste!',
            mensaje:
                'Nombraste las partes del sistema respiratorio, conoces su función y sabes cómo cuidarlo.',
          ),
        ));
    }
    return Escenario(
      velo: 0.1,
      colorVelo: _azul,
      children: [
        ...hijos,
        const BotonVolverEscena(),
        const Positioned(
            left: 64, top: 14, child: EtiquetaSeccion('Mini misión')),
        const Positioned(
            left: 270,
            top: 4,
            child: BannerTitulo('Pon a prueba lo que aprendiste', tam: 22)),
        if (_fase < 2)
          Positioned(
            left: 8,
            top: 66,
            width: 214,
            child: GloboTexto(
                colita: false,
                child: Text(_textos[_fase],
                    style: const TextStyle(fontSize: 14.5, height: 1.25))),
          ),
        if (_fase == 1)
          const Positioned(
              left: 20,
              top: 270,
              child: SizedBox(
                  width: 150, height: 200, child: ZatiMascota(tam: 200))),
      ],
    );
  }
}
