import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'comunes.dart';

/// Dibujos de la Misión 1 (sistema circulatorio).

const rojoArteria = Color(0xFFE5223B);
const azulVena = Color(0xFF2F6BE0);
const moradoCapilar = Color(0xFFB04FD0);

Paint _trazo(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round;

void _tubo(Canvas c, Path p, Color color, double ancho) {
  c.drawPath(p, _trazo(oscurecer(color, 0.35), ancho + 3));
  c.drawPath(p, _trazo(color, ancho));
  c.drawPath(
    p.shift(Offset(-ancho * 0.18, -ancho * 0.18)),
    _trazo(Colors.white.withValues(alpha: 0.35), ancho * 0.25),
  );
}

/// Corazón anatómico con aorta, venas cavas, arteria pulmonar y coronarias.
/// [resaltar]: 'corazon', 'arterias' o 'venas'.
void corazonAnatomico(
  Canvas c,
  Rect r0, {
  double latido = 0,
  String? resaltar,
}) {
  final lado = r0.shortestSide;
  final r = Rect.fromCenter(
    center: r0.center,
    width: lado,
    height: lado,
  ).inflate(lado * 0.035 * latido);
  final w = r.width;
  Path ruta(List<List<double>> pts) {
    final t = Trazo(r)..m(pts[0][0], pts[0][1]);
    for (var i = 1; i < pts.length; i++) {
      if (pts[i].length == 4) {
        t.q(pts[i][0], pts[i][1], pts[i][2], pts[i][3]);
      } else {
        t.l(pts[i][0], pts[i][1]);
      }
    }
    return t.path;
  }

  final brillo = resaltar == null ? 1.0 : 0.55;
  Color tono(Color col, String grupo) => resaltar == null || resaltar == grupo
      ? col
      : Color.lerp(col, Colors.white, 0.45)!;

  if (resaltar != null) {
    final grupo = resaltar!;
    final halo = Paint()
      ..color = (grupo == 'venas' ? azulVena : rojoArteria).withValues(
        alpha: 0.25,
      )
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    if (grupo == 'corazon')
      c.drawCircle(r.center + Offset(0, w * 0.15), w * 0.42, halo);
  }

  // Venas cavas (azules)
  final cavas = tono(azulVena, 'venas');
  _tubo(
    c,
    ruta([
      [0.31, 0.0],
      [0.32, 0.2, 0.33, 0.4],
    ]),
    cavas,
    w * 0.11,
  );
  _tubo(
    c,
    ruta([
      [0.3, 0.68],
      [0.28, 0.8, 0.27, 0.93],
    ]),
    cavas,
    w * 0.1,
  );
  // Arteria pulmonar (azul violáceo, lleva sangre sin oxígeno)
  final pulmonar = tono(const Color(0xFF5B5BD6), 'arterias');
  _tubo(
    c,
    ruta([
      [0.56, 0.42],
      [0.58, 0.22, 0.72, 0.2],
      [0.86, 0.19],
    ]),
    pulmonar,
    w * 0.1,
  );
  _tubo(
    c,
    ruta([
      [0.6, 0.24],
      [0.5, 0.2, 0.4, 0.24],
    ]),
    pulmonar,
    w * 0.075,
  );
  // Venas pulmonares (rojas pequeñas)
  final venPul = tono(const Color(0xFFD9364F), 'venas');
  _tubo(
    c,
    ruta([
      [0.78, 0.36],
      [0.92, 0.33],
    ]),
    venPul,
    w * 0.05,
  );
  _tubo(
    c,
    ruta([
      [0.78, 0.44],
      [0.92, 0.46],
    ]),
    venPul,
    w * 0.05,
  );
  // Aorta con sus ramas
  final aorta = tono(rojoArteria, 'arterias');
  _tubo(
    c,
    ruta([
      [0.5, 0.04],
      [0.49, -0.03],
    ]),
    aorta,
    w * 0.055,
  );
  _tubo(
    c,
    ruta([
      [0.57, 0.02],
      [0.57, -0.05],
    ]),
    aorta,
    w * 0.055,
  );
  _tubo(
    c,
    ruta([
      [0.63, 0.04],
      [0.66, -0.03],
    ]),
    aorta,
    w * 0.055,
  );
  _tubo(
    c,
    ruta([
      [0.47, 0.44],
      [0.44, 0.1, 0.58, 0.07],
      [0.72, 0.04, 0.72, 0.3],
    ]),
    aorta,
    w * 0.12,
  );

  // Aurícula derecha (detrás)
  final auricula = Rect.fromLTRB(
    r.left + w * 0.19,
    r.top + w * 0.3,
    r.left + w * 0.45,
    r.top + w * 0.6,
  );
  c.drawOval(
    auricula,
    Paint()..color = tono(const Color(0xFFB8283E), 'corazon'),
  );
  // Cuerpo del corazón
  final cuerpo = Trazo(r)
    ..m(0.34, 0.36)
    ..c(0.18, 0.5, 0.26, 0.8, 0.6, 0.98)
    ..c(0.86, 0.78, 0.94, 0.5, 0.8, 0.34)
    ..c(0.7, 0.26, 0.5, 0.28, 0.34, 0.36)
    ..z();
  c.drawPath(
    cuerpo.path.shift(Offset(0, w * 0.02)),
    Paint()..color = const Color(0xFF8A1022).withValues(alpha: brillo),
  );
  c.drawPath(
    cuerpo.path,
    Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.3),
        radius: 0.8,
        colors: [
          tono(const Color(0xFFFF6F7E), 'corazon'),
          tono(const Color(0xFFE02A40), 'corazon'),
          tono(const Color(0xFF9E1328), 'corazon'),
        ],
        stops: const [0, 0.55, 1],
      ).createShader(r),
  );
  // Vasos coronarios (amarillos)
  final coronaria = _trazo(tono(const Color(0xFFFFD54F), 'corazon'), w * 0.022);
  c.drawPath(
    ruta([
      [0.58, 0.36],
      [0.54, 0.62, 0.62, 0.93],
    ]),
    coronaria,
  );
  c.drawPath(
    ruta([
      [0.56, 0.55],
      [0.66, 0.6, 0.74, 0.72],
    ]),
    coronaria,
  );
  c.drawPath(
    ruta([
      [0.55, 0.7],
      [0.45, 0.72, 0.38, 0.66],
    ]),
    coronaria,
  );
  c.drawPath(
    ruta([
      [0.4, 0.4],
      [0.33, 0.5, 0.36, 0.62],
    ]),
    coronaria,
  );
  // Brillo
  c.drawPath(
    ruta([
      [0.3, 0.48],
      [0.28, 0.58, 0.34, 0.68],
    ]),
    _trazo(Colors.white.withValues(alpha: 0.55), w * 0.035),
  );
  if (resaltar == 'corazon') {
    c.drawPath(cuerpo.path, _trazo(const Color(0xFFFFF176), w * 0.03));
  }
}

class PintorCorazonAnatomico extends CustomPainter {
  PintorCorazonAnatomico(this.t, {this.resaltar, this.bpm = 72});
  final double t;
  final String? resaltar;
  final double bpm;
  @override
  void paint(Canvas c, Size s) {
    final fase = (t * bpm / 60) % 1.0;
    final lat = math.exp(-math.pow((fase - 0.15) / 0.07, 2)) +
        0.5 * math.exp(-math.pow((fase - 0.35) / 0.07, 2));
    corazonAnatomico(
      c,
      Offset.zero & s,
      latido: lat.toDouble(),
      resaltar: resaltar,
    );
  }

  @override
  bool shouldRepaint(PintorCorazonAnatomico old) => true;
}

// ---------------------------------------------------------------------------
// Niño con la red de vasos sanguíneos
// ---------------------------------------------------------------------------

/// Puntos importantes del niño (en fracciones de la caja de la silueta).
class PuntosNino {
  static const corazon = Offset(0.55, 0.31);
  static const venaCuello = Offset(0.455, 0.135);
  static const arteriaBrazo = Offset(0.79, 0.37);
  static const venaBrazo = Offset(0.2, 0.36);
  static const capilaresMano = Offset(0.9, 0.53);
  static const arteriaPierna = Offset(0.62, 0.74);
  static const pulmones = Offset(0.4, 0.24);
  static const nariz = Offset(0.5, 0.085);
  static const traquea = Offset(0.5, 0.16);
  static const intestinos = Offset(0.5, 0.47);
}

final _arterias = <List<Offset>>[
  [
    const Offset(0.55, 0.31),
    const Offset(0.53, 0.2),
    const Offset(0.535, 0.13),
    const Offset(0.53, 0.05),
  ],
  [
    const Offset(0.55, 0.31),
    const Offset(0.44, 0.205),
    const Offset(0.3, 0.215),
    const Offset(0.215, 0.35),
    const Offset(0.12, 0.52),
  ],
  [
    const Offset(0.55, 0.31),
    const Offset(0.63, 0.2),
    const Offset(0.72, 0.215),
    const Offset(0.79, 0.35),
    const Offset(0.885, 0.52),
  ],
  [
    const Offset(0.55, 0.31),
    const Offset(0.53, 0.42),
    const Offset(0.51, 0.5),
    const Offset(0.41, 0.56),
    const Offset(0.4, 0.75),
    const Offset(0.385, 0.94),
  ],
  [
    const Offset(0.51, 0.5),
    const Offset(0.6, 0.56),
    const Offset(0.615, 0.75),
    const Offset(0.625, 0.94),
  ],
];

List<Offset> _desplazar(List<Offset> pts, double dx) => [
      for (final p in pts) p + Offset(dx, 0),
    ];

final _venas = <List<Offset>>[
  _desplazar(_arterias[0], -0.075),
  _desplazar(
    _arterias[1],
    -0.02,
  ).map((p) => p + const Offset(0, 0.02)).toList(),
  _desplazar(_arterias[2], 0.02).map((p) => p + const Offset(0, 0.02)).toList(),
  _desplazar(_arterias[3], -0.05),
  _desplazar(_arterias[4], 0.035),
];

const _extremos = [
  Offset(0.495, 0.045),
  Offset(0.11, 0.54),
  Offset(0.895, 0.54),
  Offset(0.37, 0.95),
  Offset(0.645, 0.95),
];

Path _rutaSuave(Rect caja, List<Offset> pts) {
  Offset p(Offset f) => Silueta.punto(caja, f);
  final path = Path()..moveTo(p(pts[0]).dx, p(pts[0]).dy);
  for (var i = 1; i < pts.length - 1; i++) {
    final m = Offset.lerp(p(pts[i]), p(pts[i + 1]), 0.5)!;
    path.quadraticBezierTo(p(pts[i]).dx, p(pts[i]).dy, m.dx, m.dy);
  }
  path.lineTo(p(pts.last).dx, p(pts.last).dy);
  return path;
}

void dibujarCaraNino(Canvas c, Rect caja, double t) {
  final h = caja.height;
  final w = caja.width;
  Offset p(double x, double y) => Silueta.punto(caja, Offset(x, y));
  final short = RRect.fromRectAndCorners(
    Rect.fromPoints(p(0.27, 0.5), p(0.73, 0.64)),
    bottomLeft: Radius.circular(w * 0.06),
    bottomRight: Radius.circular(w * 0.06),
  );
  c.drawRRect(
    short,
    Paint()..color = const Color(0xFF3D7BE0).withValues(alpha: 0.9),
  );
  final cabeza = p(0.5, 0.075);
  final rc = 0.068 * h;
  c.drawArc(
    Rect.fromCircle(center: cabeza + Offset(0, -rc * 0.12), radius: rc * 1.08),
    math.pi * 1.02,
    math.pi * 0.96,
    true,
    Paint()..color = const Color(0xFF6D3B1F),
  );
  c.drawCircle(
    cabeza + Offset(rc * 0.5, -rc * 0.75),
    rc * 0.32,
    Paint()..color = const Color(0xFF6D3B1F),
  );
  final parpadeo = (t % 3.4) > 3.25;
  for (final dx in [-0.35, 0.35]) {
    final ojo = cabeza + Offset(dx * rc, rc * 0.05);
    if (parpadeo) {
      c.drawLine(
        ojo - Offset(rc * 0.12, 0),
        ojo + Offset(rc * 0.12, 0),
        _trazo(const Color(0xFF3B2416), rc * 0.08),
      );
    } else {
      c.drawCircle(ojo, rc * 0.14, Paint()..color = const Color(0xFF3B2416));
      c.drawCircle(
        ojo + Offset(-rc * 0.04, -rc * 0.05),
        rc * 0.05,
        Paint()..color = Colors.white,
      );
    }
  }
  for (final dx in [-0.55, 0.55]) {
    c.drawCircle(
      cabeza + Offset(dx * rc, rc * 0.35),
      rc * 0.14,
      Paint()..color = const Color(0x55FF7A7A),
    );
  }
  c.drawArc(
    Rect.fromCenter(
      center: cabeza + Offset(0, rc * 0.38),
      width: rc * 0.6,
      height: rc * 0.35,
    ),
    0.15,
    math.pi - 0.3,
    false,
    _trazo(const Color(0xFFB0473A), rc * 0.08),
  );
}

/// Niño con arterias (rojo), venas (azul), capilares (morado) y corazón.
/// [resaltar]: 'corazon', 'arterias', 'venas' o 'capilares'.
void dibujarNinoCirculatorio(
  Canvas c,
  Rect caja,
  double t, {
  String? resaltar,
  double opacidadPiel = 1,
}) {
  final w = caja.width;
  Silueta.dibujar(
    c,
    caja,
    borde: const Color(0xFFE0A88A),
    opacidad: opacidadPiel,
  );
  dibujarCaraNino(c, caja, t);
  double grosor(String g) => resaltar == g ? w * 0.034 : w * 0.02;
  Color col(Color base, String g) => resaltar == null || resaltar == g
      ? base
      : Color.lerp(base, Colors.white, 0.6)!;

  // Capilares en manos, pies y cabeza
  for (final e in _extremos) {
    final centro = Silueta.punto(caja, e);
    final rr = w * (resaltar == 'capilares' ? 0.07 : 0.05);
    if (resaltar == 'capilares') {
      c.drawCircle(
        centro,
        rr * 1.5 * (1 + 0.15 * math.sin(t * 4)),
        Paint()..color = moradoCapilar.withValues(alpha: 0.25),
      );
    }
    final malla = _trazo(
      col(moradoCapilar, 'capilares'),
      resaltar == 'capilares' ? 2.2 : 1.3,
    );
    for (var k = 0; k < 6; k++) {
      final a = k / 6 * math.pi * 2;
      final q = centro + Offset(math.cos(a), math.sin(a)) * rr;
      c.drawLine(
        centro + Offset(math.cos(a + 1), math.sin(a + 1)) * rr * 0.4,
        q,
        malla,
      );
    }
    c.drawCircle(centro, rr * 0.55, malla);
  }
  final arterias = [for (final a in _arterias) _rutaSuave(caja, a)];
  final venas = [for (final v in _venas) _rutaSuave(caja, v)];
  for (final v in venas) {
    _tubo(c, v, col(azulVena, 'venas'), grosor('venas'));
  }
  for (final a in arterias) {
    _tubo(c, a, col(rojoArteria, 'arterias'), grosor('arterias'));
  }
  // Glóbulos que viajan: rojos salen del corazón, azules regresan
  for (var i = 0; i < arterias.length; i++) {
    for (final m in arterias[i].computeMetrics()) {
      for (var k = 0; k < 3; k++) {
        final u = (t * 0.25 + k / 3 + i * 0.13) % 1;
        c.drawCircle(
          m.getTangentForOffset(u * m.length)!.position,
          w * 0.014,
          Paint()..color = Colors.white,
        );
      }
    }
    for (final m in venas[i].computeMetrics()) {
      for (var k = 0; k < 3; k++) {
        final u = 1 - (t * 0.2 + k / 3 + i * 0.17) % 1;
        c.drawCircle(
          m.getTangentForOffset(u * m.length)!.position,
          w * 0.012,
          Paint()..color = const Color(0xFFBBD3FF),
        );
      }
    }
  }
  final hc = Silueta.punto(caja, PuntosNino.corazon);
  final fase = (t * 1.2) % 1.0;
  final lat = math.exp(-math.pow((fase - 0.15) / 0.07, 2)).toDouble();
  if (resaltar == 'corazon') {
    c.drawCircle(
      hc,
      w * 0.16 * (1 + 0.1 * lat),
      Paint()..color = const Color(0x55FFEB3B),
    );
  }
  corazonAnatomico(
    c,
    Rect.fromCenter(center: hc, width: w * 0.24, height: w * 0.24),
    latido: lat,
  );
}

class PintorNinoCirculatorio extends CustomPainter {
  PintorNinoCirculatorio(this.t, this.caja, {this.resaltar});
  final double t;
  final Rect caja;
  final String? resaltar;
  @override
  void paint(Canvas c, Size s) =>
      dibujarNinoCirculatorio(c, caja, t, resaltar: resaltar);
  @override
  bool shouldRepaint(PintorNinoCirculatorio old) => true;
}

// ---------------------------------------------------------------------------
// Íconos pequeños
// ---------------------------------------------------------------------------

enum TipoIconoVaso { corazon, arteria, vena, capilar }

class IconoVaso extends StatelessWidget {
  const IconoVaso(this.tipo, {super.key});
  final TipoIconoVaso tipo;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _PintorIconoVaso(tipo), size: Size.infinite);
}

class _PintorIconoVaso extends CustomPainter {
  _PintorIconoVaso(this.tipo);
  final TipoIconoVaso tipo;
  @override
  void paint(Canvas c, Size s) {
    final r = Offset.zero & s;
    final w = s.shortestSide;
    switch (tipo) {
      case TipoIconoVaso.corazon:
        corazonAnatomico(c, r.deflate(w * 0.04));
      case TipoIconoVaso.arteria:
      case TipoIconoVaso.vena:
        final color = tipo == TipoIconoVaso.arteria ? rojoArteria : azulVena;
        c.save();
        c.translate(s.width / 2, s.height / 2);
        c.rotate(-0.5);
        final tubo = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset.zero,
            width: w * 0.95,
            height: w * 0.42,
          ),
          Radius.circular(w * 0.2),
        );
        c.drawRRect(
          tubo,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [aclarar(color, 0.3), color, oscurecer(color, 0.3)],
            ).createShader(tubo.outerRect),
        );
        c.drawOval(
          Rect.fromCenter(
            center: Offset(w * 0.38, 0),
            width: w * 0.2,
            height: w * 0.4,
          ),
          Paint()..color = oscurecer(color, 0.45),
        );
        for (final dy in [-0.08, 0.08]) {
          c.drawCircle(
            Offset(w * 0.38, dy * w),
            w * 0.05,
            Paint()..color = const Color(0xFFFF5A6E),
          );
        }
        c.restore();
      case TipoIconoVaso.capilar:
        final centro = r.center;
        final p = _trazo(moradoCapilar, w * 0.07);
        final pr = _trazo(rojoArteria, w * 0.09);
        final pa = _trazo(azulVena, w * 0.09);
        c.drawLine(
          centro + Offset(-w * 0.45, -w * 0.25),
          centro + Offset(-w * 0.15, -w * 0.1),
          pr,
        );
        c.drawLine(
          centro + Offset(w * 0.45, w * 0.25),
          centro + Offset(w * 0.15, w * 0.1),
          pa,
        );
        for (var k = 0; k < 5; k++) {
          final a = k / 5 * math.pi * 2;
          c.drawLine(
            centro,
            centro + Offset(math.cos(a), math.sin(a)) * w * 0.3,
            p,
          );
        }
        c.drawCircle(centro, w * 0.18, p);
    }
  }

  @override
  bool shouldRepaint(_PintorIconoVaso old) => old.tipo != tipo;
}

// ---------------------------------------------------------------------------
// Muñeca, cuello y células
// ---------------------------------------------------------------------------

void _ondas(Canvas c, Offset centro, double r, double t, Color color) {
  for (var k = 0; k < 3; k++) {
    final u = (t * 1.2 + k / 3) % 1;
    c.drawCircle(
      centro,
      r * (0.3 + u),
      _trazo(color.withValues(alpha: (1 - u) * 0.9), 2.5),
    );
  }
  c.drawCircle(centro, r * 0.22, Paint()..color = color);
}

class PintorMuneca extends CustomPainter {
  PintorMuneca(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final piel = Paint()..color = ColoresJuego.piel;
    final borde = _trazo(const Color(0xFFD99A7A), 2);
    // Antebrazo
    final brazo = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.42, w * 0.6, h * 0.3),
      Radius.circular(h * 0.15),
    );
    c.drawRRect(brazo, piel);
    c.drawRRect(brazo, borde);
    // Mano
    c.drawOval(Rect.fromLTWH(w * 0.55, h * 0.34, w * 0.36, h * 0.44), piel);
    c.drawOval(Rect.fromLTWH(w * 0.55, h * 0.34, w * 0.36, h * 0.44), borde);
    // Pulsera rosa
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.44, h * 0.4, w * 0.08, h * 0.34),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFFF7AA8),
    );
    // Dedos que toman el pulso
    final dedos = Paint()..color = const Color(0xFFF2BC98);
    for (var k = 0; k < 2; k++) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * (0.2 + k * 0.1), h * 0.14, w * 0.085, h * 0.36),
        Radius.circular(w * 0.04),
      );
      c.drawRRect(r, dedos);
      c.drawRRect(r, borde);
    }
    _ondas(
      c,
      Offset(w * 0.3, h * 0.55),
      h * 0.22,
      t,
      ColoresJuego.circulatorio,
    );
  }

  @override
  bool shouldRepaint(PintorMuneca old) => true;
}

class PintorCuello extends CustomPainter {
  PintorCuello(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final piel = Paint()..color = ColoresJuego.piel;
    final borde = _trazo(const Color(0xFFD99A7A), 2);
    // Cabeza de perfil y cuello
    c.drawCircle(Offset(w * 0.52, h * 0.3), h * 0.26, piel);
    c.drawCircle(Offset(w * 0.52, h * 0.3), h * 0.26, borde);
    final cuello = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.38, h * 0.45, w * 0.26, h * 0.5),
      Radius.circular(w * 0.06),
    );
    c.drawRRect(cuello, piel);
    c.drawRRect(cuello, borde);
    c.drawArc(
      Rect.fromLTWH(w * 0.3, h * 0.02, w * 0.46, h * 0.3),
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xFF6D3B1F),
    );
    c.drawCircle(
      Offset(w * 0.62, h * 0.3),
      h * 0.03,
      Paint()..color = const Color(0xFF3B2416),
    );
    c.drawArc(
      Rect.fromLTWH(w * 0.6, h * 0.36, w * 0.1, h * 0.08),
      0.2,
      2.4,
      false,
      _trazo(const Color(0xFFB0473A), 2),
    );
    // Dedos
    final dedos = Paint()..color = const Color(0xFFF2BC98);
    for (var k = 0; k < 2; k++) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          w * (0.62 + k * 0.09),
          h * (0.52 + k * 0.05),
          w * 0.3,
          h * 0.11,
        ),
        Radius.circular(h * 0.05),
      );
      c.drawRRect(r, dedos);
      c.drawRRect(r, borde);
    }
    _ondas(c, Offset(w * 0.6, h * 0.62), h * 0.2, t, ColoresJuego.circulatorio);
  }

  @override
  bool shouldRepaint(PintorCuello old) => true;
}

void dibujarCelulas(Canvas c, Rect r, double t, {double oxigeno = 0.5}) {
  final rnd = math.Random(8);
  for (var i = 0; i < 9; i++) {
    final p = Offset(
      r.left + r.width * (0.18 + (i % 3) * 0.32 + rnd.nextDouble() * 0.05),
      r.top + r.height * (0.18 + (i ~/ 3) * 0.32 + rnd.nextDouble() * 0.05),
    );
    final rr = r.shortestSide * (0.15 + 0.01 * math.sin(t * 2 + i));
    c.drawCircle(
      p,
      rr,
      Paint()
        ..color = Color.lerp(
          const Color(0xFFF7B6D2),
          const Color(0xFFFF8FB8),
          oxigeno,
        )!,
    );
    c.drawCircle(p, rr, _trazo(const Color(0xFFD16A9A), 2));
    c.drawCircle(
      p + Offset(rr * 0.15, -rr * 0.1),
      rr * 0.35,
      Paint()..color = const Color(0xFF9C4DCC),
    );
  }
}

/// Burbujita de gas (O₂ o CO₂).
void burbujaGas(Canvas c, Offset p, double r, bool oxigeno) {
  final color = oxigeno ? const Color(0xFF1E88E5) : const Color(0xFF78909C);
  c.drawCircle(p, r, Paint()..color = Colors.white);
  c.drawCircle(p, r, _trazo(color, r * 0.18));
  textoEn(
    c,
    oxigeno ? 'O₂' : 'CO₂',
    p,
    tam: r * (oxigeno ? 0.9 : 0.72),
    color: color,
  );
}
