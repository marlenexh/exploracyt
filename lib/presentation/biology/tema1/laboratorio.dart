import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'animaciones_tour.dart';
import 'comunes.dart';
import 'progreso.dart';

/// Menú del laboratorio virtual.
class PantallaLaboratorio extends StatelessWidget {
  const PantallaLaboratorio({super.key});
  @override
  Widget build(BuildContext context) {
    final p = ProgresoScope.of(context);
    final items = [
      (
        'Laboratorio del pulso',
        '¿Cómo cambia tu corazón con el ejercicio?',
        Icons.monitor_heart_rounded,
        ColoresJuego.circulatorio,
        Actividades.labPulso,
        const LabPulso(),
      ),
      (
        'Modelo de pulmón',
        'Construye un pulmón con un frasco y globos.',
        Icons.air_rounded,
        ColoresJuego.respiratorio,
        Actividades.labPulmon,
        const LabPulmon(),
      ),
      (
        'Microscopio',
        'Observa una gota de sangre e identifica sus células.',
        Icons.biotech_rounded,
        ColoresJuego.laboratorio,
        Actividades.labMicroscopio,
        const LabMicroscopio(),
      ),
      (
        'Vacunas',
        'Compara una infección con y sin vacuna.',
        Icons.vaccines_rounded,
        ColoresJuego.inmune,
        Actividades.labVacunas,
        const LabVacunas(),
      ),
    ];
    return Scaffold(
      appBar: barraJuego('Laboratorio', ColoresJuego.laboratorio),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const BurbujaCora(
            texto:
                'Los científicos usan el método científico: hacen una pregunta, proponen una hipótesis, experimentan y sacan conclusiones. ¡Ponte la bata!',
            emocion: EmocionCora.pensando,
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

/// Tarjeta de una etapa del método científico.
class _Etapa extends StatelessWidget {
  const _Etapa({
    required this.numero,
    required this.titulo,
    required this.color,
    required this.child,
  });
  final int numero;
  final String titulo;
  final Color color;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color, width: 3),
          boxShadow: [
            BoxShadow(
                color: oscurecer(color, 0.25), offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color,
                  child: Text(
                    '$numero',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      );
}

Widget _opciones(
  List<String> ops,
  int? sel,
  Color color,
  ValueChanged<int> onSel,
) =>
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < ops.length; i++)
          ChoiceChip(
            label: Text(ops[i]),
            selected: sel == i,
            selectedColor: color.withValues(alpha: 0.25),
            onSelected: (_) => onSel(i),
          ),
      ],
    );

// ===========================================================================
// 1. Laboratorio del pulso
// ===========================================================================

class LabPulso extends StatefulWidget {
  const LabPulso({super.key});
  @override
  State<LabPulso> createState() => _LabPulsoState();
}

class _LabPulsoState extends State<LabPulso> {
  static const _acts = [
    ('Dormir', Icons.bedtime_rounded, 70, 16),
    ('Sentado', Icons.chair_rounded, 85, 20),
    ('Caminar', Icons.directions_walk_rounded, 105, 26),
    ('Correr', Icons.directions_run_rounded, 145, 38),
    ('Saltar la cuerda', Icons.fitness_center_rounded, 160, 45),
  ];
  static const _color = ColoresJuego.circulatorio;
  final _rnd = math.Random();
  int? _hipotesis;
  int _act = 1;
  final Map<int, int> _registros = {};
  double _medicion = 0; // 0–1
  Timer? _timer;
  // Pulso real
  int _toques = 0;
  int _restante = 0;
  int? _pulsoReal;
  Timer? _timerReal;

  @override
  void dispose() {
    _timer?.cancel();
    _timerReal?.cancel();
    super.dispose();
  }

  void _medir() {
    _timer?.cancel();
    setState(() => _medicion = 0.001);
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      setState(() => _medicion += 0.05 / 4);
      if (_medicion >= 1) {
        t.cancel();
        setState(() {
          _medicion = 0;
          _registros[_act] = _acts[_act].$3 + _rnd.nextInt(9) - 4;
        });
      }
    });
  }

  void _iniciarPulsoReal() {
    _timerReal?.cancel();
    setState(() {
      _toques = 0;
      _restante = 15;
      _pulsoReal = null;
    });
    _timerReal = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => _restante--);
      if (_restante <= 0) {
        t.cancel();
        setState(() => _pulsoReal = _toques * 4);
      }
    });
  }

  Future<void> _terminar() async {
    final estrellas =
        1 + (_registros.length >= 4 ? 1 : 0) + (_pulsoReal != null ? 1 : 0);
    await otorgarEstrellas(
      context,
      actividad: Actividades.labPulso,
      estrellas: estrellas,
      titulo: '¡Experimento completado!',
      mensaje: estrellas == 3
          ? 'Mediste muchas actividades y también tu propio pulso.'
          : 'Tip: mide al menos 4 actividades y tu pulso real para ganar 3 estrellas.',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final a = _acts[_act];
    final bpm = _registros[_act] ?? a.$3;
    return Scaffold(
      appBar: barraJuego('Laboratorio del pulso', _color),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Etapa(
            numero: 1,
            titulo: 'Pregunta e hipótesis',
            color: _color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '¿Qué crees que le pasa a tu corazón cuando corres?',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                _opciones(
                  ['Late más rápido', 'Late más lento', 'Late igual'],
                  _hipotesis,
                  _color,
                  (i) => setState(() => _hipotesis = i),
                ),
              ],
            ),
          ),
          if (_hipotesis != null)
            _Etapa(
              numero: 2,
              titulo: 'Experimento: elige una actividad y mide',
              color: _color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < _acts.length; i++)
                        ChoiceChip(
                          avatar: Icon(_acts[i].$2, size: 18),
                          label: Text(_acts[i].$1),
                          selected: i == _act,
                          onSelected: _medicion > 0
                              ? null
                              : (_) => setState(() => _act = i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      height: 170,
                      child: Animado(
                        (t) => CustomPaint(
                          painter: _PintorMonitor(
                            t,
                            a.$3.toDouble(),
                            a.$4.toDouble(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_medicion > 0) ...[
                    LinearProgressIndicator(
                      value: _medicion,
                      color: _color,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Midiendo… cuenta los latidos',
                      textAlign: TextAlign.center,
                    ),
                  ] else
                    FilledButton.icon(
                      style: FilledButton.styleFrom(backgroundColor: _color),
                      onPressed: _medir,
                      icon: const Icon(Icons.timer_rounded),
                      label: Text(
                        _registros.containsKey(_act)
                            ? 'Medir otra vez'
                            : 'Medir pulso: ${a.$1}',
                      ),
                    ),
                  if (_registros.containsKey(_act))
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Resultado: $bpm latidos por minuto',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          if (_registros.isNotEmpty)
            _Etapa(
              numero: 3,
              titulo: 'Resultados',
              color: _color,
              child: SizedBox(
                height: 190,
                child: CustomPaint(
                  painter: _PintorBarras(
                    [
                      for (var i = 0; i < _acts.length; i++)
                        if (_registros.containsKey(i))
                          (_acts[i].$1, _registros[i]!.toDouble()),
                    ],
                    _color,
                    180,
                  ),
                ),
              ),
            ),
          if (_registros.length >= 3)
            _Etapa(
              numero: 4,
              titulo: 'Conclusión',
              color: _color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BurbujaCora(
                    emocion: _hipotesis == 0
                        ? EmocionCora.feliz
                        : EmocionCora.pensando,
                    texto:
                        '${_hipotesis == 0 ? '¡Tu hipótesis era correcta! ' : 'Tu hipótesis no se cumplió, ¡y así también aprenden los científicos! '}'
                        'Mientras más se mueven tus músculos, más oxígeno necesitan. Por eso el corazón late más rápido y también respiras más veces por minuto.',
                  ),
                ],
              ),
            ),
          _Etapa(
            numero: 5,
            titulo: 'Reto extra: mide tu pulso real',
            color: _color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pon dos dedos (no el pulgar) en tu muñeca o en el cuello hasta sentir el latido. '
                  'Presiona “Comenzar” y toca el corazón cada vez que sientas un latido durante 15 segundos.',
                ),
                const SizedBox(height: 10),
                if (_restante > 0)
                  Column(
                    children: [
                      Text(
                        '$_restante s · $_toques latidos',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTapDown: (_) => setState(() => _toques++),
                        child: TweenAnimationBuilder<double>(
                          key: ValueKey(_toques),
                          tween: Tween(begin: 1.25, end: 1),
                          duration: const Duration(milliseconds: 250),
                          builder: (_, v, child) =>
                              Transform.scale(scale: v, child: child),
                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 110,
                            color: _color,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _color),
                    onPressed: _iniciarPulsoReal,
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      _pulsoReal == null ? 'Comenzar' : 'Medir de nuevo',
                    ),
                  ),
                if (_pulsoReal != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Tu pulso: $_toques × 4 = $_pulsoReal latidos por minuto.\n'
                      '${_pulsoReal! < 60 ? '¿Seguro que contaste todos? Inténtalo de nuevo.' : _pulsoReal! > 130 ? '¡Está muy rápido! ¿Acabas de moverte?' : 'Un pulso normal para un niño en reposo es de 70 a 110.'}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
          if (_registros.length >= 3)
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: ColoresJuego.correcto,
              ),
              onPressed: _terminar,
              icon: const Icon(Icons.check_rounded),
              label: const Text('Terminar experimento'),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

double _ecg(double fase) {
  double g(double c, double w, double a) =>
      a * math.exp(-math.pow((fase - c) / w, 2));
  return g(0.1, 0.03, 0.12) -
      g(0.19, 0.008, 0.15) +
      g(0.21, 0.012, 1.0) -
      g(0.235, 0.01, 0.25) +
      g(0.45, 0.05, 0.25);
}

class _PintorMonitor extends CustomPainter {
  _PintorMonitor(this.t, this.bpm, this.rpm);
  final double t, bpm, rpm;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFF0B1F1A)));
    final rejilla = linea(const Color(0xFF1C3D33), 1);
    for (var x = 0.0; x < s.width; x += 20) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), rejilla);
    }
    for (var y = 0.0; y < s.height; y += 20) {
      c.drawLine(Offset(0, y), Offset(s.width, y), rejilla);
    }
    final ancho = s.width * 0.68;
    const ventana = 3.0;
    final path = Path();
    for (var i = 0; i <= 200; i++) {
      final u = i / 200;
      final tiempo = t - ventana + u * ventana;
      final fase = (tiempo * bpm / 60) % 1.0;
      final y = s.height * 0.6 - _ecg(fase) * s.height * 0.42;
      final x = u * ancho;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    c.drawPath(path, linea(const Color(0xFF69F0AE), 2.5));
    final fase = (t * bpm / 60) % 1.0;
    final lat = math.exp(-math.pow((fase - 0.22) / 0.06, 2));
    final centro = Offset(s.width * 0.84, s.height * 0.32);
    final r = s.height * (0.16 + 0.04 * lat);
    DibujoOrganos.corazon(
      c,
      Rect.fromCenter(center: centro, width: r * 2, height: r * 2),
    );
    textoEn(
      c,
      '${bpm.round()} lpm',
      Offset(s.width * 0.84, s.height * 0.68),
      tam: 20,
      color: const Color(0xFF69F0AE),
    );
    final resp = (1 - math.cos(2 * math.pi * t * rpm / 60)) / 2;
    textoEn(
      c,
      '🌬️ ${rpm.round()} resp/min',
      Offset(s.width * 0.84, s.height * 0.86),
      tam: 12.5 + resp * 1.5,
      color: const Color(0xFF80D8FF),
    );
  }

  @override
  bool shouldRepaint(_PintorMonitor old) => true;
}

class _PintorBarras extends CustomPainter {
  _PintorBarras(this.datos, this.color, this.maximo);
  final List<(String, double)> datos;
  final Color color;
  final double maximo;
  @override
  void paint(Canvas c, Size s) {
    final base = s.height - 30;
    c.drawLine(
      Offset(0, base),
      Offset(s.width, base),
      linea(Colors.black26, 2),
    );
    final n = datos.length;
    if (n == 0) return;
    final ancho = s.width / n;
    for (var i = 0; i < n; i++) {
      final (nombre, v) = datos[i];
      final h = (v / maximo) * (base - 24);
      final r = RRect.fromRectAndCorners(
        Rect.fromLTWH(i * ancho + ancho * 0.2, base - h, ancho * 0.6, h),
        topLeft: const Radius.circular(10),
        topRight: const Radius.circular(10),
      );
      c.drawRRect(
        r,
        relleno(Color.lerp(color.withValues(alpha: 0.5), color, v / maximo)!),
      );
      textoEn(
        c,
        '${v.round()}',
        Offset(i * ancho + ancho / 2, base - h - 12),
        tam: 13,
      );
      textoEn(
        c,
        nombre,
        Offset(i * ancho + ancho / 2, base + 15),
        tam: 11,
        peso: FontWeight.w600,
      );
    }
  }

  @override
  bool shouldRepaint(_PintorBarras old) => true;
}

// ===========================================================================
// 2. Modelo de pulmón (frasco y globos)
// ===========================================================================

class LabPulmon extends StatefulWidget {
  const LabPulmon({super.key});
  @override
  State<LabPulmon> createState() => _LabPulmonState();
}

class _LabPulmonState extends State<LabPulmon> {
  static const _color = ColoresJuego.respiratorio;
  double _tiron = 0;
  bool _tiroCompleto = false;
  static const _partes = [
    'Globos',
    'Membrana de abajo',
    'Popote en Y',
    'Frasco',
  ];
  static const _organos = [
    'Pulmones',
    'Diafragma',
    'Tráquea y bronquios',
    'Caja torácica',
  ];
  final Map<int, int> _relacion = {};
  bool _revisado = false;

  int get _correctas => _relacion.entries.where((e) => e.key == e.value).length;

  Future<void> _terminar() async {
    final estrellas = math.max(
      1,
      (_tiroCompleto ? 1 : 0) +
          (_correctas == 4 ? 2 : (_correctas >= 2 ? 1 : 0)),
    );
    await otorgarEstrellas(
      context,
      actividad: Actividades.labPulmon,
      estrellas: estrellas,
      titulo: '¡Modelo construido!',
      mensaje:
          'Cuando el diafragma baja, aumenta el espacio en el pecho, baja la presión y el aire entra a los pulmones.',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: barraJuego('Modelo de pulmón', _color),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Etapa(
            numero: 1,
            titulo: 'Materiales',
            color: _color,
            child: const Text(
              'Un frasco de plástico sin fondo, un popote en forma de Y, dos globos pequeños y un globo grande cortado que cubre la parte de abajo. '
              '¡Puedes construirlo en casa con ayuda de un adulto!',
            ),
          ),
          _Etapa(
            numero: 2,
            titulo: 'Experimenta: jala la membrana hacia abajo',
            color: _color,
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (context, cons) {
                    final alto = math.min(340.0, cons.maxWidth * 1.0);
                    return GestureDetector(
                      onVerticalDragUpdate: (d) => setState(() {
                        _tiron = (_tiron + d.delta.dy / (alto * 0.22)).clamp(
                          0.0,
                          1.0,
                        );
                        if (_tiron > 0.95) _tiroCompleto = true;
                      }),
                      onVerticalDragEnd: (_) => setState(() => _tiron = 0),
                      child: SizedBox(
                        height: alto,
                        width: double.infinity,
                        child: Animado(
                          (t) => CustomPaint(painter: _PintorFrasco(t, _tiron)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  _tiron > 0.1
                      ? 'La membrana baja → hay más espacio dentro del frasco → la presión baja → el aire entra y los globos se inflan.'
                      : 'Arrastra hacia abajo la manija morada. Al soltarla, el aire sale.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          _Etapa(
            numero: 3,
            titulo: '¿Qué representa cada parte?',
            color: _color,
            child: Column(
              children: [
                for (var i = 0; i < _partes.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _partes[i],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: !_revisado
                                    ? Colors.black26
                                    : (_relacion[i] == i
                                        ? ColoresJuego.correcto
                                        : ColoresJuego.incorrecto),
                                width: _revisado ? 2 : 1,
                              ),
                            ),
                            child: DropdownButton<int>(
                              value: _relacion[i],
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              hint: const Text('Elige…'),
                              items: [
                                for (var j = 0; j < _organos.length; j++)
                                  DropdownMenuItem(
                                    value: j,
                                    child: Text(_organos[j]),
                                  ),
                              ],
                              onChanged: (v) => setState(() {
                                _relacion[i] = v!;
                                _revisado = false;
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _relacion.length < 4
                            ? null
                            : () => setState(() => _revisado = true),
                        child: const Text('Revisar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: ColoresJuego.correcto,
                        ),
                        onPressed: _revisado ? _terminar : null,
                        child: const Text('Terminar'),
                      ),
                    ),
                  ],
                ),
                if (_revisado)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Correctas: $_correctas de 4',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PintorFrasco extends CustomPainter {
  _PintorFrasco(this.t, this.tiron);
  final double t, tiron;
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final cx = w / 2;
    final ancho = math.min(w * 0.7, h * 0.75);
    final top = h * 0.12, bottom = h * 0.78;
    // Frasco
    final frasco = Path()
      ..moveTo(cx - ancho * 0.18, top)
      ..lineTo(cx + ancho * 0.18, top)
      ..quadraticBezierTo(
        cx + ancho * 0.5,
        top + h * 0.05,
        cx + ancho * 0.5,
        top + h * 0.22,
      )
      ..lineTo(cx + ancho * 0.5, bottom)
      ..lineTo(cx - ancho * 0.5, bottom)
      ..lineTo(cx - ancho * 0.5, top + h * 0.22)
      ..quadraticBezierTo(
        cx - ancho * 0.5,
        top + h * 0.05,
        cx - ancho * 0.18,
        top,
      )
      ..close();
    c.drawPath(frasco, relleno(const Color(0x22B3E5FC)));
    c.drawPath(frasco, linea(const Color(0xFF81D4FA), 4));
    // Popote en Y
    final union = Offset(cx, top + h * 0.2);
    final izq = Offset(cx - ancho * 0.18, top + h * 0.34);
    final der = Offset(cx + ancho * 0.18, top + h * 0.34);
    final popote = linea(const Color(0xFFE0E0E0), ancho * 0.05);
    c.drawLine(Offset(cx, 0), union, popote);
    c.drawLine(union, izq, popote);
    c.drawLine(union, der, popote);
    // Globos
    final r = ancho * (0.08 + 0.12 * tiron);
    for (final p in [izq, der]) {
      final centro = p + Offset(0, r * 0.9);
      c.drawOval(
        Rect.fromCenter(center: centro, width: r * 1.8, height: r * 2.1),
        relleno(const Color(0xFFF48FB1)),
      );
      c.drawOval(
        Rect.fromCenter(center: centro, width: r * 1.8, height: r * 2.1),
        linea(const Color(0xFFC2185B), 2),
      );
    }
    // Membrana (diafragma)
    final baja = h * 0.14 * tiron;
    final mem = Path()
      ..moveTo(cx - ancho * 0.5, bottom)
      ..quadraticBezierTo(
        cx,
        bottom + baja * 2 - h * 0.03 * (1 - tiron),
        cx + ancho * 0.5,
        bottom,
      );
    c.drawPath(mem, linea(const Color(0xFF7E57C2), 7));
    final manija = Offset(
      cx,
      bottom + baja - h * 0.015 * (1 - tiron) + h * 0.06,
    );
    c.drawLine(
      Offset(cx, bottom + baja - h * 0.015 * (1 - tiron)),
      manija,
      linea(const Color(0xFF7E57C2), 4),
    );
    c.drawCircle(manija, h * 0.035, relleno(const Color(0xFF7E57C2)));
    c.drawCircle(manija, h * 0.015, relleno(Colors.white));
    // Flechas de aire
    if (tiron > 0.05) {
      for (var i = 0; i < 4; i++) {
        final u = (t * 1.5 + i / 4) % 1.0;
        c.drawCircle(
          Offset(cx, u * union.dy),
          4,
          relleno(const Color(0xFF4FC3F7)),
        );
      }
    }
    textoEn(
      c,
      'Presión interna: ${tiron > 0.1 ? 'baja ↓' : 'normal'}',
      Offset(cx, h * 0.04),
      tam: 13,
      color: Colors.white,
      fondo: tiron > 0.1 ? ColoresJuego.respiratorio : Colors.grey,
    );
  }

  @override
  bool shouldRepaint(_PintorFrasco old) => true;
}

// ===========================================================================
// 3. Microscopio
// ===========================================================================

enum _TipoCelula { rojo, blanco, plaqueta, bacteria }

class _CelulaMicro {
  _CelulaMicro(this.tipo, this.pos, this.r, this.ang);
  final _TipoCelula tipo;
  final Offset pos; // -1..1
  final double r;
  final double ang;
  bool encontrada = false;
}

class LabMicroscopio extends StatefulWidget {
  const LabMicroscopio({super.key});
  @override
  State<LabMicroscopio> createState() => _LabMicroscopioState();
}

class _LabMicroscopioState extends State<LabMicroscopio> {
  static const _color = ColoresJuego.laboratorio;
  static const _enfoqueIdeal = 0.62;
  int _muestra = 0;
  double _enfoque = 0.15;
  int _aumento = 0;
  late final List<List<_CelulaMicro>> _muestras = [_generar(0), _generar(1)];
  String? _mensaje;

  static const _nombres = {
    _TipoCelula.rojo: 'Glóbulo rojo',
    _TipoCelula.blanco: 'Glóbulo blanco',
    _TipoCelula.plaqueta: 'Plaqueta',
    _TipoCelula.bacteria: 'Bacteria',
  };

  Map<_TipoCelula, int> _metas(int m) => m == 0
      ? {_TipoCelula.blanco: 2, _TipoCelula.plaqueta: 3}
      : {_TipoCelula.blanco: 2, _TipoCelula.bacteria: 3};

  List<_CelulaMicro> _generar(int m) {
    final rnd = math.Random(10 + m);
    final lista = <_CelulaMicro>[];
    bool libre(Offset p, double r) =>
        p.distance + r < 0.95 &&
        lista.every((c) => (c.pos - p).distance > c.r + r + 0.01);
    void agregar(_TipoCelula t, int n, double r) {
      var intentos = 0;
      while (n > 0 && intentos < 2000) {
        intentos++;
        final p = Offset(rnd.nextDouble() * 2 - 1, rnd.nextDouble() * 2 - 1);
        if (libre(p, r)) {
          lista.add(_CelulaMicro(t, p, r, rnd.nextDouble() * math.pi));
          n--;
        }
      }
    }

    agregar(_TipoCelula.blanco, 2, 0.13);
    if (m == 1) agregar(_TipoCelula.bacteria, 4, 0.06);
    agregar(_TipoCelula.plaqueta, 5, 0.035);
    agregar(_TipoCelula.rojo, 40, 0.085);
    return lista;
  }

  bool _completa(int m) => _metas(m).entries.every(
        (e) =>
            _muestras[m].where((c) => c.tipo == e.key && c.encontrada).length >=
            e.value,
      );

  void _tocar(Offset local, double diametro) {
    final nitidez = (_enfoque - _enfoqueIdeal).abs();
    if (nitidez > 0.08) {
      setState(
        () => _mensaje =
            '¡Está borroso! Mueve el enfoque hasta que se vea nítido.',
      );
      return;
    }
    final zoom = [1.0, 1.6, 2.4][_aumento];
    final centro = Offset(diametro / 2, diametro / 2);
    final p = (local - centro) / (diametro / 2 * zoom);
    for (final c in _muestras[_muestra]) {
      if ((c.pos - p).distance < c.r * 1.2) {
        setState(() {
          c.encontrada = true;
          _mensaje = '¡Encontraste: ${_nombres[c.tipo]}!';
        });
        return;
      }
    }
    setState(() => _mensaje = 'Ahí solo hay plasma. ¡Sigue buscando!');
  }

  Future<void> _terminar() async {
    final estrellas = 1 + (_completa(0) ? 1 : 0) + (_completa(1) ? 1 : 0);
    await otorgarEstrellas(
      context,
      actividad: Actividades.labMicroscopio,
      estrellas: estrellas,
      titulo: '¡Gran observación!',
      mensaje:
          'En la sangre infectada hay más glóbulos blancos trabajando y aparecen bacterias. '
          '¡Por eso los médicos analizan la sangre para saber si hay una infección!',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final metas = _metas(_muestra);
    final borroso = (_enfoque - _enfoqueIdeal).abs() * 14;
    return Scaffold(
      appBar: barraJuego('Microscopio', _color),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text('Sangre sana'),
                icon: Icon(Icons.water_drop),
              ),
              ButtonSegment(
                value: 1,
                label: Text('Sangre con infección'),
                icon: Icon(Icons.coronavirus),
              ),
            ],
            selected: {_muestra},
            onSelectionChanged: (s) => setState(() {
              _muestra = s.first;
              _mensaje = null;
            }),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, cons) {
              final d = math.min(cons.maxWidth, 380.0);
              return Center(
                child: GestureDetector(
                  onTapUp: (det) => _tocar(det.localPosition, d),
                  child: Container(
                    width: d,
                    height: d,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF37474F),
                        width: 10,
                      ),
                      boxShadow: const [
                        BoxShadow(color: Colors.black38, blurRadius: 16),
                      ],
                    ),
                    child: ClipOval(
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(
                          sigmaX: borroso,
                          sigmaY: borroso,
                        ),
                        child: Animado(
                          (t) => CustomPaint(
                            painter: _PintorMicroscopio(
                              t,
                              _muestras[_muestra],
                              [1.0, 1.6, 2.4][_aumento],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(
                width: 90,
                child: Text(
                  '🔍 Enfoque',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Slider(
                  value: _enfoque,
                  activeColor: _color,
                  onChanged: (v) => setState(() => _enfoque = v),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 90,
                child: Text(
                  'Aumento',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: _opciones(
                  ['100×', '400×', '1000×'],
                  _aumento,
                  _color,
                  (i) => setState(() => _aumento = i),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_mensaje != null) BurbujaCora(texto: _mensaje!, tamCora: 48),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Misión: encuentra y toca',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                for (final e in metas.entries)
                  Row(
                    children: [
                      Icon(
                        _muestras[_muestra]
                                    .where(
                                      (c) => c.tipo == e.key && c.encontrada,
                                    )
                                    .length >=
                                e.value
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: ColoresJuego.correcto,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_nombres[e.key]}: '
                        '${math.min(e.value, _muestras[_muestra].where((c) => c.tipo == e.key && c.encontrada).length)}/${e.value}',
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: ColoresJuego.correcto,
            ),
            onPressed: _completa(0) || _completa(1) ? _terminar : null,
            icon: const Icon(Icons.check),
            label: Text(
              _completa(0) && _completa(1)
                  ? 'Terminar'
                  : 'Terminar (completa al menos una muestra)',
            ),
          ),
        ],
      ),
    );
  }
}

class _PintorMicroscopio extends CustomPainter {
  _PintorMicroscopio(this.t, this.celulas, this.zoom);
  final double t;
  final List<_CelulaMicro> celulas;
  final double zoom;
  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset.zero);
    final k = s.width / 2 * zoom;
    c.drawRect(Offset.zero & s, relleno(const Color(0xFFFFF3E0)));
    for (final cel in celulas) {
      final p =
          centro + cel.pos * k + Offset(math.sin(t * 0.5 + cel.ang) * 1.5, 0);
      final r = cel.r * k;
      switch (cel.tipo) {
        case _TipoCelula.rojo:
          dibujarGloboRojo(c, p, r, oxigeno: 0.9);
        case _TipoCelula.blanco:
          dibujarGloboBlanco(c, p, r, t);
        case _TipoCelula.plaqueta:
          c.drawOval(
            Rect.fromCenter(center: p, width: r * 2, height: r * 1.3),
            relleno(const Color(0xFFAB47BC)),
          );
        case _TipoCelula.bacteria:
          dibujarBacteria(c, p, r, cel.ang + t * 0.2, t);
      }
      if (cel.encontrada) {
        c.drawCircle(p, r * 1.25, linea(ColoresJuego.correcto, 3));
      }
    }
  }

  @override
  bool shouldRepaint(_PintorMicroscopio old) => true;
}

// ===========================================================================
// 4. Vacunas
// ===========================================================================

class LabVacunas extends StatefulWidget {
  const LabVacunas({super.key});
  @override
  State<LabVacunas> createState() => _LabVacunasState();
}

class _LabVacunasState extends State<LabVacunas>
    with SingleTickerProviderStateMixin {
  static const _color = ColoresJuego.inmune;
  int? _prediccion;
  bool _conVacuna = false;
  final Set<bool> _corridas = {};
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(seconds: 7))
        ..addListener(() => setState(() {}))
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed)
            setState(() => _corridas.add(_conVacuna));
        });

  static double germenes(bool vac, double d) => vac
      ? 22 * math.exp(-math.pow((d - 2.5) / 1.3, 2))
      : 95 * math.exp(-math.pow((d - 6) / 2.3, 2));
  static double anticuerpos(bool vac, double d) => vac
      ? 30 + 70 / (1 + math.exp(-(d - 1.8) * 2.2))
      : 90 / (1 + math.exp(-(d - 7.5) * 1.2));

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  Future<void> _terminar() async {
    final estrellas = 2 + (_prediccion == 1 ? 1 : 0);
    await otorgarEstrellas(
      context,
      actividad: Actividades.labVacunas,
      estrellas: estrellas,
      titulo: '¡Experimento completado!',
      mensaje:
          'Con la vacuna, el cuerpo ya tenía “memoria”: produjo anticuerpos rápido y los microbios nunca llegaron a enfermarlo.',
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dia = _anim.value * 14;
    final g = germenes(_conVacuna, dia);
    final enfermo = g > 50;
    return Scaffold(
      appBar: barraJuego('Laboratorio de vacunas', _color),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Etapa(
            numero: 1,
            titulo: 'Hipótesis',
            color: _color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Dos personas se encuentran con el mismo virus. Una está vacunada y la otra no. ¿Quién crees que se enfermará menos?',
                ),
                const SizedBox(height: 8),
                _opciones(
                  [
                    'La persona sin vacuna',
                    'La persona vacunada',
                    'Las dos igual',
                  ],
                  _prediccion,
                  _color,
                  (i) => setState(() => _prediccion = i),
                ),
              ],
            ),
          ),
          if (_prediccion != null)
            _Etapa(
              numero: 2,
              titulo: 'Simulación de 14 días',
              color: _color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text('Sin vacuna')),
                      ButtonSegment(
                        value: true,
                        label: Text('Con vacuna'),
                        icon: Icon(Icons.vaccines),
                      ),
                    ],
                    selected: {_conVacuna},
                    onSelectionChanged: _anim.isAnimating
                        ? null
                        : (s) => setState(() {
                              _conVacuna = s.first;
                              _anim.value = 0;
                            }),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CoraMascota(
                        tam: 64,
                        emocion:
                            enfermo ? EmocionCora.triste : EmocionCora.feliz,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Día ${dia.floor()}: ${enfermo ? '🤒 Tiene síntomas: fiebre y cansancio.' : g > 15 ? '😐 Su cuerpo está luchando.' : '😀 Se siente bien.'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 220,
                    child: CustomPaint(
                      painter: _PintorGrafica(_conVacuna, _anim.value),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Wrap(
                    spacing: 14,
                    children: [
                      _Leyenda(Color(0xFF43A047), 'Virus'),
                      _Leyenda(Color(0xFF7E57C2), 'Anticuerpos'),
                      _Leyenda(Color(0xFFE53935), 'Nivel de síntomas'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: _color),
                    onPressed:
                        _anim.isAnimating ? null : () => _anim.forward(from: 0),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text('Simular ${_conVacuna ? 'CON' : 'SIN'} vacuna'),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Simulaciones hechas: ${_corridas.length}/2',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (_corridas.length == 2)
            _Etapa(
              numero: 3,
              titulo: 'Conclusión',
              color: _color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BurbujaCora(
                    texto:
                        '${_prediccion == 1 ? '¡Acertaste! ' : 'Tu predicción fue diferente, ¡pero ahora ya sabes la respuesta! '}'
                        'Sin vacuna, el cuerpo tarda casi una semana en fabricar anticuerpos y el virus se multiplica mucho. '
                        'Con vacuna, los anticuerpos aparecen en uno o dos días.',
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: ColoresJuego.correcto,
                    ),
                    onPressed: _terminar,
                    child: const Text('Terminar experimento'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Leyenda extends StatelessWidget {
  const _Leyenda(this.color, this.texto);
  final Color color;
  final String texto;
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 14, height: 4, color: color),
          const SizedBox(width: 4),
          Text(texto, style: const TextStyle(fontSize: 12.5)),
        ],
      );
}

class _PintorGrafica extends CustomPainter {
  _PintorGrafica(this.vacuna, this.progreso);
  final bool vacuna;
  final double progreso;
  @override
  void paint(Canvas c, Size s) {
    const izq = 30.0, abajo = 22.0;
    final area = Rect.fromLTRB(izq, 8, s.width - 8, s.height - abajo);
    c.drawRRect(
      RRect.fromRectAndRadius(area, const Radius.circular(8)),
      relleno(Colors.white),
    );
    Offset p(double d, double v) => Offset(
          area.left + d / 14 * area.width,
          area.bottom - v / 100 * area.height,
        );
    // Umbral de síntomas
    final yU = p(0, 50).dy;
    c.drawRect(
      Rect.fromLTRB(area.left, area.top, area.right, yU),
      relleno(const Color(0x14E53935)),
    );
    c.drawLine(
      Offset(area.left, yU),
      Offset(area.right, yU),
      linea(const Color(0xFFE53935), 1.5),
    );
    textoEn(
      c,
      'Te sientes enfermo',
      Offset(area.right - 60, yU - 10),
      tam: 11,
      color: const Color(0xFFE53935),
    );
    for (var d = 0; d <= 14; d += 2) {
      textoEn(
        c,
        '$d',
        Offset(p(d.toDouble(), 0).dx, s.height - 10),
        tam: 10,
        peso: FontWeight.normal,
      );
    }
    textoEn(
      c,
      'días',
      Offset(izq / 2, s.height - 10),
      tam: 10,
      peso: FontWeight.normal,
    );
    void curva(double Function(bool, double) f, Color col) {
      final path = Path();
      final n = (progreso * 140).round();
      for (var i = 0; i <= n; i++) {
        final d = i / 10;
        final q = p(d, f(vacuna, d));
        i == 0 ? path.moveTo(q.dx, q.dy) : path.lineTo(q.dx, q.dy);
      }
      c.drawPath(path, linea(col, 3.5));
      if (n > 0) c.drawCircle(p(n / 10, f(vacuna, n / 10)), 5, relleno(col));
    }

    curva(_LabVacunasState.germenes, const Color(0xFF43A047));
    curva(_LabVacunasState.anticuerpos, const Color(0xFF7E57C2));
  }

  @override
  bool shouldRepaint(_PintorGrafica old) => true;
}
