import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'aventura.dart';
import 'comunes.dart';

/// Lienzo de tamaño fijo (860×480) que se escala para caber en cualquier
/// pantalla. Así cada pantalla de la misión conserva la distribución de los
/// bocetos en teléfonos y tabletas. El fondo cubre toda la pantalla.
const anchoEscenario = 860.0;
const altoEscenario = 480.0;

class Escenario extends StatelessWidget {
  const Escenario({
    super.key,
    required this.children,
    this.velo = 0.0,
    this.colorVelo = Colors.white,
  });

  /// Elementos colocados con [Positioned] en coordenadas del lienzo.
  final List<Widget> children;
  final double velo;
  final Color colorVelo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoBosque(
        velo: 0,
        child: Stack(
          children: [
            if (velo > 0)
              Positioned.fill(
                child: ColoredBox(color: colorVelo.withValues(alpha: velo)),
              ),
            SafeArea(
              child: SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: anchoEscenario,
                    height: altoEscenario,
                    child: Stack(clipBehavior: Clip.none, children: children),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Botón de regresar en la esquina superior izquierda del lienzo.
class BotonVolverEscena extends StatelessWidget {
  const BotonVolverEscena({super.key});
  @override
  Widget build(BuildContext context) => Positioned(
        left: 8,
        top: 8,
        child: BotonRedondo(
          icono: Icons.arrow_back_rounded,
          tam: 50,
          etiqueta: 'Regresar',
          onTap: () => Navigator.of(context).maybePop(),
        ),
      );
}

/// Pestaña tipo píldora (¿Qué es?, ¿Para qué sirve?, ...).
class Pestana extends StatelessWidget {
  const Pestana({
    super.key,
    required this.texto,
    required this.icono,
    required this.color,
    required this.activa,
    required this.onTap,
    this.vista = false,
  });
  final String texto;
  final IconData icono;
  final Color color;
  final bool activa;
  final bool vista;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Rebote(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.fromLTRB(6, 5, 12, 5),
        decoration: BoxDecoration(
          color: activa ? color : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: activa ? Colors.white : color.withValues(alpha: 0.7),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: oscurecer(color, 0.35),
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activa ? Colors.white : color,
              ),
              child: Icon(
                icono,
                size: 17,
                color: activa ? color : Colors.white,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: activa ? Colors.white : ColoresJuego.texto,
              ),
            ),
            if (vista && !activa) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.check_circle_rounded,
                size: 16,
                color: ColoresJuego.correcto,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Las 4 pestañas usadas en las explicaciones.
class InfoPestana {
  const InfoPestana(this.texto, this.icono, this.color);
  final String texto;
  final IconData icono;
  final Color color;
}

const pestanasExplicacion = [
  InfoPestana('¿Qué es?', Icons.question_mark_rounded, Color(0xFFFFAA00)),
  InfoPestana('¿Para qué sirve?', Icons.my_location_rounded, Color(0xFF00A6FB)),
  InfoPestana('¿Cómo funciona?', Icons.settings_rounded, Color(0xFF2DB84C)),
  InfoPestana('En la vida diaria', Icons.home_rounded, Color(0xFFFF6B3D)),
];

/// Etiqueta blanca con ícono, título y subtítulo (Nariz, Corazón, ...).
class EtiquetaParte extends StatelessWidget {
  const EtiquetaParte({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.color,
    this.icono,
    this.resaltar = false,
    this.onTap,
    this.ancho = 170,
    this.oculta = false,
  });
  final String titulo;
  final String? subtitulo;
  final Color color;
  final Widget? icono;
  final bool resaltar;
  final VoidCallback? onTap;
  final double ancho;

  /// Si es true, solo se ve el ícono y “¿?”: el nombre se descubre al tocarla
  /// (así hay menos texto en pantalla y el alumno explora).
  final bool oculta;

  @override
  Widget build(BuildContext context) {
    if (oculta) {
      return Semantics(
        button: true,
        label: 'Descubre: $titulo',
        child: Rebote(
          onTap: onTap,
          child: Movimiento(
            tipo: TipoMovimiento.latir,
            child: Container(
              width: ancho,
              padding: const EdgeInsets.fromLTRB(6, 6, 8, 6),
              decoration: BoxDecoration(
                color: aclarar(color, 0.88),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color, width: 2.5),
                boxShadow: [BoxShadow(color: oscurecer(color, 0.3).withValues(alpha: 0.6), offset: const Offset(0, 3))],
              ),
              child: Row(children: [
                if (icono != null) ...[
                  SizedBox(width: 30, height: 30, child: icono),
                  const SizedBox(width: 5),
                ],
                Expanded(
                  child: Text('¿? 👆', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: oscurecer(color, 0.15))),
                ),
              ]),
            ),
          ),
        ),
      );
    }
    final tarjeta = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: ancho,
      padding: const EdgeInsets.fromLTRB(6, 5, 8, 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: resaltar ? color : color.withValues(alpha: 0.45),
          width: resaltar ? 3.5 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: oscurecer(color, 0.3).withValues(alpha: 0.6),
            offset: const Offset(0, 3),
          ),
          if (resaltar)
            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 14),
        ],
      ),
      child: Row(
        children: [
          if (icono != null) ...[
            SizedBox(width: 30, height: 30, child: icono),
            const SizedBox(width: 5),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    titulo,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: oscurecer(color, 0.1),
                      height: 1.1,
                    ),
                  ),
                ),
                if (subtitulo != null)
                  Text(
                    subtitulo!,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.08,
                      color: ColoresJuego.texto,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
    return Rebote(
      onTap: onTap,
      child: resaltar ? Transform.scale(scale: 1.05, child: tarjeta) : tarjeta,
    );
  }
}

/// Líneas que unen etiquetas con partes del dibujo (coordenadas del lienzo).
class Conectores extends StatelessWidget {
  const Conectores(this.lineas, {super.key, this.animar = true});
  final List<(Offset, Offset, Color)> lineas;
  final bool animar;
  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: IgnorePointer(
          child: Reloj(
            builder: (_, t) =>
                CustomPaint(painter: _PintorConectores(lineas, animar ? t : 0)),
          ),
        ),
      );
}

class _PintorConectores extends CustomPainter {
  _PintorConectores(this.lineas, this.t);
  final List<(Offset, Offset, Color)> lineas;
  final double t;
  @override
  void paint(Canvas c, Size s) {
    for (var i = 0; i < lineas.length; i++) {
      final (a, b, color) = lineas[i];
      c.drawLine(
        a,
        b,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 5
          ..strokeCap = StrokeCap.round,
      );
      c.drawLine(
        a,
        b,
        Paint()
          ..color = color
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
      c.drawCircle(b, 6, Paint()..color = Colors.white);
      c.drawCircle(b, 4, Paint()..color = color);
      if (t > 0) {
        final u = (t * 0.5 + i * 0.23) % 1;
        c.drawCircle(Offset.lerp(a, b, u)!, 3.2, Paint()..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorConectores old) => true;
}

/// Zati con globo de texto, para el lienzo.
class ZatiConGlobo extends StatefulWidget {
  const ZatiConGlobo({
    super.key,
    required this.texto,
    this.tamZati = 190,
    this.anchoGlobo = 190,
    this.altoGlobo,
    this.tamLetra = 15.5,
    this.emocion = EmocionCora.feliz,
    this.globoArriba = false,
  });
  final String texto;
  final double tamZati;
  final double anchoGlobo;
  final double? altoGlobo;
  final double tamLetra;
  final EmocionCora emocion;

  /// Si es true, el globo va arriba de Zati; si no, a su derecha.
  final bool globoArriba;

  @override
  State<ZatiConGlobo> createState() => _ZatiConGloboState();
}

/// Divide un texto largo en partes cortas (1 o 2 oraciones) para que los
/// niños lean poco a poco.
List<String> partesDeTexto(String texto, {int maximo = 135}) {
  final partes = <String>[];
  for (final parrafo in texto.split(RegExp(r'\n\s*\n'))) {
    final oraciones = parrafo.trim().split(RegExp(r'(?<=[.!?…])\s+(?=[¡¿A-ZÁÉÍÓÚÑ0-9“"(])'));
    var actual = '';
    for (final o in oraciones) {
      if (o.trim().isEmpty) continue;
      if (actual.isEmpty) {
        actual = o.trim();
      } else if (actual.length + o.length + 1 <= maximo) {
        actual = '$actual ${o.trim()}';
      } else {
        partes.add(actual);
        actual = o.trim();
      }
    }
    if (actual.isNotEmpty) partes.add(actual);
  }
  return partes.isEmpty ? [texto] : partes;
}

class _ZatiConGloboState extends State<ZatiConGlobo> {
  bool _hablando = false;
  int _pagina = 0;
  late List<String> _partes = partesDeTexto(widget.texto);

  @override
  void didUpdateWidget(ZatiConGlobo old) {
    super.didUpdateWidget(old);
    if (old.texto != widget.texto) {
      _partes = partesDeTexto(widget.texto);
      _pagina = 0;
    }
  }

  void _hablar(bool v) {
    if (v == _hablando) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _hablando = v);
    });
  }

  void _siguiente() => setState(() => _pagina = (_pagina + 1) % _partes.length);

  @override
  Widget build(BuildContext context) {
    final texto = TextoMaquina(
      _partes[_pagina],
      key: ValueKey('${widget.texto}#$_pagina'),
      letrasPorSegundo: 55,
      estilo: TextStyle(
        fontSize: widget.tamLetra,
        height: 1.3,
        color: ColoresJuego.texto,
      ),
      alCambiar: _hablar,
    );
    // Si el texto es largo, se lee por partes con el botón ▶.
    final boton = _partes.length < 2
        ? null
        : Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: 'Seguir leyendo',
              child: Rebote(
                onTap: _siguiente,
                child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: moradoBanner, borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    _pagina < _partes.length - 1 ? '▶ ${_pagina + 1}/${_partes.length}' : '↺ ${_pagina + 1}/${_partes.length}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12.5),
                  ),
                ),
              ),
            ),
          );
    final contenido = widget.altoGlobo == null
        ? Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [texto, if (boton != null) boton])
        : Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(child: SingleChildScrollView(child: texto)),
            if (boton != null) boton,
          ]);
    final globo = SizedBox(
      width: widget.anchoGlobo,
      height: widget.altoGlobo,
      child: GestureDetector(
        onTap: _partes.length < 2 ? null : _siguiente,
        child: GloboTexto(colita: !widget.globoArriba, child: contenido),
      ),
    );
    final zati = SizedBox(
      width: widget.tamZati * 0.72,
      height: widget.tamZati,
      child: ZatiMascota(
        tam: widget.tamZati,
        emocion: widget.emocion,
        hablando: _hablando,
      ),
    );
    if (widget.globoArriba) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [globo, const SizedBox(height: 4), zati],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [zati, const SizedBox(width: 10), globo],
    );
  }
}

/// Puntitos de avance + flechas.
class PuntosAvance extends StatelessWidget {
  const PuntosAvance({
    super.key,
    required this.total,
    required this.actual,
    this.onAnterior,
    this.onSiguiente,
  });
  final int total;
  final int actual;
  final VoidCallback? onAnterior;
  final VoidCallback? onSiguiente;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BotonRedondo(
          icono: Icons.chevron_left_rounded,
          tam: 42,
          etiqueta: 'Anterior',
          onTap: onAnterior,
        ),
        const SizedBox(width: 10),
        for (var i = 0; i < total; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == actual ? 16 : 11,
            height: i == actual ? 16 : 11,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == actual
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
              border: Border.all(color: moradoBanner, width: 2.5),
            ),
          ),
        const SizedBox(width: 10),
        BotonRedondo(
          icono: Icons.chevron_right_rounded,
          tam: 42,
          etiqueta: 'Adelante',
          onTap: onSiguiente,
        ),
      ],
    );
  }
}

/// Botón verde "Siguiente" de los bocetos.
class BotonSiguiente extends StatelessWidget {
  const BotonSiguiente({
    super.key,
    required this.onTap,
    this.texto = 'Siguiente',
    this.latir = true,
  });
  final VoidCallback? onTap;
  final String texto;
  final bool latir;
  @override
  Widget build(BuildContext context) {
    final b = Tooltip(
      message: texto,
      child: BotonJuego(
        texto: texto,
        icono: Icons.play_arrow_rounded,
        color: const Color(0xFF2DB84C),
        onTap: onTap,
      ),
    );
    return latir && onTap != null
        ? Movimiento(tipo: TipoMovimiento.latir, intensidad: 0.25, child: b)
        : b;
  }
}

/// Panel blanco con encabezado de color.
class PanelInfo extends StatelessWidget {
  const PanelInfo({
    super.key,
    required this.titulo,
    required this.color,
    required this.child,
    this.icono,
    this.resaltar = false,
    this.padding = const EdgeInsets.all(10),
  });
  final String titulo;
  final Color color;
  final Widget child;
  final IconData? icono;
  final bool resaltar;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: resaltar ? color : Colors.white,
          width: resaltar ? 4 : 3,
        ),
        boxShadow: [
          BoxShadow(
            color: oscurecer(color, 0.35).withValues(alpha: 0.7),
            offset: const Offset(0, 5),
          ),
          if (resaltar)
            BoxShadow(color: color.withValues(alpha: 0.55), blurRadius: 18),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, aclarar(color, 0.25)]),
            ),
            child: Row(
              children: [
                if (icono != null) ...[
                  Icon(icono, color: Colors.white, size: 22),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: Padding(padding: padding, child: child),
          ),
        ],
      ),
    );
  }
}

/// Etiqueta pequeña de sección ("2. Conoce el corazón y los vasos").
class EtiquetaSeccion extends StatelessWidget {
  const EtiquetaSeccion(this.texto, {super.key});
  final String texto;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: moradoBanner,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
          ),
          border: Border.all(color: Colors.white, width: 2.5),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

/// Ventana de información con Zati.
Future<void> ventanaZati(
  BuildContext context, {
  required String titulo,
  required String texto,
  Color color = moradoBanner,
  EmocionCora emocion = EmocionCora.sorprendida,
}) {
  return showDialog(
    useRootNavigator: false,
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: math.max(220, MediaQuery.sizeOf(ctx).height - 30),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: color, width: 4),
            boxShadow: [
              BoxShadow(
                color: oscurecer(color, 0.3),
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ZatiMascota(tam: 110, emocion: emocion, hablando: true),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          texto,
                          style: const TextStyle(fontSize: 16.5, height: 1.35),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: BotonJuego(
                        texto: '¡Entendido!',
                        icono: Icons.check_rounded,
                        color: color,
                        onTap: () => Navigator.of(ctx).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
