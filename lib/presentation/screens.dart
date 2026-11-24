import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../data/models.dart';
import '../main.dart' show store;
import 'game_widgets.dart';
import 'mission_screen.dart';
import 'biology_lab_screen.dart';
import 'electronica/electronica_screen.dart';
import 'programacion/programacion_screen.dart';
import 'quimica/quimica_screen.dart';


class RutaMundo extends StatelessWidget {
  final Mundo m;
  const RutaMundo(this.m, {super.key});
  @override
  Widget build(BuildContext context) {
    if (m.id == 'bio') return BiologyLabScreen(mundo: m);
    if (m.id == 'ele') return ElectronicaScreen(mundo: m);
    if (m.id == 'pro') return ProgramacionScreen(mundo: m);
    if (m.id == 'qui') return QuimicaScreen(mundo: m);
    final fondo = Color.lerp(m.color, C.noche, .6)!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [fondo, C.noche])),
        child: SafeArea(
          child: ListenableBuilder(
            listenable: store,
            builder: (_, __) {
              final todas = [for (final t in m.temas) ...t.misiones];
              final sig = todas.where((x) => !store.completadas.contains(x.id)).firstOrNull;
              final hechos = m.temas.where((t) => t.misiones.every((x) => store.completadas.contains(x.id))).length;
              var k = 0;
              const xs = [0.0, -.5, 0.0, .5];
              return ListView(padding: const EdgeInsets.all(16), children: [
                Row(children: [
                  IconButton(tooltip: 'Volver al mapa', iconSize: 30, onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
                  Icon(m.icono, color: m.color, size: 34),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m.nombre, style: const TextStyle(fontSize: 26, fontFamily: 'LilitaOne'))),
                ]),
                Text(m.subtitulo, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: hechos / 5, minHeight: 14, color: C.sol, backgroundColor: Colors.white24)),
                const SizedBox(height: 4),
                Text('$hechos de 5 temas completados', style: const TextStyle(fontWeight: FontWeight.w700)),
                for (final t in m.temas) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: m.color, borderRadius: BorderRadius.circular(16)),
                    child: Text(t.titulo, style: const TextStyle(fontSize: 19, fontFamily: 'LilitaOne'), textAlign: TextAlign.center),
                  ),
                  for (final x in t.misiones)
                    Align(
                      alignment: Alignment(xs[k++ % 4], 0),
                      child: _Nodo(
                        icono: store.completadas.contains(x.id) ? Icons.star : Icons.play_arrow,
                        color: store.completadas.contains(x.id) ? C.sol : m.color,
                        actual: x == sig,
                        etiqueta: x.implementada ? x.titulo : '${x.titulo} (pendiente)',
                        onTap: () {
                          store.abrirMision(x.id);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PantallaMision(m, x)));
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment(xs[k++ % 4], 0),
                    child: _Nodo(
                      icono: Icons.local_fire_department,
                      color: Colors.redAccent,
                      etiqueta: 'Reto final (pendiente)',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El reto final de este tema aún no está listo.'))),
                    ),
                  ),
                ],
              ]);
            },
          ),
        ),
      ),
    );
  }
}

class _Nodo extends StatelessWidget {
  final IconData icono;
  final Color color;
  final bool actual;
  final String etiqueta;
  final VoidCallback onTap;
  const _Nodo({required this.icono, required this.color, this.actual = false, required this.etiqueta, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final circ = Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color, border: Border.all(color: Colors.white, width: 4), boxShadow: const [BoxShadow(color: Colors.black45, offset: Offset(0, 6))]),
      child: Icon(icono, size: 44, color: Colors.white),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Semantics(
        button: true,
        label: etiqueta,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 150,
            child: Column(children: [
              if (actual) Container(margin: const EdgeInsets.only(bottom: 6), padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: C.sol, borderRadius: BorderRadius.circular(12)), child: const Text('¡EMPIEZA!', style: TextStyle(color: C.tinta, fontFamily: 'LilitaOne'))),
              actual ? Pulse(child: circ) : circ,
              const SizedBox(height: 6),
              Text(etiqueta, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
          ),
        ),
      ),
    );
  }
}
