import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'comunes.dart';
import 'contenido.dart';
import 'misiones.dart';
import 'progreso.dart';

/// Pantallas de aventura según los bocetos:
/// 1. [PantallaIntroTema]: Zati, globo de texto, misión del tema y "Comenzar".
/// 2. [PantallaMisiones]: las 4 misiones (se desbloquean en orden).
/// 3. [PantallaMision]: los pasos de cada misión.

// ---------------------------------------------------------------------------
// Piezas visuales de los bocetos
// ---------------------------------------------------------------------------

const moradoBanner = Color(0xFF6A3FC8);

/// Cinta morada con el título (como en los bocetos).
class BannerTitulo extends StatelessWidget {
  const BannerTitulo(
    this.texto, {
    super.key,
    this.tam = 26,
    this.color = moradoBanner,
  });
  final String texto;
  final double tam;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PintorCinta(color),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tam * 1.4,
          vertical: tam * 0.32,
        ),
        child: Text(
          texto,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: tam,
            fontWeight: FontWeight.w700,
            height: 1.1,
            shadows: [
              Shadow(
                color: oscurecer(color, 0.45),
                offset: const Offset(0, 2.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PintorCinta extends CustomPainter {
  _PintorCinta(this.color);
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final h = s.height;
    final cola = h * 0.45;
    // Colas de la cinta
    for (final izq in [true, false]) {
      final x0 = izq ? 0.0 : s.width;
      final d = izq ? 1.0 : -1.0;
      final p = Path()
        ..moveTo(x0 + d * cola * 1.4, h * 0.22)
        ..lineTo(x0 - d * cola * 0.2, h * 0.22)
        ..lineTo(x0 + d * cola * 0.45, h * 0.62)
        ..lineTo(x0 - d * cola * 0.2, h * 1.02)
        ..lineTo(x0 + d * cola * 1.4, h * 1.02)
        ..close();
      c.drawPath(p, Paint()..color = oscurecer(color, 0.28));
    }
    final cuerpo = RRect.fromRectAndRadius(
      Rect.fromLTWH(cola * 0.8, 0, s.width - cola * 1.6, h * 0.9),
      Radius.circular(h * 0.22),
    );
    c.drawRRect(
      cuerpo.shift(Offset(0, h * 0.08)),
      Paint()..color = oscurecer(color, 0.35),
    );
    c.drawRRect(
      cuerpo,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [aclarar(color, 0.18), color],
        ).createShader(cuerpo.outerRect),
    );
    c.drawRRect(
      cuerpo.deflate(3),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.white.withValues(alpha: 0.35),
    );
  }

  @override
  bool shouldRepaint(_PintorCinta old) => old.color != color;
}

/// Letrero de madera (boceto del menú de misiones).
class LetreroMadera extends StatelessWidget {
  const LetreroMadera(this.texto, {super.key, this.tam = 26});
  final String texto;
  final double tam;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: tam * 1.2, vertical: tam * 0.3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE9B36B), Color(0xFFC98A3E)],
        ),
        border: Border.all(color: const Color(0xFF8A5A24), width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFF6B4219), offset: Offset(0, 5)),
        ],
      ),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: tam,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF4A2A0C),
          shadows: const [
            Shadow(color: Color(0x66FFFFFF), offset: Offset(0, 1.5)),
          ],
        ),
      ),
    );
  }
}

/// Botón redondo morado con borde blanco (regresar y flechas).
class BotonRedondo extends StatelessWidget {
  const BotonRedondo({
    super.key,
    required this.icono,
    this.onTap,
    this.tam = 52,
    this.color = moradoBanner,
    this.etiqueta,
  });
  final IconData icono;
  final VoidCallback? onTap;
  final double tam;
  final Color color;
  final String? etiqueta;
  @override
  Widget build(BuildContext context) {
    final activo = onTap != null;
    final base = activo ? color : Colors.grey.shade400;
    final boton = Rebote(
      onTap: onTap,
      child: Container(
        width: tam,
        height: tam,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [aclarar(base, 0.2), base],
          ),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(color: oscurecer(base, 0.35), offset: const Offset(0, 4)),
          ],
        ),
        child: Icon(icono, color: Colors.white, size: tam * 0.58),
      ),
    );
    return etiqueta == null ? boton : Tooltip(message: etiqueta!, child: boton);
  }
}

/// Globo de texto blanco con colita hacia la izquierda (hacia Zati).
class GloboTexto extends StatelessWidget {
  const GloboTexto({super.key, required this.child, this.colita = true});
  final Widget child;
  final bool colita;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: colita ? _PintorColitaGlobo() : null,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFDCD3F5), width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _PintorColitaGlobo extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final y = s.height * 0.62;
    final p = Path()
      ..moveTo(4, y - 14)
      ..lineTo(-16, y + 4)
      ..lineTo(4, y + 10)
      ..close();
    c.drawPath(p, Paint()..color = Colors.white);
    c.drawPath(
      p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = const Color(0xFFDCD3F5),
    );
    c.drawRect(Rect.fromLTWH(2, y - 12, 6, 20), Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_PintorColitaGlobo old) => false;
}

/// Ilustración de la "Estación del Cuerpo Humano": consola con pantalla azul.
class EstacionCuerpo extends StatelessWidget {
  const EstacionCuerpo({super.key, this.restaurados = 0});
  final int restaurados;
  @override
  Widget build(BuildContext context) => Reloj(
        builder: (_, t) => CustomPaint(
          painter: PintorEstacion(t, restaurados),
          size: Size.infinite,
        ),
      );
}

class PintorEstacion extends CustomPainter {
  PintorEstacion(this.t, this.restaurados);
  final double t;
  final int restaurados;
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    // Base de la consola
    final base = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.04, h * 0.08, w * 0.92, h * 0.84),
      Radius.circular(h * 0.12),
    );
    c.drawRRect(
      base.shift(Offset(0, h * 0.04)),
      Paint()..color = const Color(0xFF3B2A6B),
    );
    c.drawRRect(
      base,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF9A88C9), Color(0xFF6C5AA3)],
        ).createShader(base.outerRect),
    );
    // Pantalla
    final pantalla = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.17, w * 0.6, h * 0.62),
      Radius.circular(h * 0.06),
    );
    c.drawRRect(
      pantalla,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF7FE3FF), Color(0xFF0B78C9), Color(0xFF07365F)],
          stops: [0, 0.6, 1],
        ).createShader(pantalla.outerRect),
    );
    c.save();
    c.clipRRect(pantalla);
    // Rejilla
    final rejilla = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1;
    for (var x = pantalla.left; x < pantalla.right; x += w * 0.05) {
      c.drawLine(Offset(x, pantalla.top), Offset(x, pantalla.bottom), rejilla);
    }
    for (var y = pantalla.top; y < pantalla.bottom; y += w * 0.05) {
      c.drawLine(Offset(pantalla.left, y), Offset(pantalla.right, y), rejilla);
    }
    // Silueta holográfica
    final caja = Silueta.caja(
      pantalla.outerRect.size,
      margen: 0.08,
    ).shift(pantalla.outerRect.topLeft);
    c.drawPath(Silueta.ruta(caja), Paint()..color = const Color(0xCCB9F3FF));
    c.drawPath(
      Silueta.ruta(caja),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white,
    );
    // Puntos de los sistemas: rojo, azul, verde (se encienden al restaurar)
    final puntos = [
      const Offset(0.55, 0.32),
      const Offset(0.4, 0.24),
      const Offset(0.5, 0.45),
    ];
    const colores = [Color(0xFFFF3D68), Color(0xFF00A6FB), Color(0xFF2DB84C)];
    for (var i = 0; i < 3; i++) {
      final p = Silueta.punto(caja, puntos[i]);
      final encendido = i < restaurados;
      final k =
          encendido ? 1.0 : (0.4 + 0.6 * (math.sin(t * 6 + i) > 0 ? 1 : 0));
      c.drawCircle(
        p,
        caja.width * 0.09,
        Paint()
          ..color = (encendido ? colores[i] : const Color(0xFFFF5252))
              .withValues(alpha: 0.35 * k),
      );
      c.drawCircle(
        p,
        caja.width * 0.045,
        Paint()
          ..color = encendido
              ? colores[i]
              : const Color(0xFFFF5252).withValues(alpha: k),
      );
    }
    // Línea de escaneo
    final y = pantalla.top + ((t * 0.5) % 1) * pantalla.height;
    c.drawRect(
      Rect.fromLTWH(pantalla.left, y - 3, pantalla.width, 6),
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
    c.restore();
    c.drawRRect(
      pantalla,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0xFF3B2A6B),
    );
    // Lucecitas laterales
    for (var i = 0; i < 3; i++) {
      final on = ((t * 2 + i * 0.7) % 1) > 0.5;
      for (final x in [w * 0.11, w * 0.89]) {
        c.drawCircle(
          Offset(x, h * (0.3 + i * 0.18)),
          w * 0.025,
          Paint()
            ..color = on
                ? [
                    const Color(0xFF7CFFB2),
                    const Color(0xFFFFE066),
                    const Color(0xFF7FE3FF),
                  ][i]
                : const Color(0xFF4B3C80),
        );
      }
    }
  }

  @override
  bool shouldRepaint(PintorEstacion old) => true;
}

/// Barra superior de las pantallas de aventura: botón de regresar y cinta.
class EncabezadoAventura extends StatelessWidget {
  const EncabezadoAventura({
    super.key,
    required this.titulo,
    this.accion,
    this.letrero = false,
  });
  final String titulo;
  final Widget? accion;
  final bool letrero;
  @override
  Widget build(BuildContext context) {
    final puedeVolver = Navigator.of(context).canPop();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: puedeVolver
                ? BotonRedondo(
                    icono: Icons.arrow_back_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  )
                : null,
          ),
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Entrada(
                  desde: const Offset(0, -40),
                  child: letrero
                      ? LetreroMadera(titulo)
                      : BannerTitulo(titulo, tam: 24),
                ),
              ),
            ),
          ),
          SizedBox(width: 56, child: accion),
        ],
      ),
    );
  }
}

/// Fondo del bosque (fondo_biologia_tema1) a pantalla completa.
class FondoBosque extends StatelessWidget {
  const FondoBosque({super.key, required this.child, this.velo = 0});
  final Widget child;
  final double velo;
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              rutaFondoTema1,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF8FD3FF),
                      Color(0xFFB8E68A),
                      Color(0xFF6DBA4A),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (velo > 0)
            Positioned.fill(
              child: ColoredBox(color: Colors.white.withValues(alpha: velo)),
            ),
          Positioned.fill(child: child),
        ],
      );
}

// ---------------------------------------------------------------------------
// 1. Intro del tema (boceto 1)
// ---------------------------------------------------------------------------

class PantallaIntroTema extends StatelessWidget {
  const PantallaIntroTema({super.key, this.nombre});
  final String? nombre;

  String get textoZati =>
      '¡Hola, ${nombre ?? 'explorador'}!\n\nEn este tema conoceremos cómo está formado nuestro cuerpo y cómo funcionan algunos de sus sistemas.\n\n¿Listo para comenzar?';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoBosque(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, cons) {
              final horizontal = cons.maxWidth > cons.maxHeight;
              final titulo = Entrada(
                desde: const Offset(0, -50),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: BannerTitulo(
                    'El cuerpo humano\ny sus sistemas',
                    tam: horizontal ? 26 : 24,
                  ),
                ),
              );
              final zati = Entrada(
                indice: 1,
                desde: const Offset(-80, 0),
                child: const ZatiMascota(tam: 400, hablando: true),
              );
              final globo = Entrada(
                indice: 2,
                child: GloboTexto(
                  child: TextoMaquina(
                    textoZati,
                    estilo: TextStyle(
                      fontSize: horizontal ? 17 : 18,
                      height: 1.3,
                      color: ColoresJuego.texto,
                    ),
                  ),
                ),
              );
              const mision = Entrada(
                indice: 3,
                desde: Offset(80, 0),
                child: _PanelMisionTema(),
              );
              final comenzar = Entrada(
                indice: 4,
                desde: const Offset(0, 60),
                child: Movimiento(
                  tipo: TipoMovimiento.latir,
                  intensidad: 0.35,
                  child: BotonJuego(
                    texto: 'Comenzar',
                    icono: Icons.play_arrow_rounded,
                    color: const Color(0xFF2DB84C),
                    grande: true,
                    onTap: () => abrirPantalla(
                      context,
                      const PantallaMisiones(),
                      fondoBosque: true,
                    ),
                  ),
                ),
              );
              if (horizontal) {
                return Stack(
                  children: [
                    Positioned(left: 8, top: 8, child: _BotonSalir()),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 6,
                      height: cons.maxHeight * 0.24,
                      child: Center(child: titulo),
                    ),
                    Positioned(
                      left: cons.maxWidth * 0.01,
                      bottom: 0,
                      width: cons.maxWidth * 0.28,
                      height: cons.maxHeight * 0.78,
                      child: zati,
                    ),
                    Positioned(
                      left: cons.maxWidth * 0.29,
                      width: cons.maxWidth * 0.36,
                      top: cons.maxHeight * 0.27,
                      bottom: cons.maxHeight * 0.22,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: SingleChildScrollView(child: globo),
                      ),
                    ),
                    Positioned(
                      right: cons.maxWidth * 0.02,
                      width: cons.maxWidth * 0.3,
                      top: cons.maxHeight * 0.2,
                      bottom: cons.maxHeight * 0.06,
                      child: mision,
                    ),
                    Positioned(
                      left: cons.maxWidth * 0.29,
                      width: cons.maxWidth * 0.36,
                      bottom: cons.maxHeight * 0.04,
                      child: Center(child: comenzar),
                    ),
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(children: [_BotonSalir()]),
                  titulo,
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: Row(
                      children: [
                        Expanded(flex: 4, child: zati),
                        const SizedBox(width: 18),
                        Expanded(
                          flex: 6,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(child: globo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  const SizedBox(height: 300, child: mision),
                  const SizedBox(height: 16),
                  Center(child: comenzar),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BotonSalir extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Regresa a la app que abrió el juego (si existe).
    final ruta = ModalRoute.of(context);
    final puede = ruta != null && !ruta.isFirst;
    if (!puede) return const SizedBox(width: 52, height: 52);
    return BotonRedondo(
      icono: Icons.arrow_back_rounded,
      onTap: () => Navigator.of(context).maybePop(),
    );
  }
}

class _PanelMisionTema extends StatelessWidget {
  const _PanelMisionTema();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF4D6), Color(0xFFF3DDA8)],
        ),
        border: Border.all(color: const Color(0xFFB98A45), width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Misión del tema',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Color(0xFF5B2CA8),
            ),
          ),
          Container(
            height: 2.5,
            margin: const EdgeInsets.symmetric(vertical: 6),
            color: const Color(0xFFD9B36E),
          ),
          const Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Text(
                'La Estación del Cuerpo Humano necesita tu ayuda. Algunos de sus sistemas dejaron de funcionar y debes investigarlos para restaurarla.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.22,
                  color: Color(0xFF3B2A12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 2,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: Builder(
                  builder: (context) {
                    final p = ProgresoScope.of(context);
                    return EstacionCuerpo(
                      restaurados: misionesTema1
                          .take(3)
                          .where((m) => m.completa(p))
                          .length,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Menú de misiones (boceto 4)
// ---------------------------------------------------------------------------

class PantallaMisiones extends StatelessWidget {
  const PantallaMisiones({super.key});

  @override
  Widget build(BuildContext context) {
    final p = ProgresoScope.of(context);
    final desbloquear = ConfiguracionJuego.of(context).desbloquearTodo;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncabezadoAventura(
              titulo: 'El cuerpo humano',
              letrero: true,
              accion: BotonRedondo(
                icono: Icons.emoji_events_rounded,
                color: const Color(0xFFFFAA00),
                onTap: () => abrirPantalla(
                  context,
                  const PantallaLogrosAventura(),
                  fondoBosque: true,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: LayoutBuilder(
                builder: (context, cons) {
                  final horizontal = cons.maxWidth > cons.maxHeight * 1.2;
                  final tarjetas = [
                    for (var i = 0; i < misionesTema1.length; i++)
                      _TarjetaMision(
                        mision: misionesTema1[i],
                        indice: i,
                        desbloqueada: desbloquear || misionDesbloqueada(p, i),
                        completa: misionesTema1[i].completa(p),
                        avance: misionesTema1[i].avance(p),
                      ),
                  ];
                  if (horizontal) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 14),
                      child: Row(
                        children: [
                          for (final t in tarjetas)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: t,
                              ),
                            ),
                        ],
                      ),
                    );
                  }
                  return GridView.count(
                    padding: const EdgeInsets.all(14),
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                    children: tarjetas,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaMision extends StatefulWidget {
  const _TarjetaMision({
    required this.mision,
    required this.indice,
    required this.desbloqueada,
    required this.completa,
    required this.avance,
  });
  final Mision mision;
  final int indice;
  final bool desbloqueada;
  final bool completa;
  final double avance;
  @override
  State<_TarjetaMision> createState() => _TarjetaMisionState();
}

class _TarjetaMisionState extends State<_TarjetaMision>
    with SingleTickerProviderStateMixin {
  late final AnimationController _temblor = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  void _tocar() {
    final m = widget.mision;
    if (!widget.desbloqueada) {
      _temblor.forward(from: 0);
      final anterior = misionesTema1[widget.indice - 1];
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: moradoBanner,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Text(
              '🔒 Primero completa “${anterior.titulo}” para desbloquear esta misión.',
              style: const TextStyle(fontSize: 16, fontFamily: fuenteJuego),
            ),
          ),
        );
      return;
    }
    abrirMision(context, m);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mision;
    final bloqueada = !widget.desbloqueada;
    return Entrada(
      indice: widget.indice + 1,
      desde: const Offset(0, 70),
      child: AnimatedBuilder(
        animation: _temblor,
        builder: (_, child) => Transform.translate(
          offset: Offset(
            math.sin(_temblor.value * math.pi * 6) * 8 * (1 - _temblor.value),
            0,
          ),
          child: child,
        ),
        child: Rebote(
          onTap: _tocar,
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, m.colorFondo],
              ),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: oscurecer(m.colorFondo, 0.35),
                  offset: const Offset(0, 6),
                ),
                const BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 14,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Opacity(
                    opacity: bloqueada ? 0.75 : 1,
                    child: Movimiento(
                      tipo: widget.indice == 0
                          ? TipoMovimiento.latir
                          : TipoMovimiento.flotar,
                      fase: widget.indice.toDouble(),
                      intensidad: bloqueada ? 0 : 1,
                      child: IconoMision(m.icono),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    m.titulo,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: ColoresJuego.texto,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      m.subtitulo,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: oscurecer(m.color, 0.25),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                if (bloqueada)
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3B2A6B),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.lock_rounded,
                      color: Color(0xFF3B2A6B),
                      size: 28,
                    ),
                  )
                else if (widget.completa)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: ColoresJuego.correcto,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 4),
                        Text(
                          '¡Lograda!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BotonRedondo(
                        icono: Icons.play_arrow_rounded,
                        tam: 48,
                        onTap: _tocar,
                      ),
                      if (widget.avance > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${(widget.avance * 100).round()}%',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: moradoBanner,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Íconos grandes de las misiones (corazón, pulmones, escudo, equipo).
class IconoMision extends StatelessWidget {
  const IconoMision(this.tipo, {super.key});
  final TipoIconoMision tipo;
  @override
  Widget build(BuildContext context) {
    switch (tipo) {
      case TipoIconoMision.corazon:
        return const CustomPaint(
          painter: _PintorIconoOrgano('corazon'),
          size: Size.infinite,
        );
      case TipoIconoMision.pulmones:
        return const CustomPaint(
          painter: _PintorIconoOrgano('pulmones'),
          size: Size.infinite,
        );
      case TipoIconoMision.escudo:
        return const CustomPaint(painter: _PintorEscudo(), size: Size.infinite);
      case TipoIconoMision.equipo:
        return LayoutBuilder(
          builder: (_, c) => Center(
            child: Icon(
              Icons.groups_rounded,
              size: c.biggest.shortestSide * 0.95,
              color: const Color(0xFF8B5CF6),
              shadows: const [
                Shadow(color: Color(0xFF5B2CA8), offset: Offset(0, 4)),
              ],
            ),
          ),
        );
    }
  }
}

class _PintorIconoOrgano extends CustomPainter {
  const _PintorIconoOrgano(this.id);
  final String id;
  @override
  void paint(Canvas c, Size s) {
    final lado = s.shortestSide * 0.95;
    final r = Rect.fromCenter(
      center: s.center(Offset.zero),
      width: lado,
      height: lado,
    );
    if (id == 'corazon') {
      // Corazón brillante sin vasos (como en el boceto)
      final t = Trazo(r)
        ..m(0.5, 0.28)
        ..c(0.36, 0.06, 0.02, 0.12, 0.06, 0.45)
        ..c(0.1, 0.72, 0.38, 0.86, 0.5, 0.97)
        ..c(0.62, 0.86, 0.9, 0.72, 0.94, 0.45)
        ..c(0.98, 0.12, 0.64, 0.06, 0.5, 0.28)
        ..z();
      c.drawPath(
        t.path.shift(const Offset(0, 4)),
        Paint()..color = const Color(0xFF9E1028),
      );
      c.drawPath(
        t.path,
        Paint()
          ..shader = const RadialGradient(
            center: Alignment(-0.35, -0.45),
            colors: [Color(0xFFFF8A9A), Color(0xFFF2334A), Color(0xFFB0172B)],
            stops: [0, 0.55, 1],
          ).createShader(r),
      );
      c.drawOval(
        Rect.fromLTWH(
          r.left + lado * 0.2,
          r.top + lado * 0.22,
          lado * 0.16,
          lado * 0.1,
        ),
        Paint()..color = Colors.white.withValues(alpha: 0.7),
      );
    } else {
      DibujoOrganos.pulmones(c, r, inflado: 0.6);
    }
  }

  @override
  bool shouldRepaint(_PintorIconoOrgano old) => false;
}

class _PintorEscudo extends CustomPainter {
  const _PintorEscudo();
  @override
  void paint(Canvas c, Size s) {
    final lado = s.shortestSide * 0.92;
    final r = Rect.fromCenter(
      center: s.center(Offset.zero),
      width: lado * 0.85,
      height: lado,
    );
    final t = Trazo(r)
      ..m(0.5, 0.02)
      ..q(0.75, 0.14, 0.98, 0.14)
      ..q(1.0, 0.72, 0.5, 0.98)
      ..q(0.0, 0.72, 0.02, 0.14)
      ..q(0.25, 0.14, 0.5, 0.02)
      ..z();
    c.drawPath(
      t.path.shift(const Offset(0, 4)),
      Paint()..color = const Color(0xFF1B7A2F),
    );
    c.drawPath(
      t.path,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6EE07F), Color(0xFF2DB84C)],
        ).createShader(r),
    );
    c.drawPath(
      t.path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = lado * 0.04
        ..color = Colors.white,
    );
    final cruz = Paint()
      ..color = Colors.white
      ..strokeWidth = lado * 0.13
      ..strokeCap = StrokeCap.round;
    final centro = r.center + Offset(0, -lado * 0.03);
    c.drawLine(
      centro - Offset(0, lado * 0.17),
      centro + Offset(0, lado * 0.17),
      cruz,
    );
    c.drawLine(
      centro - Offset(lado * 0.17, 0),
      centro + Offset(lado * 0.17, 0),
      cruz,
    );
  }

  @override
  bool shouldRepaint(_PintorEscudo old) => false;
}

// ---------------------------------------------------------------------------
// 3. Pantalla de una misión: sus pasos
// ---------------------------------------------------------------------------

class PantallaMision extends StatefulWidget {
  const PantallaMision({super.key, required this.mision});
  final Mision mision;
  @override
  State<PantallaMision> createState() => _PantallaMisionState();
}

class _PantallaMisionState extends State<PantallaMision> {
  late bool _estabaCompleta;
  ProgresoJuego? _progreso;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final p = ProgresoScope.read(context);
    if (_progreso == null) {
      _progreso = p;
      _estabaCompleta = widget.mision.completa(p);
      p.addListener(_revisar);
    }
  }

  @override
  void dispose() {
    _progreso?.removeListener(_revisar);
    super.dispose();
  }

  void _revisar() {
    final completa = widget.mision.completa(_progreso!);
    if (completa && !_estabaCompleta) {
      _estabaCompleta = true;
      // Se muestra cuando se cierra la celebración de la actividad.
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        final i = misionesTema1.indexOf(widget.mision);
        final siguiente =
            i + 1 < misionesTema1.length ? misionesTema1[i + 1] : null;
        mostrarCelebracion(
          context,
          titulo: '¡Misión cumplida!',
          mensaje: '${widget.mision.mensajeFinal}'
              '${siguiente == null ? '\n¡Restauraste toda la Estación del Cuerpo Humano!' : '\n¡Desbloqueaste “${siguiente.titulo}: ${siguiente.subtitulo}”!'}',
          estrellas: 3,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mision;
    final p = ProgresoScope.of(context);
    final desbloquear = ConfiguracionJuego.of(context).desbloquearTodo;
    final hechos = m.pasos.where((x) => p.estrellasDe(x.actividad) > 0).length;
    final siguiente = m.pasos.indexWhere(
      (x) => p.estrellasDe(x.actividad) == 0,
    );
    final textoZati = siguiente == -1
        ? '¡Lo lograste! Completaste todos los pasos de esta misión. Puedes repetirlos para ganar más estrellas.'
        : siguiente == 0
            ? m.intro
            : '¡Muy bien! Sigue con el paso ${siguiente + 1}: “${m.pasos[siguiente].titulo}”.';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncabezadoAventura(titulo: '${m.titulo}: ${m.subtitulo}'),
            Expanded(
              child: LayoutBuilder(
                builder: (context, cons) {
                  final horizontal = cons.maxWidth > cons.maxHeight * 1.2;
                  final pasos = ListView.separated(
                    scrollDirection:
                        horizontal ? Axis.horizontal : Axis.vertical,
                    padding: const EdgeInsets.fromLTRB(8, 10, 16, 14),
                    itemCount: m.pasos.length,
                    separatorBuilder: (_, __) => horizontal
                        ? const Center(
                            child: Icon(
                              Icons.more_horiz_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final paso = m.pasos[i];
                      final abierto = desbloquear ||
                          i == 0 ||
                          p.estrellasDe(m.pasos[i - 1].actividad) > 0;
                      return SizedBox(
                        width: horizontal
                            ? math.min(190, cons.maxWidth * 0.24)
                            : null,
                        height: horizontal ? null : 110,
                        child: _TarjetaPaso(
                          paso: paso,
                          numero: i + 1,
                          color: m.color,
                          abierto: abierto,
                          estrellas: p.estrellasDe(paso.actividad),
                          actual: i == siguiente,
                          horizontal: horizontal,
                          onTap: () => abrirPantalla(
                            context,
                            paso.pantalla(),
                            color: m.color,
                            conFondo: !paso.escenario,
                          ),
                        ),
                      );
                    },
                  );
                  final guia = Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 110,
                        height: 160,
                        child: ZatiMascota(tam: 160, hablando: true),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: GloboTexto(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextoMaquina(
                                textoZati,
                                estilo: const TextStyle(
                                  fontSize: 16,
                                  height: 1.3,
                                  color: ColoresJuego.texto,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Pasos: $hechos/${m.pasos.length}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: m.color,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: hechos / m.pasos.length,
                                        minHeight: 10,
                                        color: m.color,
                                        backgroundColor: m.color.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                  if (horizontal) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(14, 4, 14, 0),
                          child: SizedBox(
                            height: math.min(170, cons.maxHeight * 0.42),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: guia,
                            ),
                          ),
                        ),
                        Expanded(child: pasos),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      Padding(padding: const EdgeInsets.all(12), child: guia),
                      Expanded(child: pasos),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaPaso extends StatelessWidget {
  const _TarjetaPaso({
    required this.paso,
    required this.numero,
    required this.color,
    required this.abierto,
    required this.estrellas,
    required this.actual,
    required this.horizontal,
    required this.onTap,
  });
  final PasoMision paso;
  final int numero;
  final Color color;
  final bool abierto;
  final int estrellas;
  final bool actual;
  final bool horizontal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final base = abierto ? paso.tipo.color : Colors.grey.shade500;
    final icono = Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(colors: [aclarar(base, 0.25), base]),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: oscurecer(base, 0.3), offset: const Offset(0, 3)),
        ],
      ),
      child: Icon(
        abierto ? paso.tipo.icono : Icons.lock_rounded,
        color: Colors.white,
        size: 30,
      ),
    );
    final textos = [
      Text(
        'Paso $numero · ${paso.tipo.nombre}',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: base,
        ),
      ),
      Text(
        paso.titulo,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: horizontal ? TextAlign.center : TextAlign.start,
        style: const TextStyle(
          fontSize: 16.5,
          fontWeight: FontWeight.w700,
          color: ColoresJuego.texto,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 4),
      estrellas > 0
          ? FilaEstrellas(estrellas, tam: 22)
          : Text(
              abierto ? (actual ? '¡Juega ahora!' : 'Disponible') : 'Bloqueado',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: abierto ? color : Colors.grey,
              ),
            ),
    ];
    final tarjeta = Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: abierto ? 1 : 0.8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: actual ? const Color(0xFFFFC107) : Colors.white,
          width: actual ? 4 : 3,
        ),
        boxShadow: [
          BoxShadow(color: oscurecer(base, 0.35), offset: const Offset(0, 5)),
          if (actual)
            BoxShadow(
              color: const Color(0xFFFFC107).withValues(alpha: 0.6),
              blurRadius: 16,
            ),
        ],
      ),
      child: horizontal
          ? FittedBox(
              fit: BoxFit.scaleDown,
              child: SizedBox(
                width: 170,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [icono, const SizedBox(height: 6), ...textos],
                ),
              ),
            )
          : Row(
              children: [
                icono,
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: textos,
                  ),
                ),
                const Icon(
                  Icons.play_circle_fill_rounded,
                  size: 34,
                  color: moradoBanner,
                ),
              ],
            ),
    );
    return Entrada(
      indice: numero,
      desde: horizontal ? const Offset(60, 0) : const Offset(0, 40),
      child: Rebote(
        onTap: abierto
            ? onTap
            : () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: moradoBanner,
                  content: Text(
                    '🔒 Completa el paso anterior primero.',
                    style: TextStyle(fontSize: 16, fontFamily: fuenteJuego),
                  ),
                ),
              ),
        child: actual
            ? Movimiento(
                tipo: TipoMovimiento.flotar,
                intensidad: 0.6,
                child: tarjeta,
              )
            : tarjeta,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logros (versión aventura)
// ---------------------------------------------------------------------------

class PantallaLogrosAventura extends StatelessWidget {
  const PantallaLogrosAventura({super.key});
  @override
  Widget build(BuildContext context) {
    final p = ProgresoScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const EncabezadoAventura(titulo: 'Mis logros'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(14),
                children: [
                  Center(
                    child: GloboTexto(
                      colita: false,
                      child: Text(
                        '⭐ ${p.totalEstrellas} de ${p.estrellasPosibles} estrellas',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      for (var i = 0; i < insigniasJuego.length; i++)
                        Entrada(
                          indice: i,
                          child: Container(
                            width: 250,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color:
                                    p.insignias.contains(insigniasJuego[i].id)
                                        ? insigniasJuego[i].color
                                        : Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor:
                                      p.insignias.contains(insigniasJuego[i].id)
                                          ? insigniasJuego[i].color
                                          : const Color(0xFFE6E3F0),
                                  child: Icon(
                                    p.insignias.contains(insigniasJuego[i].id)
                                        ? insigniasJuego[i].icono
                                        : Icons.lock_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        insigniasJuego[i].nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        insigniasJuego[i].descripcion,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
