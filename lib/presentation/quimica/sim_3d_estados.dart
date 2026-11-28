import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/tema1/pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import '../ciencia/barajar.dart';
import '../ciencia/visor_3d.dart';
import '../electronica/comun.dart';

/// Simulación 3D: los estados de la materia. Las partículas del agua están en
/// una caja; el alumno enfría o calienta y ve cómo se ordenan y se mueven.
class SimEstados3D extends StatefulWidget {
  const SimEstados3D({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimEstados3D> createState() => SimEstados3DState();
}

enum EstadoMateria {
  solido(
      '🧊', 'Sólido (hielo)', -15, 'Las partículas están muy juntas y ordenadas, como en filas. Solo vibran en su lugar: por eso el hielo tiene forma propia.'),
  liquido('💧', 'Líquido (agua)', 25, 'Las partículas siguen juntas pero se deslizan unas sobre otras. Por eso el agua toma la forma del recipiente.'),
  gas('♨️', 'Gas (vapor)', 110, 'Las partículas se separan muchísimo y se mueven rápido por todas partes: el vapor ocupa todo el espacio de la caja.');

  const EstadoMateria(this.emoji, this.nombre, this.temperatura, this.explicacion);
  final String emoji, nombre, explicacion;
  final int temperatura;
}

const _n = 27; // 3 × 3 × 3 partículas
const _lado = 0.9; // media caja

class SimEstados3DState extends State<SimEstados3D> with SingleTickerProviderStateMixin {
  EstadoMateria estado = EstadoMateria.solido;
  EstadoMateria _anterior = EstadoMateria.solido;
  late final AnimationController _cambio = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200), value: 1);
  final vistos = <EstadoMateria>{EstadoMateria.solido};
  int? respuesta;
  bool _terminado = false;

  static const pregunta = '¿En qué estado se mueven más rápido las partículas?';
  static const opciones = ['En el gas', 'En el sólido', 'En el líquido'];

  bool get acerto => respuesta == 0;

  @override
  void dispose() {
    _cambio.dispose();
    super.dispose();
  }

  late final Escena3D escena = _crearEscena();

  /// Posición de la partícula [i] en un estado, en el tiempo [t].
  static V3 posEn(EstadoMateria e, int i, double t) {
    final ix = i % 3, iy = (i ~/ 3) % 3, iz = i ~/ 9;
    double r(int k) => math.sin(i * 12.9898 + k * 78.233) * 0.5 + 0.5; // pseudoazar 0..1
    switch (e) {
      case EstadoMateria.solido:
        final base = V3((ix - 1) * 0.38, -_lado + 0.2 + iy * 0.38, (iz - 1) * 0.38);
        return base + V3(math.sin(t * 25 + i), math.sin(t * 23 + i * 2), math.cos(t * 27 + i)) * 0.025;
      case EstadoMateria.liquido:
        // Juntas en la parte de abajo, deslizándose
        final ang = t * (0.4 + r(1) * 0.4) + r(2) * 6.28;
        final rad = 0.15 + r(3) * 0.6;
        return V3(math.cos(ang) * rad, -_lado + 0.17 + (i % 3) * 0.2 + math.sin(t * 2 + i) * 0.04, math.sin(ang) * rad);
      case EstadoMateria.gas:
        // Rebotan por toda la caja (onda triangular)
        double rebote(double v, double fase) {
          final u = (t * v + fase) % 2;
          return (u < 1 ? u : 2 - u) * 2 - 1;
        }
        final m = _lado - 0.12;
        return V3(rebote(0.6 + r(4) * 0.8, r(5) * 2) * m, rebote(0.5 + r(6) * 0.8, r(7) * 2) * m, rebote(0.6 + r(8) * 0.8, r(9) * 2) * m);
    }
  }

  Escena3D _crearEscena() {
    // Aristas de la caja de vidrio
    const l = _lado;
    final esquinas = [
      for (final x in [-l, l])
        for (final y in [-l, l])
          for (final z in [-l, l]) V3(x, y, z)
    ];
    final aristas = <Objeto3D>[];
    for (var a = 0; a < 8; a++) {
      for (var b = a + 1; b < 8; b++) {
        final d = esquinas[a] - esquinas[b];
        final iguales = [d.x == 0, d.y == 0, d.z == 0].where((x) => x).length;
        if (iguales == 2) {
          aristas.add(
              Objeto3D(id: 'caja', malla: Malla.tubo([esquinas[a], esquinas[b]], 0.015, segmentos: 4), color: const Color(0xFFB3E5FC), seleccionable: false));
        }
      }
    }
    return Escena3D(
      distancia: 5.6,
      fondo: const [Color(0xC8102A43), Color(0xC82B4F73)],
      objetos: [
        ...aristas,
        // Paredes de vidrio
        Objeto3D(id: 'vidrio', malla: mallaCaja(), color: const Color(0xFF81D4FA), escala: const V3(l, l, l), opacidad: 0.12, seleccionable: false),
        // Parrilla: fría (azul) o caliente (roja)
        Objeto3D(
            id: 'parrilla', malla: mallaCilindro(), color: const Color(0xFF546E7A), escala: const V3(0.95, 0.08, 0.95), posicion: const V3(0, -l - 0.12, 0)),
        Objeto3D(
            id: 'parrilla_fria', malla: mallaCilindro(), color: const Color(0xFF4FC3F7), escala: const V3(0.7, 0.03, 0.7), posicion: const V3(0, -l - 0.02, 0)),
        Objeto3D(
            id: 'parrilla_caliente',
            malla: mallaCilindro(),
            color: const Color(0xFFFF5722),
            escala: const V3(0.7, 0.03, 0.7),
            posicion: const V3(0, -l - 0.02, 0),
            brillo: 1),
      ],
      particulas: (t) {
        final u = Curves.easeInOut.transform(_cambio.value);
        return [
          for (var i = 0; i < _n; i++)
            Particula3D(
                V3.lerp(posEn(_anterior, i, t), posEn(estado, i, t), u), estado == EstadoMateria.gas ? const Color(0xFF90CAF9) : const Color(0xFF1E88E5), 0.13),
          if (estado == EstadoMateria.gas)
            for (var k = 0; k < 6; k++)
              Particula3D(V3(math.cos(k * 1.05) * 0.5, -l - 0.25, math.sin(k * 1.05) * 0.5), const Color.fromRGBO(255, 112, 67, 0.7), 0.09),
        ];
      },
    );
  }

  Map<String, double> get opacidad => {
        'parrilla_fria': estado == EstadoMateria.solido ? 1 : 0,
        'parrilla_caliente': estado == EstadoMateria.gas ? 1 : 0,
      };

  void cambiar(EstadoMateria e) {
    if (e == estado) return;
    HapticFeedback.lightImpact();
    setState(() {
      _anterior = estado;
      estado = e;
      vistos.add(e);
    });
    _cambio.forward(from: 0);
  }

  void responder(int i) => setState(() => respuesta = i);

  void terminar() {
    if (_terminado) return;
    _terminado = true;
    terminarPaso(context,
        actividad: widget.actividad,
        estrellas: 3,
        titulo: '¡Estados de la materia en 3D!',
        mensaje: 'Al calentar, las partículas se mueven más y se separan: el sólido se vuelve líquido y el líquido, gas. Al enfriar pasa al revés.');
  }

  @override
  Widget build(BuildContext context) {
    final listos = vistos.length == EstadoMateria.values.length;
    final orden = ordenOpciones(pregunta, opciones.length);
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación 3D', 'Las partículas del agua en 3D', widget.color),
        Positioned(
          left: 8,
          top: 60,
          width: 230,
          height: 176,
          child: GloboZatiEle('${estado.emoji} ${estado.nombre} · ${estado.temperatura} °C\n${estado.explicacion}', tam: 12.5),
        ),
        Positioned(
          left: 8,
          top: 242,
          width: 230,
          height: 232,
          child: PanelEle(
            titulo: listos ? 'Piensa' : 'Observa los 3 estados (${vistos.length}/3)',
            icono: listos ? Icons.psychology_rounded : Icons.visibility_rounded,
            color: widget.color,
            child: SingleChildScrollView(
              child: listos
                  ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const Text(pregunta, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      for (final (pos, i) in orden.indexed)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: BotonOpcion(
                            letra: 'ABC'[pos],
                            texto: opciones[i],
                            estado: respuesta == i ? (i == 0 ? EstadoOpcion.correcta : EstadoOpcion.incorrecta) : EstadoOpcion.normal,
                            onTap: acerto ? null : () => responder(i),
                          ),
                        ),
                      if (respuesta != null)
                        Text(acerto ? '✅ ¡Sí! El calor les da energía y se mueven rapidísimo.' : '🤔 Mira otra vez la caja con el fuego encendido.',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: acerto ? ColoresJuego.correcto : ColoresJuego.incorrecto)),
                    ])
                  : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      for (final e in EstadoMateria.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(children: [
                            Icon(vistos.contains(e) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                size: 18, color: vistos.contains(e) ? ColoresJuego.correcto : Colors.black38),
                            const SizedBox(width: 4),
                            Text('${e.emoji} ${e.nombre}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          ]),
                        ),
                      const Text('Usa los botones de abajo para enfriar o calentar.', style: TextStyle(fontSize: 12, height: 1.2)),
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
            opacidad: opacidad,
            yaw: 0.6,
            pitch: -0.35,
            ayuda: 'Arrastra para girar la caja',
          ),
        ),
        Positioned(
          left: 244,
          top: 418,
          width: 440,
          child: Wrap(spacing: 6, runSpacing: 4, children: [
            ChipEle(
                texto: '🧊 Enfriar (−15 °C)',
                activo: estado == EstadoMateria.solido,
                color: const Color(0xFF0288D1),
                onTap: () => cambiar(EstadoMateria.solido)),
            ChipEle(
                texto: '🌡️ Templado (25 °C)',
                activo: estado == EstadoMateria.liquido,
                color: const Color(0xFF00897B),
                onTap: () => cambiar(EstadoMateria.liquido)),
            ChipEle(
                texto: '🔥 Calentar (110 °C)', activo: estado == EstadoMateria.gas, color: const Color(0xFFE64A19), onTap: () => cambiar(EstadoMateria.gas)),
          ]),
        ),
        if (acerto) Positioned(left: 690, top: 420, child: BotonSiguiente(texto: 'Terminar', onTap: terminar)),
        const BotonVolverEscena(),
      ],
    );
  }
}
