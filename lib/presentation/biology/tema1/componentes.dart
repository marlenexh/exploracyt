import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'escenario.dart';

/// Piezas reutilizables para las pantallas de las misiones (todas sobre el
/// lienzo fijo de [Escenario], así se ven igual en celular y computadora).

int estrellasPorExploracion(int vistos, int total) =>
    vistos >= total ? 3 : (vistos * 2 >= total ? 2 : 1);

/// Guarda las estrellas, muestra la celebración y regresa al flujo de la misión.
Future<void> terminarPaso(
  BuildContext context, {
  required String actividad,
  required int estrellas,
  required String titulo,
  required String mensaje,
}) async {
  await otorgarEstrellas(context,
      actividad: actividad,
      estrellas: estrellas,
      titulo: titulo,
      mensaje: mensaje);
  if (context.mounted) Navigator.of(context).pop();
}

// ===========================================================================
// Elegir acciones saludables
// ===========================================================================

class Accion {
  const Accion(this.icono, this.texto, this.saludable, this.porque);
  final IconData icono;
  final String texto;
  final bool saludable;
  final String porque;
}

/// Capa a pantalla completa (dentro del lienzo) donde el alumno toca las
/// acciones saludables y comprueba. Llama a [onTerminar] con los errores.
class CapaAcciones extends StatefulWidget {
  const CapaAcciones({
    super.key,
    required this.titulo,
    required this.instruccion,
    required this.acciones,
    required this.onTerminar,
    this.color = ColoresJuego.correcto,
  });
  final String titulo;
  final String instruccion;
  final List<Accion> acciones;
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<CapaAcciones> createState() => _CapaAccionesState();
}

class _CapaAccionesState extends State<CapaAcciones> {
  final _elegidas = <int>{};
  bool _revisado = false;
  int _errores = 0;
  late final List<int> _orden = List.generate(widget.acciones.length, (i) => i)
    ..shuffle(math.Random(3));

  bool get _perfecto =>
      _revisado &&
      [
        for (var i = 0; i < widget.acciones.length; i++)
          widget.acciones[i].saludable == _elegidas.contains(i)
      ].every((x) => x);

  void _comprobar() {
    setState(() {
      _revisado = true;
      if (!_perfecto) _errores++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mensaje = !_revisado
        ? widget.instruccion
        : _perfecto
            ? '¡Excelente! Elegiste todas las acciones saludables. Toca una tarjeta para saber por qué.'
            : 'Revisa las tarjetas marcadas. Alguna no es saludable o te faltó alguna saludable.';
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: Entrada(
          child: Container(
            width: 800,
            height: 440,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: widget.color, width: 4),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 70, height: 86, child: ZatiMascota(tam: 86)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.titulo,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                  color: oscurecer(widget.color, 0.1))),
                          Text(mensaje,
                              style:
                                  const TextStyle(fontSize: 14.5, height: 1.2)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1.75,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [for (final i in _orden) _tarjeta(i)],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Elegidas: ${_elegidas.length}',
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (_perfecto)
                      Tooltip(
                        message: 'Terminar',
                        child: BotonJuego(
                          texto: 'Terminar',
                          icono: Icons.check_rounded,
                          color: ColoresJuego.correcto,
                          onTap: () => widget.onTerminar(_errores),
                        ),
                      )
                    else
                      Tooltip(
                        message: 'Comprobar acciones',
                        child: BotonJuego(
                          texto: 'Comprobar',
                          icono: Icons.fact_check_rounded,
                          color: const Color(0xFFF5B400),
                          onTap: _elegidas.isEmpty ? null : _comprobar,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tarjeta(int i) {
    final a = widget.acciones[i];
    final elegida = _elegidas.contains(i);
    Color borde = elegida ? widget.color : Colors.black12;
    IconData? marca;
    if (_revisado) {
      if (elegida && a.saludable) {
        borde = ColoresJuego.correcto;
        marca = Icons.check_circle_rounded;
      } else if (elegida && !a.saludable) {
        borde = ColoresJuego.incorrecto;
        marca = Icons.cancel_rounded;
      } else if (!elegida && a.saludable && !_perfecto) {
        borde = const Color(0xFFF5B400);
        marca = Icons.help_rounded;
      }
    }
    return Rebote(
      onTap: () {
        if (_perfecto) {
          ventanaZati(context,
              titulo: a.texto,
              texto: a.porque,
              color: a.saludable
                  ? ColoresJuego.correcto
                  : ColoresJuego.incorrecto);
          return;
        }
        setState(() {
          _revisado = false;
          elegida ? _elegidas.remove(i) : _elegidas.add(i);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color:
              elegida ? aclarar(widget.color, 0.85) : const Color(0xFFF8F7FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: borde, width: elegida || marca != null ? 3 : 1.5),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                Icon(a.icono, size: 34, color: oscurecer(widget.color, 0.1)),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(a.texto,
                        style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            height: 1.1))),
              ],
            ),
            if (marca != null)
              Positioned(
                  right: 0, top: 0, child: Icon(marca, size: 20, color: borde)),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// Pantalla de explicación con 4 pestañas (¿Qué es?, ¿Para qué sirve?, ...)
// ===========================================================================

class EtiquetaExplicacion {
  const EtiquetaExplicacion({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.icono,
    required this.pos,
    required this.punto,
    required this.detalle,
    this.ancho = 142,
  });
  final String id;
  final String titulo;
  final String subtitulo;
  final Color color;
  final Widget icono;

  /// Esquina superior izquierda de la etiqueta en el lienzo.
  final Offset pos;

  /// Punto del dibujo al que apunta.
  final Offset punto;
  final String detalle;
  final double ancho;
}

class PantallaExplicacion extends StatefulWidget {
  const PantallaExplicacion({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.textos,
    required this.pintor,
    required this.etiquetas,
    required this.mensajeFinal,
    this.panel,
    this.resaltar = const {},
    this.conPestanas = true,
  });
  final String actividad;
  final String seccion;
  final String titulo;
  final Color color;

  /// Si es false, no hay pestañas y Zati dice solo `textos.first`.
  final bool conPestanas;

  /// Texto de Zati para cada pestaña (4).
  final List<String> textos;

  /// Dibujo central: recibe tiempo, pestaña y parte resaltada.
  final CustomPainter Function(double t, int pestana, String? resaltada) pintor;
  final List<EtiquetaExplicacion> etiquetas;
  final String mensajeFinal;

  /// Panel derecho opcional (x 650–854).
  final Widget Function(int pestana)? panel;

  /// Partes resaltadas por pestaña.
  final Map<int, Set<String>> resaltar;

  @override
  State<PantallaExplicacion> createState() => _PantallaExplicacionState();
}

class _PantallaExplicacionState extends State<PantallaExplicacion> {
  int _pestana = 0;
  final _vistas = <int>{0};
  final _partes = <String>{};
  String? _ultima;

  void _irA(int i) => setState(() {
        _pestana = i.clamp(0, 3);
        _vistas.add(_pestana);
        _ultima = null;
      });

  @override
  Widget build(BuildContext context) {
    final resaltadas = widget.resaltar[_pestana] ?? const <String>{};
    final conPanel = widget.panel != null;
    return Escenario(
      velo: 0.12,
      colorVelo: widget.color,
      children: [
        Positioned.fill(
          child: Reloj(
              builder: (_, t) =>
                  CustomPaint(painter: widget.pintor(t, _pestana, _ultima))),
        ),
        Conectores([
          for (final e in widget.etiquetas)
            (
              Offset(e.pos.dx < e.punto.dx ? e.pos.dx + e.ancho : e.pos.dx,
                  e.pos.dy + 22),
              e.punto,
              e.color
            ),
        ], animar: _pestana == 2),
        for (final e in widget.etiquetas)
          Positioned(
            left: e.pos.dx,
            top: e.pos.dy,
            child: EtiquetaParte(
              titulo: e.titulo,
              subtitulo: e.subtitulo,
              color: e.color,
              ancho: e.ancho,
              icono: e.icono,
              resaltar: resaltadas.contains(e.id) ||
                  _partes.contains(e.id) ||
                  _ultima == e.id,
              onTap: () {
                setState(() {
                  _partes.add(e.id);
                  _ultima = e.id;
                });
                ventanaZati(context,
                    titulo: e.titulo, texto: e.detalle, color: e.color);
              },
            ),
          ),
        const BotonVolverEscena(),
        Positioned(
          left: 64,
          top: 10,
          width: conPanel ? 580 : 790,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                EtiquetaSeccion(widget.seccion),
                const SizedBox(width: 8),
                if (!widget.conPestanas)
                  BannerTitulo(widget.titulo,
                      tam: 22, color: oscurecer(widget.color, 0.05)),
                if (widget.conPestanas)
                  for (var i = 0; i < 4; i++) ...[
                    Pestana(
                      texto: pestanasExplicacion[i].texto,
                      icono: pestanasExplicacion[i].icono,
                      color: pestanasExplicacion[i].color,
                      activa: i == _pestana,
                      vista: _vistas.contains(i),
                      onTap: () => _irA(i),
                    ),
                    const SizedBox(width: 5),
                  ],
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 58,
          child: ZatiConGlobo(
            texto: widget.textos[_pestana],
            tamZati: 170,
            anchoGlobo: 238,
            altoGlobo: 200,
            tamLetra: 14.5,
            globoArriba: true,
          ),
        ),
        if (conPanel)
          Positioned(
              left: 650,
              top: 52,
              width: 204,
              height: 360,
              child: widget.panel!(_pestana)),
        if (widget.conPestanas)
          Positioned(
            left: 300,
            top: 436,
            child: PuntosAvance(
              total: 4,
              actual: _pestana,
              onAnterior: _pestana > 0 ? () => _irA(_pestana - 1) : null,
              onSiguiente: _pestana < 3 ? () => _irA(_pestana + 1) : null,
            ),
          ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: () => terminarPaso(
              context,
              actividad: widget.actividad,
              estrellas: estrellasPorExploracion(
                  (widget.conPestanas ? _vistas.length : 0) + _partes.length,
                  (widget.conPestanas ? 4 : 0) + widget.etiquetas.length),
              titulo: '¡${widget.titulo}!',
              mensaje: widget.mensajeFinal,
            ),
          ),
        ),
      ],
    );
  }
}

/// Panel con una lista de puntos (para el lado derecho de las explicaciones).
class PanelPuntos extends StatelessWidget {
  const PanelPuntos(
      {super.key,
      required this.titulo,
      required this.color,
      required this.puntos,
      this.icono});
  final String titulo;
  final Color color;
  final List<(IconData, String)> puntos;
  final IconData? icono;
  @override
  Widget build(BuildContext context) => PanelInfo(
        titulo: titulo,
        icono: icono,
        color: color,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (final (ic, txt) in puntos)
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 13,
                          backgroundColor: aclarar(color, 0.8),
                          child: Icon(ic, size: 16, color: color)),
                      const SizedBox(width: 6),
                      Expanded(
                          child: Text(txt,
                              style: const TextStyle(
                                  fontSize: 12.5, height: 1.18))),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}

// ===========================================================================
// Pantalla de tarjetas que se voltean (ambiente, hábitos)
// ===========================================================================

class TarjetaInfo {
  const TarjetaInfo(this.icono, this.titulo, this.texto);
  final IconData icono;
  final String titulo;
  final String texto;
}

class GrupoTarjetas {
  const GrupoTarjetas(this.titulo, this.color, this.icono, this.tarjetas);
  final String titulo;
  final Color color;
  final IconData icono;
  final List<TarjetaInfo> tarjetas;
}

class PantallaTarjetas extends StatefulWidget {
  const PantallaTarjetas({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.textoZati,
    required this.grupos,
    required this.mensajeFinal,
  });
  final String actividad;
  final String seccion;
  final String titulo;
  final Color color;
  final String textoZati;
  final List<GrupoTarjetas> grupos;
  final String mensajeFinal;
  @override
  State<PantallaTarjetas> createState() => _PantallaTarjetasState();
}

class _PantallaTarjetasState extends State<PantallaTarjetas> {
  final _volteadas = <String>{};

  int get _total => widget.grupos.fold(0, (a, g) => a + g.tarjetas.length);

  @override
  Widget build(BuildContext context) {
    final ancho = 606 / widget.grupos.length;
    return Escenario(
      velo: 0.15,
      colorVelo: widget.color,
      children: [
        const BotonVolverEscena(),
        Positioned(left: 64, top: 14, child: EtiquetaSeccion(widget.seccion)),
        Positioned(
          left: 250,
          top: 4,
          width: 600,
          child: Center(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: BannerTitulo(widget.titulo,
                      tam: 23, color: oscurecer(widget.color, 0.05)))),
        ),
        Positioned(
          left: 0,
          top: 62,
          child: ZatiConGlobo(
            texto: widget.textoZati,
            tamZati: 165,
            anchoGlobo: 232,
            altoGlobo: 210,
            tamLetra: 14.5,
            globoArriba: true,
          ),
        ),
        for (var g = 0; g < widget.grupos.length; g++)
          Positioned(
            left: 244 + g * ancho,
            top: 62,
            width: ancho - 8,
            height: 352,
            child: _grupo(widget.grupos[g]),
          ),
        Positioned(
          left: 250,
          top: 430,
          child: Text(
            'Tarjetas descubiertas: ${_volteadas.length}/$_total · Toca cada tarjeta',
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 4)]),
          ),
        ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: () => terminarPaso(
              context,
              actividad: widget.actividad,
              estrellas: estrellasPorExploracion(_volteadas.length, _total),
              titulo: '¡${widget.titulo}!',
              mensaje: widget.mensajeFinal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _grupo(GrupoTarjetas g) {
    final columnas = g.tarjetas.length > 3 ? 2 : 1;
    final filas = (g.tarjetas.length / columnas).ceil();
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: g.color, width: 3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(g.icono, color: g.color, size: 24),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(g.titulo,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: oscurecer(g.color, 0.15)))),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final ancho = (c.maxWidth - 6 * (columnas - 1)) / columnas;
                final alto = (c.maxHeight - 6 * (filas - 1)) / filas;
                return GridView.count(
                  crossAxisCount: columnas,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  childAspectRatio: ancho / alto.clamp(40.0, 400.0),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [for (final t in g.tarjetas) _tarjeta(g, t)],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _tarjeta(GrupoTarjetas g, TarjetaInfo t) {
    final clave = '${g.titulo}/${t.titulo}';
    final volteada = _volteadas.contains(clave);
    return Rebote(
      onTap: () => setState(() => _volteadas.add(clave)),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: Container(
          key: ValueKey(volteada),
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: volteada ? aclarar(g.color, 0.85) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: g.color, width: 2),
          ),
          child: volteada
              ? Center(
                  child: SingleChildScrollView(
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(
                            text: '${t.titulo}: ',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        TextSpan(text: t.texto),
                      ]),
                      style: const TextStyle(fontSize: 11.8, height: 1.15),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Icon(t.icono, color: g.color, size: 30),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(t.titulo,
                            style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                height: 1.1))),
                    const Icon(Icons.touch_app_rounded,
                        size: 16, color: Colors.black26),
                  ],
                ),
        ),
      ),
    );
  }
}
