import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/pasos.dart' show estrellasPorErrores;
import 'circuito.dart';
import 'comun.dart';
import 'dibujos.dart';

/// Condición que el alumno debe lograr durante la simulación.
class Condicion {
  const Condicion(this.texto, this.cumple);
  final String texto;
  final bool Function(EstadoCircuito e) cumple;
}

/// Un reto del taller de circuitos (como un proyecto de Tinkercad).
class RetoCircuito {
  const RetoCircuito({
    required this.titulo,
    required this.instruccion,
    required this.piezas,
    required this.condiciones,
    required this.logro,
    this.cables = const [],
    this.quemarEsError = true,
  });
  final String titulo;
  final String instruccion;

  /// Crea las piezas nuevas cada vez que empieza el reto.
  final List<Pieza> Function() piezas;

  /// Cables que ya vienen puestos (no se pueden quitar).
  final List<(String, String)> cables;
  final List<Condicion> condiciones;
  final String logro;

  /// Si quemar un LED o hacer un cortocircuito cuenta como error.
  final bool quemarEsError;
}

/// Cómo se arma cada reto, por fases (algunos retos piden primero un
/// circuito “equivocado” para observar qué pasa y luego corregirlo). Lo usa el
/// botón 💡 Pista para guiar al alumno cable por cable.
const solucionesTaller = <String, List<List<(String, String)>>>{
  'Tu primer LED': [_led],
  '¿Y si lo volteas?': [
    [('r.1', 'led.1'), ('led.0', 'pila.1')],
    [('r.1', 'led.0'), ('led.1', 'pila.1')],
  ],
  'Elige la resistencia': [_led],
  'Linterna': [
    [('pila.0', 'sw.0'), ('sw.1', 'foco.0'), ('foco.1', 'pila.1')]
  ],
  'Timbre': [
    [('pila.0', 'b.0'), ('b.1', 'z.0'), ('z.1', 'pila.1')]
  ],
  'Enciende el foco': [
    [('pila.0', 'sw.0'), ('sw.1', 'foco.0'), ('foco.1', 'pila.1')]
  ],
  'Circuito con interruptor': [
    [('pila.0', 'sw.0'), ('sw.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]
  ],
  'Encuentra la falla': [
    [('r.1', 'led.0')]
  ],
  'En serie': [
    [('pila.0', 'r.0'), ('r.1', 'a.0'), ('a.1', 'b.0'), ('b.1', 'pila.1')]
  ],
  'En paralelo': [
    [('pila.0', 'r1.0'), ('pila.0', 'r2.0'), ('r1.1', 'a.0'), ('r2.1', 'b.0'), ('a.1', 'pila.1'), ('b.1', 'pila.1')]
  ],
  'Cortocircuito': [
    [('pila.0', 'pila.1')],
    _led,
  ],
  'Fotorresistencia': [
    [('pila.0', 'ldr.0'), ('ldr.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]
  ],
  'Sensor de luz del jardín': [
    [('pila.0', 'ldr.0'), ('ldr.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]
  ],
  'Enciende el motor': [
    [('pila.0', 'sw.0'), ('sw.1', 'm.0'), ('m.1', 'pila.1')]
  ],
  'Cambia el sentido': [
    [('pila.0', 'm.0'), ('m.1', 'pila.1')],
    [('pila.0', 'm.1'), ('m.0', 'pila.1')],
  ],
  'Control de velocidad': [
    [('pila.0', 'pot.0'), ('pot.1', 'm.0'), ('m.1', 'pila.1')]
  ],
  'Ventilador': [
    [('pila.0', 'sw.0'), ('sw.1', 'm.0'), ('m.1', 'pila.1'), ('sw.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')]
  ],
  'Alarma con luz': [_alarma],
  'Timbre con luz': [_alarma],
  'Luces de la sala y la cocina': [
    [('pila.0', 'sw.0'), ('sw.1', 'f1.0'), ('sw.1', 'f2.0'), ('f1.1', 'pila.1'), ('f2.1', 'pila.1')]
  ],
  'Ventilador con velocidades': [
    [('pila.0', 'sw.0'), ('sw.1', 'pot.0'), ('pot.1', 'm.0'), ('m.1', 'pila.1')]
  ],
};
const _led = [('pila.0', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')];
const _alarma = [('pila.0', 'b.0'), ('b.1', 'z.0'), ('z.1', 'pila.1'), ('b.1', 'r.0'), ('r.1', 'led.0'), ('led.1', 'pila.1')];

/// Nombre de una terminal en palabras sencillas (para las pistas).
String nombreTerminal(List<Pieza> piezas, String terminal) {
  final partes = terminal.split('.');
  final p = piezas.firstWhere((x) => x.id == partes[0]);
  final k = int.parse(partes[1]);
  final iguales = [
    for (final x in piezas)
      if (x.tipo == p.tipo) x.id
  ];
  final n = iguales.length > 1 ? ' ${iguales.indexOf(p.id) + 1}' : '';
  final otra = k == 0 ? 'una punta' : 'la otra punta';
  return switch (p.tipo) {
    TipoPieza.pila9v || TipoPieza.pila3v => k == 0 ? 'el + de la pila (rojo)' : 'el − de la pila (negro)',
    TipoPieza.led => k == 0 ? 'la pata + del LED$n (ánodo, la pata doblada)' : 'la pata − del LED$n (cátodo, la pata recta)',
    TipoPieza.zumbador => k == 0 ? 'el + del zumbador' : 'el − del zumbador',
    TipoPieza.resistencia => '$otra de la resistencia$n',
    TipoPieza.interruptor => '$otra del interruptor',
    TipoPieza.boton => '$otra del botón',
    TipoPieza.motor => '$otra del motor',
    TipoPieza.foco => '$otra del foco$n',
    TipoPieza.ldr => '$otra de la fotorresistencia',
    TipoPieza.potenciometro => k == 1 ? 'la pata central del potenciómetro' : (k == 0 ? 'una orilla del potenciómetro' : 'la otra orilla del potenciómetro'),
  };
}

const anchoArea = 608.0, altoArea = 350.0;
const _origenArea = Offset(244, 60);

const _coloresCable = [Color(0xFF2E7D32), Color(0xFF1565C0), Color(0xFFF9A825), Color(0xFF6A1B9A), Color(0xFFEF6C00)];

/// Taller de circuitos: el alumno conecta terminales con cables y simula.
class TallerCircuitos extends StatefulWidget {
  const TallerCircuitos({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.retos,
    required this.mensajeFinal,
  });
  final String actividad, seccion, titulo, mensajeFinal;
  final Color color;
  final List<RetoCircuito> retos;
  @override
  State<TallerCircuitos> createState() => TallerCircuitosState();
}

class TallerCircuitosState extends State<TallerCircuitos> {
  int _reto = 0;
  late List<Pieza> piezas;
  late List<Cable> cables;
  final _logradas = <int>{};
  String? _terminalSel;
  String? _piezaSel;
  bool corriendo = false;
  EstadoCircuito? _estado;
  double luz = 1;
  int _errores = 0;
  late String _mensaje;
  bool _completo = false;
  Offset? _abajo;
  String? _botonApretado;

  /// Cable que sugiere la pista (terminales que brillan) o cable que sobra.
  (String, String)? pista;
  int? cableSobrante;
  int pistasUsadas = 0;

  RetoCircuito get reto => widget.retos[_reto];

  @override
  void initState() {
    super.initState();
    _iniciarReto();
  }

  void _iniciarReto() {
    piezas = reto.piezas();
    cables = [for (final (a, b) in reto.cables) Cable(a, b, color: _colorPara(a, b), fijo: true)];
    _logradas.clear();
    _terminalSel = _piezaSel = null;
    corriendo = false;
    _estado = null;
    luz = 1;
    _completo = false;
    pista = null;
    cableSobrante = null;
    _mensaje = reto.instruccion;
  }

  // --- Pistas -------------------------------------------------------------------

  bool _hay(String a, String b) => cables.any((c) => c.une(a, b));

  /// 💡 Pista: dice qué cable falta (o sobra). Si la vuelve a pedir para el
  /// mismo cable, lo conecta (o lo quita) por el alumno.
  void darPista() {
    HapticFeedback.selectionClick();
    final fases = solucionesTaller[reto.titulo];
    setState(() {
      pistasUsadas++;
      if (_completo) {
        _mensaje = '¡Ya lo lograste! Presiona “${_reto < widget.retos.length - 1 ? 'Siguiente reto' : 'Terminar'}”.';
        return;
      }
      if (fases == null) {
        final falta = [
          for (var i = 0; i < reto.condiciones.length; i++)
            if (!_logradas.contains(i)) reto.condiciones[i].texto
        ];
        _mensaje =
            '💡 Pista: lee el objetivo “${falta.isEmpty ? reto.instruccion : falta.first}” y sigue el camino de la corriente: del + de la pila, por los componentes, hasta el −.';
        return;
      }
      final fase = fases[math.min(_logradas.length, fases.length - 1)];
      // ¿Sobra un cable? (que no esté en la solución de esta fase)
      final sobra = cables.indexWhere((c) => !c.fijo && !fase.any((f) => c.une(f.$1, f.$2)));
      if (sobra != -1) {
        if (cableSobrante == sobra) {
          cables.removeAt(sobra);
          cableSobrante = null;
          _mensaje = '🧹 Quité ese cable por ti. Pide otra 💡 Pista si la necesitas.';
          _resolver();
        } else {
          pista = null;
          cableSobrante = sobra;
          _mensaje = '💡 Pista: el cable que parpadea en rojo no va ahí. Tócalo para quitarlo (o toca 💡 otra vez y lo quito yo).';
        }
        return;
      }
      cableSobrante = null;
      final falta = fase.where((f) => !_hay(f.$1, f.$2)).firstOrNull;
      if (falta != null) {
        if (pista == falta) {
          cables.add(Cable(falta.$1, falta.$2, color: _colorPara(falta.$1, falta.$2)));
          pista = null;
          final quedan = fase.where((f) => !_hay(f.$1, f.$2)).length;
          _mensaje = quedan == 0
              ? '🔌 ¡Conecté el último cable! Ahora presiona “Iniciar simulación” ▶ para ver si funciona.'
              : '🔌 Conecté ese cable por ti. Faltan $quedan. Intenta el siguiente tú solo, o pide otra 💡 Pista.';
          _resolver();
        } else {
          pista = falta;
          _mensaje =
              '💡 Une ${nombreTerminal(piezas, falta.$1)} con ${nombreTerminal(piezas, falta.$2)}. ¡Brillan en amarillo! ✨ (Toca 💡 otra vez y lo conecto yo.)';
        }
        return;
      }
      pista = null;
      if (!corriendo) {
        _mensaje = '✅ ¡Todos los cables están bien! Presiona “Iniciar simulación” ▶ para probar tu circuito.';
        return;
      }
      final pendiente = [
        for (var i = 0; i < reto.condiciones.length; i++)
          if (!_logradas.contains(i)) reto.condiciones[i].texto
      ].firstOrNull;
      final acciones = <String>[
        if (piezas.any((p) => p.tipo == TipoPieza.interruptor)) 'toca el interruptor para encenderlo o apagarlo',
        if (piezas.any((p) => p.tipo == TipoPieza.boton)) 'mantén presionado el botón',
        if (piezas.any((p) => p.tipo == TipoPieza.ldr)) 'mueve el control de luz ☀️/🌙',
        if (piezas.any((p) => p.tipo == TipoPieza.potenciometro)) 'gira la perilla 🎛️',
        if (piezas.any((p) => p.editable)) 'toca un componente y cambia su valor en el Inspector',
      ];
      _mensaje = '💡 Pista: los cables ya están bien. Falta: “${pendiente ?? reto.logro}”.${acciones.isEmpty ? '' : ' Prueba: ${acciones.join(', o ')}.'}';
    });
  }

  Pieza _pieza(String id) => piezas.firstWhere((p) => p.id == id);

  Color _colorPara(String a, String b) {
    for (final t in [a, b]) {
      final p = _pieza(t.split('.').first);
      if (p.tipo == TipoPieza.pila9v || p.tipo == TipoPieza.pila3v) {
        return t.endsWith('.0') ? const Color(0xFFD32F2F) : const Color(0xFF212121);
      }
    }
    return _coloresCable[cables.length % _coloresCable.length];
  }

  // --- Simulación ------------------------------------------------------------

  void _alternarSimulacion() {
    HapticFeedback.lightImpact();
    setState(() {
      corriendo = !corriendo;
      for (final p in piezas) {
        p.quemado = false;
        if (!corriendo) p.presionado = false;
      }
      if (corriendo) {
        _resolver();
      } else {
        _estado = null;
        if (!_completo) _mensaje = 'Simulación detenida. Revisa tus conexiones y vuelve a intentarlo.';
      }
    });
  }

  void _resolver() {
    if (!corriendo) return;
    final r = resolverCircuito(piezas, cables, luz: luz);
    final e = EstadoCircuito({for (final p in piezas) p.id: p}, cables, r, luz: luz);
    _estado = e;
    if (r.quemadosAhora.isNotEmpty) {
      HapticFeedback.heavyImpact();
      if (reto.quemarEsError) _errores++;
      _mensaje = '¡Pum! 💥 El LED se quemó: pasó demasiada corriente. Detén la simulación y usa una resistencia para protegerlo.';
    } else if (r.cortocircuito) {
      if (reto.quemarEsError) _errores++;
      _mensaje = '⚠️ ¡Cortocircuito! La corriente va directo de + a − sin pasar por nada. La pila se calienta: detén la simulación y quita ese cable.';
    }
    var nueva = false;
    for (var i = 0; i < reto.condiciones.length; i++) {
      if (!_logradas.contains(i) && reto.condiciones[i].cumple(e)) {
        _logradas.add(i);
        nueva = true;
      }
    }
    if (nueva && !_completo) {
      HapticFeedback.mediumImpact();
      if (_logradas.length == reto.condiciones.length) {
        _completo = true;
        _mensaje = '¡Lo lograste! 🎉 ${reto.logro}';
      } else {
        _mensaje = '¡Bien! ✅ ${reto.condiciones[_logradas.last].texto}. Sigue con lo que falta.';
      }
    } else if (r.quemadosAhora.isEmpty && !r.cortocircuito && !_completo && _logradas.isEmpty) {
      _mensaje = _pistaSinLogro(e);
    }
  }

  String _pistaSinLogro(EstadoCircuito e) {
    if (piezas.any((p) => p.quemado)) {
      return 'Hay un LED quemado 💥. Detén la simulación (así se repara), agrega una resistencia y vuelve a intentarlo.';
    }
    if (e.cortocircuito) return _mensaje;
    for (final p in piezas) {
      if (p.tipo == TipoPieza.led && e.invertido(p.id)) {
        return 'El LED no enciende porque está al revés: la corriente debe entrar por el ánodo (pata doblada, +).';
      }
    }
    final hayCorriente = e.r.corrientePilas.values.any((i) => i.abs() > 0.0005);
    if (!hayCorriente) return 'No pasa corriente: el circuito está abierto. Revisa que el camino vaya del + de la pila, por los componentes, hasta el −.';
    return 'La corriente ya circula. Observa el circuito y revisa los objetivos.';
  }

  // --- Toques -----------------------------------------------------------------

  String? _terminalEn(Offset q) {
    String? mejor;
    var d = 20.0;
    for (final p in piezas) {
      final ts = p.terminales;
      for (var k = 0; k < ts.length; k++) {
        final dd = (ts[k] - q).distance;
        if (dd < d) {
          d = dd;
          mejor = p.terminal(k);
        }
      }
    }
    return mejor;
  }

  Offset terminalPos(String t) {
    final parts = t.split('.');
    return _pieza(parts[0]).terminales[int.parse(parts[1])];
  }

  int? _cableEn(Offset q) {
    for (var i = cables.length - 1; i >= 0; i--) {
      final pts = puntosCable(terminalPos(cables[i].a), terminalPos(cables[i].b));
      for (final p in pts) {
        if ((p - q).distance < 9) return i;
      }
    }
    return null;
  }

  Pieza? _piezaEn(Offset q) {
    for (final p in piezas.reversed) {
      if (p.cuerpo.contains(q)) return p;
    }
    return null;
  }

  void _abajoEn(Offset q) {
    _abajo = q;
    final p = _piezaEn(q);
    if (corriendo && p != null && p.tipo == TipoPieza.boton && _terminalEn(q) == null) {
      setState(() {
        p.presionado = true;
        _botonApretado = p.id;
        _piezaSel = p.id;
        _resolver();
      });
    }
  }

  void _arribaEn(Offset q) {
    if (_botonApretado != null) {
      setState(() {
        _pieza(_botonApretado!).presionado = false;
        _botonApretado = null;
        _resolver();
      });
      return;
    }
    if (_abajo != null && (q - _abajo!).distance < 14) _tocar(q);
    _abajo = null;
  }

  void _tocar(Offset q) {
    final t = _terminalEn(q);
    if (t != null) {
      HapticFeedback.selectionClick();
      setState(() {
        if (_terminalSel == null) {
          _terminalSel = t;
          _mensaje = 'Terminal elegida. Ahora toca otra terminal para unirlas con un cable.';
        } else if (_terminalSel == t) {
          _terminalSel = null;
        } else {
          final a = _terminalSel!;
          _terminalSel = null;
          if (!cables.any((c) => c.une(a, t))) {
            cables.add(Cable(a, t, color: _colorPara(a, t)));
            if (pista != null && _hay(pista!.$1, pista!.$2)) pista = null;
            cableSobrante = null;
            if (!_completo) _mensaje = corriendo ? 'Cable conectado.' : 'Cable conectado. Cuando termines, presiona “Iniciar simulación”.';
            _resolver();
          }
        }
      });
      return;
    }
    final c = _cableEn(q);
    if (c != null) {
      setState(() {
        if (cables[c].fijo) {
          _mensaje = 'Ese cable ya venía puesto en el proyecto.';
        } else {
          cables.removeAt(c);
          cableSobrante = null;
          _mensaje = 'Quitaste un cable.';
          _resolver();
        }
      });
      return;
    }
    final p = _piezaEn(q);
    setState(() {
      _terminalSel = null;
      _piezaSel = p?.id;
      if (p != null && p.tipo == TipoPieza.interruptor) {
        p.cerrado = !p.cerrado;
        HapticFeedback.lightImpact();
        _resolver();
      }
    });
  }

  void _quitarCables() => setState(() {
        cables.removeWhere((c) => !c.fijo);
        cableSobrante = null;
        _terminalSel = null;
        _resolver();
      });

  void _siguiente() {
    if (_reto < widget.retos.length - 1) {
      setState(() {
        _reto++;
        _iniciarReto();
      });
    } else {
      terminarPaso(context,
          actividad: widget.actividad, estrellas: estrellasPorErrores(_errores, dos: 1), titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal);
    }
  }

  // --- Interfaz ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final tieneLdr = piezas.any((p) => p.tipo == TipoPieza.ldr);
    final pots = [
      for (final p in piezas)
        if (p.tipo == TipoPieza.potenciometro) p
    ];
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle(widget.seccion, widget.retos.length > 1 ? '${widget.titulo} · Reto ${_reto + 1} de ${widget.retos.length}' : widget.titulo, widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 128, child: GloboZatiEle(_mensaje)),
        Positioned(left: 8, top: 194, width: 230, height: 140, child: _objetivos()),
        Positioned(left: 8, top: 340, width: 230, height: 134, child: _inspector()),
        Positioned(
          left: _origenArea.dx,
          top: _origenArea.dy,
          width: anchoArea,
          height: altoArea,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Listener(
              key: const ValueKey('area_taller'),
              behavior: HitTestBehavior.opaque,
              onPointerDown: (e) => _abajoEn(e.localPosition),
              onPointerUp: (e) => _arribaEn(e.localPosition),
              onPointerCancel: (_) => _arribaEn(_abajo ?? Offset.zero),
              child: Reloj(
                builder: (_, t) => CustomPaint(
                  size: const Size(anchoArea, altoArea),
                  painter: _PintorTaller(this, t),
                ),
              ),
            ),
          ),
        ),
        if (tieneLdr || pots.isNotEmpty)
          Positioned(
            left: _origenArea.dx + anchoArea - 196,
            top: _origenArea.dy + 6,
            width: 190,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(12), border: Border.all(color: widget.color, width: 2)),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                if (tieneLdr)
                  _deslizador(
                      luz < 0.35 ? '🌙' : '☀️',
                      'Luz del ambiente',
                      luz,
                      (v) => setState(() {
                            luz = v;
                            _resolver();
                          })),
                for (final p in pots)
                  _deslizador(
                      '🎛️',
                      'Perilla del potenciómetro',
                      p.posicion,
                      (v) => setState(() {
                            p.posicion = v;
                            _resolver();
                          })),
              ]),
            ),
          ),
        Positioned(
          left: 244,
          top: 418,
          child: Tooltip(
            message: corriendo ? 'Detener simulación' : 'Iniciar simulación',
            child: BotonJuego(
              texto: corriendo ? 'Detener simulación' : 'Iniciar simulación',
              icono: corriendo ? Icons.stop_rounded : Icons.play_arrow_rounded,
              color: corriendo ? const Color(0xFFE53935) : const Color(0xFF2DB84C),
              onTap: _alternarSimulacion,
            ),
          ),
        ),
        Positioned(
          left: 470,
          top: 418,
          child: Tooltip(
            message: 'Quitar cables',
            child: BotonJuego(texto: 'Quitar cables', icono: Icons.delete_sweep_rounded, color: const Color(0xFF78909C), onTap: _quitarCables),
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
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(texto: _reto < widget.retos.length - 1 ? 'Siguiente reto' : 'Terminar', onTap: _siguiente),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _deslizador(String emoji, String texto, double v, ValueChanged<double> cambio) => Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        Expanded(
          child: Tooltip(
            message: texto,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(trackHeight: 5, overlayShape: SliderComponentShape.noOverlay),
              child: Slider(value: v, onChanged: cambio, activeColor: widget.color),
            ),
          ),
        ),
      ]);

  Widget _objetivos() => PanelEle(
        titulo: 'Objetivos',
        icono: Icons.flag_rounded,
        color: widget.color,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < reto.condiciones.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(_logradas.contains(i) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        size: 18, color: _logradas.contains(i) ? ColoresJuego.correcto : Colors.black38),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(reto.condiciones[i].texto,
                          style: TextStyle(
                              fontSize: 12.5,
                              height: 1.15,
                              fontWeight: FontWeight.w600,
                              color: _logradas.contains(i) ? ColoresJuego.correcto : ColoresJuego.texto)),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      );

  Widget _inspector() {
    final p = _piezaSel == null ? null : piezas.where((x) => x.id == _piezaSel).firstOrNull;
    if (p == null) {
      return PanelEle(
        titulo: 'Inspector',
        icono: Icons.search_rounded,
        color: const Color(0xFF546E7A),
        child: const Text(
            'Toca un componente para ver qué es y para qué sirve.\n\nToca una terminal ■ y luego otra para poner un cable. Toca un cable para quitarlo.',
            style: TextStyle(fontSize: 12, height: 1.2)),
      );
    }
    final e = _estado;
    return PanelEle(
      titulo: p.tipo.nombre,
      icono: Icons.memory_rounded,
      color: const Color(0xFF546E7A),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.tipo.descripcion, style: const TextStyle(fontSize: 11.5, height: 1.15)),
          if (p.tipo == TipoPieza.resistencia) ...[
            const SizedBox(height: 3),
            Text('${textoOhms(p.ohms)} · ${bandasDe(p.ohms).map((b) => nombresColorBanda[b]).join('-')}',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
            if (p.editable)
              Wrap(spacing: 4, runSpacing: 4, children: [
                for (final o in const [100.0, 220.0, 1000.0, 10000.0])
                  ChipEle(
                      texto: textoOhms(o),
                      activo: p.ohms == o,
                      onTap: () => setState(() {
                            p.ohms = o;
                            _resolver();
                          })),
              ]),
          ],
          if (p.tipo == TipoPieza.led && p.editable)
            Wrap(spacing: 4, runSpacing: 4, children: [
              for (final c in ColorLed.values)
                ChipEle(
                    texto: c.nombre,
                    punto: c.color,
                    activo: p.colorLed == c,
                    onTap: () => setState(() {
                          p.colorLed = c;
                          _resolver();
                        })),
            ]),
          if (e != null && corriendo) ...[
            const SizedBox(height: 4),
            Text('🔌 Multímetro: ${e.voltaje(p.id).abs().toStringAsFixed(1)} V · ${(e.corriente(p.id).abs() * 1000).toStringAsFixed(1)} mA',
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF1565C0))),
          ],
        ]),
      ),
    );
  }

  // Para pruebas y para otras pantallas.
  bool get completo => _completo;
  int get reto0 => _reto;
  int get errores => _errores;
}

/// Puntos de la curva de un cable (cuelga un poquito, como en Tinkercad).
List<Offset> puntosCable(Offset a, Offset b, {int n = 24}) {
  final medio = Offset.lerp(a, b, 0.5)! + Offset(0, 12 + (b - a).distance * 0.08);
  return [
    for (var i = 0; i <= n; i++)
      () {
        final u = i / n;
        return a * ((1 - u) * (1 - u)) + medio * (2 * u * (1 - u)) + b * (u * u);
      }(),
  ];
}

class _PintorTaller extends CustomPainter {
  _PintorTaller(this.s, this.t);
  final TallerCircuitosState s;
  final double t;

  @override
  void paint(Canvas c, Size size) {
    // Plano de trabajo
    c.drawRect(Offset.zero & size, relleno(const Color(0xFFF7FBFF)));
    final g = linea(const Color(0xFFDCE8F5), 1);
    for (var x = 0.0; x < size.width; x += 20) {
      c.drawLine(Offset(x, 0), Offset(x, size.height), g);
    }
    for (var y = 0.0; y < size.height; y += 20) {
      c.drawLine(Offset(0, y), Offset(size.width, y), g);
    }
    c.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(14)), linea(const Color(0xFF90A4AE), 3));

    final e = s._estado;
    // Piezas
    for (final p in s.piezas) {
      dibujarPieza(
        c,
        p,
        t: t,
        brillo: e == null ? 0 : e.brillo(p.id),
        giro: e == null ? 0 : t * 14 * e.velocidad(p.id),
        suena: e != null && p.tipo == TipoPieza.zumbador && e.suena(p.id),
        luzFoco: e == null ? 0 : e.luzFoco(p.id),
        luz: s.luz,
        seleccionada: s._piezaSel == p.id,
      );
      if (p.tipo == TipoPieza.resistencia) {
        textoEn(c, textoOhms(p.ohms), p.pos + Offset(0, -16 * p.escala), tam: 12, color: const Color(0xFF5D4037));
      }
    }
    // Cables
    for (var i = 0; i < s.cables.length; i++) {
      final cab = s.cables[i];
      final pts = puntosCable(s.terminalPos(cab.a), s.terminalPos(cab.b));
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final q in pts.skip(1)) {
        path.lineTo(q.dx, q.dy);
      }
      c.drawPath(path, linea(oscurecer(cab.color, 0.45), 6)..strokeCap = StrokeCap.round);
      c.drawPath(path, linea(cab.color, 3.8)..strokeCap = StrokeCap.round);
      if (e != null && i < e.r.corrienteCables.length) {
        final corr = e.r.corrienteCables[i];
        if (corr.abs() > 0.0008) {
          final vel = 0.25 + 0.9 * (corr.abs() / 0.03).clamp(0, 1);
          for (var k = 0; k < 4; k++) {
            var u = (t * vel + k / 4) % 1;
            if (corr < 0) u = 1 - u;
            final pos = pts[(u * (pts.length - 1)).floor()];
            c.drawCircle(pos, 3, relleno(const Color(0xFFFFEB3B)));
            c.drawCircle(pos, 3, linea(const Color(0xFFF57F17), 1));
          }
        }
      }
    }
    // Cable que sobra (parpadea en rojo)
    final sobra = s.cableSobrante;
    if (sobra != null && sobra < s.cables.length) {
      final pts = puntosCable(s.terminalPos(s.cables[sobra].a), s.terminalPos(s.cables[sobra].b));
      final path = Path()..moveTo(pts.first.dx, pts.first.dy);
      for (final q in pts.skip(1)) {
        path.lineTo(q.dx, q.dy);
      }
      c.drawPath(path, linea(Color.fromRGBO(229, 57, 53, 0.35 + 0.35 * math.sin(t * 8)), 12)..strokeCap = StrokeCap.round);
    }
    // Pista: las dos terminales brillan y una línea punteada las une
    final pista = s.pista;
    if (pista != null) {
      final a = s.terminalPos(pista.$1), b = s.terminalPos(pista.$2);
      final pulso = 13 + 3 * math.sin(t * 6);
      for (final q in [a, b]) {
        c.drawCircle(q, pulso + 4, relleno(const Color(0x55FFEB3B)));
        c.drawCircle(q, pulso, linea(const Color(0xFFFFA000), 3));
      }
      final pts = puntosCable(a, b);
      for (var k = 0; k < pts.length - 1; k += 2) {
        c.drawLine(pts[k], pts[k + 1], linea(const Color(0xFFFFA000), 3)..strokeCap = StrokeCap.round);
      }
    }
    // Terminales
    for (final p in s.piezas) {
      final ts = p.terminales;
      for (var k = 0; k < ts.length; k++) {
        final id = p.terminal(k);
        final sel = s._terminalSel == id;
        final conectada = s.cables.any((cb) => cb.a == id || cb.b == id);
        if (sel) {
          c.drawCircle(ts[k], 11 + 2 * math.sin(t * 8), relleno(const Color(0x66FFA000)));
        } else if (s._terminalSel != null) {
          c.drawCircle(ts[k], 8, relleno(const Color(0x3343A047)));
        }
        final r = Rect.fromCenter(center: ts[k], width: 10, height: 10);
        c.drawRect(r, relleno(sel ? const Color(0xFFFFA000) : (conectada ? const Color(0xFF424242) : const Color(0xFF263238))));
        c.drawRect(r, linea(Colors.white, 1.2));
        // Signos + y − para saber de qué lado va cada cable
        final signo = switch (p.tipo) {
          TipoPieza.pila9v || TipoPieza.pila3v || TipoPieza.led || TipoPieza.zumbador => k == 0 ? '+' : '−',
          _ => null,
        };
        if (signo != null) {
          final fuera = ts[k] - p.pos;
          final dir = fuera.distance < 1 ? const Offset(0, -1) : fuera / fuera.distance;
          textoEn(c, signo, ts[k] + dir * 13 + const Offset(0, -1),
              tam: 13, color: Colors.white, fondo: signo == '+' ? const Color(0xFFD32F2F) : const Color(0xFF263238));
        }
      }
    }
    if (s.corriendo) {
      textoEn(c, '● Simulando', const Offset(56, 14), tam: 11, color: Colors.white, fondo: const Color(0xFF2DB84C));
    }
  }

  @override
  bool shouldRepaint(_PintorTaller old) => true;
}
