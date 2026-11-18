import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Progreso local, sin cuenta. Claves versionadas para migraciones futuras.
class ProgressStore extends ChangeNotifier {
  static const _v = 'v1';
  late SharedPreferences _p;
  String nombre = '';
  int grado = 5;
  String? ultimaMision;
  int monedas = 0;
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
    monedas = _p.getInt('$_v.monedas') ?? 0;
    sonido = _p.getBool('$_v.sonido') ?? true;
    musica = _p.getBool('$_v.musica') ?? true;
    textoGrande = _p.getBool('$_v.textoGrande') ?? false;
    reducirAnim = _p.getBool('$_v.reducirAnim') ?? false;
    avatar = _p.getString('$_v.avatar') ?? 'zati';
    completadas.addAll(_p.getStringList('$_v.completadas') ?? []);
    recompensas.addAll(_p.getStringList('$_v.recompensas') ?? []);
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
    monedas = 0;
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
    final primera = completadas.add(misionId);
    if (primera) monedas += 15; // monedas de conocimiento: solo la primera vez
    final nueva = recompensaId != null && recompensas.add(recompensaId);
    await _p.setInt('$_v.monedas', monedas);
    await _p.setStringList('$_v.completadas', completadas.toList());
    await _p.setStringList('$_v.recompensas', recompensas.toList());
    notifyListeners();
    return nueva;
  }

  double progresoMundo(List<String> ids) =>
      ids.isEmpty ? 0 : ids.where(completadas.contains).length / ids.length;
}
