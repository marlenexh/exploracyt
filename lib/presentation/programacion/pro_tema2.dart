import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_pro.dart';
import 'ilustraciones_pro.dart';
import 'pro_tema1.dart' show robot, conGemas;
import 'robot.dart';
import 'sim_3d_robot.dart';

/// Programación · Tema 2: Sigue las instrucciones (algoritmos y secuencias).

const _c1 = Color(0xFF43A047);
const _c2 = Color(0xFF1E88E5);
const _c3 = Color(0xFF8E24AA);
const _ci = Color(0xFF2E7D32);

final proTema2 = TemaBio(
  numero: 2,
  mundo: 'pro',
  estilo: estiloPro(FondoPro.tablero),
  titulo: 'Sigue las instrucciones',
  saludo: 'Un algoritmo es una lista de pasos ordenados para resolver un problema. ¡Las recetas, los instructivos y hasta tu camino a la escuela son algoritmos! Vamos a aprender a escribirlos y seguirlos.',
  misionDelTema: 'El mapa del tesoro del reino está escrito en instrucciones. Aprende qué es un algoritmo, ordena secuencias y dibuja diagramas de flujo para encontrar el tesoro.',
  color: _ci,
  insignia: 'Maestro de los Algoritmos',
  emojiInsignia: '📜',
  emojisPanel: const ['🗺️', '➡️', '🔢', '🏁', '💎'],
  videos: const {
    'algoritmos_1': 'assets/videos/algoritmos_que_son.mp4',
    'algoritmos_2': 'assets/videos/algoritmos_secuencias.mp4',
    'algoritmos_3': 'assets/videos/algoritmos_diagramas.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es un algoritmo?',
      emoji: '📜',
      color: _c1,
      intro: 'Todos seguimos algoritmos sin darnos cuenta. ¡Descubre qué los hace buenos!',
      mensajeFinal: '¡Ya sabes qué es un algoritmo y cómo debe ser!',
      pasos: [
        PasoBio('¿Qué es un algoritmo?', TipoPasoBio.explicacion, 'p2_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Algoritmo',
              titulo: '¿Qué es un algoritmo?',
              color: _c1,
              il: ilAlgoritmo,
              textos: const [
                'Un algoritmo es un conjunto finito de pasos, precisos y ordenados para resolver un problema. Todo algoritmo empieza con “Inicio” y termina con “Fin”.',
                'Los programadores escriben algoritmos antes de programar. Después los traducen a un lenguaje de programación para que la computadora los ejecute.',
                'Finito: tiene un número razonable de pasos, solo los necesarios. Preciso: cada paso es claro y no da lugar a dudas. Ordenado: los pasos siguen un orden lógico.',
                'Tu camino a la escuela es un algoritmo: me despierto, me levanto, me baño, me visto, desayuno, me lavo los dientes, tomo el transporte y llego. ¡Si cambias el orden, algo sale mal!',
              ],
              izquierda: const [
                Parte('inicio', 'Inicio', '(el comienzo)', '🟢', Color(0xFF43A047), 'Todo algoritmo comienza con “Inicio”.'),
                Parte('paso', 'Paso preciso', '(claro, sin dudas)', '🎯', Color(0xFF1E88E5), 'Cada paso dice exactamente qué hacer.'),
              ],
              derecha: const [
                Parte('orden', 'Orden', '(uno tras otro)', '🔢', Color(0xFFFFAB19), 'Los pasos se hacen en un orden lógico.'),
                Parte('fin', 'Fin', '(finito: termina)', '🔴', Color(0xFFE53935), 'Todo algoritmo termina: tiene un número limitado de pasos.'),
              ],
              resaltar: const {
                2: {'paso', 'orden', 'fin'},
                3: {'orden'},
              },
              mensajeFinal: '¡Ahora ordena un algoritmo!',
            )),
        PasoBio('Algoritmo para ir a la escuela', TipoPasoBio.juego, 'p2_m1_ord', (a) => ordenar(
              a,
              seccion: '2. Ordena',
              titulo: 'Algoritmo para ir a la escuela',
              color: _c1,
              instruccion: 'Ordena los pasos del algoritmo para ir a la escuela.',
              pasos: const [
                ('⏰', 'Me despierto'),
                ('🛏️', 'Me levanto de la cama'),
                ('🚿', 'Me baño'),
                ('👕', 'Me visto'),
                ('🥣', 'Me desayuno'),
                ('🪥', 'Me lavo los dientes'),
                ('🚌', 'Tomo el transporte'),
              ],
              explicacion: 'Cada paso se hace una sola vez y en orden: es una secuencia.',
              mensajeFinal: '¡Escribiste un algoritmo de la vida diaria!',
            )),
        PasoBio('¿Paso preciso o confuso?', TipoPasoBio.laboratorio, 'p2_m1_clas', (a) => clasificar(
              a,
              seccion: '3. Clasifica',
              titulo: '¿Paso preciso o confuso?',
              color: _c1,
              instruccion: 'Una computadora necesita pasos precisos. Arrastra cada instrucción al grupo correcto.',
              grupos: const [GrupoClasificar('Preciso ✔️', '🎯', Color(0xFF2E7D32)), GrupoClasificar('Confuso ❓', '🌫️', Color(0xFF9E9E9E))],
              items: const [
                ItemClasificar('➡️', 'Avanza 3 pasos', 0, 'Dice exactamente cuánto avanzar.'),
                ItemClasificar('🥛', 'Sirve un vaso de leche', 0, 'Es claro qué hacer.'),
                ItemClasificar('↩️', 'Gira a la derecha', 0, 'No deja dudas.'),
                ItemClasificar('⏲️', 'Hornea 20 minutos', 0, 'Dice cuánto tiempo.'),
                ItemClasificar('🤷', 'Camina un poco', 1, '¿Cuánto es “un poco”?'),
                ItemClasificar('🍲', 'Ponle sal al gusto', 1, 'La computadora no tiene “gusto”.'),
                ItemClasificar('🙃', 'Haz lo de siempre', 1, '¿Qué es “lo de siempre”?'),
                ItemClasificar('🌀', 'Muévete por ahí', 1, 'No dice a dónde.'),
              ],
              mensajeFinal: 'Las computadoras necesitan instrucciones precisas: no adivinan.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p2_m1_video', (a) => video(a,
            clave: 'algoritmos_1', titulo: 'Video: los algoritmos', tema: 'qué es un algoritmo y sus características', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p2_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseRelacionar(const [
                  ('Finito', 'Tiene un número limitado de pasos.'),
                  ('Preciso', 'Cada paso es claro y sin dudas.'),
                  ('Ordenado', 'Los pasos siguen un orden lógico.'),
                  ('Inicio y Fin', 'Marcan dónde empieza y termina.'),
                ], color: _c1, instruccion: 'Relaciona cada característica del algoritmo.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué es un algoritmo?',
                    opciones: ['Pasos finitos, precisos y ordenados para resolver un problema', 'Un tipo de computadora', 'Un juego de mesa'],
                    correcta: 0,
                    explicacion: 'Así lo define el libro de fundamentos de programación.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Conoces las características de un buen algoritmo.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Secuencias',
      emoji: '➡️',
      color: _c2,
      intro: 'Una secuencia son pasos que se hacen uno tras otro, en orden. ¡Guía al robot por el mapa!',
      mensajeFinal: '¡Programaste secuencias perfectas!',
      pasos: [
        PasoBio('La secuencia', TipoPasoBio.explicacion, 'p2_m2_tarj', (a) => tarjetas(
              a,
              seccion: '1. Secuencia',
              titulo: 'Las secuencias',
              color: _c2,
              textoZati: 'En una secuencia, la computadora hace un paso, luego el siguiente, y así hasta el final. ¡El orden lo es todo! Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('¿Qué es?', _c2, Icons.format_list_numbered_rounded, [
                  TarjetaInfo(Icons.looks_one_rounded, 'Uno tras otro', 'Las instrucciones se ejecutan una después de otra, de arriba hacia abajo.'),
                  TarjetaInfo(Icons.repeat_one_rounded, 'Una sola vez', 'En una secuencia simple cada paso se hace una vez.'),
                  TarjetaInfo(Icons.swap_vert_rounded, 'El orden importa', 'Si cambias el orden, el resultado cambia.'),
                ]),
                GrupoTarjetas('Para el robot', Color(0xFFEF6C00), Icons.smart_toy_rounded, [
                  TarjetaInfo(Icons.arrow_upward_rounded, 'Avanzar', 'Se mueve un cuadro hacia donde mira.'),
                  TarjetaInfo(Icons.rotate_left_rounded, 'Girar', 'Gira sin moverse de su lugar.'),
                  TarjetaInfo(Icons.diamond_rounded, 'Recoger', 'Toma la gema del cuadro donde está.'),
                ]),
              ],
              mensajeFinal: '¡Ahora programa secuencias para el robot!',
            )),
        PasoBio('Secuencias con el robot', TipoPasoBio.simulacion, 'p2_m2_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Secuencias con el robot',
              color: _c2,
              mensajeFinal: 'Programaste secuencias: cada bloque se ejecuta uno tras otro.',
              niveles: const [
                NivelRobot(
                  titulo: 'El camino',
                  instruccion: 'Escribe la secuencia para llegar a la meta. Recuerda: el robot gira sin moverse.',
                  mapa: ['S.#', '#.#', '#.M'],
                  logro: 'Tu secuencia llevó al robot paso a paso hasta la meta.',
                  pista: 'Avanza 1, gira a la derecha, avanza 2, gira a la izquierda, avanza 1.',
                ),
                NivelRobot(
                  titulo: 'La gema',
                  instruccion: 'Recoge la gema 💎 en el camino. Usa “recoger gema” cuando el robot esté sobre ella.',
                  mapa: ['S.G.M'],
                  bloques: conGemas,
                  logro: 'Recogiste la gema en el momento correcto de la secuencia.',
                ),
                NivelRobot(
                  titulo: 'Bajando',
                  instruccion: 'El robot mira hacia abajo. Planea con cuidado: ¿hacia dónde queda su derecha?',
                  mapa: ['#S##', '#..#', '##.#', '##GM'],
                  dir: Dir.abajo,
                  bloques: conGemas,
                  logro: 'Pensaste desde el punto de vista del robot. ¡Eso hacen los programadores!',
                  pista: 'Mirando hacia abajo, “girar a la izquierda” hace que mire a la derecha de la pantalla.',
                ),
              ],
            )),
        PasoBio('Robot en 3D', TipoPasoBio.simulacion, 'p2_m2_3d', (a) => SimRobot3D(actividad: a, color: _c2)),
        PasoBio('Video del tema', TipoPasoBio.video, 'p2_m2_video', (a) => video(a,
            clave: 'algoritmos_2', titulo: 'Video: las secuencias', tema: 'cómo se ejecutan las instrucciones en orden', siguiente: '¡A ordenar otra secuencia!')),
        PasoBio('Lávate las manos', TipoPasoBio.juego, 'p2_m2_ord', (a) => ordenar(
              a,
              seccion: '2. Ordena',
              titulo: 'Secuencia: lavarse las manos',
              color: _c2,
              instruccion: 'Ordena la secuencia para lavarse bien las manos.',
              pasos: const [
                ('🚰', 'Abrir la llave'),
                ('💧', 'Mojar las manos'),
                ('🧼', 'Poner jabón'),
                ('👐', 'Tallar 20 segundos'),
                ('🚿', 'Enjuagar'),
                ('🧻', 'Secar las manos'),
              ],
              explicacion: 'Si te enjuagas antes del jabón, ¡el algoritmo no funciona!',
              mensajeFinal: '¡Manos limpias y secuencia correcta!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p2_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'El robot mira a la derecha. Ejecuta: avanzar, girar a la izquierda, avanzar. ¿Hacia dónde mira al final?',
                    opciones: ['Hacia arriba', 'Hacia abajo', 'Hacia la derecha'],
                    correcta: 0,
                    explicacion: 'Mirando a la derecha, su izquierda es hacia arriba.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué es una secuencia?',
                    opciones: ['Instrucciones que se ejecutan una tras otra en orden', 'Instrucciones que se repiten sin fin', 'Un error del programa'],
                    correcta: 0,
                    explicacion: 'El orden es muy importante en una secuencia.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Dominas las secuencias.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Diagramas y pseudocódigo',
      emoji: '🔷',
      color: _c3,
      intro: 'Los programadores dibujan sus algoritmos con diagramas de flujo y los escriben en pseudocódigo. ¡Aprende sus símbolos!',
      mensajeFinal: '¡Ya representas algoritmos como los programadores!',
      pasos: [
        PasoBio('El diagrama de flujo', TipoPasoBio.explicacion, 'p2_m3_exp', (a) => explicacion(
              a,
              seccion: '1. Diagramas',
              titulo: 'El diagrama de flujo',
              color: _c3,
              il: ilDiagrama,
              textos: const [
                'Un diagrama de flujo es una forma de dibujar un algoritmo usando figuras geométricas para cada tipo de paso, unidas con flechas. Tiene un solo inicio y un solo final.',
                'Sirve para ver de un vistazo cómo “fluye” el algoritmo y encontrar errores antes de programar. Otra forma es el pseudocódigo: escribir los pasos con palabras como “leer”, “imprimir”, “si”, “mientras”.',
                'Óvalo: Inicio y Fin. Paralelogramo: entrada o salida de datos (leer, imprimir). Rectángulo: un proceso o cálculo. Rombo: una decisión con dos caminos (sí o no). Flechas: indican el orden.',
                'Este diagrama calcula el área de un rectángulo: lee la base y la altura, multiplica y muestra el resultado. En pseudocódigo sería: inicio, leer base y altura, área = base × altura, imprimir área, fin.',
              ],
              izquierda: const [
                Parte('inicioFin', 'Óvalo', '(inicio y fin)', '⭕', Color(0xFF43A047), 'Marca dónde empieza y dónde termina el algoritmo.'),
                Parte('entrada', 'Paralelogramo', '(entrada / salida)', '▱', Color(0xFF8E24AA), 'Para leer datos o mostrar resultados.'),
                Parte('flecha', 'Flecha', '(dirección)', '⬇️', Color(0xFF455A64), 'Indica qué paso sigue.'),
              ],
              derecha: const [
                Parte('proceso', 'Rectángulo', '(proceso)', '▭', Color(0xFFEF6C00), 'Un cálculo u operación.'),
                Parte('decision', 'Rombo', '(decisión)', '🔷', Color(0xFF00897B), 'Hace una pregunta: según la respuesta, sigue un camino u otro.'),
                Parte('salida', 'Imprimir', '(salida)', '🖨️', Color(0xFF1E88E5), 'Muestra el resultado en la pantalla.'),
              ],
              resaltar: const {
                2: {'inicioFin', 'entrada', 'proceso', 'decision'},
              },
              mensajeFinal: '¡Ahora memoriza los símbolos!',
            )),
        PasoBio('Memorama de símbolos', TipoPasoBio.juego, 'p2_m3_mem', (a) => memorama(
              a,
              titulo: 'Memorama de símbolos',
              color: _c3,
              instruccion: 'Encuentra cada símbolo del diagrama de flujo con su significado.',
              pares: const [
                ('⭕', 'Óvalo', 'Inicio o fin'),
                ('▱', 'Paralelogramo', 'Leer o imprimir datos'),
                ('▭', 'Rectángulo', 'Proceso o cálculo'),
                ('🔷', 'Rombo', 'Decisión: sí o no'),
                ('⬇️', 'Flecha', 'Orden de los pasos'),
                ('📝', 'Pseudocódigo', 'Pasos escritos con palabras'),
              ],
              mensajeFinal: '¡Conoces los símbolos de los diagramas de flujo!',
            )),
        PasoBio('Arma el diagrama', TipoPasoBio.laboratorio, 'p2_m3_ord', (a) => ordenar(
              a,
              seccion: '2. Arma el diagrama',
              titulo: 'Diagrama: área del rectángulo',
              color: _c3,
              instruccion: 'Ordena los pasos del diagrama de flujo que calcula el área de un rectángulo.',
              pasos: const [
                ('⭕', 'Inicio'),
                ('▱', 'Leer base y altura'),
                ('▭', 'área = base × altura'),
                ('▱', 'Imprimir el área'),
                ('⭕', 'Fin'),
              ],
              explicacion: 'Entrada → proceso → salida, entre el inicio y el fin.',
              mensajeFinal: '¡Armaste un diagrama de flujo!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p2_m3_video', (a) => video(a,
            clave: 'algoritmos_3', titulo: 'Video: diagramas de flujo', tema: 'los símbolos del diagrama de flujo y el pseudocódigo', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p2_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseEtiquetar(ilDiagrama, const {'inicioFin': 'Inicio / Fin', 'entrada': 'Entrada', 'proceso': 'Proceso', 'decision': 'Decisión', 'salida': 'Salida'}, color: _c3,
                    instruccion: 'Nombra cada símbolo del diagrama de flujo.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué símbolo se usa para una decisión?',
                    opciones: ['El rombo', 'El óvalo', 'El rectángulo'],
                    correcta: 0,
                    explicacion: 'Del rombo salen dos caminos: sí y no.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué es el pseudocódigo?',
                    opciones: ['Escribir el algoritmo con palabras como “leer”, “imprimir” y “si”', 'Un virus', 'Un dibujo con figuras'],
                    correcta: 0,
                    explicacion: 'Es parecido a un lenguaje de programación, pero en español.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Representas algoritmos con diagramas y pseudocódigo.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El mapa del tesoro',
      emoji: '🏆',
      color: Color(0xFFE65100),
      intro: '¡Último desafío! Sigue y programa las instrucciones del mapa para encontrar el tesoro del reino.',
      mensajeFinal: '¡Encontraste el tesoro del reino!',
      pasos: [
        PasoBio('Las pistas del mapa', TipoPasoBio.reto, 'p2_int_sit', (a) => situacion(
              a,
              titulo: 'Las pistas del mapa',
              color: const Color(0xFFE65100),
              escenas: const [
                EscenaBio(
                  titulo: 'La primera pista',
                  narracion: 'El mapa dice: “Camina hacia donde sale el sol”. El robot no sabe qué hacer.',
                  emojis: '🗺️🤖',
                  pregunta: '¿Cómo mejorarías la instrucción?',
                  opciones: ['Avanza 3 cuadros hacia la derecha', 'Camina feliz', 'Ve por ahí'],
                  correcta: 0,
                  explicacion: 'Una instrucción precisa no deja dudas.',
                ),
                EscenaBio(
                  titulo: 'El orden',
                  narracion: 'Las pistas están revueltas: “abre el cofre”, “camina al árbol”, “cava un hoyo”.',
                  emojis: '🌳⛏️🧰',
                  pregunta: '¿Cuál es el orden correcto?',
                  opciones: ['Caminar al árbol, cavar, abrir el cofre', 'Abrir el cofre, cavar, caminar', 'Cavar, abrir, caminar'],
                  correcta: 0,
                  explicacion: 'Un algoritmo es ordenado.',
                ),
                EscenaBio(
                  titulo: 'El dibujo',
                  narracion: 'Quieres dibujar el algoritmo con figuras para que todos lo entiendan.',
                  emojis: '🔷⬇️',
                  pregunta: '¿Qué usarías?',
                  opciones: ['Un diagrama de flujo', 'Un poema', 'Una foto'],
                  correcta: 0,
                  explicacion: 'Usa óvalos, rectángulos, rombos y flechas.',
                ),
                EscenaBio(
                  titulo: 'El fin',
                  narracion: 'Un amigo escribió un mapa que dice “camina y camina” sin parar nunca.',
                  emojis: '♾️😵',
                  pregunta: '¿Qué característica le falta a ese algoritmo?',
                  opciones: ['Ser finito: debe terminar', 'Ser de colores', 'Ser largo'],
                  correcta: 0,
                  explicacion: 'Todo algoritmo tiene un fin.',
                ),
              ],
              mensajeFinal: '¡Descifraste las pistas! Ahora programa al robot.',
            )),
        PasoBio('Programa el camino al tesoro', TipoPasoBio.simulacion, 'p2_int_robot', (a) => robot(
              a,
              seccion: 'Integradora',
              titulo: 'Camino al tesoro',
              color: const Color(0xFFE65100),
              mensajeFinal: '¡El robot encontró el tesoro con tu secuencia!',
              niveles: const [
                NivelRobot(
                  titulo: 'El tesoro',
                  instruccion: 'Programa la secuencia completa: llega al tesoro 🏁 y recoge la gema 💎 del camino.',
                  mapa: ['S..##', '##.##', '##.GM'],
                  bloques: conGemas,
                  logro: 'Secuencia perfecta: precisa, ordenada y finita.',
                  pista: 'Avanza 2, gira a la derecha, avanza 2, gira a la izquierda, avanza, recoge y avanza.',
                ),
              ],
            )),
        PasoBio('Supercerebro de algoritmos', TipoPasoBio.reto, 'p2_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFE65100),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Con qué empieza y termina todo algoritmo?',
                    opciones: ['Con Inicio y Fin', 'Con un dibujo', 'Con una pregunta'],
                    correcta: 0,
                    explicacion: 'Así se marcan sus límites.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué figura del diagrama de flujo es un proceso?',
                    opciones: ['El rectángulo', 'El rombo', 'El óvalo'],
                    correcta: 0,
                    explicacion: 'Ahí van los cálculos.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué pasa si cambias el orden de una secuencia?',
                    opciones: ['El resultado puede cambiar o fallar', 'Nada', 'Se hace más rápido siempre'],
                    correcta: 0,
                    explicacion: 'En una secuencia el orden importa.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Cuál es una instrucción precisa?',
                    opciones: ['Gira a la izquierda', 'Muévete un poquito', 'Haz algo'],
                    correcta: 0,
                    explicacion: 'No deja dudas.',
                  ),
                ], color: const Color(0xFFE65100), instruccion: 'Demuestra todo lo que sabes de algoritmos.'),
              ],
              mensajeFinal: '¡Ganaste la insignia «Maestro de los Algoritmos»!',
            )),
      ],
    ),
  ],
);
