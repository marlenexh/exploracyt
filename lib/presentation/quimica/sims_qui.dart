import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';

/// Lista de objetivos con palomitas.
Widget objetivosPanel(List<String> metas, Set<int> hechas, Color color, {String titulo = 'Objetivos'}) => PanelEle(
      titulo: titulo,
      icono: Icons.flag_rounded,
      color: color,
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          for (var k = 0; k < metas.length; k++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(hechas.contains(k) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    size: 18, color: hechas.contains(k) ? ColoresJuego.correcto : Colors.black38),
                const SizedBox(width: 4),
                Expanded(child: Text(metas[k], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.15))),
              ]),
            ),
        ]),
      ),
    );

Widget deslizador(BuildContext context, String emoji, String texto, double v, ValueChanged<double> cambio, Color color, {double min = 0, double max = 1}) =>
    Row(children: [
      SizedBox(width: 30, child: Text(emoji, style: const TextStyle(fontSize: 20))),
      SizedBox(width: 96, child: Text(texto, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
      Expanded(
        child: Tooltip(
          message: texto,
          child: Slider(value: v, min: min, max: max, onChanged: cambio, activeColor: color),
        ),
      ),
    ]);

/// Base para simulaciones con objetivos: muestra Siguiente al lograrlos todos.
mixin ObjetivosSim<T extends StatefulWidget> on State<T> {
  final hechas = <int>{};
  void lograr(int k) {
    if (hechas.add(k)) HapticFeedback.mediumImpact();
  }
}

// ===========================================================================
// Gases: compresibilidad, expansión, fluidez y masa
// ===========================================================================

class SimGases extends StatefulWidget {
  const SimGases({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimGases> createState() => SimGasesState();
}

class SimGasesState extends State<SimGases> with ObjetivosSim {
  double volumen = 1, temperatura = 0.35;
  bool pesado = false;
  static const metas = [
    'Comprime el gas: empuja el émbolo hasta la mitad',
    'Calienta el gas',
    'Con el gas caliente, déjalo expandirse al máximo',
    'Pesa un globo inflado y uno desinflado',
  ];

  void cambiar({double? v, double? t}) => setState(() {
        volumen = v ?? volumen;
        temperatura = t ?? temperatura;
        if (volumen <= 0.5) lograr(0);
        if (temperatura >= 0.8) lograr(1);
        if (temperatura >= 0.8 && volumen >= 0.97 && hechas.contains(0)) lograr(2);
      });

  void pesar() => setState(() {
        pesado = true;
        lograr(3);
      });

  double get presion => (0.4 + temperatura) / volumen;

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Lo comprobaste! Los gases se pueden comprimir, se expanden al calentarse, fluyen y ocupan todo el espacio, ¡y tienen masa!'
        : pesado
            ? 'El globo inflado pesa más: ¡el aire tiene masa! Aunque no lo veamos, el aire está formado por partículas.'
            : 'El aire es una mezcla de gases. Sus partículas están muy separadas y se mueven sin parar. Usa los controles y observa qué les pasa.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'La jeringa de gas', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 242,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorGas(volumen, temperatura, t, pesado))),
          ),
        ),
        Positioned(
          left: 244,
          top: 306,
          width: 608,
          height: 110,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14), border: Border.all(color: widget.color, width: 2)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              deslizador(context, '💉', 'Émbolo', volumen, (v) => cambiar(v: v), widget.color, min: 0.3),
              deslizador(context, '🔥', 'Temperatura', temperatura, (t) => cambiar(t: t), const Color(0xFFE53935)),
            ]),
          ),
        ),
        Positioned(
          left: 470,
          top: 420,
          child: Tooltip(
              message: 'Pesar globos', child: BotonJuego(texto: 'Pesar globos', icono: Icons.balance_rounded, color: const Color(0xFF7E57C2), onTap: pesar)),
        ),
        if (listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
                onTap: () => terminarPaso(context,
                    actividad: widget.actividad, estrellas: 3, titulo: '¡La jeringa de gas!', mensaje: 'Comprobaste las propiedades de los gases.')),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorGas extends CustomPainter {
  _PintorGas(this.v, this.temp, this.t, this.pesado);
  final double v, temp, t;
  final bool pesado;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFFF1F8FE)));
    // Jeringa
    final barril = Rect.fromLTWH(30, 50, 380, 120);
    final xEmb = barril.left + 20 + v * (barril.width - 20);
    final gas = Rect.fromLTRB(barril.left + 6, barril.top + 6, xEmb, barril.bottom - 6);
    c.drawRRect(RRect.fromRectAndRadius(barril, const Radius.circular(10)), relleno(Colors.white));
    c.drawRect(gas, relleno(Color.lerp(const Color(0x2229B6F6), const Color(0x33FF7043), temp)!));
    // Partículas: rebotan dentro del gas; se mueven más rápido con calor
    final rnd = math.Random(3);
    final vel = 40 + temp * 260;
    for (var k = 0; k < 28; k++) {
      final ax = rnd.nextDouble() * 10, ay = rnd.nextDouble() * 10;
      final vx = (0.5 + rnd.nextDouble()) * vel, vy = (0.5 + rnd.nextDouble()) * vel;
      double rebote(double pos, double largo) {
        final m = pos % (2 * largo);
        return m < largo ? m : 2 * largo - m;
      }

      final x = gas.left + 6 + rebote(ax * 100 + t * vx, gas.width - 12);
      final y = gas.top + 6 + rebote(ay * 100 + t * vy, gas.height - 12);
      c.drawCircle(Offset(x, y), 5, relleno(Color.lerp(const Color(0xFF1E88E5), const Color(0xFFE53935), temp)!));
    }
    c.drawRRect(RRect.fromRectAndRadius(barril, const Radius.circular(10)), linea(const Color(0xFF78909C), 3));
    // Émbolo
    c.drawRect(Rect.fromLTWH(xEmb, barril.top + 4, 10, barril.height - 8), relleno(const Color(0xFF455A64)));
    c.drawRect(Rect.fromLTWH(xEmb + 10, barril.center.dy - 6, 150 - (xEmb - barril.left) * 0.1, 12), relleno(const Color(0xFF90A4AE)));
    c.drawLine(Offset(barril.left, barril.center.dy), Offset(barril.left - 22, barril.center.dy), linea(const Color(0xFF78909C), 6));
    // Medidor de presión
    final p = (0.4 + temp) / v;
    textoEn(c, 'Presión: ${(p * 10).toStringAsFixed(0)}', Offset(barril.center.dx, 28),
        tam: 15, color: Colors.white, fondo: p > 3 ? const Color(0xFFE53935) : const Color(0xFF1565C0));
    textoEn(c, 'Volumen del gas: ${(v * 100).round()} %', Offset(barril.center.dx, barril.bottom + 22), tam: 13, color: const Color(0xFF37474F));
    // Balanza con globos
    final b = Offset(510, 200);
    c.drawLine(b, b - const Offset(0, 90), linea(const Color(0xFF6D4C41), 5));
    final ang = pesado ? 0.18 : 0.0;
    final iz = b - const Offset(0, 90) + Offset(-60 * math.cos(ang), 60 * math.sin(ang));
    final de = b - const Offset(0, 90) + Offset(60 * math.cos(ang), -60 * math.sin(ang));
    c.drawLine(iz, de, linea(const Color(0xFF6D4C41), 4));
    dibujarEmoji(c, '🎈', iz + const Offset(0, 22), 38);
    textoEn(c, 'inflado', iz + const Offset(0, 50), tam: 11, color: const Color(0xFF37474F));
    c.save();
    c.translate(de.dx, de.dy + 26);
    c.scale(0.55, 0.45);
    dibujarEmoji(c, '🎈', Offset.zero, 38);
    c.restore();
    textoEn(c, 'desinflado', de + const Offset(0, 50), tam: 11, color: const Color(0xFF37474F));
    c.drawPath(
        Path()
          ..moveTo(b.dx - 24, b.dy)
          ..lineTo(b.dx + 24, b.dy)
          ..lineTo(b.dx, b.dy - 16)
          ..close(),
        relleno(const Color(0xFF8D6E63)));
  }

  @override
  bool shouldRepaint(_PintorGas old) => true;
}

// ===========================================================================
// Conservación y descomposición de alimentos
// ===========================================================================

const _alimentos = [('Pan', '🍞'), ('Leche', '🥛'), ('Manzana', '🍎'), ('Carne', '🥩')];
const _metodos = [('Al aire libre', '🌡️', 25), ('Refrigerador', '🧊', 4), ('Congelador', '❄️', -18), ('Deshidratar / salar', '🧂', 25)];

/// Días aproximados que dura cada alimento con cada método.
const vidaAlimento = [
  [4, 8, 90, 60],
  [1, 7, 90, 365],
  [7, 30, 180, 365],
  [1, 3, 180, 120],
];

class SimConservacion extends StatefulWidget {
  const SimConservacion({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimConservacion> createState() => SimConservacionState();
}

class SimConservacionState extends State<SimConservacion> with ObjetivosSim {
  int alimento = 0, metodo = 0;
  double dias = 0;
  final _probados = <int>{};
  static const metas = [
    'Deja el pan al aire libre más de 5 días',
    'Conserva la leche 7 días sin que se eche a perder',
    'Prueba los 4 métodos de conservación',
  ];

  double get deterioro => (dias / vidaAlimento[alimento][metodo]).clamp(0, 1.5).toDouble();

  void cambiar({int? a, int? m, double? d}) => setState(() {
        alimento = a ?? alimento;
        metodo = m ?? metodo;
        dias = d ?? dias;
        _probados.add(metodo);
        if (alimento == 0 && metodo == 0 && dias > 5) lograr(0);
        if (alimento == 1 && dias >= 7 && deterioro < 1) lograr(1);
        if (_probados.length == 4) lograr(2);
      });

  @override
  Widget build(BuildContext context) {
    final (nombre, _) = _alimentos[alimento];
    final (met, _, temp) = _metodos[metodo];
    final malo = deterioro >= 1;
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Muy bien! Los microorganismos (bacterias y hongos) descomponen los alimentos. Crecen rápido con calor y humedad; el frío los frena y sin agua casi no pueden vivir.'
        : malo
            ? '¡$nombre descompuesto! 🦠 Aparecieron moho, mal olor o cambios de color. No se debe comer.'
            : '$nombre · $met ($temp °C). Mueve los días y observa. ¿Qué método conserva mejor los alimentos?';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Laboratorio', 'Conserva los alimentos', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            for (var i = 0; i < _alimentos.length; i++)
              ChipEle(texto: '${_alimentos[i].$2} ${_alimentos[i].$1}', activo: alimento == i, color: widget.color, onTap: () => cambiar(a: i, d: 0)),
            const SizedBox(width: 12),
            for (var i = 0; i < _metodos.length; i++)
              ChipEle(texto: '${_metodos[i].$2} ${_metodos[i].$1}', activo: metodo == i, color: const Color(0xFF00897B), onTap: () => cambiar(m: i, d: 0)),
          ]),
        ),
        Positioned(
          left: 244,
          top: 128,
          width: 608,
          height: 210,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorComida(alimento, metodo, deterioro, dias, t)))),
        ),
        Positioned(
          left: 244,
          top: 344,
          width: 608,
          height: 66,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14), border: Border.all(color: widget.color, width: 2)),
            child: Row(children: [
              Expanded(child: deslizador(context, '📅', 'Días: ${dias.round()}', dias, (d) => cambiar(d: d), widget.color, max: 14)),
              Text(malo ? '❌ No se puede comer' : '✅ Se puede comer',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: malo ? ColoresJuego.incorrecto : ColoresJuego.correcto)),
            ]),
          ),
        ),
        if (listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
                onTap: () => terminarPaso(context,
                    actividad: widget.actividad,
                    estrellas: 3,
                    titulo: '¡Conserva los alimentos!',
                    mensaje: 'Comprobaste cómo la temperatura y el tiempo cambian los alimentos.')),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorComida extends CustomPainter {
  _PintorComida(this.a, this.m, this.det, this.dias, this.t);
  final int a, m;
  final double det, dias, t;
  @override
  void paint(Canvas c, Size s) {
    final frio = m == 1 || m == 2;
    c.drawRect(Offset.zero & s, relleno(frio ? const Color(0xFFE3F2FD) : (m == 3 ? const Color(0xFFFFF8E1) : const Color(0xFFFFF3E0))));
    if (frio) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(140, 14, 220, 182), const Radius.circular(14)), linea(const Color(0xFF90CAF9), 4));
      for (var k = 0; k < 6; k++) {
        dibujarEmoji(c, '❄️', Offset(160 + k * 36.0, 30 + math.sin(t + k) * 3), 14);
      }
    }
    final centro = const Offset(250, 110);
    final e = _alimentos[a].$2;
    // El alimento cambia de color con el deterioro
    c.saveLayer(
        null, Paint()..colorFilter = ColorFilter.mode(Color.lerp(const Color(0x00000000), const Color(0xAA6D4C41), det.clamp(0, 1))!, BlendMode.srcATop));
    dibujarEmoji(c, m == 3 && a == 2 ? '🍂' : e, centro, 96 * (m == 3 ? 0.85 : 1));
    c.restore();
    // Manchas de moho y bacterias
    if (det > 0.5) {
      final n = ((det - 0.5) * 20).round().clamp(0, 14);
      final rnd = math.Random(a * 10 + m);
      for (var k = 0; k < n; k++) {
        c.drawCircle(centro + Offset(rnd.nextDouble() * 70 - 35, rnd.nextDouble() * 60 - 30), 4 + rnd.nextDouble() * 6, relleno(const Color(0xAA7CB342)));
      }
    }
    if (det >= 1) {
      for (var k = 0; k < 3; k++) {
        dibujarEmoji(c, '🪰', centro + Offset(math.cos(t * 3 + k * 2) * 70, -50 + math.sin(t * 4 + k) * 20), 20);
      }
      dibujarEmoji(c, '🦠', centro + const Offset(60, 40), 26);
    }
    // Termómetro
    final temp = _metodos[m].$3;
    textoEn(c, '${_metodos[m].$2} $temp °C', const Offset(470, 40),
        tam: 18, color: Colors.white, fondo: temp < 10 ? const Color(0xFF1E88E5) : const Color(0xFFE65100));
    textoEn(c, 'Día ${dias.round()}', const Offset(470, 80), tam: 16, color: const Color(0xFF37474F));
    final vida = vidaAlimento[a][m];
    textoEn(c, 'Dura aprox. ${vida >= 60 ? '${(vida / 30).round()} meses' : '$vida días'}', const Offset(470, 120), tam: 13, color: const Color(0xFF455A64));
    // Barra de frescura
    final r = Rect.fromLTWH(390, 150, 160, 16);
    c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), relleno(const Color(0xFFE0E0E0)));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(r.left, r.top, r.width * (1 - det.clamp(0, 1)), r.height), const Radius.circular(8)),
        relleno(Color.lerp(const Color(0xFF43A047), const Color(0xFFE53935), det.clamp(0, 1))!));
    textoEn(c, 'Frescura', const Offset(470, 182), tam: 11, color: const Color(0xFF455A64));
  }

  @override
  bool shouldRepaint(_PintorComida old) => true;
}

// ===========================================================================
// Combustión: la vela en el frasco y el triángulo del fuego
// ===========================================================================

class SimCombustion extends StatefulWidget {
  const SimCombustion({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimCombustion> createState() => SimCombustionState();
}

class SimCombustionState extends State<SimCombustion> with ObjetivosSim {
  /// 0 sin frasco, 1 frasco chico, 2 frasco grande.
  int frasco = 0;
  bool tapada = false;
  double _oxigeno = 1;
  Timer? _timer;
  bool combustible = true, oxigeno = true, calor = true;
  final _apagadas = <int>{};
  static const metas = [
    'Tapa la vela con el frasco chico',
    'Tapa la vela con el frasco grande y compara',
    'Quita un lado del triángulo para apagar el fuego',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get hayFuego => combustible && oxigeno && calor;

  void tapar(int f) {
    _timer?.cancel();
    setState(() {
      frasco = f;
      tapada = f != 0;
      _oxigeno = 1;
    });
    if (f == 0) return;
    final dur = f == 1 ? 4.0 : 9.0;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        _oxigeno -= 0.1 / dur;
        if (_oxigeno <= 0) {
          _oxigeno = 0;
          tm.cancel();
          _apagadas.add(f);
          lograr(f - 1);
        }
      });
    });
  }

  void alternar(int lado) => setState(() {
        if (lado == 0) combustible = !combustible;
        if (lado == 1) oxigeno = !oxigeno;
        if (lado == 2) calor = !calor;
        if (!hayFuego) lograr(2);
      });

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Excelente! El fuego necesita tres cosas: combustible, oxígeno y calor. En el frasco grande hay más aire (oxígeno), por eso la vela dura más.'
        : tapada && _oxigeno <= 0
            ? 'La vela se apagó: ¡se acabó el oxígeno del frasco! ${_apagadas.length < 2 ? 'Ahora prueba el otro frasco.' : ''}'
            : 'La combustión es una reacción química: el material se quema con el oxígeno del aire y libera luz y calor. Experimenta con la vela y el triángulo del fuego.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Laboratorio', 'La vela y el triángulo del fuego', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 300,
          height: 300,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18), child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorVela(frasco, tapada ? _oxigeno : 1, t)))),
        ),
        Positioned(
          left: 244,
          top: 366,
          width: 300,
          child: Wrap(spacing: 4, runSpacing: 4, alignment: WrapAlignment.center, children: [
            Tooltip(message: 'Sin frasco', child: ChipEle(texto: '🕯️ Sin frasco', activo: frasco == 0, color: widget.color, onTap: () => tapar(0))),
            Tooltip(message: 'Frasco chico', child: ChipEle(texto: '🫙 Frasco chico', activo: frasco == 1, color: widget.color, onTap: () => tapar(1))),
            Tooltip(message: 'Frasco grande', child: ChipEle(texto: '🫙 Frasco grande', activo: frasco == 2, color: widget.color, onTap: () => tapar(2))),
          ]),
        ),
        Positioned(
          left: 552,
          top: 60,
          width: 300,
          height: 350,
          child: Container(
            decoration:
                BoxDecoration(color: const Color(0xFF263238), borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 2)),
            child: Stack(children: [
              Positioned.fill(child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorTriangulo(combustible, oxigeno, calor, t)))),
              const Positioned(
                  left: 0,
                  right: 0,
                  top: 8,
                  child: Text('Triángulo del fuego',
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
              Positioned(
                  left: 8,
                  bottom: 8,
                  child: Tooltip(
                      message: 'Combustible',
                      child: ChipEle(texto: '🪵 Combustible', activo: combustible, color: const Color(0xFF8D6E63), onTap: () => alternar(0)))),
              Positioned(
                  right: 8,
                  bottom: 8,
                  child: Tooltip(
                      message: 'Oxígeno', child: ChipEle(texto: '💨 Oxígeno', activo: oxigeno, color: const Color(0xFF29B6F6), onTap: () => alternar(1)))),
              Positioned(
                  left: 0,
                  right: 0,
                  top: 40,
                  child: Center(
                      child: Tooltip(
                          message: 'Calor', child: ChipEle(texto: '🌡️ Calor', activo: calor, color: const Color(0xFFE53935), onTap: () => alternar(2))))),
            ]),
          ),
        ),
        if (listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
                onTap: () => terminarPaso(context,
                    actividad: widget.actividad, estrellas: 3, titulo: '¡La vela y el fuego!', mensaje: 'Comprobaste qué necesita el fuego para existir.')),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorVela extends CustomPainter {
  _PintorVela(this.frasco, this.o2, this.t);
  final int frasco;
  final double o2, t;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFF1C1B2E)));
    c.drawRect(Rect.fromLTWH(0, s.height - 40, s.width, 40), relleno(const Color(0xFF5D4037)));
    final base = Offset(s.width / 2, s.height - 40);
    c.drawRect(Rect.fromCenter(center: base - const Offset(0, 40), width: 36, height: 80), relleno(const Color(0xFFFFF8E1)));
    c.drawLine(base - const Offset(0, 80), base - const Offset(0, 90), linea(const Color(0xFF212121), 2));
    final llama = o2.clamp(0.0, 1.0);
    if (llama > 0.02) {
      final f = base - Offset(0, 104 - (1 - llama) * 8);
      c.drawCircle(
          f,
          60 * llama,
          Paint()
            ..shader = RadialGradient(colors: [const Color(0x66FFB300), const Color(0x00FFB300)]).createShader(Rect.fromCircle(center: f, radius: 60 * llama)));
      c.save();
      c.translate(f.dx, f.dy);
      c.scale(llama * (1 + 0.05 * math.sin(t * 12)), llama);
      c.drawOval(const Rect.fromLTWH(-10, -26, 20, 40), relleno(const Color(0xFFFFA000)));
      c.drawOval(const Rect.fromLTWH(-5, -12, 10, 22), relleno(const Color(0xFFFFF59D)));
      c.restore();
    } else {
      for (var k = 0; k < 3; k++) {
        final fr = (t * 0.5 + k / 3) % 1;
        c.drawCircle(base - Offset(math.sin(t + k) * 6, 96 + fr * 60), 6 + fr * 8, relleno(Color.fromARGB((80 * (1 - fr)).round(), 200, 200, 200)));
      }
    }
    if (frasco > 0) {
      final h = frasco == 1 ? 150.0 : 220.0, w = frasco == 1 ? 110.0 : 170.0;
      final r = Rect.fromLTWH(base.dx - w / 2, base.dy - h, w, h);
      c.drawRRect(RRect.fromRectAndCorners(r, topLeft: const Radius.circular(20), topRight: const Radius.circular(20)), relleno(const Color(0x2290CAF9)));
      c.drawRRect(RRect.fromRectAndCorners(r, topLeft: const Radius.circular(20), topRight: const Radius.circular(20)), linea(const Color(0xAABBDEFB), 3));
      textoEn(c, 'Oxígeno: ${(o2 * 100).round()} %', Offset(s.width / 2, 22),
          tam: 14, color: Colors.white, fondo: o2 > 0.3 ? const Color(0xFF1E88E5) : const Color(0xFFE53935));
    }
  }

  @override
  bool shouldRepaint(_PintorVela old) => true;
}

class _PintorTriangulo extends CustomPainter {
  _PintorTriangulo(this.comb, this.oxi, this.cal, this.t);
  final bool comb, oxi, cal;
  final double t;
  @override
  void paint(Canvas c, Size s) {
    final a = Offset(s.width / 2, 90), b = Offset(40, s.height - 60), d = Offset(s.width - 40, s.height - 60);
    void lado(Offset p, Offset q, bool on, Color col) => c.drawLine(p, q, linea(on ? col : const Color(0x33FFFFFF), 10)..strokeCap = StrokeCap.round);
    lado(a, b, cal, const Color(0xFFE53935));
    lado(a, d, oxi, const Color(0xFF29B6F6));
    lado(b, d, comb, const Color(0xFF8D6E63));
    final cen = Offset(s.width / 2, s.height * 0.6);
    if (comb && oxi && cal) {
      dibujarEmoji(c, '🔥', cen, 70 * (1 + 0.05 * math.sin(t * 9)));
    } else {
      dibujarEmoji(c, '💨', cen, 50);
      textoEn(c, 'Sin fuego', cen + const Offset(0, 44), tam: 14, color: Colors.white);
    }
  }

  @override
  bool shouldRepaint(_PintorTriangulo old) => true;
}
