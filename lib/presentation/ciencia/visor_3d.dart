import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/motor_3d.dart';

export '../biology/tema1/motor_3d.dart';

/// Piezas y visor 3D compartidos por las simulaciones 3D de Electrónica, IA y
/// Programación (usan el mismo motor 3D que los modelos del cuerpo humano).

/// Cubo de lado 2 centrado en el origen (escálalo para hacer cajas).
Malla mallaCaja() {
  const v = [
    V3(-1, -1, -1), V3(1, -1, -1), V3(1, 1, -1), V3(-1, 1, -1), //
    V3(-1, -1, 1), V3(1, -1, 1), V3(1, 1, 1), V3(-1, 1, 1),
  ];
  const caras = [
    [0, 1, 2], [0, 2, 3], // atrás
    [4, 6, 5], [4, 7, 6], // frente
    [0, 4, 5], [0, 5, 1], // abajo
    [3, 2, 6], [3, 6, 7], // arriba
    [0, 3, 7], [0, 7, 4], // izquierda
    [1, 5, 6], [1, 6, 2], // derecha
  ];
  return Malla(List.of(v), [for (final c in caras) List.of(c)]);
}

/// Cilindro de radio 1 y altura 2 a lo largo del eje Y, con tapas.
Malla mallaCilindro({int segmentos = 18}) {
  final v = <V3>[const V3(0, -1, 0), const V3(0, 1, 0)];
  final c = <List<int>>[];
  for (var i = 0; i < segmentos; i++) {
    final a = 2 * math.pi * i / segmentos;
    v
      ..add(V3(math.cos(a), -1, math.sin(a)))
      ..add(V3(math.cos(a), 1, math.sin(a)));
  }
  for (var i = 0; i < segmentos; i++) {
    final j = (i + 1) % segmentos;
    final a0 = 2 + i * 2, a1 = a0 + 1, b0 = 2 + j * 2, b1 = b0 + 1;
    c
      ..add([a0, b0, b1])
      ..add([a0, b1, a1])
      ..add([0, b0, a0])
      ..add([1, a1, b1]);
  }
  return Malla(v, c);
}

/// Visor 3D interactivo: arrastra para girar, botones para acercar y tocar
/// una pieza para seleccionarla. El tiempo [t] avanza solo para animar.
class Visor3D extends StatefulWidget {
  const Visor3D({
    super.key,
    required this.escena,
    this.etiquetas = const {},
    this.opacidad = const {},
    this.seleccionado,
    this.onTocar,
    this.yaw = 0.5,
    this.pitch = -0.5,
    this.autoGiro = false,
    this.ayuda = 'Arrastra para girar · toca una pieza',
  });
  final Escena3D escena;
  final Map<String, String> etiquetas;

  /// Opacidad por objeto (0 = oculto). Sirve para encender y apagar cosas.
  final Map<String, double> opacidad;
  final String? seleccionado;
  final ValueChanged<String?>? onTocar;

  /// Ángulos iniciales de la cámara. [pitch] negativo = mirar desde arriba.
  final double yaw, pitch;
  final bool autoGiro;
  final String ayuda;

  @override
  State<Visor3D> createState() => Visor3DState();
}

class Visor3DState extends State<Visor3D> with SingleTickerProviderStateMixin {
  late final AnimationController _reloj = AnimationController(vsync: this, duration: const Duration(days: 1));
  final _cache = CacheSeleccion();
  double t = 0, _ultimo = 0;
  late double yaw = widget.yaw, pitch = widget.pitch;
  double zoom = 1;
  late bool _auto = widget.autoGiro;

  @override
  void initState() {
    super.initState();
    _reloj
      ..addListener(_tick)
      ..forward();
  }

  void _tick() {
    final ahora = (_reloj.lastElapsedDuration?.inMicroseconds ?? 0) / 1e6;
    final dt = (ahora - _ultimo).clamp(0.0, 0.1);
    _ultimo = ahora;
    setState(() {
      t += dt;
      if (_auto) yaw += dt * 0.3;
    });
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(children: [
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (d) => widget.onTocar?.call(_cache.objetoEn(d.localPosition)),
              onPanStart: (_) => _auto = false,
              onPanUpdate: (d) => setState(() {
                yaw += d.delta.dx * 0.012;
                pitch = (pitch - d.delta.dy * 0.012).clamp(-1.35, 0.3);
              }),
              child: CustomPaint(
                painter: Pintor3D(
                  escena: widget.escena,
                  t: t,
                  yaw: yaw,
                  pitch: pitch,
                  zoom: zoom,
                  cache: _cache,
                  seleccionado: widget.seleccionado,
                  opacidadExtra: widget.opacidad,
                  etiquetas: widget.etiquetas,
                ),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Column(children: [
              _Boton(Icons.threesixty_rounded, 'Girar solo', () => setState(() => _auto = !_auto), activo: _auto),
              _Boton(Icons.zoom_in_rounded, 'Acercar', () => setState(() => zoom = math.min(2.2, zoom * 1.2))),
              _Boton(Icons.zoom_out_rounded, 'Alejar', () => setState(() => zoom = math.max(0.6, zoom / 1.2))),
            ]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 6,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(color: const Color(0x99000000), borderRadius: BorderRadius.circular(12)),
                child: Text('🖐️ ${widget.ayuda}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
        ]),
      );
}

class _Boton extends StatelessWidget {
  const _Boton(this.icono, this.texto, this.onTap, {this.activo = false});
  final IconData icono;
  final String texto;
  final VoidCallback onTap;
  final bool activo;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Tooltip(
          message: texto,
          child: Material(
            color: activo ? const Color(0xFFFFD54F) : Colors.white.withValues(alpha: 0.9),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Padding(padding: const EdgeInsets.all(6), child: Icon(icono, size: 22, color: const Color(0xFF263238))),
            ),
          ),
        ),
      );
}
