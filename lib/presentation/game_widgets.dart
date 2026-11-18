import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../main.dart' show store;

/// Botón "arcade" con relieve que se hunde al presionar.
class GameButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final Color color, textColor;
  final VoidCallback? onTap;
  const GameButton(this.label, {super.key, this.icon, this.color = C.verde, this.textColor = Colors.white, this.onTap});
  @override
  State<GameButton> createState() => _GBState();
}

class _GBState extends State<GameButton> {
  bool _d = false;
  @override
  Widget build(BuildContext context) {
    final hsl = HSLColor.fromColor(widget.color);
    final dark = hsl.withLightness(hsl.lightness * .6).toColor();
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _d = true),
        onTapUp: (_) => setState(() => _d = false),
        onTapCancel: () => setState(() => _d = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          margin: EdgeInsets.only(top: _d ? 5 : 0, bottom: _d ? 0 : 5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          constraints: const BoxConstraints(minHeight: 56, minWidth: 160),
          decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: dark, offset: Offset(0, _d ? 0 : 5))]),
          child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            if (widget.icon != null) ...[Icon(widget.icon, color: widget.textColor), const SizedBox(width: 8)],
            Flexible(
                child: Text(widget.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: widget.textColor, fontSize: 20, fontFamily: 'LilitaOne'))),
          ]),
        ),
      ),
    );
  }
}

class Pulse extends StatefulWidget {
  final Widget child;
  const Pulse({super.key, required this.child});
  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..repeat(reverse: true);
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => store.reducirAnim
      ? widget.child
      : ScaleTransition(scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut)), child: widget.child);
}

enum ZatiEstado { normal, celebrar, pensar }

/// Zati animado por código: respira, tiene sombra y reacciona.
/// Para reaccionar de nuevo con el mismo estado, aumenta [disparo].
class Zati extends StatefulWidget {
  final double size;
  final ZatiEstado estado;
  final int disparo;
  const Zati({super.key, this.size = 140, this.estado = ZatiEstado.normal, this.disparo = 0});
  @override
  State<Zati> createState() => _ZatiState();
}

class _ZatiState extends State<Zati> with TickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400))..repeat();
  late final AnimationController _o = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  @override
  void didUpdateWidget(Zati old) {
    super.didUpdateWidget(old);
    if (widget.disparo != old.disparo && widget.estado != ZatiEstado.normal && !store.reducirAnim) _o.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    _o.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.size * 1.2;
    return Semantics(
      label: 'Zati, el temazate',
      child: SizedBox(
        width: widget.size * .9,
        height: h + 10,
        child: AnimatedBuilder(
          animation: Listenable.merge([_c, _o]),
          builder: (_, __) {
            final s = store.reducirAnim ? 0.0 : math.sin(2 * math.pi * _c.value);
            final t = _o.value;
            var dy = 0.0, giro = 0.0;
            if (_o.isAnimating) {
              if (widget.estado == ZatiEstado.celebrar) {
                dy = -widget.size * .25 * math.sin(math.pi * t);
              } else {
                giro = .08 * math.sin(4 * math.pi * t) * (1 - t);
              }
            }
            final brillo = _o.isAnimating && widget.estado == ZatiEstado.celebrar;
            return Stack(alignment: Alignment.bottomCenter, clipBehavior: Clip.none, children: [
              Container(width: widget.size * .5, height: 10, decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(50))),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Transform.translate(
                  offset: Offset(0, dy),
                  child: Transform.rotate(
                    angle: giro,
                    alignment: Alignment.bottomCenter,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.diagonal3Values(1 - .012 * s, 1 + .02 * s, 1),
                      child: Image.asset('assets/zati.png', height: h, fit: BoxFit.contain, errorBuilder: (_, __, ___) => SizedBox(height: h, child: const Icon(Icons.pets, size: 60))),
                    ),
                  ),
                ),
              ),
              if (brillo) ...[
                Positioned(top: 0, left: 0, child: Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: Icon(Icons.star, color: C.sol, size: widget.size * .2))),
                Positioned(top: h * .15, right: 0, child: Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: Icon(Icons.star, color: C.sol, size: widget.size * .16))),
                Positioned(top: h * .5, left: -4, child: Opacity(opacity: (1 - t).clamp(0.0, 1.0), child: Icon(Icons.auto_awesome, color: Colors.white, size: widget.size * .15))),
              ],
            ]);
          },
        ),
      ),
    );
  }
}

/// Barra superior estilo videojuego: avatar, nivel, XP, insignias, ajustes.
class Hud extends StatelessWidget {
  const Hud({super.key});
  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final n = store.completadas.length;
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: C.panel, border: Border(bottom: BorderSide(color: C.sol, width: 3))),
            child: Row(children: [
              ClipOval(child: Image.asset('assets/zati.png', width: 52, height: 52, fit: BoxFit.cover, alignment: const Alignment(0, -.85))),
              const SizedBox(width: 10),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${store.nombre} · ${store.grado}.º', style: const TextStyle(fontSize: 18, fontFamily: 'LilitaOne'), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Row(children: [
                    Text('Nivel ${n ~/ 3 + 1}', style: const TextStyle(color: C.sol, fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (n % 3) / 3, minHeight: 10, color: C.verde, backgroundColor: Colors.white24))),
                  ]),
                ]),
              ),
              const SizedBox(width: 10),
              Tooltip(message: 'Mis insignias', child: Row(children: [const Icon(Icons.military_tech, color: C.sol, size: 30), Text('${store.recompensas.length}', style: const TextStyle(fontSize: 20, fontFamily: 'LilitaOne'))])),
              IconButton(tooltip: 'Ajustes', iconSize: 28, onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajustes: pendiente.'))), icon: const Icon(Icons.settings)),
            ]),
          );
        },
      );
}
