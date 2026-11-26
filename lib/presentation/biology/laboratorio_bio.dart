import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';

/// Especies del terrario: (emoji, nombre, color, máximo).
const especiesTerrario = [
  ('🌿', 'Plantas', Color(0xFF43A047), 20),
  ('🐰', 'Conejos', Color(0xFF8D6E63), 10),
  ('🦊', 'Zorros', Color(0xFFFF7043), 5),
  ('🍄', 'Hongos', Color(0xFF8E24AA), 5),
];

/// Resultado de simular el terrario.
class SimulacionTerrario {
  const SimulacionTerrario(this.equilibrado, this.mensaje, this.serie);
  final bool equilibrado;
  final String mensaje;

  /// Población de cada especie, día por día (31 valores: día 0 a 30).
  final List<List<double>> serie;
}

/// Simula 30 días del terrario. Un ecosistema está equilibrado si tiene sol,
/// agua, productores, consumidores y descomponedores en buena proporción
/// (pirámide de energía: muchas plantas, menos herbívoros y pocos carnívoros).
SimulacionTerrario simularTerrario({required bool sol, required bool agua, required List<int> n}) {
  final p0 = n[0].toDouble(), h0 = n[1].toDouble(), c0 = n[2].toDouble(), d0 = n[3].toDouble();
  // Va de a hasta b entre los días d1 y d2.
  double tramo(int dia, double a, double b, int d1, int d2) => dia <= d1 ? a : (dia >= d2 ? b : a + (b - a) * (dia - d1) / (d2 - d1));
  List<double> serie(double Function(int) f) => [for (var d = 0; d <= 30; d++) math.max(0, f(d)).toDouble()];
  List<double> estable(double v, double fase) => serie((d) => v == 0 ? 0 : v + math.sin(d / 3 + fase) * math.max(0.3, v * 0.08));

  String? problema;
  late List<List<double>> s;
  if (!sol || !agua) {
    problema = !sol
        ? 'Sin sol, las plantas no pueden hacer fotosíntesis y se secan. Sin plantas, los conejos y luego los zorros se quedan sin alimento.'
        : 'Sin agua, las plantas se marchitan. Sin plantas, los conejos y luego los zorros se quedan sin alimento.';
    s = [serie((d) => tramo(d, p0, 0, 0, 10)), serie((d) => tramo(d, h0, 0, 8, 18)), serie((d) => tramo(d, c0, 0, 15, 26)), estable(d0, 3)];
  } else if (p0 == 0) {
    problema = 'Sin plantas no hay productores: nadie convierte la luz del Sol en alimento. Los conejos y los zorros no tienen qué comer.';
    s = [serie((_) => 0), serie((d) => tramo(d, h0, 0, 2, 12)), serie((d) => tramo(d, c0, 0, 10, 22)), estable(d0, 3)];
  } else if (h0 == 0 && c0 > 0) {
    problema = 'Los zorros son carnívoros y comen conejos. Sin conejos, los zorros no tienen alimento.';
    s = [serie((d) => tramo(d, p0, math.min(20, p0 * 1.5), 0, 20)), serie((_) => 0), serie((d) => tramo(d, c0, 0, 3, 15)), estable(d0, 3)];
  } else if (h0 == 0) {
    problema = 'Faltan consumidores: agrega conejos (herbívoros) y zorros (carnívoros) para formar una cadena alimenticia.';
    s = [serie((d) => tramo(d, p0, math.min(20, p0 * 1.5), 0, 20)), serie((_) => 0), serie((_) => 0), estable(d0, 3)];
  } else if (h0 < 2 * c0) {
    problema =
        'Hay demasiados zorros para tan pocos conejos. Se comen todos los conejos y después los zorros pasan hambre. Debe haber al menos 2 conejos por cada zorro.';
    s = [serie((d) => tramo(d, p0, math.min(20, p0 + 4), 10, 25)), serie((d) => tramo(d, h0, 0, 0, 12)), serie((d) => tramo(d, c0, 0, 12, 24)), estable(d0, 3)];
  } else if (p0 < 3 * h0) {
    problema = 'Hay muy pocas plantas para tantos conejos: se las comen todas y después pasan hambre. Debe haber al menos 3 plantas por cada conejo.';
    s = [serie((d) => tramo(d, p0, 0, 0, 14)), serie((d) => tramo(d, h0, 0, 12, 24)), serie((d) => tramo(d, c0, 0, 20, 30)), estable(d0, 3)];
  } else if (c0 == 0) {
    problema =
        'Sin zorros que los controlen, los conejos se multiplican muchísimo, se comen todas las plantas y luego se quedan sin comida. Los depredadores mantienen el equilibrio.';
    s = [
      serie((d) => tramo(d, p0, 0, 6, 22)),
      serie((d) => d <= 18 ? tramo(d, h0, math.min(10, h0 * 3), 0, 18) : tramo(d, math.min(10, h0 * 3), 0, 18, 30)),
      serie((_) => 0),
      estable(d0, 3)
    ];
  } else if (d0 == 0) {
    problema =
        'Sin hongos ni otros descomponedores, las hojas y los restos no regresan al suelo como nutrientes. La tierra se empobrece y las plantas crecen cada vez menos.';
    s = [serie((d) => tramo(d, p0, p0 * 0.3, 5, 30)), serie((d) => tramo(d, h0, h0 * 0.5, 15, 30)), estable(c0, 2), serie((_) => 0)];
  } else {
    s = [estable(p0, 0), estable(h0, 1), estable(c0, 2), estable(d0, 3)];
  }
  return SimulacionTerrario(
    problema == null,
    problema ??
        '¡Ecosistema equilibrado! Las plantas producen alimento con la luz del Sol, los conejos comen plantas, los zorros comen conejos y los hongos devuelven los nutrientes al suelo. Todos sobrevivieron 30 días.',
    s,
  );
}

/// Laboratorio de la Vida: armar un terrario equilibrado.
class LaboratorioBio extends StatefulWidget {
  const LaboratorioBio({super.key, required this.onTerminar, this.color = const Color(0xFF2E7D32)});
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioBio> createState() => LaboratorioBioState();
}

class LaboratorioBioState extends State<LaboratorioBio> {
  bool sol = false, agua = false;
  final n = [0, 0, 0, 0];
  SimulacionTerrario? resultado;
  int dia = 0, intentos = 0;
  bool simulando = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _cambio(VoidCallback f) => setState(() {
        f();
        resultado = null;
        dia = 0;
      });

  void alternarSol() => _cambio(() => sol = !sol);
  void alternarAgua() => _cambio(() => agua = !agua);
  void cambiar(int k, int delta) => _cambio(() => n[k] = (n[k] + delta).clamp(0, especiesTerrario[k].$4));
  void poner(List<int> valores) => _cambio(() {
        for (var k = 0; k < 4; k++) {
          n[k] = valores[k];
        }
      });

  void simular() {
    if (simulando) return;
    _timer?.cancel();
    setState(() {
      resultado = simularTerrario(sol: sol, agua: agua, n: n);
      dia = 0;
      simulando = true;
      intentos++;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 90), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        dia++;
        if (dia >= 30) {
          t.cancel();
          simulando = false;
        }
      });
    });
  }

  bool get exito => resultado != null && resultado!.equilibrado && !simulando && dia >= 30;
  int get estrellas => intentos <= 2 ? 3 : (intentos <= 4 ? 2 : 1);

  Future<void> publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡Ecosistema equilibrado!',
        mensaje:
            'Tu terrario sobrevivió 30 días: sol, agua, productores, consumidores y descomponedores en equilibrio. ¡Ganaste la insignia “Guardián de Ecosistemas”!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  List<double> get actuales => resultado == null ? [for (final v in n) v.toDouble()] : [for (final s in resultado!.serie) s[dia]];

  String get mensaje {
    if (resultado != null && !simulando) return resultado!.mensaje;
    if (simulando) return 'Día $dia de 30… Observa qué pasa con cada población.';
    if (!sol || !agua) {
      return '¡Bienvenido al Laboratorio de la Vida! Vas a crear un ecosistema en un terrario. Primero dale lo que todo ser vivo necesita: enciende el ☀️ Sol y el 💧 Agua.';
    }
    if (n[0] == 0) return 'Ahora agrega productores: las 🌿 plantas fabrican su alimento con la luz del Sol.';
    if (n[1] == 0 || n[2] == 0) {
      return 'Agrega consumidores: 🐰 conejos (herbívoros) y 🦊 zorros (carnívoros). Recuerda la pirámide: muchas plantas, menos conejos y pocos zorros.';
    }
    if (n[3] == 0) return 'No olvides a los descomponedores: los 🍄 hongos convierten los restos en nutrientes para el suelo.';
    return '¡Tu terrario está listo! Presiona “Simular 30 días” para ver si se mantiene en equilibrio.';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final act = actuales;
    return Escenario(
      velo: 0.06,
      colorVelo: c,
      children: [
        encabezadoEle('Laboratorio', 'Laboratorio de la Vida', c),
        Positioned(left: 8, top: 60, width: 230, height: 214, child: GloboZatiEle(mensaje, tam: 12)),
        Positioned(
          left: 8,
          top: 280,
          width: 230,
          height: 192,
          child: PanelEle(
            titulo: 'Pirámide de energía',
            icono: Icons.change_history_rounded,
            color: c,
            child: CustomPaint(painter: _Piramide(n), child: const SizedBox.expand()),
          ),
        ),
        // Terrario
        Positioned(
          left: 244,
          top: 60,
          width: 380,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _Terrario(t, sol, agua, act, dia, resultado != null))),
          ),
        ),
        // Gráfica o controles
        Positioned(
          left: 630,
          top: 60,
          width: 222,
          height: 300,
          child: resultado == null
              ? PanelEle(
                  titulo: 'Tu terrario',
                  icono: Icons.tune_rounded,
                  color: c,
                  child: Column(children: [
                    Row(children: [
                      Expanded(child: _interruptor('☀️', 'Sol', sol, alternarSol)),
                      const SizedBox(width: 6),
                      Expanded(child: _interruptor('💧', 'Agua', agua, alternarAgua)),
                    ]),
                    const SizedBox(height: 6),
                    for (var k = 0; k < 4; k++) Expanded(child: _contador(k)),
                  ]),
                )
              : PanelEle(
                  titulo: 'Poblaciones · día $dia',
                  icono: Icons.show_chart_rounded,
                  color: c,
                  child: Column(children: [
                    Expanded(child: CustomPaint(painter: _Grafica(resultado!.serie, dia), child: const SizedBox.expand())),
                    Wrap(spacing: 6, children: [
                      for (final e in especiesTerrario) Text('${e.$1} ${e.$2}', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: e.$3)),
                    ]),
                  ]),
                ),
        ),
        Positioned(
          left: 244,
          top: 368,
          width: 608,
          child: Row(children: [
            if (resultado != null && !simulando)
              Tooltip(
                  message: 'Cambiar el terrario',
                  child: BotonJuego(texto: 'Cambiar', icono: Icons.edit_rounded, color: const Color(0xFF757575), onTap: () => _cambio(() {}))),
            const Spacer(),
            if (resultado == null)
              Tooltip(message: 'Simular 30 días', child: BotonJuego(texto: 'Simular 30 días', icono: Icons.play_arrow_rounded, color: c, onTap: simular)),
          ]),
        ),
        if (exito) Positioned(left: 640, top: 420, child: BotonSiguiente(texto: '¡Lo logré!', onTap: publicar)),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _interruptor(String emoji, String texto, bool activo, VoidCallback onTap) => Tooltip(
        message: texto,
        child: ChipEle(texto: '$emoji $texto ${activo ? 'ON' : 'OFF'}', activo: activo, color: widget.color, onTap: onTap),
      );

  Widget _contador(int k) {
    final e = especiesTerrario[k];
    return Row(children: [
      Text(e.$1, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 4),
      Expanded(child: Text(e.$2, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
      Tooltip(
        message: 'Quitar ${e.$2}',
        child: IconButton(visualDensity: VisualDensity.compact, onPressed: () => cambiar(k, -1), icon: Icon(Icons.remove_circle_rounded, color: e.$3)),
      ),
      SizedBox(width: 22, child: Text('${n[k]}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900))),
      Tooltip(
        message: 'Agregar ${e.$2}',
        child: IconButton(visualDensity: VisualDensity.compact, onPressed: () => cambiar(k, 1), icon: Icon(Icons.add_circle_rounded, color: e.$3)),
      ),
    ]);
  }
}

class _Terrario extends CustomPainter {
  _Terrario(this.t, this.sol, this.agua, this.n, this.dia, this.simulado);
  final double t;
  final bool sol, agua, simulado;
  final List<double> n;
  final int dia;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(
        Offset.zero & s,
        Paint()
          ..shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: sol ? const [Color(0xFF81D4FA), Color(0xFFE1F5FE)] : const [Color(0xFF455A64), Color(0xFF90A4AE)])
              .createShader(Offset.zero & s));
    if (sol) {
      final p = Offset(s.width * 0.85, s.height * 0.14);
      c.drawCircle(
          p, 38, Paint()..shader = RadialGradient(colors: const [Color(0x88FFF176), Color(0x00FFF176)]).createShader(Rect.fromCircle(center: p, radius: 38)));
      dibujarEmoji(c, '☀️', p, 34);
    }
    if (agua) {
      dibujarEmoji(c, '🌧️', Offset(s.width * 0.2, s.height * 0.12), 30);
      for (var k = 0; k < 14; k++) {
        final f = (t * 0.8 + k / 14) % 1;
        final x = s.width * (0.05 + (k * 0.071) % 0.4);
        c.drawLine(Offset(x, s.height * (0.18 + f * 0.45)), Offset(x - 2, s.height * (0.18 + f * 0.45) + 7), linea(const Color(0xAA1E88E5), 2));
      }
    }
    // Suelo
    final suelo = Rect.fromLTWH(0, s.height * 0.66, s.width, s.height * 0.34);
    final fertil = n[3] > 0 || !simulado ? 1.0 : (1 - dia / 30);
    c.drawRect(suelo, relleno(Color.lerp(const Color(0xFFBCAAA4), const Color(0xFF6D4C41), fertil)!));
    c.drawRect(Rect.fromLTWH(0, suelo.top, s.width, 6), relleno(Color.lerp(const Color(0xFFC5E1A5), const Color(0xFF7CB342), math.min(1, n[0] / 8))!));
    // Organismos dispersos
    final rnd = math.Random(7);
    final lugares = [
      [for (var i = 0; i < 20; i++) Offset(0.04 + rnd.nextDouble() * 0.92, 0.62 + rnd.nextDouble() * 0.06)],
      [for (var i = 0; i < 10; i++) Offset(0.08 + rnd.nextDouble() * 0.84, 0.74 + rnd.nextDouble() * 0.1)],
      [for (var i = 0; i < 10; i++) Offset(0.1 + rnd.nextDouble() * 0.8, 0.82 + rnd.nextDouble() * 0.08)],
      [for (var i = 0; i < 10; i++) Offset(0.05 + rnd.nextDouble() * 0.9, 0.92 + rnd.nextDouble() * 0.04)],
    ];
    const tam = [26.0, 24.0, 26.0, 18.0];
    for (var k = 0; k < 4; k++) {
      final cuantos = n[k].round().clamp(0, lugares[k].length);
      for (var i = 0; i < cuantos; i++) {
        final base = lugares[k][i];
        final mov = k == 1 || k == 2 ? Offset(math.sin(t * (1.2 + k * 0.3) + i) * 8, 0) : Offset.zero;
        dibujarEmoji(c, especiesTerrario[k].$1, Offset(base.dx * s.width, base.dy * s.height) + mov, tam[k]);
      }
    }
    // Vidrio del terrario
    c.drawRRect(RRect.fromRectAndRadius((Offset.zero & s).deflate(3), const Radius.circular(20)), linea(const Color(0xCCFFFFFF), 6));
    c.drawLine(Offset(s.width * 0.08, s.height * 0.1), Offset(s.width * 0.14, s.height * 0.5), linea(const Color(0x55FFFFFF), 8));
    if (simulado) {
      final tp = TextPainter(
          text: TextSpan(
              text: ' Día $dia ', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, backgroundColor: Color(0xAA1B5E20))),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(c, const Offset(14, 12));
    }
  }

  @override
  bool shouldRepaint(_Terrario old) => true;
}

class _Grafica extends CustomPainter {
  _Grafica(this.serie, this.dia);
  final List<List<double>> serie;
  final int dia;
  @override
  void paint(Canvas c, Size s) {
    final ejes = linea(const Color(0x55000000), 1.5);
    c.drawLine(Offset(0, s.height), Offset(s.width, s.height), ejes);
    c.drawLine(Offset.zero, Offset(0, s.height), ejes);
    for (var k = 0; k < serie.length; k++) {
      final max = especiesTerrario[k].$4.toDouble();
      final p = Path();
      for (var d = 0; d <= dia; d++) {
        final o = Offset(d / 30 * s.width, s.height - (serie[k][d] / max).clamp(0, 1) * s.height * 0.95);
        d == 0 ? p.moveTo(o.dx, o.dy) : p.lineTo(o.dx, o.dy);
      }
      c.drawPath(p, linea(especiesTerrario[k].$3, 2.5));
    }
  }

  @override
  bool shouldRepaint(_Grafica old) => old.dia != dia;
}

class _Piramide extends CustomPainter {
  _Piramide(this.n);
  final List<int> n;
  @override
  void paint(Canvas c, Size s) {
    const niveles = [('🦊', 'Carnívoros', Color(0xFFFF7043)), ('🐰', 'Herbívoros', Color(0xFF8D6E63)), ('🌿', 'Productores', Color(0xFF43A047))];
    final cuenta = [n[2], n[1], n[0]];
    final h = s.height / 3;
    for (var i = 0; i < 3; i++) {
      final ancho = s.width * (0.4 + 0.3 * i);
      final r = Rect.fromLTWH((s.width - ancho) / 2, i * h + 2, ancho, h - 4);
      c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), relleno(niveles[i].$3.withValues(alpha: 0.85)));
      final tp = TextPainter(
          text: TextSpan(text: '${niveles[i].$1} ${cuenta[i]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
          textDirection: TextDirection.ltr)
        ..layout();
      tp.paint(c, r.center - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_Piramide old) => true;
}
