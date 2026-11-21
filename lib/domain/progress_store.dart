import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/body_topic.dart';

/// Progreso local, sin cuenta. Claves versionadas para migraciones futuras.
class ProgressStore extends ChangeNotifier {
  static const _v = 'v1';
  late SharedPreferences _p;
  String nombre = '';
  int grado = 5;
  String? ultimaMision;
  bool sonido = true, musica = true, textoGrande = false, reducirAnim = false;
  String avatar = 'zati';
  final Set<String> completadas = {};
  final Set<String> recompensas = {}; // Set: nunca hay duplicados

  bool get registrado => nombre.isNotEmpty;

  Future<void> cargar() async {
    _p = await SharedPreferences.getInstance();
    nombre = _p.getString('$_v.nombre') ?? '';
    grado = _p.getInt('$_v.grado') ?? 5;
    ultimaMision = _p.getString('$_v.ultima');
    if (_p.containsKey('$_v.monedas')) await _p.remove('$_v.monedas');
    sonido = _p.getBool('$_v.sonido') ?? true;
    musica = _p.getBool('$_v.musica') ?? true;
    textoGrande = _p.getBool('$_v.textoGrande') ?? false;
    reducirAnim = _p.getBool('$_v.reducirAnim') ?? false;
    avatar = _p.getString('$_v.avatar') ?? 'zati';
    completadas.addAll(_p.getStringList('$_v.completadas') ?? []);
    recompensas.addAll(_p.getStringList('$_v.recompensas') ?? []);
    // Tema 1: solo hay insignia al terminar todo el tema.
    if (recompensas.any(legacyBodyBadgeIds.contains)) {
      recompensas.removeAll(legacyBodyBadgeIds);
      await _p.setStringList('$_v.recompensas', recompensas.toList());
    }
    for (final mission in bodyMissions) {
      final badge = mission.badgeId;
      if (badge != null && completadas.contains(mission.id)) recompensas.add(badge);
    }
  }

  Future<void> registrar(String n, int g) async {
    nombre = n.trim();
    grado = g;
    await _p.setString('$_v.nombre', nombre);
    await _p.setInt('$_v.grado', g);
    notifyListeners();
  }

  Future<void> actualizarPerfil(String n, int g, {required bool son, required bool mus, required bool grande, required bool reducir}) async {
    nombre = n.trim().isEmpty ? nombre : n.trim();
    grado = g;
    sonido = son;
    musica = mus;
    textoGrande = grande;
    reducirAnim = reducir;
    await _p.setString('$_v.nombre', nombre);
    await _p.setInt('$_v.grado', g);
    await _p.setBool('$_v.sonido', son);
    await _p.setBool('$_v.musica', mus);
    await _p.setBool('$_v.textoGrande', grande);
    await _p.setBool('$_v.reducirAnim', reducir);
    notifyListeners();
  }

  /// Borra todo el progreso y el perfil de este dispositivo.
  Future<void> reiniciar() async {
    await _p.clear();
    nombre = '';
    grado = 5;
    ultimaMision = null;
    sonido = musica = true;
    textoGrande = reducirAnim = false;
    completadas.clear();
    recompensas.clear();
    notifyListeners();
  }

  Future<void> abrirMision(String id) async {
    ultimaMision = id;
    await _p.setString('$_v.ultima', id);
    notifyListeners();
  }

  /// Repetir una misión nunca quita progreso ni duplica recompensas.
  Future<bool> completar(String misionId, {String? recompensaId}) async {
    completadas.add(misionId);
    final nueva = recompensaId != null && recompensas.add(recompensaId);
    await _p.setStringList('$_v.completadas', completadas.toList());
    await _p.setStringList('$_v.recompensas', recompensas.toList());
    notifyListeners();
    return nueva;
  }

  /// The persisted completion is also the source of truth for Topic 1 badges.
  Future<void> completeBodyInvestigation(int index) async {
    if (!bodyMissionUnlocked(index, completadas)) {
      throw StateError('The required investigation is incomplete.');
    }
    final mission = bodyMissions[index];
    final updated = {...completadas, mission.id};
    if (!await _p.setStringList('$_v.completadas', updated.toList())) {
      throw StateError('Could not save investigation progress.');
    }
    completadas.add(mission.id);
    final badge = mission.badgeId;
    if (badge != null && recompensas.add(badge)) {
      await _p.setStringList('$_v.recompensas', recompensas.toList());
    }
    notifyListeners();
  }

  double progresoMundo(List<String> ids) =>
      ids.isEmpty ? 0 : ids.where(completadas.contains).length / ids.length;
}
