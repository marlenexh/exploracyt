import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/models.dart';
import '../main.dart' show store;
import 'game_widgets.dart';

/// Misión jugable: llamada → pista → laboratorio → reto → recompensa.
/// Hoy solo "¡Que vuelva la luz!" está implementada; las demás se marcan pendientes.
class PantallaMision extends StatefulWidget {
  final Mundo m;
  final Mision x;
  const PantallaMision(this.m, this.x, {super.key});
  @override
  State<PantallaMision> createState() => _PMState();
}

class _PMState extends State<PantallaMision> {
  int _p = 0;
  void _sig() => setState(() => _p++);

  @override
  Widget build(BuildContext context) {
    if (!widget.x.implementada) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.x.titulo)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Zati(size: 100),
              const SizedBox(height: 16),
              const Text('Esta misión aún no está lista.\nSu laboratorio llegará en una próxima fase.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
              const SizedBox(height: 8),
              const Text('Contenido curricular: pendiente de validación', style: TextStyle(fontSize: 16)),
            ]),
          ),
        ),
      );
    }
    final pasos = [_llamada(), _pista(), CircuitLab(onDone: _sig), Quiz(onDone: _sig), Recompensa_(widget.m, widget.x)];
    return Scaffold(
      body: Container(
        decoration: _fondo,
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                IconButton(tooltip: 'Salir de la misión', iconSize: 30, onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: (_p + 1) / pasos.length, minHeight: 14, color: C.verde, backgroundColor: Colors.white24))),
                const SizedBox(width: 12),
              ]),
            ),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: KeyedSubtree(key: ValueKey(_p), child: pasos[_p]))),
          ]),
        ),
      ),
    );
  }

  static const _fondo = BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF3B2A12), C.noche]));

  Widget _llamada() => _centro([
        const Zati(size: 150),
        const SizedBox(height: 20),
        const Text('¡Que vuelva la luz!', style: TextStyle(fontSize: 32, fontFamily: 'LilitaOne'), textAlign: TextAlign.center),
        const SizedBox(height: 10),
        const Text('Zati se quedó sin luz en su cabaña. Conecta la pila, el cable y el foco para salvarlo.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GameButton('Iniciar misión', color: C.sol, textColor: C.tinta, onTap: _sig),
      ]);

  Widget _pista() => _centro([
        const Text('Descubre la pista', style: TextStyle(fontSize: 28, fontFamily: 'LilitaOne')),
        const SizedBox(height: 16),
        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.battery_full, size: 48, color: C.sol),
          Icon(Icons.arrow_right_alt, size: 40),
          Icon(Icons.cable, size: 48, color: C.cielo),
          Icon(Icons.arrow_right_alt, size: 40),
          Icon(Icons.lightbulb, size: 48, color: C.sol),
        ]),
        const SizedBox(height: 16),
        const Text('La corriente solo viaja si el camino está cerrado. Si algo se corta, el foco se apaga.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Ejemplo: el interruptor de tu casa abre o cierra ese camino.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        GameButton('Ir al laboratorio', icon: Icons.science, onTap: _sig),
      ]);
}

Widget _centro(List<Widget> h) => Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 520), child: Column(mainAxisSize: MainAxisSize.min, children: h))));

Widget _pieza(IconData i, String t) => Container(
      width: 96,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: C.panel, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white54, width: 2)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(i, size: 40, color: Colors.white), Text(t, style: const TextStyle(fontWeight: FontWeight.w800))]),
    );

/// Laboratorio real: arrastra las piezas a su lugar; al cerrar el circuito el foco se enciende.
class CircuitLab extends StatefulWidget {
  final VoidCallback onDone;
  const CircuitLab({super.key, required this.onDone});
  @override
  State<CircuitLab> createState() => _CLState();
}

class _CLState extends State<CircuitLab> {
  static const _def = [('pila', Icons.battery_full, 'Pila', 'Pista: busca la pieza que guarda la energía.'), ('cable', Icons.cable, 'Cable', 'Pista: necesitas algo que lleve la corriente.'), ('foco', Icons.lightbulb, 'Foco', 'Pista: ¿qué pieza produce luz?')];
  final Set<String> _ok = {};
  String _msg = 'Arrastra cada pieza a su lugar.';
  ZatiEstado _z = ZatiEstado.normal;
  int _n = 0;
  bool get _listo => _ok.length == 3;

  @override
  Widget build(BuildContext context) => _centro([
        const Text('Laboratorio: ¡Conecta el circuito!', style: TextStyle(fontSize: 26, fontFamily: 'LilitaOne'), textAlign: TextAlign.center),
        Zati(size: 80, estado: _z, disparo: _n),
        const SizedBox(height: 8),
        Semantics(
          label: _listo ? 'Foco encendido' : 'Foco apagado',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(shape: BoxShape.circle, color: _listo ? C.sol : Colors.white12, boxShadow: _listo ? [const BoxShadow(color: C.sol, blurRadius: 40, spreadRadius: 8)] : []),
            child: Icon(Icons.lightbulb, size: 64, color: _listo ? Colors.white : Colors.white38),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(spacing: 10, runSpacing: 10, alignment: WrapAlignment.center, children: [
          for (final d in _def)
            DragTarget<String>(
              onWillAcceptWithDetails: (_) => true,
              onAcceptWithDetails: (det) => setState(() {
                _n++;
                if (det.data == d.$1) {
                  _ok.add(d.$1);
                  _msg = _listo ? '¡Circuito cerrado! El foco se encendió.' : '¡Bien! Esa pieza va ahí.';
                  _z = ZatiEstado.celebrar;
                } else {
                  _msg = 'Esa pieza no va ahí. ${d.$4}';
                  _z = ZatiEstado.pensar;
                }
              }),
              builder: (_, __, ___) => Container(
                width: 104,
                height: 100,
                decoration: BoxDecoration(color: _ok.contains(d.$1) ? C.verde.withOpacity(.4) : Colors.white10, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white54, width: 2)),
                child: _ok.contains(d.$1) ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(d.$2, size: 36), Text('${d.$3} ✓', style: const TextStyle(fontWeight: FontWeight.w800))]) : Center(child: Text('Espacio ${_def.indexOf(d) + 1}', style: const TextStyle(fontSize: 16))),
              ),
            ),
        ]),
        const SizedBox(height: 16),
        Text(_msg, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        if (_listo)
          GameButton('Continuar', onTap: widget.onDone)
        else
          Wrap(spacing: 10, children: [
            for (final d in _def.reversed)
              if (!_ok.contains(d.$1))
                Draggable<String>(data: d.$1, feedback: Material(color: Colors.transparent, child: _pieza(d.$2, d.$3)), childWhenDragging: Opacity(opacity: .3, child: _pieza(d.$2, d.$3)), child: _pieza(d.$2, d.$3)),
          ]),
      ]);
}

/// Reto final: los errores dan pistas, no castigos.
class Quiz extends StatefulWidget {
  final VoidCallback onDone;
  const Quiz({super.key, required this.onDone});
  @override
  State<Quiz> createState() => _QState();
}

class _QState extends State<Quiz> {
  static const _ops = ['Madera', 'Metal', 'Plástico', 'Papel'];
  final Set<String> _mal = {};
  bool _bien = false;
  ZatiEstado _z = ZatiEstado.normal;
  int _n = 0;
  @override
  Widget build(BuildContext context) => _centro([
        Zati(size: 80, estado: _z, disparo: _n),
        const Text('Reto final', style: TextStyle(fontSize: 28, fontFamily: 'LilitaOne')),
        const SizedBox(height: 8),
        const Text('¡Gran trabajo! Ahora responde para activar el generador de la cabaña.', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        const Text('¿Qué material permite mejor el paso de la electricidad?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800), textAlign: TextAlign.center),
        const SizedBox(height: 12),
        for (final o in _ops)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(minimumSize: const Size(0, 58), alignment: Alignment.centerLeft, side: BorderSide(color: (_bien && o == 'Metal') ? C.verde : Colors.white54, width: 2)),
                onPressed: (_bien || _mal.contains(o)) ? null : () => setState(() {
                  _n++;
                  if (o == 'Metal') {
                    _bien = true;
                    _z = ZatiEstado.celebrar;
                  } else {
                    _mal.add(o);
                    _z = ZatiEstado.pensar;
                  }
                }),
                icon: Icon(_bien && o == 'Metal' ? Icons.check_circle : (_mal.contains(o) ? Icons.cancel : Icons.circle_outlined)),
                label: Text(o, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
        const SizedBox(height: 8),
        if (_mal.isNotEmpty && !_bien) const Text('Casi. Pista: piensa de qué están hechos por dentro los cables.', style: TextStyle(fontSize: 18, color: C.sol), textAlign: TextAlign.center),
        if (_bien) ...[
          const Text('¡Correcto! Los metales son buenos conductores.', style: TextStyle(fontSize: 18, color: C.verde, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          GameButton('Siguiente', onTap: widget.onDone),
        ],
      ]);
}

class Recompensa_ extends StatefulWidget {
  final Mundo m;
  final Mision x;
  const Recompensa_(this.m, this.x, {super.key});
  @override
  State<Recompensa_> createState() => _RState();
}

class _RState extends State<Recompensa_> {
  bool? _nueva;
  @override
  void initState() {
    super.initState();
    // Idempotente: repetir la misión no duplica la pieza ni quita progreso.
    store.completar(widget.x.id, recompensaId: widget.x.recompensa?.id).then((n) {
      if (mounted) setState(() => _nueva = n);
    });
  }

  @override
  Widget build(BuildContext context) => _centro([
        TweenAnimationBuilder<double>(tween: Tween(begin: 0, end: 1), duration: const Duration(milliseconds: 800), curve: Curves.elasticOut, builder: (_, v, child) => Transform.scale(scale: v, child: child), child: const Icon(Icons.stars, size: 120, color: C.sol)),
        const Text('¡Misión completada!', style: TextStyle(fontSize: 32, fontFamily: 'LilitaOne'), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Has iluminado la cabaña de Zati.', style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: C.panel, borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            const Icon(Icons.smart_toy, size: 44, color: C.cielo),
            const SizedBox(width: 12),
            Expanded(child: Text('Pieza del robot Zati: ${widget.x.recompensa?.nombre ?? ''}\n${_nueva == null ? '' : (_nueva! ? '¡Nueva pieza!' : 'Ya tenías esta pieza')}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
          ]),
        ),
        const SizedBox(height: 12),
        const Text('Aprendiste: un circuito cerrado deja pasar la corriente, y los metales la conducen bien.', style: TextStyle(fontSize: 17), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        GameButton('Volver al mapa', color: C.sol, textColor: C.tinta, onTap: () => Navigator.pop(context)),
      ]);
}
