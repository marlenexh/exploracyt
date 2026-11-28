import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/ia_topics.dart';
import '../../data/laboratorios.dart';
import '../../data/pro_topics.dart';
import '../../data/worlds.dart';
import '../../main.dart' show store;
import '../biology/tema_bio_screen.dart' show temasBio;
import '../biology/temas/motor.dart' show TemaBio, Emoji;
import '../electronica/electronica_screen.dart' show temasEle;
import '../fisica/fisica_screen.dart' show temasFis;
import '../ia/ia_screen.dart' show temasIA;
import '../programacion/programacion_screen.dart' show temasPro;
import '../quimica/quimica_screen.dart' show temasQui;

/// Una insignia del juego, con el diseño con el que se gana.
class InsigniaVista {
  const InsigniaVista(this.id, this.nombre, this.emoji, this.mundo, {this.laboratorio = false});
  final String id, nombre, emoji, mundo;
  final bool laboratorio;
}

final _temasPorMundo = <String, Map<int, TemaBio>>{
  'bio': temasBio,
  'qui': temasQui,
  'fis': temasFis,
  'ele': temasEle,
  'ia': temasIA,
  'pro': temasPro,
};

/// Todas las insignias que se pueden ganar, mundo por mundo.
List<InsigniaVista> catalogoInsignias() {
  final res = <InsigniaVista>[];
  for (final m in mundos) {
    for (final t in m.temas) {
      final n = int.tryParse(t.id.split('-t').last) ?? 0;
      final emoji = _temasPorMundo[m.id]?[n]?.emojiInsignia ?? (m.id == 'bio' && n == 1 ? '🫀' : '🏅');
      for (final x in t.misiones) {
        final r = x.recompensa;
        if (r != null && !res.any((e) => e.id == r.id)) res.add(InsigniaVista(r.id, r.nombre, emoji, m.id));
      }
    }
    final lab = laboratoriosMundos[m.id];
    if (lab != null) res.add(InsigniaVista(lab.badgeId, lab.insignia, lab.emoji, m.id, laboratorio: true));
    if (m.id == 'ia') res.add(const InsigniaVista(iaLabBadgeId, iaLabBadge, '🤖', 'ia', laboratorio: true));
    if (m.id == 'pro') res.add(const InsigniaVista(proLabBadgeId, proLabBadge, '🎮', 'pro', laboratorio: true));
  }
  return res;
}

/// La medalla dorada con rayos, igual a la que aparece al ganar la insignia.
class MedallaInsignia extends StatefulWidget {
  const MedallaInsignia({super.key, required this.emoji, this.tam = 110, this.ganada = true, this.animada = true});
  final String emoji;
  final double tam;
  final bool ganada, animada;
  @override
  State<MedallaInsignia> createState() => _MedallaInsigniaState();
}

class _MedallaInsigniaState extends State<MedallaInsignia> with SingleTickerProviderStateMixin {
  late final AnimationController _giro = AnimationController(vsync: this, duration: const Duration(seconds: 12));

  @override
  void initState() {
    super.initState();
    if (widget.animada && widget.ganada) _giro.repeat();
  }

  @override
  void dispose() {
    _giro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tam;
    final medalla = Container(
      width: t * 0.68,
      height: t * 0.68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: widget.ganada
            ? const RadialGradient(colors: [Color(0xFFFFF59D), Color(0xFFFFC107), Color(0xFFF57F17)])
            : const RadialGradient(colors: [Color(0xFFECEFF1), Color(0xFFB0BEC5), Color(0xFF78909C)]),
        border: Border.all(color: Colors.white, width: t * 0.025),
        boxShadow: [BoxShadow(color: widget.ganada ? const Color(0xFFB8860B) : const Color(0xFF546E7A), offset: Offset(0, t * 0.025))],
      ),
      child: widget.ganada ? Emoji(widget.emoji, tam: t * 0.32) : Icon(Icons.lock_rounded, color: Colors.white, size: t * 0.28),
    );
    return SizedBox(
      width: t,
      height: t,
      child: Stack(alignment: Alignment.center, children: [
        if (widget.ganada)
          RotationTransition(
            turns: _giro,
            child: Container(
              width: t * 0.96,
              height: t * 0.96,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(colors: [Color(0xFFFFE082), Color(0xFFFFF3C4), Color(0xFFFFE082), Color(0xFFFFF3C4), Color(0xFFFFE082)]),
              ),
            ),
          ),
        medalla,
      ]),
    );
  }
}

/// “Mis insignias”: cada insignia con su medalla, como cuando se ganó.
class PantallaInsignias extends StatelessWidget {
  const PantallaInsignias({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF1B1446),
        body: SafeArea(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              final catalogo = catalogoInsignias();
              final ganadas = catalogo.where((i) => store.recompensas.contains(i.id)).length;
              return ListView(padding: const EdgeInsets.fromLTRB(12, 8, 12, 24), children: [
                Row(children: [
                  IconButton.filled(
                    tooltip: 'Volver',
                    style: IconButton.styleFrom(backgroundColor: const Color(0xFF3B2A6B)),
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('🏅 Mis insignias ($ganadas de ${catalogo.length})',
                        style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 26, color: Color(0xFFFFE082))),
                  ),
                ]),
                if (ganadas == 0)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Aún no tienes insignias. ¡Termina un tema o un laboratorio para ganar la primera!',
                        style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                for (final m in mundos) ...[
                  const SizedBox(height: 12),
                  Row(children: [
                    Icon(m.icono, color: m.color, size: 26),
                    const SizedBox(width: 6),
                    Text(m.nombre, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 21, color: m.color)),
                  ]),
                  const SizedBox(height: 6),
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    for (final i in catalogo.where((i) => i.mundo == m.id)) _Tarjeta(i, store.recompensas.contains(i.id), m.color),
                  ]),
                ],
              ]);
            },
          ),
        ),
      );
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta(this.i, this.ganada, this.color);
  final InsigniaVista i;
  final bool ganada;
  final Color color;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: ganada ? i.nombre : 'Insignia por ganar: ${i.nombre}',
        child: GestureDetector(
          onTap: ganada ? () => _ver(context) : null,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ganada ? Colors.white : Colors.white10,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: ganada ? const Color(0xFFFFC107) : Colors.white24, width: 3),
            ),
            child: Column(children: [
              MedallaInsignia(emoji: i.emoji, tam: 96, ganada: ganada, animada: false),
              const SizedBox(height: 4),
              Text(i.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: ganada ? const Color(0xFFE67E00) : Colors.white54)),
              Text(i.laboratorio ? '🔬 Laboratorio final' : '📚 Tema',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: ganada ? Colors.black54 : Colors.white38)),
            ]),
          ),
        ),
      );

  /// Muestra la insignia en grande, como el día que se ganó.
  void _ver(BuildContext context) => showDialog<void>(
        context: context,
        builder: (c) => Dialog(
          backgroundColor: Colors.transparent,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            MedallaInsignia(emoji: i.emoji, tam: math.min(240, MediaQuery.sizeOf(c).shortestSide * 0.5)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFC107), width: 4)),
              child: Column(children: [
                const Text('Ganaste la insignia', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text(i.nombre, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: Color(0xFFE67E00))),
              ]),
            ),
            const SizedBox(height: 10),
            FilledButton(onPressed: () => Navigator.pop(c), child: const Text('Cerrar')),
          ]),
        ),
      );
}
