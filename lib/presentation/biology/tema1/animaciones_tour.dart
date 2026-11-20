import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'aventura.dart' show EstacionCuerpo;
import 'comunes.dart';
import 'contenido.dart';

/// Animaciones 2D que acompañan cada escena del recorrido interactivo.
/// Todas dibujan en coordenadas relativas al área (0–1) para que los puntos
/// de interés definidos en contenido.dart coincidan con el dibujo.

Widget construirAnimacion(AnimTour tipo) {
  switch (tipo) {
    case AnimTour.queEsCuerpo:
      return Animado((t) => CustomPaint(painter: _PintorQueEsCuerpo(t)));
    case AnimTour.estacion:
      return const Padding(
        padding: EdgeInsets.all(18),
        child: EstacionCuerpo(),
      );
    case AnimTour.niveles:
      return const _AnimNiveles();
    case AnimTour.organos:
      return Animado((t) => CustomPaint(painter: _PintorOrganos(t)));
    case AnimTour.sistemasEquipo:
      return const _AnimSistemas();
    case AnimTour.corazon:
      return const _AnimCorazon();
    case AnimTour.circuito:
      return Animado((t) => CustomPaint(painter: _PintorCircuito(t)));
    case AnimTour.sangre:
      return Animado((t) => CustomPaint(painter: _PintorSangre(t)));
    case AnimTour.viaAire:
      return Animado((t) => CustomPaint(painter: _PintorViaAire(t)));
    case AnimTour.diafragma:
      return const _AnimDiafragma();
    case AnimTour.alveolo:
      return Animado((t) => CustomPaint(painter: _PintorAlveolo(t)));
    case AnimTour.barreras:
      return Animado((t) => CustomPaint(painter: _PintorBarreras(t)));
    case AnimTour.fagocito:
      return const _AnimFagocito();
    case AnimTour.anticuerpos:
      return Animado((t) => CustomPaint(painter: _PintorAnticuerpos(t)));
    case AnimTour.vacuna:
      return Animado((t) => CustomPaint(painter: _PintorVacuna(t)));
    case AnimTour.habitos:
      return const _Habitos();
  }
}

/// Reconstruye su contenido en cada cuadro con el tiempo en segundos.
class Animado extends StatefulWidget {
  const Animado(this.builder, {super.key});
  final Widget Function(double t) builder;
  @override
  State<Animado> createState() => _AnimadoState();
}

class _AnimadoState extends State<Animado> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _t = 0;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker((d) => setState(() => _t = d.inMicroseconds / 1e6))
      ..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      SizedBox.expand(child: widget.builder(_t));
}

Offset _f(Size s, double x, double y) => Offset(x * s.width, y * s.height);

double _suave(double x) {
  final v = x.clamp(0.0, 1.0);
  return v * v * (3 - 2 * v);
}

// Dibujos reutilizables -------------------------------------------------------

void dibujarCelula(
  Canvas c,
  Offset centro,
  double r,
  double t, {
  Color membrana = const Color(0xFFFFCDD2),
  Color nucleo = const Color(0xFF8E24AA),
}) {
  final path = Path();
  for (var i = 0; i <= 40; i++) {
    final a = i / 40 * 2 * math.pi;
    final rr = r * (1 + 0.04 * math.sin(a * 4 + t * 2));
    final p = centro + Offset(math.cos(a), math.sin(a)) * rr;
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  path.close();
  c.drawPath(path, relleno(membrana.withValues(alpha: 0.85)));
  c.drawPath(path, linea(Color.lerp(membrana, Colors.black, 0.3)!, r * 0.05));
  c.drawCircle(
    centro + Offset(r * 0.1, -r * 0.05),
    r * 0.32,
    relleno(nucleo.withValues(alpha: 0.8)),
  );
  for (var i = 0; i < 4; i++) {
    final a = i * 1.7 + t * 0.3;
    c.drawOval(
      Rect.fromCenter(
        center: centro + Offset(math.cos(a), math.sin(a)) * r * 0.62,
        width: r * 0.22,
        height: r * 0.12,
      ),
      relleno(const Color(0xFFFF8A65)),
    );
  }
}

void dibujarGloboRojo(Canvas c, Offset centro, double r, {double oxigeno = 1}) {
  final color = Color.lerp(
    const Color(0xFF8E3A59),
    const Color(0xFFE53935),
    oxigeno,
  )!;
  c.drawCircle(centro, r, relleno(color));
  c.drawCircle(
    centro,
    r * 0.5,
    relleno(Color.lerp(color, Colors.black, 0.18)!),
  );
  c.drawCircle(
    centro,
    r,
    linea(Color.lerp(color, Colors.black, 0.3)!, r * 0.12),
  );
}

void dibujarGloboBlanco(Canvas c, Offset centro, double r, double t) {
  final path = Path();
  for (var i = 0; i <= 36; i++) {
    final a = i / 36 * 2 * math.pi;
    final rr = r * (1 + 0.07 * math.sin(a * 6 + t * 3));
    final p = centro + Offset(math.cos(a), math.sin(a)) * rr;
    i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
  }
  path.close();
  c.drawPath(path, relleno(const Color(0xFFF3EEFF)));
  c.drawPath(path, linea(const Color(0xFFB39DDB), r * 0.06));
  for (final o in [
    const Offset(-0.3, -0.1),
    const Offset(0.05, 0.15),
    const Offset(0.3, -0.15),
  ]) {
    c.drawCircle(centro + o * r, r * 0.24, relleno(const Color(0xFF7E57C2)));
  }
}

void dibujarBacteria(
  Canvas c,
  Offset centro,
  double r,
  double ang,
  double t, {
  Color color = const Color(0xFF66BB6A),
}) {
  c.save();
  c.translate(centro.dx, centro.dy);
  c.rotate(ang);
  final cola = Path()..moveTo(-r * 1.1, 0);
  for (var i = 1; i <= 6; i++) {
    cola.lineTo(-r * 1.1 - i * r * 0.18, math.sin(t * 10 + i) * r * 0.2);
  }
  c.drawPath(cola, linea(Color.lerp(color, Colors.black, 0.3)!, r * 0.08));
  final cuerpo = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset.zero, width: r * 2.2, height: r * 1.1),
    Radius.circular(r * 0.55),
  );
  c.drawRRect(cuerpo, relleno(color));
  c.drawRRect(cuerpo, linea(Color.lerp(color, Colors.black, 0.3)!, r * 0.1));
  c.drawCircle(Offset(r * 0.5, -r * 0.12), r * 0.12, relleno(Colors.black87));
  c.drawCircle(Offset(r * 0.2, -r * 0.12), r * 0.12, relleno(Colors.black87));
  c.restore();
}

void dibujarVirus(
  Canvas c,
  Offset centro,
  double r,
  double t, {
  Color color = const Color(0xFF43A047),
}) {
  for (var i = 0; i < 10; i++) {
    final a = i / 10 * 2 * math.pi + t * 0.5;
    final d = Offset(math.cos(a), math.sin(a));
    c.drawLine(
      centro + d * r * 0.9,
      centro + d * r * 1.35,
      linea(Color.lerp(color, Colors.black, 0.2)!, r * 0.12),
    );
    c.drawCircle(
      centro + d * r * 1.4,
      r * 0.16,
      relleno(const Color(0xFFFFA726)),
    );
  }
  c.drawCircle(centro, r, relleno(color));
  c.drawCircle(
    centro + Offset(-r * 0.3, -r * 0.3),
    r * 0.25,
    relleno(Colors.white.withValues(alpha: 0.3)),
  );
}

void dibujarAnticuerpo(Canvas c, Offset p, double tam, double ang) {
  c.save();
  c.translate(p.dx, p.dy);
  c.rotate(ang);
  final pt = linea(const Color(0xFFFFC107), tam * 0.22);
  c.drawLine(Offset(0, tam * 0.6), Offset.zero, pt);
  c.drawLine(Offset.zero, Offset(-tam * 0.45, -tam * 0.5), pt);
  c.drawLine(Offset.zero, Offset(tam * 0.45, -tam * 0.5), pt);
  c.restore();
}

// 1. Niveles de organización ---------------------------------------------------

class _AnimNiveles extends StatefulWidget {
  const _AnimNiveles();
  @override
  State<_AnimNiveles> createState() => _AnimNivelesState();
}

class _AnimNivelesState extends State<_AnimNiveles> {
  int _nivel = 0;
  double _inicio = 0;
  double _ultimoT = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _nivel = (_nivel + 1) % 5;
        _inicio = _ultimoT;
      }),
      child: Animado((t) {
        _ultimoT = t;
        return CustomPaint(
          painter: _PintorNiveles(
            t,
            _nivel,
            ((t - _inicio) / 0.6).clamp(0.0, 1.0),
          ),
        );
      }),
    );
  }
}

class _PintorNiveles extends CustomPainter {
  _PintorNiveles(this.t, this.nivel, this.entrada);
  final double t;
  final int nivel;
  final double entrada;
  static const nombres = ['Célula', 'Tejido', 'Órgano', 'Sistema', 'Organismo'];

  @override
  void paint(Canvas c, Size s) {
    final centro = _f(s, 0.5, 0.4);
    final tam = math.min(s.width * 0.5, s.height * 0.62);
    final esc = 0.6 + 0.4 * Curves.elasticOut.transform(entrada);
    c.save();
    c.translate(centro.dx, centro.dy);
    c.scale(esc);
    c.translate(-centro.dx, -centro.dy);
    final caja = Rect.fromCenter(center: centro, width: tam, height: tam);
    switch (nivel) {
      case 0:
        dibujarCelula(c, centro, tam * 0.38, t);
      case 1:
        for (var fila = 0; fila < 5; fila++) {
          for (var col = 0; col < 6; col++) {
            final p = caja.topLeft +
                Offset(
                  (col + (fila.isOdd ? 0.5 : 0)) * tam / 5.5 + tam * 0.05,
                  fila * tam / 5 + tam * 0.1,
                );
            dibujarCelula(
              c,
              p,
              tam * 0.085,
              t + fila + col,
              membrana: const Color(0xFFEF9A9A),
              nucleo: const Color(0xFF6A1B9A),
            );
          }
        }
      case 2:
        final lat = math.pow(math.max(0, math.sin(t * 7)), 6).toDouble();
        DibujoOrganos.corazon(c, caja.deflate(tam * 0.08), latido: lat);
      case 3:
        final ramas = [
          [0.5, 0.5, 0.5, 0.0],
          [0.5, 0.5, 0.05, 0.3],
          [0.5, 0.5, 0.95, 0.3],
          [0.5, 0.5, 0.2, 1.0],
          [0.5, 0.5, 0.8, 1.0],
          [0.5, 0.5, 0.0, 0.7],
          [0.5, 0.5, 1.0, 0.7],
        ];
        for (var i = 0; i < ramas.length; i++) {
          final r = ramas[i];
          final a = caja.topLeft + Offset(r[0] * tam, r[1] * tam);
          final b = caja.topLeft + Offset(r[2] * tam, r[3] * tam);
          c.drawLine(
            a + const Offset(-3, 0),
            b + const Offset(-3, 0),
            linea(ColoresJuego.sangrePobre, tam * 0.03),
          );
          c.drawLine(
            a + const Offset(3, 0),
            b + const Offset(3, 0),
            linea(ColoresJuego.sangreRica, tam * 0.03),
          );
          final k = (t * 0.6 + i * 0.13) % 1;
          c.drawCircle(
            Offset.lerp(a, b, k)!,
            tam * 0.025,
            relleno(Colors.white),
          );
        }
        DibujoOrganos.corazon(
          c,
          Rect.fromCenter(
            center: centro,
            width: tam * 0.35,
            height: tam * 0.35,
          ),
        );
      default:
        final b = Silueta.caja(Size(tam, tam)).shift(caja.topLeft);
        Silueta.dibujar(c, b);
        for (final o in posicionesOrganos) {
          final p = Silueta.punto(b, o.centro);
          DibujoOrganos.dibujar(
            c,
            Rect.fromCenter(
              center: p,
              width: o.tamano.width * b.width,
              height: o.tamano.height * b.height,
            ),
            o.id,
          );
        }
    }
    c.restore();
    // Fila inferior de niveles
    for (var i = 0; i < 5; i++) {
      final p = _f(s, 0.1 + i * 0.2, 0.89);
      final activo = i == nivel;
      c.drawCircle(
        p,
        s.height * (activo ? 0.065 : 0.05),
        relleno(activo ? ColoresJuego.intro : Colors.white),
      );
      c.drawCircle(
        p,
        s.height * (activo ? 0.065 : 0.05),
        linea(ColoresJuego.intro, 2),
      );
      textoEn(
        c,
        '${i + 1}',
        p,
        tam: s.height * 0.05,
        color: activo ? Colors.white : ColoresJuego.intro,
      );
      if (i < 4) {
        c.drawLine(
          p + Offset(s.height * 0.07, 0),
          _f(s, 0.3 + i * 0.2, 0.89) - Offset(s.height * 0.07, 0),
          linea(ColoresJuego.intro.withValues(alpha: 0.4), 2),
        );
      }
    }
    textoEn(
      c,
      nombres[nivel],
      _f(s, 0.5, 0.75),
      tam: s.height * 0.065,
      color: Colors.white,
      fondo: ColoresJuego.intro,
    );
  }

  @override
  bool shouldRepaint(_PintorNiveles old) => true;
}

// 2. Órganos principales -------------------------------------------------------

class _PintorOrganos extends CustomPainter {
  _PintorOrganos(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final b = Silueta.caja(s);
    Silueta.dibujar(c, b, borde: const Color(0xFFE0A88A));
    for (final o in posicionesOrganos) {
      final p = Silueta.punto(b, o.centro) +
          Offset(0, math.sin(t * 2 + o.centro.dx * 9) * 1.5);
      final r = Rect.fromCenter(
        center: p,
        width: o.tamano.width * b.width,
        height: o.tamano.height * b.height,
      );
      if (o.id == 'corazon') {
        DibujoOrganos.corazon(
          c,
          r,
          latido: math.pow(math.max(0, math.sin(t * 7)), 6).toDouble(),
        );
      } else if (o.id == 'pulmones') {
        DibujoOrganos.pulmones(c, r, inflado: (1 - math.cos(t * 1.4)) / 2);
      } else {
        DibujoOrganos.dibujar(c, r, o.id);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorOrganos old) => true;
}

// 3. Sistemas en equipo --------------------------------------------------------

class _AnimSistemas extends StatefulWidget {
  const _AnimSistemas();
  @override
  State<_AnimSistemas> createState() => _AnimSistemasState();
}

class _AnimSistemasState extends State<_AnimSistemas> {
  final _activos = <String>{'circulatorio'};
  @override
  Widget build(BuildContext context) {
    Widget chip(String id, String nombre, Color color) => Padding(
          padding: const EdgeInsets.all(3),
          child: FilterChip(
            label: Text(nombre, style: const TextStyle(fontSize: 12)),
            selected: _activos.contains(id),
            selectedColor: color.withValues(alpha: 0.25),
            checkmarkColor: color,
            visualDensity: VisualDensity.compact,
            onSelected: (v) =>
                setState(() => v ? _activos.add(id) : _activos.remove(id)),
          ),
        );
    return Stack(
      children: [
        Animado(
          (t) => CustomPaint(painter: _PintorSistemas(t, Set.of(_activos))),
        ),
        Positioned(
          left: 4,
          top: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              chip('circulatorio', 'Circulatorio', ColoresJuego.circulatorio),
              chip('respiratorio', 'Respiratorio', ColoresJuego.respiratorio),
              chip('inmune', 'Inmunológico', ColoresJuego.inmune),
            ],
          ),
        ),
      ],
    );
  }
}

class _PintorSistemas extends CustomPainter {
  _PintorSistemas(this.t, this.activos);
  final double t;
  final Set<String> activos;

  @override
  void paint(Canvas c, Size s) {
    final b = Silueta.caja(s);
    Silueta.dibujar(c, b, opacidad: 0.7, borde: const Color(0xFFE0A88A));
    Offset p(double x, double y) => Silueta.punto(b, Offset(x, y));
    final w = b.width;

    if (activos.contains('respiratorio')) {
      c.drawLine(
        p(0.5, 0.1),
        p(0.5, 0.2),
        linea(const Color(0xFF90CAF9), w * 0.04),
      );
      DibujoOrganos.pulmones(
        c,
        Rect.fromCenter(center: p(0.5, 0.25), width: w * 0.5, height: w * 0.5),
        inflado: (1 - math.cos(t * 1.6)) / 2,
      );
    }
    if (activos.contains('circulatorio')) {
      final corazon = p(0.55, 0.32);
      final destinos = [
        p(0.5, 0.05),
        p(0.12, 0.5),
        p(0.88, 0.5),
        p(0.37, 0.94),
        p(0.63, 0.94),
      ];
      final controles = [
        p(0.52, 0.18),
        p(0.3, 0.22),
        p(0.7, 0.22),
        p(0.4, 0.5),
        p(0.6, 0.5),
      ];
      for (var i = 0; i < destinos.length; i++) {
        for (final venosa in [false, true]) {
          final off = Offset(venosa ? -w * 0.018 : w * 0.018, 0);
          final path = Path()
            ..moveTo(corazon.dx + off.dx, corazon.dy)
            ..quadraticBezierTo(
              controles[i].dx + off.dx,
              controles[i].dy,
              destinos[i].dx + off.dx,
              destinos[i].dy,
            );
          c.drawPath(
            path,
            linea(
              (venosa ? ColoresJuego.sangrePobre : ColoresJuego.sangreRica)
                  .withValues(alpha: 0.85),
              w * 0.022,
            ),
          );
          for (var k = 0; k < 3; k++) {
            var u = (t * 0.35 + k / 3 + i * 0.1) % 1;
            if (venosa) u = 1 - u;
            final a = Offset.lerp(
              Offset.lerp(corazon + off, controles[i] + off, u)!,
              Offset.lerp(controles[i] + off, destinos[i] + off, u)!,
              u,
            )!;
            c.drawCircle(a, w * 0.016, relleno(Colors.white));
          }
        }
      }
      DibujoOrganos.corazon(
        c,
        Rect.fromCenter(center: corazon, width: w * 0.17, height: w * 0.17),
        latido: math.pow(math.max(0, math.sin(t * 7)), 6).toDouble(),
      );
    }
    if (activos.contains('inmune')) {
      final ganglios = [
        p(0.42, 0.14),
        p(0.58, 0.14),
        p(0.3, 0.21),
        p(0.7, 0.21),
        p(0.42, 0.55),
        p(0.58, 0.55),
        p(0.5, 0.42),
      ];
      final ruta = Path()..moveTo(ganglios[0].dx, ganglios[0].dy);
      for (final g in [ganglios[2], ganglios[6], ganglios[4]]) {
        ruta.lineTo(g.dx, g.dy);
      }
      ruta.moveTo(ganglios[1].dx, ganglios[1].dy);
      for (final g in [ganglios[3], ganglios[6], ganglios[5]]) {
        ruta.lineTo(g.dx, g.dy);
      }
      c.drawPath(ruta, linea(const Color(0xFF9CCC65), w * 0.012));
      for (var i = 0; i < ganglios.length; i++) {
        final pul = 1 + 0.25 * math.sin(t * 3 + i);
        c.drawCircle(
          ganglios[i],
          w * 0.04 * pul,
          relleno(const Color(0x557E57C2)),
        );
        c.drawCircle(ganglios[i], w * 0.025, relleno(ColoresJuego.inmune));
      }
      // Escudo
      final e = p(0.5, 0.75);
      final esc = Path()
        ..moveTo(e.dx, e.dy - w * 0.1)
        ..lineTo(e.dx + w * 0.09, e.dy - w * 0.06)
        ..quadraticBezierTo(
          e.dx + w * 0.08,
          e.dy + w * 0.06,
          e.dx,
          e.dy + w * 0.11,
        )
        ..quadraticBezierTo(
          e.dx - w * 0.08,
          e.dy + w * 0.06,
          e.dx - w * 0.09,
          e.dy - w * 0.06,
        )
        ..close();
      c.drawPath(esc, relleno(ColoresJuego.inmune.withValues(alpha: 0.8)));
      c.drawPath(esc, linea(Colors.white, 2));
    }
  }

  @override
  bool shouldRepaint(_PintorSistemas old) => true;
}

// 4. Corazón y sus cavidades ---------------------------------------------------

class _AnimCorazon extends StatefulWidget {
  const _AnimCorazon();
  @override
  State<_AnimCorazon> createState() => _AnimCorazonState();
}

class _AnimCorazonState extends State<_AnimCorazon> {
  double _bpm = 75;
  double _fase = 0;
  double _ultimo = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Animado((t) {
          final dt = (t - _ultimo).clamp(0.0, 0.1);
          _ultimo = t;
          _fase = (_fase + dt * _bpm / 60) % 1;
          return CustomPaint(painter: _PintorCorazon(t, _fase, _bpm));
        }),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              const SizedBox(width: 10),
              Text(
                '${_bpm.round()} lpm',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColoresJuego.circulatorio,
                ),
              ),
              Expanded(
                child: Slider(
                  min: 40,
                  max: 160,
                  value: _bpm,
                  activeColor: ColoresJuego.circulatorio,
                  onChanged: (v) => setState(() => _bpm = v),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PintorCorazon extends CustomPainter {
  _PintorCorazon(this.t, this.fase, this.bpm);
  final double t, fase, bpm;

  @override
  void paint(Canvas c, Size s) {
    // Contracción: aurículas (0–0.15), ventrículos (0.15–0.45)
    final aur = math.sin(math.pi * (fase / 0.15).clamp(0.0, 1.0));
    final ven = math.sin(math.pi * ((fase - 0.15) / 0.3).clamp(0.0, 1.0));
    final h = s.height;
    // Vasos
    void vaso(List<Offset> pts, Color col, double ancho) {
      final path = Path()..moveTo(pts[0].dx, pts[0].dy);
      if (pts.length == 3) {
        path.quadraticBezierTo(pts[1].dx, pts[1].dy, pts[2].dx, pts[2].dy);
      } else {
        path.lineTo(pts[1].dx, pts[1].dy);
      }
      c.drawPath(path, linea(col, ancho));
    }

    vaso(
      [_f(s, 0.3, 0.0), _f(s, 0.38, 0.3)],
      ColoresJuego.sangrePobre,
      h * 0.07,
    );
    vaso(
      [_f(s, 0.42, 0.62), _f(s, 0.4, 0.05), _f(s, 0.2, 0.08)],
      const Color(0xFF7E57C2),
      h * 0.06,
    );
    vaso(
      [_f(s, 0.58, 0.6), _f(s, 0.58, -0.02), _f(s, 0.82, 0.1)],
      const Color(0xFFC62828),
      h * 0.075,
    );
    vaso(
      [_f(s, 0.92, 0.3), _f(s, 0.62, 0.36)],
      ColoresJuego.sangreRica,
      h * 0.05,
    );

    // Silueta del corazón
    final r = Rect.fromLTRB(s.width * 0.2, h * 0.1, s.width * 0.8, h * 0.98);
    final t0 = Trazo(r)
      ..m(0.5, 0.18)
      ..c(0.3, 0.02, 0.0, 0.08, 0.04, 0.42)
      ..c(0.08, 0.7, 0.38, 0.85, 0.5, 0.98)
      ..c(0.62, 0.85, 0.92, 0.7, 0.96, 0.42)
      ..c(1.0, 0.08, 0.7, 0.02, 0.5, 0.18)
      ..z();
    final escala = 1 - 0.03 * ven;
    c.save();
    c.translate(r.center.dx, r.center.dy);
    c.scale(escala);
    c.translate(-r.center.dx, -r.center.dy);
    c.drawPath(t0.path, relleno(const Color(0xFFE57373)));
    c.drawPath(t0.path, linea(const Color(0xFF8E1B1B), 3));

    void camara(
      Offset centro,
      double w,
      double hh,
      double contr,
      Color col,
      String nombre,
    ) {
      final k = 1 - 0.22 * contr;
      final rect = Rect.fromCenter(
        center: centro,
        width: w * k,
        height: hh * k,
      );
      c.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(w * 0.45)),
        relleno(col),
      );
      c.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(w * 0.45)),
        linea(Colors.white.withValues(alpha: 0.6), 2),
      );
      textoEn(c, nombre, centro, tam: h * 0.045, color: Colors.white);
    }

    final W = s.width;
    camara(
      _f(s, 0.39, 0.37),
      W * 0.15,
      h * 0.2,
      aur,
      ColoresJuego.sangrePobre,
      'AD',
    );
    camara(
      _f(s, 0.61, 0.37),
      W * 0.15,
      h * 0.2,
      aur,
      ColoresJuego.sangreRica,
      'AI',
    );
    camara(
      _f(s, 0.41, 0.68),
      W * 0.14,
      h * 0.3,
      ven,
      const Color(0xFF3949AB),
      'VD',
    );
    camara(
      _f(s, 0.59, 0.68),
      W * 0.15,
      h * 0.32,
      ven,
      const Color(0xFFC62828),
      'VI',
    );
    // Tabique
    c.drawLine(
      _f(s, 0.5, 0.25),
      _f(s, 0.5, 0.86),
      linea(const Color(0xFF8E1B1B), W * 0.012),
    );
    // Válvulas: se abren cuando se contraen las aurículas
    for (final x in [0.4, 0.6]) {
      final base = _f(s, x, 0.52);
      final apertura = 0.15 + 0.85 * aur;
      for (final lado in [-1.0, 1.0]) {
        final punta = base +
            Offset(
              lado * W * 0.035 * (1 - apertura),
              h * 0.05 * apertura + h * 0.01,
            );
        c.drawLine(
          base + Offset(lado * W * 0.04, 0),
          punta,
          linea(Colors.white, 3),
        );
      }
    }
    c.restore();

    // Gotitas de sangre
    final derecha = [
      _f(s, 0.3, 0.0),
      _f(s, 0.38, 0.3),
      _f(s, 0.39, 0.4),
      _f(s, 0.41, 0.7),
      _f(s, 0.42, 0.62),
      _f(s, 0.4, 0.15),
      _f(s, 0.2, 0.08),
    ];
    final izquierda = [
      _f(s, 0.92, 0.3),
      _f(s, 0.62, 0.36),
      _f(s, 0.61, 0.4),
      _f(s, 0.59, 0.7),
      _f(s, 0.58, 0.6),
      _f(s, 0.6, 0.1),
      _f(s, 0.82, 0.1),
    ];
    for (final camino in [derecha, izquierda]) {
      for (var i = 0; i < 6; i++) {
        final u = (t * bpm / 150 + i / 6) % 1;
        final seg = u * (camino.length - 1);
        final k = seg.floor().clamp(0, camino.length - 2);
        final p = Offset.lerp(camino[k], camino[k + 1], seg - k)!;
        dibujarGloboRojo(
          c,
          p,
          h * 0.018,
          oxigeno: identical(camino, derecha) ? 0 : 1,
        );
      }
    }
    if (ven > 0.6) {
      textoEn(
        c,
        '¡PUM!',
        _f(s, 0.86, 0.6),
        tam: h * 0.07,
        color: Colors.white,
        fondo: ColoresJuego.circulatorio,
      );
    } else if (aur > 0.6) {
      textoEn(
        c,
        'pum',
        _f(s, 0.86, 0.6),
        tam: h * 0.05,
        color: ColoresJuego.circulatorio,
        fondo: Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_PintorCorazon old) => true;
}

// 5. Circuito de la sangre -------------------------------------------------------

class _PintorCircuito extends CustomPainter {
  _PintorCircuito(this.t);
  final double t;

  // (x, y, oxígeno)
  static const _ruta = [
    [0.6, 0.2, 1.0],
    [0.66, 0.32, 1.0],
    [0.54, 0.44, 1.0],
    [0.56, 0.56, 1.0],
    [0.82, 0.62, 1.0],
    [0.72, 0.86, 1.0],
    [0.5, 0.9, 0.5],
    [0.28, 0.86, 0.0],
    [0.18, 0.62, 0.0],
    [0.44, 0.56, 0.0],
    [0.46, 0.44, 0.0],
    [0.34, 0.32, 0.0],
    [0.4, 0.2, 0.0],
    [0.5, 0.17, 0.5],
    [0.6, 0.2, 1.0],
  ];

  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    final pts = _ruta.map((p) => _f(s, p[0], p[1])).toList();
    Color col(double ox) =>
        Color.lerp(ColoresJuego.sangrePobre, ColoresJuego.sangreRica, ox)!;

    // Cuerpo (capilares)
    final cuerpo = RRect.fromRectAndRadius(
      Rect.fromLTRB(s.width * 0.26, h * 0.8, s.width * 0.74, h * 0.98),
      Radius.circular(h * 0.05),
    );
    c.drawRRect(cuerpo, relleno(const Color(0xFFFFE0CC)));
    for (var i = 0; i < 6; i++) {
      final x = s.width * (0.3 + i * 0.075);
      c.drawLine(
        Offset(x, h * 0.83),
        Offset(x + s.width * 0.03, h * 0.95),
        linea(
          Color.lerp(ColoresJuego.sangreRica, ColoresJuego.sangrePobre, i / 5)!,
          2,
        ),
      );
    }
    textoEn(c, 'Cuerpo', Offset(s.width * 0.5, h * 0.965), tam: h * 0.038);

    // Pulmones
    DibujoOrganos.pulmones(
      c,
      Rect.fromCenter(
        center: _f(s, 0.5, 0.15),
        width: h * 0.3,
        height: h * 0.3,
      ),
      inflado: (1 - math.cos(t * 1.5)) / 2,
    );

    // Vasos
    for (var i = 0; i < pts.length - 1; i++) {
      final a = pts[i], b = pts[i + 1];
      c.drawLine(
        a,
        b,
        Paint()
          ..strokeWidth = h * 0.035
          ..strokeCap = StrokeCap.round
          ..shader = LinearGradient(
            colors: [col(_ruta[i][2]), col(_ruta[i + 1][2])],
          ).createShader(Rect.fromPoints(a, b)),
      );
    }
    // Corazón
    DibujoOrganos.corazon(
      c,
      Rect.fromCenter(
        center: _f(s, 0.5, 0.5),
        width: h * 0.22,
        height: h * 0.22,
      ),
      latido: math.pow(math.max(0, math.sin(t * 6)), 6).toDouble(),
    );

    // Glóbulos viajando
    var total = 0.0;
    final largos = <double>[];
    for (var i = 0; i < pts.length - 1; i++) {
      largos.add((pts[i + 1] - pts[i]).distance);
      total += largos.last;
    }
    for (var k = 0; k < 16; k++) {
      var d = ((t * 0.07 + k / 16) % 1) * total;
      var i = 0;
      while (i < largos.length - 1 && d > largos[i]) {
        d -= largos[i];
        i++;
      }
      final u = (d / largos[i]).clamp(0.0, 1.0);
      final p = Offset.lerp(pts[i], pts[i + 1], u)!;
      final ox = _ruta[i][2] + (_ruta[i + 1][2] - _ruta[i][2]) * u;
      dibujarGloboRojo(c, p, h * 0.022, oxigeno: ox);
    }
    textoEn(
      c,
      'Arterias',
      _f(s, 0.88, 0.56),
      tam: h * 0.04,
      color: ColoresJuego.sangreRica,
    );
    textoEn(
      c,
      'Venas',
      _f(s, 0.12, 0.56),
      tam: h * 0.04,
      color: ColoresJuego.sangrePobre,
    );
    textoEn(
      c,
      'Circuito pequeño',
      _f(s, 0.82, 0.22),
      tam: h * 0.034,
      color: Colors.black54,
    );
    textoEn(
      c,
      'Circuito grande',
      _f(s, 0.85, 0.8),
      tam: h * 0.034,
      color: Colors.black54,
    );
  }

  @override
  bool shouldRepaint(_PintorCircuito old) => true;
}

// 6. Componentes de la sangre ----------------------------------------------------

class _PintorSangre extends CustomPainter {
  _PintorSangre(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height, w = s.width;
    // Fondo con glóbulos flotando
    final rnd = math.Random(3);
    for (var i = 0; i < 14; i++) {
      final x = 0.4 + rnd.nextDouble() * 0.58;
      final y = (rnd.nextDouble() + t * 0.03 * (1 + rnd.nextDouble())) % 1.0;
      dibujarGloboRojo(c, _f(s, x, y), h * 0.025, oxigeno: 0.8);
    }
    c.drawRect(
      Rect.fromLTRB(w * 0.38, 0, w, h),
      relleno(Colors.white.withValues(alpha: 0.55)),
    );
    // Tubo de ensayo
    final tubo = RRect.fromRectAndCorners(
      Rect.fromLTRB(w * 0.12, h * 0.05, w * 0.28, h * 0.94),
      bottomLeft: Radius.circular(w * 0.08),
      bottomRight: Radius.circular(w * 0.08),
    );
    c.save();
    c.clipRRect(tubo);
    final capas = [
      [0.12, 0.52, const Color(0xFFFFE082)],
      [0.52, 0.55, const Color(0xFFFAFAFA)],
      [0.55, 1.0, const Color(0xFFC62828)],
    ];
    for (final k in capas) {
      c.drawRect(
        Rect.fromLTRB(
          w * 0.12,
          h * (k[0] as double),
          w * 0.28,
          h * (k[1] as double),
        ),
        relleno(k[2] as Color),
      );
    }
    c.restore();
    c.drawRRect(tubo, linea(const Color(0xFF90A4AE), 3));
    textoEn(c, '55 %', _f(s, 0.2, 0.42), tam: h * 0.04, color: Colors.brown);
    textoEn(
      c,
      '<1 %',
      _f(s, 0.33, 0.535),
      tam: h * 0.033,
      color: Colors.black54,
    );
    textoEn(c, '45 %', _f(s, 0.2, 0.75), tam: h * 0.04, color: Colors.white);

    // Ejemplares
    final bob = math.sin(t * 2) * h * 0.01;
    dibujarGloboRojo(c, _f(s, 0.58, 0.3) + Offset(0, bob), h * 0.09);
    textoEn(c, 'Glóbulo rojo', _f(s, 0.58, 0.45), tam: h * 0.04);
    dibujarGloboBlanco(c, _f(s, 0.83, 0.32) - Offset(0, bob), h * 0.1, t);
    textoEn(c, 'Glóbulo blanco', _f(s, 0.83, 0.47), tam: h * 0.04);
    for (var i = 0; i < 5; i++) {
      final p = _f(s, 0.58 + (i % 3) * 0.04, 0.72 + (i ~/ 3) * 0.05) +
          Offset(math.sin(t + i) * 3, bob);
      c.drawOval(
        Rect.fromCenter(center: p, width: h * 0.045, height: h * 0.028),
        relleno(const Color(0xFFBA68C8)),
      );
    }
    textoEn(c, 'Plaquetas', _f(s, 0.62, 0.86), tam: h * 0.04);
  }

  @override
  bool shouldRepaint(_PintorSangre old) => true;
}

// 7. Camino del aire -----------------------------------------------------------------

class _PintorViaAire extends CustomPainter {
  _PintorViaAire(this.t);
  final double t;
  static const _partes = [
    [0.5, 0.0, 'Nariz'],
    [0.5, 0.13, 'Nariz'],
    [0.5, 0.22, 'Faringe'],
    [0.5, 0.29, 'Laringe'],
    [0.5, 0.45, 'Tráquea'],
    [0.5, 0.57, 'Bronquios'],
    [0.4, 0.65, 'Bronquios'],
    [0.36, 0.8, 'Alvéolos'],
  ];

  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    // Pulmones (incluyen tráquea inferior y bronquios)
    final lado = h * 0.62;
    DibujoOrganos.pulmones(
      c,
      Rect.fromCenter(center: _f(s, 0.5, 0.68), width: lado, height: lado),
      inflado: (1 - math.cos(t * 1.2)) / 2,
    );
    // Cabeza
    final cabeza = _f(s, 0.5, 0.13);
    c.drawCircle(cabeza, h * 0.11, relleno(ColoresJuego.piel));
    c.drawCircle(cabeza, h * 0.11, linea(const Color(0xFFE0A88A), 2));
    for (final dx in [-0.035, 0.035]) {
      c.drawCircle(
        cabeza + Offset(dx * h, -h * 0.03),
        h * 0.012,
        relleno(Colors.black87),
      );
    }
    c.drawArc(
      Rect.fromCenter(
        center: cabeza + Offset(0, h * 0.045),
        width: h * 0.05,
        height: h * 0.025,
      ),
      0,
      math.pi,
      false,
      linea(Colors.brown, 2),
    );
    // Vía aérea superior
    final via = Path()
      ..moveTo(cabeza.dx, cabeza.dy)
      ..lineTo(cabeza.dx, h * 0.38);
    c.drawPath(via, linea(const Color(0xFFE8EAF6), h * 0.045));
    for (var i = 0; i < 4; i++) {
      final y = h * (0.32 + i * 0.016);
      c.drawLine(
        Offset(cabeza.dx - h * 0.02, y),
        Offset(cabeza.dx + h * 0.02, y),
        linea(const Color(0xFF9FA8DA), 1.5),
      );
    }
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: _f(s, 0.5, 0.29),
          width: h * 0.07,
          height: h * 0.05,
        ),
        const Radius.circular(6),
      ),
      relleno(const Color(0xFFB39DDB)),
    );
    c.drawPolygon(cabeza + Offset(0, -h * 0.01), h * 0.02);

    // Burbuja de aire
    final ciclo = (t / 6) % 1.0;
    final seg = ciclo * (_partes.length - 1);
    final k = seg.floor().clamp(0, _partes.length - 2);
    final a = _partes[k], b = _partes[k + 1];
    final pa = _f(s, a[0] as double, a[1] as double),
        pb = _f(s, b[0] as double, b[1] as double);
    final p = Offset.lerp(pa, pb, _suave(seg - k))!;
    c.drawCircle(p, h * 0.035, relleno(const Color(0xAA4FC3F7)));
    c.drawCircle(p, h * 0.035, linea(Colors.white, 2));
    textoEn(c, 'O₂', p, tam: h * 0.03, color: Colors.white);
    textoEn(
      c,
      b[2] as String,
      _f(s, 0.82, 0.08),
      tam: h * 0.05,
      color: Colors.white,
      fondo: ColoresJuego.respiratorio,
    );
  }

  @override
  bool shouldRepaint(_PintorViaAire old) => true;
}

extension on Canvas {
  void drawPolygon(Offset c, double r) {
    final p = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx - r * 0.8, c.dy + r)
      ..lineTo(c.dx + r * 0.8, c.dy + r)
      ..close();
    drawPath(p, relleno(const Color(0xFFF4B393)));
  }
}

// 8. Diafragma (interactivo) -------------------------------------------------------

class _AnimDiafragma extends StatefulWidget {
  const _AnimDiafragma();
  @override
  State<_AnimDiafragma> createState() => _AnimDiafragmaState();
}

class _AnimDiafragmaState extends State<_AnimDiafragma> {
  bool _presionado = false;
  double _b = 0;
  double _ultimo = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Animado((t) {
          final dt = (t - _ultimo).clamp(0.0, 0.1);
          _ultimo = t;
          _b = (_b + (_presionado ? dt / 1.6 : -dt / 1.8)).clamp(0.0, 1.0);
          final estado =
              _presionado && _b < 1 ? 1 : (!_presionado && _b > 0 ? -1 : 0);
          return CustomPaint(painter: _PintorDiafragma(t, _b, estado));
        }),
        Positioned(
          right: 8,
          bottom: 8,
          child: Listener(
            onPointerDown: (_) => setState(() => _presionado = true),
            onPointerUp: (_) => setState(() => _presionado = false),
            onPointerCancel: (_) => setState(() => _presionado = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _presionado ? ColoresJuego.respiratorio : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: ColoresJuego.respiratorio, width: 2),
              ),
              child: Text(
                _presionado ? 'Inhalando…' : 'Mantén: Inhalar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _presionado ? Colors.white : ColoresJuego.respiratorio,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PintorDiafragma extends CustomPainter {
  _PintorDiafragma(this.t, this.b, this.estado);
  final double t, b;
  final int estado; // 1 inhalando, -1 exhalando, 0 quieto

  @override
  void paint(Canvas c, Size s) {
    final h = s.height, w = s.width;
    final abre = 1 + 0.05 * b;
    // Torso
    final torso = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: _f(s, 0.5, 0.5),
        width: w * 0.62 * abre,
        height: h * 0.96,
      ),
      Radius.circular(h * 0.15),
    );
    c.drawRRect(torso, relleno(const Color(0xFFFFE9DC)));
    // Costillas
    for (var i = 0; i < 6; i++) {
      final y = h * (0.2 + i * 0.09);
      for (final lado in [-1.0, 1.0]) {
        final path = Path()
          ..moveTo(w * 0.5 + lado * w * 0.03, y)
          ..quadraticBezierTo(
            w * 0.5 + lado * w * 0.3 * abre,
            y - h * 0.06,
            w * 0.5 + lado * w * 0.28 * abre,
            y + h * 0.08,
          );
        c.drawPath(path, linea(const Color(0xFFE6D3C3), h * 0.022));
      }
    }
    c.drawLine(
      _f(s, 0.5, 0.17),
      _f(s, 0.5, 0.66),
      linea(const Color(0xFFE6D3C3), h * 0.03),
    );
    // Pulmones
    final lado = h * (0.62 + 0.06 * b);
    DibujoOrganos.pulmones(
      c,
      Rect.fromCenter(
        center: _f(s, 0.5, 0.42 + 0.02 * b),
        width: lado,
        height: lado,
      ),
      inflado: b,
    );
    // Diafragma
    final yTop = h * (0.7 + 0.1 * b), yBorde = h * (0.84 + 0.04 * b);
    final dia = Path()
      ..moveTo(w * 0.2, yBorde)
      ..quadraticBezierTo(w * 0.5, yTop - h * 0.12, w * 0.8, yBorde)
      ..lineTo(w * 0.8, yBorde + h * 0.04)
      ..quadraticBezierTo(w * 0.5, yTop - h * 0.08, w * 0.2, yBorde + h * 0.04)
      ..close();
    c.drawPath(dia, relleno(const Color(0xFFC0504D)));
    // Flechas
    if (estado != 0) {
      final abajo = estado == 1;
      final x = w * 0.5, y0 = yTop + h * 0.05;
      c.drawLine(
        Offset(x, y0),
        Offset(x, y0 + (abajo ? h * 0.07 : -h * 0.07)),
        linea(Colors.black54, 3),
      );
      textoEn(
        c,
        abajo ? 'El diafragma baja ↓' : 'El diafragma sube ↑',
        _f(s, 0.5, 0.97),
        tam: h * 0.04,
        color: Colors.white,
        fondo: abajo ? ColoresJuego.respiratorio : Colors.grey,
      );
      // Partículas de aire
      for (var i = 0; i < 5; i++) {
        var u = (t * 1.2 + i / 5) % 1.0;
        if (!abajo) u = 1 - u;
        final p = Offset(w * 0.5 + math.sin(i * 2.0) * 4, h * (0.0 + 0.3 * u));
        c.drawCircle(
          p,
          h * 0.015,
          relleno(abajo ? const Color(0xFF4FC3F7) : Colors.grey),
        );
      }
    }
    textoEn(
      c,
      'Aire en pulmones: ${(b * 100).round()} %',
      _f(s, 0.18, 0.06),
      tam: h * 0.04,
      color: ColoresJuego.respiratorio,
      fondo: Colors.white,
    );
  }

  @override
  bool shouldRepaint(_PintorDiafragma old) => true;
}

// 9. Alvéolo -----------------------------------------------------------------------

class _PintorAlveolo extends CustomPainter {
  _PintorAlveolo(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height, w = s.width;
    // Bronquiolo
    c.drawLine(
      _f(s, 0.05, 0.02),
      _f(s, 0.28, 0.32),
      linea(const Color(0xFFF8BBD0), h * 0.09),
    );
    // Alvéolo (racimo)
    final centro = _f(s, 0.36, 0.5);
    final resp = 1 + 0.05 * math.sin(t * 1.5);
    for (final o in [
      const Offset(-0.12, -0.1),
      const Offset(0.1, -0.12),
      const Offset(-0.1, 0.13),
      const Offset(0.12, 0.12),
    ]) {
      c.drawCircle(
        centro + Offset(o.dx * h, o.dy * h),
        h * 0.15 * resp,
        relleno(const Color(0xFFFCE4EC)),
      );
    }
    c.drawCircle(centro, h * 0.22 * resp, relleno(const Color(0xFFF8BBD0)));
    c.drawCircle(centro, h * 0.22 * resp, linea(const Color(0xFFEC407A), 2));
    textoEn(c, 'Aire', centro, tam: h * 0.045, color: const Color(0xFFAD1457));
    // Capilar
    final cap = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.72, -20, w * 0.86, h + 20),
      Radius.circular(w * 0.07),
    );
    c.drawRRect(cap, relleno(const Color(0xFFFFCDD2)));
    c.drawRRect(cap, linea(const Color(0xFFE57373), 2));
    for (var i = 0; i < 6; i++) {
      final y = ((t * 0.12 + i / 6) % 1.0);
      dibujarGloboRojo(
        c,
        Offset(w * 0.79, y * h),
        h * 0.045,
        oxigeno: _suave((y - 0.2) / 0.6),
      );
    }
    // Moléculas
    for (var i = 0; i < 5; i++) {
      final u = (t * 0.35 + i / 5) % 1.0;
      final o2 = Offset.lerp(
        _f(s, 0.46, 0.3 + i * 0.03),
        _f(s, 0.76, 0.38 + i * 0.03),
        u,
      )!;
      c.drawCircle(o2, h * 0.025, relleno(const Color(0xFF29B6F6)));
      textoEn(c, 'O₂', o2, tam: h * 0.022, color: Colors.white);
      final co2 = Offset.lerp(
        _f(s, 0.76, 0.6 + i * 0.03),
        _f(s, 0.46, 0.66 + i * 0.03),
        u,
      )!;
      c.drawCircle(co2, h * 0.028, relleno(const Color(0xFF757575)));
      textoEn(c, 'CO₂', co2, tam: h * 0.019, color: Colors.white);
    }
    textoEn(
      c,
      'Capilar',
      _f(s, 0.93, 0.08),
      tam: h * 0.038,
      color: const Color(0xFFC62828),
    );
  }

  @override
  bool shouldRepaint(_PintorAlveolo old) => true;
}

// 10. Barreras -------------------------------------------------------------------

class _PintorBarreras extends CustomPainter {
  _PintorBarreras(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height, w = s.width;
    // Cara
    final cara = _f(s, 0.28, 0.47);
    c.drawCircle(cara, h * 0.36, relleno(ColoresJuego.piel));
    c.drawCircle(cara, h * 0.36, linea(const Color(0xFFE0A88A), 2));
    for (final x in [0.19, 0.37]) {
      final ojo = _f(s, x, 0.33);
      c.drawOval(
        Rect.fromCenter(center: ojo, width: h * 0.1, height: h * 0.07),
        relleno(Colors.white),
      );
      c.drawCircle(ojo, h * 0.022, relleno(const Color(0xFF5D4037)));
    }
    final lagrima = _f(s, 0.19, 0.38 + ((t * 0.3) % 1) * 0.12);
    c.drawCircle(lagrima, h * 0.015, relleno(const Color(0xFF4FC3F7)));
    final nariz = Path()
      ..moveTo(cara.dx, h * 0.38)
      ..lineTo(cara.dx - h * 0.04, h * 0.5)
      ..lineTo(cara.dx + h * 0.03, h * 0.5);
    c.drawPath(nariz, linea(const Color(0xFFD7967A), 3));
    c.drawArc(
      Rect.fromCenter(
        center: _f(s, 0.28, 0.6),
        width: h * 0.18,
        height: h * 0.1,
      ),
      0.1,
      math.pi - 0.2,
      false,
      linea(const Color(0xFFC2185B), 4),
    );
    // Microbio rebotando en la nariz
    final rebote = (t * 0.8) % 1.0;
    final dist = rebote < 0.5 ? 1 - rebote * 2 : (rebote - 0.5) * 2;
    dibujarBacteria(
      c,
      cara + Offset(-h * 0.1 - dist * h * 0.15, h * 0.03),
      h * 0.025,
      0,
      t,
    );

    // Piel
    final piel = Rect.fromLTRB(w * 0.6, h * 0.06, w * 0.95, h * 0.46);
    c.drawRRect(
      RRect.fromRectAndRadius(piel, const Radius.circular(12)),
      relleno(const Color(0xFFE3F2FD)),
    );
    final capa = Rect.fromLTRB(piel.left, h * 0.3, piel.right, piel.bottom);
    c.drawRRect(
      RRect.fromRectAndCorners(
        capa,
        bottomLeft: const Radius.circular(12),
        bottomRight: const Radius.circular(12),
      ),
      relleno(ColoresJuego.piel),
    );
    for (var i = 0; i < 6; i++) {
      c.drawLine(
        Offset(piel.left + i * piel.width / 6, h * 0.3),
        Offset(piel.left + i * piel.width / 6, piel.bottom),
        linea(const Color(0xFFE0A88A), 1),
      );
    }
    c.drawLine(
      Offset(piel.left, h * 0.3),
      Offset(piel.right, h * 0.3),
      linea(const Color(0xFFBF8264), 4),
    );
    for (var i = 0; i < 3; i++) {
      final u = (t * 0.7 + i / 3) % 1.0;
      final y = u < 0.5 ? h * (0.1 + u * 0.36) : h * (0.28 - (u - 0.5) * 0.36);
      dibujarBacteria(
        c,
        Offset(piel.left + piel.width * (0.25 + i * 0.25), y),
        h * 0.025,
        math.pi / 2,
        t,
      );
    }
    textoEn(
      c,
      '¡Piel!',
      Offset(piel.center.dx, h * 0.4),
      tam: h * 0.04,
      color: Colors.brown,
    );

    // Estómago con ácido
    final est = Rect.fromLTRB(w * 0.6, h * 0.54, w * 0.95, h * 0.97);
    DibujoOrganos.estomago(c, est);
    for (var i = 0; i < 6; i++) {
      final u = (t * 0.5 + i / 6) % 1.0;
      c.drawCircle(
        Offset(
          est.left + est.width * (0.35 + 0.08 * (i % 4)),
          est.bottom - est.height * (0.15 + u * 0.35),
        ),
        h * 0.012 * (1 + u),
        linea(const Color(0xFFC6FF00), 2),
      );
    }
    final des = (t * 0.4) % 1.0;
    dibujarBacteria(
      c,
      Offset(est.center.dx, est.top + est.height * 0.55),
      h * 0.03 * (1 - des),
      0.3,
      t,
      color: Color.lerp(const Color(0xFF66BB6A), const Color(0xFFBDBDBD), des)!,
    );
  }

  @override
  bool shouldRepaint(_PintorBarreras old) => true;
}

// 11. Fagocito (interactivo) --------------------------------------------------------

class _Germen {
  _Germen(this.pos, this.vel);
  Offset pos; // relativo 0–1
  Offset vel;
  double comido = 0; // 0 vivo, >0 siendo absorbido
}

class _AnimFagocito extends StatefulWidget {
  const _AnimFagocito();
  @override
  State<_AnimFagocito> createState() => _AnimFagocitoState();
}

class _AnimFagocitoState extends State<_AnimFagocito> {
  final _rnd = math.Random();
  final _germenes = <_Germen>[];
  Offset _fago = const Offset(0.5, 0.5);
  Offset? _objetivo;
  double _ultimo = 0;
  int _comidos = 0;

  _Germen _nuevo() => _Germen(
        Offset(_rnd.nextDouble() * 0.9 + 0.05, _rnd.nextDouble() * 0.8 + 0.1),
        Offset(_rnd.nextDouble() - 0.5, _rnd.nextDouble() - 0.5) * 0.08,
      );

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 4; i++) {
      _germenes.add(_nuevo());
    }
  }

  void _paso(double dt) {
    for (final g in _germenes) {
      if (g.comido > 0) {
        g.comido += dt;
        g.pos = Offset.lerp(g.pos, _fago, 0.08)!;
        continue;
      }
      g.pos += g.vel * dt;
      if (g.pos.dx < 0.05 || g.pos.dx > 0.95)
        g.vel = Offset(-g.vel.dx, g.vel.dy);
      if (g.pos.dy < 0.08 || g.pos.dy > 0.92)
        g.vel = Offset(g.vel.dx, -g.vel.dy);
    }
    final terminados = _germenes.where((g) => g.comido > 1.2).length;
    if (terminados > 0) {
      _comidos += terminados;
      _germenes.removeWhere((g) => g.comido > 1.2);
      for (var i = 0; i < terminados; i++) {
        _germenes.add(_nuevo());
      }
    }
    // Movimiento del fagocito
    Offset? meta = _objetivo;
    if (meta == null) {
      final vivos = _germenes.where((g) => g.comido == 0).toList();
      if (vivos.isNotEmpty) {
        vivos.sort(
          (a, b) =>
              (a.pos - _fago).distance.compareTo((b.pos - _fago).distance),
        );
        meta = vivos.first.pos;
      }
    }
    if (meta != null) {
      final d = meta - _fago;
      final paso = 0.12 * dt;
      _fago = d.distance < paso ? meta : _fago + d / d.distance * paso;
      if (_objetivo != null && (_objetivo! - _fago).distance < 0.01)
        _objetivo = null;
    }
    for (final g in _germenes) {
      if (g.comido == 0 && (g.pos - _fago).distance < 0.07) g.comido = 0.01;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cons) {
        return GestureDetector(
          onTapDown: (d) => _objetivo = Offset(
            d.localPosition.dx / cons.maxWidth,
            d.localPosition.dy / cons.maxHeight,
          ),
          child: Animado((t) {
            final dt = (t - _ultimo).clamp(0.0, 0.1);
            _ultimo = t;
            _paso(dt);
            return CustomPaint(
              painter: _PintorFagocito(
                t,
                _fago,
                _objetivo,
                _germenes,
                _comidos,
              ),
            );
          }),
        );
      },
    );
  }
}

class _PintorFagocito extends CustomPainter {
  _PintorFagocito(
    this.t,
    this.fago,
    this.objetivo,
    this.germenes,
    this.comidos,
  );
  final double t;
  final Offset fago;
  final Offset? objetivo;
  final List<_Germen> germenes;
  final int comidos;

  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    // Tejido de fondo
    final rnd = math.Random(7);
    for (var i = 0; i < 12; i++) {
      final p = _f(s, rnd.nextDouble(), rnd.nextDouble());
      c.drawCircle(
        p,
        h * (0.07 + rnd.nextDouble() * 0.04),
        relleno(const Color(0xFFFFE4EC)),
      );
    }
    if (objetivo != null) {
      final p = _f(s, objetivo!.dx, objetivo!.dy);
      c.drawCircle(
        p,
        h * 0.03,
        linea(ColoresJuego.inmune.withValues(alpha: 0.6), 2),
      );
    }
    for (final g in germenes) {
      final p = _f(s, g.pos.dx, g.pos.dy);
      final esc = g.comido > 0 ? (1 - g.comido / 1.2).clamp(0.0, 1.0) : 1.0;
      dibujarBacteria(c, p, h * 0.03 * esc, math.atan2(g.vel.dy, g.vel.dx), t);
    }
    // Fagocito con seudópodos
    final centro = _f(s, fago.dx, fago.dy);
    final r = h * 0.11;
    final path = Path();
    for (var i = 0; i <= 48; i++) {
      final a = i / 48 * 2 * math.pi;
      final rr = r *
          (1 + 0.12 * math.sin(a * 5 + t * 3) + 0.05 * math.sin(a * 3 - t * 2));
      final p = centro + Offset(math.cos(a), math.sin(a)) * rr;
      i == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();
    c.drawPath(path, relleno(const Color(0xDDF3EEFF)));
    c.drawPath(path, linea(const Color(0xFF9575CD), 3));
    for (final o in [
      const Offset(-0.35, -0.1),
      const Offset(0.0, 0.25),
      const Offset(0.3, -0.15),
    ]) {
      c.drawCircle(centro + o * r, r * 0.22, relleno(const Color(0xFF7E57C2)));
    }
    textoEn(
      c,
      'Microbios eliminados: $comidos',
      _f(s, 0.5, 0.06),
      tam: h * 0.045,
      color: Colors.white,
      fondo: ColoresJuego.inmune,
    );
  }

  @override
  bool shouldRepaint(_PintorFagocito old) => true;
}

// 12. Anticuerpos ------------------------------------------------------------------

class _PintorAnticuerpos extends CustomPainter {
  _PintorAnticuerpos(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    final ciclo = t % 7.0;
    final linf = _f(s, 0.16, 0.5);
    dibujarCelula(
      c,
      linf,
      h * 0.14,
      t,
      membrana: const Color(0xFFD1C4E9),
      nucleo: const Color(0xFF5E35B1),
    );
    textoEn(c, 'Linfocito', _f(s, 0.16, 0.72), tam: h * 0.04);
    final fago = _f(s, 0.88, 0.78);
    dibujarGloboBlanco(
      c,
      fago,
      h * 0.11 * (1 + (ciclo > 4.5 ? 0.1 * math.sin(t * 8) : 0)),
      t,
    );
    final virus = [_f(s, 0.62, 0.3), _f(s, 0.7, 0.55), _f(s, 0.6, 0.72)];
    for (var v = 0; v < virus.length; v++) {
      final mov = _suave((ciclo - 4.2 - v * 0.3) / 1.5);
      final pos = Offset.lerp(virus[v], fago, mov)!;
      final esc = 1 - _suave((ciclo - 5.5 - v * 0.3) / 0.6);
      if (esc <= 0.02) continue;
      dibujarVirus(c, pos, h * 0.05 * esc, t);
      for (var k = 0; k < 4; k++) {
        final ang = k / 4 * 2 * math.pi + v;
        final destino =
            pos + Offset(math.cos(ang), math.sin(ang)) * h * 0.1 * esc;
        final u = _suave((ciclo - 0.5 - k * 0.35 - v * 0.2) / 1.6);
        if (u <= 0) continue;
        final p = Offset.lerp(linf, destino, u)!;
        dibujarAnticuerpo(
          c,
          p,
          h * 0.05 * (u < 1 ? 1 : esc),
          ang - math.pi / 2,
        );
      }
    }
    final etapa = ciclo < 2.5
        ? '1. El linfocito fabrica anticuerpos'
        : ciclo < 4.2
            ? '2. Los anticuerpos marcan al virus'
            : '3. El fagocito se lo come';
    textoEn(
      c,
      etapa,
      _f(s, 0.5, 0.06),
      tam: h * 0.045,
      color: Colors.white,
      fondo: ColoresJuego.inmune,
    );
  }

  @override
  bool shouldRepaint(_PintorAnticuerpos old) => true;
}

// 13. Vacunas ------------------------------------------------------------------------

class _PintorVacuna extends CustomPainter {
  _PintorVacuna(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height, w = s.width;
    final activo = ((t / 2.5) % 3).floor();
    final titulos = ['Vacuna', 'Entrenamiento', 'Protección'];
    for (var i = 0; i < 3; i++) {
      final centro = _f(s, 0.18 + i * 0.32, 0.45);
      final panel = RRect.fromRectAndRadius(
        Rect.fromCenter(center: centro, width: w * 0.28, height: h * 0.72),
        const Radius.circular(18),
      );
      c.drawRRect(
        panel,
        relleno(
          i == activo ? Colors.white : Colors.white.withValues(alpha: 0.55),
        ),
      );
      c.drawRRect(
        panel,
        linea(
          i == activo ? ColoresJuego.inmune : Colors.black12,
          i == activo ? 4 : 2,
        ),
      );
      textoEn(
        c,
        titulos[i],
        centro + Offset(0, h * 0.42),
        tam: h * 0.045,
        color: i == activo ? ColoresJuego.inmune : Colors.black45,
      );
      if (i < 2) {
        final a = _f(s, 0.33 + i * 0.32, 0.45);
        c.drawLine(
          a - Offset(w * 0.01, 0),
          a + Offset(w * 0.015, 0),
          linea(ColoresJuego.inmune, 4),
        );
      }
      final r = h * 0.07;
      switch (i) {
        case 0:
          // Jeringa
          c.save();
          c.translate(centro.dx, centro.dy - h * 0.1);
          c.rotate(-0.6);
          c.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(
                center: Offset.zero,
                width: r * 2.6,
                height: r * 0.8,
              ),
              const Radius.circular(6),
            ),
            relleno(const Color(0xFFB3E5FC)),
          );
          c.drawLine(
            Offset(r * 1.3, 0),
            Offset(r * 2.1, 0),
            linea(Colors.grey, 2),
          );
          c.drawLine(
            Offset(-r * 1.3, 0),
            Offset(-r * 1.9, 0),
            linea(Colors.grey.shade700, 5),
          );
          c.restore();
          dibujarVirus(
            c,
            centro + Offset(0, h * 0.13),
            r * 0.6,
            t * 0.2,
            color: const Color(0xFFBDBDBD),
          );
          textoEn(
            c,
            'zzz',
            centro + Offset(r * 0.8, h * 0.06),
            tam: h * 0.035,
            color: Colors.grey,
          );
        case 1:
          dibujarCelula(
            c,
            centro,
            r * 1.2,
            t,
            membrana: const Color(0xFFD1C4E9),
            nucleo: const Color(0xFF5E35B1),
          );
          for (var k = 0; k < 3; k++) {
            final a = t * 1.5 + k * 2.1;
            dibujarAnticuerpo(
              c,
              centro + Offset(math.cos(a), math.sin(a)) * r * 1.8,
              h * 0.04,
              a + math.pi / 2,
            );
          }
          textoEn(
            c,
            '💡 ¡Memoria!',
            centro + Offset(0, -h * 0.22),
            tam: h * 0.035,
            color: ColoresJuego.inmune,
          );
        default:
          // Escudo que bloquea al virus real
          final ataque = (t * 0.8) % 1.0;
          dibujarVirus(
            c,
            centro + Offset(w * 0.05 * (1 - ataque) + w * 0.02, -h * 0.12),
            r * 0.55,
            t,
            color: const Color(0xFFE53935),
          );
          final esc = Path()
            ..moveTo(centro.dx, centro.dy - r * 0.6)
            ..lineTo(centro.dx + r, centro.dy - r * 0.2)
            ..quadraticBezierTo(
              centro.dx + r * 0.9,
              centro.dy + r,
              centro.dx,
              centro.dy + r * 1.4,
            )
            ..quadraticBezierTo(
              centro.dx - r * 0.9,
              centro.dy + r,
              centro.dx - r,
              centro.dy - r * 0.2,
            )
            ..close();
          c.drawPath(esc, relleno(ColoresJuego.inmune));
          c.drawPath(esc, linea(Colors.white, 3));
          textoEn(
            c,
            '✓',
            centro + Offset(0, r * 0.3),
            tam: h * 0.08,
            color: Colors.white,
          );
      }
    }
  }

  @override
  bool shouldRepaint(_PintorVacuna old) => true;
}

// 14. Hábitos saludables ----------------------------------------------------------------

class _Habitos extends StatefulWidget {
  const _Habitos();
  @override
  State<_Habitos> createState() => _HabitosState();
}

class _HabitosState extends State<_Habitos> {
  static const _items = [
    (
      Icons.directions_run_rounded,
      'Ejercicio',
      'Fortalece tu corazón y tus pulmones.',
      ColoresJuego.circulatorio,
    ),
    (
      Icons.eco_rounded,
      'Frutas y verduras',
      'Sus vitaminas ayudan a tus defensas.',
      ColoresJuego.correcto,
    ),
    (
      Icons.water_drop_rounded,
      'Tomar agua',
      'Tu sangre es casi la mitad agua.',
      ColoresJuego.respiratorio,
    ),
    (
      Icons.bedtime_rounded,
      'Dormir bien',
      'Mientras duermes, tu sistema inmune se recarga.',
      ColoresJuego.inmune,
    ),
    (
      Icons.wash_rounded,
      'Lavarte las manos',
      'Elimina microbios antes de que entren.',
      Color(0xFF00897B),
    ),
    (
      Icons.smoke_free_rounded,
      'Cero humo',
      'Protege tus alvéolos y bronquios.',
      Color(0xFF546E7A),
    ),
  ];
  final _volteadas = <int>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.15,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          for (var i = 0; i < _items.length; i++)
            GestureDetector(
              onTap: () => setState(
                () => _volteadas.contains(i)
                    ? _volteadas.remove(i)
                    : _volteadas.add(i),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Container(
                  key: ValueKey(_volteadas.contains(i)),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _volteadas.contains(i) ? _items[i].$4 : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _items[i].$4, width: 2),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _volteadas.contains(i)
                        ? SizedBox(
                            width: 110,
                            child: Text(
                              _items[i].$3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_items[i].$1, color: _items[i].$4, size: 30),
                              Text(
                                _items[i].$2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 0. ¿Qué es el cuerpo humano? (boceto intro tema1bio) ------------------------

class _PintorQueEsCuerpo extends CustomPainter {
  _PintorQueEsCuerpo(this.t);
  final double t;

  @override
  void paint(Canvas c, Size s) {
    final h = s.height * 0.94;
    final w = h * Silueta.proporcion;
    final caja = Rect.fromCenter(
      center: Offset(s.width * 0.33, s.height * 0.5),
      width: w,
      height: h,
    );
    Offset p(double x, double y) => Silueta.punto(caja, Offset(x, y));

    // Niño: piel, short, cabello y cara
    Silueta.dibujar(c, caja, borde: const Color(0xFFE0A88A));
    final short = RRect.fromRectAndCorners(
      Rect.fromPoints(p(0.27, 0.5), p(0.73, 0.64)),
      bottomLeft: Radius.circular(w * 0.06),
      bottomRight: Radius.circular(w * 0.06),
    );
    c.drawRRect(short, relleno(const Color(0xFF3D7BE0)));
    c.drawLine(
      p(0.5, 0.56),
      p(0.5, 0.64),
      linea(const Color(0xFF2A5CB0), w * 0.025),
    );
    final cabeza = p(0.5, 0.075);
    final rc = 0.068 * h;
    c.drawArc(
      Rect.fromCircle(
        center: cabeza + Offset(0, -rc * 0.12),
        radius: rc * 1.08,
      ),
      math.pi * 1.02,
      math.pi * 0.96,
      true,
      relleno(const Color(0xFF6D3B1F)),
    );
    c.drawCircle(
      cabeza + Offset(rc * 0.5, -rc * 0.75),
      rc * 0.32,
      relleno(const Color(0xFF6D3B1F)),
    );
    final parpadeo = (t % 3.2) > 3.05;
    for (final dx in [-0.35, 0.35]) {
      final ojo = cabeza + Offset(dx * rc, rc * 0.05);
      if (parpadeo) {
        c.drawLine(
          ojo - Offset(rc * 0.12, 0),
          ojo + Offset(rc * 0.12, 0),
          linea(const Color(0xFF3B2416), rc * 0.08),
        );
      } else {
        c.drawCircle(ojo, rc * 0.13, relleno(const Color(0xFF3B2416)));
        c.drawCircle(
          ojo + Offset(-rc * 0.04, -rc * 0.05),
          rc * 0.045,
          relleno(Colors.white),
        );
      }
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
      linea(const Color(0xFFB0473A), rc * 0.08),
    );

    // Vasos sanguíneos
    final corazon = p(0.55, 0.325);
    final destinos = [
      p(0.5, 0.13),
      p(0.14, 0.5),
      p(0.86, 0.5),
      p(0.38, 0.93),
      p(0.62, 0.93),
    ];
    final ctrl = [
      p(0.52, 0.2),
      p(0.3, 0.24),
      p(0.7, 0.24),
      p(0.42, 0.55),
      p(0.58, 0.55),
    ];
    for (var i = 0; i < destinos.length; i++) {
      for (final venosa in [false, true]) {
        final off = Offset(venosa ? -w * 0.014 : w * 0.014, 0);
        final ruta = Path()
          ..moveTo(corazon.dx + off.dx, corazon.dy)
          ..quadraticBezierTo(
            ctrl[i].dx + off.dx,
            ctrl[i].dy,
            destinos[i].dx + off.dx,
            destinos[i].dy,
          );
        c.drawPath(
          ruta,
          linea(
            (venosa ? ColoresJuego.sangrePobre : ColoresJuego.sangreRica)
                .withValues(alpha: 0.75),
            w * 0.016,
          ),
        );
      }
    }
    // Órganos
    for (final o in posicionesOrganos) {
      if (o.id == 'cerebro') continue;
      final r = Rect.fromCenter(
        center: p(o.centro.dx, o.centro.dy),
        width: o.tamano.width * w,
        height: o.tamano.height * h,
      );
      if (o.id == 'corazon') {
        DibujoOrganos.corazon(
          c,
          r,
          latido: math.pow(math.max(0, math.sin(t * 6.5)), 6).toDouble(),
        );
      } else if (o.id == 'pulmones') {
        DibujoOrganos.pulmones(c, r, inflado: (1 - math.cos(t * 1.5)) / 2);
      } else {
        DibujoOrganos.dibujar(c, r, o.id);
      }
    }
    // Ganglios (sistema inmunológico)
    final ganglios = [
      p(0.42, 0.14),
      p(0.58, 0.14),
      p(0.31, 0.2),
      p(0.69, 0.2),
      p(0.42, 0.55),
      p(0.58, 0.55),
    ];
    for (var i = 0; i < ganglios.length; i++) {
      c.drawCircle(
        ganglios[i],
        w * 0.035 * (1 + 0.25 * math.sin(t * 3 + i)),
        relleno(const Color(0x552DB84C)),
      );
      c.drawCircle(ganglios[i], w * 0.022, relleno(const Color(0xFF2DB84C)));
    }

    // Etiquetas de los sistemas
    final etiquetas = [
      (
        'Sistema\ncirculatorio',
        ColoresJuego.circulatorio,
        0.2,
        p(0.55, 0.32),
        0,
      ),
      (
        'Sistema\nrespiratorio',
        ColoresJuego.respiratorio,
        0.5,
        p(0.64, 0.25),
        1,
      ),
      ('Sistema\ninmunológico', const Color(0xFF2DB84C), 0.8, p(0.58, 0.55), 2),
    ];
    final activo = ((t / 2.2) % 3).floor();
    for (final (texto, color, y, destino, i) in etiquetas) {
      final centro = Offset(s.width * 0.79, s.height * y);
      final destacar = i == activo;
      final k = destacar ? 1 + 0.05 * math.sin((t % 2.2) / 2.2 * math.pi) : 1.0;
      final r = Rect.fromCenter(
        center: centro,
        width: s.width * 0.36 * k,
        height: s.height * 0.21 * k,
      );
      final inicio = Offset(r.left, centro.dy);
      // Línea con un pulso que viaja hacia el órgano
      c.drawLine(inicio, destino, linea(color, 2.5));
      final u = (t * 0.6 + i * 0.3) % 1;
      c.drawCircle(Offset.lerp(inicio, destino, u)!, 4, relleno(color));
      c.drawCircle(destino, 5, relleno(color));
      final rr = RRect.fromRectAndRadius(r, Radius.circular(s.height * 0.06));
      c.drawRRect(rr.shift(const Offset(0, 3)), relleno(oscurecer(color, 0.3)));
      c.drawRRect(rr, relleno(Colors.white));
      c.drawRRect(rr, linea(color, destacar ? 4 : 2.5));
      final icono = Rect.fromCenter(
        center: Offset(r.left + r.height * 0.55, centro.dy),
        width: r.height * 0.7,
        height: r.height * 0.7,
      );
      switch (i) {
        case 0:
          DibujoOrganos.corazon(c, icono);
        case 1:
          DibujoOrganos.pulmones(c, icono);
        default:
          final e = Trazo(icono.deflate(icono.width * 0.08))
            ..m(0.5, 0.02)
            ..q(0.75, 0.14, 0.98, 0.14)
            ..q(1.0, 0.72, 0.5, 0.98)
            ..q(0.0, 0.72, 0.02, 0.14)
            ..q(0.25, 0.14, 0.5, 0.02)
            ..z();
          c.drawPath(e.path, relleno(color));
          final cr = icono.center;
          final cruz = linea(Colors.white, icono.width * 0.12);
          c.drawLine(
            cr - Offset(0, icono.width * 0.18),
            cr + Offset(0, icono.width * 0.18),
            cruz,
          );
          c.drawLine(
            cr - Offset(icono.width * 0.18, 0),
            cr + Offset(icono.width * 0.18, 0),
            cruz,
          );
      }
      textoEn(
        c,
        texto,
        Offset(
          r.left + r.height * 1.05 + (r.right - r.left - r.height * 1.05) / 2,
          centro.dy,
        ),
        tam: s.height * 0.044,
        color: oscurecer(color, 0.15),
      );
    }
  }

  @override
  bool shouldRepaint(_PintorQueEsCuerpo old) => true;
}
