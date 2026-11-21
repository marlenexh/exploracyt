import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'aventura.dart' show FondoBosque;
import 'contenido.dart';
import 'misiones.dart';
import 'progreso.dart';
import 'ui_divertida.dart';

export 'ui_divertida.dart';

// ---------------------------------------------------------------------------
// Colores y tema
// ---------------------------------------------------------------------------

class ColoresJuego {
  static const fondo = Color(0xFFFFF8EC);
  static const primario = Color(0xFF4361EE);
  static const texto = Color(0xFF26215C);
  static const intro = Color(0xFFFF8A00);
  static const circulatorio = Color(0xFFFF3D68);
  static const respiratorio = Color(0xFF00A6FB);
  static const inmune = Color(0xFF8B5CF6);
  static const laboratorio = Color(0xFF06B6A4);
  static const retos = Color(0xFFFFAA00);
  static const sim3d = Color(0xFF4361EE);
  static const sangreRica = Color(0xFFE53935);
  static const sangrePobre = Color(0xFF5C6BC0);
  static const piel = Color(0xFFFFD3B6);
  static const correcto = Color(0xFF2DB84C);
  static const incorrecto = Color(0xFFFF3B3B);
}

/// Fuente redondeada para niños (assets/fonts). Si no está registrada en el
/// pubspec, Flutter usa la fuente por defecto sin fallar.
const fuenteJuego = 'Fredoka';

ThemeData temaJuego() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: fuenteJuego,
    colorSchemeSeed: ColoresJuego.primario,
    scaffoldBackgroundColor: Colors.transparent,
  );
  final redondo = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
  );
  return base.copyWith(
    textTheme: base.textTheme.apply(
      bodyColor: ColoresJuego.texto,
      displayColor: ColoresJuego.texto,
      fontFamily: fuenteJuego,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: fuenteJuego,
        ),
        shape: redondo,
        elevation: 4,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        textStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: fuenteJuego,
        ),
        shape: redondo,
        side: const BorderSide(width: 2.5, color: ColoresJuego.primario),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      labelStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: fuenteJuego,
        color: ColoresJuego.texto,
      ),
      shape: const StadiumBorder(
        side: BorderSide(color: Color(0x33000000), width: 1.5),
      ),
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
    ),
    sliderTheme: base.sliderTheme.copyWith(
      trackHeight: 10,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 26),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
    ),
    progressIndicatorTheme: base.progressIndicatorTheme.copyWith(
      linearTrackColor: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

/// Abre una pantalla del juego conservando el tema, el progreso y la
/// configuración, con una transición divertida y el fondo del bosque.
Future<T?> abrirPantalla<T>(
  BuildContext context,
  Widget pantalla, {
  Color color = ColoresJuego.primario,
  bool fondoBosque = false,
  bool conFondo = true,
}) {
  final progreso = ProgresoScope.read(context);
  final config = ConfiguracionJuego.of(context);
  return Navigator.of(context).push<T>(
    RutaJuego(
      builder: (_) => ConfiguracionJuego(
        desbloquearTodo: config.desbloquearTodo,
        videos: config.videos,
        nombreAlumno: config.nombreAlumno,
        child: ProgresoScope(
          progreso: progreso,
          child: Theme(
            data: temaJuego(),
            child: !conFondo
                ? pantalla
                : fondoBosque
                    ? FondoBosque(child: pantalla)
                    : FondoAnimado(color: color, child: pantalla),
          ),
        ),
      ),
    ),
  );
}

/// Guarda estrellas y muestra la celebración con las insignias nuevas.
Future<void> otorgarEstrellas(
  BuildContext context, {
  required String actividad,
  required int estrellas,
  required String titulo,
  required String mensaje,
}) async {
  final progreso = ProgresoScope.read(context);
  progreso.registrar(actividad, estrellas);
  final nuevas = List<Insignia>.from(progreso.nuevasInsignias);
  await mostrarCelebracion(
    context,
    titulo: titulo,
    mensaje: mensaje,
    estrellas: estrellas,
    insignias: nuevas,
  );
}

// ---------------------------------------------------------------------------
// Utilidad para trazar rutas con coordenadas relativas (0–1)
// ---------------------------------------------------------------------------

class Trazo {
  Trazo(this.r);
  final Rect r;
  final Path path = Path();
  double x(double f) => r.left + f * r.width;
  double y(double f) => r.top + f * r.height;
  Offset o(double fx, double fy) => Offset(x(fx), y(fy));
  void m(double a, double b) => path.moveTo(x(a), y(b));
  void l(double a, double b) => path.lineTo(x(a), y(b));
  void q(double a, double b, double c, double d) =>
      path.quadraticBezierTo(x(a), y(b), x(c), y(d));
  void c(double a, double b, double c, double d, double e, double f) =>
      path.cubicTo(x(a), y(b), x(c), y(d), x(e), y(f));
  void z() => path.close();
}

Paint relleno(Color c) => Paint()..color = c;
Paint linea(Color c, double ancho) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = ancho
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void textoEn(
  Canvas canvas,
  String texto,
  Offset centro, {
  double tam = 12,
  Color color = ColoresJuego.texto,
  FontWeight peso = FontWeight.bold,
  Color? fondo,
}) {
  final tp = TextPainter(
    text: TextSpan(
      text: texto,
      style: TextStyle(fontSize: tam, color: color, fontWeight: peso),
    ),
    textDirection: TextDirection.ltr,
    textAlign: TextAlign.center,
  )..layout();
  final pos = centro - Offset(tp.width / 2, tp.height / 2);
  if (fondo != null) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(pos.dx - 6, pos.dy - 3, tp.width + 12, tp.height + 6),
        const Radius.circular(8),
      ),
      relleno(fondo),
    );
  }
  tp.paint(canvas, pos);
}

// ---------------------------------------------------------------------------
// Silueta del cuerpo y órganos dibujados
// ---------------------------------------------------------------------------

class Silueta {
  /// Proporción ancho/alto de la silueta.
  static const proporcion = 0.55;

  /// Caja centrada donde cabe la silueta dentro de [s].
  static Rect caja(Size s, {double margen = 0.03}) {
    final h = s.height * (1 - margen * 2);
    final w = math.min(h * proporcion, s.width * 0.95);
    final hh = w / proporcion;
    return Rect.fromCenter(
      center: Offset(s.width / 2, s.height / 2),
      width: w,
      height: hh,
    );
  }

  static Offset punto(Rect caja, Offset f) =>
      Offset(caja.left + f.dx * caja.width, caja.top + f.dy * caja.height);

  static Path ruta(Rect b) {
    final w = b.width, h = b.height;
    Offset p(double x, double y) => Offset(b.left + x * w, b.top + y * h);
    final path = Path()
      ..addOval(Rect.fromCircle(center: p(0.5, 0.075), radius: 0.068 * h))
      ..addRect(Rect.fromPoints(p(0.45, 0.12), p(0.55, 0.17)))
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromPoints(p(0.26, 0.155), p(0.74, 0.56)),
          Radius.circular(0.08 * w),
        ),
      );
    void extremidad(Offset a, Offset c, double ancho) {
      final d = c - a;
      final n = Offset(-d.dy, d.dx) / d.distance * (ancho / 2);
      path.addPath(
        Path()
          ..moveTo((a + n).dx, (a + n).dy)
          ..lineTo((c + n).dx, (c + n).dy)
          ..arcToPoint(c - n, radius: Radius.circular(ancho / 2))
          ..lineTo((a - n).dx, (a - n).dy)
          ..arcToPoint(a + n, radius: Radius.circular(ancho / 2))
          ..close(),
        Offset.zero,
      );
    }

    extremidad(p(0.27, 0.19), p(0.1, 0.52), 0.13 * w);
    extremidad(p(0.73, 0.19), p(0.9, 0.52), 0.13 * w);
    extremidad(p(0.38, 0.52), p(0.37, 0.96), 0.17 * w);
    extremidad(p(0.62, 0.52), p(0.63, 0.96), 0.17 * w);
    return path;
  }

  static void dibujar(
    Canvas canvas,
    Rect b, {
    Color color = ColoresJuego.piel,
    Color? borde,
    double opacidad = 1,
  }) {
    final path = ruta(b);
    canvas.drawPath(
      path,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: opacidad),
            Color.lerp(color, Colors.black, 0.08)!.withValues(alpha: opacidad),
          ],
        ).createShader(b),
    );
    if (borde != null) {
      canvas.drawPath(path, linea(borde, 2));
    }
  }
}

class DibujoOrganos {
  static void dibujar(Canvas c, Rect r, String id) {
    switch (id) {
      case 'corazon':
        corazon(c, r);
      case 'pulmones':
        pulmones(c, r);
      case 'cerebro':
        cerebro(c, r);
      case 'estomago':
        estomago(c, r);
      case 'higado':
        higado(c, r);
      case 'intestinos':
        intestinos(c, r);
    }
  }

  static Rect _cuadro(Rect r) => Rect.fromCenter(
        center: r.center,
        width: r.shortestSide,
        height: r.shortestSide,
      );

  static void corazon(Canvas c, Rect r0, {double latido = 0}) {
    final r = _cuadro(r0).inflate(r0.shortestSide * 0.04 * latido);
    final t = Trazo(r);
    final w = r.width;
    // Vasos principales
    final aorta = Trazo(r)
      ..m(0.56, 0.32)
      ..q(0.54, 0.02, 0.82, 0.08);
    c.drawPath(aorta.path, linea(const Color(0xFFC62828), w * 0.13));
    final vena = Trazo(r)
      ..m(0.36, 0.34)
      ..l(0.34, 0.05);
    c.drawPath(vena.path, linea(ColoresJuego.sangrePobre, w * 0.11));
    t
      ..m(0.5, 0.3)
      ..c(0.36, 0.1, 0.02, 0.16, 0.08, 0.5)
      ..c(0.14, 0.74, 0.4, 0.86, 0.52, 0.98)
      ..c(0.64, 0.86, 0.9, 0.72, 0.94, 0.48)
      ..c(0.98, 0.16, 0.66, 0.1, 0.5, 0.3)
      ..z();
    c.drawPath(
      t.path,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFFF6B6B), Color(0xFFD32F2F), Color(0xFF8E1B1B)],
          stops: [0, 0.6, 1],
        ).createShader(r),
    );
    final brillo = Trazo(r)
      ..m(0.22, 0.3)
      ..q(0.18, 0.42, 0.24, 0.52);
    c.drawPath(
      brillo.path,
      linea(Colors.white.withValues(alpha: 0.5), w * 0.04),
    );
  }

  static void _pulmon(Trazo t, bool izq) {
    double fx(double x) => izq ? x : 1 - x;
    t
      ..m(fx(0.43), 0.22)
      ..c(fx(0.25), 0.12, fx(0.06), 0.45, fx(0.07), 0.86)
      ..q(fx(0.25), 0.99, fx(0.45), 0.86)
      ..q(fx(0.38), 0.55, fx(0.43), 0.22)
      ..z();
  }

  static void pulmones(Canvas c, Rect r0, {double inflado = 0.5}) {
    final r = _cuadro(r0);
    final esc = 0.92 + inflado * 0.12;
    final rr = Rect.fromCenter(
      center: r.center,
      width: r.width * esc,
      height: r.height * esc,
    );
    final shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFA4B6), Color(0xFFE5677F)],
    ).createShader(rr);
    for (final izq in [true, false]) {
      final t = Trazo(rr);
      _pulmon(t, izq);
      c.drawPath(t.path, Paint()..shader = shader);
      c.drawPath(t.path, linea(const Color(0xFFB8455B), r.width * 0.02));
    }
    final w = r.width;
    final tr = Trazo(r)
      ..m(0.5, 0.0)
      ..l(0.5, 0.33)
      ..m(0.5, 0.33)
      ..q(0.45, 0.38, 0.36, 0.45)
      ..m(0.5, 0.33)
      ..q(0.55, 0.38, 0.64, 0.45);
    c.drawPath(tr.path, linea(const Color(0xFFE8EAF6), w * 0.07));
    c.drawPath(tr.path, linea(const Color(0xFF9FA8DA), w * 0.025));
  }

  static void cerebro(Canvas c, Rect r0) {
    final r = Rect.fromCenter(
      center: r0.center,
      width: r0.shortestSide * 1.2,
      height: r0.shortestSide * 0.9,
    );
    c.drawOval(
      r,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFC1D6), Color(0xFFF48FB1)],
        ).createShader(r),
    );
    final p = linea(const Color(0xFFD06A92), r.width * 0.035);
    final t = Trazo(r)
      ..m(0.5, 0.08)
      ..l(0.5, 0.9)
      ..m(0.2, 0.3)
      ..q(0.3, 0.2, 0.38, 0.35)
      ..m(0.12, 0.55)
      ..q(0.25, 0.45, 0.36, 0.6)
      ..m(0.25, 0.78)
      ..q(0.35, 0.68, 0.42, 0.8)
      ..m(0.8, 0.3)
      ..q(0.7, 0.2, 0.62, 0.35)
      ..m(0.88, 0.55)
      ..q(0.75, 0.45, 0.64, 0.6)
      ..m(0.75, 0.78)
      ..q(0.65, 0.68, 0.58, 0.8);
    c.drawPath(t.path, p);
  }

  static void estomago(Canvas c, Rect r0) {
    final r = _cuadro(r0);
    final t = Trazo(r)
      ..m(0.28, 0.04)
      ..l(0.42, 0.04)
      ..q(0.44, 0.34, 0.66, 0.34)
      ..q(0.96, 0.36, 0.9, 0.66)
      ..q(0.8, 0.96, 0.45, 0.9)
      ..q(0.14, 0.84, 0.22, 0.5)
      ..q(0.28, 0.3, 0.28, 0.04)
      ..z();
    c.drawPath(
      t.path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFFCC80), Color(0xFFFF8A65)],
        ).createShader(r),
    );
    c.drawPath(t.path, linea(const Color(0xFFD84315), r.width * 0.025));
  }

  static void higado(Canvas c, Rect r0) {
    final r = Rect.fromCenter(
      center: r0.center,
      width: r0.shortestSide * 1.3,
      height: r0.shortestSide * 0.85,
    );
    final t = Trazo(r)
      ..m(0.03, 0.35)
      ..q(0.3, 0.0, 0.97, 0.12)
      ..q(0.88, 0.5, 0.55, 0.85)
      ..q(0.2, 0.8, 0.03, 0.35)
      ..z();
    c.drawPath(
      t.path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFB0473A), Color(0xFF7B2A20)],
        ).createShader(r),
    );
    c.drawPath(t.path, linea(const Color(0xFF5D1E16), r.width * 0.02));
  }

  static void intestinos(Canvas c, Rect r0) {
    final r = Rect.fromCenter(
      center: r0.center,
      width: r0.shortestSide * 1.25,
      height: r0.shortestSide,
    );
    final w = r.width;
    final grueso = Trazo(r)
      ..m(0.1, 0.95)
      ..l(0.1, 0.12)
      ..q(0.1, 0.05, 0.2, 0.05)
      ..l(0.8, 0.05)
      ..q(0.9, 0.05, 0.9, 0.12)
      ..l(0.9, 0.9);
    c.drawPath(grueso.path, linea(const Color(0xFFD9826A), w * 0.13));
    final delgado = Trazo(r)..m(0.28, 0.25);
    for (var i = 0; i < 4; i++) {
      final y = 0.25 + i * 0.17;
      if (i.isEven) {
        delgado.q(0.5, y - 0.08, 0.72, y);
        delgado.q(0.8, y + 0.08, 0.72, y + 0.17);
      } else {
        delgado.q(0.5, y - 0.08, 0.28, y);
        delgado.q(0.2, y + 0.08, 0.28, y + 0.17);
      }
    }
    c.drawPath(delgado.path, linea(const Color(0xFFFFAB91), w * 0.1));
    c.drawPath(delgado.path, linea(const Color(0xFFE57357), w * 0.02));
  }
}

class IconoOrgano extends StatelessWidget {
  const IconoOrgano(this.id, {super.key, this.tam = 56});
  final String id;
  final double tam;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: tam,
        height: tam,
        child: CustomPaint(painter: _PintorOrgano(id)),
      );
}

class _PintorOrgano extends CustomPainter {
  _PintorOrgano(this.id);
  final String id;
  @override
  void paint(Canvas canvas, Size size) =>
      DibujoOrganos.dibujar(canvas, Offset.zero & size, id);
  @override
  bool shouldRepaint(_PintorOrgano old) => old.id != id;
}

// ---------------------------------------------------------------------------
// Cora, la glóbula roja guía
// ---------------------------------------------------------------------------

enum EmocionCora { feliz, sorprendida, pensando, triste }

class CoraMascota extends StatefulWidget {
  const CoraMascota({
    super.key,
    this.tam = 72,
    this.emocion = EmocionCora.feliz,
    this.hablando = false,
  });
  final double tam;
  final EmocionCora emocion;
  final bool hablando;
  @override
  State<CoraMascota> createState() => _CoraMascotaState();
}

class _CoraMascotaState extends State<CoraMascota>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ZatiMascota(
        tam: widget.tam,
        emocion: widget.emocion,
        hablando: widget.hablando,
      );
}

/// Zati, el guía del Tema 1 (assets/images/zati_tema1.png). Flota, rebota
/// al hablar y reacciona con su postura. Si la imagen no está registrada en
/// el pubspec, se dibuja a Cora como respaldo.
class ZatiMascota extends StatelessWidget {
  const ZatiMascota({
    super.key,
    this.tam = 120,
    this.emocion = EmocionCora.feliz,
    this.hablando = false,
    this.voltear = false,
  });
  final double tam;
  final EmocionCora emocion;
  final bool hablando;
  final bool voltear;

  @override
  Widget build(BuildContext context) {
    // Zati se muestra quieto (sin flotar ni rebotar).
    return SizedBox(
      width: tam,
      height: tam,
      child: Transform.flip(
        flipX: voltear,
        child: Image.asset(
          rutaZatiTema1,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          filterQuality: FilterQuality.medium,
          errorBuilder: (_, __, ___) =>
              CustomPaint(painter: PintorCora(0, emocion)),
        ),
      ),
    );
  }
}

class PintorCora extends CustomPainter {
  PintorCora(this.t, this.emocion, {this.hablando = false});
  final double t;
  final EmocionCora emocion;
  final bool hablando;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide * 0.38;
    final salto = hablando
        ? (math.sin(t * 2 * math.pi * 8)).abs() * size.height * 0.03
        : 0.0;
    final c = Offset(
      size.width / 2,
      size.height / 2 + math.sin(t * 2 * math.pi) * size.height * 0.04 - salto,
    );
    // Estiramiento tipo "gelatina"
    final estira = 1 + 0.04 * math.sin(t * 2 * math.pi * 2);
    // Sombra
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.95),
        width: r * 1.4,
        height: r * 0.2,
      ),
      relleno(Colors.black.withValues(alpha: 0.12)),
    );
    // Bracitos que saludan
    final brazo = linea(const Color(0xFFB71C1C), r * 0.13);
    final saludo = math.sin(t * 2 * math.pi * 2) * 0.5;
    canvas.drawLine(
      c + Offset(-r * 0.92, r * 0.1),
      c + Offset(-r * 1.25, r * 0.45),
      brazo,
    );
    final mano = c +
        Offset(r * 0.92, -r * 0.05) +
        Offset(math.cos(-0.9 + saludo), math.sin(-0.9 + saludo)) * r * 0.45;
    canvas.drawLine(c + Offset(r * 0.92, -r * 0.05), mano, brazo);
    canvas.drawCircle(mano, r * 0.11, relleno(const Color(0xFFB71C1C)));
    canvas.drawCircle(
      c + Offset(-r * 1.25, r * 0.45),
      r * 0.11,
      relleno(const Color(0xFFB71C1C)),
    );

    final cuerpo = Rect.fromCenter(
      center: c,
      width: r * 2 * estira,
      height: r * 1.85 / estira,
    );
    canvas.drawOval(
      cuerpo,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.3, -0.4),
          colors: [Color(0xFFFF8A8A), Color(0xFFF2334A), Color(0xFFB0172B)],
          stops: [0, 0.65, 1],
        ).createShader(cuerpo),
    );
    canvas.drawOval(cuerpo, linea(const Color(0xFF8E0E1F), r * 0.06));
    // Centro cóncavo
    canvas.drawOval(
      Rect.fromCenter(
        center: c + Offset(0, r * 0.12),
        width: r * 1.1,
        height: r * 0.8,
      ),
      relleno(const Color(0x22000000)),
    );
    // Ojos grandes y brillantes
    final parpadeo = (t * 3 % 1) > 0.95;
    for (final s in [-1.0, 1.0]) {
      final ojo = c + Offset(s * r * 0.36, -r * 0.2);
      if (parpadeo) {
        canvas.drawArc(
          Rect.fromCenter(center: ojo, width: r * 0.32, height: r * 0.2),
          0,
          math.pi,
          false,
          linea(const Color(0xFF3B0A0A), r * 0.07),
        );
      } else {
        final alto = emocion == EmocionCora.sorprendida ? 0.5 : 0.42;
        canvas.drawOval(
          Rect.fromCenter(center: ojo, width: r * 0.36, height: r * alto),
          relleno(Colors.white),
        );
        final pupila = ojo +
            Offset(
              emocion == EmocionCora.pensando ? r * 0.06 : 0,
              emocion == EmocionCora.pensando ? -r * 0.07 : r * 0.04,
            );
        canvas.drawCircle(pupila, r * 0.13, relleno(const Color(0xFF2B1B1B)));
        canvas.drawCircle(
          pupila + Offset(-r * 0.04, -r * 0.05),
          r * 0.05,
          relleno(Colors.white),
        );
        canvas.drawCircle(
          pupila + Offset(r * 0.04, r * 0.04),
          r * 0.022,
          relleno(Colors.white),
        );
      }
      if (emocion == EmocionCora.triste) {
        canvas.drawLine(
          ojo + Offset(-s * r * 0.18, -r * 0.3),
          ojo + Offset(s * r * 0.12, -r * 0.36),
          linea(const Color(0xFF3B0A0A), r * 0.05),
        );
      }
    }
    // Mejillas
    for (final s in [-1.0, 1.0]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: c + Offset(s * r * 0.64, r * 0.14),
          width: r * 0.28,
          height: r * 0.16,
        ),
        relleno(const Color(0x88FFC1C1)),
      );
    }
    // Boca
    final boca = Rect.fromCenter(
      center: c + Offset(0, r * 0.2),
      width: r * 0.5,
      height: r * 0.36,
    );
    const colBoca = Color(0xFF3B0A0A);
    if (hablando) {
      final abre = 0.08 + 0.18 * (math.sin(t * 2 * math.pi * 8)).abs();
      canvas.drawOval(
        Rect.fromCenter(
          center: c + Offset(0, r * 0.36),
          width: r * 0.34,
          height: r * abre,
        ),
        relleno(colBoca),
      );
    } else {
      switch (emocion) {
        case EmocionCora.feliz:
          final sonrisa = Path()
            ..moveTo(c.dx - r * 0.26, c.dy + r * 0.26)
            ..quadraticBezierTo(
              c.dx,
              c.dy + r * 0.62,
              c.dx + r * 0.26,
              c.dy + r * 0.26,
            )
            ..close();
          canvas.drawPath(sonrisa, relleno(colBoca));
          canvas.drawOval(
            Rect.fromCenter(
              center: c + Offset(0, r * 0.4),
              width: r * 0.18,
              height: r * 0.08,
            ),
            relleno(const Color(0xFFFF8FA3)),
          );
        case EmocionCora.sorprendida:
          canvas.drawOval(
            Rect.fromCenter(
              center: c + Offset(0, r * 0.38),
              width: r * 0.22,
              height: r * 0.26,
            ),
            relleno(colBoca),
          );
        case EmocionCora.pensando:
          canvas.drawLine(
            c + Offset(-r * 0.15, r * 0.38),
            c + Offset(r * 0.18, r * 0.32),
            linea(colBoca, r * 0.07),
          );
        case EmocionCora.triste:
          canvas.drawArc(
            boca.shift(Offset(0, r * 0.3)),
            1.15 * math.pi,
            0.7 * math.pi,
            false,
            linea(colBoca, r * 0.07),
          );
      }
    }
    // Brillo
    canvas.drawArc(
      cuerpo.deflate(r * 0.15),
      1.1 * math.pi,
      0.35 * math.pi,
      false,
      linea(Colors.white.withValues(alpha: 0.55), r * 0.09),
    );
  }

  @override
  bool shouldRepaint(PintorCora old) => true;
}

/// Cora "dice" el texto letra por letra mientras mueve la boca.
class BurbujaCora extends StatefulWidget {
  const BurbujaCora({
    super.key,
    required this.texto,
    this.emocion = EmocionCora.feliz,
    this.tamCora = 64,
    this.animarTexto = true,
  });
  final String texto;
  final EmocionCora emocion;
  final double tamCora;
  final bool animarTexto;

  @override
  State<BurbujaCora> createState() => _BurbujaCoraState();
}

class _BurbujaCoraState extends State<BurbujaCora> {
  bool _hablando = false;

  @override
  Widget build(BuildContext context) {
    const estilo = TextStyle(
      fontSize: 16.5,
      height: 1.35,
      color: ColoresJuego.texto,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CoraMascota(
          tam: widget.tamCora,
          emocion: widget.emocion,
          hablando: _hablando,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: CustomPaint(
            painter: _PintorColita(),
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFFFD6DC), width: 2.5),
                boxShadow: const [
                  BoxShadow(color: Color(0x22F2334A), offset: Offset(0, 5)),
                ],
              ),
              child: widget.animarTexto
                  ? TextoMaquina(
                      widget.texto,
                      estilo: estilo,
                      alCambiar: (v) {
                        if (mounted && v != _hablando) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _hablando = v);
                          });
                        }
                      },
                    )
                  : Text(widget.texto, style: estilo),
            ),
          ),
        ),
      ],
    );
  }
}

class _PintorColita extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Path()
      ..moveTo(10, s.height - 26)
      ..lineTo(-2, s.height - 8)
      ..lineTo(24, s.height - 14)
      ..close();
    c.drawPath(p, relleno(const Color(0xFFFFD6DC)));
  }

  @override
  bool shouldRepaint(_PintorColita old) => false;
}

// ---------------------------------------------------------------------------
// Estrellas, tarjetas y celebración
// ---------------------------------------------------------------------------

class FilaEstrellas extends StatelessWidget {
  const FilaEstrellas(
    this.n, {
    super.key,
    this.max = 3,
    this.tam = 20,
    this.vacia = Colors.black26,
  });
  final int n;
  final int max;
  final double tam;
  final Color vacia;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          max,
          (i) => Icon(
            i < n ? Icons.star_rounded : Icons.star_outline_rounded,
            size: tam,
            color: i < n ? const Color(0xFFFFC107) : vacia,
          ),
        ),
      );
}

/// Tarjeta gruesa y colorida que entra rebotando y se "aplasta" al tocarla.
class TarjetaActividad extends StatelessWidget {
  const TarjetaActividad({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
    required this.onTap,
    this.estrellas,
    this.ilustracion,
    this.indice = 0,
  });
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;
  final VoidCallback onTap;
  final int? estrellas;
  final Widget? ilustracion;
  final int indice;

  @override
  Widget build(BuildContext context) {
    return Entrada(
      indice: indice,
      desde: Offset(indice.isEven ? -60 : 60, 0),
      child: Rebote(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [aclarar(color, 0.12), oscurecer(color, 0.05)],
            ),
            boxShadow: [
              BoxShadow(
                color: oscurecer(color, 0.3),
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Círculos decorativos
              Positioned(
                right: -30,
                top: -40,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
              ),
              Row(
                children: [
                  ilustracion ??
                      Movimiento(
                        tipo: TipoMovimiento.balancear,
                        fase: indice * 0.7,
                        intensidad: 0.6,
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: oscurecer(color, 0.35),
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(icono, color: color, size: 36),
                        ),
                      ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.15,
                            shadows: [
                              Shadow(
                                color: oscurecer(color, 0.4),
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          subtitulo,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.92),
                          ),
                        ),
                        if (estrellas != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: FilaEstrellas(estrellas!),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> mostrarCelebracion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required int estrellas,
  List<Insignia> insignias = const [],
}) {
  HapticFeedback.mediumImpact();
  return showGeneralDialog(
    useRootNavigator: false,
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: (_, anim, __, child) => ScaleTransition(
      scale: CurvedAnimation(parent: anim, curve: Curves.elasticOut),
      child: child,
    ),
    pageBuilder: (ctx, _, __) {
      final tam = MediaQuery.sizeOf(ctx);
      final horizontal = tam.width > tam.height && tam.height < 600;
      final zati = SizedBox(
        width: 170,
        height: horizontal ? 190 : 130,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Movimiento(
              tipo: TipoMovimiento.girar,
              intensidad: 0.5,
              child: SizedBox(
                width: 170,
                height: 170,
                child: CustomPaint(painter: _PintorRayos()),
              ),
            ),
            ZatiMascota(
              tam: horizontal ? 170 : 125,
              emocion:
                  estrellas >= 2 ? EmocionCora.feliz : EmocionCora.pensando,
              hablando: true,
            ),
          ],
        ),
      );
      final estrellasFila = Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 700 + i * 350),
            curve: Curves.elasticOut,
            builder: (_, v, __) => Transform.rotate(
              angle: (1 - v) * 2,
              child: Transform.scale(
                scale: i < estrellas ? v : 1,
                child: Padding(
                  padding: EdgeInsets.only(bottom: i == 1 ? 14 : 0),
                  child: Icon(
                    i < estrellas
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: i == 1 ? 70 : 54,
                    color: i < estrellas
                        ? const Color(0xFFFFC107)
                        : Colors.black26,
                    shadows: i < estrellas
                        ? const [
                            Shadow(
                              color: Color(0xFFFF8F00),
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          );
        }),
      );
      final contenido = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFF6B00),
            ),
          ),
          const SizedBox(height: 6),
          estrellasFila,
          const SizedBox(height: 8),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 17, height: 1.3),
          ),
          for (final ins in insignias) ...[
            const SizedBox(height: 12),
            Entrada(
              indice: 6,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ins.color, aclarar(ins.color, 0.3)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Movimiento(
                      tipo: TipoMovimiento.latir,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(ins.icono, color: ins.color, size: 28),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '¡NUEVA INSIGNIA!\n${ins.nombre}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
      final boton = BotonJuego(
        texto: '¡Genial!',
        icono: Icons.thumb_up_rounded,
        color: const Color(0xFFFF8A00),
        grande: true,
        onTap: () => Navigator.of(ctx).pop(),
      );
      return Theme(
        data: temaJuego(),
        child: Stack(
          children: [
            if (estrellas > 0) const Positioned.fill(child: LluviaConfeti()),
            Center(
              child: Padding(
                padding: EdgeInsets.all(horizontal ? 12 : 24),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: horizontal ? 680 : 420,
                      maxHeight: tam.height - 24,
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: const Color(0xFFFFD54F),
                        width: 4,
                      ),
                    ),
                    child: horizontal
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              zati,
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: SingleChildScrollView(
                                        child: contenido,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    boton,
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              zati,
                              Flexible(
                                child: SingleChildScrollView(child: contenido),
                              ),
                              const SizedBox(height: 14),
                              boton,
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class _PintorRayos extends CustomPainter {
  const _PintorRayos();
  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset.zero);
    final r = s.shortestSide / 2;
    for (var i = 0; i < 12; i++) {
      final a = i / 12 * 2 * math.pi;
      final p = Path()
        ..moveTo(centro.dx, centro.dy)
        ..lineTo(
          centro.dx + math.cos(a - 0.13) * r,
          centro.dy + math.sin(a - 0.13) * r,
        )
        ..lineTo(
          centro.dx + math.cos(a + 0.13) * r,
          centro.dy + math.sin(a + 0.13) * r,
        )
        ..close();
      c.drawPath(
        p,
        relleno(
          (i.isEven ? const Color(0xFFFFE082) : const Color(0xFFFFF3C4))
              .withValues(alpha: 0.9),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(_PintorRayos old) => false;
}

/// Barra superior de colores (con forma de ola) usada en todas las pantallas.
PreferredSizeWidget barraJuego(
  String titulo,
  Color color, {
  List<Widget>? acciones,
}) =>
    BarraJuego(titulo: titulo, color: color, acciones: acciones);
