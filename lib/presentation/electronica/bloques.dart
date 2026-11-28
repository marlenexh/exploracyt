import 'dart:async';
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

/// Programación por bloques, como los "Bloques de código" de Tinkercad:
/// SI (entrada) ENTONCES (salida) SI NO (salida).

const colorEntrada = Color(0xFF8E44AD);
const colorControl = Color(0xFFF39C12);
const colorSalida = Color(0xFF2E86DE);

class SensorProg {
  const SensorProg(this.id, this.nombre, this.emoji, this.unidad, this.umbrales);
  final String id, nombre, emoji, unidad;
  final List<double> umbrales;
}

class SalidaProg {
  const SalidaProg(this.id, this.nombre, this.emoji);
  final String id, nombre, emoji;
}

const sensorLuz = SensorProg('luz', 'luz', '☀️', '%', [20, 50, 80]);
const sensorTemp = SensorProg('temp', 'temperatura', '🌡️', '°C', [15, 28, 40]);
const sensorMov = SensorProg('mov', 'movimiento', '🚶', '', [0.5]);
const sensorDist = SensorProg('dist', 'distancia', '📏', 'cm', [10, 30, 100]);
const sensorHum = SensorProg('hum', 'humedad de la tierra', '💧', '%', [20, 40, 70]);

const salidaFoco = SalidaProg('foco', 'foco', '💡');
const salidaVentilador = SalidaProg('ventilador', 'ventilador', '🌀');
const salidaAlarma = SalidaProg('alarma', 'alarma', '🔔');
const salidaBarrera = SalidaProg('barrera', 'barrera', '🚧');
const salidaBomba = SalidaProg('bomba', 'bomba de agua', '🚿');

class Momento {
  const Momento(this.nombre, this.emoji, this.lecturas);
  final String nombre, emoji;
  final Map<String, double> lecturas;
}

class RetoProg {
  const RetoProg({
    required this.titulo,
    required this.instruccion,
    required this.sensores,
    required this.salidas,
    required this.momentos,
    required this.esperado,
    required this.logro,
    this.reglas = 1,
  });
  final String titulo, instruccion, logro;
  final List<SensorProg> sensores;
  final List<SalidaProg> salidas;
  final List<Momento> momentos;

  /// Qué salidas deben estar encendidas en cada momento.
  final Map<String, bool> Function(Map<String, double> lecturas) esperado;
  final int reglas;
}

class Regla {
  int sensor = 0, umbral = 0, salida = 0;
  bool mayor = true, encender = true;
}

Map<String, bool> ejecutarPrograma(RetoProg reto, List<Regla> reglas, Map<String, double> lecturas) {
  final out = {for (final s in reto.salidas) s.id: false};
  for (final r in reglas) {
    final s = reto.sensores[r.sensor];
    final v = lecturas[s.id] ?? 0;
    final u = s.umbrales[r.umbral.clamp(0, s.umbrales.length - 1)];
    final cumple = r.mayor ? v > u : v < u;
    out[reto.salidas[r.salida].id] = cumple ? r.encender : !r.encender;
  }
  return out;
}

/// Busca un programa que resuelva el reto y que se parezca lo más posible al
/// del alumno (para la 💡 Pista). Devuelve null si no hay solución.
List<Regla>? solucionCercana(RetoProg reto, List<Regla> actual) {
  final opciones = <Regla>[];
  for (var se = 0; se < reto.sensores.length; se++) {
    for (var u = 0; u < reto.sensores[se].umbrales.length; u++) {
      for (final ma in [true, false]) {
        for (var sa = 0; sa < reto.salidas.length; sa++) {
          for (final en in [true, false]) {
            opciones.add(Regla()
              ..sensor = se
              ..umbral = u
              ..mayor = ma
              ..salida = sa
              ..encender = en);
          }
        }
      }
    }
  }
  int distancia(Regla a, Regla b) =>
      (a.sensor != b.sensor ? 1 : 0) +
      (a.umbral != b.umbral ? 1 : 0) +
      (a.mayor != b.mayor ? 1 : 0) +
      (a.salida != b.salida ? 1 : 0) +
      (a.encender != b.encender ? 1 : 0);
  bool resuelve(List<Regla> rs) => reto.momentos.every((m) {
        final esp = reto.esperado(m.lecturas);
        final obt = ejecutarPrograma(reto, rs, m.lecturas);
        return esp.entries.every((e) => obt[e.key] == e.value);
      });
  List<Regla>? mejor;
  var dMejor = 1 << 30;
  void buscar(List<Regla> parcial) {
    if (parcial.length == actual.length) {
      if (!resuelve(parcial)) return;
      var d = 0;
      for (var i = 0; i < parcial.length; i++) {
        d += distancia(parcial[i], actual[i]);
      }
      if (d < dMejor) {
        dMejor = d;
        mejor = [...parcial];
      }
      return;
    }
    for (final o in opciones) {
      buscar([...parcial, o]);
    }
  }

  buscar([]);
  return mejor;
}

class ProgramaBloques extends StatefulWidget {
  const ProgramaBloques(
      {super.key, required this.actividad, required this.seccion, required this.titulo, required this.color, required this.retos, required this.mensajeFinal});
  final String actividad, seccion, titulo, mensajeFinal;
  final Color color;
  final List<RetoProg> retos;
  @override
  State<ProgramaBloques> createState() => ProgramaBloquesState();
}

class ProgramaBloquesState extends State<ProgramaBloques> {
  int _r = 0;
  late List<Regla> reglas;
  int _errores = 0;
  int? _mostrando;
  List<bool?> _resultados = [];
  bool _completo = false;
  late String _mensaje;
  Timer? _timer;

  RetoProg get reto => widget.retos[_r];

  @override
  void initState() {
    super.initState();
    _nuevo();
  }

  void _nuevo() {
    reglas = List.generate(reto.reglas, (i) => Regla()..salida = i % reto.salidas.length);
    _resultados = List.filled(reto.momentos.length, null);
    _mostrando = null;
    _completo = false;
    _mensaje = reto.instruccion;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _correcto(int i) {
    final m = reto.momentos[i];
    final obtenido = ejecutarPrograma(reto, reglas, m.lecturas);
    final esperado = reto.esperado(m.lecturas);
    return esperado.entries.every((e) => obtenido[e.key] == e.value);
  }

  /// 💡 Pista: dice qué bloque cambiar; si la pide otra vez, lo cambia.
  String? _ultimaPista;
  int pistasUsadas = 0;
  void darPista() {
    if (_completo) return;
    final sol = solucionCercana(reto, reglas);
    if (sol == null) return;
    HapticFeedback.selectionClick();
    setState(() {
      pistasUsadas++;
      for (var i = 0; i < reglas.length; i++) {
        final r = reglas[i], b = sol[i];
        final regla = reglas.length > 1 ? ' de la regla ${i + 1}' : '';
        final s = reto.sensores[b.sensor];
        final cambios = <(String, String, VoidCallback)>[
          if (r.sensor != b.sensor)
            (
              'sensor$i',
              'En el bloque morado$regla elige el sensor ${s.emoji} ${s.nombre}: es el que mide lo que importa aquí.',
              () {
                r.sensor = b.sensor;
                r.umbral = 0;
              }
            ),
          if (r.mayor != b.mayor)
            (
              'mayor$i',
              s.id == 'mov'
                  ? 'Cambia “${r.mayor ? 'detecta' : 'no detecta'}”$regla: piensa cuándo debe pasar.'
                  : 'Cambia la comparación$regla a “${b.mayor ? 'mayor que >' : 'menor que <'}”: ¿debe pasar cuando hay más o cuando hay menos ${s.nombre}?',
              () => r.mayor = b.mayor
            ),
          if (r.umbral != b.umbral)
            ('umbral$i', 'Cambia el número$regla a ${s.umbrales[b.umbral].round()} ${s.unidad}: lee bien la instrucción.', () => r.umbral = b.umbral),
          if (r.salida != b.salida)
            ('salida$i', 'En el bloque azul$regla elige ${reto.salidas[b.salida].emoji} ${reto.salidas[b.salida].nombre}.', () => r.salida = b.salida),
          if (r.encender != b.encender)
            ('encender$i', 'Cambia “${r.encender ? 'encender' : 'apagar'}”$regla por “${b.encender ? 'encender' : 'apagar'}”.', () => r.encender = b.encender),
        ];
        if (cambios.isEmpty) continue;
        final (id, texto, aplicar) = cambios.first;
        if (_ultimaPista == id) {
          aplicar();
          _ultimaPista = null;
          _resultados = List.filled(reto.momentos.length, null);
          _mostrando = null;
          _mensaje = '🔧 Lo cambié por ti. Pide otra 💡 Pista o presiona “Probar programa”.';
        } else {
          _ultimaPista = id;
          _mensaje = '💡 Pista: $texto\n(Toca 💡 otra vez y lo cambio por ti.)';
        }
        return;
      }
      _mensaje = '✅ ¡Tus bloques ya están bien! Presiona “Probar programa” ▶ para comprobarlo.';
    });
  }

  void probar() {
    _timer?.cancel();
    HapticFeedback.lightImpact();
    setState(() {
      _resultados = List.filled(reto.momentos.length, null);
      _mostrando = 0;
      _resultados[0] = _correcto(0);
      _mensaje = 'Probando el programa… ▶️';
    });
    _timer = Timer.periodic(const Duration(milliseconds: 900), (tm) {
      if (!mounted) return tm.cancel();
      final i = (_mostrando ?? 0) + 1;
      if (i >= reto.momentos.length) {
        tm.cancel();
        _terminarPrueba();
        return;
      }
      setState(() {
        _mostrando = i;
        _resultados[i] = _correcto(i);
      });
    });
  }

  void _terminarPrueba() {
    final mal = _resultados.indexWhere((x) => x == false);
    setState(() {
      if (mal == -1) {
        HapticFeedback.mediumImpact();
        _completo = true;
        _mensaje = '¡Tu invento funciona! 🎉 ${reto.logro}';
      } else {
        HapticFeedback.heavyImpact();
        _errores++;
        final m = reto.momentos[mal];
        final esp = reto.esperado(m.lecturas);
        final s = reto.salidas.firstWhere((x) => esp.containsKey(x.id) && ejecutarPrograma(reto, reglas, m.lecturas)[x.id] != esp[x.id]);
        _mensaje = 'En “${m.nombre}” ${s.emoji} el ${s.nombre} debería estar ${esp[s.id]! ? 'ENCENDIDO' : 'APAGADO'}. Revisa tus bloques y vuelve a probar.';
      }
    });
  }

  void _siguiente() {
    if (_r < widget.retos.length - 1) {
      setState(() {
        _r++;
        _nuevo();
      });
    } else {
      terminarPaso(context, actividad: widget.actividad, estrellas: estrellasPorErrores(_errores), titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal);
    }
  }

  void _cambiar(VoidCallback f) {
    if (_mostrando != null && !_completo && _timer?.isActive == true) return;
    HapticFeedback.selectionClick();
    setState(() {
      f();
      _resultados = List.filled(reto.momentos.length, null);
      _mostrando = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final m = reto.momentos[_mostrando ?? 0];
    final salidas = _mostrando == null ? {for (final s in reto.salidas) s.id: false} : ejecutarPrograma(reto, reglas, m.lecturas);
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.seccion, widget.retos.length > 1 ? '${widget.titulo} · ${_r + 1} de ${widget.retos.length}' : widget.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(_mensaje, tam: 13)),
        Positioned(
          left: 8,
          top: 256,
          width: 230,
          height: 216,
          child: PanelEle(
            titulo: 'Así se lee',
            icono: Icons.lightbulb_rounded,
            color: colorControl,
            child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Leyenda(colorEntrada, 'ENTRADA', 'Lo que mide el sensor'),
              _Leyenda(colorControl, 'CONTROL', 'La decisión: si… entonces…'),
              _Leyenda(colorSalida, 'SALIDA', 'Lo que hace el aparato'),
              SizedBox(height: 4),
              Text('Toca cada bloque para cambiarlo y luego presiona “Probar programa”.', style: TextStyle(fontSize: 12, height: 1.15)),
            ]),
          ),
        ),
        // Editor de código
        Positioned(
          left: 244,
          top: 60,
          width: 340,
          height: 350,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFF2B2B3A), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF555570), width: 2)),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _bloque(colorControl, [const _TextoBloque('al iniciar, repetir siempre:')]),
                const SizedBox(height: 6),
                for (var i = 0; i < reglas.length; i++) ...[_regla(i), const SizedBox(height: 8)],
              ]),
            ),
          ),
        ),
        // Simulación
        Positioned(
          left: 590,
          top: 60,
          width: 262,
          height: 350,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(16), border: Border.all(color: widget.color, width: 2.5)),
            child: Column(children: [
              const SizedBox(height: 6),
              Text(_mostrando == null ? 'Simulación' : '${m.emoji} ${m.nombre}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text(
                  _mostrando == null
                      ? 'Presiona “Probar programa”'
                      : [for (final s in reto.sensores) '${s.emoji} ${_lectura(s, m.lecturas[s.id] ?? 0)}'].join('   '),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colorEntrada)),
              Expanded(child: Reloj(builder: (_, t) => CustomPaint(size: Size.infinite, painter: _PintorSalidas(reto.salidas, salidas, t, m.emoji)))),
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                child: Row(children: [
                  for (var i = 0; i < reto.momentos.length; i++)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: _resultados[i] == null ? const Color(0xFFF1F1F1) : (_resultados[i]! ? const Color(0xFFC8E6C9) : const Color(0xFFFFCDD2)),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _mostrando == i ? widget.color : Colors.black12, width: 2),
                        ),
                        child: Column(children: [
                          Text(reto.momentos[i].emoji, style: const TextStyle(fontSize: 16)),
                          Text(_resultados[i] == null ? '·' : (_resultados[i]! ? '✅' : '❌'), style: const TextStyle(fontSize: 11)),
                        ]),
                      ),
                    ),
                ]),
              ),
            ]),
          ),
        ),
        if (!_completo)
          Positioned(
            left: 244,
            top: 418,
            child: Tooltip(
              message: 'Probar programa',
              child: BotonJuego(texto: 'Probar programa', icono: Icons.play_arrow_rounded, color: const Color(0xFF2DB84C), onTap: probar),
            ),
          ),
        if (!_completo)
          Positioned(
            left: 690,
            top: 418,
            child: Tooltip(
              message: 'Pista',
              child: BotonJuego(texto: 'Pista', icono: Icons.lightbulb_rounded, color: const Color(0xFFFFA000), onTap: darPista),
            ),
          ),
        if (_completo)
          Positioned(left: 690, top: 420, child: BotonSiguiente(texto: _r < widget.retos.length - 1 ? 'Siguiente invento' : 'Terminar', onTap: _siguiente)),
        const BotonVolverEscena(),
      ],
    );
  }

  String _lectura(SensorProg s, double v) {
    if (s.id == 'mov') return v > 0.5 ? 'sí' : 'no';
    return '${v.round()} ${s.unidad}';
  }

  Widget _regla(int i) {
    final r = reglas[i];
    final s = reto.sensores[r.sensor];
    final sal = reto.salidas[r.salida];
    final esMov = s.id == 'mov';
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
      decoration: BoxDecoration(
          color: colorControl, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Color(0xFFB9770E), offset: Offset(0, 3))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Wrap(spacing: 4, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
          const _TextoBloque('si'),
          _Ficha(
              'Regla ${i + 1} sensor',
              colorEntrada,
              '${s.emoji} ${s.nombre}',
              () => _cambiar(() {
                    r.sensor = (r.sensor + 1) % reto.sensores.length;
                    r.umbral = 0;
                  })),
          if (esMov)
            _Ficha('Regla ${i + 1} comparar', colorEntrada, r.mayor ? 'detecta' : 'no detecta', () => _cambiar(() => r.mayor = !r.mayor))
          else ...[
            _Ficha('Regla ${i + 1} comparar', colorEntrada, r.mayor ? 'es mayor que' : 'es menor que', () => _cambiar(() => r.mayor = !r.mayor)),
            _Ficha('Regla ${i + 1} valor', colorEntrada, '${s.umbrales[r.umbral].round()} ${s.unidad}',
                () => _cambiar(() => r.umbral = (r.umbral + 1) % s.umbrales.length)),
          ],
          const _TextoBloque('entonces'),
        ]),
        Container(
          margin: const EdgeInsets.only(left: 14, top: 6, bottom: 4),
          child: Wrap(spacing: 4, children: [
            _Ficha('Regla ${i + 1} acción', colorSalida, r.encender ? 'encender' : 'apagar', () => _cambiar(() => r.encender = !r.encender)),
            _Ficha('Regla ${i + 1} salida', colorSalida, '${sal.emoji} ${sal.nombre}', () => _cambiar(() => r.salida = (r.salida + 1) % reto.salidas.length)),
          ]),
        ),
        const _TextoBloque('si no'),
        Container(
          margin: const EdgeInsets.only(left: 14, top: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: colorSalida.withValues(alpha: 0.85), borderRadius: BorderRadius.circular(8)),
          child: Text('${r.encender ? 'apagar' : 'encender'} ${sal.emoji} ${sal.nombre}',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
      ]),
    );
  }

  Widget _bloque(Color c, List<Widget> hijos) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: hijos),
      );

  // Para pruebas.
  bool get completo => _completo;
  int get errores => _errores;
  bool? resultado(int i) => _resultados[i];
}

class _TextoBloque extends StatelessWidget {
  const _TextoBloque(this.t);
  final String t;
  @override
  Widget build(BuildContext context) => Text(t, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Colors.white));
}

class _Ficha extends StatelessWidget {
  const _Ficha(this.tooltip, this.color, this.texto, this.onTap);
  final String tooltip, texto;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Tooltip(
        message: tooltip,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white, width: 1.5),
              boxShadow: [BoxShadow(color: oscurecer(color, 0.35), offset: const Offset(0, 2))],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text(texto, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.white)),
              const Icon(Icons.arrow_drop_down_rounded, color: Colors.white, size: 18),
            ]),
          ),
        ),
      );
}

class _Leyenda extends StatelessWidget {
  const _Leyenda(this.color, this.titulo, this.texto);
  final Color color;
  final String titulo, texto;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: Text(titulo, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
          ),
          const SizedBox(width: 6),
          Expanded(child: Text(texto, style: const TextStyle(fontSize: 12))),
        ]),
      );
}

class _PintorSalidas extends CustomPainter {
  _PintorSalidas(this.salidas, this.estado, this.t, this.fondo);
  final List<SalidaProg> salidas;
  final Map<String, bool> estado;
  final double t;
  final String fondo;
  @override
  void paint(Canvas c, Size s) {
    dibujarEmoji(c, fondo, Offset(s.width - 34, 30), 40);
    final n = salidas.length;
    for (var i = 0; i < n; i++) {
      final on = estado[salidas[i].id] ?? false;
      final p = Offset(s.width * (i + 1) / (n + 1), s.height * 0.55);
      switch (salidas[i].id) {
        case 'foco':
          dibujarPiezaEn(c, TipoPieza.foco, p, 1.6, luzFoco: on ? 1 : 0);
        case 'ventilador':
          dibujarPiezaEn(c, TipoPieza.motor, p, 1.5, giro: on ? t * 14 : 0);
        case 'alarma':
          dibujarPiezaEn(c, TipoPieza.zumbador, p, 1.4, suena: on, t: t);
        case 'barrera':
          c.drawRect(Rect.fromCenter(center: p + const Offset(-40, 20), width: 16, height: 50), relleno(const Color(0xFF546E7A)));
          c.save();
          c.translate(p.dx - 40, p.dy);
          c.rotate(on ? -math.pi / 2.4 : 0);
          for (var k = 0; k < 5; k++) {
            c.drawRect(Rect.fromLTWH(k * 18.0, -5, 18, 10), relleno(k.isEven ? const Color(0xFFE53935) : Colors.white));
          }
          c.restore();
        case 'bomba':
          dibujarEmoji(c, '🪴', p + const Offset(0, 20), 46);
          if (on) {
            for (var k = 0; k < 4; k++) {
              final f = (t * 1.5 + k / 4) % 1;
              c.drawCircle(p + Offset(-12 + k * 8.0, -40 + f * 40), 3, relleno(const Color(0xFF29B6F6)));
            }
          }
      }
      final estadoTxt = salidas[i].id == 'barrera' ? (on ? 'ARRIBA' : 'ABAJO') : (on ? 'ENCENDIDO' : 'APAGADO');
      // Con dos aparatos se usa el emoji para que los letreros no se encimen.
      textoEn(c, salidas.length > 1 ? '${salidas[i].emoji} $estadoTxt' : '${salidas[i].nombre}: $estadoTxt', Offset(p.dx, s.height - 12),
          tam: 11, color: Colors.white, fondo: on ? const Color(0xFF2DB84C) : const Color(0xFF90A4AE));
    }
  }

  @override
  bool shouldRepaint(_PintorSalidas old) => true;
}
