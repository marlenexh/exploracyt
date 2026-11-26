import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import 'personajes_datos.dart';

const _claveVisitadas = 'personas_visitadas';

/// Museo “Personas que transforman el mundo”.
class PersonasTransformanScreen extends StatefulWidget {
  const PersonasTransformanScreen({super.key});
  @override
  State<PersonasTransformanScreen> createState() => PersonasTransformanScreenState();
}

class PersonasTransformanScreenState extends State<PersonasTransformanScreen> {
  Set<String> visitadas = {};
  String? sala;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => visitadas = (p.getStringList(_claveVisitadas) ?? []).toSet());
  }

  void elegirSala(String? s) => setState(() => sala = s);

  Future<void> abrir(PersonajeInfo p) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => DetallePersonajeScreen(personaje: p),
        transitionsBuilder: (_, a, __, h) => FadeTransition(opacity: a, child: h),
      ),
    );
    _cargar();
  }

  Future<void> jugar() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const QuienSoyScreen()));
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final salas = sala == null ? salasMuseo : salasMuseo.where((s) => s.$1 == sala).toList();
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoMuseo(),
        SafeArea(
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
                child: Column(children: [
                  Row(children: [
                    IconButton.filled(
                      tooltip: 'Volver',
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(children: [
                          Text('🏛️ MUSEO',
                              style: TextStyle(
                                  color: Color(0xFFFFE082), fontSize: 26, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 6)])),
                          Text('Personas que transforman el mundo',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                        ]),
                      ),
                    ),
                    _boleto(),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ListView(scrollDirection: Axis.horizontal, children: [
                          _chipSala(null, '🏛️', 'Todas las salas', const Color(0xFF8D6E63)),
                          for (final s in salasMuseo) _chipSala(s.$1, s.$2, s.$1, s.$3),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Juego ¿Quién soy?',
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFB300), foregroundColor: const Color(0xFF3E2723)),
                        onPressed: jugar,
                        icon: const Text('🎲', style: TextStyle(fontSize: 18)),
                        label: const Text('¿Quién soy?', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
            for (final s in salas) ...[
              SliverToBoxAdapter(child: _letreroSala(s)),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 292,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    children: [
                      for (final (i, p) in personajes.where((p) => p.sala == s.$1).indexed)
                        _Retrato(key: ValueKey(p.nombre), personaje: p, indice: i, visitado: visitadas.contains(p.nombre), onTap: () => abrir(p)),
                    ],
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ]),
        ),
      ]),
    );
  }

  Widget _boleto() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFB8860B), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
        ),
        child: Column(children: [
          const Text('🎟️', style: TextStyle(fontSize: 18)),
          Text('${visitadas.length}/${personajes.length}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF5D4037))),
        ]),
      );

  Widget _chipSala(String? valor, String emoji, String texto, Color color) {
    final activo = sala == valor;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tooltip(
        message: 'Sala $texto',
        child: GestureDetector(
          onTap: () => elegirSala(valor),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: activo ? color : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFB8860B), width: 2),
            ),
            child: Text('$emoji $texto', style: TextStyle(fontWeight: FontWeight.w900, color: activo ? Colors.white : const Color(0xFF5D4037))),
          ),
        ),
      ),
    );
  }

  Widget _letreroSala((String, String, Color) s) {
    final total = personajes.where((p) => p.sala == s.$1).length;
    final vistos = personajes.where((p) => p.sala == s.$1 && visitadas.contains(p.nombre)).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      child: Row(children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFC9A227), Color(0xFFFFE082)]),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('${s.$2} Sala de ${s.$1}', style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 18, color: Color(0xFF3E2723))),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('$vistos de $total',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
      ]),
    );
  }
}

/// Retrato enmarcado con foco de luz y placa.
class _Retrato extends StatefulWidget {
  const _Retrato({super.key, required this.personaje, required this.indice, required this.visitado, required this.onTap});
  final PersonajeInfo personaje;
  final int indice;
  final bool visitado;
  final VoidCallback onTap;
  @override
  State<_Retrato> createState() => _RetratoState();
}

class _RetratoState extends State<_Retrato> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.personaje;
    final c = colorSala(p.sala);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + widget.indice * 150),
      curve: Curves.easeOutBack,
      builder: (_, v, h) => Transform.translate(offset: Offset(0, (1 - v) * 50), child: Opacity(opacity: v.clamp(0.0, 1.0), child: h)),
      child: Tooltip(
        message: p.nombre,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _presionado = true),
          onTapCancel: () => setState(() => _presionado = false),
          onTapUp: (_) => setState(() => _presionado = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _presionado ? 0.95 : 1,
            duration: const Duration(milliseconds: 120),
            child: SizedBox(
              width: 178,
              child: Column(children: [
                // Foco de luz
                Reloj(
                  builder: (_, t) => CustomPaint(
                    size: const Size(178, 26),
                    painter: _Foco(0.75 + 0.25 * (math.sin(t * 1.5 + widget.indice) * 0.5 + 0.5)),
                  ),
                ),
                // Marco dorado
                Container(
                  width: 150,
                  height: 172,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFE082), Color(0xFFB8860B), Color(0xFFFFD54F), Color(0xFF8D6E1E)]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [BoxShadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 8))],
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [Color.lerp(c, Colors.white, 0.55)!, Color.lerp(c, Colors.black, 0.2)!]),
                      border: Border.all(color: const Color(0xFF5D4037), width: 2),
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Reloj(
                          builder: (_, t) => Transform.translate(
                              offset: Offset(0, math.sin(t * 1.8 + widget.indice) * 3), child: Text(p.avatar, style: const TextStyle(fontSize: 66)))),
                      Positioned(right: 4, bottom: 2, child: Text(p.objeto.$1, style: const TextStyle(fontSize: 24))),
                      if (widget.visitado)
                        Positioned(
                          left: 2,
                          top: 4,
                          child: Transform.rotate(
                            angle: -0.3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFFC62828), width: 2), borderRadius: BorderRadius.circular(4), color: Colors.white70),
                              child: const Text('VISITADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
                            ),
                          ),
                        ),
                    ]),
                  ),
                ),
                const SizedBox(height: 10),
                // Placa
                Container(
                  width: 160,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFC9A227), Color(0xFFFFE082), Color(0xFFC9A227)]),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF8D6E1E), width: 1.5),
                  ),
                  child: Column(children: [
                    Text(p.nombre,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF3E2723), height: 1.05)),
                    Text(p.anios, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF5D4037))),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class _Foco extends CustomPainter {
  _Foco(this.brillo);
  final double brillo;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Rect.fromCenter(center: Offset(s.width / 2, 4), width: 40, height: 8), Paint()..color = const Color(0xFF424242));
    final cono = Path()
      ..moveTo(s.width / 2 - 14, 8)
      ..lineTo(s.width / 2 + 14, 8)
      ..lineTo(s.width / 2 + 80, s.height + 40)
      ..lineTo(s.width / 2 - 80, s.height + 40)
      ..close();
    c.drawPath(
        cono,
        Paint()
          ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color.fromRGBO(255, 241, 180, 0.55 * brillo), const Color(0x00FFF1B4)]).createShader(Rect.fromLTWH(0, 0, s.width, s.height + 40)));
  }

  @override
  bool shouldRepaint(_Foco old) => old.brillo != brillo;
}

/// Fondo del museo: pared con molduras, piso de madera y luces del techo.
class FondoMuseo extends StatelessWidget {
  const FondoMuseo({super.key});
  @override
  Widget build(BuildContext context) => const RepaintBoundary(child: CustomPaint(painter: _PintorMuseo(), child: SizedBox.expand()));
}

class _PintorMuseo extends CustomPainter {
  const _PintorMuseo();
  @override
  void paint(Canvas c, Size s) {
    final piso = s.height * 0.86;
    c.drawRect(
        Rect.fromLTWH(0, 0, s.width, piso),
        Paint()
          ..shader =
              const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF3E1010), Color(0xFF6D1F1F), Color(0xFF5A1818)])
                  .createShader(Rect.fromLTWH(0, 0, s.width, piso)));
    // Techo con molduras y lámparas
    c.drawRect(Rect.fromLTWH(0, 0, s.width, 18), Paint()..color = const Color(0xFF2A0A0A));
    c.drawRect(Rect.fromLTWH(0, 18, s.width, 4), Paint()..color = const Color(0xFFC9A227));
    for (var x = 60.0; x < s.width; x += 180) {
      c.drawCircle(
          Offset(x, 26),
          24,
          Paint()
            ..shader = RadialGradient(colors: const [Color(0x55FFE082), Color(0x00FFE082)]).createShader(Rect.fromCircle(center: Offset(x, 26), radius: 24)));
    }
    // Paneles de la pared
    final moldura = Paint()
      ..color = const Color(0x44FFE082)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var x = 20.0; x < s.width - 40; x += 200) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, 70, 170, piso - 150), const Radius.circular(6)), moldura);
    }
    // Zoclo
    c.drawRect(Rect.fromLTWH(0, piso - 40, s.width, 40), Paint()..color = const Color(0xFF3E1010));
    c.drawRect(Rect.fromLTWH(0, piso - 42, s.width, 4), Paint()..color = const Color(0xFFC9A227));
    // Piso de madera
    c.drawRect(Rect.fromLTWH(0, piso, s.width, s.height - piso), Paint()..color = const Color(0xFF8D5A2B));
    final tabla = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1.5;
    for (var y = piso + 14.0; y < s.height; y += 14) {
      c.drawLine(Offset(0, y), Offset(s.width, y), tabla);
    }
    for (var x = 0.0; x < s.width; x += 90) {
      c.drawLine(Offset(x, piso), Offset(x - 30, s.height), tabla);
    }
    // Alfombra roja
    c.drawRect(Rect.fromLTWH(s.width * 0.3, piso, s.width * 0.4, s.height - piso), Paint()..color = const Color(0xAA8E1B1B));
  }

  @override
  bool shouldRepaint(_PintorMuseo old) => false;
}

// ===========================================================================
// La vitrina de cada persona
// ===========================================================================

class DetallePersonajeScreen extends StatefulWidget {
  const DetallePersonajeScreen({super.key, required this.personaje});
  final PersonajeInfo personaje;
  @override
  State<DetallePersonajeScreen> createState() => DetallePersonajeScreenState();
}

class DetallePersonajeScreenState extends State<DetallePersonajeScreen> {
  bool volteada = false;
  bool sello = false;

  PersonajeInfo get p => widget.personaje;

  @override
  void initState() {
    super.initState();
    _visitar();
  }

  Future<void> _visitar() async {
    final pref = await SharedPreferences.getInstance();
    final lista = (pref.getStringList(_claveVisitadas) ?? []).toSet();
    final nueva = lista.add(p.nombre);
    await pref.setStringList(_claveVisitadas, lista.toList());
    if (nueva && mounted) {
      setState(() => sello = true);
      Timer(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => sello = false);
      });
    }
  }

  void voltear() => setState(() => volteada = !volteada);

  @override
  Widget build(BuildContext context) {
    final c = colorSala(p.sala);
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoMuseo(),
        Container(color: Colors.black.withValues(alpha: 0.35)),
        SafeArea(
          child: LayoutBuilder(builder: (context, cons) {
            final ancho = cons.maxWidth > 760;
            final retrato = _retratoGrande(c);
            final info = Column(children: [
              _tarjeta('🏆', 'Su gran aporte', c, Row(children: [Expanded(child: Text(p.aporte, style: _texto)), const SizedBox(width: 10), _vitrina()])),
              const SizedBox(height: 10),
              _tarjeta('📜', 'Línea del tiempo', c, _lineaTiempo(c)),
              const SizedBox(height: 10),
              _sabiasQue(),
              const SizedBox(height: 10),
              _tarjeta('🌟', 'Lo que nos enseña', c, Text(p.ensenanza, style: _texto)),
            ]);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(children: [
                    Row(children: [
                      IconButton.filled(
                        tooltip: 'Volver al museo',
                        style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text('${emojiSala(p.sala)} Sala de ${p.sala}',
                            style: const TextStyle(
                                color: Color(0xFFFFE082), fontSize: 18, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                      ),
                    ]),
                    const SizedBox(height: 10),
                    if (ancho)
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [SizedBox(width: 330, child: retrato), const SizedBox(width: 16), Expanded(child: info)])
                    else
                      Column(children: [retrato, const SizedBox(height: 12), info]),
                  ]),
                ),
              ),
            );
          }),
        ),
        if (sello)
          IgnorePointer(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 2.5, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (_, v, h) => Transform.scale(scale: v, child: Transform.rotate(angle: -0.25, child: h)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      border: Border.all(color: const Color(0xFFC62828), width: 5),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Text('🎟️ ¡SELLO DE VISITANTE!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  static const _texto = TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, height: 1.3, color: Color(0xFF3E2723));

  Widget _retratoGrande(Color c) => Column(children: [
        Reloj(
          builder: (_, t) => Transform.rotate(
            angle: math.sin(t * 0.8) * 0.015,
            alignment: Alignment.topCenter,
            child: Container(
              width: 300,
              height: 340,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFE082), Color(0xFFB8860B), Color(0xFFFFD54F), Color(0xFF8D6E1E)]),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black, blurRadius: 20, offset: const Offset(0, 10)),
                  BoxShadow(color: const Color(0x66FFE082), blurRadius: 40 + 10 * math.sin(t))
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [Color.lerp(c, Colors.white, 0.6)!, Color.lerp(c, Colors.black, 0.25)!]),
                  border: Border.all(color: const Color(0xFF5D4037), width: 3),
                ),
                child: Stack(alignment: Alignment.center, children: [
                  Transform.translate(offset: Offset(0, math.sin(t * 1.6) * 5), child: Text(p.avatar, style: const TextStyle(fontSize: 140))),
                  Positioned(bottom: 8, right: 10, child: Text(p.objeto.$1, style: const TextStyle(fontSize: 44))),
                ]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 300,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFC9A227), Color(0xFFFFE082), Color(0xFFC9A227)]),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF8D6E1E), width: 2),
          ),
          child: Column(children: [
            Text(p.nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontFamily: 'LilitaOne', color: Color(0xFF3E2723))),
            Text('${p.pais} · ${p.anios}',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
          ]),
        ),
      ]);

  Widget _tarjeta(String emoji, String titulo, Color c, Widget hijo) => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (_, v, h) => Transform.translate(offset: Offset((1 - v) * 60, 0), child: Opacity(opacity: v.clamp(0.0, 1.0), child: h)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBF0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFC9A227), width: 3),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$emoji $titulo', style: TextStyle(fontSize: 19, fontFamily: 'LilitaOne', color: Color.lerp(c, Colors.black, 0.3))),
            const SizedBox(height: 6),
            DefaultTextStyle.merge(style: const TextStyle(color: Color(0xFF3E2723), fontSize: 15), child: hijo),
          ]),
        ),
      );

  /// Vitrina de vidrio con el objeto girando sobre un pedestal.
  Widget _vitrina() => SizedBox(
        width: 110,
        child: Column(children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x55B3E5FC), Color(0x22FFFFFF)]),
              border: Border.all(color: const Color(0xAA90A4AE), width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Reloj(
              builder: (_, t) => Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(t * 1.2),
                  child: Text(p.objeto.$1, style: const TextStyle(fontSize: 52)),
                ),
              ),
            ),
          ),
          Container(width: 110, height: 14, decoration: BoxDecoration(color: const Color(0xFF5D4037), borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 4),
          Text(p.objeto.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
        ]),
      );

  Widget _lineaTiempo(Color c) => Column(children: [
        for (var i = 0; i < p.historia.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + i * 450),
            curve: Curves.easeOutBack,
            builder: (_, v, h) => Opacity(opacity: v.clamp(0.0, 1.0), child: Transform.scale(scale: 0.8 + 0.2 * v, alignment: Alignment.centerLeft, child: h)),
            child: IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(
                  width: 30,
                  child: Column(children: [
                    Container(
                        width: 18, height: 18, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3))),
                    if (i < p.historia.length - 1) Expanded(child: Container(width: 3, color: c.withValues(alpha: 0.5))),
                  ]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: '${p.historia[i].$1}  ', style: TextStyle(fontWeight: FontWeight.w900, color: c, fontSize: 15)),
                      TextSpan(text: p.historia[i].$2),
                    ])),
                  ),
                ),
              ]),
            ),
          ),
      ]);

  Widget _sabiasQue() => Tooltip(
        message: 'Voltear dato curioso',
        child: GestureDetector(
          onTap: voltear,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: volteada ? math.pi : 0),
            duration: const Duration(milliseconds: 500),
            builder: (_, a, __) {
              final frente = a < math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(a),
                child: Container(
                  width: double.infinity,
                  height: 110,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: frente ? const [Color(0xFFFFCA28), Color(0xFFFF8F00)] : const [Color(0xFFFFF8E1), Color(0xFFFFECB3)]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFC9A227), width: 3),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationX(frente ? 0 : math.pi),
                    child: frente
                        ? const Text('💡 ¿Sabías que…? Toca para descubrirlo',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 19, fontFamily: 'LilitaOne', color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 3)]))
                        : Text(p.dato,
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

// ===========================================================================
// Juego ¿Quién soy?
// ===========================================================================

class PreguntaQuienSoy {
  const PreguntaQuienSoy(this.correcta, this.opciones);
  final PersonajeInfo correcta;
  final List<PersonajeInfo> opciones;
}

/// Arma [n] preguntas con 3 opciones cada una.
List<PreguntaQuienSoy> armarQuienSoy(math.Random rnd, {int n = 5}) {
  final orden = [...personajes]..shuffle(rnd);
  return [
    for (final p in orden.take(n))
      PreguntaQuienSoy(
          p,
          ([
            p,
            ...([...personajes.where((x) => x != p)]..shuffle(rnd)).take(2)
          ])
            ..shuffle(rnd)),
  ];
}

class QuienSoyScreen extends StatefulWidget {
  const QuienSoyScreen({super.key, this.semilla});
  final int? semilla;
  @override
  State<QuienSoyScreen> createState() => QuienSoyScreenState();
}

class QuienSoyScreenState extends State<QuienSoyScreen> {
  late final preguntas = armarQuienSoy(math.Random(widget.semilla));
  int actual = 0, aciertos = 0;
  PersonajeInfo? elegido;

  bool get terminado => actual >= preguntas.length;

  void elegir(PersonajeInfo p) {
    if (elegido != null || terminado) return;
    setState(() {
      elegido = p;
      if (p == preguntas[actual].correcta) aciertos++;
    });
  }

  void siguiente() => setState(() {
        actual++;
        elegido = null;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoMuseo(),
        Container(color: Colors.black.withValues(alpha: 0.3)),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(children: [
                  Row(children: [
                    IconButton.filled(
                      tooltip: 'Volver al museo',
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('🎲 ¿QUIÉN SOY?',
                            style: TextStyle(
                                color: Color(0xFFFFE082), fontSize: 26, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 6)])),
                      ),
                    ),
                    Text('⭐ $aciertos', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 14),
                  if (terminado) _final() else ..._pregunta(),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  List<Widget> _pregunta() {
    final q = preguntas[actual];
    return [
      Text('Pregunta ${actual + 1} de ${preguntas.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      TweenAnimationBuilder<double>(
        key: ValueKey(actual),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (_, v, h) => Transform.scale(scale: v, child: h),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFC9A227), width: 3)),
          child: Text('🗨️ “${q.correcta.pista}”',
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF3E2723))),
        ),
      ),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 12, children: [
        for (final p in q.opciones)
          Tooltip(
            message: 'Elegir ${p.nombre}',
            child: GestureDetector(
              onTap: () => elegir(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 170,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFB8860B)]),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: elegido == null
                          ? Colors.transparent
                          : (p == q.correcta ? const Color(0xFF43A047) : (p == elegido ? const Color(0xFFE53935) : Colors.transparent)),
                      width: 5),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(children: [
                  Container(
                    height: 110,
                    alignment: Alignment.center,
                    color: Color.lerp(colorSala(p.sala), Colors.white, 0.5),
                    child: Text(p.avatar, style: const TextStyle(fontSize: 64)),
                  ),
                  const SizedBox(height: 6),
                  Text(p.nombre, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF3E2723))),
                ]),
              ),
            ),
          ),
      ]),
      const SizedBox(height: 14),
      if (elegido != null) ...[
        Text(elegido == q.correcta ? '¡Correcto! Es ${q.correcta.nombre}. ${q.correcta.aporte}' : '¡Casi! Era ${q.correcta.nombre}. ${q.correcta.aporte}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
        const SizedBox(height: 8),
        Tooltip(
          message: 'Siguiente pregunta',
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFB300), foregroundColor: const Color(0xFF3E2723)),
            onPressed: siguiente,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Siguiente', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    ];
  }

  Widget _final() => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        builder: (_, v, h) => Transform.scale(scale: v, child: h),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFC9A227), width: 4)),
          child: Column(children: [
            Text(aciertos == preguntas.length ? '🏆' : (aciertos >= 3 ? '🥈' : '📚'), style: const TextStyle(fontSize: 70)),
            Text('¡Acertaste $aciertos de ${preguntas.length}!', style: const TextStyle(fontSize: 26, fontFamily: 'LilitaOne', color: Color(0xFF3E2723))),
            const SizedBox(height: 6),
            Text(aciertos == preguntas.length ? '¡Eres guía experto del museo!' : 'Visita las salas del museo para conocer a más personas y vuelve a jugar.',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Volver al museo')),
          ]),
        ),
      );
}
