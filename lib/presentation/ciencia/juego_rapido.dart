import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../electronica/comun.dart';

/// Una opción del juego rápido.
class OpcionRapida {
  const OpcionRapida(this.emoji, this.texto, this.color);
  final String emoji, texto;
  final Color color;
}

/// Un objeto que entra a la máquina: cómo es antes, cómo queda después,
/// qué opción es la correcta y por qué.
class ObjetoRapido {
  const ObjetoRapido(this.antes, this.despues, this.nombre, this.correcta, this.porque);
  final String antes, despues, nombre, porque;
  final int correcta;
}

/// Juego contra reloj: los objetos entran uno por uno a una máquina y hay
/// que elegir la opción correcta antes de que se acabe el tiempo. Al acertar
/// el objeto se transforma; al fallar se explica y el objeto vuelve después.
class JuegoRapido extends StatefulWidget {
  const JuegoRapido({
    super.key,
    required this.actividad,
    required this.seccion,
    required this.titulo,
    required this.color,
    required this.instruccion,
    required this.opciones,
    required this.objetos,
    required this.mensajeFinal,
    this.segundos = 10,
  });
  final String actividad, seccion, titulo, instruccion, mensajeFinal;
  final Color color;
  final List<OpcionRapida> opciones;
  final List<ObjetoRapido> objetos;
  final int segundos;
  @override
  State<JuegoRapido> createState() => JuegoRapidoState();
}

class JuegoRapidoState extends State<JuegoRapido> {
  late final List<int> fila = [for (var i = 0; i < widget.objetos.length; i++) i];
  bool empezado = false, transformando = false;
  int puntos = 0, racha = 0, mejorRacha = 0, errores = 0;
  double tiempo = 1;
  String? aviso;
  bool? ultimoBien;
  Timer? _reloj, _pausa;

  bool get terminado => fila.isEmpty;
  ObjetoRapido? get actual => fila.isEmpty ? null : widget.objetos[fila.first];

  @override
  void dispose() {
    _reloj?.cancel();
    _pausa?.cancel();
    super.dispose();
  }

  void empezar() {
    setState(() => empezado = true);
    _iniciarReloj();
  }

  void _iniciarReloj() {
    _reloj?.cancel();
    tiempo = 1;
    _reloj = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        tiempo -= 0.1 / widget.segundos;
        if (tiempo <= 0) {
          t.cancel();
          _fallar('¡Se acabó el tiempo! ${actual!.porque}');
        }
      });
    });
  }

  /// El alumno elige la opción [k] para el objeto actual.
  void elegir(int k) {
    if (!empezado || terminado || transformando) return;
    final o = actual!;
    if (k == o.correcta) {
      _reloj?.cancel();
      HapticFeedback.lightImpact();
      setState(() {
        racha++;
        mejorRacha = math.max(mejorRacha, racha);
        puntos += 10 + (tiempo * 10).round() + (racha >= 3 ? 5 : 0);
        aviso = '¡Correcto! ${o.porque}';
        ultimoBien = true;
        transformando = true;
      });
      _pausa = Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        setState(() {
          transformando = false;
          fila.removeAt(0);
        });
        if (!terminado) _iniciarReloj();
      });
    } else {
      _reloj?.cancel();
      _fallar('¡Uy! ${o.porque}');
    }
  }

  void _fallar(String texto) {
    HapticFeedback.mediumImpact();
    setState(() {
      errores++;
      racha = 0;
      aviso = texto;
      ultimoBien = false;
      transformando = true;
    });
    _pausa = Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        transformando = false;
        fila.add(fila.removeAt(0));
      });
      _iniciarReloj();
    });
  }

  int get estrellas => errores == 0 ? 3 : (errores <= 2 ? 2 : 1);

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    final o = actual;
    final msg = terminado
        ? '¡Terminaste con $puntos puntos y una racha máxima de $mejorRacha! ${widget.mensajeFinal}'
        : !empezado
            ? widget.instruccion
            : aviso ?? 'Elige rápido: ¿qué opción le toca a “${o!.nombre}”?';
    return Escenario(
      velo: 0.1,
      colorVelo: c,
      children: [
        encabezadoEle(widget.seccion, widget.titulo, c),
        Positioned(left: 8, top: 60, width: 230, height: 230, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(
          left: 8,
          top: 296,
          width: 230,
          height: 176,
          child: PanelEle(
            titulo: 'Marcador',
            icono: Icons.emoji_events_rounded,
            color: c,
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text('⭐ $puntos puntos', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              Text('🔥 Racha: $racha${racha >= 3 ? '  ¡+5!' : ''}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              Text('📦 Faltan: ${fila.length} de ${widget.objetos.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
        // La máquina
        Positioned(
          left: 250,
          top: 60,
          width: 600,
          height: 260,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [aclarar(c, 0.85), aclarar(c, 0.6)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: oscurecer(c, 0.2), width: 4),
              boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 10, offset: Offset(0, 5))],
            ),
            child: Stack(alignment: Alignment.center, children: [
              // Banda transportadora
              Positioned(
                left: 20,
                right: 20,
                bottom: 40,
                height: 18,
                child: Reloj(
                  builder: (_, t) => CustomPaint(painter: _Banda(empezado && !terminado ? t : 0, oscurecer(c, 0.35))),
                ),
              ),
              // Engranes decorativos
              for (final (x, y, r, v) in const [(40.0, 40.0, 22.0, 1.0), (560.0, 40.0, 26.0, -0.8)])
                Positioned(
                  left: x - r,
                  top: y - r,
                  child: Reloj(
                    builder: (_, t) =>
                        Transform.rotate(angle: t * v, child: Icon(Icons.settings_rounded, size: r * 2, color: oscurecer(c, 0.25).withValues(alpha: 0.5))),
                  ),
                ),
              if (!empezado)
                Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(widget.objetos.take(4).map((e) => e.antes).join('  '), style: const TextStyle(fontSize: 46)),
                  const SizedBox(height: 14),
                  Tooltip(message: 'Empezar', child: BotonJuego(texto: '¡Empezar!', icono: Icons.play_arrow_rounded, color: c, onTap: empezar)),
                ])
              else if (terminado)
                Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🏆', style: TextStyle(fontSize: 70)),
                  Text('$puntos puntos', style: TextStyle(fontFamily: 'LilitaOne', fontSize: 30, color: oscurecer(c, 0.3))),
                ])
              else
                TweenAnimationBuilder<double>(
                  key: ValueKey('${fila.first}-${fila.length}-$errores'),
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutBack,
                  builder: (_, v, hijo) => Transform.translate(offset: Offset((1 - v) * -260, 0), child: hijo),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      transitionBuilder: (h, a) =>
                          ScaleTransition(scale: a, child: RotationTransition(turns: Tween(begin: 0.5, end: 1.0).animate(a), child: h)),
                      child: Text(
                        transformando && ultimoBien == true ? o!.despues : o!.antes,
                        key: ValueKey(transformando && ultimoBien == true),
                        style: const TextStyle(fontSize: 84),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: c, width: 2)),
                      child: Text(o.nombre, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                    ),
                  ]),
                ),
              if (transformando && ultimoBien != null)
                Positioned(top: 14, child: Text(ultimoBien! ? '✨ ¡Bien! ✨' : '❌', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900))),
              // Tiempo
              if (empezado && !terminado)
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 12,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: tiempo.clamp(0.0, 1.0),
                      minHeight: 12,
                      color: tiempo > 0.3 ? const Color(0xFF43A047) : const Color(0xFFE53935),
                      backgroundColor: Colors.white70,
                    ),
                  ),
                ),
            ]),
          ),
        ),
        // Botones de respuesta
        Positioned(
          left: 250,
          top: 330,
          width: 600,
          height: 82,
          child: Row(children: [
            for (var k = 0; k < widget.opciones.length; k++) ...[
              if (k > 0) const SizedBox(width: 10),
              Expanded(
                child: Tooltip(
                  message: 'Opción ${widget.opciones[k].texto}',
                  child: Rebote(
                    onTap: () => elegir(k),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: empezado && !terminado ? widget.opciones[k].color : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: oscurecer(widget.opciones[k].color, 0.4), offset: const Offset(0, 5))],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('${widget.opciones[k].emoji} ${widget.opciones[k].texto}',
                              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ]),
        ),
        if (terminado)
          Positioned(
            left: 690,
            top: 420,
            child: BotonSiguiente(
                onTap: () =>
                    terminarPaso(context, actividad: widget.actividad, estrellas: estrellas, titulo: '¡${widget.titulo}!', mensaje: widget.mensajeFinal)),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _Banda extends CustomPainter {
  _Banda(this.t, this.color);
  final double t;
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final r = RRect.fromRectAndRadius(Offset.zero & s, Radius.circular(s.height / 2));
    c.drawRRect(r, Paint()..color = color);
    final p = Paint()
      ..color = Colors.white38
      ..strokeWidth = 3;
    for (var x = -(t * 60) % 24; x < s.width; x += 24) {
      c.drawLine(Offset(x, 4), Offset(x + 8, s.height - 4), p);
    }
  }

  @override
  bool shouldRepaint(_Banda old) => old.t != t;
}
