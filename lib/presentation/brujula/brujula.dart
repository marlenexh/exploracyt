import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/brujula.dart';
import '../../data/worlds.dart';
import '../../main.dart' show store;

Color colorPieza(String mundo) => mundos.firstWhere((m) => m.id == mundo).color;

/// Dibujo de la Brújula de la Ciencia con sus seis piezas. Las piezas que
/// faltan se ven como huecos con “?”. [nueva] llega volando según [llegada]
/// (0 = lejos, 1 = en su lugar).
class BrujulaCiencia extends StatelessWidget {
  const BrujulaCiencia({super.key, required this.obtenidas, this.nueva, this.llegada = 1, this.giro = 0, this.tam = 220});
  final Set<String> obtenidas;
  final String? nueva;
  final double llegada, giro, tam;

  @override
  Widget build(BuildContext context) => SizedBox.square(
        dimension: tam,
        child: CustomPaint(painter: _PintorBrujula(obtenidas, nueva, llegada, giro)),
      );
}

class _PintorBrujula extends CustomPainter {
  _PintorBrujula(this.obtenidas, this.nueva, this.llegada, this.giro);
  final Set<String> obtenidas;
  final String? nueva;
  final double llegada, giro;

  static const _sector = 2 * math.pi / 6;

  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset.zero);
    final R = s.shortestSide / 2;
    final completa = piezasBrujula.every((p) => obtenidas.contains(p.mundo));

    // Brillo cuando está completa
    if (completa) {
      c.drawCircle(
          centro,
          R,
          Paint()
            ..shader = RadialGradient(colors: [const Color(0x88FFF59D), const Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: centro, radius: R)));
    }
    // Aro de latón
    final aro = R * 0.92;
    c.drawCircle(centro + Offset(0, R * 0.04), aro, Paint()..color = const Color(0x55000000));
    c.drawCircle(
        centro,
        aro,
        Paint()
          ..shader = const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE082), Color(0xFFC8962E), Color(0xFF8D6E2B), Color(0xFFFFD54F)]).createShader(Rect.fromCircle(center: centro, radius: aro)));
    final interior = R * 0.78;
    c.drawCircle(centro, interior, Paint()..color = const Color(0xFF1B2A47));
    // Marcas del aro
    for (var k = 0; k < 36; k++) {
      final a = k * math.pi / 18;
      final largo = k % 9 == 0 ? 0.09 : 0.045;
      c.drawLine(
          centro + Offset.fromDirection(a, aro * (0.97 - largo)),
          centro + Offset.fromDirection(a, aro * 0.97),
          Paint()
            ..color = const Color(0xFF5D4037)
            ..strokeWidth = k % 9 == 0 ? 2.2 : 1.2);
    }
    // N, E, S, O
    for (final (letra, a) in const [('N', -math.pi / 2), ('E', 0.0), ('S', math.pi / 2), ('O', math.pi)]) {
      _texto(c, letra, centro + Offset.fromDirection(a, (aro + interior) / 2), R * 0.1, const Color(0xFF4E342E));
    }

    // Piezas
    for (var i = 0; i < piezasBrujula.length; i++) {
      final p = piezasBrujula[i];
      final inicio = -math.pi / 2 - _sector / 2 + i * _sector;
      final medio = inicio + _sector / 2;
      final tiene = obtenidas.contains(p.mundo) || p.mundo == nueva;
      final camino = Path()
        ..moveTo(centro.dx, centro.dy)
        ..arcTo(Rect.fromCircle(center: centro, radius: interior * 0.97), inicio + 0.03, _sector - 0.06, false)
        ..close();
      if (!tiene) {
        c.drawPath(camino, Paint()..color = const Color(0xFF0E1830));
        c.drawPath(
            camino,
            Paint()
              ..color = const Color(0x66FFFFFF)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5);
        _texto(c, '?', centro + Offset.fromDirection(medio, interior * 0.68), R * 0.16, const Color(0x88FFFFFF));
        continue;
      }
      var desplazado = Offset.zero;
      var escala = 1.0;
      if (p.mundo == nueva && llegada < 1) {
        final e = Curves.easeOutBack.transform(llegada.clamp(0, 1));
        desplazado = Offset.fromDirection(medio, (1 - e) * R * 1.6);
        escala = 0.6 + 0.4 * e;
      }
      c.save();
      final ancla = centro + desplazado;
      c.translate(ancla.dx, ancla.dy);
      c.scale(escala);
      c.translate(-centro.dx, -centro.dy);
      final color = colorPieza(p.mundo);
      c.drawPath(
          camino,
          Paint()
            ..shader = RadialGradient(colors: [Color.lerp(color, Colors.white, 0.45)!, color, Color.lerp(color, Colors.black, 0.3)!], stops: const [0, 0.6, 1])
                .createShader(Rect.fromCircle(center: centro, radius: interior)));
      c.drawPath(
          camino,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = p.mundo == nueva ? 3 : 1.8);
      _texto(c, p.emoji, centro + Offset.fromDirection(medio, interior * 0.68), R * 0.17, Colors.white);
      c.restore();
    }

    // Aguja
    final a = (completa ? giro : 0) - math.pi / 2;
    final punta = centro + Offset.fromDirection(a, interior * 0.4);
    final cola = centro + Offset.fromDirection(a + math.pi, interior * 0.4);
    final lado = Offset.fromDirection(a + math.pi / 2, R * 0.06);
    c.drawPath(Path()..addPolygon([punta, centro + lado, centro - lado], true), Paint()..color = const Color(0xFFE53935));
    c.drawPath(Path()..addPolygon([cola, centro + lado, centro - lado], true), Paint()..color = const Color(0xFFECEFF1));
    c.drawCircle(centro, R * 0.08, Paint()..color = const Color(0xFFFFD54F));
    c.drawCircle(centro, R * 0.04, Paint()..color = const Color(0xFF8D6E2B));
  }

  void _texto(Canvas c, String t, Offset en, double tam, Color color) {
    final tp = TextPainter(
      text: TextSpan(text: t, style: TextStyle(fontSize: tam, color: color, fontFamily: 'LilitaOne')),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, en - Offset(tp.width / 2, tp.height / 2));
  }

  @override
  bool shouldRepaint(_PintorBrujula old) => old.llegada != llegada || old.giro != giro || old.nueva != nueva || old.obtenidas.length != obtenidas.length;
}

/// Botón del mapa: brújula pequeña con el avance de piezas.
class BotonBrujula extends StatelessWidget {
  const BotonBrujula({super.key});
  @override
  Widget build(BuildContext context) {
    final n = store.piezas.length;
    return Semantics(
      button: true,
      label: 'Brújula de la Ciencia, $n de 6 piezas',
      child: Material(
        color: const Color(0xFF12304A),
        shape: const StadiumBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PantallaBrujula())),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 14, 4),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              BrujulaCiencia(obtenidas: store.piezas, tam: 38),
              const SizedBox(width: 6),
              Text('Brújula $n/6', style: const TextStyle(color: Colors.white, fontFamily: 'LilitaOne', fontSize: 16)),
            ]),
          ),
        ),
      ),
    );
  }
}

/// Pantalla con la brújula grande y dónde está cada pieza.
class PantallaBrujula extends StatefulWidget {
  const PantallaBrujula({super.key});
  @override
  State<PantallaBrujula> createState() => _PantallaBrujulaState();
}

class _PantallaBrujulaState extends State<PantallaBrujula> with SingleTickerProviderStateMixin {
  late final AnimationController _giro = AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _giro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final obtenidas = store.piezas;
    final completa = obtenidas.length == piezasBrujula.length;
    final brujula = AnimatedBuilder(
      animation: _giro,
      builder: (_, __) => BrujulaCiencia(obtenidas: obtenidas, giro: _giro.value * 2 * math.pi, tam: 260),
    );
    final lista = Column(mainAxisSize: MainAxisSize.min, children: [
      for (final p in piezasBrujula) _FilaPieza(p, obtenidas.contains(p.mundo)),
    ]);
    return Scaffold(
      backgroundColor: const Color(0xFF0B1A33),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, box) {
          final horizontal = box.maxWidth > 760;
          final mensaje = Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFFFB300), width: 2)),
            child: Text(
              completa
                  ? '🎉 ¡Reconstruiste la Brújula de la Ciencia! Gracias a ti, Zati puede volver a descubrir los secretos del mundo.'
                  : 'Zati: “La brújula se rompió y sus 6 piezas quedaron en los 6 mundos. Termina el laboratorio final de cada mundo para recuperar su pieza.” '
                      'Llevas ${obtenidas.length} de 6.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Fredoka', fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF4E342E)),
            ),
          );
          return ListView(padding: const EdgeInsets.fromLTRB(12, 8, 12, 24), children: [
            Row(children: [
              IconButton.filled(
                tooltip: 'Volver',
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF12304A)),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
              const Expanded(
                child: Text('🧭 Brújula de la Ciencia',
                    textAlign: TextAlign.center, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 26, color: Color(0xFFFFE082))),
              ),
              const SizedBox(width: 48),
            ]),
            const SizedBox(height: 10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: horizontal
                  ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Expanded(child: Column(children: [brujula, const SizedBox(height: 10), mensaje])),
                      const SizedBox(width: 16),
                      Expanded(child: lista),
                    ])
                  : Column(children: [brujula, const SizedBox(height: 10), mensaje, const SizedBox(height: 10), lista]),
            ),
          ]);
        }),
      ),
    );
  }
}

class _FilaPieza extends StatelessWidget {
  const _FilaPieza(this.p, this.tiene);
  final PiezaBrujula p;
  final bool tiene;
  @override
  Widget build(BuildContext context) {
    final color = colorPieza(p.mundo);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: tiene ? Color.lerp(color, Colors.white, 0.85) : const Color(0xFF1B2A47),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tiene ? color : Colors.white24, width: 2),
      ),
      child: Row(children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: tiene ? color : Colors.white10, shape: BoxShape.circle),
          child: Text(tiene ? p.emoji : '?', style: const TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'LilitaOne')),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.nombre, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 17, color: tiene ? Color.lerp(color, Colors.black, 0.5) : Colors.white)),
            Text(tiene ? '✔ Recuperada en el mundo de ${p.nombreMundo}' : 'Mundo de ${p.nombreMundo}: termina el ${p.laboratorio}',
                style: TextStyle(fontFamily: 'Fredoka', fontSize: 13, fontWeight: FontWeight.w600, color: tiene ? const Color(0xFF2E7D32) : Colors.white70)),
          ]),
        ),
      ]),
    );
  }
}

/// Celebración que aparece sobre cualquier pantalla al recuperar una pieza.
class CelebracionPieza extends StatefulWidget {
  const CelebracionPieza({super.key});
  @override
  State<CelebracionPieza> createState() => CelebracionPiezaState();
}

class CelebracionPiezaState extends State<CelebracionPieza> with TickerProviderStateMixin {
  late final AnimationController _llegada = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
  late final AnimationController _giro = AnimationController(vsync: this, duration: const Duration(seconds: 3));
  String? _mundo;

  @override
  void initState() {
    super.initState();
    store.piezaNueva.addListener(_cambio);
    _cambio();
  }

  void _cambio() {
    final m = store.piezaNueva.value;
    if (m == null || m == _mundo) return;
    setState(() => _mundo = m);
    _llegada.forward(from: 0);
    if (store.piezas.length == piezasBrujula.length) _giro.repeat();
  }

  void cerrar() {
    _giro.stop();
    setState(() => _mundo = null);
    store.piezaNueva.value = null;
  }

  @override
  void dispose() {
    store.piezaNueva.removeListener(_cambio);
    _llegada.dispose();
    _giro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mundo = _mundo;
    if (mundo == null) return const SizedBox.shrink();
    final p = piezaDelMundo(mundo);
    final obtenidas = store.piezas;
    final completa = obtenidas.length == piezasBrujula.length;
    return Positioned.fill(
      child: Material(
        color: const Color(0xDD07122A),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(completa ? '🎉 ¡Brújula reconstruida! 🎉' : '✨ ¡Encontraste una pieza! ✨',
                      textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 28, color: Color(0xFFFFE082))),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (_, box) => AnimatedBuilder(
                      animation: Listenable.merge([_llegada, _giro]),
                      builder: (_, __) => BrujulaCiencia(
                        obtenidas: obtenidas.difference({mundo}),
                        nueva: mundo,
                        llegada: _llegada.value,
                        giro: _giro.value * 2 * math.pi,
                        tam: math.min(240, box.maxWidth),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(18), border: Border.all(color: colorPieza(mundo), width: 3)),
                    child: Text(
                      completa
                          ? '¡Recuperaste la ${p.nombre} ${p.emoji} y reconstruiste la Brújula de la Ciencia! Gracias a ti, Zati puede volver a descubrir los secretos del mundo.'
                          : 'Recuperaste la ${p.nombre} ${p.emoji} en el mundo de ${p.nombreMundo}. Llevas ${obtenidas.length} de 6 piezas de la Brújula de la Ciencia. ¡Sigue explorando los demás mundos!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontFamily: 'Fredoka', fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF4E342E)),
                    ),
                  ),
                  const SizedBox(height: 14),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB300),
                      foregroundColor: const Color(0xFF3E2723),
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                      textStyle: const TextStyle(fontFamily: 'LilitaOne', fontSize: 20),
                    ),
                    onPressed: cerrar,
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text('¡Seguir explorando!'),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
