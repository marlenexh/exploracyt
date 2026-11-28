import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'animaciones_tour.dart';
import 'comunes.dart';
import 'contenido.dart';
import 'pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'progreso.dart';
import '../../ciencia/barajar.dart';

class PantallaRetos extends StatelessWidget {
  const PantallaRetos({super.key});
  @override
  Widget build(BuildContext context) {
    final p = ProgresoScope.of(context);
    final items = [
      (
        'Supercerebro',
        '10 preguntas, 3 vidas. ¿Cuánto sabes?',
        Icons.psychology_rounded,
        const Color(0xFFFF7043),
        Actividades.retoQuiz,
        const RetoQuiz(),
      ),
      (
        'Arma el cuerpo',
        'Arrastra cada órgano a su lugar.',
        Icons.extension_rounded,
        ColoresJuego.intro,
        Actividades.retoArma,
        const RetoArmaCuerpo(),
      ),
      (
        'La ruta de la sangre y el aire',
        'Ordena los pasos del viaje.',
        Icons.route_rounded,
        ColoresJuego.circulatorio,
        Actividades.retoRuta,
        const RetoRuta(),
      ),
      (
        'Defensa inmune',
        '¡Detén a los microbios sin atacar a tus células!',
        Icons.sports_esports_rounded,
        ColoresJuego.inmune,
        Actividades.retoDefensa,
        const RetoDefensa(),
      ),
    ];
    return Scaffold(
      appBar: barraJuego('Retos', ColoresJuego.retos),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BurbujaCora(
            texto:
                '¡Hora de poner a prueba todo lo que aprendiste! Cada reto da hasta 3 estrellas.',
          ),
          const SizedBox(height: 16),
          for (final it in items) ...[
            TarjetaActividad(
              indice: items.indexOf(it),
              titulo: it.$1,
              subtitulo: it.$2,
              icono: it.$3,
              color: it.$4,
              estrellas: p.estrellasDe(it.$5),
              onTap: () => abrirPantalla(context, it.$6, color: it.$4),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

// ===========================================================================
// Reto 1: Supercerebro (quiz)
// ===========================================================================

class RetoQuiz extends StatefulWidget {
  const RetoQuiz({super.key});
  @override
  State<RetoQuiz> createState() => _RetoQuizState();
}

class _RetoQuizState extends State<RetoQuiz> {
  static const _color = Color(0xFFFF7043);
  static const _total = 10;
  static const _segundos = 25;
  late List<PreguntaQuiz> _preguntas;
  int _i = 0, _aciertos = 0, _vidas = 3, _racha = 0;
  int? _elegida;
  int _restante = _segundos;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final todas = List.of(bancoPreguntas)..shuffle();
    _preguntas = todas.take(_total).toList();
    _iniciarTiempo();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarTiempo() {
    _timer?.cancel();
    _restante = _segundos;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_elegida != null) return;
      setState(() => _restante--);
      if (_restante <= 0) _responder(-1);
    });
  }

  void _responder(int i) {
    if (_elegida != null) return;
    final ok = i == _preguntas[_i].correcta;
    setState(() {
      _elegida = i;
      if (ok) {
        _aciertos++;
        _racha++;
      } else {
        _vidas--;
        _racha = 0;
      }
    });
  }

  Future<void> _siguiente() async {
    if (_vidas <= 0 || _i == _preguntas.length - 1) {
      _timer?.cancel();
      final estrellas = _vidas <= 0
          ? 0
          : (_aciertos >= 9
              ? 3
              : _aciertos >= 7
                  ? 2
                  : 1);
      await otorgarEstrellas(
        context,
        actividad: Actividades.retoQuiz,
        estrellas: estrellas,
        titulo: _vidas <= 0 ? '¡Te quedaste sin vidas!' : '¡Reto terminado!',
        mensaje: 'Respondiste bien $_aciertos de ${_i + 1} preguntas. '
            '${estrellas < 3 ? 'Repasa el recorrido y vuelve a intentarlo.' : '¡Tienes un supercerebro!'}',
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }
    setState(() {
      _i++;
      _elegida = null;
    });
    _iniciarTiempo();
  }

  @override
  Widget build(BuildContext context) {
    final q = _preguntas[_i];
    final temaColor = switch (q.tema) {
      'circulatorio' => ColoresJuego.circulatorio,
      'respiratorio' => ColoresJuego.respiratorio,
      'inmune' => ColoresJuego.inmune,
      _ => ColoresJuego.intro,
    };
    return Scaffold(
      appBar: barraJuego('Supercerebro', _color),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    for (var v = 0; v < 3; v++)
                      Icon(
                        v < _vidas
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: ColoresJuego.circulatorio,
                      ),
                    const Spacer(),
                    if (_racha >= 2)
                      Chip(
                        label: Text('🔥 Racha x$_racha'),
                        visualDensity: VisualDensity.compact,
                      ),
                    const SizedBox(width: 8),
                    Text(
                      '${_i + 1}/${_preguntas.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _restante / _segundos,
                    minHeight: 10,
                    color: _restante > 8 ? _color : ColoresJuego.incorrecto,
                    backgroundColor: _color.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [temaColor, aclarar(temaColor, 0.25)],
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: oscurecer(temaColor, 0.3),
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Text(
                    q.pregunta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                for (final (posI, i) in ordenOpciones(q.pregunta, q.opciones.length).indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: BotonOpcion(
                      letra: 'ABCD'[posI],
                      texto: q.opciones[i],
                      estado: _elegida == null
                          ? EstadoOpcion.normal
                          : i == q.correcta
                              ? EstadoOpcion.correcta
                              : i == _elegida
                                  ? EstadoOpcion.incorrecta
                                  : EstadoOpcion.normal,
                      onTap: _elegida == null ? () => _responder(i) : null,
                    ),
                  ),
                if (_elegida != null) ...[
                  const SizedBox(height: 6),
                  BurbujaCora(
                    emocion: _elegida == q.correcta
                        ? EmocionCora.feliz
                        : EmocionCora.triste,
                    texto:
                        '${_elegida == q.correcta ? '¡Correcto! ' : _elegida == -1 ? '¡Se acabó el tiempo! ' : '¡Ups! '}${q.explicacion}',
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _color),
                    onPressed: _siguiente,
                    child: Text(
                      _vidas <= 0 || _i == _preguntas.length - 1
                          ? 'Ver resultado'
                          : 'Siguiente',
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_elegida != null && _elegida == q.correcta)
            Positioned.fill(child: ExplosionConfeti(key: ValueKey('q$_i'))),
        ],
      ),
    );
  }
}

// ===========================================================================
// Reto 2: Arma el cuerpo
// ===========================================================================

class RetoArmaCuerpo extends StatefulWidget {
  const RetoArmaCuerpo({super.key});
  @override
  State<RetoArmaCuerpo> createState() => _RetoArmaCuerpoState();
}

class _RetoArmaCuerpoState extends State<RetoArmaCuerpo> {
  final _colocados = <String>{};
  int _errores = 0;
  String? _mensaje;
  final _reloj = Stopwatch()..start();
  late final List<PosicionOrgano> _bandeja = List.of(posicionesOrganos)
    ..shuffle();

  void _soltar(PosicionOrgano destino, String id) {
    if (destino.id == id) {
      setState(() {
        _colocados.add(id);
        _mensaje = '¡Bien! ${infoOrganos[id]!.descripcion}';
      });
      if (_colocados.length == posicionesOrganos.length) _ganar();
    } else {
      setState(() {
        _errores++;
        _mensaje =
            'Ahí no va ${infoOrganos[id]!.nombre.toLowerCase()}. Pista: ${_pista(id)}';
      });
    }
  }

  String _pista(String id) => switch (id) {
        'cerebro' => 'está protegido por el cráneo.',
        'pulmones' => 'ocupan casi todo el pecho.',
        'corazon' => 'está entre los pulmones, un poco a la izquierda.',
        'higado' => 'está en el lado derecho, debajo de las costillas.',
        'estomago' => 'está a la izquierda, debajo del corazón.',
        _ => 'están en la parte baja del abdomen.',
      };

  Future<void> _ganar() async {
    _reloj.stop();
    final seg = _reloj.elapsed.inSeconds;
    final estrellas = _errores == 0 ? 3 : (_errores <= 2 ? 2 : 1);
    await otorgarEstrellas(
      context,
      actividad: Actividades.retoArma,
      estrellas: estrellas,
      titulo: '¡Cuerpo completo!',
      mensaje: 'Lo armaste en $seg segundos con $_errores errores.',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraJuego('Arma el cuerpo', ColoresJuego.intro),
      body: LayoutBuilder(
        builder: (context, total) {
          final silueta = LayoutBuilder(
            builder: (context, cons) {
              final size = Size(cons.maxWidth, cons.maxHeight);
              final caja = Silueta.caja(size);
              return Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _PintorSiluetaReto(caja, _colocados),
                    ),
                  ),
                  for (final o in posicionesOrganos)
                    Positioned.fromRect(
                      rect: Rect.fromCenter(
                        center: Silueta.punto(caja, o.centro),
                        width: o.tamano.width * caja.width,
                        height: o.tamano.height * caja.height,
                      ),
                      child: DragTarget<String>(
                        onWillAcceptWithDetails: (_) =>
                            !_colocados.contains(o.id),
                        onAcceptWithDetails: (d) => _soltar(o, d.data),
                        builder: (context, candidatos, _) => _colocados
                                .contains(o.id)
                            ? const SizedBox.shrink()
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  color: candidatos.isNotEmpty
                                      ? ColoresJuego.intro.withValues(
                                          alpha: 0.35,
                                        )
                                      : Colors.white.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ColoresJuego.intro,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: ColoresJuego.intro,
                                    size: 16,
                                  ),
                                ),
                              ),
                      ),
                    ),
                ],
              );
            },
          );
          final fichas = [
            for (final o in _bandeja)
              if (!_colocados.contains(o.id))
                Draggable<String>(
                  data: o.id,
                  feedback: Material(
                    color: Colors.transparent,
                    child: IconoOrgano(o.id, tam: 80),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: _Ficha(o)),
                  child: _Ficha(o),
                ),
          ];
          final burbuja = _mensaje == null
              ? null
              : BurbujaCora(texto: _mensaje!, tamCora: 52);
          if (total.maxWidth > total.maxHeight * 1.2) {
            return Row(
              children: [
                Expanded(child: silueta),
                Container(
                  width: math.min(380, total.maxWidth * 0.45),
                  margin: const EdgeInsets.fromLTRB(0, 6, 12, 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: ColoresJuego.intro, width: 3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      burbuja ??
                          const Text(
                            'Arrastra cada órgano a su lugar en el cuerpo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          children: fichas,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: silueta),
              if (burbuja != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: burbuja,
                ),
              Container(
                height: 108,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(8),
                  children: [
                    for (final f in fichas)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: f,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Ficha extends StatelessWidget {
  const _Ficha(this.o);
  final PosicionOrgano o;
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconoOrgano(o.id, tam: 64),
          Text(
            o.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      );
}

class _PintorSiluetaReto extends CustomPainter {
  _PintorSiluetaReto(this.caja, this.colocados);
  final Rect caja;
  final Set<String> colocados;
  @override
  void paint(Canvas c, Size s) {
    Silueta.dibujar(c, caja, borde: const Color(0xFFE0A88A));
    for (final o in posicionesOrganos) {
      if (!colocados.contains(o.id)) continue;
      DibujoOrganos.dibujar(
        c,
        Rect.fromCenter(
          center: Silueta.punto(caja, o.centro),
          width: o.tamano.width * caja.width,
          height: o.tamano.height * caja.height,
        ),
        o.id,
      );
    }
  }

  @override
  bool shouldRepaint(_PintorSiluetaReto old) => true;
}

// ===========================================================================
// Reto 3: Ordena la ruta
// ===========================================================================

class RetoRuta extends StatefulWidget {
  /// [nivel] 0 = ruta de la sangre, 1 = ruta del aire, null = las dos.
  const RetoRuta({super.key, this.nivel});
  final int? nivel;
  @override
  State<RetoRuta> createState() => _RetoRutaState();
}

class _RetoRutaState extends State<RetoRuta> {
  static const _niveles = [
    (
      'La ruta de la sangre',
      ColoresJuego.circulatorio,
      [
        'La sangre con poco oxígeno llega por las venas cavas',
        'Entra a la aurícula derecha',
        'Pasa al ventrículo derecho',
        'Viaja por la arteria pulmonar a los pulmones',
        'En los pulmones se carga de oxígeno',
        'Regresa a la aurícula izquierda',
        'Pasa al ventrículo izquierdo',
        'Sale por la aorta hacia todo el cuerpo',
      ],
    ),
    (
      'La ruta del aire',
      ColoresJuego.respiratorio,
      [
        'Nariz',
        'Faringe',
        'Laringe',
        'Tráquea',
        'Bronquios',
        'Bronquiolos',
        'Alvéolos',
        'El oxígeno pasa a la sangre',
      ],
    ),
  ];
  late int _nivel = widget.nivel ?? 0;
  late List<String> _orden;
  bool _revisado = false;
  int _intentos = 0;
  final List<int> _intentosPorNivel = [];

  @override
  void initState() {
    super.initState();
    _mezclar();
  }

  void _mezclar() {
    final correcto = _niveles[_nivel].$3;
    do {
      _orden = List.of(correcto)..shuffle();
    } while (_orden.join() == correcto.join());
    _revisado = false;
    _intentos = 0;
  }

  bool get _todoBien {
    final c = _niveles[_nivel].$3;
    for (var i = 0; i < c.length; i++) {
      if (_orden[i] != c[i]) return false;
    }
    return true;
  }

  Future<void> _revisar() async {
    setState(() {
      _revisado = true;
      _intentos++;
    });
    if (!_todoBien) return;
    _intentosPorNivel.add(_intentos);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    if (widget.nivel == null && _nivel < _niveles.length - 1) {
      await mostrarCelebracion(
        context,
        titulo: '¡Ruta correcta!',
        mensaje: 'Ahora ordena la ruta del aire.',
        estrellas: 3,
      );
      setState(() {
        _nivel++;
        _mezclar();
      });
    } else {
      final total = _intentosPorNivel.fold(0, (a, b) => a + b);
      final rutas = _intentosPorNivel.length;
      final estrellas = total <= rutas ? 3 : (total <= rutas * 2 ? 2 : 1);
      await otorgarEstrellas(
        context,
        actividad:
            widget.nivel == 1 ? Actividades.retoRutaAire : Actividades.retoRuta,
        estrellas: estrellas,
        titulo: '¡Experto en rutas!',
        mensaje: rutas == 1
            ? 'Ordenaste la ruta en $total ${total == 1 ? 'intento' : 'intentos'}.'
            : 'Ordenaste las dos rutas en $total intentos.',
      );
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final (titulo, color, correcto) = _niveles[_nivel];
    return Scaffold(
      appBar: barraJuego(titulo, color),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: BurbujaCora(
              tamCora: 48,
              texto: _revisado && !_todoBien
                  ? 'Los pasos en rojo no están en su lugar. ¡Muévelos e inténtalo de nuevo!'
                  : 'Mantén presionado un paso y arrástralo para ponerlo en orden, del primero al último.',
            ),
          ),
          Expanded(
            child: ReorderableListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onReorderItem: (a, b) => setState(() {
                final x = _orden.removeAt(a);
                _orden.insert(b, x);
                _revisado = false;
              }),
              children: [
                for (var i = 0; i < _orden.length; i++)
                  Card(
                    key: ValueKey(_orden[i]),
                    color: !_revisado
                        ? Colors.white
                        : (_orden[i] == correcto[i]
                            ? const Color(0xFFE8F5E9)
                            : const Color(0xFFFFEBEE)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: color,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _orden[i],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.drag_handle_rounded),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: color),
                  onPressed: _revisar,
                  icon: const Icon(Icons.fact_check_rounded),
                  label: const Text('Revisar orden'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// Reto 4: Defensa inmune (juego de acción)
// ===========================================================================

enum _TipoEnte { bacteria, virus, globuloRojo }

class _Ente {
  _Ente(this.tipo, this.pos, this.vel);
  final _TipoEnte tipo;
  Offset pos; // 0–1
  Offset vel;
  double muerte = 0; // >0 animación de eliminación
  bool get malo => tipo != _TipoEnte.globuloRojo;
}

class RetoDefensa extends StatefulWidget {
  const RetoDefensa({super.key});
  @override
  State<RetoDefensa> createState() => _RetoDefensaState();
}

class _RetoDefensaState extends State<RetoDefensa>
    with SingleTickerProviderStateMixin {
  static const _duracion = 45.0;
  final _rnd = math.Random();
  late final Ticker _ticker;
  final _entes = <_Ente>[];
  final _destellos = <(Offset, double, bool)>[]; // posición, edad, acierto
  double _t = 0, _ultimo = 0, _proximo = 0;
  int _puntos = 0, _vidas = 5, _eliminados = 0, _errores = 0;
  double _carga = 0; // anticuerpos 0–1
  bool _jugando = false, _terminado = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_paso);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _comenzar() {
    setState(() {
      _entes.clear();
      _destellos.clear();
      _t = 0;
      _ultimo = 0;
      _proximo = 0;
      _puntos = 0;
      _vidas = 5;
      _eliminados = 0;
      _errores = 0;
      _carga = 0;
      _jugando = true;
      _terminado = false;
    });
    _ticker
      ..stop()
      ..start();
  }

  void _generar() {
    final dificultad = 1 + _t / _duracion * 1.6;
    final r = _rnd.nextDouble();
    final tipo = r < 0.28
        ? _TipoEnte.globuloRojo
        : (r < 0.64 ? _TipoEnte.bacteria : _TipoEnte.virus);
    final ang = _rnd.nextDouble() * 2 * math.pi;
    final inicio =
        const Offset(0.5, 0.5) + Offset(math.cos(ang), math.sin(ang)) * 0.75;
    final haciaCentro = (const Offset(0.5, 0.5) - inicio);
    final vel = tipo == _TipoEnte.globuloRojo
        ? Offset(math.cos(ang + 1.6), math.sin(ang + 1.6)) * 0.09
        : haciaCentro /
            haciaCentro.distance *
            (0.07 + 0.03 * _rnd.nextDouble()) *
            dificultad;
    final pos = tipo == _TipoEnte.globuloRojo
        ? Offset(0.15 + _rnd.nextDouble() * 0.7, 0.15 + _rnd.nextDouble() * 0.7)
        : inicio;
    _entes.add(_Ente(tipo, pos, vel));
    _proximo = _t +
        (1.1 - 0.5 * (dificultad - 1) / 1.6) * (0.6 + _rnd.nextDouble() * 0.6);
  }

  void _paso(Duration d) {
    final ahora = d.inMicroseconds / 1e6;
    final dt = (ahora - _ultimo).clamp(0.0, 0.05);
    _ultimo = ahora;
    if (!_jugando) return;
    _t += dt;
    if (_t >= _proximo) _generar();
    for (final e in _entes) {
      if (e.muerte > 0) {
        e.muerte += dt;
        continue;
      }
      e.pos += e.vel * dt;
      if (!e.malo) {
        if (e.pos.dx < 0.05 || e.pos.dx > 0.95) {
          e.vel = Offset(-e.vel.dx, e.vel.dy);
        }
        if (e.pos.dy < 0.05 || e.pos.dy > 0.95) {
          e.vel = Offset(e.vel.dx, -e.vel.dy);
        }
      } else if ((e.pos - const Offset(0.5, 0.5)).distance < 0.09) {
        e.muerte = 0.01;
        _vidas--;
        _destellos.add((e.pos, 0, false));
      }
    }
    _entes.removeWhere((e) => e.muerte > 0.4);
    for (var i = 0; i < _destellos.length; i++) {
      _destellos[i] = (
        _destellos[i].$1,
        _destellos[i].$2 + dt,
        _destellos[i].$3,
      );
    }
    _destellos.removeWhere((d) => d.$2 > 0.6);
    // Los glóbulos rojos se van después de un rato
    if (_entes.where((e) => !e.malo).length > 5) {
      _entes.firstWhere((e) => !e.malo).muerte = 0.01;
    }
    if (_vidas <= 0 || _t >= _duracion) _fin();
    setState(() {});
  }

  void _tocar(Offset rel) {
    if (!_jugando) return;
    _Ente? mejor;
    var dist = 0.09;
    for (final e in _entes) {
      if (e.muerte > 0) continue;
      final d = (e.pos - rel).distance;
      if (d < dist) {
        dist = d;
        mejor = e;
      }
    }
    if (mejor == null) return;
    mejor.muerte = 0.01;
    if (mejor.malo) {
      _eliminados++;
      _puntos += mejor.tipo == _TipoEnte.virus ? 15 : 10;
      _carga = math.min(1, _carga + 0.12);
      _destellos.add((mejor.pos, 0, true));
    } else {
      _errores++;
      _puntos = math.max(0, _puntos - 15);
      _destellos.add((mejor.pos, 0, false));
    }
  }

  void _lanzarAnticuerpos() {
    if (_carga < 1) return;
    _carga = 0;
    for (final e in _entes) {
      if (e.malo && e.muerte == 0) {
        e.muerte = 0.01;
        _eliminados++;
        _puntos += 10;
        _destellos.add((e.pos, 0, true));
      }
    }
  }

  Future<void> _fin() async {
    _jugando = false;
    _terminado = true;
    _ticker.stop();
    final gano = _vidas > 0;
    final estrellas = !gano
        ? (_eliminados >= 10 ? 1 : 0)
        : (_vidas >= 4 && _errores <= 1 ? 3 : (_vidas >= 2 ? 2 : 1));
    await otorgarEstrellas(
      context,
      actividad: Actividades.retoDefensa,
      estrellas: estrellas,
      titulo: gano
          ? '¡Defendiste el cuerpo!'
          : 'Los microbios llegaron a la célula',
      mensaje: 'Eliminaste $_eliminados microbios y obtuviste $_puntos puntos. '
          '${_errores > 0 ? 'Atacaste $_errores glóbulos rojos por error: ¡el sistema inmune debe distinguir lo propio de lo extraño!' : '¡No atacaste a ninguna célula propia!'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraJuego('Defensa inmune', ColoresJuego.inmune),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Row(
              children: [
                for (var v = 0; v < 5; v++)
                  Icon(
                    v < _vidas
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: ColoresJuego.circulatorio,
                    size: 22,
                  ),
                const Spacer(),
                Text(
                  '⏱ ${math.max(0, _duracion - _t).ceil()} s',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                Text(
                  '⭐ $_puntos',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: LayoutBuilder(
                  builder: (context, cons) {
                    return GestureDetector(
                      onTapDown: (d) => _tocar(
                        Offset(
                          d.localPosition.dx / cons.maxWidth,
                          d.localPosition.dy / cons.maxHeight,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _PintorDefensa(_t, _entes, _destellos),
                            ),
                          ),
                          if (!_jugando)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black45,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(12),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: SizedBox(
                                    width: 520,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CoraMascota(
                                          tam: 90,
                                          emocion: EmocionCora.sorprendida,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          _terminado
                                              ? '¿Otra ronda?'
                                              : '¡Eres un glóbulo blanco! Toca las bacterias y los virus antes de que lleguen a la célula del centro.\n'
                                                  'NO toques a los glóbulos rojos: son células de tu cuerpo.\n'
                                                  'Llena la barra para lanzar anticuerpos.',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        FilledButton.icon(
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                ColoresJuego.inmune,
                                          ),
                                          onPressed: _comenzar,
                                          icon: const Icon(
                                            Icons.play_arrow_rounded,
                                          ),
                                          label: Text(
                                            _terminado
                                                ? 'Jugar otra vez'
                                                : '¡A defender!',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _carga,
                        minHeight: 14,
                        color: const Color(0xFFFFC107),
                        backgroundColor: const Color(0x33FFC107),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA000),
                    ),
                    onPressed: _carga >= 1 && _jugando
                        ? () => setState(_lanzarAnticuerpos)
                        : null,
                    icon: const Text(
                      'Y',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18,
                      ),
                    ),
                    label: const Text('Anticuerpos'),
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

class _PintorDefensa extends CustomPainter {
  _PintorDefensa(this.t, this.entes, this.destellos);
  final double t;
  final List<_Ente> entes;
  final List<(Offset, double, bool)> destellos;

  @override
  void paint(Canvas c, Size s) {
    final rect = Offset.zero & s;
    c.drawRect(
      rect,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFFFFE5EC), Color(0xFFF8BBD0)],
        ).createShader(rect),
    );
    final rnd = math.Random(2);
    for (var i = 0; i < 10; i++) {
      c.drawCircle(
        Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height),
        s.shortestSide * (0.05 + rnd.nextDouble() * 0.06),
        relleno(const Color(0x22FFFFFF)),
      );
    }
    final m = s.shortestSide;
    final centro = rect.center;
    // Célula a proteger
    dibujarCelula(
      c,
      centro,
      m * 0.1,
      t,
      membrana: const Color(0xFFFFF59D),
      nucleo: const Color(0xFFFF8F00),
    );
    c.drawCircle(
      centro,
      m * 0.1 + 6 + math.sin(t * 4) * 2,
      linea(const Color(0x66FFB300), 3),
    );
    Offset pos(Offset rel) => Offset(rel.dx * s.width, rel.dy * s.height);
    for (final e in entes) {
      final p = pos(e.pos);
      final esc = e.muerte > 0 ? (1 - e.muerte / 0.4).clamp(0.0, 1.0) : 1.0;
      switch (e.tipo) {
        case _TipoEnte.bacteria:
          dibujarBacteria(
            c,
            p,
            m * 0.035 * esc,
            math.atan2(e.vel.dy, e.vel.dx),
            t,
          );
        case _TipoEnte.virus:
          dibujarVirus(c, p, m * 0.03 * esc, t);
        case _TipoEnte.globuloRojo:
          dibujarGloboRojo(c, p, m * 0.045 * esc);
      }
      if (e.muerte > 0 && e.malo) {
        dibujarGloboBlanco(c, p, m * 0.05 * (0.6 + e.muerte), t);
      }
    }
    for (final d in destellos) {
      final p = pos(d.$1);
      final a = (1 - d.$2 / 0.6).clamp(0.0, 1.0);
      textoEn(
        c,
        d.$3 ? '+10' : '¡Ay!',
        p - Offset(0, 30 * d.$2 + 20),
        tam: 16,
        color: (d.$3 ? ColoresJuego.correcto : ColoresJuego.incorrecto)
            .withValues(alpha: a),
      );
    }
  }

  @override
  bool shouldRepaint(_PintorDefensa old) => true;
}
