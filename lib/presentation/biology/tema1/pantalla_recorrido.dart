import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'animaciones_tour.dart';
import 'aventura.dart';
import 'comunes.dart';
import 'contenido.dart';
import 'progreso.dart';

/// Lista de capítulos del recorrido interactivo.
class PantallaCapitulos extends StatelessWidget {
  const PantallaCapitulos({super.key});
  @override
  Widget build(BuildContext context) {
    final progreso = ProgresoScope.of(context);
    return Scaffold(
      appBar: barraJuego('Recorrido interactivo', ColoresJuego.intro),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BurbujaCora(
            texto:
                '¡Hola! Soy Zati, tu guía. ¡Acompáñame a conocer el cuerpo humano por dentro!',
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < capitulosTour.length; i++) ...[
            TarjetaActividad(
              indice: i,
              titulo: 'Capítulo ${i + 1}: ${capitulosTour[i].titulo}',
              subtitulo:
                  '${capitulosTour[i].subtitulo} · ${capitulosTour[i].escenas.length} escenas',
              icono: capitulosTour[i].icono,
              color: capitulosTour[i].color,
              estrellas: progreso.estrellasDe(capitulosTour[i].id),
              onTap: () => abrirPantalla(
                context,
                PantallaRecorrido(capitulo: capitulosTour[i]),
                color: capitulosTour[i].color,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class PantallaRecorrido extends StatefulWidget {
  const PantallaRecorrido({super.key, required this.capitulo});
  final CapituloTour capitulo;
  @override
  State<PantallaRecorrido> createState() => _PantallaRecorridoState();
}

class _PantallaRecorridoState extends State<PantallaRecorrido> {
  int _escena = 0;
  final Map<int, Set<int>> _vistos = {};
  final Map<int, int> _respuesta = {}; // escena -> opción elegida
  final Set<int> _correctaPrimerIntento = {};
  final Set<int> _intentadas = {};
  bool _hablando = false;

  CapituloTour get cap => widget.capitulo;
  EscenaTour get escena => cap.escenas[_escena];

  Future<void> _ventana({
    required String titulo,
    required String texto,
    EmocionCora emocion = EmocionCora.sorprendida,
  }) {
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: cap.color, width: 4),
              boxShadow: [
                BoxShadow(
                  color: oscurecer(cap.color, 0.3),
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ZatiMascota(tam: 120, emocion: emocion, hablando: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: cap.color,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Text(
                            texto,
                            style: const TextStyle(fontSize: 17, height: 1.35),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: BotonJuego(
                          texto: '¡Entendido!',
                          icono: Icons.check_rounded,
                          color: cap.color,
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

  void _abrirPunto(int i) {
    setState(() => _vistos.putIfAbsent(_escena, () => {}).add(i));
    final p = escena.puntos[i];
    _ventana(titulo: p.titulo, texto: p.texto);
  }

  /// Muestra la pregunta rápida de la escena. Devuelve true al acertar.
  Future<bool> _preguntar() async {
    final indice = _escena;
    final pregunta = escena.pregunta!;
    final ok = await showDialog<bool>(
      useRootNavigator: false,
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogo) {
          final acerto = _respuesta[indice] == pregunta.correcta;
          final tamPantalla = MediaQuery.sizeOf(ctx);
          final horizontal = tamPantalla.width > tamPantalla.height;
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: horizontal ? 760 : 620,
                maxHeight: tamPantalla.height - 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: _PreguntaRapida(
                        pregunta: pregunta,
                        color: cap.color,
                        elegida: _respuesta[indice],
                        columnas: horizontal ? 2 : 1,
                        onElegir: (i) {
                          setState(() {
                            if (!_intentadas.contains(indice) &&
                                i == pregunta.correcta) {
                              _correctaPrimerIntento.add(indice);
                            }
                            _intentadas.add(indice);
                            _respuesta[indice] = i;
                          });
                          setDialogo(() {});
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!acerto)
                        BotonJuego(
                          texto: 'Volver a la escena',
                          color: Colors.blueGrey,
                          onTap: () => Navigator.of(ctx).pop(false),
                        ),
                      if (acerto)
                        BotonJuego(
                          texto: 'Continuar',
                          icono: Icons.arrow_forward_rounded,
                          color: ColoresJuego.correcto,
                          onTap: () => Navigator.of(ctx).pop(true),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    return ok ?? false;
  }

  Future<void> _siguiente() async {
    if (escena.pregunta != null &&
        _respuesta[_escena] != escena.pregunta!.correcta) {
      if (!await _preguntar() || !mounted) return;
    }
    if (_escena < cap.escenas.length - 1) {
      setState(() => _escena++);
      return;
    }
    var totalPuntos = 0, vistos = 0, preguntas = 0;
    for (var i = 0; i < cap.escenas.length; i++) {
      totalPuntos += cap.escenas[i].puntos.length;
      vistos += _vistos[i]?.length ?? 0;
      if (cap.escenas[i].pregunta != null) preguntas++;
    }
    var estrellas = 1;
    if (vistos >= totalPuntos) estrellas++;
    if (_correctaPrimerIntento.length >= preguntas) estrellas++;
    await otorgarEstrellas(
      context,
      actividad: cap.id,
      estrellas: estrellas,
      titulo: '¡Explicación terminada!',
      mensaje: estrellas == 3
          ? 'Exploraste todo y respondiste perfecto. ¡Eres un gran científico!'
          : 'Para ganar 3 estrellas explora todos los puntos y responde bien a la primera.',
    );
    if (mounted) Navigator.of(context).pop();
  }

  void _hablar(bool v) {
    if (v == _hablando) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _hablando = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncabezadoAventura(titulo: escena.titulo),
            Expanded(
              child: LayoutBuilder(
                builder: (context, cons) {
                  if (cons.maxWidth > cons.maxHeight * 1.2) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: cons.maxWidth * 0.42,
                          child: _panelZati(cons.maxHeight, horizontal: true),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 8, 16, 6),
                            child: Center(child: _areaAnimacion()),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: _areaAnimacion(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 300,
                        child: _panelZati(300, horizontal: false),
                      ),
                    ],
                  );
                },
              ),
            ),
            _navegacion(),
          ],
        ),
      ),
    );
  }

  Widget _panelZati(double alto, {required bool horizontal}) {
    final e = escena;
    final vistos = _vistos[_escena]?.length ?? 0;
    return LayoutBuilder(
      builder: (context, cons) {
        final anchoZati = cons.maxWidth * 0.36;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              width: anchoZati,
              height: cons.maxHeight * 0.82,
              child: ZatiMascota(
                tam: cons.maxHeight * 0.82,
                hablando: _hablando,
              ),
            ),
            Positioned(
              left: anchoZati * 0.92,
              right: 4,
              top: 8,
              bottom: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Flexible(
                    child: GloboTexto(
                      child: SingleChildScrollView(
                        child: TextoMaquina(
                          e.narracion,
                          key: ValueKey('${cap.id}-$_escena'),
                          estilo: TextStyle(
                            fontSize: horizontal ? 16 : 17,
                            height: 1.32,
                            color: ColoresJuego.texto,
                          ),
                          alCambiar: _hablar,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (e.puntos.isNotEmpty)
                        _Pastilla(
                          icono: vistos >= e.puntos.length
                              ? Icons.check_circle_rounded
                              : Icons.touch_app_rounded,
                          texto: 'Descubre $vistos/${e.puntos.length}',
                          color: vistos >= e.puntos.length
                              ? ColoresJuego.correcto
                              : cap.color,
                        ),
                      if (e.instruccion != null && e.puntos.isEmpty)
                        _Pastilla(
                          icono: Icons.touch_app_rounded,
                          texto: e.instruccion!,
                          color: cap.color,
                        ),
                      if (e.sabiasQue != null)
                        Rebote(
                          onTap: () => _ventana(
                            titulo: '¿Sabías que…?',
                            texto: e.sabiasQue!,
                            emocion: EmocionCora.feliz,
                          ),
                          child: const Movimiento(
                            tipo: TipoMovimiento.latir,
                            intensidad: 0.5,
                            child: _Pastilla(
                              icono: Icons.lightbulb_rounded,
                              texto: '¿Sabías que…?',
                              color: Color(0xFFFFAA00),
                            ),
                          ),
                        ),
                      if (e.pregunta != null)
                        _Pastilla(
                          icono: _respuesta[_escena] == e.pregunta!.correcta
                              ? Icons.verified_rounded
                              : Icons.psychology_alt_rounded,
                          texto: _respuesta[_escena] == e.pregunta!.correcta
                              ? '¡Pregunta lograda!'
                              : 'Hay una pregunta',
                          color: const Color(0xFF8B5CF6),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _navegacion() {
    final ultima = _escena == cap.escenas.length - 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BotonRedondo(
            icono: Icons.chevron_left_rounded,
            tam: 48,
            etiqueta: 'Anterior',
            onTap: _escena > 0 ? () => setState(() => _escena--) : null,
          ),
          const SizedBox(width: 14),
          for (var i = 0; i < cap.escenas.length; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: i == _escena ? 18 : 12,
              height: i == _escena ? 18 : 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _escena
                    ? Colors.white
                    : (i < _escena
                        ? aclarar(moradoBanner, 0.3)
                        : Colors.white.withValues(alpha: 0.6)),
                border: Border.all(color: moradoBanner, width: 2.5),
              ),
            ),
          const SizedBox(width: 14),
          Movimiento(
            tipo: TipoMovimiento.latir,
            intensidad: 0.3,
            child: BotonRedondo(
              icono: ultima ? Icons.check_rounded : Icons.chevron_right_rounded,
              tam: 48,
              etiqueta: ultima ? 'Terminar' : 'Siguiente',
              color: ultima ? ColoresJuego.correcto : moradoBanner,
              onTap: _siguiente,
            ),
          ),
        ],
      ),
    );
  }

  Widget _areaAnimacion() {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white, width: 5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x55000000),
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, cons) {
            final size = Size(cons.maxWidth, cons.maxHeight);
            final caja = Silueta.caja(size);
            return Stack(
              children: [
                Positioned.fill(
                  child: KeyedSubtree(
                    key: ValueKey('${cap.id}-$_escena'),
                    child: construirAnimacion(escena.anim),
                  ),
                ),
                for (var i = 0; i < escena.puntos.length; i++)
                  _PuntoBrillante(
                    posicion: escena.puntos[i].marco == Marco.silueta
                        ? Silueta.punto(caja, escena.puntos[i].pos)
                        : Offset(
                            escena.puntos[i].pos.dx * size.width,
                            escena.puntos[i].pos.dy * size.height,
                          ),
                    visto: _vistos[_escena]?.contains(i) ?? false,
                    color: cap.color,
                    onTap: () => _abrirPunto(i),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Pastilla extends StatelessWidget {
  const _Pastilla({
    required this.icono,
    required this.texto,
    required this.color,
  });
  final IconData icono;
  final String texto;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 2),
          boxShadow: [
            BoxShadow(
                color: oscurecer(color, 0.25), offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 17, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: oscurecer(color, 0.15),
                ),
              ),
            ),
          ],
        ),
      );
}

class _PuntoBrillante extends StatefulWidget {
  const _PuntoBrillante({
    required this.posicion,
    required this.visto,
    required this.color,
    required this.onTap,
  });
  final Offset posicion;
  final bool visto;
  final Color color;
  final VoidCallback onTap;
  @override
  State<_PuntoBrillante> createState() => _PuntoBrillanteState();
}

class _PuntoBrillanteState extends State<_PuntoBrillante>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const tam = 44.0;
    return Positioned(
      left: widget.posicion.dx - tam / 2,
      top: widget.posicion.dy - tam / 2,
      width: tam,
      height: tam,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final v = _c.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                if (!widget.visto)
                  Container(
                    width: 20 + 24 * v,
                    height: 20 + 24 * v,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withValues(alpha: 0.45 * (1 - v)),
                    ),
                  ),
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.visto ? ColoresJuego.correcto : widget.color,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Icon(
                    widget.visto ? Icons.check : Icons.question_mark_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PreguntaRapida extends StatelessWidget {
  const _PreguntaRapida({
    required this.pregunta,
    required this.color,
    required this.elegida,
    required this.onElegir,
    this.columnas = 1,
  });
  final PreguntaQuiz pregunta;
  final Color color;
  final int? elegida;
  final ValueChanged<int> onElegir;
  final int columnas;

  Widget _opcion(int i, bool acerto) => BotonOpcion(
        letra: 'ABCD'[i],
        texto: pregunta.opciones[i],
        estado: elegida == i
            ? (i == pregunta.correcta
                ? EstadoOpcion.correcta
                : EstadoOpcion.incorrecta)
            : (acerto && i == pregunta.correcta
                ? EstadoOpcion.correcta
                : EstadoOpcion.normal),
        onTap: acerto ? null : () => onElegir(i),
      );

  @override
  Widget build(BuildContext context) {
    final acerto = elegida == pregunta.correcta;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color, width: 3),
            boxShadow: [
              BoxShadow(
                color: oscurecer(color, 0.25),
                offset: const Offset(0, 6),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, aclarar(color, 0.3)],
                  ),
                ),
                child: Row(
                  children: [
                    const Movimiento(
                      tipo: TipoMovimiento.balancear,
                      child: Icon(
                        Icons.psychology_alt_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '¡PREGUNTA RÁPIDA!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (acerto)
                      const Icon(
                        Icons.verified_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      pregunta.pregunta,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    for (var i = 0; i < pregunta.opciones.length; i += columnas)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var k = i; k < i + columnas; k++) ...[
                              if (k > i) const SizedBox(width: 8),
                              Expanded(
                                child: k < pregunta.opciones.length
                                    ? _opcion(k, acerto)
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    if (elegida != null)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text(
                          key: ValueKey(elegida),
                          acerto
                              ? '✅ ¡Correcto! ${pregunta.explicacion}'
                              : '🤔 Casi… ¡inténtalo otra vez!',
                          style: TextStyle(
                            color: acerto
                                ? ColoresJuego.correcto
                                : ColoresJuego.incorrecto,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (acerto)
          Positioned.fill(
            child: ExplosionConfeti(key: ValueKey(pregunta.pregunta)),
          ),
      ],
    );
  }
}

enum EstadoOpcion { normal, correcta, incorrecta }

class BotonOpcion extends StatelessWidget {
  const BotonOpcion({
    super.key,
    required this.texto,
    required this.estado,
    required this.onTap,
    this.letra,
  });
  final String texto;
  final EstadoOpcion estado;
  final VoidCallback? onTap;
  final String? letra;

  static const _colores = [
    Color(0xFF4361EE),
    Color(0xFFFF8A00),
    Color(0xFF8B5CF6),
    Color(0xFF06B6A4),
  ];

  @override
  Widget build(BuildContext context) {
    final indice = letra == null ? 0 : 'ABCD'.indexOf(letra!);
    final base = switch (estado) {
      EstadoOpcion.correcta => ColoresJuego.correcto,
      EstadoOpcion.incorrecta => ColoresJuego.incorrecto,
      EstadoOpcion.normal => _colores[indice.clamp(0, 3)],
    };
    final lleno = estado != EstadoOpcion.normal;
    return TweenAnimationBuilder<double>(
      key: ValueKey(estado),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (_, v, child) => Transform.translate(
        offset: Offset(
          estado == EstadoOpcion.incorrecta
              ? math.sin(v * math.pi * 6) * 8 * (1 - v)
              : 0,
          0,
        ),
        child: Transform.scale(
          scale: estado == EstadoOpcion.correcta
              ? 1 + 0.06 * math.sin(v * math.pi)
              : 1,
          child: child,
        ),
      ),
      child: Rebote(
        onTap: onTap,
        escala: 0.96,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: lleno ? base : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: base, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: oscurecer(base, 0.25),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: lleno ? Colors.white : base,
                  shape: BoxShape.circle,
                ),
                child: estado == EstadoOpcion.normal
                    ? Text(
                        letra ?? '•',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      )
                    : Icon(
                        estado == EstadoOpcion.correcta
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                        color: base,
                        size: 26,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: lleno ? Colors.white : ColoresJuego.texto,
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
