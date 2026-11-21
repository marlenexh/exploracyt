import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/bio_topics.dart';
import '../../main.dart' show store;
import 'tema1/progreso.dart';
import 'temas/motor.dart';
import 'temas/tema2.dart';
import 'temas/tema3.dart';
import 'temas/tema4.dart';
import 'temas/tema5.dart';

/// Juegos de los temas 2 a 5, por número de tema.
final temasBio = <int, TemaBio>{2: tema2, 3: tema3, 4: tema4, 5: tema5};

/// Abre el juego de un tema de Biología (2 a 5).
class TemaBioScreen extends StatelessWidget {
  const TemaBioScreen({super.key, required this.numero});
  final int numero;

  static String claveProgreso(int numero) => 'v1.tema$numero.juego';

  @override
  Widget build(BuildContext context) => TemaJuegoScreen(tema: temasBio[numero]!, info: bioTopics[numero]!);
}

/// Abre el juego de un tema (de cualquier mundo) y conecta su progreso con el
/// de Explora Ciencia, igual que `Tema1Screen`:
/// - Las estrellas de cada actividad se guardan en el dispositivo.
/// - Al completar una misión se marca en [store]; la insignia se entrega solo
///   al terminar la actividad integradora.
class TemaJuegoScreen extends StatefulWidget {
  const TemaJuegoScreen({super.key, required this.tema, required this.info});
  final TemaBio tema;
  final TopicInfo info;

  /// Biología conserva su clave original; los demás mundos llevan su id.
  static String clave(TopicInfo info) => info.mundo == 'bio' ? TemaBioScreen.claveProgreso(info.numero) : 'v1.${info.mundo}.tema${info.numero}.juego';

  @override
  State<TemaJuegoScreen> createState() => _TemaJuegoScreenState();
}

class _TemaJuegoScreenState extends State<TemaJuegoScreen> {
  ProgresoJuego? _progreso;
  SharedPreferences? _prefs;

  String get _clave => TemaJuegoScreen.clave(widget.info);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    ProgresoJuego progreso;
    try {
      final guardado = prefs.getString(_clave);
      progreso = guardado == null ? ProgresoJuego() : ProgresoJuego.fromJson(jsonDecode(guardado) as Map<String, dynamic>);
    } catch (_) {
      progreso = ProgresoJuego();
    }
    progreso.addListener(_alCambiar);
    if (!mounted) return;
    setState(() {
      _prefs = prefs;
      _progreso = progreso;
    });
    await _sincronizar();
  }

  void _alCambiar() {
    final p = _progreso;
    if (p == null) return;
    _prefs?.setString(_clave, jsonEncode(p.toJson()));
    _sincronizar();
  }

  /// Marca en la app, en orden, las misiones ya completadas dentro del juego.
  Future<void> _sincronizar() async {
    final p = _progreso;
    if (p == null) return;
    final ids = widget.info.missionIds;
    for (var i = 0; i < ids.length && i < widget.tema.misiones.length; i++) {
      if (!widget.tema.misiones[i].completa(p)) break;
      if (store.completadas.contains(ids[i])) continue;
      try {
        await store.completar(ids[i], recompensaId: i == ids.length - 1 ? widget.info.badgeId : null);
      } catch (_) {
        break;
      }
    }
  }

  @override
  void dispose() {
    _progreso?.removeListener(_alCambiar);
    _progreso?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _progreso;
    if (p == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF183E73),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    final nombre = store.nombre.trim();
    return TemaBioJuego(tema: widget.tema, progreso: p, nombreAlumno: nombre.isEmpty ? null : nombre);
  }
}
