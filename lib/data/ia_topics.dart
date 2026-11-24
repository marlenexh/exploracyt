import 'bio_topics.dart';

/// Temas de Inteligencia Artificial: identificadores de sus misiones para el
/// resto de la app. El contenido jugable vive en `lib/presentation/ia/`.
const iaTopics = {
  1: TopicInfo(1, ['¿Qué es la inteligencia artificial?', 'La prueba de Turing', 'Agentes y tipos de IA', 'La Feria de los Robots'],
      'Explorador de Máquinas Inteligentes',
      mundo: 'ia'),
  2: TopicInfo(
      2, ['Características y semejanzas', 'Secuencias y patrones', 'Las máquinas reconocen patrones', 'El museo de los patrones'], 'Detective de Patrones',
      mundo: 'ia'),
  3: TopicInfo(3, ['¿Cómo aprende una máquina?', 'Entrena tu clasificador', 'La neurona artificial', 'El robot que separa la basura'], 'Entrenador de Máquinas',
      mundo: 'ia'),
  4: TopicInfo(4, ['La IA en tu casa y tu bolsillo', 'Recomendaciones y búsquedas', 'La IA que ayuda', 'Un día con la IA'], 'Detective de la IA Cotidiana',
      mundo: 'ia'),
  5: TopicInfo(5, ['Límites y errores de la IA', 'Privacidad y datos personales', 'Contenido falso y uso responsable', 'El reglamento de IA del salón'],
      'Guardián Digital Responsable',
      mundo: 'ia'),
};

/// Contenido de cada tema, como lo pide el programa.
const iaContenidos = {
  1: 'Qué es la inteligencia artificial y cuáles son algunas de sus aplicaciones.',
  2: 'Reconocimiento de características, semejanzas y patrones.',
  3: 'Introducción al aprendizaje automático mediante ejemplos y clasificaciones.',
  4: 'Aplicaciones de la inteligencia artificial en dispositivos y servicios cotidianos.',
  5: 'Uso responsable, limitaciones y riesgos de la inteligencia artificial.',
};

/// Laboratorio de IA (construir una IA), fuera de los 5 temas.
const iaLabId = 'ia-lab';
const iaLabBadgeId = 'ia-lab-badge';
const iaLabBadge = 'Ingeniero de IA';
