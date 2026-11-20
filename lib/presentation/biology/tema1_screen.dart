import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/body_topic.dart';
import '../../main.dart' show store;
import 'tema1/cuerpo_humano.dart';
import 'tema1/misiones.dart' show misionesTema1;

/// Abre el juego del Tema 1 ("El cuerpo humano y sus sistemas") y conecta su
/// progreso con el de Explora Ciencia:
/// - Las estrellas de cada actividad se guardan en el dispositivo.
/// - Al completar una misión del juego se marca la misión del Tema 1 en
///   [store], con su insignia, para el mapa y la brújula de la ciencia.
class Tema1Screen extends StatefulWidget {
  const Tema1Screen({super.key});

  static const claveProgreso = 'v1.tema1.juego';

  @override
  State<Tema1Screen> createState() => _Tema1ScreenState();
}

class _Tema1ScreenState extends State<Tema1Screen> {
  ProgresoJuego? _progreso;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final prefs = await SharedPreferences.getInstance();
    ProgresoJuego progreso;
    try {
      final guardado = prefs.getString(Tema1Screen.claveProgreso);
      progreso = guardado == null
          ? ProgresoJuego()
          : ProgresoJuego.fromJson(
              jsonDecode(guardado) as Map<String, dynamic>);
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
    _prefs?.setString(Tema1Screen.claveProgreso, jsonEncode(p.toJson()));
    _sincronizar();
  }

  /// Marca en la app las misiones que ya se completaron dentro del juego.
  Future<void> _sincronizar() async {
    final p = _progreso;
    if (p == null) return;
    for (var i = 0; i < bodyMissions.length && i < misionesTema1.length; i++) {
      final id = bodyMissions[i].id;
      if (!misionesTema1[i].completa(p) || store.completadas.contains(id))
        continue;
      if (!bodyMissionUnlocked(i, store.completadas)) break;
      try {
        await store.completeBodyInvestigation(i);
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
    return CuerpoHumanoJuego(
      progreso: p,
      nombreAlumno: nombre.isEmpty ? null : nombre,
    );
  }
}
