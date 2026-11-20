import 'package:flutter/widgets.dart';

import 'contenido.dart';

/// Guarda las estrellas (0–3) obtenidas en cada actividad y las insignias
/// desbloqueadas. Es un [ChangeNotifier]: escúchalo para guardar el progreso
/// (por ejemplo con shared_preferences usando [toJson] / [ProgresoJuego.fromJson]).
class ProgresoJuego extends ChangeNotifier {
  ProgresoJuego({Map<String, int>? estrellas, Set<String>? insignias})
      : _estrellas = {...?estrellas},
        _insignias = {...?insignias};

  final Map<String, int> _estrellas;
  final Set<String> _insignias;

  /// Insignias que se desbloquearon en la última llamada a [registrar].
  final List<Insignia> nuevasInsignias = [];

  int estrellasDe(String actividad) => _estrellas[actividad] ?? 0;

  int get totalEstrellas => _estrellas.values.fold(0, (a, b) => a + b);

  int get estrellasPosibles => Actividades.todas.length * 3;

  Set<String> get insignias => Set.unmodifiable(_insignias);

  /// Registra un resultado. Solo se guarda si mejora el anterior.
  bool registrar(String actividad, int estrellas) {
    nuevasInsignias.clear();
    final valor = estrellas.clamp(0, 3);
    if (valor <= estrellasDe(actividad)) return false;
    _estrellas[actividad] = valor;
    for (final ins in insigniasJuego) {
      if (_insignias.contains(ins.id)) continue;
      final cumple = ins.requisitos.every((a) => estrellasDe(a) > 0) &&
          totalEstrellas >= ins.estrellasMinimas;
      if (cumple) {
        _insignias.add(ins.id);
        nuevasInsignias.add(ins);
      }
    }
    notifyListeners();
    return true;
  }

  void reiniciar() {
    _estrellas.clear();
    _insignias.clear();
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'estrellas': Map<String, int>.from(_estrellas),
        'insignias': _insignias.toList(),
      };

  factory ProgresoJuego.fromJson(Map<String, dynamic> json) => ProgresoJuego(
        estrellas: (json['estrellas'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        ),
        insignias: (json['insignias'] as List?)?.map((e) => '$e').toSet(),
      );
}

/// Hace disponible el progreso a todas las pantallas del juego.
class ProgresoScope extends InheritedNotifier<ProgresoJuego> {
  const ProgresoScope({
    super.key,
    required ProgresoJuego progreso,
    required super.child,
  }) : super(notifier: progreso);

  static ProgresoJuego of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ProgresoScope>()!.notifier!;

  static ProgresoJuego read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ProgresoScope>()!.notifier!;
}

/// Identificadores de cada actividad que otorga estrellas.
class Actividades {
  static const tourIntro = 'tour_intro';
  static const tourCirculatorio = 'tour_circulatorio';
  static const tourRespiratorio = 'tour_respiratorio';
  static const tourInmune = 'tour_inmune';
  static const simCorazon = 'sim_corazon';
  static const simPulmones = 'sim_pulmones';
  static const simCuerpo = 'sim_cuerpo';
  static const simInmune = 'sim_inmune';
  static const labPulso = 'lab_pulso';
  static const labPulmon = 'lab_pulmon';
  static const labMicroscopio = 'lab_microscopio';
  static const labVacunas = 'lab_vacunas';
  static const retoQuiz = 'reto_quiz';
  static const retoArma = 'reto_arma';
  static const retoRuta = 'reto_ruta';
  static const m1Cuerpo = 'm1_cuerpo';
  static const m1Circulatorio = 'm1_circulatorio';
  static const m1Vasos = 'm1_vasos';
  static const m1Viaje = 'm1_viaje';
  static const m1Video = 'm1_video';
  static const m1Lab = 'm1_lab';
  static const m1Mini = 'm1_mini';
  static const retoRutaAire = 'reto_ruta_aire';
  static const retoDefensa = 'reto_defensa';

  /// Actividades que se juegan en las misiones (cuentan para las estrellas).
  static const todas = [
    // Misión 1
    tourIntro,
    m1Cuerpo,
    m1Circulatorio,
    m1Vasos,
    m1Viaje,
    m1Video,
    m1Lab,
    m1Mini, //
    // Misión 2
    tourRespiratorio, simPulmones, labPulmon, retoRutaAire, //
    // Misión 3
    tourInmune, simInmune, labMicroscopio, labVacunas, retoDefensa, //
    // Actividad integradora
    simCuerpo, retoArma, retoQuiz,
  ];
}
