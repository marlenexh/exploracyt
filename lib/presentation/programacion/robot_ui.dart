import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../biology/temas/pasos.dart' show estrellasPorErrores;
import '../electronica/comun.dart';
import 'robot.dart';

const colorMovimiento = Color(0xFF4C97FF);
const colorAccion = Color(0xFF59C059);
const colorControl = Color(0xFFFFAB19);
const colorEvento = Color(0xFFFFBF00);
const colorSensor = Color(0xFF5CB1D6);

Color colorDe(TipoBloque t) => switch (t) {
      TipoBloque.avanzar || TipoBloque.izquierda || TipoBloque.derecha => colorMovimiento,
      TipoBloque.recoger => colorAccion,
      _ => colorControl,
    };

/// Actividad: programar al robot para superar uno o varios niveles.
class ProgramaRobot extends StatefulWidget {
  const ProgramaRobot({super.key, required this.actividad, required this.seccion, required this.titulo, required this.color, required this.niveles, required this.mensajeFinal});
  final String actividad, seccion, titulo, mensajeFinal;
  final Color color;
  final List<NivelRobot> niveles;
  @override
  State<ProgramaRobot> createState() => ProgramaRobotState();
}

enum _TipoFila { inicio, cabecera, sino, fin }

class _Fila {
  _Fila(this.tipo, this.lista, this.indice, this.nivel, [this.b]);
  final _TipoFila tipo;
  final List<Bloque> lista;
  final int indice, nivel;
  final Bloque? b;
  bool cursorAntes = false;
}

class ProgramaRobotState extends State<ProgramaRobot> {
  int _n = 0;
  late List<Bloque> programa;
  late List<Bloque> _cursorLista;
  int _cursorPos = 0;
  int? _sel;
  Ejecucion? _ej;
  int _paso = 0;
  Timer? _timer;
  bool _completo = false;
  int _errores = 0;
  late String _mensaje;

  NivelRobot get nivel => widget.niveles[_n];

  @override
  void initState() {
    super.initState();
    _nuevo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nuevo() {
    programa = nivel.inicial?.call() ?? [];
    _cursorLista = programa;
    _cursorPos = programa.length;
    _sel = null;
    _ej = null;
    _paso = 0;
    _completo = false;
    _mensaje = nivel.instruccion;
  }

  bool get corriendo => _timer?.isActive ?? false;

  // --- Edición ---------------------------------------------------------------

  void agregar(TipoBloque t) {
    if (corriendo) return;
    HapticFeedback.selectionClick();
    setState(() {
      final b = Bloque(t, cond: nivel.condiciones.first, veces: t == TipoBloque.repetir ? 4 : 3);
      _cursorLista.insert(_cursorPos.clamp(0, _cursorLista.length), b);
      _sel = b.id;
      if (t.contenedor) {
        _cursorLista = b.hijos;
        _cursorPos = 0;
      } else {
        _cursorPos++;
      }
      _ej = null;
    });
  }

  (List<Bloque>, int)? _buscar(List<Bloque> l, int id) {
    for (var i = 0; i < l.length; i++) {
      if (l[i].id == id) return (l, i);
      final h = _buscar(l[i].hijos, id) ?? _buscar(l[i].sino, id);
      if (h != null) return h;
    }
    return null;
  }

  bool _contiene(Bloque b, List<Bloque> lista) {
    if (identical(b.hijos, lista) || identical(b.sino, lista)) return true;
    return [...b.hijos, ...b.sino].any((h) => _contiene(h, lista));
  }

  void borrar() {
    final s = _sel;
    if (s == null || corriendo) return;
    final r = _buscar(programa, s);
    if (r == null) return;
    setState(() {
      final (l, i) = r;
      final b = l.removeAt(i);
      if (_contiene(b, _cursorLista)) {
        _cursorLista = l;
        _cursorPos = i;
      } else if (identical(_cursorLista, l) && _cursorPos > i) {
        _cursorPos--;
      }
      _sel = null;
      _ej = null;
    });
  }

  void mover(int delta) {
    final s = _sel;
    if (s == null || corriendo) return;
    final r = _buscar(programa, s);
    if (r == null) return;
    final (l, i) = r;
    final j = i + delta;
    if (j < 0 || j >= l.length) return;
    setState(() {
      final b = l.removeAt(i);
      l.insert(j, b);
      _ej = null;
    });
  }

  void borrarTodo() {
    if (corriendo) return;
    setState(() {
      programa.clear();
      _cursorLista = programa;
      _cursorPos = 0;
      _sel = null;
      _ej = null;
    });
  }

  void _tocarFila(_Fila f) {
    if (corriendo) return;
    setState(() {
      final b = f.b;
      switch (f.tipo) {
        case _TipoFila.inicio:
          _cursorLista = programa;
          _cursorPos = 0;
          _sel = null;
        case _TipoFila.cabecera:
          _sel = b!.id;
          if (b.tipo.contenedor) {
            _cursorLista = b.hijos;
            _cursorPos = b.hijos.length;
          } else {
            _cursorLista = f.lista;
            _cursorPos = f.indice + 1;
          }
        case _TipoFila.sino:
          _sel = b!.id;
          _cursorLista = b.sino;
          _cursorPos = b.sino.length;
        case _TipoFila.fin:
          _sel = b!.id;
          _cursorLista = f.lista;
          _cursorPos = f.indice + 1;
      }
    });
  }

  List<_Fila> _filas() {
    final out = <_Fila>[_Fila(_TipoFila.inicio, programa, 0, 0)];
    var marcarSiguiente = false;
    void agregarFila(_Fila f) {
      if (marcarSiguiente) {
        f.cursorAntes = true;
        marcarSiguiente = false;
      }
      out.add(f);
    }

    void lista(List<Bloque> l, int nivel) {
      for (var i = 0; i < l.length; i++) {
        if (identical(l, _cursorLista) && _cursorPos == i) marcarSiguiente = true;
        final b = l[i];
        agregarFila(_Fila(_TipoFila.cabecera, l, i, nivel, b));
        if (b.tipo.contenedor) {
          lista(b.hijos, nivel + 1);
          if (b.tipo == TipoBloque.siSino) {
            agregarFila(_Fila(_TipoFila.sino, l, i, nivel, b));
            lista(b.sino, nivel + 1);
          }
          agregarFila(_Fila(_TipoFila.fin, l, i, nivel, b));
        }
      }
      if (identical(l, _cursorLista) && _cursorPos >= l.length) marcarSiguiente = true;
    }

    lista(programa, 1);
    if (marcarSiguiente) out.add(_Fila(_TipoFila.fin, programa, -1, 0)..cursorAntes = true);
    return out;
  }

  // --- Ejecución -------------------------------------------------------------

  void ejecutar() {
    if (corriendo) return;
    HapticFeedback.lightImpact();
    final ej = ejecutarRobot(nivel, programa);
    setState(() {
      _ej = ej;
      _paso = 0;
      _mensaje = '▶️ Ejecutando el programa…';
    });
    _timer = Timer.periodic(const Duration(milliseconds: 320), (t) {
      if (!mounted) return t.cancel();
      if (_paso >= ej.pasos.length - 1) {
        t.cancel();
        _terminar(ej);
        return;
      }
      setState(() => _paso++);
    });
  }

  void _terminar(Ejecucion ej) {
    setState(() {
      final total = contarBloques(programa);
      switch (ej.resultado) {
        case Resultado.exito:
          _completo = true;
          HapticFeedback.mediumImpact();
          _mensaje = '¡Lo lograste! 🎉 ${nivel.logro}';
        case Resultado.choque:
          _mensaje = '¡Pum! 💥 El robot chocó con una pared en el bloque resaltado. Corrige ese paso y vuelve a ejecutar.';
        case Resultado.sinMeta:
          _mensaje = 'El programa terminó, pero el robot no llegó a la meta 🏁. Revisa qué pasos faltan.';
        case Resultado.faltanGemas:
          _mensaje = 'Llegaste a la meta, pero faltan gemas 💎. Usa “recoger gema” cuando el robot esté sobre una.';
        case Resultado.cicloInfinito:
          _mensaje = '🔄 ¡Ciclo infinito! El robot repetiría para siempre. Revisa la condición o lo que hay dentro del ciclo.';
        case Resultado.dibujoIncompleto:
          _mensaje = 'El dibujo no es igual al modelo punteado. Compara las líneas y corrige tu programa.';
        case Resultado.muyLargo:
          _mensaje = '¡Funciona! Pero usaste $total bloques y el reto pide máximo ${nivel.maxBloques}. Usa “repetir” para que tu programa sea más corto.';
      }
      if (!_completo) {
        _errores++;
        HapticFeedback.heavyImpact();
        if (nivel.pista != null && _errores >= 2) _mensaje += '\n💡 Pista: ${nivel.pista}';
      }
    });
  }

  void reiniciar() {
    _timer?.cancel();
    setState(() {
      _ej = null;
      _paso = 0;
      if (!_completo) _mensaje = nivel.instruccion;
    });
  }

  void _siguiente() {
    if (_n < widget.niveles.length - 1) {
      setState(() {
        _n++;
        _nuevo();
      });
    } else {
      terminarPaso(context, actividad: widget.actividad, estrellas: estrellasPorErrores(_errores), titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal);
    }
  }

  // --- Interfaz --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final filas = _filas();
    final activo = _ej == null ? null : _ej!.pasos[_paso].bloque;
    final total = contarBloques(programa);
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.seccion, widget.niveles.length > 1 ? '${widget.titulo} · Nivel ${_n + 1} de ${widget.niveles.length}' : widget.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 160, child: GloboZatiEle(_mensaje, tam: 12.5)),
        Positioned(
          left: 8,
          top: 226,
          width: 230,
          height: 246,
          child: PanelEle(
            titulo: 'Bloques',
            icono: Icons.extension_rounded,
            color: colorControl,
            child: SingleChildScrollView(
              child: Wrap(spacing: 5, runSpacing: 5, children: [
                for (final t in TipoBloque.values)
                  if (nivel.bloques.contains(t))
                    Tooltip(
                      message: 'Agregar ${t.nombre}',
                      child: GestureDetector(
                        onTap: () => agregar(t),
                        child: _PiezaBloque(texto: '${t.emoji} ${t.nombre}', color: colorDe(t)),
                      ),
                    ),
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text('Toca un bloque para ponerlo donde está la línea amarilla del programa.', style: TextStyle(fontSize: 11, height: 1.15, color: Colors.black54)),
                ),
              ]),
            ),
          ),
        ),
        // Editor
        Positioned(
          left: 244,
          top: 60,
          width: 286,
          height: 352,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFFF9F9FB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFB0BEC5), width: 2)),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: const BoxDecoration(color: Color(0xFFE3E8EF), borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
                child: Row(children: [
                  Text('Programa · $total bloque${total == 1 ? '' : 's'}${nivel.maxBloques != null ? ' (máx. ${nivel.maxBloques})' : ''}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: nivel.maxBloques != null && total > nivel.maxBloques! ? ColoresJuego.incorrecto : const Color(0xFF455A64))),
                  const Spacer(),
                  _Mini(Icons.arrow_upward_rounded, 'Subir bloque', _sel == null ? null : () => mover(-1)),
                  _Mini(Icons.arrow_downward_rounded, 'Bajar bloque', _sel == null ? null : () => mover(1)),
                  _Mini(Icons.delete_rounded, 'Borrar bloque', _sel == null ? null : borrar),
                ]),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(6, 4, 6, 8),
                  children: [for (final f in filas) _fila(f, activo)],
                ),
              ),
            ]),
          ),
        ),
        // Mundo
        Positioned(
          left: 536,
          top: 60,
          width: 316,
          height: 352,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorMundo(nivel, _ej == null ? null : _ej!.pasos[_paso], t))),
          ),
        ),
        Positioned(
          left: 244,
          top: 420,
          child: Row(children: [
            Tooltip(
              message: 'Ejecutar programa',
              child: BotonJuego(texto: 'Ejecutar', icono: Icons.play_arrow_rounded, color: const Color(0xFF2DB84C), onTap: _completo ? null : ejecutar),
            ),
            const SizedBox(width: 8),
            Tooltip(message: 'Reiniciar robot', child: BotonJuego(texto: 'Reiniciar', icono: Icons.replay_rounded, color: const Color(0xFF78909C), onTap: reiniciar)),
            const SizedBox(width: 8),
            Tooltip(message: 'Borrar todo', child: BotonJuego(texto: '', icono: Icons.delete_sweep_rounded, color: const Color(0xFFE57373), onTap: borrarTodo)),
          ]),
        ),
        if (_completo)
          Positioned(left: 690, top: 420, child: BotonSiguiente(texto: _n < widget.niveles.length - 1 ? 'Siguiente nivel' : 'Terminar', onTap: _siguiente)),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _fila(_Fila f, int? activo) {
    final b = f.b;
    final cursor = f.cursorAntes
        ? Container(height: 4, margin: EdgeInsets.only(left: 12.0 * f.nivel, bottom: 2), decoration: BoxDecoration(color: const Color(0xFFFFD600), borderRadius: BorderRadius.circular(2)))
        : null;
    if (f.indice == -1) return cursor ?? const SizedBox();
    Widget contenido;
    switch (f.tipo) {
      case _TipoFila.inicio:
        contenido = _PiezaBloque(texto: '🚩 al empezar', color: colorEvento, sombrero: true);
      case _TipoFila.cabecera:
        final t = b!.tipo;
        contenido = Wrap(crossAxisAlignment: WrapCrossAlignment.center, spacing: 3, children: [
          _PiezaBloque(texto: '${t.emoji} ${t.nombre}', color: colorDe(t), activo: b.id == activo, seleccionado: b.id == _sel),
          if (t == TipoBloque.repetir)
            Tooltip(
              message: 'Cambiar veces',
              child: GestureDetector(
                onTap: corriendo
                    ? null
                    : () => setState(() {
                          b.veces = b.veces % 10 + 1;
                          _ej = null;
                        }),
                child: _Valor('${b.veces} veces'),
              ),
            ),
          if (t == TipoBloque.si || t == TipoBloque.siSino || t == TipoBloque.mientras)
            Tooltip(
              message: 'Cambiar condición',
              child: GestureDetector(
                onTap: corriendo
                    ? null
                    : () => setState(() {
                          final cs = nivel.condiciones;
                          b.cond = cs[(cs.indexOf(b.cond) + 1) % cs.length];
                          _ej = null;
                        }),
                child: _Valor(b.cond.texto, color: colorSensor),
              ),
            ),
        ]);
      case _TipoFila.sino:
        contenido = _PiezaBloque(texto: 'si no', color: colorControl, fino: true, seleccionado: b!.id == _sel);
      case _TipoFila.fin:
        contenido = Container(width: 60, height: 9, decoration: BoxDecoration(color: colorControl, borderRadius: BorderRadius.circular(4)));
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
      if (cursor != null) cursor,
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _tocarFila(f),
        child: Padding(padding: EdgeInsets.only(left: 12.0 * f.nivel, bottom: 3), child: Align(alignment: Alignment.centerLeft, child: contenido)),
      ),
    ]);
  }

  // Para pruebas.
  bool get completo => _completo;
  int get errores => _errores;
  int get nivelActual => _n;
}

class _PiezaBloque extends StatelessWidget {
  const _PiezaBloque({required this.texto, required this.color, this.activo = false, this.seleccionado = false, this.sombrero = false, this.fino = false});
  final String texto;
  final Color color;
  final bool activo, seleccionado, sombrero, fino;
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: fino ? 2 : 4),
        decoration: BoxDecoration(
          color: activo ? aclarar(color, 0.35) : color,
          borderRadius: sombrero ? const BorderRadius.vertical(top: Radius.circular(14), bottom: Radius.circular(6)) : BorderRadius.circular(7),
          border: Border.all(color: seleccionado ? const Color(0xFF212121) : (activo ? Colors.white : oscurecer(color, 0.2)), width: seleccionado || activo ? 2.5 : 1.2),
          boxShadow: [BoxShadow(color: oscurecer(color, 0.35), offset: const Offset(0, 2))],
        ),
        child: Text(texto, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
      );
}

class _Valor extends StatelessWidget {
  const _Valor(this.t, {this.color = Colors.white});
  final String t;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.black26)),
        child: Text('$t ▾', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color == Colors.white ? ColoresJuego.texto : Colors.white)),
      );
}

class _Mini extends StatelessWidget {
  const _Mini(this.icono, this.tooltip, this.onTap);
  final IconData icono;
  final String tooltip;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: const EdgeInsets.all(3), child: Icon(icono, size: 19, color: onTap == null ? Colors.black26 : const Color(0xFF455A64))),
        ),
      );
}

/// Dibuja la cuadrícula, la meta, las gemas, el trazo y el robot.
class _PintorMundo extends CustomPainter {
  _PintorMundo(this.nivel, this.paso, this.t);
  final NivelRobot nivel;
  final PasoRobot? paso;
  final double t;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(nivel.dibujo != null ? const Color(0xFFFFFDF5) : const Color(0xFFE8F5E9)));
    final cel = math.min((s.width - 16) / nivel.columnas, (s.height - 16) / nivel.filas);
    final o = Offset((s.width - cel * nivel.columnas) / 2, (s.height - cel * nivel.filas) / 2);
    Offset centro(int x, int y) => o + Offset((x + 0.5) * cel, (y + 0.5) * cel);
    final dibujo = nivel.dibujo;
    if (dibujo != null) {
      // Papel cuadriculado con puntos en las esquinas
      Offset punto(int x, int y) => o + Offset(x * cel, y * cel);
      for (var y = 0; y <= nivel.filas; y++) {
        for (var x = 0; x <= nivel.columnas; x++) {
          c.drawCircle(punto(x, y), 2, relleno(const Color(0xFFB0BEC5)));
        }
      }
      Offset centroP(int x, int y) => centro(x, y);
      void segs(Set<String> ss, Paint p) {
        for (final sg in ss) {
          final ps = sg.split('-').map((q) => q.split(',').map(int.parse).toList()).toList();
          c.drawLine(centroP(ps[0][0], ps[0][1]), centroP(ps[1][0], ps[1][1]), p);
        }
      }

      segs(dibujo, linea(const Color(0x55607D8B), cel * 0.22)..strokeCap = StrokeCap.round);
      segs(paso?.trazo ?? const {}, linea(const Color(0xFF7C4DFF), cel * 0.14)..strokeCap = StrokeCap.round);
    } else {
      for (var y = 0; y < nivel.filas; y++) {
        for (var x = 0; x < nivel.columnas; x++) {
          final r = Rect.fromLTWH(o.dx + x * cel, o.dy + y * cel, cel, cel).deflate(1.5);
          final ch = nivel.celda(x, y);
          if (ch == '#') {
            c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(cel * 0.15)), relleno(const Color(0xFF5D6D7E)));
            c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r.left, r.top, r.width, r.height * 0.3), Radius.circular(cel * 0.15)), relleno(const Color(0xFF66BB6A)));
          } else {
            c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(cel * 0.12)), relleno((x + y).isEven ? const Color(0xFFFFF8E1) : const Color(0xFFFFECB3)));
            if (ch == 'M') dibujarEmoji(c, '🏁', r.center, cel * 0.62);
            if (ch == 'G' && !(paso?.gemas.contains((x, y)) ?? false)) dibujarEmoji(c, '💎', r.center + Offset(0, math.sin(t * 3 + x) * cel * 0.04), cel * 0.5);
            if (ch == 'S') c.drawCircle(r.center, cel * 0.1, relleno(const Color(0x334C97FF)));
          }
        }
      }
    }
    final (x0, y0) = nivel.inicio;
    final p = paso;
    final pos = centro(p?.x ?? x0, p?.y ?? y0);
    final dir = p?.dir ?? nivel.dir;
    _robot(c, pos, cel * 0.8, dir, choque: p?.evento == Evento.choque, festejo: p?.evento == Evento.recoger);
  }

  void _robot(Canvas c, Offset p, double tam, Dir d, {bool choque = false, bool festejo = false}) {
    final u = tam / 10;
    c.save();
    c.translate(p.dx, p.dy + (festejo ? -u * math.sin(t * 20).abs() : 0));
    // Flecha de dirección
    final ang = math.atan2(d.dy.toDouble(), d.dx.toDouble());
    c.save();
    c.rotate(ang);
    final f = Path()
      ..moveTo(5.2 * u, 0)
      ..lineTo(3.6 * u, -1.6 * u)
      ..lineTo(3.6 * u, 1.6 * u)
      ..close();
    c.drawPath(f, relleno(const Color(0xFFFF7043)));
    c.restore();
    final cuerpo = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, u * 0.6), width: 7 * u, height: 6 * u), Radius.circular(1.8 * u));
    c.drawRRect(cuerpo.shift(Offset(0, u * 0.5)), relleno(const Color(0x33000000)));
    c.drawRRect(cuerpo, relleno(choque ? const Color(0xFFE57373) : const Color(0xFF4C97FF)));
    c.drawRRect(cuerpo, linea(const Color(0xFF1E4FA3), u * 0.4));
    c.drawLine(Offset(0, -2.4 * u), Offset(0, -3.6 * u), linea(const Color(0xFF1E4FA3), u * 0.4));
    c.drawCircle(Offset(0, -3.9 * u), u * 0.6, relleno(const Color(0xFFFFD600)));
    // Cara mirando hacia donde avanza
    final mx = d.dx * 0.8 * u, my = d.dy * 0.5 * u;
    for (final ex in [-1.4, 1.4]) {
      c.drawCircle(Offset(ex * u + mx, my), 1.1 * u, relleno(Colors.white));
      c.drawCircle(Offset(ex * u + mx * 1.3, my * 1.3), 0.5 * u, relleno(const Color(0xFF263238)));
    }
    c.drawArc(Rect.fromCenter(center: Offset(mx, 1.8 * u + my), width: 2.4 * u, height: 1.4 * u), 0, math.pi, false, linea(Colors.white, u * 0.35));
    if (choque) textoEn(c, '💥', Offset(d.dx * 4 * u, d.dy * 4 * u), tam: 4 * u);
    c.restore();
  }

  @override
  bool shouldRepaint(_PintorMundo old) => true;
}
