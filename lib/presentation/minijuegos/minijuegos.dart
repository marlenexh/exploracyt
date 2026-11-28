import 'package:flutter/material.dart';

import '../electronica/comun.dart' show ChipEle;
import 'base.dart';
import 'juego_aventura_final.dart';
import 'juego_electron.dart';
import 'juego_etiquetas.dart';
import 'juego_globulo.dart';
import 'juego_lanzamiento.dart';
import 'juego_moleculas.dart';
import 'juego_plataformas.dart';

/// Los mini-juegos de acción (hechos con Flame), uno por mundo, y la aventura
/// final de la Brújula de la Ciencia.

Widget juegoLanzamiento(String actividad, {Color color = const Color(0xFF6A1B9A)}) => PantallaMiniJuego<ModeloLanzamiento>(
      actividad: actividad,
      titulo: 'Lanza con gravedad',
      color: color,
      crearModelo: ModeloLanzamiento.new,
      capas: capasLanzamiento,
      aprendizaje: 'La gravedad jala todo hacia abajo. Donde hay menos gravedad (la Luna), lo que lanzas llega mucho más lejos.',
      alArrastrar: (m, p) => m.apuntar(p),
      alSoltar: (m) => m.soltar(),
    );

Widget juegoGlobulo(String actividad, {Color color = const Color(0xFFC62828)}) => PantallaMiniJuego<ModeloGlobulo>(
      actividad: actividad,
      titulo: 'Glóbulo blanco al ataque',
      color: color,
      crearModelo: ModeloGlobulo.new,
      capas: capasGlobulo,
      aprendizaje: 'Los glóbulos blancos son los defensores del cuerpo: atrapan a los microbios. Los anticuerpos les ayudan.',
      alTocar: (m, p) => m.moverA(p),
      alArrastrar: (m, p) => m.moverA(p),
    );

Widget juegoMoleculas(String actividad, {Color color = const Color(0xFF7B1FA2)}) => PantallaMiniJuego<ModeloMoleculas>(
      actividad: actividad,
      titulo: 'Arma moléculas',
      color: color,
      crearModelo: ModeloMoleculas.new,
      capas: capasMoleculas,
      aprendizaje: 'Los átomos se unen para formar moléculas: H₂O (agua) tiene 2 hidrógenos y 1 oxígeno.',
      alTocar: (m, p) => m.moverA(p),
      alArrastrar: (m, p) => m.moverA(p),
    );

Widget juegoElectron(String actividad, {Color color = const Color(0xFFD81B60)}) => PantallaMiniJuego<ModeloElectron>(
      actividad: actividad,
      titulo: 'El viaje del electrón',
      color: color,
      crearModelo: ModeloElectron.new,
      capas: capasElectron,
      aprendizaje: 'La corriente solo circula si el camino está cerrado. Un cortocircuito es peligroso: la corriente no pasa por el foco.',
      alTocar: (m, p) => m.tocar(p),
    );

Widget juegoEtiquetas(String actividad, {Color color = const Color(0xFF6A1B9A)}) => PantallaMiniJuego<ModeloEtiquetas>(
      actividad: actividad,
      titulo: 'Etiqueta para entrenar',
      color: color,
      crearModelo: ModeloEtiquetas.new,
      capas: capasEtiquetas,
      aprendizaje: 'Una IA aprende de los datos que le damos. Si los datos están mal etiquetados, la IA aprende mal.',
      controles: (context, m) => Row(children: [
        Tooltip(message: 'Es fruta', child: ChipEle(texto: '🍎 Fruta', activo: false, color: const Color(0xFF2E7D32), onTap: () => m.etiquetar(true))),
        const SizedBox(width: 10),
        Tooltip(message: 'No es fruta', child: ChipEle(texto: '❌ No es fruta', activo: false, color: const Color(0xFFC62828), onTap: () => m.etiquetar(false))),
      ]),
    );

Widget juegoPlataformas(String actividad, {Color color = const Color(0xFF1E88E5)}) => PantallaMiniJuego<ModeloPlataformas>(
      actividad: actividad,
      titulo: 'Plataformas con bloques',
      color: color,
      crearModelo: ModeloPlataformas.new,
      capas: capasPlataformas,
      aprendizaje: 'Un programa es una secuencia de instrucciones. Un ciclo (🔁 repite) ahorra bloques cuando algo se repite.',
      controles: (context, m) => Wrap(spacing: 6, runSpacing: 4, children: [
        for (final b in Bloque.values)
          Tooltip(message: b.nombre, child: ChipEle(texto: '${b.emoji} ${b.nombre}', activo: false, color: color, onTap: () => m.agregar(b))),
        Tooltip(message: 'Borrar bloque', child: ChipEle(texto: '⌫', activo: false, color: const Color(0xFF78909C), onTap: m.borrar)),
        Tooltip(message: 'Ejecutar', child: ChipEle(texto: '▶ Ejecutar', activo: true, color: const Color(0xFF2DB84C), onTap: m.ejecutar)),
      ]),
    );

/// La aventura final (desde la pantalla de la Brújula).
Widget juegoAventuraFinal({required void Function(ModeloAventura m) onTerminar}) => PantallaMiniJuego<ModeloAventura>(
      actividad: 'aventura_final',
      seccion: 'Aventura final',
      titulo: 'Zati recupera la Brújula',
      color: const Color(0xFFF57C00),
      crearModelo: ModeloAventura.new,
      capas: capasAventura,
      aprendizaje: 'Cada mundo te dio una pieza: la ciencia funciona mejor cuando juntamos todo lo que sabemos.',
      alTocar: (m, p) => m.volar(),
      onTerminar: onTerminar,
    );
