import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/tema1/ui_divertida.dart' show aclarar, oscurecer;
import '../biology/temas/motor.dart' show dibujarEmoji;
import 'ilustraciones_ele.dart' show dibujarEngrane;

/// Fondos animados del mundo de Electrónica (uno por tema).

enum FondoEle { taller, ciudad, detective, fabrica, planos, placa }

EstiloMundo estiloEle(FondoEle f) {
  final (a, b, borde, sombra) = switch (f) {
    FondoEle.taller => (const Color(0xFFFFCA28), const Color(0xFFFF8F00), const Color(0xFFE65100), const Color(0xFF8D3F00)),
    FondoEle.ciudad => (const Color(0xFF64B5F6), const Color(0xFF1E88E5), const Color(0xFF0D47A1), const Color(0xFF062A63)),
    FondoEle.detective => (const Color(0xFF4DD0E1), const Color(0xFF00838F), const Color(0xFF004D40), const Color(0xFF00251F)),
    FondoEle.fabrica => (const Color(0xFFB0BEC5), const Color(0xFF607D8B), const Color(0xFF37474F), const Color(0xFF1C262B)),
    FondoEle.planos => (const Color(0xFFE1F5FE), const Color(0xFF81D4FA), const Color(0xFF0277BD), const Color(0xFF01416E)),
    FondoEle.placa => (const Color(0xFF81C784), const Color(0xFF2E7D32), const Color(0xFF1B5E20), const Color(0xFF0A2E0D)),
  };
  return EstiloMundo(
    fondo: (_) => FondoElectronica(f),
    letrero: [a, b],
    bordeLetrero: borde,
    sombraLetrero: sombra,
    textoLetrero: f == FondoEle.planos ? const Color(0xFF01416E) : Colors.white,
  );
}

class FondoElectronica extends StatelessWidget {
  const FondoElectronica(this.tipo, {super.key});
  final FondoEle tipo;
  @override
  Widget build(BuildContext context) => RepaintBoundary(
        child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorFondoEle(tipo, t), child: const SizedBox.expand())),
      );
}

class _PintorFondoEle extends CustomPainter {
  _PintorFondoEle(this.tipo, this.t);
  final FondoEle tipo;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    switch (tipo) {
      case FondoEle.taller:
        _taller(c, s);
      case FondoEle.ciudad:
        _ciudad(c, s);
      case FondoEle.detective:
        _detective(c, s);
      case FondoEle.fabrica:
        _fabrica(c, s);
      case FondoEle.planos:
        _planos(c, s);
      case FondoEle.placa:
        pintarPlaca(c, s, t);
    }
  }

  void _degradado(Canvas c, Size s, List<Color> cols) => c.drawRect(
      Offset.zero & s, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: cols).createShader(Offset.zero & s));

  // Taller: pared perforada, herramientas, repisa y mesa de madera.
  void _taller(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFFFFE0B2), Color(0xFFFFCC80)]);
    final paso = s.shortestSide / 18;
    final punto = relleno(const Color(0x33A1662F));
    for (var y = paso; y < s.height * 0.72; y += paso) {
      for (var x = paso / 2; x < s.width; x += paso) {
        c.drawCircle(Offset(x, y), paso * 0.09, punto);
      }
    }
    final u = s.shortestSide / 100;
    // Herramientas colgadas
    void llave(Offset p, double a) {
      c.save();
      c.translate(p.dx, p.dy);
      c.rotate(a + math.sin(t * 0.8) * 0.03);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, 9 * u), width: 3.2 * u, height: 16 * u), Radius.circular(u)), relleno(const Color(0xFF90A4AE)));
      c.drawCircle(Offset.zero, 3.6 * u, relleno(const Color(0xFF90A4AE)));
      c.drawCircle(Offset(0, -0.8 * u), 1.8 * u, relleno(const Color(0xFFFFE0B2)));
      c.restore();
    }

    void desarmador(Offset p, double a, Color mango) {
      c.save();
      c.translate(p.dx, p.dy);
      c.rotate(a + math.sin(t * 0.7 + 1) * 0.03);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 4 * u, height: 9 * u), Radius.circular(1.6 * u)), relleno(mango));
      c.drawRect(Rect.fromCenter(center: Offset(0, 9 * u), width: 1.2 * u, height: 10 * u), relleno(const Color(0xFF9E9E9E)));
      c.restore();
    }

    llave(Offset(s.width * 0.08, s.height * 0.12), 0.2);
    desarmador(Offset(s.width * 0.14, s.height * 0.13), -0.1, const Color(0xFFE53935));
    desarmador(Offset(s.width * 0.18, s.height * 0.12), 0.15, const Color(0xFF1E88E5));
    llave(Offset(s.width * 0.9, s.height * 0.14), -0.25);
    desarmador(Offset(s.width * 0.95, s.height * 0.12), 0.1, const Color(0xFFFFB300));
    // Repisa con cajas de componentes
    final yRep = s.height * 0.4;
    c.drawRect(Rect.fromLTWH(s.width * 0.62, yRep, s.width * 0.36, 2.2 * u), relleno(const Color(0xFF8D6E63)));
    for (var k = 0; k < 4; k++) {
      final r = Rect.fromLTWH(s.width * 0.64 + k * s.width * 0.085, yRep - 9 * u, s.width * 0.07, 9 * u);
      c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u)), relleno([const Color(0xFF42A5F5), const Color(0xFFEF5350), const Color(0xFF66BB6A), const Color(0xFFAB47BC)][k]));
      dibujarEmoji(c, ['💡', '🔋', '⚙️', '🔌'][k], r.center, 5 * u);
    }
    // Lámpara colgante
    final lx = s.width * 0.5;
    c.drawLine(Offset(lx, 0), Offset(lx, s.height * 0.08), linea(const Color(0xFF5D4037), 0.6 * u));
    c.drawPath(
        Path()
          ..moveTo(lx - 7 * u, s.height * 0.08 + 6 * u)
          ..lineTo(lx - 3 * u, s.height * 0.08)
          ..lineTo(lx + 3 * u, s.height * 0.08)
          ..lineTo(lx + 7 * u, s.height * 0.08 + 6 * u)
          ..close(),
        relleno(const Color(0xFF37474F)));
    c.drawCircle(Offset(lx, s.height * 0.08 + 7 * u), 30 * u, Paint()..shader = RadialGradient(colors: [const Color(0x55FFF59D), const Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: Offset(lx, s.height * 0.08 + 7 * u), radius: 30 * u)));
    // Mesa
    final mesa = Rect.fromLTWH(0, s.height * 0.74, s.width, s.height * 0.26);
    c.drawRect(mesa, Paint()..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFB07A4A), Color(0xFF8A5A33)]).createShader(mesa));
    c.drawRect(Rect.fromLTWH(0, mesa.top, s.width, 1.6 * u), relleno(const Color(0xFFD7A06B)));
    for (var k = 1; k < 6; k++) {
      c.drawLine(Offset(0, mesa.top + k * mesa.height / 6), Offset(s.width, mesa.top + k * mesa.height / 6 + 2 * u), linea(const Color(0x226D4C41), 0.6 * u));
    }
    _chispas(c, s, const Color(0xFFFFD54F));
  }

  // Ciudad de noche con ventanas que se encienden y cables de luz.
  void _ciudad(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFF0B1240), Color(0xFF2A1B5C), Color(0xFF4A2C7A)]);
    final rnd = math.Random(7);
    for (var k = 0; k < 60; k++) {
      final p = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height * 0.5);
      c.drawCircle(p, 0.6 + rnd.nextDouble() * 1.2, relleno(Colors.white.withValues(alpha: 0.3 + 0.5 * (0.5 + 0.5 * math.sin(t * 2 + k)))));
    }
    final u = s.shortestSide / 100;
    c.drawCircle(Offset(s.width * 0.85, s.height * 0.16), 7 * u, relleno(const Color(0xFFFFF9C4)));
    c.drawCircle(Offset(s.width * 0.85 + 2.5 * u, s.height * 0.16 - 1.5 * u), 6 * u, relleno(const Color(0xFF1B1550)));
    // Edificios
    final rb = math.Random(3);
    var x = 0.0;
    var i = 0;
    while (x < s.width) {
      final w = s.width * (0.06 + rb.nextDouble() * 0.06);
      final h = s.height * (0.22 + rb.nextDouble() * 0.33);
      final r = Rect.fromLTWH(x, s.height - h, w - 2, h);
      c.drawRect(r, relleno(i.isEven ? const Color(0xFF1A1F4D) : const Color(0xFF232A5E)));
      final cols = (w / (3.4 * u)).floor().clamp(1, 6);
      for (var fy = r.top + 3 * u; fy < s.height - 3 * u; fy += 4.4 * u) {
        for (var cx = 0; cx < cols; cx++) {
          final semilla = (i * 31 + cx * 7 + (fy / u).round() * 13) % 17;
          final on = ((t * 0.4 + semilla / 17) % 1) < 0.6;
          if (!on) continue;
          c.drawRect(Rect.fromLTWH(r.left + 1.6 * u + cx * (w - 3.2 * u) / cols, fy, 1.8 * u, 2.4 * u), relleno(semilla.isEven ? const Color(0xFFFFE082) : const Color(0xFF80DEEA)));
        }
      }
      x += w;
      i++;
    }
    // Postes y cables con pulsos de corriente
    final yCable = s.height * 0.55;
    final cable = linea(const Color(0xFF90A4AE), 0.5 * u);
    final postes = [for (var k = 0; k <= 5; k++) s.width * k / 5];
    for (var k = 0; k < postes.length - 1; k++) {
      final a = Offset(postes[k], yCable), b = Offset(postes[k + 1], yCable);
      final m = Offset((a.dx + b.dx) / 2, yCable + 5 * u);
      c.drawPath(Path()..moveTo(a.dx, a.dy)..quadraticBezierTo(m.dx, m.dy, b.dx, b.dy), cable);
      final f = (t * 0.5 + k * 0.23) % 1;
      final q = Offset(a.dx + (b.dx - a.dx) * f, yCable + 2 * u * 4 * f * (1 - f) * 2.5 / 2);
      c.drawCircle(q, 1.4 * u, relleno(const Color(0xFFFFEB3B)));
      c.drawCircle(q, 3 * u, relleno(const Color(0x44FFEB3B)));
    }
    for (final px in postes) {
      c.drawRect(Rect.fromLTWH(px - 0.6 * u, yCable - 2 * u, 1.2 * u, s.height - yCable), relleno(const Color(0xFF37474F)));
    }
    c.drawRect(Rect.fromLTWH(0, s.height - 4 * u, s.width, 4 * u), relleno(const Color(0xFF121633)));
  }

  // Laboratorio de detectives: radar, cuadrícula y lupa.
  void _detective(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFF00363A), Color(0xFF004D57), Color(0xFF00252B)]);
    final u = s.shortestSide / 100;
    final g = linea(const Color(0x2226C6DA), 0.4 * u);
    for (var x = 0.0; x < s.width; x += 6 * u) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), g);
    }
    for (var y = 0.0; y < s.height; y += 6 * u) {
      c.drawLine(Offset(0, y), Offset(s.width, y), g);
    }
    // Radar
    final cen = Offset(s.width * 0.86, s.height * 0.78);
    final rr = 34 * u;
    for (var k = 1; k <= 3; k++) {
      c.drawCircle(cen, rr * k / 3, linea(const Color(0x5526C6DA), 0.5 * u));
    }
    final a = t * 1.4;
    c.drawArc(Rect.fromCircle(center: cen, radius: rr), a, 0.6, true, Paint()..shader = SweepGradient(startAngle: a, endAngle: a + 0.6, colors: const [Color(0x0026C6DA), Color(0x8826C6DA)]).createShader(Rect.fromCircle(center: cen, radius: rr)));
    for (final (dx, dy) in const [(0.4, -0.3), (-0.5, 0.1), (0.1, 0.55)]) {
      final p = cen + Offset(dx, dy) * rr;
      final ang = (math.atan2(dy, dx) - a) % (2 * math.pi);
      c.drawCircle(p, 1.4 * u, relleno(Color.fromARGB((255 * (1 - (ang / (2 * math.pi)))).round(), 105, 240, 174)));
    }
    // Línea de escaneo
    final y = (t * 0.25 % 1) * s.height;
    c.drawRect(Rect.fromLTWH(0, y, s.width, 0.8 * u), relleno(const Color(0x3369F0AE)));
    // Lupa grande
    final lp = Offset(s.width * 0.1, s.height * 0.2);
    c.drawCircle(lp, 10 * u, linea(const Color(0x66B2EBF2), 1.6 * u));
    c.drawLine(lp + Offset(7 * u, 7 * u), lp + Offset(15 * u, 15 * u), linea(const Color(0x66B2EBF2), 2.4 * u)..strokeCap = StrokeCap.round);
    // Iconos de sensores parpadeando
    for (final (e, fx, fy, k) in const [('👁️', 0.25, 0.85, 0), ('🌡️', 0.5, 0.92, 1), ('📡', 0.92, 0.25, 2), ('💡', 0.6, 0.08, 3)]) {
      final al = 0.25 + 0.35 * (0.5 + 0.5 * math.sin(t * 2 + k));
      c.saveLayer(null, Paint()..color = Colors.white.withValues(alpha: al));
      dibujarEmoji(c, e, Offset(s.width * fx, s.height * fy), 7 * u);
      c.restore();
    }
  }

  // Fábrica: engranes grandes, banda transportadora y cajas.
  void _fabrica(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFF546E7A), Color(0xFF78909C), Color(0xFF455A64)]);
    final u = s.shortestSide / 100;
    // Ventanales
    for (var k = 0; k < 5; k++) {
      final r = Rect.fromLTWH(s.width * (0.08 + k * 0.18), s.height * 0.08, s.width * 0.12, s.height * 0.22);
      c.drawRect(r, relleno(const Color(0x3381D4FA)));
      c.drawRect(r, linea(const Color(0x55263238), 0.6 * u));
      c.drawLine(r.topCenter, r.bottomCenter, linea(const Color(0x55263238), 0.4 * u));
    }
    c.saveLayer(null, Paint()..color = const Color(0x88FFFFFF));
    dibujarEngrane(c, Offset(s.width * 0.08, s.height * 0.55), 22 * u, 14, t * 0.4, const Color(0xFF90A4AE));
    dibujarEngrane(c, Offset(s.width * 0.08 + 37 * u, s.height * 0.55 - 6 * u), 16 * u, 10, -t * 0.4 * 1.4 + 0.2, const Color(0xFFB0BEC5));
    dibujarEngrane(c, Offset(s.width * 0.92, s.height * 0.45), 26 * u, 16, -t * 0.3, const Color(0xFF90A4AE));
    dibujarEngrane(c, Offset(s.width * 0.6, s.height * 0.4), 12 * u, 8, t * 0.7, const Color(0xFFFFB300));
    c.restore();
    // Banda transportadora
    final yb = s.height * 0.84;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-2 * u, yb, s.width + 4 * u, 6 * u), Radius.circular(3 * u)), relleno(const Color(0xFF263238)));
    for (var x = -((t * 8 * u) % (6 * u)); x < s.width; x += 6 * u) {
      c.drawLine(Offset(x, yb + u), Offset(x, yb + 5 * u), linea(const Color(0xFF455A64), 0.5 * u));
    }
    for (var k = 0; k < 5; k++) {
      final x = ((t * 8 * u + k * s.width / 5) % (s.width + 20 * u)) - 10 * u;
      final caja = Rect.fromLTWH(x, yb - 8 * u, 10 * u, 8 * u);
      c.drawRect(caja, relleno(const Color(0xFFD7A06B)));
      c.drawRect(caja, linea(const Color(0xFF8D6E63), 0.4 * u));
      c.drawLine(caja.topCenter, caja.bottomCenter, linea(const Color(0xFFBCAAA4), 0.8 * u));
    }
    c.drawRect(Rect.fromLTWH(0, yb + 6 * u, s.width, s.height - yb), relleno(const Color(0xFF37474F)));
    // Pistón
    final px = s.width * 0.45;
    final baja = (math.sin(t * 2) * 0.5 + 0.5) * 6 * u;
    c.drawRect(Rect.fromLTWH(px - 1 * u, s.height * 0.58, 2 * u, 12 * u + baja), relleno(const Color(0xFFB0BEC5)));
    c.drawRect(Rect.fromLTWH(px - 5 * u, s.height * 0.58 + 12 * u + baja, 10 * u, 3 * u), relleno(const Color(0xFFFFB300)));
    c.drawRect(Rect.fromLTWH(px - 7 * u, s.height * 0.52, 14 * u, 6 * u), relleno(const Color(0xFF263238)));
  }

  // Planos de inventor: papel azul con dibujos blancos.
  void _planos(Canvas c, Size s) {
    _degradado(c, s, const [Color(0xFF0D47A1), Color(0xFF1565C0)]);
    final u = s.shortestSide / 100;
    final fino = linea(const Color(0x22FFFFFF), 0.3 * u);
    final grueso = linea(const Color(0x44FFFFFF), 0.5 * u);
    for (var k = 0; k * 3 * u < s.width; k++) {
      c.drawLine(Offset(k * 3 * u, 0), Offset(k * 3 * u, s.height), k % 5 == 0 ? grueso : fino);
    }
    for (var k = 0; k * 3 * u < s.height; k++) {
      c.drawLine(Offset(0, k * 3 * u), Offset(s.width, k * 3 * u), k % 5 == 0 ? grueso : fino);
    }
    final trazo = linea(const Color(0xAAFFFFFF), 0.6 * u);
    // Robot
    final rp = Offset(s.width * 0.1, s.height * 0.6);
    c.drawRect(Rect.fromCenter(center: rp, width: 14 * u, height: 16 * u), trazo);
    c.drawRect(Rect.fromCenter(center: rp - Offset(0, 13 * u), width: 10 * u, height: 8 * u), trazo);
    c.drawCircle(rp - Offset(2.5 * u, 13 * u), u, trazo);
    c.drawCircle(rp - Offset(-2.5 * u, 13 * u), u, trazo);
    c.drawLine(rp - Offset(0, 17 * u), rp - Offset(0, 21 * u), trazo);
    c.drawCircle(rp - Offset(0, 22 * u), u * (1 + 0.4 * math.sin(t * 4)), relleno(const Color(0xFFFFEB3B)));
    // Foco de idea
    final fp = Offset(s.width * 0.9, s.height * 0.2);
    c.drawCircle(fp, 6 * u, trazo);
    c.drawRect(Rect.fromCenter(center: fp + Offset(0, 8 * u), width: 5 * u, height: 4 * u), trazo);
    for (var k = 0; k < 8; k++) {
      final a = k * math.pi / 4 + t * 0.2;
      final l = (8 + 1.5 * math.sin(t * 3 + k)) * u;
      c.drawLine(fp + Offset(math.cos(a), math.sin(a)) * 8 * u, fp + Offset(math.cos(a), math.sin(a)) * l * 1.3, linea(const Color(0x88FFEB3B), 0.6 * u));
    }
    // Circuito dibujándose
    final pts = [Offset(s.width * 0.75, s.height * 0.7), Offset(s.width * 0.95, s.height * 0.7), Offset(s.width * 0.95, s.height * 0.92), Offset(s.width * 0.75, s.height * 0.92), Offset(s.width * 0.75, s.height * 0.7)];
    final avance = (t * 0.3) % 1 * 4;
    for (var k = 0; k < 4; k++) {
      final f = (avance - k).clamp(0.0, 1.0);
      if (f > 0) c.drawLine(pts[k], Offset.lerp(pts[k], pts[k + 1], f)!, trazo);
    }
    c.drawCircle(pts[1], 2 * u, trazo);
    // Engrane esbozado
    final ep = Offset(s.width * 0.3, s.height * 0.12);
    c.save();
    c.translate(ep.dx, ep.dy);
    c.rotate(t * 0.3);
    for (var k = 0; k < 10; k++) {
      final a = k * math.pi / 5;
      c.drawLine(Offset(math.cos(a), math.sin(a)) * 6 * u, Offset(math.cos(a), math.sin(a)) * 8 * u, trazo);
    }
    c.drawCircle(Offset.zero, 6 * u, trazo);
    c.restore();
  }

  void _chispas(Canvas c, Size s, Color col) {
    for (var k = 0; k < 10; k++) {
      final f = (t * 0.12 + k / 10) % 1;
      final p = Offset(s.width * ((k * 0.37) % 1), s.height * (1 - f));
      c.drawCircle(p, 2 + (k % 3), relleno(col.withValues(alpha: 0.6 * math.sin(f * math.pi))));
    }
  }

  @override
  bool shouldRepaint(_PintorFondoEle old) => old.t != t || old.tipo != tipo;
}

/// Placa de circuito impreso (fondo del mapa del mundo).
void pintarPlaca(Canvas c, Size s, double t) {
  c.drawRect(Offset.zero & s, Paint()..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0B5D2E), Color(0xFF0E7A3C), Color(0xFF0A4D27)]).createShader(Offset.zero & s));
  final u = s.shortestSide / 100;
  final rnd = math.Random(11);
  final pista = linea(const Color(0x66D4AF37), 0.9 * u)..strokeJoin = StrokeJoin.round;
  final caminos = <List<Offset>>[];
  for (var k = 0; k < 18; k++) {
    var p = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height);
    final pts = [p];
    for (var j = 0; j < 4; j++) {
      final horiz = j.isEven;
      final d = (rnd.nextDouble() * 30 + 8) * u * (rnd.nextBool() ? 1 : -1);
      p = horiz ? Offset(p.dx + d, p.dy) : Offset(p.dx, p.dy + d);
      pts.add(p);
    }
    caminos.add(pts);
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (final q in pts.skip(1)) {
      path.lineTo(q.dx, q.dy);
    }
    c.drawPath(path, pista);
    c.drawCircle(pts.first, 1.6 * u, relleno(const Color(0xAAD4AF37)));
    c.drawCircle(pts.last, 1.6 * u, relleno(const Color(0xAAD4AF37)));
  }
  // Pulsos viajando por las pistas
  for (var k = 0; k < caminos.length; k += 2) {
    final pts = caminos[k];
    final f = (t * 0.35 + k * 0.13) % 1 * (pts.length - 1);
    final i = f.floor().clamp(0, pts.length - 2);
    final q = Offset.lerp(pts[i], pts[i + 1], f - i)!;
    c.drawCircle(q, 1.3 * u, relleno(const Color(0xFFFFF59D)));
    c.drawCircle(q, 3 * u, relleno(const Color(0x33FFF59D)));
  }
  // Chips
  for (var k = 0; k < 6; k++) {
    final r = Rect.fromCenter(center: Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height), width: 12 * u, height: 8 * u);
    c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u)), relleno(const Color(0xAA1C1C1C)));
    for (var j = 0; j < 5; j++) {
      final x = r.left + (j + 0.5) * r.width / 5;
      c.drawLine(Offset(x, r.top), Offset(x, r.top - 1.6 * u), linea(const Color(0xAABDBDBD), 0.6 * u));
      c.drawLine(Offset(x, r.bottom), Offset(x, r.bottom + 1.6 * u), linea(const Color(0xAABDBDBD), 0.6 * u));
    }
  }
  for (var k = 0; k < 8; k++) {
    final p = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height);
    final on = (t * 1.5 + k * 0.37) % 1 < 0.5;
    c.drawCircle(p, 1.2 * u, relleno(on ? const Color(0xFFFF5252) : oscurecer(const Color(0xFFFF5252), 0.6)));
    if (on) c.drawCircle(p, 3 * u, relleno(aclarar(const Color(0xFFFF5252), 0.3).withValues(alpha: 0.25)));
  }
}
