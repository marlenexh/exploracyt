/// La Brújula de la Ciencia: en la historia se rompió y sus seis piezas
/// quedaron dispersas, una en cada mundo. El alumno recupera la pieza de un
/// mundo al terminar su laboratorio final (el final del mundo).
class PiezaBrujula {
  const PiezaBrujula(this.mundo, this.nombreMundo, this.nombre, this.emoji, this.recompensaLab, this.laboratorio);

  /// Id del mundo (bio, qui, fis, ele, ia, pro).
  final String mundo, nombreMundo;
  final String nombre, emoji;

  /// Insignia del laboratorio final que entrega la pieza.
  final String recompensaLab;

  /// Nombre del laboratorio final del mundo.
  final String laboratorio;
}

/// En el orden de los mundos; también es el orden de las piezas alrededor de
/// la brújula, empezando arriba y en el sentido de las manecillas del reloj.
const piezasBrujula = [
  PiezaBrujula('bio', 'Biología', 'Pieza de la Vida', '🌿', 'bio-lab-badge', 'Laboratorio de la Vida'),
  PiezaBrujula('qui', 'Química', 'Pieza de la Materia', '⚗️', 'qui-lab-badge', 'Laboratorio de Experimentos'),
  PiezaBrujula('fis', 'Física', 'Pieza de la Energía', '⚡', 'fis-lab-badge', 'Laboratorio de Lanzamientos'),
  PiezaBrujula('ele', 'Electrónica', 'Pieza de los Circuitos', '💡', 'ele-lab-badge', 'Laboratorio del Inventor'),
  PiezaBrujula('ia', 'Inteligencia Artificial', 'Pieza de la Inteligencia', '🧠', 'ia-lab-badge', 'Laboratorio de IA'),
  PiezaBrujula('pro', 'Programación', 'Pieza del Código', '💻', 'pro-lab-badge', 'Laboratorio del Programador'),
];

/// Mundos cuya pieza ya se recuperó.
Set<String> piezasObtenidas(Set<String> recompensas) => {
      for (final p in piezasBrujula)
        if (recompensas.contains(p.recompensaLab)) p.mundo,
    };

/// La pieza que entrega una recompensa (o null si no es de un laboratorio final).
PiezaBrujula? piezaDeRecompensa(String recompensa) {
  for (final p in piezasBrujula) {
    if (p.recompensaLab == recompensa) return p;
  }
  return null;
}

PiezaBrujula piezaDelMundo(String mundo) => piezasBrujula.firstWhere((p) => p.mundo == mundo);
