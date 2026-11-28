/// Glosario de palabras difíciles, explicadas para niños de primaria.
///
/// En las explicaciones de los temas aparecen como “📖 Palabras difíciles”:
/// al tocarlas, Zati explica qué significan con palabras sencillas.
class PalabraGlosario {
  const PalabraGlosario(this.palabra, this.emoji, this.patron, this.significado);
  final String palabra, emoji;

  /// Expresión regular (sin distinguir mayúsculas) que encuentra la palabra
  /// y sus variantes (plural, femenino…).
  final String patron;
  final String significado;

  RegExp get regex => RegExp('(?<!\\p{L})(?:$patron)(?!\\p{L})', caseSensitive: false, unicode: true);
}

const glosario = [
  // ---------------- Biología ----------------
  PalabraGlosario('Célula', '🔬', 'células?',
      'Es la parte más pequeña de un ser vivo. Todos los seres vivos están hechos de células, como una casa está hecha de ladrillos.'),
  PalabraGlosario('Microscopio', '🔬', 'microscopios?', 'Instrumento con lentes que hace ver muchísimo más grandes las cosas diminutas, como las células.'),
  PalabraGlosario('Organismo', '🧬', 'organismos?', 'Otra forma de decir “ser vivo”: una planta, un animal, una persona o un microbio.'),
  PalabraGlosario('Tejido', '🧶', 'tejidos?', 'Un grupo de células iguales que trabajan juntas, por ejemplo el tejido de los músculos.'),
  PalabraGlosario('Órgano', '🫀', 'órganos?',
      'Una parte del cuerpo hecha de tejidos que tiene un trabajo especial, como el corazón (bombear sangre) o los pulmones (respirar).'),
  PalabraGlosario(
      'Nutrientes', '🥦', 'nutrientes?', 'Lo que los alimentos le dan a tu cuerpo para crecer, moverse y estar sano: proteínas, vitaminas, minerales…'),
  PalabraGlosario('Proteínas', '🥚', 'proteínas?',
      'Nutrientes que ayudan a construir y reparar tu cuerpo (músculos, piel). Hay en el huevo, el frijol, la carne y la leche.'),
  PalabraGlosario('Carbohidratos', '🍞', 'carbohidratos?', 'Nutrientes que dan energía para jugar y pensar. Hay en el pan, la tortilla, el arroz y la papa.'),
  PalabraGlosario('Vitaminas', '🍊', 'vitaminas?', 'Nutrientes que ayudan a que tu cuerpo funcione bien y no te enfermes. Hay muchas en frutas y verduras.'),
  PalabraGlosario(
      'Fotosíntesis', '🌿', 'fotosíntesis', 'Así fabrican su alimento las plantas: usan la luz del Sol, agua y un gas del aire. ¡Y de paso sueltan oxígeno!'),
  PalabraGlosario('Ecosistema', '🏞️', 'ecosistemas?',
      'Un lugar donde viven seres vivos que dependen unos de otros, junto con el agua, el suelo, el aire y la luz. Por ejemplo, un bosque o un lago.'),
  PalabraGlosario('Biodiversidad', '🦋', 'biodiversidad', 'La gran variedad de seres vivos que hay en un lugar o en todo el planeta. México tiene muchísima.'),
  PalabraGlosario('Biótico', '🐞', 'bióticos?|bióticas?', 'Todo lo que tiene vida en un ecosistema: plantas, animales, hongos…'),
  PalabraGlosario('Abiótico', '🪨', 'abióticos?|abióticas?',
      'Lo que no tiene vida pero es necesario en un ecosistema: el agua, el aire, las rocas, la luz y la temperatura.'),
  PalabraGlosario('Herbívoro', '🐄', 'herbívoros?', 'Animal que solo come plantas, como la vaca o el conejo.'),
  PalabraGlosario('Carnívoro', '🦁', 'carnívoros?', 'Animal que come otros animales, como el león o el águila.'),
  PalabraGlosario('Omnívoro', '🐻', 'omnívoros?', 'Animal que come plantas y animales, como el oso… ¡y las personas!'),
  PalabraGlosario('Oxígeno', '💨', 'oxígeno', 'Un gas del aire que necesitamos para vivir. Lo tomamos al respirar.'),
  PalabraGlosario('Dióxido de carbono', '🌫️', 'dióxido de carbono|co₂', 'Un gas que sacamos al respirar. Las plantas lo usan para hacer su alimento.'),
  PalabraGlosario('Microbio', '🦠', 'microbios?|microorganismos?|bacterias?',
      'Seres vivos tan pequeños que solo se ven con microscopio. Algunos nos ayudan y otros nos enferman.'),

  // ---------------- Química ----------------
  PalabraGlosario('Materia', '🧱', 'materia', 'Todo lo que ocupa un lugar y se puede tocar o pesar: el agua, una piedra, el aire, tú.'),
  PalabraGlosario('Propiedad', '📏', 'propiedades|propiedad', 'Una característica de un material: si es duro o blando, si se dobla, si deja pasar el agua…'),
  PalabraGlosario('Permeable', '💧', 'permeables?', 'Que deja pasar el agua, como una tela o un papel.'),
  PalabraGlosario('Impermeable', '☔', 'impermeables?', 'Que NO deja pasar el agua, como el plástico de un paraguas.'),
  PalabraGlosario('Partículas', '⚪', 'partículas?', 'Pedacitos tan pequeños que no se ven, de los que está hecha toda la materia.'),
  PalabraGlosario('Comprimir', '🤏', 'comprimir|comprime|comprimen|comprimido|compresión',
      'Apretar algo para que ocupe menos espacio. Los gases se pueden comprimir porque sus partículas están muy separadas.'),
  PalabraGlosario('Cambio físico', '🧊', 'cambios? físicos?|cambios? temporal(?:es)?',
      'Un cambio en el que el material sigue siendo el mismo, como el hielo que se derrite: sigue siendo agua.'),
  PalabraGlosario('Cambio químico', '🔥', 'cambios? químicos?|cambios? permanentes?',
      'Un cambio en el que se forma algo nuevo y no se puede regresar, como el huevo que se cocina o el papel que se quema.'),
  PalabraGlosario('Reacción química', '⚗️', 'reacciones químicas|reacción química|reacciona[rn]?',
      'Cuando dos o más sustancias se juntan y forman algo nuevo, como el vinagre con bicarbonato que hace burbujas.'),
  PalabraGlosario('Combustión', '🔥', 'combustión', 'Cuando algo se quema. Para que haya fuego se necesitan tres cosas: combustible, calor y oxígeno.'),
  PalabraGlosario('Combustible', '🪵', 'combustibles?', 'Material que se puede quemar para dar calor o energía, como la madera, el gas o la gasolina.'),
  PalabraGlosario('Oxidación', '🔩', 'oxidación|oxida[rn]?|oxidado|óxido',
      'Cuando un metal como el hierro se junta con el agua y el oxígeno del aire y se forma óxido, una capa rojiza.'),
  PalabraGlosario('Descomposición', '🍌', 'descomposición|descompone[rn]?',
      'Cuando los alimentos u otros restos se echan a perder porque los microbios los van deshaciendo.'),
  PalabraGlosario('Reversible', '🔄', 'reversibles?', 'Que se puede regresar a como estaba antes.'),
  PalabraGlosario('Irreversible', '⛔', 'irreversibles?', 'Que ya no se puede regresar a como estaba antes.'),

  // ---------------- Física ----------------
  PalabraGlosario('Magnetismo', '🧲', 'magnetismo|magnéticos?|magnéticas?', 'La fuerza invisible de los imanes que atrae algunos metales, como el hierro.'),
  PalabraGlosario('Polos', '🧲', 'polos?', 'Los dos extremos de un imán: norte y sur. Polos iguales se empujan y polos distintos se atraen.'),
  PalabraGlosario('Repeler', '↔️', 'repele[rn]?|repulsión|se repelen', 'Empujarse para alejarse, como dos imanes con polos iguales.'),
  PalabraGlosario('Atracción', '🤝', 'atracción|atrae[rn]?', 'Cuando algo jala a otra cosa hacia sí, como un imán con un clip.'),
  PalabraGlosario('Gravedad', '🍎', 'gravedad', 'La fuerza que jala todo hacia el centro de la Tierra. Por eso las cosas caen y no flotamos.'),
  PalabraGlosario('Fuerza', '💪', 'fuerzas?', 'Un empujón o un jalón que puede mover algo, frenarlo o cambiar su forma.'),
  PalabraGlosario('Energía', '⚡', 'energía', 'Lo que permite que las cosas se muevan, se calienten, den luz o hagan un trabajo.'),
  PalabraGlosario('Temperatura', '🌡️', 'temperatura', 'Qué tan caliente o frío está algo. Se mide con un termómetro, en grados (°C).'),
  PalabraGlosario('Conducción', '🥄', 'conducción', 'Cuando el calor viaja tocando, de una parte a otra, como en una cuchara metida en sopa caliente.'),
  PalabraGlosario('Convección', '♨️', 'convección', 'Cuando el calor viaja con el aire o el agua que se mueven: lo caliente sube y lo frío baja.'),
  PalabraGlosario('Radiación', '☀️', 'radiación', 'Cuando el calor viaja sin tocar nada, como el calor del Sol que llega hasta nosotros.'),
  PalabraGlosario('Órbita', '🪐', 'órbitas?', 'El camino que sigue un planeta alrededor del Sol, o la Luna alrededor de la Tierra.'),
  PalabraGlosario('Rotación', '🌍', 'rotación', 'Cuando la Tierra gira sobre sí misma, como un trompo. Tarda un día y por eso hay día y noche.'),
  PalabraGlosario('Traslación', '🔄', 'traslación', 'El viaje de la Tierra alrededor del Sol. Tarda un año.'),
  PalabraGlosario('Renovable', '🌬️', 'renovables?', 'Energía que no se acaba, como la del Sol o la del viento.'),

  // ---------------- Electrónica ----------------
  PalabraGlosario(
      'Electricidad', '⚡', 'electricidad|eléctricos?|eléctricas?', 'Una forma de energía que viaja por los cables y hace funcionar focos, motores y aparatos.'),
  PalabraGlosario('Corriente', '〰️', 'corriente eléctrica|corriente',
      'Es la electricidad moviéndose por un camino (el circuito), como el agua que corre por una manguera.'),
  PalabraGlosario(
      'Voltaje', '🔋', 'voltajes?|voltios?|\\d+ ?v', 'Qué tan fuerte “empuja” la pila a la corriente. Se mide en voltios (V). Más voltios, más empuje.'),
  PalabraGlosario(
      'Circuito', '🔁', 'circuitos?', 'El camino cerrado por donde viaja la corriente: sale de la pila, pasa por los componentes y regresa a la pila.'),
  PalabraGlosario('Circuito abierto', '✂️', 'circuitos? abiertos?|camino abierto',
      'Un circuito con el camino cortado (un cable suelto o el interruptor apagado). La corriente no pasa.'),
  PalabraGlosario(
      'Resistencia', '🟫', 'resistencias?', 'Un componente que frena la corriente, como un freno de bicicleta. Protege a otros componentes, como el LED.'),
  PalabraGlosario('Ohm', 'Ω', 'ohms?|ohmios?|kΩ|Ω', 'La unidad que dice cuánto frena una resistencia. Más ohms = más freno = menos corriente.'),
  PalabraGlosario('LED', '💡', 'led|leds', 'Una lucecita pequeña que gasta muy poca energía. Solo enciende si la corriente entra por su pata + (ánodo).'),
  PalabraGlosario(
      'Ánodo y cátodo', '➕', 'ánodo|cátodo', 'Las dos patas del LED. El ánodo es la pata + (la doblada o larga) y el cátodo es la pata − (la recta o corta).'),
  PalabraGlosario('Interruptor', '🔘', 'interruptor(?:es)?', 'Abre o cierra el camino de la corriente. Es como una puerta: cerrada deja pasar, abierta no.'),
  PalabraGlosario('Cortocircuito', '⚠️', 'cortocircuitos?',
      'Cuando la corriente va directo del + al − sin pasar por nada que la frene. La pila se calienta: ¡es peligroso!'),
  PalabraGlosario('En serie', '🔗', 'en serie', 'Componentes conectados uno detrás de otro en un solo camino. Si uno falla, todos se apagan.'),
  PalabraGlosario('En paralelo', '🪜', 'en paralelo', 'Componentes conectados cada uno en su propio camino. Si uno falla, los demás siguen funcionando.'),
  PalabraGlosario('Sensor', '📡', 'sensor(?:es)?', 'Un “sentido” para las máquinas: detecta luz, calor, movimiento o distancia y avisa al circuito.'),
  PalabraGlosario('Fotorresistencia', '🌗', 'fotorresistencias?|ldr', 'Un sensor de luz: con mucha luz deja pasar más corriente y en la oscuridad casi nada.'),
  PalabraGlosario('Potenciómetro', '🎛️', 'potenciómetros?',
      'Una resistencia con perilla: al girarla cambias cuánto frena. Sirve para subir y bajar el volumen o la velocidad.'),
  PalabraGlosario('Componente', '🧩', 'componentes?', 'Cada pieza de un circuito: pila, cables, resistencia, LED, motor…'),
  PalabraGlosario('Zumbador', '🔔', 'zumbador(?:es)?', 'Un componente que convierte la electricidad en sonido: ¡bzzz!'),
  PalabraGlosario('Engrane', '⚙️', 'engranes?|engranajes?', 'Ruedas con dientes que se empujan entre sí para pasar el movimiento de una a otra.'),
  PalabraGlosario(
      'Polaridad', '➕', 'polaridad', 'Saber cuál lado es + y cuál es −. Algunos componentes, como el LED, solo funcionan si se conectan del lado correcto.'),
  PalabraGlosario('Prototipo', '🛠️', 'prototipos?', 'Un primer modelo de un invento para probar si funciona antes de hacerlo de verdad.'),

  // ---------------- Inteligencia Artificial ----------------
  PalabraGlosario('Inteligencia artificial', '🤖', 'inteligencia artificial|ia',
      'Programas que aprenden de ejemplos para hacer cosas que parecen inteligentes, como reconocer fotos o entender la voz.'),
  PalabraGlosario('Datos', '📊', 'datos', 'Información (fotos, números, palabras) que se usa para que una computadora aprenda o tome decisiones.'),
  PalabraGlosario('Patrón', '🔁', 'patrones|patrón', 'Algo que se repite y sigue una regla. Encontrar patrones ayuda a adivinar lo que sigue.'),
  PalabraGlosario('Pixel', '🟦', 'pixeles|píxeles|pixel|píxel', 'Cada cuadrito de color de una imagen digital. Una foto tiene miles o millones de pixeles.'),
  PalabraGlosario(
      'Entrenar', '🏋️', 'entrena[rn]?|entrenamiento|entrenada', 'Enseñarle a una IA con muchos ejemplos para que aprenda a reconocer o decidir algo.'),
  PalabraGlosario(
      'Etiquetar', '🏷️', 'etiqueta[rn]?|etiquetad[oa]s?', 'Ponerle nombre a cada ejemplo (“esto es un gato”, “esto es un perro”) para que la IA aprenda.'),
  PalabraGlosario('Neurona artificial', '🟣', 'neuronas? artificial(?:es)?|neuronas?',
      'Una pequeña parte de una IA que recibe señales, las suma y decide si pasa la señal o no. Se inspira en las neuronas del cerebro.'),
  PalabraGlosario(
      'Red neuronal', '🕸️', 'redes neuronales|red neuronal', 'Muchas neuronas artificiales conectadas en capas. Juntas pueden aprender cosas difíciles.'),
  PalabraGlosario('Sesgo', '⚖️', 'sesgos?', 'Cuando una IA aprende mal porque sus ejemplos no eran variados, y por eso se equivoca o es injusta.'),
  PalabraGlosario('Privacidad', '🔒', 'privacidad', 'Cuidar tu información personal (nombre, dirección, fotos) para que no la vean personas que no deben.'),

  // ---------------- Programación ----------------
  PalabraGlosario('Algoritmo', '📝', 'algoritmos?', 'Una lista de pasos ordenados para resolver un problema, como una receta de cocina.'),
  PalabraGlosario('Programa', '💻', 'programas?', 'Un algoritmo escrito para que lo entienda una computadora o un robot.'),
  PalabraGlosario('Instrucción', '👉', 'instrucciones|instrucción', 'Una orden que le das a la computadora o al robot, como “avanza” o “gira”.'),
  PalabraGlosario('Secuencia', '➡️', 'secuencias?', 'Instrucciones en un orden. Si cambias el orden, cambia el resultado.'),
  PalabraGlosario('Ciclo', '🔁', 'ciclos?|bucles?', 'Una instrucción que repite otras varias veces, como “repite 4 veces: avanza”.'),
  PalabraGlosario(
      'Condición', '❓', 'condiciones|condición|condicional(?:es)?', 'Una pregunta que el programa revisa para decidir: “SI hay pared, ENTONCES gira”.'),
  PalabraGlosario('Variable', '📦', 'variables?', 'Una cajita con nombre donde el programa guarda un dato que puede cambiar, como los puntos de un juego.'),
  PalabraGlosario('Bug', '🐞', 'bugs?', 'Un error en un programa. Se llama así porque “bug” significa “bicho” en inglés.'),
  PalabraGlosario('Depurar', '🔍', 'depura[rn]?|depuración', 'Buscar y corregir los errores (bugs) de un programa.'),
  PalabraGlosario('Código', '⌨️', 'código', 'Las instrucciones de un programa escritas en un lenguaje que entiende la computadora.'),
  PalabraGlosario('Evento', '🎬', 'eventos?', 'Algo que pasa y hace que el programa reaccione, como presionar un botón o tocar la pantalla.'),
  PalabraGlosario('Diagrama de flujo', '🗺️', 'diagramas? de flujo', 'Un dibujo con figuras y flechas que muestra los pasos de un algoritmo.'),
];

/// Palabras del glosario que aparecen en un texto (sin repetir, en orden de aparición).
List<PalabraGlosario> palabrasEn(String texto, {int maximo = 3}) {
  final encontradas = <(int, PalabraGlosario)>[];
  for (final p in glosario) {
    final m = p.regex.firstMatch(texto);
    if (m != null) encontradas.add((m.start, p));
  }
  encontradas.sort((a, b) => a.$1.compareTo(b.$1));
  // Si una palabra está dentro de otra más específica (circuito / circuito abierto), se queda la específica.
  final res = <PalabraGlosario>[];
  for (final (_, p) in encontradas) {
    if (res.any((r) => r.palabra == p.palabra)) continue;
    res.add(p);
  }
  return res.take(maximo).toList();
}
