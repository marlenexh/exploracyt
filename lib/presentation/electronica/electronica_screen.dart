import 'package:flutter/material.dart';

import '../../data/ele_topics.dart';
import '../../data/models.dart';
import '../../main.dart' show store;
import '../biology/tema_bio_screen.dart' show TemaJuegoScreen;
import '../biology/temas/motor.dart';
import 'ele_tema1.dart';
import 'ele_tema2.dart';
import 'ele_tema3.dart';
import 'ele_tema4.dart';
import 'ele_tema5.dart';
import 'fondos.dart';

/// Juegos de los temas de Electrónica, por número de tema.
final temasEle = <int, TemaBio>{1: eleTema1, 2: eleTema2, 3: eleTema3, 4: eleTema4, 5: eleTema5};

const _emojisTema = {1: '🔌', 2: '⚡', 3: '🕵️', 4: '⚙️', 5: '🤖'};

/// Mapa del mundo de Electrónica: "La ciudad de los circuitos".
class ElectronicaScreen extends StatelessWidget {
  const ElectronicaScreen({super.key, required this.mundo});
  final Mundo mundo;

  void _abrir(BuildContext context, int n) {
    final info = eleTopics[n]!;
    store.abrirMision(info.missionIds.first);
    Navigator.push(context, MaterialPageRoute(builder: (_) => TemaJuegoScreen(tema: temasEle[n]!, info: info)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B5D2E),
      body: Stack(
        children: [
          const Positioned.fill(child: FondoElectronica(FondoEle.placa)),
          SafeArea(
            child: ListenableBuilder(
              listenable: store,
              builder: (context, _) => LayoutBuilder(builder: (context, c) {
                final ancho = c.maxWidth >= 720;
                final tarjetas = [for (var n = 1; n <= 5; n++) _TarjetaTema(numero: n, ancho: ancho, onTap: () => _abrir(context, n))];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
                      child: Row(children: [
                        Tooltip(
                          message: 'Volver al mapa',
                          child: Material(
                            color: const Color(0xFF7C4DFF),
                            shape: const CircleBorder(side: BorderSide(color: Colors.white, width: 3)),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () => Navigator.pop(context),
                              child: const Padding(padding: EdgeInsets.all(10), child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text('⚡ ${mundo.nombre} · ${mundo.subtitulo}',
                                  style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 28, color: Colors.white, shadows: [Shadow(blurRadius: 6, offset: Offset(0, 2))])),
                            ),
                            const Text('Conoce cómo funcionan los aparatos electrónicos y cómo sus componentes trabajan juntos.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontFamily: 'Fredoka', fontSize: 15, color: Colors.white, shadows: [Shadow(blurRadius: 4)])),
                          ]),
                        ),
                      ]),
                    ),
                    Expanded(
                      child: ancho
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 12),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final t in tarjetas) Expanded(child: t)]),
                            )
                          : ListView(padding: const EdgeInsets.fromLTRB(12, 6, 12, 16), children: tarjetas),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaTema extends StatelessWidget {
  const _TarjetaTema({required this.numero, required this.ancho, required this.onTap});
  final int numero;
  final bool ancho;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tema = temasEle[numero]!;
    final info = eleTopics[numero]!;
    final hechas = info.missionIds.where(store.completadas.contains).length;
    final insignia = store.recompensas.contains(info.badgeId);
    final color = tema.color;
    final cuerpo = [
      Text(_emojisTema[numero]!, style: TextStyle(fontSize: ancho ? 46 : 40)),
      const SizedBox(height: 4, width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: ancho ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tema $numero', style: TextStyle(fontFamily: 'Fredoka', fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            Text(tema.titulo,
                textAlign: ancho ? TextAlign.center : TextAlign.start,
                style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 19, color: Color(0xFF263238), height: 1.05)),
            const SizedBox(height: 4),
            Text(eleContenidos[numero]!,
                textAlign: ancho ? TextAlign.center : TextAlign.start,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Fredoka', fontSize: 12.5, color: Color(0xFF455A64), height: 1.15)),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(value: hechas / 4, minHeight: 9, color: color, backgroundColor: color.withValues(alpha: 0.18)),
            ),
            const SizedBox(height: 3),
            Text(insignia ? '🏅 ${info.badge}' : 'Misiones: $hechas de 4',
                textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Fredoka', fontSize: 12, fontWeight: FontWeight.w700, color: insignia ? const Color(0xFFB8860B) : const Color(0xFF546E7A))),
          ],
        ),
      ),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ancho ? 6 : 0, vertical: ancho ? 0 : 6),
      child: Semantics(
        button: true,
        label: 'Tema $numero: ${tema.titulo}',
        child: Material(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(22),
          elevation: 6,
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), border: Border.all(color: color, width: 3.5)),
              child: ancho
                  ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      ...cuerpo,
                      const SizedBox(height: 8),
                      Icon(Icons.play_circle_fill_rounded, color: color, size: 40),
                    ])
                  : Row(children: [...cuerpo, Icon(Icons.play_circle_fill_rounded, color: color, size: 36)]),
            ),
          ),
        ),
      ),
    );
  }
}
