import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';
import 'robot_ui.dart' show colorControl, colorEvento, colorMovimiento, colorAccion;

/// Laboratorio del programador: el alumno programa los eventos de su propio
/// videojuego (como en Scratch), lo prueba, encuentra sus errores y lo publica.

class _Escena {
  const _Escena(this.nombre, this.emoji, this.premio, this.peligro, this.cielo);
  final String nombre, emoji, premio, peligro;
  final List<Color> cielo;
}

const _escenas = [
  _Escena('espacio', '🌌', '⭐', '☄️', [Color(0xFF0B1240), Color(0xFF3A2A7A)]),
  _Escena('bosque', '🌳', '🍎', '🐝', [Color(0xFF8FD3FF), Color(0xFFB8E68A)]),
  _Escena('mar', '🌊', '🐚', '🦈', [Color(0xFF4FC3F7), Color(0xFF01579B)]),
];
const _personajes = ['🐱', '🤖', '🦊', '🐸'];

/// Opciones de cada bloque de evento. La primera es la que hace funcionar el juego.
class ConfigJuego {
  int personaje = 0, escena = 0;
  int izquierda = 2, derecha = 2; // 0 mover izq/der, 1 al revés, 2 nada
  int premio = 2, peligro = 2; // 0 correcto, 1 al revés, 2 nada
  int caer = 1; // 0 hacer caer objetos, 1 nada
  int meta = 3; // 0: 5, 1: 10, 2: 15, 3: nunca
  int perder = 1; // 0 terminar el juego, 1 nada
  int velocidad = 1; // 0 lenta, 1 normal, 2 rápida

  static const metas = [5, 10, 15];
  int? get puntosMeta => meta < 3 ? metas[meta] : null;
}

class EstudioVideojuegos extends StatefulWidget {
  const EstudioVideojuegos({super.key, required this.onTerminar, this.color = const Color(0xFF7C4DFF)});

  /// Se llama al publicar el juego, con las estrellas ganadas.
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<EstudioVideojuegos> createState() => EstudioVideojuegosState();
}

class _Obj {
  _Obj(this.x, this.y, this.premio);
  double x, y;
  final bool premio;
}

class EstudioVideojuegosState extends State<EstudioVideojuegos> with SingleTickerProviderStateMixin {
  final config = ConfigJuego();
  late final Ticker _ticker = createTicker(_tick);
  final _rnd = math.Random(5);
  final _foco = FocusNode();

  bool jugando = false;
  bool probado = false;
  bool ganado = false;
  int _pruebas = 0;
  String _mensaje = '¡Te damos la bienvenida al laboratorio de programación! Crea tu propio videojuego: elige personaje y escenario, y programa qué pasa con cada evento. Luego presiona “Probar juego”.';

  // Estado de la partida
  double _x = 304, _t = 0, _spawn = 0;
  Duration _ultimo = Duration.zero;
  int puntos = 0, vidas = 3;
  int _mov = 0;
  final _objs = <_Obj>[];
  bool _siguioSinVidas = false;

  static const ancho = 608.0, alto = 350.0;

  @override
  void dispose() {
    _ticker.dispose();
    _foco.dispose();
    super.dispose();
  }

  double get _vel => [0.7, 1.0, 1.4][config.velocidad];

  List<(String, bool)> get revision => [
        ('⬅️ mueve a la izquierda', config.izquierda == 0),
        ('➡️ mueve a la derecha', config.derecha == 0),
        ('${_escenas[config.escena].premio} suma puntos', config.premio == 0),
        ('${_escenas[config.escena].peligro} quita vidas', config.peligro == 0),
        ('Los objetos caen', config.caer == 0),
        ('Hay una forma de ganar', config.meta < 3),
        ('El juego termina al perder', config.perder == 0),
        ('Ganaste una partida', ganado),
      ];

  bool get listo => revision.every((r) => r.$2);

  void cambiar(VoidCallback f) {
    if (jugando) return;
    HapticFeedback.selectionClick();
    setState(f);
  }

  // --- Partida ---------------------------------------------------------------

  void jugar() {
    setState(() {
      jugando = true;
      _x = ancho / 2;
      _t = 0;
      _spawn = 0;
      puntos = 0;
      vidas = 3;
      _mov = 0;
      _objs.clear();
      _siguioSinVidas = false;
      _ultimo = Duration.zero;
      _pruebas++;
    });
    _ticker.start();
    _foco.requestFocus();
  }

  void _tick(Duration e) {
    final dt = ((e - _ultimo).inMicroseconds / 1e6).clamp(0.0, 0.05);
    _ultimo = e;
    avanzar(dt);
  }

  /// Avanza la partida [dt] segundos (también se usa en las pruebas).
  void avanzar(double dt) {
    if (!jugando) return;
    setState(() {
      _t += dt;
      final dir = _mov == 0
          ? 0
          : _accionMover(_mov < 0 ? config.izquierda : config.derecha, _mov < 0 ? -1 : 1);
      _x = (_x + dir * 260 * dt).clamp(24.0, ancho - 24);
      if (config.caer == 0) {
        _spawn -= dt;
        if (_spawn <= 0) {
          _spawn = 0.85 / _vel;
          _objs.add(_Obj(20 + _rnd.nextDouble() * (ancho - 40), -20, _rnd.nextDouble() < 0.7));
        }
      }
      for (final o in _objs) {
        o.y += 140 * _vel * dt;
      }
      final tocados = _objs.where((o) => (Offset(o.x, o.y) - Offset(_x, alto - 44)).distance < 36).toList();
      for (final o in tocados) {
        _objs.remove(o);
        _tocar(o.premio);
      }
      _objs.removeWhere((o) => o.y > alto + 20);
      if (_t > 75) detener('Se acabó el tiempo de prueba.');
    });
  }

  int _accionMover(int opcion, int lado) => switch (opcion) {
        0 => lado,
        1 => -lado,
        _ => 0,
      };

  /// Lo que pasa al tocar un objeto, según el programa del alumno.
  void tocar(bool premio) => setState(() => _tocar(premio));

  void _tocar(bool premio) {
    final op = premio ? config.premio : config.peligro;
    final efecto = switch (op) {
      0 => premio ? 1 : -1,
      1 => premio ? -1 : 1,
      _ => 0,
    };
    if (efecto > 0) {
      puntos++;
      HapticFeedback.selectionClick();
    } else if (efecto < 0) {
      vidas--;
      HapticFeedback.mediumImpact();
    }
    final meta = config.puntosMeta;
    if (meta != null && puntos >= meta) {
      ganado = true;
      _fin('¡GANASTE! 🏆 Llegaste a $meta puntos.');
    } else if (vidas <= 0) {
      if (config.perder == 0) {
        _fin('Fin del juego: te quedaste sin vidas. ¡Tu programa lo detectó bien! Vuelve a intentarlo.');
      } else {
        _siguioSinVidas = true;
      }
    }
  }

  void _fin(String texto) {
    _ticker.stop();
    jugando = false;
    probado = true;
    _mensaje = '$texto\n\n${_diagnostico()}';
  }

  void detener([String texto = 'Detuviste la prueba.']) {
    if (!jugando) return;
    setState(() => _fin(texto));
  }

  String _diagnostico() {
    final malos = revision.where((r) => !r.$2).map((r) => r.$1).toList();
    if (malos.isEmpty) return '¡Tu juego funciona perfecto! Presiona “Publicar juego”.';
    final pistas = <String>[];
    if (config.izquierda != 0 || config.derecha != 0) pistas.add('las flechas no mueven bien al personaje');
    if (config.caer != 0) pistas.add('no cae ningún objeto');
    if (config.premio != 0 || config.peligro != 0) pistas.add('los puntos o las vidas no cambian como deberían');
    if (config.meta == 3) pistas.add('no hay forma de ganar');
    if (_siguioSinVidas || config.perder != 0) pistas.add('el juego sigue aunque ya no tengas vidas');
    return pistas.isEmpty ? 'Revisa la lista del programador.' : '🐞 Bugs encontrados: ${pistas.join('; ')}. Corrige los bloques y prueba otra vez.';
  }

  int get estrellas => _pruebas <= 2 ? 3 : (_pruebas <= 4 ? 2 : 1);

  void publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡Juego publicado!',
        mensaje: 'Creaste, probaste y depuraste tu propio videojuego. ¡Ganaste la insignia “Desarrollador de Videojuegos”!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  // --- Interfaz --------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final esc = _escenas[config.escena];
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Laboratorio', 'Laboratorio del programador: crea tu videojuego', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 196, child: GloboZatiEle(_mensaje, tam: 12.5)),
        Positioned(
          left: 8,
          top: 262,
          width: 230,
          height: 210,
          child: PanelEle(
            titulo: 'Revisión del programador',
            icono: Icons.checklist_rounded,
            color: const Color(0xFF2E7D32),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (!probado) const Text('Prueba tu juego para revisar si tiene errores.', style: TextStyle(fontSize: 11.5, color: Colors.black54)),
                for (final (t, ok) in revision)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('${!probado ? '❔' : (ok ? '✅' : '❌')} $t', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
              ]),
            ),
          ),
        ),
        if (!jugando) ...[
          Positioned(left: 244, top: 60, width: 372, height: 352, child: _codigo(esc)),
          Positioned(
            left: 622,
            top: 60,
            width: 230,
            height: 352,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorJuego(esc, _personajes[config.personaje], 115, const [], t, null, null, vistaPrevia: true))),
            ),
          ),
          Positioned(
            left: 244,
            top: 420,
            child: Tooltip(message: 'Probar juego', child: BotonJuego(texto: 'Probar juego', icono: Icons.sports_esports_rounded, color: const Color(0xFF2DB84C), onTap: jugar)),
          ),
          if (listo)
            Positioned(left: 640, top: 420, child: BotonSiguiente(texto: 'Publicar juego', onTap: publicar)),
        ],
        if (jugando) ...[
          Positioned(
            left: 244,
            top: 60,
            width: ancho,
            height: alto,
            child: Focus(
              focusNode: _foco,
              autofocus: true,
              onKeyEvent: (_, k) {
                if (k.logicalKey == LogicalKeyboardKey.arrowLeft || k.logicalKey == LogicalKeyboardKey.arrowRight) {
                  final lado = k.logicalKey == LogicalKeyboardKey.arrowLeft ? -1 : 1;
                  if (k is KeyDownEvent || k is KeyRepeatEvent) _mov = lado;
                  if (k is KeyUpEvent && _mov == lado) _mov = 0;
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CustomPaint(painter: _PintorJuego(esc, _personajes[config.personaje], _x, _objs, _t, puntos, vidas, sinCaer: config.caer != 0 && _t > 4)),
              ),
            ),
          ),
          Positioned(left: 250, top: 418, child: _BotonFlecha(icono: Icons.arrow_back_rounded, etiqueta: 'Flecha izquierda', onCambio: (v) => _mov = v ? -1 : (_mov == -1 ? 0 : _mov))),
          Positioned(left: 330, top: 418, child: _BotonFlecha(icono: Icons.arrow_forward_rounded, etiqueta: 'Flecha derecha', onCambio: (v) => _mov = v ? 1 : (_mov == 1 ? 0 : _mov))),
          Positioned(left: 700, top: 420, child: Tooltip(message: 'Detener prueba', child: BotonJuego(texto: 'Detener', icono: Icons.stop_rounded, color: const Color(0xFFE53935), onTap: detener))),
        ],
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _codigo(_Escena esc) {
    final p = _personajes[config.personaje];
    Widget chip(String tooltip, String texto, Color c, VoidCallback onTap) => Tooltip(
          message: tooltip,
          child: GestureDetector(
            onTap: () => cambiar(onTap),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white, width: 1.4)),
              child: Text('$texto ▾', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        );
    Widget evento(String cuando, Widget accion) => Container(
          margin: const EdgeInsets.only(bottom: 6),
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 6),
          decoration: BoxDecoration(color: colorEvento, borderRadius: const BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(6))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(cuando, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF5D4037))),
            const SizedBox(height: 3),
            Padding(padding: const EdgeInsets.only(left: 10), child: accion),
          ]),
        );
    const mover = ['mover a la izquierda', 'mover a la derecha', 'no hacer nada'];
    const moverD = ['mover a la derecha', 'mover a la izquierda', 'no hacer nada'];
    const efectoP = ['sumar 1 punto', 'restar 1 vida', 'no hacer nada'];
    const efectoN = ['restar 1 vida', 'sumar 1 punto', 'no hacer nada'];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF9F9FB), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFB0BEC5), width: 2)),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(spacing: 6, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
            const Text('Diseño:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            chip('Cambiar personaje', 'personaje $p', const Color(0xFF9966FF), () => config.personaje = (config.personaje + 1) % _personajes.length),
            chip('Cambiar escenario', '${esc.emoji} ${esc.nombre}', const Color(0xFF9966FF), () => config.escena = (config.escena + 1) % _escenas.length),
          ]),
          const SizedBox(height: 6),
          evento(
              '🚩 al empezar, repetir siempre:',
              chip('Bloque al empezar', ['hacer caer ${esc.premio} y ${esc.peligro}', 'no hacer nada'][config.caer], colorControl,
                  () => config.caer = (config.caer + 1) % 2)),
          evento('⌨️ cuando presiono ⬅️', chip('Bloque flecha izquierda', mover[config.izquierda], colorMovimiento, () => config.izquierda = (config.izquierda + 1) % 3)),
          evento('⌨️ cuando presiono ➡️', chip('Bloque flecha derecha', moverD[config.derecha], colorMovimiento, () => config.derecha = (config.derecha + 1) % 3)),
          evento('💥 cuando $p toca ${esc.premio}', chip('Bloque premio', efectoP[config.premio], colorAccion, () => config.premio = (config.premio + 1) % 3)),
          evento('💥 cuando $p toca ${esc.peligro}', chip('Bloque peligro', efectoN[config.peligro], colorAccion, () => config.peligro = (config.peligro + 1) % 3)),
          evento(
              '🏆 si puntos =',
              Wrap(spacing: 4, children: [
                chip('Bloque meta', config.meta < 3 ? '${ConfigJuego.metas[config.meta]}' : 'nunca', colorControl, () => config.meta = (config.meta + 1) % 4),
                const Text('entonces ganar', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF5D4037))),
              ])),
          evento('💔 si vidas = 0', chip('Bloque perder', ['terminar el juego', 'no hacer nada'][config.perder], colorControl, () => config.perder = (config.perder + 1) % 2)),
          evento('⚙️ velocidad del juego', chip('Bloque velocidad', ['lenta', 'normal', 'rápida'][config.velocidad], colorControl, () => config.velocidad = (config.velocidad + 1) % 3)),
        ]),
      ),
    );
  }
}

class _BotonFlecha extends StatelessWidget {
  const _BotonFlecha({required this.icono, required this.etiqueta, required this.onCambio});
  final IconData icono;
  final String etiqueta;
  final ValueChanged<bool> onCambio;
  @override
  Widget build(BuildContext context) => Tooltip(
        message: etiqueta,
        child: Listener(
          onPointerDown: (_) => onCambio(true),
          onPointerUp: (_) => onCambio(false),
          onPointerCancel: (_) => onCambio(false),
          child: Container(
            width: 70,
            height: 54,
            decoration: BoxDecoration(color: colorMovimiento, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white, width: 3), boxShadow: const [BoxShadow(color: Color(0xFF2D5FB0), offset: Offset(0, 4))]),
            child: Icon(icono, color: Colors.white, size: 34),
          ),
        ),
      );
}

class _PintorJuego extends CustomPainter {
  _PintorJuego(this.esc, this.personaje, this.x, this.objs, this.t, this.puntos, this.vidas, {this.vistaPrevia = false, this.sinCaer = false});
  final _Escena esc;
  final String personaje;
  final double x, t;
  final List<_Obj> objs;
  final int? puntos, vidas;
  final bool vistaPrevia, sinCaer;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: esc.cielo).createShader(Offset.zero & s));
    switch (esc.nombre) {
      case 'espacio':
        for (var k = 0; k < 40; k++) {
          c.drawCircle(Offset((k * 97 % 600) / 600 * s.width, (k * 53 % 340) / 340 * s.height), 1.2, relleno(Colors.white.withValues(alpha: 0.4 + 0.4 * math.sin(t * 2 + k).abs())));
        }
        dibujarEmoji(c, '🪐', Offset(s.width * 0.82, s.height * 0.2), s.height * 0.16);
      case 'bosque':
        for (var k = 0; k < 5; k++) {
          dibujarEmoji(c, '🌲', Offset(s.width * (0.1 + k * 0.2), s.height * 0.72), s.height * 0.2);
        }
        dibujarEmoji(c, '☁️', Offset(s.width * (0.2 + 0.05 * math.sin(t * 0.5)), s.height * 0.15), s.height * 0.12);
      default:
        for (var k = 0; k < 8; k++) {
          final f = (t * 0.2 + k / 8) % 1;
          c.drawCircle(Offset(s.width * (k + 0.5) / 8, s.height * (1 - f)), 4, linea(Colors.white54, 1.5));
        }
    }
    c.drawRect(Rect.fromLTWH(0, s.height - 22, s.width, 22), relleno(const Color(0x66000000)));
    if (vistaPrevia) {
      dibujarEmoji(c, esc.premio, Offset(s.width * 0.3, s.height * 0.3 + 10 * math.sin(t * 2)), 34);
      dibujarEmoji(c, esc.peligro, Offset(s.width * 0.7, s.height * 0.42 + 10 * math.sin(t * 2 + 1)), 34);
      dibujarEmoji(c, personaje, Offset(s.width / 2, s.height - 44), 50);
      textoEn(c, 'Vista previa', Offset(s.width / 2, 16), tam: 13, color: Colors.white, fondo: const Color(0x88000000));
      return;
    }
    for (final o in objs) {
      dibujarEmoji(c, o.premio ? esc.premio : esc.peligro, Offset(o.x, o.y), 34);
    }
    dibujarEmoji(c, personaje, Offset(x, s.height - 44), 52);
    textoEn(c, '${esc.premio} Puntos: $puntos', const Offset(80, 18), tam: 15, color: Colors.white, fondo: const Color(0x99000000));
    textoEn(c, '❤️ Vidas: $vidas', Offset(s.width - 70, 18), tam: 15, color: Colors.white, fondo: (vidas ?? 1) <= 0 ? const Color(0xCCE53935) : const Color(0x99000000));
    if (sinCaer) textoEn(c, 'No cae nada… ¿programaste el bloque “al empezar”?', Offset(s.width / 2, s.height / 2), tam: 15, color: Colors.white, fondo: const Color(0xAA000000));
  }

  @override
  bool shouldRepaint(_PintorJuego old) => true;
}
