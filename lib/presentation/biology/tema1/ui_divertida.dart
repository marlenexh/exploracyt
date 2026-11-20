import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'aventura.dart' show BannerTitulo, BotonRedondo;

/// Componentes visuales "de videojuego" para niños de 10 a 12 años:
/// fondos animados, botones que rebotan, entradas escalonadas, confeti,
/// barras de colores y transiciones divertidas.

Color aclarar(Color c, double t) => Color.lerp(c, Colors.white, t)!;
Color oscurecer(Color c, double t) => Color.lerp(c, Colors.black, t)!;

/// Reloj compartido simple: reconstruye con los segundos transcurridos.
class Reloj extends StatefulWidget {
  const Reloj({super.key, required this.builder});
  final Widget Function(BuildContext context, double t) builder;
  @override
  State<Reloj> createState() => _RelojState();
}

class _RelojState extends State<Reloj> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) => widget.builder(context, _t);
}

// ---------------------------------------------------------------------------
// Fondo animado con células, burbujas y destellos flotando
// ---------------------------------------------------------------------------

class FondoAnimado extends StatelessWidget {
  const FondoAnimado({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo del bosque del Tema 1, cubierto con un velo del color de la sección.
        Positioned.fill(
          child: Image.asset(
            'assets/images/biology/fondo_biologia_tema1.jpg',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
        Positioned.fill(
          child: RepaintBoundary(
            child: Reloj(
              builder: (_, t) => CustomPaint(painter: _PintorFondo(t, color)),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _PintorFondo extends CustomPainter {
  _PintorFondo(this.t, this.color);
  final double t;
  final Color color;

  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            aclarar(color, 0.7).withValues(alpha: 0.78),
            aclarar(color, 0.9).withValues(alpha: 0.84),
            const Color(0xFFFFFBF2).withValues(alpha: 0.88),
          ],
          stops: const [0, 0.45, 1],
        ).createShader(rect),
    );
    // Rayos de luz girando muy despacio desde arriba
    final centro = Offset(s.width * 0.5, -s.height * 0.1);
    final rayo = Paint()..color = Colors.white.withValues(alpha: 0.18);
    for (var i = 0; i < 12; i++) {
      final a = i / 12 * 2 * math.pi + t * 0.03;
      final p = Path()
        ..moveTo(centro.dx, centro.dy)
        ..lineTo(
          centro.dx + math.cos(a - 0.08) * s.height * 2,
          centro.dy + math.sin(a - 0.08) * s.height * 2,
        )
        ..lineTo(
          centro.dx + math.cos(a + 0.08) * s.height * 2,
          centro.dy + math.sin(a + 0.08) * s.height * 2,
        )
        ..close();
      c.drawPath(p, rayo);
    }

    final rnd = math.Random(42);
    final tinta = color.withValues(alpha: 0.14);
    final borde = color.withValues(alpha: 0.22);
    for (var i = 0; i < 18; i++) {
      final x0 = rnd.nextDouble();
      final vel = 0.012 + rnd.nextDouble() * 0.02;
      final tam = 10 + rnd.nextDouble() * 26;
      final fase = rnd.nextDouble() * 6;
      final tipo = i % 3;
      final y = 1.1 - ((t * vel + rnd.nextDouble()) % 1.2);
      final p = Offset(
        (x0 + 0.03 * math.sin(t * 0.6 + fase)) * s.width,
        y * s.height,
      );
      switch (tipo) {
        case 0: // glóbulo (dona)
          c.drawCircle(p, tam, Paint()..color = tinta);
          c.drawCircle(
            p,
            tam * 0.45,
            Paint()..color = Colors.white.withValues(alpha: 0.35),
          );
        case 1: // burbuja
          c.drawCircle(
            p,
            tam * 0.7,
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5
              ..color = borde,
          );
          c.drawCircle(
            p + Offset(-tam * 0.22, -tam * 0.22),
            tam * 0.15,
            Paint()..color = Colors.white.withValues(alpha: 0.7),
          );
        default: // cruz / destello
          final k = 0.6 + 0.4 * math.sin(t * 2 + fase);
          final d = tam * 0.45 * k;
          final pinc = Paint()
            ..color = borde
            ..strokeWidth = 3.5
            ..strokeCap = StrokeCap.round;
          c.drawLine(p - Offset(d, 0), p + Offset(d, 0), pinc);
          c.drawLine(p - Offset(0, d), p + Offset(0, d), pinc);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorFondo old) => old.t != t || old.color != color;
}

// ---------------------------------------------------------------------------
// Rebote al tocar
// ---------------------------------------------------------------------------

class Rebote extends StatefulWidget {
  const Rebote({
    super.key,
    required this.child,
    this.onTap,
    this.escala = 0.93,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double escala;
  @override
  State<Rebote> createState() => _ReboteState();
}

class _ReboteState extends State<Rebote> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 380),
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : (_) => _c.forward(),
      onTapCancel: () => _c.reverse(),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              _c.reverse();
              HapticFeedback.lightImpact();
              widget.onTap!();
            },
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, child) {
          final v = _c.status == AnimationStatus.reverse
              ? Curves.elasticOut.transform(1 - _c.value)
              : _c.value;
          final k = _c.status == AnimationStatus.reverse
              ? widget.escala + (1 - widget.escala) * v
              : 1 - (1 - widget.escala) * v;
          return Transform.scale(scale: k, child: child);
        },
        child: widget.child,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Entrada escalonada (aparece deslizándose y rebotando)
// ---------------------------------------------------------------------------

class Entrada extends StatefulWidget {
  const Entrada({
    super.key,
    required this.child,
    this.indice = 0,
    this.desde = const Offset(0, 40),
  });
  final Widget child;
  final int indice;
  final Offset desde;
  @override
  State<Entrada> createState() => _EntradaState();
}

class _EntradaState extends State<Entrada> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );

  Timer? _espera;

  @override
  void initState() {
    super.initState();
    if (widget.indice == 0) {
      _c.forward();
    } else {
      _espera = Timer(Duration(milliseconds: 70 * widget.indice), () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _espera?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) {
          final v = Curves.easeOutBack.transform(_c.value);
          return Opacity(
            opacity: _c.value.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: widget.desde * (1 - v),
              child: Transform.scale(scale: 0.85 + 0.15 * v, child: child),
            ),
          );
        },
        child: widget.child,
      );
}

// ---------------------------------------------------------------------------
// Animaciones continuas sencillas
// ---------------------------------------------------------------------------

enum TipoMovimiento { flotar, latir, balancear, girar }

class Movimiento extends StatelessWidget {
  const Movimiento({
    super.key,
    required this.child,
    this.tipo = TipoMovimiento.flotar,
    this.fase = 0,
    this.intensidad = 1,
  });
  final Widget child;
  final TipoMovimiento tipo;
  final double fase;
  final double intensidad;

  @override
  Widget build(BuildContext context) => Reloj(
        builder: (_, t) {
          final x = t + fase;
          switch (tipo) {
            case TipoMovimiento.flotar:
              return Transform.translate(
                offset: Offset(0, math.sin(x * 2.2) * 5 * intensidad),
                child: child,
              );
            case TipoMovimiento.latir:
              final b = math.pow(math.max(0, math.sin(x * 6)), 8).toDouble();
              return Transform.scale(
                scale: 1 + 0.12 * b * intensidad,
                child: child,
              );
            case TipoMovimiento.balancear:
              return Transform.rotate(
                angle: math.sin(x * 2.5) * 0.12 * intensidad,
                child: child,
              );
            case TipoMovimiento.girar:
              return Transform.rotate(
                  angle: x * 0.6 * intensidad, child: child);
          }
        },
      );
}

// ---------------------------------------------------------------------------
// Confeti
// ---------------------------------------------------------------------------

const coloresConfeti = [
  Color(0xFFFF4D6D),
  Color(0xFFFFC300),
  Color(0xFF2EC4B6),
  Color(0xFF3D5AFE),
  Color(0xFF9B5DE5),
  Color(0xFF00BBF9),
  Color(0xFF8AC926),
];

/// Lluvia de confeti continua (para celebraciones).
class LluviaConfeti extends StatelessWidget {
  const LluviaConfeti({super.key, this.cantidad = 60});
  final int cantidad;
  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Reloj(
          builder: (_, t) => CustomPaint(
              painter: _PintorLluvia(t, cantidad), size: Size.infinite),
        ),
      );
}

class _PintorLluvia extends CustomPainter {
  _PintorLluvia(this.t, this.n);
  final double t;
  final int n;
  @override
  void paint(Canvas c, Size s) {
    final rnd = math.Random(9);
    for (var i = 0; i < n; i++) {
      final x = rnd.nextDouble() * s.width;
      final vel = 0.18 + rnd.nextDouble() * 0.25;
      final y = ((t * vel + rnd.nextDouble()) % 1.15 - 0.1) * s.height;
      final col = coloresConfeti[i % coloresConfeti.length];
      c.save();
      c.translate(x + math.sin(t * 3 + i) * 12, y);
      c.rotate(t * (2 + rnd.nextDouble() * 3) + i);
      final ancho = 6 + rnd.nextDouble() * 6;
      if (i.isEven) {
        c.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: ancho,
            height: ancho * 0.5,
          ),
          Paint()..color = col,
        );
      } else {
        c.drawCircle(Offset.zero, ancho * 0.35, Paint()..color = col);
      }
      c.restore();
    }
  }

  @override
  bool shouldRepaint(_PintorLluvia old) => true;
}

/// Explosión de confeti que se reproduce una sola vez.
class ExplosionConfeti extends StatefulWidget {
  const ExplosionConfeti({super.key, this.cantidad = 40});
  final int cantidad;
  @override
  State<ExplosionConfeti> createState() => _ExplosionConfetiState();
}

class _ExplosionConfetiState extends State<ExplosionConfeti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..forward();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => CustomPaint(
            painter: _PintorExplosion(
              _c.value,
              widget.cantidad,
              widget.key.hashCode,
            ),
            size: Size.infinite,
          ),
        ),
      );
}

class _PintorExplosion extends CustomPainter {
  _PintorExplosion(this.v, this.n, this.semilla);
  final double v;
  final int n;
  final int semilla;
  @override
  void paint(Canvas c, Size s) {
    if (v >= 1) return;
    final rnd = math.Random(semilla);
    final origen = Offset(s.width / 2, s.height * 0.55);
    final alfa = (1 - v).clamp(0.0, 1.0);
    for (var i = 0; i < n; i++) {
      final ang = -math.pi / 2 + (rnd.nextDouble() - 0.5) * math.pi * 1.4;
      final vel = 200 + rnd.nextDouble() * 260;
      final dx = math.cos(ang) * vel * v;
      final dy = math.sin(ang) * vel * v + 420 * v * v;
      final col = coloresConfeti[i % coloresConfeti.length].withValues(
        alpha: alfa,
      );
      c.save();
      c.translate(origen.dx + dx, origen.dy + dy);
      c.rotate(v * 12 + i);
      c.drawRect(const Rect.fromLTWH(-5, -2.5, 10, 5), Paint()..color = col);
      c.restore();
    }
  }

  @override
  bool shouldRepaint(_PintorExplosion old) => old.v != v;
}

// ---------------------------------------------------------------------------
// Transición de pantallas
// ---------------------------------------------------------------------------

class RutaJuego<T> extends PageRouteBuilder<T> {
  RutaJuego({required WidgetBuilder builder})
      : super(
          transitionDuration: const Duration(milliseconds: 520),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, _, __) => builder(context),
          transitionsBuilder: (context, anim, secundaria, child) {
            final entra = CurvedAnimation(
              parent: anim,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeIn,
            );
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: anim,
                curve: const Interval(0, 0.5),
              ),
              child: ScaleTransition(
                scale: Tween(begin: 0.82, end: 1.0).animate(entra),
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(entra),
                  child: child,
                ),
              ),
            );
          },
        );
}

// ---------------------------------------------------------------------------
// Barra superior de colores con forma de ola
// ---------------------------------------------------------------------------

class BarraJuego extends StatelessWidget implements PreferredSizeWidget {
  const BarraJuego({
    super.key,
    required this.titulo,
    required this.color,
    this.acciones,
    this.estrellas,
  });
  final String titulo;
  final Color color;
  final List<Widget>? acciones;
  final int? estrellas;

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final puedeVolver = Navigator.of(context).canPop();
    final arriba = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(10, arriba + 6, 10, 2),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: puedeVolver
                ? BotonRedondo(
                    icono: Icons.arrow_back_rounded,
                    tam: 50,
                    onTap: () => Navigator.of(context).maybePop(),
                  )
                : null,
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: BannerTitulo(
                  titulo,
                  tam: 22,
                  color: oscurecer(color, 0.08),
                ),
              ),
            ),
          ),
          ...?acciones,
          if (acciones == null || acciones!.isEmpty) const SizedBox(width: 56),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Botón grueso estilo videojuego
// ---------------------------------------------------------------------------

class BotonJuego extends StatelessWidget {
  const BotonJuego({
    super.key,
    required this.texto,
    required this.color,
    this.onTap,
    this.icono,
    this.grande = false,
  });
  final String texto;
  final Color color;
  final VoidCallback? onTap;
  final IconData? icono;
  final bool grande;

  @override
  Widget build(BuildContext context) {
    final activo = onTap != null;
    final base = activo ? color : Colors.grey.shade400;
    return Rebote(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 22,
          vertical: grande ? 16 : 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [aclarar(base, 0.2), base],
          ),
          boxShadow: [
            BoxShadow(color: oscurecer(base, 0.3), offset: const Offset(0, 5)),
            if (activo)
              BoxShadow(
                color: base.withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icono != null) ...[
              Icon(icono, color: Colors.white, size: grande ? 28 : 22),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                texto,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: grande ? 21 : 17,
                  shadows: [
                    Shadow(
                      color: oscurecer(base, 0.35),
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Texto que aparece letra por letra, como si alguien lo dijera.
/// Tocar el texto lo muestra completo.
class TextoMaquina extends StatefulWidget {
  const TextoMaquina(
    this.texto, {
    super.key,
    this.estilo,
    this.letrasPorSegundo = 45,
    this.alCambiar,
  });
  final String texto;
  final TextStyle? estilo;
  final double letrasPorSegundo;
  final ValueChanged<bool>? alCambiar; // true mientras "habla"
  @override
  State<TextoMaquina> createState() => _TextoMaquinaState();
}

class _TextoMaquinaState extends State<TextoMaquina>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  int _visibles = 0;
  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick);
    _iniciar();
  }

  void _iniciar() {
    _visibles = 0;
    _ticker
      ..stop()
      ..start();
    widget.alCambiar?.call(true);
  }

  void _tick(Duration d) {
    final n = math.min(
      widget.texto.length,
      (d.inMilliseconds / 1000 * widget.letrasPorSegundo).floor(),
    );
    if (n != _visibles) setState(() => _visibles = n);
    if (n >= widget.texto.length) {
      _ticker.stop();
      widget.alCambiar?.call(false);
    }
  }

  @override
  void didUpdateWidget(TextoMaquina old) {
    super.didUpdateWidget(old);
    if (old.texto != widget.texto) _iniciar();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completo = _visibles >= widget.texto.length;
    return GestureDetector(
      onTap: completo
          ? null
          : () {
              _ticker.stop();
              setState(() => _visibles = widget.texto.length);
              widget.alCambiar?.call(false);
            },
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: widget.texto.substring(0, _visibles)),
            // El resto se reserva invisible para que la burbuja no cambie de tamaño.
            TextSpan(
              text: widget.texto.substring(_visibles),
              style: const TextStyle(color: Colors.transparent),
            ),
          ],
        ),
        style: widget.estilo,
      ),
    );
  }
}
