import 'package:flutter/material.dart';

import '../biology/tema1/progreso.dart';
import 'circuito.dart';
import 'ele_tema1.dart' show abiertoYListo, pz;
import 'taller.dart';

/// Actividad del laboratorio de Electrónica.
const actividadLabEle = 'ele-lab';

/// Proyectos de la casa inteligente.
final retosCasaInteligente = [
  RetoCircuito(
    titulo: 'Luces de la sala y la cocina',
    instruccion:
        'La casa necesita dos focos que se prendan juntos con un solo interruptor. Conecta la pila, el interruptor y los DOS focos en paralelo (cada foco en su propio camino). Simula y enciende.',
    piezas: () => [
      pz('pila', TipoPieza.pila3v, 90, 240),
      pz('sw', TipoPieza.interruptor, 260, 100),
      pz('f1', TipoPieza.foco, 450, 110),
      pz('f2', TipoPieza.foco, 450, 290)
    ],
    condiciones: [
      Condicion('Los dos focos encienden', (e) => e.luzFoco('f1') > 0.3 && e.luzFoco('f2') > 0.3 && e.piezas['sw']!.cerrado),
      Condicion('El interruptor apaga los dos', (e) => abiertoYListo(e, 'sw')),
    ],
    logro: 'En paralelo, cada foco tiene su propio camino: así funcionan las luces de una casa.',
  ),
  RetoCircuito(
    titulo: 'Timbre con luz',
    instruccion:
        'Cuando alguien toque el timbre debe sonar el zumbador Y encenderse un LED (para quien no escucha bien). Usa la pila de 9 V, el botón, el zumbador, y el LED con su resistencia. Mantén presionado el botón.',
    piezas: () => [
      pz('pila', TipoPieza.pila9v, 80, 240),
      pz('b', TipoPieza.boton, 250, 100),
      pz('z', TipoPieza.zumbador, 460, 110),
      pz('r', TipoPieza.resistencia, 370, 290),
      pz('led', TipoPieza.led, 540, 290),
    ],
    condiciones: [
      Condicion('Suena y se enciende el LED al presionar', (e) => e.suena('z') && e.encendido('led') && e.piezas['b']!.presionado),
      Condicion('Al soltar, todo se apaga', (e) => !e.piezas['b']!.presionado && e.voltaje('b').abs() > 1),
    ],
    logro: 'Un mismo botón puede controlar varias salidas: sonido y luz.',
  ),
  RetoCircuito(
    titulo: 'Sensor de luz del jardín',
    instruccion:
        'El jardín tiene un sensor de luz. Conecta en un solo camino: pila + → fotorresistencia → resistencia → LED → pila −. Simula y mueve el control de luz (☀️/🌙).',
    piezas: () => [
      pz('pila', TipoPieza.pila9v, 80, 240),
      pz('ldr', TipoPieza.ldr, 210, 140),
      pz('r', TipoPieza.resistencia, 340, 230),
      pz('led', TipoPieza.led, 500, 200)
    ],
    condiciones: [
      Condicion('Con mucha luz, el LED brilla', (e) => e.encendido('led') && e.luz > 0.7),
      Condicion('A oscuras, casi no pasa corriente', (e) => !e.encendido('led') && e.luz < 0.3 && e.voltaje('ldr').abs() > 1),
    ],
    logro: 'El sensor le avisa a la casa si es de día o de noche.',
  ),
  RetoCircuito(
    titulo: 'Ventilador con velocidades',
    instruccion:
        'Arma el ventilador del cuarto: pila, interruptor, potenciómetro (una orilla y la pata central) y motor en un solo camino. Enciéndelo y gira la perilla 🎛️ para que vaya rápido y luego lento.',
    piezas: () => [
      pz('pila', TipoPieza.pila9v, 80, 240),
      pz('sw', TipoPieza.interruptor, 230, 90),
      pz('pot', TipoPieza.potenciometro, 390, 150, ohms: 300, pot: 0.5),
      pz('m', TipoPieza.motor, 540, 250),
    ],
    condiciones: [
      Condicion('El ventilador gira rápido', (e) => e.velocidad('m').abs() > 0.8 && e.piezas['sw']!.cerrado),
      Condicion('El ventilador gira lento', (e) => e.velocidad('m').abs() > 0.08 && e.velocidad('m').abs() < 0.35),
    ],
    logro: 'El potenciómetro regula la velocidad, como la perilla de un ventilador real.',
  ),
];

/// Laboratorio del Inventor: los circuitos de una casa inteligente, en el
/// mismo taller de circuitos de los temas.
class LaboratorioEle extends StatefulWidget {
  const LaboratorioEle({super.key, required this.onTerminar, this.color = const Color(0xFFFF8F00)});
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioEle> createState() => _LaboratorioEleState();
}

class _LaboratorioEleState extends State<LaboratorioEle> {
  final progreso = ProgresoJuego();
  bool _avisado = false;

  @override
  void initState() {
    super.initState();
    progreso.addListener(() {
      final e = progreso.estrellasDe(actividadLabEle);
      if (e > 0 && !_avisado) {
        _avisado = true;
        widget.onTerminar(e);
      }
    });
  }

  @override
  void dispose() {
    progreso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ProgresoScope(
        progreso: progreso,
        child: TallerCircuitos(
          actividad: actividadLabEle,
          seccion: 'Laboratorio',
          titulo: 'La casa inteligente',
          color: widget.color,
          retos: retosCasaInteligente,
          mensajeFinal:
              '¡Construiste los circuitos de una casa inteligente: luces en paralelo, timbre con luz, sensor de luz y ventilador con velocidades! Ganaste la insignia “Inventor de la Casa Inteligente”.',
        ),
      );
}
