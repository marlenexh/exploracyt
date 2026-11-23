import 'bio_topics.dart';

/// Temas de Química: identificadores de sus misiones para el resto de la app.
/// El contenido jugable vive en `lib/presentation/quimica/`.
const quiTopics = {
  1: TopicInfo(1, ['¿De qué están hechas las cosas?', 'Dureza, flexibilidad y permeabilidad', 'El material correcto', 'La mochila para la lluvia'],
      'Detective de Materiales',
      mundo: 'qui'),
  2: TopicInfo(2, ['Sólidos, líquidos y gases', 'Las propiedades de los gases', 'Gases en la vida diaria', 'El globo de la feria'], 'Explorador de los Gases',
      mundo: 'qui'),
  3: TopicInfo(3, ['Cambios temporales', 'Cambios permanentes', 'Los cambios de estado', 'La fiesta de cumpleaños'], 'Maestro de las Transformaciones',
      mundo: 'qui'),
  4: TopicInfo(4, ['La cocción', 'La descomposición', 'La conservación', 'El refrigerador descompuesto'], 'Chef Científico', mundo: 'qui'),
  5: TopicInfo(5, ['La combustión', 'La oxidación', 'Fuego y ambiente', 'Campamento seguro'], 'Guardián del Fuego', mundo: 'qui'),
};

/// Contenido de cada tema, como lo pide el programa.
const quiContenidos = {
  1: 'Propiedades de los materiales, como dureza, flexibilidad y permeabilidad.',
  2: 'Características y propiedades de los gases, como volumen, compresibilidad, fluidez, masa y expansión.',
  3: 'Cambios temporales y permanentes que pueden experimentar los materiales.',
  4: 'Efectos de la temperatura, tiempo y conservación de alimentos.',
  5: 'Transformaciones de materiales y sus implicaciones ambientales y cotidianas.',
};
