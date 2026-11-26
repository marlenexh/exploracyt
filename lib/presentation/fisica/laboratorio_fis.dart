import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../ciencia/sim_comun.dart';
import '../electronica/comun.dart';

/// Una misión de lanzamiento.
class MisionLanzamiento {
  const MisionLanzamiento(this.lugar, this.emoji, this.gravedad, this.blanco, this.dato, {this.muro});
  final String lugar, emoji, dato;

  /// Aceleración de la gravedad (m/s²).
  final double gravedad;

  /// Distancia al centro del blanco (m).
  final double blanco;

  /// Muro: (distancia, altura) en metros.
  final (double, double)? muro;
}

const misionesLanzamiento = [
  MisionLanzamiento('la Tierra', '🌍', 9.8, 60, 'En la Tierra la gravedad jala con 9.8 m/s² cada segundo.'),
  MisionLanzamiento('la Luna', '🌕', 1.6, 85, 'En la Luna la gravedad es 6 veces menor: ¡con la misma fuerza todo vuela mucho más lejos!'),
  MisionLanzamiento('Marte', '🔴', 3.7, 75, 'En Marte la gravedad es menos de la mitad que en la Tierra. ¡Pasa sobre el muro!', muro: (45, 22)),
];

/// Resultado de un lanzamiento.
class Tiro {
  const Tiro(this.puntos, this.alcance, this.chocoMuro);

  /// Trayectoria (x, y) en metros.
  final List<Offset> puntos;
  final double alcance;
  final bool chocoMuro;
}

/// Calcula la trayectoria de un proyectil sin aire.
Tiro calcularTiro(double fuerza, double anguloGrados, MisionLanzamiento m) {
  final a = anguloGrados * math.pi / 180;
  final vx = fuerza * math.cos(a), vy = fuerza * math.sin(a);
  final tVuelo = 2 * vy / m.gravedad;
  final puntos = <Offset>[];
  var choco = false;
  for (var i = 0; i <= 80; i++) {
    final t = tVuelo * i / 80;
    final p = Offset(vx * t, vy * t - m.gravedad * t * t / 2);
    final muro = m.muro;
    if (muro != null && p.dx >= muro.$1 - 0.5 && p.dy <= muro.$2 && (puntos.isEmpty || puntos.last.dx < muro.$1 - 0.5)) {
      puntos.add(Offset(muro.$1 - 0.5, math.max(0, p.dy)));
      choco = true;
      break;
    }
    puntos.add(p);
  }
  return Tiro(puntos, choco ? puntos.last.dx : vx * tVuelo, choco);
}

/// Laboratorio de Lanzamientos de Física.
class LaboratorioFis extends StatefulWidget {
  const LaboratorioFis({super.key, required this.onTerminar, this.color = const Color(0xFF00897B)});
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioFis> createState() => LaboratorioFisState();
}

class LaboratorioFisState extends State<LaboratorioFis> {
  int mision = 0, tiros = 0;
  double fuerza = 15, angulo = 30;
  Tiro? tiro;
  double avance = 0;
  bool acerto = false;
  Timer? _timer;
  final logradas = <int>{};

  MisionLanzamiento get m => misionesLanzamiento[mision];
  bool get terminado => logradas.length == misionesLanzamiento.length;
  bool get volando => tiro != null && avance < 1;
  int get estrellas => tiros <= 6 ? 3 : (tiros <= 10 ? 2 : 1);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void fijar({double? f, double? a}) => setState(() {
        fuerza = f ?? fuerza;
        angulo = a ?? angulo;
        if (!volando) tiro = null;
      });

  void lanzar() {
    if (volando || acerto) return;
    _timer?.cancel();
    setState(() {
      tiro = calcularTiro(fuerza, angulo, m);
      avance = 0;
      tiros++;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        avance = math.min(1, avance + 0.025);
        if (avance >= 1) {
          t.cancel();
          if (!tiro!.chocoMuro && (tiro!.alcance - m.blanco).abs() <= 5) {
            acerto = true;
            logradas.add(mision);
          }
        }
      });
    });
  }

  void siguienteMision() => setState(() {
        if (mision < misionesLanzamiento.length - 1) mision++;
        tiro = null;
        acerto = false;
        avance = 0;
      });

  Future<void> publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡Misión espacial cumplida!',
        mensaje:
            'Diste en el blanco en la Tierra, la Luna y Marte. La gravedad cambia en cada lugar y por eso cambian los tiros. ¡Ganaste la insignia “Ingeniero de Lanzamientos”!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  String get mensaje {
    if (terminado) return '¡Lo lograste en los tres mundos! Presiona “Terminar”.';
    if (tiro == null) {
      return 'Misión ${mision + 1}: lanza la pelota en ${m.lugar} ${m.emoji} y cae en el blanco a ${m.blanco.toInt()} m. ${m.dato} Ajusta la fuerza y el ángulo, y presiona “¡Lanzar!”.';
    }
    if (volando) return '¡Allá va! La gravedad la jala hacia abajo todo el tiempo y por eso su camino es una curva.';
    if (acerto) return '¡En el blanco! Cayó a ${tiro!.alcance.toStringAsFixed(0)} m.';
    if (tiro!.chocoMuro) return '¡Chocó con el muro! Prueba un ángulo más alto para que pase por arriba.';
    final dif = tiro!.alcance - m.blanco;
    return dif < 0
        ? 'Cayó a ${tiro!.alcance.toStringAsFixed(0)} m: te faltaron ${(-dif).toStringAsFixed(0)} m. Usa más fuerza o un ángulo más cercano a 45°.'
        : 'Cayó a ${tiro!.alcance.toStringAsFixed(0)} m: te pasaste ${dif.toStringAsFixed(0)} m. Usa menos fuerza.';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Escenario(
      velo: 0.06,
      colorVelo: c,
      children: [
        encabezadoEle('Laboratorio', 'Laboratorio de Lanzamientos', c),
        Positioned(left: 8, top: 60, width: 230, height: 230, child: GloboZatiEle(mensaje, tam: 12)),
        Positioned(
          left: 8,
          top: 296,
          width: 230,
          height: 176,
          child: PanelEle(
            titulo: 'Misiones · tiros: $tiros',
            icono: Icons.rocket_launch_rounded,
            color: c,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (var k = 0; k < misionesLanzamiento.length; k++)
                Row(children: [
                  Text(logradas.contains(k) ? '✅' : (k == mision ? '▶️' : '⬜'), style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text('${misionesLanzamiento[k].emoji} ${misionesLanzamiento[k].lugar[0].toUpperCase()}${misionesLanzamiento[k].lugar.substring(1)}',
                      style: TextStyle(fontSize: 14, fontWeight: k == mision ? FontWeight.w900 : FontWeight.w600)),
                  const Spacer(),
                  Text('g = ${misionesLanzamiento[k].gravedad}', style: const TextStyle(fontSize: 12)),
                ]),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 262,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _Campo(m, tiro, avance, fuerza, angulo, t, acerto), child: const SizedBox.expand())),
          ),
        ),
        Positioned(
          left: 244,
          top: 328,
          width: 608,
          height: 86,
          child: PanelEle(
            titulo: 'Controles de la catapulta',
            icono: Icons.tune_rounded,
            color: c,
            child: Row(children: [
              Expanded(
                child: Column(children: [
                  Expanded(
                      child: deslizador(context, '💪', 'Fuerza ${fuerza.toStringAsFixed(0)}', fuerza, (v) => fijar(f: v.roundToDouble()), c, min: 5, max: 35)),
                  Expanded(
                      child: deslizador(
                          context, '📐', 'Ángulo ${angulo.toStringAsFixed(0)}°', angulo, (v) => fijar(a: v.roundToDouble()), const Color(0xFFFF7043),
                          min: 10, max: 80)),
                ]),
              ),
              const SizedBox(width: 10),
              if (!acerto) Tooltip(message: 'Lanzar', child: BotonJuego(texto: '¡Lanzar!', icono: Icons.sports_baseball_rounded, color: c, onTap: lanzar)),
            ]),
          ),
        ),
        if (acerto && !terminado)
          Positioned(
              left: 640,
              top: 420,
              child: Tooltip(
                  message: 'Siguiente misión',
                  child: BotonJuego(texto: 'Siguiente misión', icono: Icons.arrow_forward_rounded, color: c, onTap: siguienteMision))),
        if (terminado) Positioned(left: 660, top: 420, child: BotonSiguiente(texto: 'Terminar', onTap: publicar)),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _Campo extends CustomPainter {
  _Campo(this.m, this.tiro, this.avance, this.fuerza, this.angulo, this.t, this.acerto);
  final MisionLanzamiento m;
  final Tiro? tiro;
  final double avance, fuerza, angulo, t;
  final bool acerto;

  @override
  void paint(Canvas c, Size s) {
    final cielo = switch (m.emoji) {
      '🌍' => const [Color(0xFF81D4FA), Color(0xFFE1F5FE)],
      '🌕' => const [Color(0xFF0B0D2A), Color(0xFF283593)],
      _ => const [Color(0xFFFFAB91), Color(0xFFFFE0B2)],
    };
    final suelo = switch (m.emoji) { '🌍' => const Color(0xFF7CB342), '🌕' => const Color(0xFFB0BEC5), _ => const Color(0xFFBF5B33) };
    c.drawRect(Offset.zero & s,
        Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: cielo).createShader(Offset.zero & s));
    if (m.emoji == '🌕') {
      for (var k = 0; k < 40; k++) {
        c.drawCircle(Offset((k * 211 % 1000) / 1000 * s.width, (k * 97 % 1000) / 1000 * s.height * 0.7), 1.2, relleno(Colors.white70));
      }
      dibujarEmoji(c, '🌍', Offset(s.width * 0.85, s.height * 0.18), 34);
    }
    // Escala: 105 m a lo ancho; altura hasta 45 m visibles.
    final x0 = 40.0, piso = s.height - 30;
    final ex = (s.width - x0 - 14) / 105, ey = (piso - 14) / 45;
    Offset p(Offset m) => Offset(x0 + m.dx * ex, piso - m.dy * ey);
    c.drawRect(Rect.fromLTRB(0, piso, s.width, s.height), relleno(suelo));
    // Regla de distancias
    for (var d = 0; d <= 100; d += 20) {
      final x = x0 + d * ex;
      c.drawLine(Offset(x, piso), Offset(x, piso + 6), linea(Colors.white, 2));
      final tp = TextPainter(
          text: TextSpan(text: '$d m', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w800)),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(c, Offset(x - tp.width / 2, piso + 8));
    }
    // Blanco
    final b = p(Offset(m.blanco, 0));
    for (var k = 3; k >= 1; k--) {
      c.drawOval(Rect.fromCenter(center: b, width: 5 * ex * 2 * k / 3, height: 10.0 * k / 3), relleno(k.isOdd ? const Color(0xFFE53935) : Colors.white));
    }
    dibujarEmoji(c, '🎯', b - const Offset(0, 22), 26);
    // Muro
    final muro = m.muro;
    if (muro != null) {
      final r = Rect.fromLTRB(p(Offset(muro.$1 - 1.5, 0)).dx, p(Offset(0, muro.$2)).dy, p(Offset(muro.$1 + 1.5, 0)).dx, piso);
      c.drawRect(r, relleno(const Color(0xFF6D4C41)));
      for (var y = r.top; y < r.bottom; y += 10) {
        c.drawLine(Offset(r.left, y), Offset(r.right, y), linea(const Color(0x55000000), 1));
      }
    }
    // Catapulta y flecha de dirección
    final base = p(Offset.zero);
    c.drawRect(Rect.fromCenter(center: base + const Offset(0, -6), width: 34, height: 12), relleno(const Color(0xFF5D4037)));
    final a = angulo * math.pi / 180;
    final punta = base + Offset(math.cos(a), -math.sin(a)) * (18 + fuerza * 1.2);
    c.drawLine(base + const Offset(0, -10), punta, linea(const Color(0xFFFF7043), 4)..strokeCap = StrokeCap.round);
    c.drawCircle(punta, 4, relleno(const Color(0xFFFF7043)));
    // Trayectoria y pelota
    final tr = tiro;
    if (tr != null) {
      final n = (tr.puntos.length * avance).clamp(1, tr.puntos.length).toInt();
      for (var i = 0; i < n; i += 2) {
        c.drawCircle(p(tr.puntos[i]), 2.2, relleno(const Color(0xAAFFFFFF)));
      }
      final actual = p(tr.puntos[n - 1]);
      dibujarEmoji(c, '⚽', Offset(actual.dx, math.max(10, actual.dy)), 22);
      if (actual.dy < 0) dibujarEmoji(c, '⬆️', Offset(actual.dx, 10), 14);
      if (avance >= 1) {
        final tp = TextPainter(
            text: TextSpan(
                text: acerto ? ' ¡En el blanco! ' : ' ${tr.alcance.toStringAsFixed(0)} m ',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    backgroundColor: acerto ? const Color(0xFF43A047) : const Color(0xCC000000))),
            textDirection: TextDirection.ltr)
          ..layout();
        tp.paint(c, Offset((actual.dx - tp.width / 2).clamp(4, s.width - tp.width - 4), actual.dy - 46));
      }
    } else {
      dibujarEmoji(c, '⚽', base + const Offset(0, -20), 20);
    }
    final tp = TextPainter(
        text: TextSpan(
            text: ' ${m.emoji} ${m.lugar[0].toUpperCase()}${m.lugar.substring(1)} · gravedad ${m.gravedad} m/s² ',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, backgroundColor: Color(0x99000000))),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(c, const Offset(10, 8));
  }

  @override
  bool shouldRepaint(_Campo old) => true;
}
