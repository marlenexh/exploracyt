import 'bio_topics.dart';

/// Temas de Física: identificadores de sus misiones para el resto de la app.
/// El contenido jugable vive en `lib/presentation/fisica/`.
const fisTopics = {
  1: TopicInfo(1, ['Imanes y polos', '¿Qué atrae un imán?', 'La Tierra es un imán', 'El explorador perdido'], 'Maestro de los Imanes', mundo: 'fis'),
  2: TopicInfo(2, ['¿Qué es la gravedad?', 'La caída de los objetos', 'Efectos de la gravedad', 'Misión a la Luna'], 'Explorador de la Gravedad', mundo: 'fis'),
  3: TopicInfo(3, ['Temperatura y calor', '¿Cómo viaja el calor?', 'Conductores y aislantes', 'El pozole de la abuela'], 'Experto en Calor', mundo: 'fis'),
  4: TopicInfo(4, ['La electricidad', 'Conductores y aislantes', 'Uso responsable de la energía', 'El recibo de luz'], 'Guardián de la Energía', mundo: 'fis'),
  5: TopicInfo(5, ['El Sol y los planetas', 'Características de los planetas', 'Los movimientos de la Tierra', 'Viaje espacial'], 'Astronauta Explorador',
      mundo: 'fis'),
};

/// Contenido de cada tema, como lo pide el programa.
const fisContenidos = {
  1: 'Magnetismo, polos magnéticos, atracción, repulsión y sus aplicaciones.',
  2: 'La gravedad, la caída de los objetos y sus efectos.',
  3: 'Temperatura, transferencia de calor y ejemplos cotidianos.',
  4: 'Electricidad, conductores, aislantes y uso responsable de la energía.',
  5: 'El Sol, los planetas, sus características y movimientos.',
};
