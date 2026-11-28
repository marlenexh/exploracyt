import 'dart:math' as math;

import 'package:flame/components.dart';
export 'package:flame/components.dart' show Component, PositionComponent, Sprite, Vector2;
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';

/// Base de los mini-juegos de acción hechos con Flame (el motor de juegos 2D
/// de Flutter). La lógica de cada juego vive en un *modelo* (Dart puro, fácil
/// de probar) y Flame se encarga del ciclo de juego (60 cuadros por segundo),
/// los componentes que se dibujan, las partículas y los efectos.

/// Tamaño del área de juego (en el lienzo de 860 × 480 del juego).
const anchoJuego = 608.0, altoJuego = 350.0;

/// Algo que pasó en el juego y que se muestra con un efecto (chispas y texto).
class EfectoJuego {
  const EfectoJuego(this.pos, this.color, [this.texto]);
  final Offset pos;
  final Color color;
  final String? texto;
}

/// Lógica común de un mini-juego.
abstract class ModeloJuego extends ChangeNotifier {
  bool jugando = false, terminado = false, gano = false;
  int puntos = 0, errores = 0;
  final efectos = <EfectoJuego>[];
  final azar = math.Random(7);

  /// Reinicia el estado del juego (antes de cada partida).
  void reiniciar();

  /// Avanza la simulación [dt] segundos (solo mientras se juega).
  void paso(double dt);

  /// Texto de Zati en este momento.
  String get mensaje;

  /// Marcador (puntos, vidas…).
  String get marcador;
  int get estrellas;

  void empezar() {
    puntos = 0;
    errores = 0;
    terminado = gano = false;
    efectos.clear();
    reiniciar();
    jugando = true;
    notifyListeners();
  }

  void terminar(bool gane) {
    jugando = false;
    terminado = true;
    gano = gane;
    notifyListeners();
  }

  void efecto(Offset pos, Color color, [String? texto]) => efectos.add(EfectoJuego(pos, color, texto));

  /// Avanza el juego (lo llama Flame en cada cuadro; las pruebas lo llaman a mano).
  void avanzar(double dt) {
    if (jugando) paso(math.min(dt, 0.05));
  }
}

/// Juego de Flame común: fondo transparente (se ve el fondo del mundo),
/// actualiza el modelo y convierte sus efectos en partículas y textos.
class JuegoFlame<M extends ModeloJuego> extends FlameGame {
  JuegoFlame(this.m, this.capas);
  final M m;

  /// Componentes que dibujan el juego (fondo, personajes…), en orden.
  final List<Component> Function(M m) capas;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    await addAll(capas(m));
  }

  @override
  void update(double dt) {
    m.avanzar(dt);
    for (final e in m.efectos) {
      _chispas(e);
    }
    m.efectos.clear();
    super.update(dt);
  }

  void _chispas(EfectoJuego e) {
    final r = math.Random();
    add(ParticleSystemComponent(
      position: Vector2(e.pos.dx, e.pos.dy),
      priority: 50,
      particle: Particle.generate(
        count: 14,
        lifespan: 0.6,
        generator: (_) => AcceleratedParticle(
          speed: Vector2(r.nextDouble() * 220 - 110, r.nextDouble() * -200),
          acceleration: Vector2(0, 360),
          child: CircleParticle(radius: 2 + r.nextDouble() * 2.5, paint: Paint()..color = e.color),
        ),
      ),
    ));
    if (e.texto != null) {
      add(TextComponent(
        text: e.texto!,
        position: Vector2(e.pos.dx, e.pos.dy - 10),
        anchor: Anchor.center,
        priority: 60,
        textRenderer: TextPaint(
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white, shadows: [Shadow(color: e.color, blurRadius: 6)]),
        ),
      )..addAll([
          MoveEffect.by(Vector2(0, -36), EffectController(duration: 0.9)),
          RemoveEffect(delay: 0.9),
        ]));
    }
  }
}

/// Un componente de Flame que dibuja con una función (para capas sencillas).
class CapaJuego extends Component {
  CapaJuego(this.dibujo, {super.priority});
  final void Function(Canvas c) dibujo;
  @override
  void render(Canvas canvas) => dibujo(canvas);
}

/// Un personaje u objeto del juego: Flame lo coloca y lo dibuja cada cuadro.
class ActorJuego extends PositionComponent {
  ActorJuego(this.posicion, this.dibujo, {super.priority});

  /// Lee la posición actual desde el modelo.
  final Offset? Function() posicion;
  final void Function(Canvas c) dibujo;
  bool _visible = true;

  @override
  void update(double dt) {
    final p = posicion();
    _visible = p != null;
    if (p != null) position.setValues(p.dx, p.dy);
  }

  @override
  void renderTree(Canvas canvas) {
    if (_visible) super.renderTree(canvas);
  }

  @override
  void render(Canvas canvas) => dibujo(canvas);
}

void emojiEn(Canvas c, String e, Offset p, double tam) => dibujarEmoji(c, e, p, tam);

void textoJuego(Canvas c, String t, Offset centro, {double tam = 13, Color color = Colors.white, Color? fondo}) {
  final tp = TextPainter(
    text: TextSpan(text: t, style: TextStyle(fontSize: tam, fontWeight: FontWeight.w800, color: color, fontFamily: 'Fredoka')),
    textDirection: TextDirection.ltr,
  )..layout();
  final caja = Rect.fromCenter(center: centro, width: tp.width + 12, height: tp.height + 4);
  if (fondo != null) c.drawRRect(RRect.fromRectAndRadius(caja, const Radius.circular(8)), Paint()..color = fondo);
  tp.paint(c, centro - Offset(tp.width / 2, tp.height / 2));
}

/// Pantalla de un mini-juego: fondo del mundo, Zati, marcador, el juego de
/// Flame y los controles. Al ganar, entrega las estrellas del paso.
class PantallaMiniJuego<M extends ModeloJuego> extends StatefulWidget {
  const PantallaMiniJuego({
    super.key,
    required this.actividad,
    required this.titulo,
    required this.color,
    required this.crearModelo,
    required this.capas,
    required this.aprendizaje,
    this.seccion = 'Mini-juego',
    this.controles,
    this.alTocar,
    this.alArrastrar,
    this.alSoltar,
    this.onTerminar,
  });
  final String actividad, titulo, seccion;
  final Color color;
  final M Function() crearModelo;
  final List<Component> Function(M m) capas;

  /// Lo que se aprende (se muestra en el marcador y al terminar).
  final String aprendizaje;
  final Widget Function(BuildContext context, M m)? controles;
  final void Function(M m, Offset p)? alTocar, alArrastrar;
  final void Function(M m)? alSoltar;

  /// Si no es null, se llama al terminar en lugar de entregar estrellas del paso.
  final void Function(M m)? onTerminar;

  @override
  State<PantallaMiniJuego<M>> createState() => PantallaMiniJuegoState<M>();
}

class PantallaMiniJuegoState<M extends ModeloJuego> extends State<PantallaMiniJuego<M>> {
  late final M modelo = widget.crearModelo();
  late final JuegoFlame<M> juego = JuegoFlame<M>(modelo, widget.capas);
  bool _entregado = false;

  void jugar() {
    HapticFeedback.lightImpact();
    modelo.empezar();
  }

  void terminar() {
    if (_entregado) return;
    _entregado = true;
    if (widget.onTerminar != null) {
      widget.onTerminar!(modelo);
      return;
    }
    terminarPaso(context, actividad: widget.actividad, estrellas: modelo.estrellas, titulo: '¡${widget.titulo}!', mensaje: widget.aprendizaje);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: modelo,
        builder: (context, _) {
          final m = modelo;
          return Escenario(
            velo: 0.06,
            colorVelo: widget.color,
            children: [
              encabezadoEle(widget.seccion, '🎮 ${widget.titulo}', widget.color),
              Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(m.mensaje, tam: 13)),
              Positioned(
                left: 8,
                top: 256,
                width: 230,
                height: 218,
                child: PanelEle(
                  titulo: 'Marcador',
                  icono: Icons.scoreboard_rounded,
                  color: widget.color,
                  child: SingleChildScrollView(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(m.marcador, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, height: 1.35)),
                      const SizedBox(height: 6),
                      Text('💡 ${widget.aprendizaje}', style: const TextStyle(fontSize: 12, height: 1.2)),
                    ]),
                  ),
                ),
              ),
              Positioned(
                left: 244,
                top: 60,
                width: anchoJuego,
                height: altoJuego,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(children: [
                    Positioned.fill(child: ColoredBox(color: Colors.black.withValues(alpha: 0.18))),
                    Positioned.fill(child: GameWidget(game: juego)),
                    Positioned.fill(
                      child: GestureDetector(
                        key: const ValueKey('area_minijuego'),
                        behavior: HitTestBehavior.translucent,
                        onTapDown: (d) => widget.alTocar?.call(m, d.localPosition),
                        onPanStart: (d) => widget.alArrastrar?.call(m, d.localPosition),
                        onPanUpdate: (d) => widget.alArrastrar?.call(m, d.localPosition),
                        onPanEnd: (_) => widget.alSoltar?.call(m),
                      ),
                    ),
                    if (!m.jugando && !m.terminado)
                      Center(
                        child: Tooltip(
                          message: '¡Jugar!',
                          child: BotonJuego(texto: '¡Jugar!', icono: Icons.play_arrow_rounded, color: const Color(0xFF2DB84C), onTap: jugar),
                        ),
                      ),
                    if (m.terminado)
                      Center(
                        child: Container(
                          width: 360,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: widget.color, width: 4),
                            boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 12)],
                          ),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [
                            Text(m.gano ? '🏆 ¡Lo lograste!' : '💪 ¡Casi!',
                                style: TextStyle(fontFamily: 'LilitaOne', fontSize: 26, color: oscurecer(widget.color, 0.2))),
                            Text(m.gano ? '⭐' * m.estrellas : 'Inténtalo otra vez: ¡cada intento te hace mejor!',
                                textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 10),
                            Wrap(spacing: 8, runSpacing: 6, alignment: WrapAlignment.center, children: [
                              Tooltip(
                                  message: 'Jugar otra vez',
                                  child: BotonJuego(texto: 'Otra vez', icono: Icons.replay_rounded, color: const Color(0xFF7C4DFF), onTap: jugar)),
                              if (m.gano)
                                Tooltip(
                                    message: 'Terminar',
                                    child: BotonJuego(texto: 'Terminar', icono: Icons.check_rounded, color: const Color(0xFF2DB84C), onTap: terminar)),
                            ]),
                          ]),
                        ),
                      ),
                  ]),
                ),
              ),
              if (widget.controles != null) Positioned(left: 244, top: 416, width: 608, child: widget.controles!(context, m)),
              const BotonVolverEscena(),
            ],
          );
        },
      );
}
