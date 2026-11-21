import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../biology/temas/pasos.dart' show estrellasPorErrores;
import 'circuito.dart';
import 'comun.dart';
import 'dibujos.dart';
import 'ilustraciones_ele.dart';

// ===========================================================================
// Código de colores de las resistencias
// ===========================================================================

class SimBandasResistencia extends StatefulWidget {
  const SimBandasResistencia({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimBandasResistencia> createState() => _SimBandasState();
}

const _objetivosResistencia = [
  (220.0, 'Para proteger un LED con la pila de 9 V se usa una de 220 Ω.'),
  (1000.0, 'Una de 1 kΩ (1 000 Ω) deja pasar menos corriente: el LED brilla menos.'),
  (10000.0, 'Una de 10 kΩ se usa mucho con sensores y botones.'),
];

class _SimBandasState extends State<SimBandasResistencia> {
  final _bandas = [1, 0, 0];
  int _obj = 0;
  int _errores = 0;
  bool _listo = false;
  String _mensaje = 'Las resistencias traen franjas de colores que dicen su valor. Toca cada franja para cambiar su color y arma la resistencia que se pide.';

  double get _valor => ohmsDeBandas(_bandas);

  void _comprobar() {
    final (meta, dato) = _objetivosResistencia[_obj];
    if (_valor == meta) {
      HapticFeedback.mediumImpact();
      setState(() {
        if (_obj == _objetivosResistencia.length - 1) {
          _listo = true;
          _mensaje = '¡Excelente! Ya sabes leer el código de colores. $dato';
        } else {
          _mensaje = '¡Correcto! ✅ $dato Ahora arma la siguiente.';
          _obj++;
        }
      });
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _errores++;
        _mensaje = 'Tu resistencia mide ${textoOhms(_valor)} y se pide ${textoOhms(meta)}. Recuerda: 1ª y 2ª franja son números y la 3ª dice cuántos ceros van.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meta = _objetivosResistencia[_obj].$1;
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Laboratorio', 'Código de colores', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(_mensaje)),
        Positioned(
          left: 8,
          top: 258,
          width: 230,
          height: 214,
          child: PanelEle(
            titulo: 'Tabla de colores',
            icono: Icons.palette_rounded,
            color: widget.color,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(spacing: 3, runSpacing: 3, children: [
                  for (var i = 0; i < 10; i++)
                    Container(
                      width: 38,
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(color: colorBanda(i), borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.black26)),
                      child: Text('$i', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w700, color: i == 0 || i == 1 || i == 7 || i == 2 || i == 6 || i == 5 ? Colors.white : Colors.black)),
                    ),
                ]),
                const SizedBox(height: 6),
                const Text('Ejemplo: rojo-rojo-marrón = 2, 2 y 1 cero = 220 Ω', style: TextStyle(fontSize: 12, height: 1.15)),
                const Text('La franja dorada indica la precisión.', style: TextStyle(fontSize: 11.5, color: Colors.black54)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 350,
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(18), border: Border.all(color: widget.color, width: 3)),
            child: Stack(children: [
              Positioned(
                left: 0,
                right: 0,
                top: 12,
                child: Text('Arma una resistencia de ${textoOhms(meta)}  (${_obj + 1} de ${_objetivosResistencia.length})',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: oscurecer(widget.color, 0.2))),
              ),
              Positioned.fill(top: 40, child: CustomPaint(painter: _PintorResistenciaGrande(_bandas))),
              for (var i = 0; i < 3; i++)
                Positioned(
                  left: 196 + i * 56.0,
                  top: 120,
                  width: 44,
                  height: 110,
                  child: Tooltip(
                    message: 'Franja ${i + 1}',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _listo
                          ? null
                          : () => setState(() {
                                HapticFeedback.selectionClick();
                                _bandas[i] = (_bandas[i] + 1) % (i == 2 ? 7 : 10);
                                if (i == 0 && _bandas[0] == 0) _bandas[0] = 1;
                              }),
                    ),
                  ),
                ),
              for (var i = 0; i < 3; i++)
                Positioned(
                  left: 176 + i * 56.0,
                  top: 244,
                  width: 84,
                  child: Text('${i == 2 ? 'ceros' : 'número'}\n${nombresColorBanda[_bandas[i]]}',
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, height: 1.1)),
                ),
              Positioned(
                left: 0,
                right: 0,
                top: 292,
                child: Text('Tu resistencia: ${textoOhms(_valor)}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ),
        if (!_listo)
          Positioned(
            left: 470,
            top: 418,
            child: Tooltip(
              message: 'Comprobar resistencia',
              child: BotonJuego(texto: 'Comprobar', icono: Icons.check_circle_rounded, color: const Color(0xFFF5B400), onTap: _comprobar),
            ),
          ),
        if (_listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
              onTap: () => terminarPaso(context,
                  actividad: widget.actividad,
                  estrellas: estrellasPorErrores(_errores),
                  titulo: '¡Código de colores!',
                  mensaje: 'Ya sabes leer y armar el valor de una resistencia, como en Tinkercad.'),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  // Para pruebas.
  int get objetivo => _obj;
}

class _PintorResistenciaGrande extends CustomPainter {
  _PintorResistenciaGrande(this.bandas);
  final List<int> bandas;
  @override
  void paint(Canvas c, Size s) {
    final y = 135.0;
    c.drawLine(Offset(60, y), Offset(s.width - 60, y), linea(colorPata, 10)..strokeCap = StrokeCap.round);
    final r = Rect.fromCenter(center: Offset(s.width / 2, y), width: 300, height: 100);
    c.drawRRect(RRect.fromRectAndRadius(r.shift(const Offset(0, 5)), const Radius.circular(50)), relleno(const Color(0x33000000)));
    c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(50)), relleno(const Color(0xFFE6C9A0)));
    for (var i = 0; i < 3; i++) {
      final br = Rect.fromLTWH(196 + i * 56.0, r.top, 32, r.height);
      c.drawRect(br, relleno(colorBanda(bandas[i])));
      c.drawRect(br, linea(Colors.black26, 1));
    }
    c.drawRect(Rect.fromLTWH(390, r.top, 26, r.height), relleno(colorOro));
    c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(50)), linea(const Color(0xFFA1887F), 3));
    c.drawOval(Rect.fromLTWH(r.left + 40, r.top + 12, 200, 18), relleno(Colors.white.withValues(alpha: 0.35)));
  }

  @override
  bool shouldRepaint(_PintorResistenciaGrande old) => true;
}

// ===========================================================================
// Laboratorio de sensores
// ===========================================================================

class LabSensores extends StatefulWidget {
  const LabSensores({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<LabSensores> createState() => LabSensoresState();
}

class _SensorLab {
  const _SensorLab(this.id, this.nombre, this.emoji, this.metas, this.explicacion);
  final String id, nombre, emoji, explicacion;
  final List<String> metas;
}

const _sensoresLab = [
  _SensorLab('luz', 'Luz', '☀️', ['Con mucha luz: menos de 1 kΩ', 'A oscuras: más de 50 kΩ'],
      'La fotorresistencia cambia su resistencia con la luz. Así las lámparas del alumbrado público saben cuándo encender.'),
  _SensorLab('temperatura', 'Temperatura', '🌡️', ['Calor: más de 35 °C', 'Frío: menos de 5 °C'],
      'El sensor de temperatura da más voltaje cuando hace más calor (10 milivoltios por cada grado).'),
  _SensorLab('movimiento', 'Movimiento', '🐈', ['El sensor detecta al gato', 'El gato fuera del alcance: sin detección'],
      'El sensor PIR detecta el calor que se mueve frente a él, como una persona o un animal. Lo usan las alarmas y algunas luces.'),
  _SensorLab('distancia', 'Distancia', '📦', ['Objeto a menos de 20 cm', 'Objeto a más de 150 cm'],
      'El sensor ultrasónico lanza un sonido que no oímos y mide cuánto tarda en regresar el eco. Así funcionan los sensores para estacionarse.'),
];

class LabSensoresState extends State<LabSensores> {
  int _tab = 0;
  final _valores = <String, double>{'luz': 0.6, 'temperatura': 22, 'movimiento': 0.1, 'distancia': 80};
  final _logradas = <String>{};
  bool get _listo => _logradas.length == 8;

  bool _cumple(String id, int k) {
    final v = _valores[id]!;
    return switch ((id, k)) {
      ('luz', 0) => Pieza.ohmsLdr(v) < 1000,
      ('luz', 1) => Pieza.ohmsLdr(v) > 50000,
      ('temperatura', 0) => v > 35,
      ('temperatura', 1) => v < 5,
      ('movimiento', 0) => _detecta(v),
      ('movimiento', 1) => !_detecta(v),
      ('distancia', 0) => v < 20,
      ('distancia', 1) => v > 150,
      _ => false,
    };
  }

  static bool _detecta(double x) => x > 0.45 && x < 0.9;

  void cambiar(String id, double v) {
    setState(() {
      _valores[id] = v;
      for (var k = 0; k < 2; k++) {
        if (_cumple(id, k) && _logradas.add('$id$k')) HapticFeedback.mediumImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = _sensoresLab[_tab];
    final v = _valores[s.id]!;
    final hechas = [for (var k = 0; k < 2; k++) _logradas.contains('${s.id}$k')];
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Laboratorio', 'Laboratorio de sensores', widget.color),
        Positioned(
          left: 8,
          top: 60,
          width: 230,
          height: 200,
          child: GloboZatiEle(_listo ? '¡Probaste los 4 sensores! Cada uno “siente” algo distinto del ambiente y lo convierte en una señal eléctrica.' : s.explicacion),
        ),
        Positioned(
          left: 8,
          top: 266,
          width: 230,
          height: 206,
          child: PanelEle(
            titulo: 'Objetivos · ${s.nombre}',
            icono: Icons.flag_rounded,
            color: widget.color,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var k = 0; k < 2; k++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(hechas[k] ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 18, color: hechas[k] ? ColoresJuego.correcto : Colors.black38),
                    const SizedBox(width: 4),
                    Expanded(child: Text(s.metas[k], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                  ]),
                ),
              const Spacer(),
              Text('Metas logradas: ${_logradas.length} de 8', style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 58,
          width: 608,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < _sensoresLab.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChipEle(
                    texto: '${_sensoresLab[i].emoji} ${_sensoresLab[i].nombre}${_logradas.contains('${_sensoresLab[i].id}0') && _logradas.contains('${_sensoresLab[i].id}1') ? ' ✓' : ''}',
                    activo: _tab == i,
                    color: widget.color,
                    onTap: () => setState(() => _tab = i),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          left: 244,
          top: 92,
          width: 608,
          height: 262,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorSensor(s.id, v, t))),
          ),
        ),
        Positioned(
          left: 250,
          top: 360,
          width: 596,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14), border: Border.all(color: widget.color, width: 2)),
            child: Row(children: [
              Text(_etiquetaControl(s.id), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              Expanded(
                child: Tooltip(
                  message: 'Control ${s.nombre}',
                  child: Slider(
                    value: v,
                    min: _rango(s.id).$1,
                    max: _rango(s.id).$2,
                    activeColor: widget.color,
                    onChanged: (x) => cambiar(s.id, x),
                  ),
                ),
              ),
              SizedBox(width: 190, child: Text(_lectura(s.id, v), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1565C0)))),
            ]),
          ),
        ),
        if (_listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
              onTap: () => terminarPaso(context,
                  actividad: widget.actividad, estrellas: 3, titulo: '¡Laboratorio de sensores!', mensaje: 'Los sensores son los “sentidos” de los aparatos electrónicos.'),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  static (double, double) _rango(String id) => switch (id) {
        'temperatura' => (-10.0, 50.0),
        'distancia' => (2.0, 200.0),
        _ => (0.0, 1.0),
      };

  static String _etiquetaControl(String id) => switch (id) {
        'luz' => '🌙 ↔ ☀️',
        'temperatura' => '🧊 ↔ 🔥',
        'movimiento' => '🐈 posición',
        _ => '📦 distancia',
      };

  static String _lectura(String id, double v) {
    switch (id) {
      case 'luz':
        return 'Resistencia: ${textoOhms(Pieza.ohmsLdr(v).roundToDouble())}';
      case 'temperatura':
        return '${v.round()} °C · señal ${(0.5 + v / 100).toStringAsFixed(2)} V';
      case 'movimiento':
        return _detecta(v) ? '🔴 ¡Movimiento detectado!' : '⚪ Sin movimiento';
      default:
        return '${v.round()} cm · eco ${(2 * v / 34300 * 1000).toStringAsFixed(1)} ms';
    }
  }

  // Para pruebas.
  int get metas => _logradas.length;
  void elegir(int tab) => setState(() => _tab = tab);
}

class _PintorSensor extends CustomPainter {
  _PintorSensor(this.id, this.v, this.t);
  final String id;
  final double v, t;

  @override
  void paint(Canvas c, Size s) {
    switch (id) {
      case 'luz':
        final cielo = Color.lerp(const Color(0xFF1A237E), const Color(0xFF81D4FA), v)!;
        c.drawRect(Offset.zero & s, relleno(cielo));
        if (v > 0.35) {
          c.drawCircle(Offset(120, 70), 34 + 4 * math.sin(t * 2), relleno(Color.lerp(const Color(0x00FFEB3B), const Color(0xFFFFEB3B), (v - 0.35) / 0.65)!));
        } else {
          dibujarEmoji(c, '🌙', const Offset(120, 70), 50);
          for (var k = 0; k < 12; k++) {
            c.drawCircle(Offset(40 + k * 47.0 % 560, 20 + (k * 37 % 90)), 1.8, relleno(Colors.white70));
          }
        }
        c.drawRect(Rect.fromLTWH(0, s.height - 50, s.width, 50), relleno(const Color(0xFF6D4C41)));
        // Farola que enciende a oscuras
        c.drawRect(Rect.fromLTWH(470, 60, 8, s.height - 110), relleno(const Color(0xFF455A64)));
        c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(440, 50, 68, 18), const Radius.circular(8)), relleno(const Color(0xFF37474F)));
        if (Pieza.ohmsLdr(v) > 20000) {
          c.drawPath(Path()..moveTo(450, 68)..lineTo(410, s.height - 50)..lineTo(540, s.height - 50)..lineTo(498, 68)..close(), relleno(const Color(0x55FFF59D)));
          c.drawCircle(const Offset(474, 70), 10, relleno(const Color(0xFFFFF59D)));
        }
        dibujarPiezaEn(c, TipoPieza.ldr, Offset(290, s.height / 2 - 10), 3, luzFoco: 0);
        _medidor(c, Offset(24, s.height - 44), (math.log(Pieza.ohmsLdr(v)) / math.ln10 - 2.3) / 2.7, 'Resistencia');
      case 'temperatura':
        final calor = ((v + 10) / 60).clamp(0.0, 1.0);
        c.drawRect(Offset.zero & s, relleno(Color.lerp(const Color(0xFFB3E5FC), const Color(0xFFFFCCBC), calor)!));
        dibujarEmoji(c, v > 30 ? '🔥' : (v < 8 ? '🧊' : '🌤️'), const Offset(110, 120), 80);
        dibujarSensor(c, 'temperatura', const Offset(300, 120), 3.2);
        // Termómetro
        final base = const Offset(480, 200);
        c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(base.dx - 12, 30, 24, 170), const Radius.circular(12)), relleno(Colors.white));
        c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(base.dx - 12, 30, 24, 170), const Radius.circular(12)), linea(const Color(0xFF90A4AE), 2));
        final h = 150 * calor;
        c.drawRect(Rect.fromLTWH(base.dx - 6, 190 - h, 12, h + 10), relleno(const Color(0xFFE53935)));
        c.drawCircle(base + const Offset(0, 10), 20, relleno(const Color(0xFFE53935)));
        textoEn(c, '${v.round()} °C', const Offset(540, 110), tam: 22, color: const Color(0xFFB71C1C));
      case 'movimiento':
        c.drawRect(Offset.zero & s, relleno(const Color(0xFFFFF8E1)));
        c.drawRect(Rect.fromLTWH(0, s.height - 50, s.width, 50), relleno(const Color(0xFFBCAAA4)));
        final pir = const Offset(560, 40);
        final detecta = LabSensoresState._detecta(v);
        c.drawPath(Path()..moveTo(pir.dx, pir.dy)..lineTo(0.45 * s.width, s.height - 50)..lineTo(0.9 * s.width, s.height - 50)..close(),
            relleno((detecta ? const Color(0xFFFF5252) : const Color(0xFF42A5F5)).withValues(alpha: 0.18 + (detecta ? 0.1 * math.sin(t * 10).abs() : 0))));
        dibujarSensor(c, 'movimiento', pir, 1.6, activo: detecta);
        dibujarEmoji(c, '🐈', Offset(30 + v * (s.width - 60), s.height - 80), 60);
        if (detecta) textoEn(c, '¡Movimiento!', const Offset(300, 40), tam: 22, color: Colors.white, fondo: const Color(0xFFE53935));
      default:
        c.drawRect(Offset.zero & s, relleno(const Color(0xFFE8F5E9)));
        c.drawRect(Rect.fromLTWH(0, s.height - 60, s.width, 60), relleno(const Color(0xFF9E9E9E)));
        final sensor = Offset(70, s.height - 110);
        dibujarSensor(c, 'distancia', sensor, 1.5);
        final x = 130 + (v / 200) * (s.width - 200);
        dibujarEmoji(c, '📦', Offset(x + 30, s.height - 110), 70);
        // Ondas de ida y eco
        for (var k = 0; k < 3; k++) {
          final f = (t * 0.9 + k / 3) % 1;
          final px = sensor.dx + 50 + f * (x - sensor.dx - 50);
          c.drawArc(Rect.fromCircle(center: Offset(px, sensor.dy), radius: 18), -math.pi / 3, 2 * math.pi / 3, false, linea(const Color(0xFF1E88E5).withValues(alpha: 1 - f * 0.6), 3));
        }
        c.drawLine(Offset(sensor.dx + 40, s.height - 40), Offset(x, s.height - 40), linea(const Color(0xFF263238), 2));
        textoEn(c, '${v.round()} cm', Offset((sensor.dx + 40 + x) / 2, s.height - 28), tam: 16, color: const Color(0xFF263238));
        if (v < 20) textoEn(c, '¡Muy cerca! 🚨', const Offset(300, 40), tam: 20, color: Colors.white, fondo: const Color(0xFFE53935));
    }
  }

  void _medidor(Canvas c, Offset o, double f, String texto) {
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(o.dx, o.dy, 180, 16), const Radius.circular(8)), relleno(Colors.white));
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(o.dx, o.dy, 180 * f.clamp(0, 1), 16), const Radius.circular(8)), relleno(const Color(0xFFFF8F00)));
    textoEn(c, texto, o + const Offset(90, -12), tam: 12, color: Colors.white, fondo: const Color(0x88000000));
  }

  @override
  bool shouldRepaint(_PintorSensor old) => true;
}

// ===========================================================================
// Engranes: velocidad, fuerza y sentido de giro
// ===========================================================================

class SimEngranes extends StatefulWidget {
  const SimEngranes({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimEngranes> createState() => SimEngranesState();
}

class SimEngranesState extends State<SimEngranes> {
  int motor = 20, salida = 20;
  bool loca = false;
  final _logros = <int>{};
  static const _metas = ['La salida gira MÁS RÁPIDO que el motor', 'La salida gira MÁS LENTO (con más fuerza)', 'La salida gira en el MISMO sentido que el motor'];

  double get relacion => motor / salida;

  void _revisar() {
    final antes = _logros.length;
    if (relacion > 1) _logros.add(0);
    if (relacion < 1) _logros.add(1);
    if (loca) _logros.add(2);
    if (_logros.length > antes) HapticFeedback.mediumImpact();
  }

  void cambiar({int? m, int? s, bool? l}) => setState(() {
        motor = m ?? motor;
        salida = s ?? salida;
        loca = l ?? loca;
        _revisar();
      });

  @override
  Widget build(BuildContext context) {
    final listo = _logros.length == 3;
    final rpmSalida = 60 * relacion;
    final mensaje = listo
        ? '¡Lo lograste! Un engrane pequeño que mueve a uno grande da MÁS FUERZA pero menos velocidad. Uno grande que mueve a uno pequeño da MÁS VELOCIDAD. Y una rueda loca en medio cambia el sentido de giro.'
        : 'Los engranes pasan el movimiento del motor a otras piezas. Cambia el número de dientes y agrega una rueda loca para lograr los 3 objetivos.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'Engranes en acción', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 196, child: GloboZatiEle(mensaje, tam: 13)),
        Positioned(
          left: 8,
          top: 262,
          width: 230,
          height: 210,
          child: PanelEle(
            titulo: 'Objetivos',
            icono: Icons.flag_rounded,
            color: widget.color,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var k = 0; k < 3; k++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(_logros.contains(k) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 18, color: _logros.contains(k) ? ColoresJuego.correcto : Colors.black38),
                    const SizedBox(width: 4),
                    Expanded(child: Text(_metas[k], style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600))),
                  ]),
                ),
            ]),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 270,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorEngranes(motor, salida, loca, t, rpmSalida))),
          ),
        ),
        Positioned(
          left: 244,
          top: 334,
          width: 608,
          height: 82,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14), border: Border.all(color: widget.color, width: 2)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const SizedBox(width: 120, child: Text('Engrane del motor:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                for (final n in const [10, 20, 30])
                  Padding(padding: const EdgeInsets.only(right: 4), child: ChipEle(texto: '$n dientes', activo: motor == n, color: const Color(0xFFFFA000), onTap: () => cambiar(m: n))),
                const Spacer(),
                ChipEle(texto: loca ? '⚙️ Con rueda loca' : '⚙️ Agregar rueda loca', activo: loca, color: const Color(0xFF7E57C2), onTap: () => cambiar(l: !loca)),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const SizedBox(width: 120, child: Text('Engrane de salida:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                for (final n in const [10, 20, 30])
                  Padding(padding: const EdgeInsets.only(right: 4), child: ChipEle(texto: '$n dientes', activo: salida == n, color: const Color(0xFF00897B), onTap: () => cambiar(s: n))),
              ]),
            ]),
          ),
        ),
        if (listo)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
              onTap: () => terminarPaso(context,
                  actividad: widget.actividad, estrellas: 3, titulo: '¡Engranes en acción!', mensaje: 'Los engranes están en bicicletas, relojes, licuadoras y robots.'),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  // Para pruebas.
  int get logros => _logros.length;
}

class _PintorEngranes extends CustomPainter {
  _PintorEngranes(this.motor, this.salida, this.loca, this.t, this.rpm);
  final int motor, salida;
  final bool loca;
  final double t, rpm;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFFECEFF1)));
    final g = linea(const Color(0xFFCFD8DC), 1);
    for (var x = 0.0; x < s.width; x += 20) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), g);
    }
    double rad(int n) => n * 2.6;
    const y = 122.0;
    final ra = rad(motor), rb = rad(salida), ri = rad(12);
    final xa = 120.0 + ra * 0.2;
    final xi = xa + ra + ri - 4;
    final xb = (loca ? xi + ri : xa + ra) + rb - 4;
    // Motor
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(xa - 50, y + ra + 14, 100, 46), const Radius.circular(10)), relleno(const Color(0xFF90A4AE)));
    textoEn(c, 'MOTOR', Offset(xa, y + ra + 37), tam: 14, color: Colors.white);
    final w = t * 2.0;
    dibujarEngrane(c, Offset(xa, y), ra, motor, w, const Color(0xFFFFB300));
    if (loca) dibujarEngrane(c, Offset(xi, y), ri, 12, -w * motor / 12 + 0.12, const Color(0xFF7E57C2));
    final wb = (loca ? 1 : -1) * w * motor / salida + 0.1;
    dibujarEngrane(c, Offset(xb, y), rb, salida, wb, const Color(0xFF26A69A));
    // Flechas de sentido
    void sentido(Offset centro, double r, bool horario, Color col) {
      final a0 = -math.pi * 0.85, a1 = -math.pi * 0.25;
      final rect = Rect.fromCircle(center: centro, radius: r + 14);
      c.drawArc(rect, a0, a1 - a0, false, linea(col, 3.5));
      final fin = horario ? a1 : a0;
      final p = centro + Offset(math.cos(fin), math.sin(fin)) * (r + 14);
      c.drawCircle(p, 5, relleno(col));
      textoEn(c, horario ? '↻' : '↺', centro + Offset(0, -r - 30), tam: 20, color: col);
    }

    sentido(Offset(xa, y), ra, true, const Color(0xFFE65100));
    sentido(Offset(xb, y), rb, loca, const Color(0xFF00695C));
    textoEn(c, 'Salida', Offset(xb, y + rb + 18), tam: 13, color: const Color(0xFF00695C), fondo: Colors.white);
    if (loca) textoEn(c, 'Rueda loca', Offset(xi, y + ri + 18), tam: 12, color: const Color(0xFF4527A0), fondo: Colors.white);
    textoEn(c, 'Motor: 60 vueltas/min   →   Salida: ${rpm.round()} vueltas/min', Offset(s.width / 2, s.height - 14), tam: 13,
        color: Colors.white, fondo: const Color(0xFF1565C0));
  }

  @override
  bool shouldRepaint(_PintorEngranes old) => true;
}
