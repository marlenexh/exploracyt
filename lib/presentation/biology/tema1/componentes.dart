import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'aventura.dart';
import 'comunes.dart';
import 'escenario.dart';
import '../../ciencia/glosario_chips.dart';

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
        // Palabras difíciles del texto, explicadas por Zati.
        Positioned(
          left: 4,
          top: 438,
          width: 292,
          child: ChipsGlosario(texto: widget.textos[_pestana], color: widget.color),
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
  const TarjetaInfo(this.icono, this.titulo, this.texto, {this.emoji});
  final IconData icono;
  final String titulo;
  final String texto;

  /// Dibujo opcional (emoji) para la ilustración grande de la tarjeta.
  final String? emoji;
}

class GrupoTarjetas {
  const GrupoTarjetas(this.titulo, this.color, this.icono, this.tarjetas);
  final String titulo;
  final Color color;
  final IconData icono;
  final List<TarjetaInfo> tarjetas;
}

/// Tarjetas para descubrir: cada una se abre en grande con una ilustración
/// animada, la información y la pregunta “¿Ya lo sabías?”.
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
  State<PantallaTarjetas> createState() => PantallaTarjetasState();
}

class PantallaTarjetasState extends State<PantallaTarjetas> {
  /// Tarjetas vistas y la reacción del alumno (true: “¡No lo sabía!”).
  final reacciones = <String, bool>{};

  /// Tarjeta abierta en grande (índice en [_todas]).
  int? abierta;

  late final List<(GrupoTarjetas, TarjetaInfo)> _todas = [
    for (final g in widget.grupos)
      for (final t in g.tarjetas) (g, t)
  ];

  int get _total => _todas.length;
  int get vistas => reacciones.length;
  String _clave(GrupoTarjetas g, TarjetaInfo t) => '${g.titulo}/${t.titulo}';

  void abrir(int i) => setState(() => abierta = i);
  void cerrar() => setState(() => abierta = null);

  void reaccionar(bool nuevo) {
    final i = abierta;
    if (i == null) return;
    final (g, t) = _todas[i];
    setState(() {
      reacciones[_clave(g, t)] = nuevo;
      // Pasa a la siguiente tarjeta sin ver, o cierra si ya vio todas.
      final siguiente = [for (var k = 1; k <= _total; k++) (i + k) % _total].where((k) => !reacciones.containsKey(_clave(_todas[k].$1, _todas[k].$2)));
      abierta = siguiente.isEmpty ? null : siguiente.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ancho = 606 / widget.grupos.length;
    final nuevos = reacciones.values.where((v) => v).length;
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
          child: Center(child: FittedBox(fit: BoxFit.scaleDown, child: BannerTitulo(widget.titulo, tam: 23, color: oscurecer(widget.color, 0.05)))),
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
          width: 420,
          child: Row(children: [
            for (var k = 0; k < _total; k++)
              Padding(
                padding: const EdgeInsets.only(right: 3),
                child: Icon(k < vistas ? Icons.star_rounded : Icons.star_outline_rounded, size: 18, color: k < vistas ? const Color(0xFFFFD54F) : Colors.white70),
              ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                vistas == 0 ? 'Toca una tarjeta para descubrirla' : '$vistas de $_total · 🤩 $nuevos datos nuevos',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, shadows: [Shadow(blurRadius: 4)]),
              ),
            ),
          ]),
        ),
        Positioned(
          left: 680,
          top: 422,
          child: BotonSiguiente(
            onTap: () => terminarPaso(
              context,
              actividad: widget.actividad,
              estrellas: estrellasPorExploracion(vistas, _total),
              titulo: '¡${widget.titulo}!',
              mensaje: widget.mensajeFinal,
            ),
          ),
        ),
        if (abierta != null) ...[
          Positioned.fill(child: GestureDetector(onTap: cerrar, child: Container(color: const Color(0x99000000)))),
          Positioned(
            left: 110,
            top: 52,
            width: 640,
            height: 380,
            child: _TarjetaGrande(
              key: ValueKey(abierta),
              grupo: _todas[abierta!].$1,
              tarjeta: _todas[abierta!].$2,
              numero: abierta! + 1,
              total: _total,
              reaccion: reacciones[_clave(_todas[abierta!].$1, _todas[abierta!].$2)],
              onReaccion: reaccionar,
              onCerrar: cerrar,
              onAnterior: () => abrir((abierta! - 1 + _total) % _total),
              onSiguiente: () => abrir((abierta! + 1) % _total),
            ),
          ),
        ],
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
              Expanded(child: Text(g.titulo, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: oscurecer(g.color, 0.15)))),
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
    final reaccion = reacciones[_clave(g, t)];
    final vista = reaccion != null;
    final indice = _todas.indexWhere((e) => identical(e.$2, t));
    return Rebote(
      onTap: () => abrir(indice),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        transitionBuilder: (child, anim) => AnimatedBuilder(
          animation: anim,
          child: child,
          builder: (_, hijo) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY((1 - anim.value) * math.pi / 2),
            child: hijo,
          ),
        ),
        child: Container(
          key: ValueKey(vista),
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            gradient: vista ? null : LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [aclarar(g.color, 0.12), oscurecer(g.color, 0.18)]),
            color: vista ? aclarar(g.color, 0.88) : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: vista ? g.color : Colors.white, width: 2),
            boxShadow: vista ? null : [BoxShadow(color: g.color.withValues(alpha: 0.45), blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Stack(children: [
            Row(
              children: [
                if (vista)
                  Text(t.emoji ?? (reaccion ? '🤩' : '😎'), style: const TextStyle(fontSize: 22))
                else
                  Reloj(
                    builder: (_, s) => Transform.translate(
                      offset: Offset(0, math.sin(s * 2.5 + indice) * 2),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: Color(0x33FFFFFF), shape: BoxShape.circle),
                        child: Icon(t.icono, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                const SizedBox(width: 6),
                Expanded(child: TextoSinCortar(t.titulo, color: vista ? oscurecer(g.color, 0.35) : Colors.white)),
              ],
            ),
            Positioned(
              right: 0,
              top: 0,
              child: vista
                  ? Icon(Icons.check_circle_rounded, size: 16, color: g.color)
                  : Reloj(
                      builder: (_, s) => Transform.scale(
                        scale: 1 + 0.15 * math.sin(s * 4 + indice).abs(),
                        child: Container(
                          width: 18,
                          height: 18,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(color: Color(0xFFFFD54F), shape: BoxShape.circle),
                          child: const Text('?', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF5D4037))),
                        ),
                      ),
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Tarjeta abierta en grande con ilustración animada.
class _TarjetaGrande extends StatelessWidget {
  const _TarjetaGrande({
    super.key,
    required this.grupo,
    required this.tarjeta,
    required this.numero,
    required this.total,
    required this.reaccion,
    required this.onReaccion,
    required this.onCerrar,
    required this.onAnterior,
    required this.onSiguiente,
  });
  final GrupoTarjetas grupo;
  final TarjetaInfo tarjeta;
  final int numero, total;
  final bool? reaccion;
  final ValueChanged<bool> onReaccion;
  final VoidCallback onCerrar, onAnterior, onSiguiente;

  @override
  Widget build(BuildContext context) {
    final c = grupo.color;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutBack,
      builder: (_, v, hijo) => Transform.scale(scale: 0.7 + 0.3 * v, child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 18, offset: Offset(0, 8))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(children: [
          // Ilustración
          Container(
            width: 230,
            decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [aclarar(c, 0.2), oscurecer(c, 0.25)])),
            child: Reloj(
              builder: (_, s) => Stack(alignment: Alignment.center, children: [
                for (var k = 0; k < 3; k++)
                  Container(
                    width: 120.0 + k * 40 + 10 * math.sin(s * 2 + k),
                    height: 120.0 + k * 40 + 10 * math.sin(s * 2 + k),
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withValues(alpha: 0.25 - k * 0.06), width: 3)),
                  ),
                for (var k = 0; k < 8; k++)
                  Transform.translate(
                    offset: Offset(math.cos(s * 0.8 + k * math.pi / 4) * 95, math.sin(s * 0.8 + k * math.pi / 4) * 95),
                    child: Icon(Icons.auto_awesome, size: 10.0 + (k % 3) * 4, color: Colors.white.withValues(alpha: 0.7)),
                  ),
                Transform.translate(
                  offset: Offset(0, math.sin(s * 2) * 6),
                  child: Transform.rotate(
                    angle: math.sin(s * 1.3) * 0.08,
                    child: Container(
                      width: 118,
                      height: 118,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: oscurecer(c, 0.4).withValues(alpha: 0.5), blurRadius: 12, offset: const Offset(0, 6))],
                      ),
                      child: tarjeta.emoji != null ? Text(tarjeta.emoji!, style: const TextStyle(fontSize: 62)) : Icon(tarjeta.icono, size: 66, color: c),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(12)),
                    child: Text('Tarjeta $numero de $total', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: oscurecer(c, 0.3))),
                  ),
                ),
              ]),
            ),
          ),
          // Información
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 10, 12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: aclarar(c, 0.85), borderRadius: BorderRadius.circular(10)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(grupo.icono, size: 15, color: oscurecer(c, 0.2)),
                      const SizedBox(width: 4),
                      Text(grupo.titulo, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: oscurecer(c, 0.25))),
                    ]),
                  ),
                  const Spacer(),
                  IconButton(tooltip: 'Cerrar', onPressed: onCerrar, icon: const Icon(Icons.close_rounded)),
                ]),
                Text(tarjeta.titulo, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 25, height: 1.05, color: oscurecer(c, 0.3))),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(tarjeta.texto, style: const TextStyle(fontSize: 17, height: 1.3, fontWeight: FontWeight.w600, color: ColoresJuego.texto)),
                  ),
                ),
                const SizedBox(height: 6),
                Text(reaccion == null ? '¿Ya lo sabías?' : (reaccion! ? '¡Aprendiste algo nuevo! 🤩' : '¡Eres un experto! 😎'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: ColoresJuego.texto)),
                const SizedBox(height: 4),
                Row(children: [
                  IconButton(tooltip: 'Anterior', onPressed: onAnterior, icon: Icon(Icons.chevron_left_rounded, color: c, size: 30)),
                  Expanded(child: _boton('🤩', '¡No lo sabía!', const Color(0xFFFF7043), reaccion == true, () => onReaccion(true))),
                  const SizedBox(width: 6),
                  Expanded(child: _boton('😎', '¡Ya lo sabía!', const Color(0xFF42A5F5), reaccion == false, () => onReaccion(false))),
                  IconButton(tooltip: 'Siguiente tarjeta', onPressed: onSiguiente, icon: Icon(Icons.chevron_right_rounded, color: c, size: 30)),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _boton(String emoji, String texto, Color color, bool activo, VoidCallback onTap) => Rebote(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: activo ? color : aclarar(color, 0.85),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color, width: 2),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('$emoji $texto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: activo ? Colors.white : oscurecer(color, 0.3))),
          ),
        ),
      );
}

/// Texto que reduce su tamaño si una palabra no cabe completa en el ancho,
/// para que nunca se parta a la mitad (p. ej. "reproduce-n").
class TextoSinCortar extends StatelessWidget {
  const TextoSinCortar(this.texto, {super.key, this.tam = 13.5, this.alineacion = TextAlign.start, this.color});
  final String texto;
  final double tam;
  final TextAlign alineacion;
  final Color? color;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        var t = tam;
        TextStyle estilo(double f) => DefaultTextStyle.of(context)
            .style
            .merge(TextStyle(fontSize: f, fontWeight: FontWeight.w700, height: 1.1, color: color));
        double anchoMax(double f) {
          var m = 0.0;
          for (final palabra in texto.split(RegExp(r'\s+'))) {
            final tp = TextPainter(
                text: TextSpan(text: palabra, style: estilo(f)),
                textDirection: TextDirection.ltr,
                textScaler: MediaQuery.textScalerOf(context))
              ..layout();
            if (tp.width > m) m = tp.width;
          }
          return m;
        }

        if (c.maxWidth.isFinite) {
          while (t > 9 && anchoMax(t) > c.maxWidth) {
            t -= 0.5;
          }
        }
        return Text(texto, textAlign: alineacion, style: estilo(t));
      });
}
