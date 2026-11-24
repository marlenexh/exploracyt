import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show Reloj, linea, relleno, textoEn;
import '../biology/tema1/estilo_mundo.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../ciencia/pinceles.dart';

/// Fondos animados del mundo de Inteligencia Artificial: el mapa (la
/// estación de las máquinas inteligentes), uno por tema y el laboratorio.
enum FondoIA { estacion, maquinas, patrones, ensena, accion, cuidado, laboratorio }

EstiloMundo estiloIA(FondoIA f) {
  final (a, b, borde) = switch (f) {
    FondoIA.estacion => (const Color(0xFFF48FB1), const Color(0xFFD81B60), const Color(0xFF880E4F)),
    FondoIA.maquinas => (const Color(0xFFB39DDB), const Color(0xFF5E35B1), const Color(0xFF311B92)),
    FondoIA.patrones => (const Color(0xFFFFCC80), const Color(0xFFF57C00), const Color(0xFFBF360C)),
    FondoIA.ensena => (const Color(0xFFA5D6A7), const Color(0xFF2E7D32), const Color(0xFF1B5E20)),
    FondoIA.accion => (const Color(0xFF80DEEA), const Color(0xFF00838F), const Color(0xFF004D57)),
    FondoIA.cuidado => (const Color(0xFF90CAF9), const Color(0xFF1565C0), const Color(0xFF0D2F6B)),
    FondoIA.laboratorio => (const Color(0xFFCE93D8), const Color(0xFF8E24AA), const Color(0xFF4A148C)),
  };
  return EstiloMundo(
      fondo: (_) => FondoInteligencia(f),
      letrero: [a, b],
      bordeLetrero: borde,
      sombraLetrero: Color.lerp(borde, Colors.black, 0.4)!,
      textoLetrero: Colors.white);
}

class FondoInteligencia extends StatelessWidget {
  const FondoInteligencia(this.tipo, {super.key});
  final FondoIA tipo;
  @override
  Widget build(BuildContext context) =>
      RepaintBoundary(child: Reloj(builder: (_, t) => CustomPaint(painter: _Pintor(tipo, t), child: const SizedBox.expand())));
}

class _Pintor extends CustomPainter {
  _Pintor(this.tipo, this.t);
  final FondoIA tipo;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    final u = s.shortestSide / 100;
    switch (tipo) {
      case FondoIA.estacion:
        _estacion(c, s, u);
      case FondoIA.maquinas:
        _maquinas(c, s, u);
      case FondoIA.patrones:
        _patrones(c, s, u);
      case FondoIA.ensena:
        _ensena(c, s, u);
      case FondoIA.accion:
        _accion(c, s, u);
      case FondoIA.cuidado:
        _cuidado(c, s, u);
      case FondoIA.laboratorio:
        _laboratorio(c, s, u);
    }
  }

  /// Mapa: estación espacial nocturna con una gran red neuronal que se
  /// enciende, pistas de circuito con datos que viajan y robots que flotan.
  void _estacion(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF12002B), Color(0xFF2A0A4A), Color(0xFF4A1259)]);
    estrellas(c, s, u, t, n: 70, alto: 0.6);
    _circuitos(c, s, u, const Color(0x55F06292), const Color(0xFFFF80AB));
    _redNeuronal(c, Rect.fromLTWH(s.width * 0.18, s.height * 0.12, s.width * 0.64, s.height * 0.5), u, const Color(0xFFFF80AB), const Color(0xFF80DEEA));
    // Plataforma de la estación
    final piso = Rect.fromLTWH(0, s.height * 0.8, s.width, s.height * 0.2);
    c.drawRect(
        piso,
        Paint()
          ..shader =
              const LinearGradient(colors: [Color(0xFF3A1250), Color(0xFF1A0530)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(piso));
    for (var k = 0; k < 12; k++) {
      final x = s.width * k / 11;
      c.drawLine(Offset(s.width / 2 + (x - s.width / 2) * 0.3, piso.top), Offset(x, s.height), linea(const Color(0x33FF80AB), 0.3 * u));
    }
    c.drawLine(piso.topLeft, piso.topRight, linea(const Color(0xAAFF80AB), 0.5 * u));
    for (var k = 0; k < 3; k++) {
      final x = s.width * (0.12 + k * 0.38);
      dibujarEmoji(c, ['🤖', '🛰️', '🦾'][k], Offset(x, s.height * (0.72 + 0.02 * k) + math.sin(t * 1.4 + k) * 1.5 * u), 7 * u);
    }
  }

  /// Tema 1: fábrica de robots con banda transportadora y engranes.
  void _maquinas(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF1A237E), Color(0xFF4527A0), Color(0xFF7E57C2)]);
    for (var k = 0; k < 4; k++) {
      engrane(
          c, Offset(s.width * (0.08 + k * 0.29), s.height * (0.14 + (k % 2) * 0.08)), (8 + k % 2 * 4) * u, t * (k.isEven ? 0.5 : -0.7), const Color(0x22FFFFFF),
          dientes: 10);
    }
    // Ventanas de la fábrica
    for (var k = 0; k < 6; k++) {
      final r = Rect.fromLTWH(s.width * (0.04 + k * 0.165), s.height * 0.32, s.width * 0.12, s.height * 0.16);
      c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(u)), relleno(const Color(0x22B3E5FC)));
      c.drawLine(r.topCenter, r.bottomCenter, linea(const Color(0x33FFFFFF), 0.3 * u));
    }
    // Banda transportadora con robots
    final y = s.height * 0.8;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-2 * u, y, s.width + 4 * u, 5 * u), Radius.circular(2.5 * u)), relleno(const Color(0xFF263238)));
    for (var x = -(t * 6 * u) % (6 * u); x < s.width; x += 6 * u) {
      c.drawLine(Offset(x, y + u), Offset(x, y + 4 * u), linea(const Color(0xFF546E7A), 0.4 * u));
    }
    const cosas = ['🤖', '📱', '🔊', '🚗', '🦾', '💡'];
    for (var k = 0; k < 6; k++) {
      final x = ((t * 0.05 + k / 6) % 1.1 - 0.05) * s.width;
      dibujarEmoji(c, cosas[k], Offset(x, y - 4 * u), 7 * u);
    }
    c.drawRect(Rect.fromLTWH(0, y + 5 * u, s.width, s.height), relleno(const Color(0xFF1A1340)));
    // Chispas del brazo soldador
    final brazo = Offset(s.width * 0.5, s.height * 0.62);
    c.drawLine(Offset(s.width * 0.5, 0), brazo, linea(const Color(0x88B0BEC5), 1.2 * u));
    for (var k = 0; k < 6; k++) {
      final f = (t * 1.5 + k / 6) % 1;
      final a = k * 1.1 + t;
      c.drawCircle(brazo + Offset(math.cos(a), math.sin(a).abs()) * f * 6 * u, 0.4 * u, relleno(Color.fromARGB((255 * (1 - f)).round(), 255, 213, 79)));
    }
  }

  /// Tema 2: mosaico de figuras que cambia de color formando patrones.
  void _patrones(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFFFFF8E1), Color(0xFFFFE0B2)]);
    final lado = 12 * u;
    const cols = [Color(0x33FF7043), Color(0x33FFCA28), Color(0x3366BB6A), Color(0x3329B6F6), Color(0x33AB47BC)];
    var fila = 0;
    for (var y = 0.0; y < s.height + lado; y += lado, fila++) {
      var col = 0;
      for (var x = 0.0; x < s.width + lado; x += lado, col++) {
        final k = (fila + col + (t * 0.6).floor()) % 5;
        final cen = Offset(x + lado / 2, y + lado / 2);
        final p = relleno(cols[k]);
        switch ((fila * 3 + col) % 3) {
          case 0:
            c.drawCircle(cen, lado * 0.32, p);
          case 1:
            c.drawRect(Rect.fromCenter(center: cen, width: lado * 0.56, height: lado * 0.56), p);
          default:
            c.drawPath(
                Path()
                  ..moveTo(cen.dx, cen.dy - lado * 0.32)
                  ..lineTo(cen.dx + lado * 0.32, cen.dy + lado * 0.28)
                  ..lineTo(cen.dx - lado * 0.32, cen.dy + lado * 0.28)
                  ..close(),
                p);
        }
      }
    }
    // Lupa que recorre el mosaico
    final l = Offset(s.width * (0.5 + 0.35 * math.sin(t * 0.25)), s.height * (0.5 + 0.25 * math.sin(t * 0.4)));
    c.drawCircle(l, 9 * u, relleno(const Color(0x33FFFFFF)));
    c.drawCircle(l, 9 * u, linea(const Color(0xAA6D4C41), 1.2 * u));
    c.drawLine(l + Offset(6.4 * u, 6.4 * u), l + Offset(13 * u, 13 * u), linea(const Color(0xAA6D4C41), 2 * u)..strokeCap = StrokeCap.round);
  }

  /// Tema 3: pizarrón de la escuela de robots con dibujos de gis.
  void _ensena(Canvas c, Size s, double u) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFF8D6E63)));
    final piz = Rect.fromLTWH(s.width * 0.03, s.height * 0.05, s.width * 0.94, s.height * 0.72);
    c.drawRRect(RRect.fromRectAndRadius(piz, Radius.circular(2 * u)), relleno(const Color(0xFF5D4037)));
    final verde = piz.deflate(1.6 * u);
    c.drawRect(verde, Paint()..shader = const LinearGradient(colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)]).createShader(verde));
    final gis = linea(const Color(0x88FFFFFF), 0.35 * u);
    // Ejemplos con su etiqueta, como en el aprendizaje supervisado
    const ej = [('🐱', 'gato'), ('🐶', 'perro'), ('🐱', 'gato'), ('🐦', 'ave')];
    for (var k = 0; k < ej.length; k++) {
      final p = Offset(verde.left + verde.width * (0.12 + k * 0.17), verde.top + verde.height * 0.3);
      c.saveLayer(null, Paint()..color = const Color(0x99FFFFFF));
      dibujarEmoji(c, ej[k].$1, p, 7 * u);
      c.restore();
      textoEn(c, ej[k].$2, p + Offset(0, 7 * u), tam: 3.2 * u, color: const Color(0xCCFFFFFF));
      c.drawLine(p + Offset(-4 * u, 10 * u), p + Offset(4 * u, 10 * u), gis);
    }
    // Flecha y "?" que parpadea
    final q = Offset(verde.left + verde.width * 0.84, verde.top + verde.height * 0.3);
    c.drawLine(q - Offset(10 * u, 0), q - Offset(4 * u, 0), gis);
    textoEn(c, '¿?', q, tam: 6 * u, color: Color.fromARGB((150 + 100 * math.sin(t * 3)).round().clamp(0, 255), 255, 241, 118));
    // Gráfica de aprendizaje dibujada con gis
    final g = Rect.fromLTWH(verde.left + verde.width * 0.1, verde.top + verde.height * 0.6, verde.width * 0.35, verde.height * 0.3);
    c.drawLine(g.bottomLeft, g.topLeft, gis);
    c.drawLine(g.bottomLeft, g.bottomRight, gis);
    final avance = (t * 0.15) % 1;
    final curva = Path()..moveTo(g.left, g.bottom);
    for (var f = 0.0; f <= avance; f += 0.02) {
      curva.lineTo(g.left + f * g.width, g.bottom - (1 - math.exp(-4 * f)) * g.height);
    }
    c.drawPath(curva, linea(const Color(0xCCFFF176), 0.5 * u));
    // Repisa y gises
    c.drawRect(Rect.fromLTWH(piz.left, piz.bottom, piz.width, 2 * u), relleno(const Color(0xFF4E342E)));
    dibujarEmoji(c, '🤖', Offset(s.width * 0.82, s.height * 0.88 + math.sin(t * 2) * 0.6 * u), 9 * u);
    dibujarEmoji(c, '📚', Offset(s.width * 0.12, s.height * 0.9), 6 * u);
  }

  /// Tema 4: ciudad al atardecer con aparatos inteligentes conectados.
  void _accion(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF006064), Color(0xFF00838F), Color(0xFFFFB74D)]);
    // Edificios
    for (var k = 0; k < 10; k++) {
      final w = s.width / 10;
      final h = s.height * (0.25 + (k * 37 % 30) / 100);
      final r = Rect.fromLTWH(k * w, s.height * 0.85 - h, w * 0.9, h);
      c.drawRect(r, relleno(const Color(0xFF004D57)));
      for (var y = r.top + 2 * u; y < r.bottom - 2 * u; y += 4 * u) {
        for (var x = r.left + 1.5 * u; x < r.right - 2 * u; x += 3.5 * u) {
          final on = ((x * 7 + y * 3 + (t * 0.5).floor() * 13) ~/ 1) % 5 == 0;
          c.drawRect(Rect.fromLTWH(x, y, 1.6 * u, 2 * u), relleno(on ? const Color(0xFFFFF59D) : const Color(0x33FFFFFF)));
        }
      }
    }
    c.drawRect(Rect.fromLTWH(0, s.height * 0.85, s.width, s.height * 0.15), relleno(const Color(0xFF263238)));
    // Coche autónomo
    final x = ((t * 0.06) % 1.2 - 0.1) * s.width;
    dibujarEmoji(c, '🚗', Offset(x, s.height * 0.9), 6 * u);
    // Señales que viajan entre aparatos
    const aparatos = ['📱', '🔊', '⌚', '📺', '🛰️'];
    final pts = [for (var k = 0; k < 5; k++) Offset(s.width * (0.1 + k * 0.2), s.height * (0.18 + (k % 2) * 0.12) + math.sin(t + k) * u)];
    for (var k = 0; k < 4; k++) {
      c.drawLine(pts[k], pts[k + 1], linea(const Color(0x44FFFFFF), 0.3 * u));
      final f = (t * 0.6 + k * 0.25) % 1;
      c.drawCircle(Offset.lerp(pts[k], pts[k + 1], f)!, 0.8 * u, relleno(const Color(0xFFFFF59D)));
    }
    for (var k = 0; k < 5; k++) {
      for (var r = 0; r < 2; r++) {
        final f = (t * 0.5 + r * 0.5) % 1;
        c.drawCircle(pts[k], (4 + f * 6) * u, linea(Color.fromARGB((90 * (1 - f)).round(), 255, 255, 255), 0.3 * u));
      }
      dibujarEmoji(c, aparatos[k], pts[k], 6 * u);
    }
  }

  /// Tema 5: escudo de protección, candados y semáforo de precaución.
  void _cuidado(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF0D47A1), Color(0xFF1976D2), Color(0xFF64B5F6)]);
    // Hexágonos de un escudo digital
    final lado = 7 * u;
    for (var fila = 0; fila * lado * 1.5 < s.height + lado; fila++) {
      for (var col = 0; col * lado * 1.73 < s.width + lado; col++) {
        final cen = Offset(col * lado * 1.73 + (fila.isOdd ? lado * 0.87 : 0), fila * lado * 1.5);
        final brillo = (math.sin(t * 1.2 + col * 0.5 + fila * 0.7) * 0.5 + 0.5);
        final p = Path();
        for (var k = 0; k < 6; k++) {
          final a = math.pi / 6 + k * math.pi / 3;
          final q = cen + Offset(math.cos(a), math.sin(a)) * lado * 0.9;
          k == 0 ? p.moveTo(q.dx, q.dy) : p.lineTo(q.dx, q.dy);
        }
        p.close();
        c.drawPath(p, linea(Color.fromARGB((20 + 50 * brillo).round(), 255, 255, 255), 0.3 * u));
      }
    }
    // Gran escudo que late
    final e = Offset(s.width * 0.5, s.height * 0.45);
    final k = 1 + 0.03 * math.sin(t * 2);
    c.save();
    c.translate(e.dx, e.dy);
    c.scale(k);
    final escudo = Path()
      ..moveTo(0, -18 * u)
      ..quadraticBezierTo(14 * u, -14 * u, 16 * u, -12 * u)
      ..quadraticBezierTo(16 * u, 10 * u, 0, 20 * u)
      ..quadraticBezierTo(-16 * u, 10 * u, -16 * u, -12 * u)
      ..quadraticBezierTo(-14 * u, -14 * u, 0, -18 * u)
      ..close();
    c.drawPath(escudo, relleno(const Color(0x33FFFFFF)));
    c.drawPath(escudo, linea(const Color(0x88FFFFFF), 0.6 * u));
    c.restore();
    flotan(c, s, u, t, const ['🔒', '🛡️', '🚦', '🧐', '✅'], 0.08);
  }

  /// Laboratorio: pantallas con la curva de entrenamiento y neuronas.
  void _laboratorio(Canvas c, Size s, double u) {
    gradiente(c, s, const [Color(0xFF1A0033), Color(0xFF2E1050)]);
    _circuitos(c, s, u, const Color(0x44CE93D8), const Color(0xFFE1BEE7));
    // Monitores
    for (var k = 0; k < 3; k++) {
      final r = Rect.fromLTWH(s.width * (0.05 + k * 0.32), s.height * 0.08, s.width * 0.26, s.height * 0.26);
      c.drawRRect(RRect.fromRectAndRadius(r.inflate(u), Radius.circular(1.5 * u)), relleno(const Color(0xFF37474F)));
      c.drawRect(r, relleno(const Color(0xFF0B1020)));
      final p = Path()..moveTo(r.left, r.bottom - 2 * u);
      for (var x = 0.0; x <= 1; x += 0.04) {
        final y = switch (k) {
          0 => 1 - math.exp(-4 * x) + 0.04 * math.sin(x * 30 + t * 3),
          1 => 0.5 + 0.35 * math.sin(x * 9 + t * 2),
          _ => (x * 7 + t).floor().isEven ? 0.8 : 0.3,
        };
        p.lineTo(r.left + x * r.width, r.bottom - 2 * u - y * (r.height - 4 * u));
      }
      c.drawPath(p, linea([const Color(0xFF69F0AE), const Color(0xFF40C4FF), const Color(0xFFFF80AB)][k], 0.4 * u));
    }
    _redNeuronal(c, Rect.fromLTWH(s.width * 0.25, s.height * 0.45, s.width * 0.5, s.height * 0.38), u, const Color(0xFFE1BEE7), const Color(0xFF69F0AE));
  }

  /// Pistas de circuito con pulsos de datos.
  void _circuitos(Canvas c, Size s, double u, Color pista, Color pulso) {
    for (var k = 0; k < 8; k++) {
      final y = s.height * (0.08 + k * 0.12);
      final x1 = s.width * ((k * 0.17) % 0.4), x2 = x1 + s.width * 0.25, x3 = x2 + s.width * 0.08;
      final p = Path()
        ..moveTo(0, y)
        ..lineTo(x1, y)
        ..lineTo(x2, y + 4 * u * (k.isEven ? 1 : -1))
        ..lineTo(s.width, y + 4 * u * (k.isEven ? 1 : -1));
      c.drawPath(p, linea(pista, 0.3 * u));
      c.drawCircle(Offset(x3, y + 4 * u * (k.isEven ? 1 : -1)), 0.8 * u, relleno(pista));
      final f = (t * 0.15 + k * 0.13) % 1;
      c.drawCircle(Offset(f * s.width, f * s.width < x1 ? y : y + 4 * u * (k.isEven ? 1 : -1)), 0.6 * u, relleno(pulso));
    }
  }

  /// Red neuronal de 3 capas con señales que la recorren.
  void _redNeuronal(Canvas c, Rect r, double u, Color nodo, Color senal) {
    const capas = [3, 5, 4, 2];
    final pos = <List<Offset>>[];
    for (var i = 0; i < capas.length; i++) {
      pos.add([for (var j = 0; j < capas[i]; j++) Offset(r.left + r.width * i / (capas.length - 1), r.top + r.height * (j + 1) / (capas[i] + 1))]);
    }
    for (var i = 0; i < capas.length - 1; i++) {
      for (final a in pos[i]) {
        for (final b in pos[i + 1]) {
          c.drawLine(a, b, linea(nodo.withValues(alpha: 0.18), 0.25 * u));
        }
      }
    }
    for (var k = 0; k < 6; k++) {
      final f = (t * 0.35 + k / 6) % 1;
      final capa = (f * (capas.length - 1)).floor();
      final fr = f * (capas.length - 1) - capa;
      final a = pos[capa][(k * 7) % capas[capa]], b = pos[capa + 1][(k * 3 + 1) % capas[capa + 1]];
      c.drawCircle(Offset.lerp(a, b, fr)!, 0.8 * u, relleno(senal));
    }
    for (var i = 0; i < capas.length; i++) {
      for (var j = 0; j < capas[i]; j++) {
        final brillo = math.sin(t * 2 + i * 1.3 + j) * 0.5 + 0.5;
        c.drawCircle(pos[i][j], 2.4 * u, relleno(nodo.withValues(alpha: 0.25 + 0.5 * brillo)));
        c.drawCircle(pos[i][j], 2.4 * u, linea(nodo, 0.3 * u));
      }
    }
  }

  @override
  bool shouldRepaint(_Pintor old) => old.t != t || old.tipo != tipo;
}
