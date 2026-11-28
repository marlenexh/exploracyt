import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../ciencia/visor_3d.dart';
import 'comun.dart';

/// Simulación 3D: un circuito sencillo sobre una tabla (pila, cables,
/// interruptor y foco). El alumno lo gira, toca las piezas, enciende el foco,
/// usa dos pilas y corta un cable para ver qué pasa.
class SimCircuito3D extends StatefulWidget {
  const SimCircuito3D({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimCircuito3D> createState() => SimCircuito3DState();
}

/// Qué es cada pieza, explicado para niños.
const infoPiezas3D = {
  'pila': ('🔋 Pila', 'Es la fuente de energía. Empuja a la corriente para que salga por el + y regrese por el −.'),
  'cable': ('〰️ Cables', 'Son el camino por donde viaja la corriente. Por dentro tienen metal (cobre) y por fuera plástico para protegernos.'),
  'interruptor': ('🔘 Interruptor', 'Abre o cierra el camino. Cerrado: la corriente pasa. Abierto: el camino se corta y todo se apaga.'),
  'foco': ('💡 Foco', 'Convierte la energía eléctrica en luz. Solo enciende si la corriente puede dar la vuelta completa.'),
};

class SimCircuito3DState extends State<SimCircuito3D> {
  bool cerrado = false, dosPilas = false, cableCortado = false;
  String? sel;
  final vistas = <String>{};
  final logros = <int>{};
  bool _terminado = false;

  static const objetivos = [
    'Toca las 4 piezas para conocerlas',
    'Cierra el interruptor y enciende el foco',
    'Usa 2 pilas: ¿qué le pasa al foco?',
    'Corta un cable con el foco encendido',
  ];

  bool get encendido => cerrado && !cableCortado;

  late final Escena3D escena = _crearEscena();

  // Camino de la corriente (del + al −) a la altura de los cables.
  static const _y = 0.12;
  static const _camino = [
    V3(-1.55, 1.0, -0.12), // + de la pila
    V3(-1.55, 1.25, -0.12),
    V3(-1.2, 1.25, -0.9),
    V3(-1.2, _y, -0.9),
    V3(1.55, _y, -0.9),
    V3(1.55, _y, -0.2), // entra al foco
    V3(1.55, 0.6, 0),
    V3(1.55, _y, 0.2), // sale del foco
    V3(1.55, _y, 0.9),
    V3(0.3, _y, 0.9), // interruptor
    V3(-0.3, _y, 0.9),
    V3(-1.2, _y, 0.9),
    V3(-1.2, 1.25, 0.12),
    V3(-1.55, 1.25, 0.12),
    V3(-1.55, 1.0, 0.12), // − de la pila
  ];

  Escena3D _crearEscena() {
    Objeto3D cable(String id, List<V3> camino) =>
        Objeto3D(id: id, malla: Malla.tubo(camino, 0.045, segmentos: 8), color: id.contains('roto') ? const Color(0xFFE53935) : const Color(0xFF2E7D32));
    return Escena3D(
      distancia: 6.2,
      fondo: const [Color(0xC80F2A3D), Color(0xC81F4E6B)],
      objetos: [
        Objeto3D(
            id: 'tablero',
            malla: mallaCaja(),
            color: const Color(0xFF8D6E63),
            escala: const V3(2.0, 0.05, 1.25),
            posicion: const V3(0, -0.02, 0),
            seleccionable: false),
        // Pila (de 9 V) y la segunda pila
        Objeto3D(
            id: 'pila', malla: mallaCaja(), color: const Color(0xFF37474F), escala: const V3(0.22, 0.45, 0.32), posicion: const V3(-1.55, 0.5, 0), brillo: 0.5),
        Objeto3D(id: 'pila', malla: mallaCaja(), color: const Color(0xFFFFB300), escala: const V3(0.225, 0.12, 0.325), posicion: const V3(-1.55, 0.78, 0)),
        Objeto3D(
            id: 'pila', malla: mallaCilindro(), color: const Color(0xFFD32F2F), escala: const V3(0.07, 0.06, 0.07), posicion: const V3(-1.55, 0.98, -0.12)),
        Objeto3D(id: 'pila', malla: mallaCilindro(), color: const Color(0xFF212121), escala: const V3(0.07, 0.06, 0.07), posicion: const V3(-1.55, 0.98, 0.12)),
        Objeto3D(
            id: 'pila2',
            malla: mallaCaja(),
            color: const Color(0xFF37474F),
            escala: const V3(0.22, 0.45, 0.32),
            posicion: const V3(-2.05, 0.5, 0),
            brillo: 0.5),
        Objeto3D(id: 'pila2', malla: mallaCaja(), color: const Color(0xFFFFB300), escala: const V3(0.225, 0.12, 0.325), posicion: const V3(-2.05, 0.78, 0)),
        // Cables (el de arriba tiene versión entera y cortada)
        cable('cable', _camino.sublist(7, 10)),
        cable('cable', _camino.sublist(0, 4)),
        cable('cable_entero', [_camino[3], _camino[4]]),
        cable('cable_roto', [_camino[3], const V3(0.05, _y, -0.9)]),
        cable('cable_roto', [const V3(0.45, _y, -0.9), _camino[4]]),
        cable('cable', _camino.sublist(4, 6)),
        cable('cable', _camino.sublist(10)),
        // Interruptor: base y palanca (abierta o cerrada)
        Objeto3D(id: 'interruptor', malla: mallaCaja(), color: const Color(0xFF1565C0), escala: const V3(0.45, 0.1, 0.24), posicion: const V3(0, 0.1, 0.9)),
        Objeto3D(
            id: 'interruptor_cerrado',
            malla: mallaCaja(),
            color: const Color(0xFFB0BEC5),
            escala: const V3(0.36, 0.05, 0.08),
            posicion: const V3(0, 0.23, 0.9),
            brillo: 0.8),
        Objeto3D(
            id: 'interruptor_abierto',
            malla: mallaCaja().mover(const V3(1, 0, 0)),
            color: const Color(0xFFB0BEC5),
            escala: const V3(0.18, 0.05, 0.08),
            posicion: const V3(-0.33, 0.23, 0.9),
            rotacion: const V3(0, 0, 0.75),
            brillo: 0.8),
        // Foco: rosca, vidrio apagado y vidrio encendido
        Objeto3D(
            id: 'foco',
            malla: mallaCilindro(),
            color: const Color(0xFF9E9E9E),
            escala: const V3(0.16, 0.2, 0.16),
            posicion: const V3(1.55, 0.3, 0),
            brillo: 0.8),
        Objeto3D(
            id: 'foco',
            malla: Malla.esfera(lat: 12, lon: 16),
            color: const Color(0xFFCFD8DC),
            escala: const V3(0.3, 0.34, 0.3),
            posicion: const V3(1.55, 0.78, 0),
            opacidad: 0.7),
        Objeto3D(
            id: 'foco_luz',
            malla: Malla.esfera(lat: 12, lon: 16),
            color: const Color(0xFFFFF176),
            escala: const V3(0.31, 0.35, 0.31),
            posicion: const V3(1.55, 0.78, 0),
            brillo: 1,
            seleccionable: false,
            pulso: (t) => 1 + 0.03 * (t * 6).remainder(1)),
      ],
      particulas: (t) {
        final ps = <Particula3D>[];
        if (encendido) {
          // Brillo alrededor del foco
          ps.add(Particula3D(const V3(1.55, 0.78, 0), Color.fromRGBO(255, 241, 118, dosPilas ? 0.55 : 0.35), dosPilas ? 0.75 : 0.55));
          // La corriente viaja por el camino completo
          final vel = dosPilas ? 0.16 : 0.08;
          for (var i = 0; i < 26; i++) {
            ps.add(Particula3D(puntoEnCamino(_camino, (t * vel + i / 26) % 1), const Color(0xFFFFEB3B), 0.05));
          }
        }
        return ps;
      },
    );
  }

  Map<String, double> get opacidad => {
        'pila2': dosPilas ? 1 : 0,
        'cable_entero': cableCortado ? 0 : 1,
        'cable_roto': cableCortado ? 1 : 0,
        'interruptor_cerrado': cerrado ? 1 : 0,
        'interruptor_abierto': cerrado ? 0 : 1,
        'foco_luz': encendido ? (dosPilas ? 1 : 0.85) : 0,
        'foco': encendido ? 0 : 1,
      };

  String get mensaje {
    if (sel != null) {
      final (titulo, texto) = infoPiezas3D[sel]!;
      return '$titulo: $texto';
    }
    if (cableCortado && cerrado) {
      return '✂️ El cable cortado deja el camino abierto: la corriente ya no puede dar la vuelta y el foco se apaga.'
          '${logros.length == objetivos.length ? ' ¡Excelente! 🎉 Presiona «Terminar».' : ''}';
    }
    if (logros.length == objetivos.length) return '¡Excelente! 🎉 Viste que la corriente necesita un camino cerrado. Presiona «Terminar».';
    if (encendido) {
      return dosPilas
          ? '⚡⚡ Con 2 pilas hay más energía: la corriente viaja más rápido y el foco brilla más.'
          : '💡 ¡Se encendió! Mira los puntitos amarillos: es la corriente saliendo del + de la pila, pasando por el foco y regresando al −.';
    }
    return 'Este es un circuito de verdad, ¡en 3D! Gíralo con el dedo, toca cada pieza para conocerla y luego cierra el interruptor.';
  }

  void tocar(String? id) {
    if (id == null) return setState(() => sel = null);
    final pieza = id.startsWith('cable')
        ? 'cable'
        : id.startsWith('interruptor')
            ? 'interruptor'
            : id.startsWith('pila')
                ? 'pila'
                : id.startsWith('foco')
                    ? 'foco'
                    : null;
    if (pieza == null) return;
    HapticFeedback.selectionClick();
    setState(() {
      sel = pieza;
      vistas.add(pieza);
      _revisar();
    });
  }

  void alternarInterruptor() => _cambiar(() => cerrado = !cerrado);
  void alternarPilas() => _cambiar(() => dosPilas = !dosPilas);
  void alternarCable() => _cambiar(() => cableCortado = !cableCortado);

  void _cambiar(VoidCallback f) {
    HapticFeedback.lightImpact();
    setState(() {
      f();
      sel = null;
      _revisar();
    });
  }

  void _revisar() {
    if (vistas.length == 4) logros.add(0);
    if (encendido) logros.add(1);
    if (encendido && dosPilas) logros.add(2);
    if (cerrado && cableCortado && logros.contains(1)) logros.add(3);
  }

  void terminar() {
    if (_terminado) return;
    _terminado = true;
    terminarPaso(context,
        actividad: widget.actividad,
        estrellas: 3,
        titulo: '¡Circuito 3D!',
        mensaje: 'La corriente sale de la pila, recorre el camino y regresa. Si el camino se abre (interruptor o cable cortado), todo se apaga.');
  }

  @override
  Widget build(BuildContext context) => Escenario(
        velo: 0.08,
        colorVelo: widget.color,
        children: [
          encabezadoEle('Simulación 3D', 'Un circuito en 3D', widget.color),
          Positioned(left: 8, top: 60, width: 230, height: 176, child: GloboZatiEle(mensaje, tam: 13)),
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
                            child: Text(i == 0 ? '${objetivos[i]} (${vistas.length}/4)' : objetivos[i],
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
              opacidad: opacidad,
              seleccionado: sel == 'cable' ? 'cable' : sel,
              onTocar: tocar,
              yaw: 0.35,
              pitch: -0.75,
              etiquetas: const {'pila': 'Pila', 'cable': 'Cable', 'interruptor': 'Interruptor', 'foco': 'Foco'},
            ),
          ),
          Positioned(
            left: 244,
            top: 418,
            width: 440,
            child: Wrap(spacing: 6, runSpacing: 4, children: [
              ChipEle(texto: cerrado ? '🔘 Interruptor: cerrado' : '⭕ Interruptor: abierto', activo: cerrado, color: widget.color, onTap: alternarInterruptor),
              ChipEle(texto: dosPilas ? '🔋🔋 2 pilas' : '🔋 1 pila', activo: dosPilas, color: widget.color, onTap: alternarPilas),
              ChipEle(
                  texto: cableCortado ? '✂️ Cable cortado' : '〰️ Cable completo', activo: cableCortado, color: const Color(0xFFE53935), onTap: alternarCable),
            ]),
          ),
          if (logros.length == objetivos.length) Positioned(left: 690, top: 420, child: BotonSiguiente(texto: 'Terminar', onTap: terminar)),
          const BotonVolverEscena(),
        ],
      );
}
