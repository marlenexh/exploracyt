import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import '../game_widgets.dart';
import 'explora_profesiones_screen.dart';
import 'fondo_vocacion.dart';
import 'mis_descubrimientos_screen.dart';
import 'personas_transforman_screen.dart';
import 'test_intereses_screen.dart';

class OpcionVocacion {
  const OpcionVocacion({required this.titulo, required this.descripcion, required this.emoji, required this.colores, required this.pantalla});
  final String titulo, descripcion, emoji;
  final List<Color> colores;
  final WidgetBuilder pantalla;
}

/// Vocación: el camino al futuro.
class VocacionScreen extends StatefulWidget {
  const VocacionScreen({super.key});

  static final List<OpcionVocacion> opciones = [
    OpcionVocacion(
      titulo: 'Descubre tus intereses',
      descripcion: 'Responde preguntas divertidas y descubre qué áreas de la ciencia van contigo.',
      emoji: '🧭',
      colores: const [Color(0xFF536DFE), Color(0xFF283593)],
      pantalla: (_) => const TestInteresesScreen(),
    ),
    OpcionVocacion(
      titulo: 'Explora profesiones',
      descripcion: 'Conoce 31 carreras de ciencia y tecnología, con imágenes animadas: qué hacen, sus herramientas y un día de trabajo.',
      emoji: '💼',
      colores: const [Color(0xFFFF9E40), Color(0xFFD84315)],
      pantalla: (_) => const ExploraProfesionesScreen(),
    ),
    OpcionVocacion(
      titulo: 'Personas que transforman el mundo',
      descripcion: 'Visita el museo: científicas, inventores, programadoras y exploradores que cambiaron la historia.',
      emoji: '🏛️',
      colores: const [Color(0xFF43C67A), Color(0xFF1B6E43)],
      pantalla: (_) => const PersonasTransformanScreen(),
    ),
    OpcionVocacion(
      titulo: 'Mis descubrimientos',
      descripcion: 'Mira tus intereses, tus profesiones favoritas, las personas que conociste y tus insignias.',
      emoji: '🏆',
      colores: const [Color(0xFFFFCA28), Color(0xFFB8860B)],
      pantalla: (_) => const MisDescubrimientosScreen(),
    ),
  ];

  @override
  State<VocacionScreen> createState() => _VocacionScreenState();
}

class _VocacionScreenState extends State<VocacionScreen> {
  bool test = false;
  int favoritas = 0, personas = 0;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      test = p.getString('resultado_test_intereses') != null;
      favoritas = (p.getStringList(ExploraProfesionesScreen.claveFavoritas) ?? []).length;
      personas = (p.getStringList('personas_visitadas') ?? []).length;
    });
  }

  Future<void> _abrir(OpcionVocacion o) async {
    await Navigator.push(context, MaterialPageRoute(builder: o.pantalla));
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FondoVocacion(),
          SafeArea(
            child: LayoutBuilder(builder: (context, constraints) {
              final ancho = constraints.maxWidth > 700;
              return SingleChildScrollView(
                padding: EdgeInsets.all(ancho ? 22 : 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Column(children: [
                      Row(children: [
                        IconButton.filled(
                          tooltip: 'Volver',
                          style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF3B1F6E)),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(children: [
                              Text('VOCACIÓN',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black54, blurRadius: 6)])),
                              Text('El camino al futuro', style: TextStyle(color: Color(0xFFFFE082), fontSize: 15, fontWeight: FontWeight.w800)),
                            ]),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ]),
                      const SizedBox(height: 10),
                      _bienvenida(ancho),
                      const SizedBox(height: 12),
                      _progreso(),
                      const SizedBox(height: 16),
                      const Text('¿Qué quieres descubrir hoy?',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black54, blurRadius: 6)])),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: VocacionScreen.opciones.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: ancho ? 2 : 1,
                          mainAxisExtent: ancho ? 170 : 176,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemBuilder: (context, i) => _Portal(opcion: VocacionScreen.opciones[i], indice: i, onTap: () => _abrir(VocacionScreen.opciones[i])),
                      ),
                      const SizedBox(height: 16),
                      const Text('✨ ¡No hay una sola manera de construir tu futuro! ✨',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black54, blurRadius: 5)])),
                    ]),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _bienvenida(bool ancho) => Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Reloj(builder: (_, t) => Transform.translate(offset: Offset(0, math.sin(t * 2) * 4), child: Zati(size: ancho ? 120 : 92))),
        const SizedBox(width: 8),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (_, v, hijo) =>
                Transform.scale(scale: 0.8 + 0.2 * v, alignment: Alignment.bottomLeft, child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(22), topRight: Radius.circular(22), bottomRight: Radius.circular(22), bottomLeft: Radius.circular(4)),
                boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('¡Explora tu futuro!', style: TextStyle(color: Color(0xFF3B1F6E), fontSize: 24, fontFamily: 'LilitaOne')),
                SizedBox(height: 4),
                Text(
                  'La ciencia y la tecnología tienen muchísimos caminos. Descubre qué te gusta, conoce profesiones increíbles y visita el museo de las personas que cambiaron el mundo.',
                  style: TextStyle(color: Color(0xFF26215C), fontSize: 15, fontWeight: FontWeight.w600, height: 1.25),
                ),
              ]),
            ),
          ),
        ),
      ]);

  Widget _progreso() {
    Widget dato(String emoji, String texto, bool hecho) => Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              color: hecho ? const Color(0xFFFFF8E1) : Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: hecho ? const Color(0xFFFFCA28) : Colors.white54, width: 2),
            ),
            child: Column(children: [
              Text(hecho ? emoji : '🔒', style: const TextStyle(fontSize: 22)),
              Text(texto,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: hecho ? const Color(0xFF5D4037) : Colors.white)),
            ]),
          ),
        );
    return Row(children: [
      dato('🧭', test ? 'Test hecho' : 'Haz el test', test),
      const SizedBox(width: 8),
      dato('💼', '$favoritas favoritas', favoritas > 0),
      const SizedBox(width: 8),
      dato('🏛️', '$personas personas', personas > 0),
    ]);
  }
}

/// Tarjeta-portal animada de cada sección.
class _Portal extends StatefulWidget {
  const _Portal({required this.opcion, required this.indice, required this.onTap});
  final OpcionVocacion opcion;
  final int indice;
  final VoidCallback onTap;
  @override
  State<_Portal> createState() => _PortalState();
}

class _PortalState extends State<_Portal> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.opcion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + widget.indice * 180),
      curve: Curves.easeOutCubic,
      builder: (_, v, hijo) => Transform.translate(offset: Offset(0, (1 - v) * 60), child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
      child: Tooltip(
        message: o.titulo,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _presionado = true),
          onTapCancel: () => setState(() => _presionado = false),
          onTapUp: (_) => setState(() => _presionado = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _presionado ? 0.95 : 1,
            duration: const Duration(milliseconds: 120),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: o.colores),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: o.colores.last.withValues(alpha: 0.6), blurRadius: 14, offset: const Offset(0, 6))],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(children: [
                // Destellos
                Positioned.fill(
                  child: Reloj(
                    builder: (_, t) => CustomPaint(painter: _Destellos(t + widget.indice)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(children: [
                    SizedBox(
                      width: 104,
                      height: 104,
                      child: Reloj(
                        builder: (_, t) => Stack(alignment: Alignment.center, children: [
                          Transform.rotate(
                            angle: t * 0.8,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white54, width: 3, strokeAlign: BorderSide.strokeAlignInside),
                                gradient: const SweepGradient(colors: [Color(0x00FFFFFF), Color(0x66FFFFFF), Color(0x00FFFFFF)]),
                              ),
                            ),
                          ),
                          Container(
                            width: 78,
                            height: 78,
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          ),
                          Transform.translate(
                            offset: Offset(0, math.sin(t * 2.4 + widget.indice) * 4),
                            child: Text(o.emoji, style: const TextStyle(fontSize: 44)),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(o.titulo,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontFamily: 'LilitaOne',
                                height: 1.05,
                                shadows: [Shadow(color: Colors.black38, blurRadius: 4)])),
                        const SizedBox(height: 6),
                        Flexible(
                            child: Text(o.descripcion,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 13.5, fontWeight: FontWeight.w600, height: 1.2))),
                      ]),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
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

class _Destellos extends CustomPainter {
  _Destellos(this.t);
  final double t;
  @override
  void paint(Canvas c, Size s) {
    for (var k = 0; k < 7; k++) {
      final f = (t * 0.12 + k / 7) % 1;
      final p = Offset(s.width * ((k * 0.29 + 0.1) % 1), s.height * (1 - f));
      c.drawCircle(p, 2 + (k % 3).toDouble(), Paint()..color = Colors.white.withValues(alpha: 0.35 * math.sin(f * math.pi)));
    }
  }

  @override
  bool shouldRepaint(_Destellos old) => old.t != t;
}
