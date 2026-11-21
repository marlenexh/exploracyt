import 'bio_topics.dart';

/// Temas de Electrónica: identificadores de sus misiones para el resto de la
/// app. El contenido jugable vive en `lib/presentation/electronica/`.
const eleTopics = {
  1: TopicInfo(1, ['La caja de componentes', 'El LED y la resistencia', 'Pilas, interruptores y más', 'La linterna de emergencia'],
      'Conocedor de Componentes', mundo: 'ele'),
  2: TopicInfo(2, ['¿Qué es un circuito?', 'Serie y paralelo', 'Conductores y seguridad', 'La ciudad a oscuras'], 'Maestro de los Circuitos',
      mundo: 'ele'),
  3: TopicInfo(3, ['¿Qué es un sensor?', '¿Cómo funcionan?', 'Sensores a nuestro alrededor', 'El misterio del museo'], 'Detective Electrónico',
      mundo: 'ele'),
  4: TopicInfo(4, ['El motor eléctrico', 'Mecanismos', 'Máquinas de todos los días', 'El carrito de la feria'], 'Ingeniero en Movimiento',
      mundo: 'ele'),
  5: TopicInfo(5, ['Sistemas automáticos', 'Programa con bloques', 'Diseña tu invento', 'El invernadero automático'], 'Inventor Electrónico',
      mundo: 'ele'),
};

/// Contenido de cada tema, como lo pide el programa.
const eleContenidos = {
  1: 'Identificación de LED, resistencias, pilas, interruptores y otros componentes básicos.',
  2: 'Funcionamiento de circuitos eléctricos, conexiones y flujo de corriente.',
  3: 'Qué son los sensores, cómo funcionan y dónde se utilizan.',
  4: 'Motores, mecanismos y aplicaciones en dispositivos cotidianos.',
  5: 'Integración de componentes para comprender sistemas automatizados sencillos.',
};
