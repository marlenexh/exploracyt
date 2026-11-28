import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../ciencia/visor_3d.dart';
import '../electronica/comun.dart';
import 'sims_fis.dart' show planetas;

/// Simulación 3D: el Sistema Solar. Los planetas giran alrededor del Sol; el
/// alumno lo gira, toca cada planeta para conocerlo y cambia la velocidad.
class SimSistemaSolar3D extends StatefulWidget {
  const SimSistemaSolar3D({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimSistemaSolar3D> createState() => SimSistemaSolar3DState();
}

/// Tamaño de la órbita y del planeta (no están a escala: así se ven todos).
const _orbitas = [0.95, 1.3, 1.7, 2.1, 2.75, 3.4, 3.95, 4.45];
const _radios = [0.07, 0.11, 0.12, 0.09, 0.3, 0.25, 0.17, 0.16];
const _colores = [
  Color(0xFF9E9E9E), // Mercurio
  Color(0xFFF3D9A4), // Venus
  Color(0xFF1E88E5), // Tierra (océanos)
  Color(0xFFC1440E), // Marte
  Color(0xFFE3C9A1), // Júpiter
  Color(0xFFF1DFA8), // Saturno
  Color(0xFF9FE3EA), // Urano
  Color(0xFF3F5BD9), // Neptuno
];

class SimSistemaSolar3DState extends State<SimSistemaSolar3D> {
  String? sel;
  final visitados = <String>{};
  final logros = <int>{};
  bool rapido = false;
  bool _terminado = false;

  // Tiempo propio de la simulación (para cambiar la velocidad sin saltos).
  double _fase = 0, _ultimoT = 0;
  double _tiempo(double t) {
    if (t != _ultimoT) {
      _fase += (t - _ultimoT).clamp(0, 0.1) * (rapido ? 5 : 1);
      _ultimoT = t;
    }
    return _fase;
  }

  static const objetivos = [
    'Toca el Sol',
    'Encuentra la Tierra',
    'Encuentra el planeta más grande',
    'Conoce 6 planetas',
  ];

  static String idPlaneta(int i) => 'p$i';

  /// Posición del planeta [i] en su órbita.
  V3 posicion(int i, double t) {
    final a = _tiempo(t) * 0.9 / math.pow(planetas[i].periodo, 0.55) + i * 1.7;
    return V3(math.cos(a) * _orbitas[i], 0, math.sin(a) * _orbitas[i]);
  }

  late final Escena3D escena = _crearEscena();

  Escena3D _crearEscena() {
    final objs = <Objeto3D>[];
    // Sol
    objs.add(Objeto3D(
      id: 'sol',
      malla: Malla.esfera(lat: 16, lon: 20),
      color: const Color(0xFFFFB300),
      escala: const V3(0.55, 0.55, 0.55),
      brillo: 1,
      pulso: (t) => 1 + 0.015 * math.sin(t * 3),
    ));
    // Órbitas
    for (var i = 0; i < 8; i++) {
      objs.add(Objeto3D(
        id: 'orbita',
        malla: Malla.tubo(
            [for (var k = 0; k <= 48; k++) V3(math.cos(k / 48 * 2 * math.pi) * _orbitas[i], 0, math.sin(k / 48 * 2 * math.pi) * _orbitas[i])], 0.006,
            segmentos: 3),
        color: Colors.white,
        opacidad: 0.3,
        seleccionable: false,
      ));
    }
    // Planetas
    for (var i = 0; i < 8; i++) {
      final r = _radios[i];
      V3 mov(double t) => posicion(i, t);
      Objeto3D parte(Malla m, Color c, {double brillo = 0.3, bool gira = true, double opacidad = 1}) => Objeto3D(
            id: idPlaneta(i),
            malla: m,
            color: c,
            desplazamiento: mov,
            giro: gira ? (t) => V3(0, t * 1.2, 0) : null,
            brillo: brillo,
            opacidad: opacidad,
          );
      objs.add(parte(Malla.esfera(lat: 12, lon: 16).escalar(V3(r, r, r)), _colores[i], brillo: i == 2 ? 0.6 : 0.3));
      switch (i) {
        case 2: // La Tierra: continentes, hielo en los polos y la Luna
          for (final (dir, c) in const [
            (V3(0.6, 0.35, 0.72), Color(0xFF43A047)),
            (V3(-0.7, 0.1, 0.7), Color(0xFF7CB342)),
            (V3(-0.3, -0.45, -0.84), Color(0xFF8D6E63)),
            (V3(0.85, -0.2, -0.45), Color(0xFF43A047)),
          ]) {
            objs.add(parte(Malla.esfera(lat: 6, lon: 8).escalar(V3(r * 0.5, r * 0.4, r * 0.5)).mover(dir.unitario() * (r * 0.62)), c));
          }
          objs.add(parte(Malla.esfera(lat: 6, lon: 8).escalar(V3(r * 0.45, r * 0.3, r * 0.45)).mover(V3(0, r * 0.82, 0)), Colors.white));
          objs.add(parte(Malla.esfera(lat: 6, lon: 8).escalar(V3(r * 0.5, r * 0.3, r * 0.5)).mover(V3(0, -r * 0.82, 0)), Colors.white));
          objs.add(Objeto3D(
            id: 'luna',
            malla: Malla.esfera(lat: 8, lon: 10),
            color: const Color(0xFFCFD8DC),
            escala: const V3(0.04, 0.04, 0.04),
            desplazamiento: (t) {
              final a = _tiempo(t) * 3;
              return posicion(2, t) + V3(math.cos(a) * 0.24, 0.03, math.sin(a) * 0.24);
            },
          ));
        case 4: // Júpiter: bandas y la Gran Mancha Roja
          for (final y in [-0.45, 0.0, 0.45]) {
            objs.add(parte(Malla.esfera(lat: 8, lon: 16).escalar(V3(r * 1.01, r * 0.12, r * 1.01)).mover(V3(0, y * r, 0)), const Color(0xFFB07A4E)));
          }
          objs.add(
              parte(Malla.esfera(lat: 6, lon: 8).escalar(V3(r * 0.28, r * 0.16, r * 0.2)).mover(V3(r * 0.55, -r * 0.25, r * 0.72)), const Color(0xFFC0392B)));
        case 5: // Saturno: anillos
          objs.add(parte(Malla.esfera(lat: 6, lon: 32).escalar(V3(r * 2.2, r * 0.03, r * 2.2)), const Color(0xFFD7C08A), gira: false, opacidad: 0.85));
          objs.add(parte(Malla.esfera(lat: 8, lon: 16).escalar(V3(r * 1.01, r * 0.15, r * 1.01)), const Color(0xFFD9BC7B)));
        case 3: // Marte: casquete polar
          objs.add(parte(Malla.esfera(lat: 6, lon: 8).escalar(V3(r * 0.45, r * 0.25, r * 0.45)).mover(V3(0, r * 0.85, 0)), Colors.white));
      }
    }
    return Escena3D(
      distancia: 11,
      fondo: const [Color(0xC802030F), Color(0xC80B1238)],
      objetos: objs,
      particulas: (t) => [
        // Brillo del Sol
        const Particula3D(V3.cero, Color.fromRGBO(255, 183, 0, 0.25), 0.95),
        // Estrellas lejanas
        for (var k = 0; k < 40; k++)
          Particula3D(V3(math.sin(k * 12.9898) * 9, math.cos(k * 4.1414) * 5, math.sin(k * 78.233) * 9),
              Color.fromRGBO(255, 255, 255, 0.5 + 0.3 * math.sin(t + k)), 0.025),
      ],
    );
  }

  String get mensaje {
    final s = sel;
    if (s == 'sol') {
      return '☀️ El Sol es una estrella: una esfera gigante de gases muy calientes. Su gravedad mantiene a los 8 planetas girando a su alrededor.';
    }
    if (s == 'luna') return '🌙 La Luna es el satélite natural de la Tierra: gira a nuestro alrededor y tarda unos 27 días en dar la vuelta.';
    if (s != null && s.startsWith('p')) {
      final p = planetas[int.parse(s.substring(1))];
      final anio = p.periodo < 1 ? '${(p.periodo * 365).round()} días' : '${p.periodo.toStringAsFixed(p.periodo < 10 ? 1 : 0)} años terrestres';
      return '${p.emoji} ${p.nombre} (planeta ${p.tipo.toLowerCase()}): ${p.dato} Su año dura $anio.';
    }
    if (logros.length == objetivos.length) return '¡Gran viaje! 🚀 Conociste el Sistema Solar en 3D. Presiona «Terminar».';
    return 'Este es el Sistema Solar en 3D. Gíralo con el dedo, acércate con 🔍 y toca el Sol y los planetas para conocerlos. ¿Notas que los más cercanos al Sol van más rápido?';
  }

  void tocar(String? id) {
    if (id == null || id == 'orbita') return setState(() => sel = null);
    HapticFeedback.selectionClick();
    setState(() {
      sel = id;
      if (id.startsWith('p')) visitados.add(id);
      if (id == 'sol') logros.add(0);
      if (id == idPlaneta(2)) logros.add(1);
      if (id == idPlaneta(4)) logros.add(2);
      if (visitados.length >= 6) logros.add(3);
    });
  }

  void terminar() {
    if (_terminado) return;
    _terminado = true;
    terminarPaso(context,
        actividad: widget.actividad,
        estrellas: 3,
        titulo: '¡Viaje por el Sistema Solar completo!',
        mensaje: 'Los 8 planetas giran alrededor del Sol en sus órbitas. Los cercanos dan la vuelta más rápido que los lejanos.');
  }

  @override
  Widget build(BuildContext context) => Escenario(
        velo: 0.08,
        colorVelo: widget.color,
        children: [
          encabezadoEle('Simulación 3D', 'El Sistema Solar en 3D', widget.color),
          Positioned(left: 8, top: 60, width: 230, height: 176, child: GloboZatiEle(mensaje, tam: 12.5)),
          Positioned(
            left: 8,
            top: 242,
            width: 230,
            height: 232,
            child: PanelEle(
              titulo: 'Objetivos ${logros.length}/${objetivos.length}',
              icono: Icons.flag_rounded,
              color: widget.color,
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  for (var i = 0; i < objetivos.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Icon(logros.contains(i) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                            size: 18, color: logros.contains(i) ? ColoresJuego.correcto : Colors.black38),
                        const SizedBox(width: 4),
                        Expanded(
                            child: Text(i == 3 ? '${objetivos[i]} (${math.min(visitados.length, 6)}/6)' : objetivos[i],
                                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, height: 1.15))),
                      ]),
                    ),
                ]),
              ),
            ),
          ),
          Positioned(
            left: 244,
            top: 60,
            width: 608,
            height: 350,
            child: Visor3D(
              escena: escena,
              seleccionado: sel,
              onTocar: tocar,
              yaw: 0.2,
              pitch: -0.55,
              etiquetas: {
                'sol': '☀️ Sol',
                idPlaneta(2): '🌍 Tierra',
                if (sel != null && sel!.startsWith('p') && sel != idPlaneta(2)) sel!: planetas[int.parse(sel!.substring(1))].nombre,
              },
              ayuda: 'Arrastra para girar · toca un planeta',
            ),
          ),
          Positioned(
            left: 244,
            top: 418,
            width: 440,
            child: Wrap(spacing: 6, runSpacing: 4, children: [
              ChipEle(texto: '🐢 Velocidad normal', activo: !rapido, color: widget.color, onTap: () => setState(() => rapido = false)),
              ChipEle(texto: '🚀 Más rápido', activo: rapido, color: widget.color, onTap: () => setState(() => rapido = true)),
            ]),
          ),
          if (logros.length == objetivos.length) Positioned(left: 690, top: 420, child: BotonSiguiente(texto: 'Terminar', onTap: terminar)),
          const BotonVolverEscena(),
        ],
      );
}
