import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../tema1/aventura.dart' show BannerTitulo, GloboTexto, moradoBanner;
import '../tema1/componentes.dart' show terminarPaso;
import '../tema1/comunes.dart';
import '../tema1/contenido.dart' show PreguntaQuiz;
import '../tema1/escenario.dart';
import '../tema1/pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'motor.dart';
import '../../ciencia/barajar.dart';

/// Actividades genéricas, todas sobre el lienzo fijo de [Escenario].

int estrellasPorErrores(int errores, {int dos = 2}) => errores == 0 ? 3 : (errores <= dos ? 2 : 1);

Widget _globo(String texto, {double alto = 170}) => Positioned(
      left: 0,
      top: 62,
      child: ZatiConGlobo(texto: texto, tamZati: 165, anchoGlobo: 228, altoGlobo: alto, tamLetra: 14.5, globoArriba: true),
    );

Widget _encabezado(String seccion, String titulo, Color color) => Positioned(
      left: 64,
      top: 10,
      right: 8,
      child: Row(
        children: [
          EtiquetaSeccion(seccion),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: BannerTitulo(titulo, tam: 22, color: oscurecer(color, 0.05)),
            ),
          ),
        ],
      ),
    );

/// Tarjeta pequeña con emoji y texto (para arrastrar).
class FichaBio extends StatelessWidget {
  const FichaBio({super.key, required this.emoji, required this.texto, this.color = moradoBanner, this.ancho = 120, this.flotando = false});
  final String emoji;
  final String texto;
  final Color color;
  final double ancho;
  final bool flotando;
  @override
  Widget build(BuildContext context) => Container(
        width: ancho,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: flotando ? 0.3 : 0.12), blurRadius: flotando ? 12 : 3, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Emoji(emoji, tam: 22),
            const SizedBox(width: 4),
            Expanded(
              child: Text(texto,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.05, color: ColoresJuego.texto)),
            ),
          ],
        ),
      );
}

Widget _arrastrable<T extends Object>(T dato, Widget hijo, {double ancho = 120}) => Draggable<T>(
      data: dato,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Material(color: Colors.transparent, child: Transform.translate(offset: Offset(-ancho / 2, -18), child: hijo)),
      childWhenDragging: Opacity(opacity: 0.3, child: hijo),
      child: hijo,
    );

// ===========================================================================
// Clasificar en grupos
// ===========================================================================

class GrupoClasificar {
  const GrupoClasificar(this.nombre, this.emoji, this.color);
  final String nombre;
  final String emoji;
  final Color color;
}

class ItemClasificar {
  const ItemClasificar(this.emoji, this.texto, this.grupo, this.porque);
  final String emoji;
  final String texto;
  final int grupo;
  final String porque;
}

class PantallaClasificar extends StatefulWidget {
  const PantallaClasificar({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.instruccion,
    required this.grupos,
    required this.items,
    required this.mensajeFinal,
  });
  final String actividad, seccion, titulo, instruccion, mensajeFinal;
  final Color color;
  final List<GrupoClasificar> grupos;
  final List<ItemClasificar> items;
  @override
  State<PantallaClasificar> createState() => _PantallaClasificarState();
}

class _PantallaClasificarState extends State<PantallaClasificar> with SingleTickerProviderStateMixin {
  final Map<int, int> _colocados = {}; // item -> grupo
  int _errores = 0;
  int? _mal;
  late String _mensaje = widget.instruccion;
  late final List<int> _orden = List.generate(widget.items.length, (i) => i)..shuffle(math.Random(widget.titulo.length));
  late final AnimationController _temblor = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  void _soltar(int item, int grupo) {
    final it = widget.items[item];
    if (it.grupo == grupo) {
      HapticFeedback.lightImpact();
      setState(() {
        _colocados[item] = grupo;
        _mensaje = '¡Bien! ${it.porque}';
      });
    } else {
      HapticFeedback.mediumImpact();
      _errores++;
      _temblor.forward(from: 0);
      setState(() {
        _mal = grupo;
        _mensaje = '“${it.texto}” no va en “${widget.grupos[grupo].nombre}”. Piénsalo otra vez.';
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) setState(() => _mal = null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendientes = [for (final i in _orden) if (!_colocados.containsKey(i)) i];
    final listo = pendientes.isEmpty;
    final n = widget.grupos.length;
    final ancho = (606 - (n - 1) * 8) / n;
    return Escenario(
      velo: 0.12,
      colorVelo: widget.color,
      children: [
        _encabezado(widget.seccion, widget.titulo, widget.color),
        _globo(_mensaje),
        Positioned(
          left: 244,
          top: 60,
          width: 606,
          height: 150,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(20), border: Border.all(color: widget.color, width: 2.5)),
            child: listo
                ? Center(
                    child: Text('¡Clasificaste todo! 🎉',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: oscurecer(widget.color, 0.1))),
                  )
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        for (final i in pendientes)
                          _arrastrable<int>(i, FichaBio(emoji: widget.items[i].emoji, texto: widget.items[i].texto, color: widget.color, ancho: 140), ancho: 140),
                      ],
                    ),
                  ),
          ),
        ),
        for (var g = 0; g < n; g++)
          Positioned(
            left: 244 + g * (ancho + 8),
            top: 218,
            width: ancho,
            height: 196,
            child: AnimatedBuilder(
              animation: _temblor,
              builder: (_, child) => Transform.translate(
                offset: Offset(_mal == g ? math.sin(_temblor.value * math.pi * 6) * 8 * (1 - _temblor.value) : 0, 0),
                child: child,
              ),
              child: DragTarget<int>(
                onAcceptWithDetails: (d) => _soltar(d.data, g),
                builder: (context, cand, _) => _caja(g, cand.isNotEmpty),
              ),
            ),
          ),
        if (listo)
          Positioned(
            left: 680,
            top: 422,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: estrellasPorErrores(_errores),
                titulo: '¡${widget.titulo}!',
                mensaje: widget.mensajeFinal,
              ),
            ),
          ),
        if (!listo)
          Positioned(
            left: 250,
            top: 430,
            child: Text('Arrastra cada tarjeta a su grupo · Faltan ${pendientes.length}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white, shadows: [Shadow(blurRadius: 4)])),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _caja(int g, bool activa) {
    final grupo = widget.grupos[g];
    final dentro = [for (final e in _colocados.entries) if (e.value == g) e.key];
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: activa ? aclarar(grupo.color, 0.7) : Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _mal == g ? ColoresJuego.incorrecto : grupo.color, width: activa ? 4 : 3),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Emoji(grupo.emoji, tam: 24),
              const SizedBox(width: 4),
              Expanded(
                child: Text(grupo.nombre,
                    maxLines: 2, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: oscurecer(grupo.color, 0.2), height: 1.05)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  for (final i in dentro)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: aclarar(grupo.color, 0.8), borderRadius: BorderRadius.circular(12)),
                      child: Text('${widget.items[i].emoji} ${widget.items[i].texto}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Ordenar una secuencia
// ===========================================================================

class PantallaOrdenar extends StatefulWidget {
  const PantallaOrdenar({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.instruccion,
    required this.pasos,
    required this.explicacion,
    required this.mensajeFinal,
    this.ciclo = false,
  });
  final String actividad, seccion, titulo, instruccion, explicacion, mensajeFinal;
  final Color color;

  /// (emoji, texto) en el orden correcto.
  final List<(String, String)> pasos;

  /// Si es true se dibuja una flecha del último al primero (ciclo de vida).
  final bool ciclo;
  @override
  State<PantallaOrdenar> createState() => _PantallaOrdenarState();
}

class _PantallaOrdenarState extends State<PantallaOrdenar> {
  late final List<int?> _ranuras = List.filled(widget.pasos.length, null);
  final _bien = <int>{};
  final _malas = <int>{};
  int _errores = 0;
  bool _listo = false;
  late final List<int> _orden = List.generate(widget.pasos.length, (i) => i)..shuffle(math.Random(widget.titulo.length + 3));

  List<Offset> get _posiciones {
    final n = widget.pasos.length;
    final cols = n <= 4 ? n : (n / 2).ceil();
    final ancho = 606 / cols;
    return [
      for (var i = 0; i < n; i++)
        Offset(244 + (i % cols) * ancho + (ancho - 132) / 2, 72 + (i ~/ cols) * 120.0),
    ];
  }

  void _comprobar() {
    final mal = <int>{};
    for (var i = 0; i < _ranuras.length; i++) {
      if (_ranuras[i] == i) {
        _bien.add(i);
      } else {
        mal.add(i);
      }
    }
    if (mal.isEmpty) {
      HapticFeedback.mediumImpact();
      setState(() => _listo = true);
      return;
    }
    _errores++;
    HapticFeedback.heavyImpact();
    setState(() => _malas
      ..clear()
      ..addAll(mal));
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        for (final i in mal) {
          _ranuras[i] = null;
        }
        _malas.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final pos = _posiciones;
    final pendientes = [for (final i in _orden) if (!_ranuras.contains(i)) i];
    return Escenario(
      velo: 0.12,
      colorVelo: widget.color,
      children: [
        _encabezado(widget.seccion, widget.titulo, widget.color),
        _globo(_listo ? '¡Orden correcto! ${widget.explicacion}' : widget.instruccion, alto: 200),
        Positioned.fill(
          child: IgnorePointer(child: CustomPaint(painter: _PintorFlechas(pos, widget.ciclo, widget.color))),
        ),
        for (var i = 0; i < pos.length; i++)
          Positioned(
            left: pos[i].dx,
            top: pos[i].dy,
            child: DragTarget<int>(
              onWillAcceptWithDetails: (_) => !_bien.contains(i) && !_listo,
              onAcceptWithDetails: (d) => setState(() {
                final antes = _ranuras.indexOf(d.data);
                if (antes != -1) _ranuras[antes] = null;
                _ranuras[i] = d.data;
              }),
              builder: (context, cand, _) {
                final v = _ranuras[i];
                final color = _bien.contains(i) ? ColoresJuego.correcto : (_malas.contains(i) ? ColoresJuego.incorrecto : widget.color);
                return GestureDetector(
                  onTap: v != null && !_bien.contains(i) ? () => setState(() => _ranuras[i] = null) : null,
                  child: Container(
                    width: 132,
                    height: 96,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: v == null ? Colors.white.withValues(alpha: cand.isNotEmpty ? 1 : 0.75) : aclarar(color, 0.86),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: cand.isNotEmpty ? const Color(0xFFFFAA00) : color, width: 3),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 11, backgroundColor: color, child: Text('${i + 1}', style: const TextStyle(fontSize: 12, color: Colors.white))),
                        Expanded(
                          child: v == null
                              ? const Center(child: Text('?', style: TextStyle(fontSize: 22, color: Colors.black26, fontWeight: FontWeight.w700)))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Emoji(widget.pasos[v].$1, tam: 24),
                                    Text(widget.pasos[v].$2,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.05)),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        Positioned(
          left: 244,
          top: 320,
          width: 606,
          height: 96,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.92), borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 2)),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  for (final i in pendientes)
                    _arrastrable<int>(i, FichaBio(emoji: widget.pasos[i].$1, texto: widget.pasos[i].$2, color: widget.color, ancho: 140), ancho: 140),
                  if (pendientes.isEmpty && !_listo)
                    Tooltip(
                      message: 'Comprobar orden',
                      child: BotonJuego(texto: 'Comprobar', icono: Icons.check_circle_rounded, color: const Color(0xFFF5B400), onTap: _comprobar),
                    ),
                  if (_listo) const Text('¡Muy bien! 🎉', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: ColoresJuego.correcto)),
                ],
              ),
            ),
          ),
        ),
        if (_listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: estrellasPorErrores(_errores, dos: 1),
                titulo: '¡${widget.titulo}!',
                mensaje: widget.mensajeFinal,
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorFlechas extends CustomPainter {
  _PintorFlechas(this.pos, this.ciclo, this.color);
  final List<Offset> pos;
  final bool ciclo;
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    const w = 132.0, h = 96.0;
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final p2 = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Dibuja una línea quebrada con punta de flecha en el último punto.
    void trazo(List<Offset> pts) {
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final q in pts.skip(1)) {
        path.lineTo(q.dx, q.dy);
      }
      c.drawPath(path, p);
      c.drawPath(path, p2);
      final fin = pts.last, d = fin - pts[pts.length - 2];
      final u = d / d.distance, n = Offset(-u.dy, u.dx);
      c.drawLine(fin, fin - u * 10 + n * 7, p2);
      c.drawLine(fin, fin - u * 10 - n * 7, p2);
    }

    bool mismaFila(Offset a, Offset b) => (a.dy - b.dy).abs() < 10;

    for (var i = 0; i < pos.length - 1; i++) {
      final a = pos[i], b = pos[i + 1];
      if (mismaFila(a, b)) {
        final y = a.dy + h / 2;
        if ((b.dx - a.dx).abs() > w + 12) {
          trazo([Offset(a.dx + w + 4, y), Offset(b.dx - 4, y)]);
        }
      } else {
        // Cambio de fila: baja por el hueco entre filas.
        final yHueco = (a.dy + h + b.dy) / 2 - 3;
        trazo([
          Offset(a.dx + w / 2, a.dy + h + 2),
          Offset(a.dx + w / 2, yHueco),
          Offset(b.dx + w / 2, yHueco),
          Offset(b.dx + w / 2, b.dy - 2),
        ]);
      }
    }
    if (ciclo && pos.length > 2) {
      final a = pos.last, b = pos.first;
      if (mismaFila(a, b)) {
        // Regresa por debajo de las tarjetas.
        final y = a.dy + h + 14;
        trazo([
          Offset(a.dx + w / 2, a.dy + h + 2),
          Offset(a.dx + w / 2, y),
          Offset(b.dx + w / 2, y),
          Offset(b.dx + w / 2, b.dy + h + 2),
        ]);
      } else {
        // Regresa por la izquierda de la primera tarjeta.
        final x = b.dx - 12;
        trazo([
          Offset(a.dx - 2, a.dy + h / 2),
          Offset(x, a.dy + h / 2),
          Offset(x, b.dy + h / 2),
          Offset(b.dx - 2, b.dy + h / 2),
        ]);
      }
    }
  }

  @override
  bool shouldRepaint(_PintorFlechas old) => false;
}

// ===========================================================================
// Fase de preguntas (para mini misiones)
// ===========================================================================

class FasePreguntas extends StatefulWidget {
  const FasePreguntas({super.key, required this.preguntas, required this.onCompleto, this.color = moradoBanner});
  final List<PreguntaQuiz> preguntas;
  final ValueChanged<int> onCompleto;
  final Color color;
  @override
  State<FasePreguntas> createState() => _FasePreguntasState();
}

class _FasePreguntasState extends State<FasePreguntas> {
  int _i = 0, _errores = 0;
  int? _elegida;

  @override
  Widget build(BuildContext context) {
    final q = widget.preguntas[_i];
    final acerto = _elegida == q.correcta;
    return Positioned(
      left: 244,
      top: 62,
      width: 606,
      height: 410,
      child: Entrada(
        key: ValueKey(_i),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: widget.color, width: 4)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Pregunta ${_i + 1} de ${widget.preguntas.length}', style: TextStyle(fontWeight: FontWeight.w700, color: widget.color)),
              const SizedBox(height: 4),
              Text(q.pregunta, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (posK, k) in ordenOpciones(q.pregunta, q.opciones.length).indexed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: BotonOpcion(
                            letra: 'ABCD'[posK],
                            texto: q.opciones[k],
                            estado: _elegida == k ? (k == q.correcta ? EstadoOpcion.correcta : EstadoOpcion.incorrecta) : EstadoOpcion.normal,
                            onTap: acerto
                                ? null
                                : () => setState(() {
                                      if (k != q.correcta) _errores++;
                                      _elegida = k;
                                    }),
                          ),
                        ),
                      if (_elegida != null)
                        Text(acerto ? '✅ ${q.explicacion}' : '🤔 ¡Inténtalo otra vez!',
                            style: TextStyle(fontWeight: FontWeight.w600, color: acerto ? ColoresJuego.correcto : ColoresJuego.incorrecto)),
                    ],
                  ),
                ),
              ),
              if (acerto)
                Align(
                  alignment: Alignment.centerRight,
                  child: Tooltip(
                    message: 'Siguiente pregunta',
                    child: BotonJuego(
                      texto: _i < widget.preguntas.length - 1 ? 'Siguiente pregunta' : 'Terminar',
                      icono: Icons.arrow_forward_rounded,
                      color: ColoresJuego.correcto,
                      onTap: () {
                        if (_i < widget.preguntas.length - 1) {
                          setState(() {
                            _i++;
                            _elegida = null;
                          });
                        } else {
                          widget.onCompleto(_errores);
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Mini misión por fases ("Pon a prueba lo que aprendiste")
// ===========================================================================

class FaseMini {
  const FaseMini(this.instruccion, this.construir, {this.mostrarGlobo = true, this.mostrarZati = true});
  final String instruccion;

  /// Construye la fase (un widget Positioned/Positioned.fill para el lienzo).
  final Widget Function(ValueChanged<int> alTerminar) construir;

  /// false para fases que ocupan todo el lienzo (por ejemplo, acciones).
  final bool mostrarGlobo;

  /// false cuando la parte inferior izquierda se usa (bandeja de tarjetas).
  final bool mostrarZati;
}

class PantallaMiniMisionBio extends StatefulWidget {
  const PantallaMiniMisionBio({super.key, required this.actividad, required this.color, required this.fases, required this.mensajeFinal});
  final String actividad, mensajeFinal;
  final Color color;
  final List<FaseMini> fases;
  @override
  State<PantallaMiniMisionBio> createState() => _PantallaMiniMisionBioState();
}

class _PantallaMiniMisionBioState extends State<PantallaMiniMisionBio> {
  int _fase = 0, _errores = 0;

  void _siguiente(int errores) {
    _errores += errores;
    if (_fase < widget.fases.length - 1) {
      setState(() => _fase++);
      return;
    }
    terminarPaso(
      context,
      actividad: widget.actividad,
      estrellas: _errores == 0 ? 3 : (_errores <= 3 ? 2 : 1),
      titulo: '¡Pusiste a prueba lo que aprendiste!',
      mensaje: widget.mensajeFinal,
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.fases[_fase];
    return Escenario(
      velo: 0.1,
      colorVelo: widget.color,
      children: [
        KeyedSubtree(key: ValueKey(_fase), child: f.construir(_siguiente)),
        Positioned(left: 64, top: 14, child: EtiquetaSeccion('Mini misión · ${_fase + 1}/${widget.fases.length}')),
        Positioned(
          left: 0,
          right: 0,
          top: 4,
          child: IgnorePointer(child: Center(child: BannerTitulo('Pon a prueba lo que aprendiste', tam: 20, color: oscurecer(widget.color, 0.05)))),
        ),
        if (f.mostrarGlobo)
          Positioned(
            left: 8,
            top: 66,
            width: 220,
            child: GloboTexto(colita: false, child: Text('${_fase + 1}. ${f.instruccion}', style: const TextStyle(fontSize: 14.5, height: 1.25))),
          ),
        if (f.mostrarGlobo && f.mostrarZati)
          const Positioned(left: 30, top: 290, child: IgnorePointer(child: SizedBox(width: 130, height: 180, child: ZatiMascota(tam: 180)))),
        const BotonVolverEscena(),
      ],
    );
  }
}

// ===========================================================================
// Juego: atrapa lo correcto
// ===========================================================================

class CosaQueCae {
  const CosaQueCae(this.emoji, this.buena, {this.mensaje});
  final String emoji;
  final bool buena;

  /// Lo que dice el juego cuando se atrapa una mala.
  final String? mensaje;
}

class JuegoAtrapar extends StatefulWidget {
  const JuegoAtrapar({
    super.key,
    required this.actividad,
    required this.titulo,
    required this.instrucciones,
    required this.color,
    required this.recolector,
    required this.cosas,
    required this.mensajeFinal,
    this.duracion = 45,
  });
  final String actividad, titulo, instrucciones, recolector, mensajeFinal;
  final Color color;
  final List<CosaQueCae> cosas;
  final double duracion;
  @override
  State<JuegoAtrapar> createState() => _JuegoAtraparState();
}

class _Cae {
  _Cae(this.cosa, this.x, this.vel);
  final CosaQueCae cosa;
  final double x, vel;
  double y = 70;
  bool atrapada = false;
}

class _JuegoAtraparState extends State<JuegoAtrapar> with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  final _rnd = math.Random();
  final _caen = <_Cae>[];
  final _mensajes = <(Offset, String, double, bool)>[];
  double _t = 0, _ultimo = 0, _proxima = 0, _x = 430;
  int _puntos = 0, _vidas = 5;
  bool _jugando = false, _terminado = false;
  String? _ultimoAviso;

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _comenzar() {
    setState(() {
      _caen.clear();
      _mensajes.clear();
      _t = 0;
      _ultimo = 0;
      _proxima = 0;
      _puntos = 0;
      _vidas = 5;
      _x = 430;
      _jugando = true;
      _terminado = false;
      _ultimoAviso = null;
    });
    _ticker
      ..stop()
      ..start();
  }

  void _tick(Duration d) {
    final ahora = d.inMicroseconds / 1e6;
    final dt = (ahora - _ultimo).clamp(0.0, 0.05);
    _ultimo = ahora;
    if (!_jugando) return;
    _t += dt;
    final dificultad = 1 + 1.1 * _t / widget.duracion;
    _proxima -= dt;
    if (_proxima <= 0) {
      final buenas = widget.cosas.where((c) => c.buena).toList();
      final malas = widget.cosas.where((c) => !c.buena).toList();
      final cosa = _rnd.nextDouble() < 0.55 ? buenas[_rnd.nextInt(buenas.length)] : malas[_rnd.nextInt(malas.length)];
      _caen.add(_Cae(cosa, 40 + _rnd.nextDouble() * 780, (105 + _rnd.nextDouble() * 70) * dificultad));
      _proxima = (0.95 - 0.35 * (dificultad - 1) / 1.1) * (0.6 + _rnd.nextDouble() * 0.6);
    }
    for (final k in _caen) {
      k.y += k.vel * dt;
      if (!k.atrapada && k.y > 390 && k.y < 450 && (k.x - _x).abs() < 62) {
        k.atrapada = true;
        if (k.cosa.buena) {
          _puntos++;
          _mensajes.add((Offset(k.x, 370), '+1', 0, true));
          HapticFeedback.selectionClick();
        } else {
          _vidas--;
          _ultimoAviso = k.cosa.mensaje;
          _mensajes.add((Offset(k.x, 370), '¡Oh, no!', 0, false));
          HapticFeedback.mediumImpact();
        }
      }
    }
    _caen.removeWhere((k) => k.atrapada || k.y > 490);
    for (var i = 0; i < _mensajes.length; i++) {
      _mensajes[i] = (_mensajes[i].$1, _mensajes[i].$2, _mensajes[i].$3 + dt, _mensajes[i].$4);
    }
    _mensajes.removeWhere((m) => m.$3 > 0.8);
    if (_vidas <= 0 || _t >= widget.duracion) {
      _jugando = false;
      _terminado = true;
      _ticker.stop();
      final estrellas = _vidas <= 0 ? (_puntos >= 10 ? 1 : 0) : (_puntos >= 28 ? 3 : (_puntos >= 16 ? 2 : 1));
      if (estrellas > 0) {
        terminarPaso(context,
            actividad: widget.actividad,
            estrellas: estrellas,
            titulo: _vidas > 0 ? '¡Excelente!' : '¡Buen intento!',
            mensaje: 'Atrapaste $_puntos. ${widget.mensajeFinal}');
      }
    }
    setState(() {});
  }

  void _mover(double x) {
    if (_jugando) _x = x.clamp(70.0, 790.0);
  }

  @override
  Widget build(BuildContext context) {
    const area = Rect.fromLTWH(10, 60, 840, 410);
    return Escenario(
      velo: 0.1,
      colorVelo: widget.color,
      children: [
        Positioned.fromRect(
          rect: area,
          child: GestureDetector(
            onPanStart: (d) => _mover(d.localPosition.dx + area.left),
            onPanUpdate: (d) => _mover(d.localPosition.dx + area.left),
            onTapDown: (d) => _mover(d.localPosition.dx + area.left),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: CustomPaint(size: area.size, painter: _PintorAtrapar(_t, _x, _caen, _mensajes, widget.recolector, widget.color)),
            ),
          ),
        ),
        const Positioned(left: 64, top: 14, child: EtiquetaSeccion('Juego')),
        Positioned(
          left: 260,
          top: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                for (var v = 0; v < 5; v++) Icon(v < _vidas ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: ColoresJuego.circulatorio, size: 20),
                const SizedBox(width: 12),
                Text('⏱ ${math.max(0, widget.duracion - _t).ceil()} s', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(width: 12),
                Text('⭐ $_puntos', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ],
            ),
          ),
        ),
        if (_jugando && _ultimoAviso != null)
          Positioned(
            left: 260,
            top: 52,
            width: 420,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14)),
              child: Text(_ultimoAviso!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        if (!_jugando)
          Positioned.fill(
            child: Container(
              color: Colors.black45,
              alignment: Alignment.center,
              child: Container(
                width: 580,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: widget.color, width: 4)),
                child: Row(
                  children: [
                    const SizedBox(width: 110, height: 150, child: ZatiMascota(tam: 150)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_terminado ? '¿Otra ronda?' : widget.titulo, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: widget.color)),
                          const SizedBox(height: 6),
                          Text(widget.instrucciones, style: const TextStyle(fontSize: 15, height: 1.3)),
                          const SizedBox(height: 6),
                          Wrap(spacing: 4, children: [
                            const Text('Atrapa: ', style: TextStyle(fontWeight: FontWeight.w700)),
                            for (final c in widget.cosas.where((c) => c.buena).take(6)) Emoji(c.emoji, tam: 20),
                          ]),
                          const SizedBox(height: 12),
                          Tooltip(
                            message: 'Jugar',
                            child: BotonJuego(texto: _terminado ? 'Jugar otra vez' : '¡A jugar!', icono: Icons.play_arrow_rounded, color: widget.color, onTap: _comenzar),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorAtrapar extends CustomPainter {
  _PintorAtrapar(this.t, this.x, this.caen, this.mensajes, this.recolector, this.color);
  final double t, x;
  final List<_Cae> caen;
  final List<(Offset, String, double, bool)> mensajes;
  final String recolector;
  final Color color;
  static const off = Offset(-10, -60);
  @override
  void paint(Canvas c, Size s) {
    final r = Offset.zero & s;
    c.drawRect(
        r,
        Paint()
          ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [aclarar(color, 0.75), aclarar(color, 0.92)])
              .createShader(r));
    for (var i = 0; i < 4; i++) {
      final cx = ((i * 230 + t * 18) % (s.width + 200)) - 100;
      for (final d in const [Offset(0, 0), Offset(30, -10), Offset(60, 0)]) {
        c.drawCircle(Offset(cx, 50.0 + i * 12) + d, 26, Paint()..color = Colors.white.withValues(alpha: 0.8));
      }
    }
    c.drawRect(Rect.fromLTWH(0, s.height - 26, s.width, 26), Paint()..color = const Color(0xFF8BC34A));
    for (final k in caen) {
      c.save();
      final p = Offset(k.x, k.y) + off;
      c.translate(p.dx, p.dy);
      c.rotate(math.sin(t * 3 + k.x) * 0.25);
      dibujarEmoji(c, k.cosa.emoji, Offset.zero, 34);
      c.restore();
    }
    dibujarEmoji(c, recolector, Offset(x, 420) + off, 64);
    for (final m in mensajes) {
      final a = (1 - m.$3 / 0.8).clamp(0.0, 1.0);
      textoEn(c, m.$2, m.$1 + off - Offset(0, 40 * m.$3), tam: 18, color: (m.$4 ? ColoresJuego.correcto : ColoresJuego.incorrecto).withValues(alpha: a));
    }
  }

  @override
  bool shouldRepaint(_PintorAtrapar old) => true;
}

// ===========================================================================
// Juego: memorama
// ===========================================================================

class JuegoMemorama extends StatefulWidget {
  const JuegoMemorama({
    super.key,
    required this.actividad,
    required this.titulo,
    required this.color,
    required this.instruccion,
    required this.pares,
    required this.mensajeFinal,
  });
  final String actividad, titulo, instruccion, mensajeFinal;
  final Color color;

  /// (emoji, nombre, pareja) — la pareja es el texto de la otra tarjeta.
  final List<(String, String, String)> pares;
  @override
  State<JuegoMemorama> createState() => _JuegoMemoramaState();
}

class _JuegoMemoramaState extends State<JuegoMemorama> {
  late final List<(int, bool)> _cartas = [
    for (var i = 0; i < widget.pares.length; i++) ...[(i, true), (i, false)],
  ]..shuffle(math.Random(widget.titulo.length));
  final _encontradas = <int>{};
  final _abiertas = <int>[];
  int _intentos = 0;
  bool _esperando = false;
  late String _mensaje = widget.instruccion;

  void _tocar(int k) {
    if (_esperando || _abiertas.contains(k) || _encontradas.contains(_cartas[k].$1)) return;
    setState(() => _abiertas.add(k));
    if (_abiertas.length < 2) return;
    _intentos++;
    final a = _cartas[_abiertas[0]], b = _cartas[_abiertas[1]];
    if (a.$1 == b.$1) {
      HapticFeedback.lightImpact();
      setState(() {
        _encontradas.add(a.$1);
        _abiertas.clear();
        _mensaje = '¡Pareja encontrada! ${widget.pares[a.$1].$2}: ${widget.pares[a.$1].$3}';
      });
    } else {
      _esperando = true;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          _abiertas.clear();
          _esperando = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final n = _cartas.length;
    final cols = n <= 8 ? 4 : (n <= 12 ? 4 : 5);
    final filas = (n / cols).ceil();
    final ancho = (606 - (cols - 1) * 8) / cols;
    final alto = (350 - (filas - 1) * 8) / filas;
    final listo = _encontradas.length == widget.pares.length;
    return Escenario(
      velo: 0.12,
      colorVelo: widget.color,
      children: [
        _encabezado('Juego', widget.titulo, widget.color),
        _globo('$_mensaje\n\nIntentos: $_intentos', alto: 220),
        for (var k = 0; k < n; k++)
          Positioned(
            left: 244 + (k % cols) * (ancho + 8),
            top: 62 + (k ~/ cols) * (alto + 8),
            width: ancho,
            height: alto,
            child: Rebote(onTap: () => _tocar(k), child: _carta(k)),
          ),
        if (listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: _intentos <= widget.pares.length + 3 ? 3 : (_intentos <= widget.pares.length * 2 + 2 ? 2 : 1),
                titulo: '¡Memorama completo!',
                mensaje: 'Lo lograste en $_intentos intentos. ${widget.mensajeFinal}',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _carta(int k) {
    final (par, esNombre) = _cartas[k];
    final visible = _abiertas.contains(k) || _encontradas.contains(par);
    final encontrada = _encontradas.contains(par);
    final (emoji, nombre, pareja) = widget.pares[par];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(visible),
        constraints: const BoxConstraints.expand(),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: visible ? null : LinearGradient(colors: [widget.color, aclarar(widget.color, 0.3)]),
          color: visible ? (encontrada ? const Color(0xFFE6F8EA) : Colors.white) : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: encontrada ? ColoresJuego.correcto : Colors.white, width: 3),
          boxShadow: [BoxShadow(color: oscurecer(widget.color, 0.3), offset: const Offset(0, 4))],
        ),
        child: !visible
            ? const Center(child: Text('?', style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.w700)))
            : Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    width: 120,
                    child: esNombre
                        ? Column(mainAxisSize: MainAxisSize.min, children: [
                            Emoji(emoji, tam: 30),
                            Text(nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          ])
                        : Text(pareja, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, height: 1.15)),
                  ),
                ),
              ),
      ),
    );
  }
}

// ===========================================================================
// Situación para resolver (actividad integradora)
// ===========================================================================

class EscenaBio {
  const EscenaBio({
    required this.titulo,
    required this.narracion,
    required this.emojis,
    required this.pregunta,
    required this.opciones,
    required this.correcta,
    required this.explicacion,
  });
  final String titulo, narracion, emojis, pregunta, explicacion;
  final List<String> opciones;
  final int correcta;
}

class PantallaSituacionBio extends StatefulWidget {
  const PantallaSituacionBio({
    super.key,
    required this.actividad,
    required this.titulo,
    required this.color,
    required this.escenas,
    required this.mensajeFinal,
  });
  final String actividad, titulo, mensajeFinal;
  final Color color;
  final List<EscenaBio> escenas;
  @override
  State<PantallaSituacionBio> createState() => _PantallaSituacionBioState();
}

class _PantallaSituacionBioState extends State<PantallaSituacionBio> {
  int _i = 0, _primer = 0;
  int? _elegida;
  final _intentadas = <int>{};

  @override
  Widget build(BuildContext context) {
    final e = widget.escenas[_i];
    final acerto = _elegida == e.correcta;
    final ultima = _i == widget.escenas.length - 1;
    return Escenario(
      velo: 0.05,
      children: [
        _encabezado('Situación', widget.titulo, widget.color),
        _globo('${e.titulo}\n\n${e.narracion}', alto: 210),
        Positioned(
          left: 244,
          top: 62,
          width: 610,
          height: 356,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: widget.color, width: 4)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Escena ${_i + 1} de ${widget.escenas.length}', style: TextStyle(fontWeight: FontWeight.w700, color: widget.color)),
                    const Spacer(),
                    Emoji(e.emojis, tam: 26),
                  ],
                ),
                const SizedBox(height: 4),
                Text(e.pregunta, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final (posK, k) in ordenOpciones(e.pregunta, e.opciones.length).indexed)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: BotonOpcion(
                              letra: 'ABCD'[posK],
                              texto: e.opciones[k],
                              estado: _elegida == k ? (k == e.correcta ? EstadoOpcion.correcta : EstadoOpcion.incorrecta) : EstadoOpcion.normal,
                              onTap: acerto
                                  ? null
                                  : () => setState(() {
                                        if (!_intentadas.contains(_i) && k == e.correcta) _primer++;
                                        _intentadas.add(_i);
                                        _elegida = k;
                                      }),
                            ),
                          ),
                        if (_elegida != null && !acerto)
                          const Text('🤔 Piensa en lo que aprendiste e inténtalo otra vez.',
                              style: TextStyle(fontWeight: FontWeight.w600, color: ColoresJuego.incorrecto)),
                        if (acerto) Text('✅ ${e.explicacion}', style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: ColoresJuego.correcto)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (acerto)
          Positioned(
            left: 650,
            top: 424,
            child: BotonSiguiente(
              texto: ultima ? 'Terminar' : 'Siguiente escena',
              onTap: () {
                if (!ultima) {
                  setState(() {
                    _i++;
                    _elegida = null;
                  });
                  return;
                }
                final n = widget.escenas.length;
                terminarPaso(
                  context,
                  actividad: widget.actividad,
                  estrellas: _primer >= n ? 3 : (_primer >= n - 2 ? 2 : 1),
                  titulo: '¡Situación resuelta!',
                  mensaje: widget.mensajeFinal,
                );
              },
            ),
          ),
        if (acerto && !ultima) Positioned.fill(child: ExplosionConfeti(key: ValueKey('esc$_i'))),
        const BotonVolverEscena(),
      ],
    );
  }
}
