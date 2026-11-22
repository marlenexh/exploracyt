import 'bio_topics.dart';

/// Temas de Programación: identificadores de sus misiones para el resto de la
/// app. El contenido jugable vive en `lib/presentation/programacion/`.
const proTopics = {
  1: TopicInfo(1, ['¿Qué es programar?', 'Pensamiento computacional', 'Resuelve paso a paso', 'El robot cocinero'], 'Pensador Computacional',
      mundo: 'pro'),
  2: TopicInfo(2, ['¿Qué es un algoritmo?', 'Secuencias', 'Diagramas y pseudocódigo', 'El mapa del tesoro'], 'Maestro de los Algoritmos',
      mundo: 'pro'),
  3: TopicInfo(3, ['¿Qué son los bloques?', 'Mueve al robot', 'Dibuja con código', 'La gran fábrica'], 'Programador de Bloques', mundo: 'pro'),
  4: TopicInfo(4, ['Decisiones: si… si no', 'Ciclos: repetir', 'Combina ciclos y decisiones', 'El laberinto giratorio'],
      'Experto en Ciclos y Decisiones', mundo: 'pro'),
  5: TopicInfo(5, ['¿Qué es un bug?', 'Depura algoritmos', 'Depura programas', 'El videojuego con bichos'], 'Cazador de Errores', mundo: 'pro'),
};

/// Contenido de cada tema, como lo pide el programa.
const proContenidos = {
  1: 'Qué es la programación, pensamiento computacional y resolución de problemas paso a paso.',
  2: 'Algoritmos, secuencias y organización de acciones.',
  3: 'Introducción a la programación mediante bloques visuales.',
  4: 'Condiciones, decisiones y estructuras de repetición.',
  5: 'Identificación y corrección de errores en secuencias y programas sencillos.',
};

/// Laboratorio del programador (crear un videojuego), fuera de los 5 temas.
const proLabId = 'pro-lab';
const proLabBadgeId = 'pro-lab-badge';
const proLabBadge = 'Desarrollador de Videojuegos';
