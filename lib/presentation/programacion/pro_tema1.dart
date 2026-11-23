import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'cazaerrores.dart';
import 'fondos_pro.dart';
import 'ilustraciones_pro.dart';
import 'robot.dart';
import 'robot_ui.dart';

/// Programación · Tema 1: Piensa como programador.

Widget robot(String a, {required String seccion, required String titulo, required Color color, required List<NivelRobot> niveles, required String mensajeFinal}) =>
    ProgramaRobot(actividad: a, seccion: seccion, titulo: titulo, color: color, niveles: niveles, mensajeFinal: mensajeFinal);

Widget cazar(String a, {required String seccion, required String titulo, required Color color, required List<ProgramaConErrores> programas, required String mensajeFinal}) =>
    CazaErrores(actividad: a, seccion: seccion, titulo: titulo, color: color, programas: programas, mensajeFinal: mensajeFinal);

const movimiento = {TipoBloque.avanzar, TipoBloque.izquierda, TipoBloque.derecha};
const conGemas = {TipoBloque.avanzar, TipoBloque.izquierda, TipoBloque.derecha, TipoBloque.recoger};

const _c1 = Color(0xFF7E57C2);
const _c2 = Color(0xFF00897B);
const _c3 = Color(0xFFEF6C00);
const _ci = Color(0xFF5E35B1);

final proTema1 = TemaBio(
  numero: 1,
  mundo: 'pro',
  estilo: estiloPro(FondoPro.castillo),
  titulo: 'Piensa como programador',
  saludo: 'Programar es darle instrucciones a una computadora para que resuelva un problema. ¡Pero antes de programar hay que aprender a pensar como programador: paso a paso y sin saltarse nada!',
  misionDelTema: 'El reino de los algoritmos necesita nuevos programadores. Descubre qué es programar, entrena tu pensamiento computacional y resuelve tus primeros problemas paso a paso.',
  color: _ci,
  insignia: 'Pensador Computacional',
  emojiInsignia: '🧠',
  emojisPanel: const ['💻', '🧩', '🤖', '📜', '💡'],
  videos: const {
    'programacion_1': 'assets/videos/programacion_que_es.mp4',
    'programacion_2': 'assets/videos/programacion_pensamiento.mp4',
    'programacion_3': 'assets/videos/programacion_problemas.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es programar?',
      emoji: '💻',
      color: _c1,
      intro: 'Las computadoras son muy rápidas, pero no piensan solas: hacen exactamente lo que alguien les ordena. ¡Descubre quién les da las órdenes!',
      mensajeFinal: '¡Ya sabes qué es programar!',
      pasos: [
        PasoBio('¿Qué es programar?', TipoPasoBio.explicacion, 'p1_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Programar',
              titulo: '¿Qué es programar?',
              color: _c1,
              il: ilProgramar,
              textos: const [
                'Un programa es un conjunto de instrucciones, escritas en un lenguaje de programación, que una computadora sigue para resolver un problema o hacer una tarea. Programar es crear esas instrucciones.',
                'Los programas hacen funcionar los videojuegos, las apps del celular, los semáforos y hasta las lavadoras. Sin programas, la computadora no sabría qué hacer.',
                'Primero el programador piensa los pasos para resolver el problema: eso es un algoritmo. Luego lo escribe en un lenguaje que la computadora entiende, como Scratch, Python o Java. Al final la computadora lo ejecuta.',
                'Un buen programa es claro (fácil de entender), conciso (sin pasos de sobra) y eficaz (cumple su objetivo). ¡Así lo hacen los programadores de verdad!',
              ],
              izquierda: const [
                Parte('programador', 'Programador', '(quien da las órdenes)', '🧑‍💻', _c1, 'Es la persona que piensa cómo resolver el problema y escribe el programa.'),
                Parte('programa', 'Programa', '(instrucciones)', '📄', Color(0xFF4C97FF), 'Las instrucciones escritas en un lenguaje de programación.'),
              ],
              derecha: const [
                Parte('algoritmo', 'Algoritmo', '(los pasos)', '📜', Color(0xFFFFAB19), 'La lista ordenada de pasos para resolver el problema.'),
                Parte('resultado', 'Ejecución', '(la computadora lo hace)', '🤖', Color(0xFF59C059), 'La computadora sigue el programa, paso por paso, muy rápido.'),
              ],
              resaltar: const {
                1: {'resultado'},
                2: {'algoritmo', 'programa'},
              },
              mensajeFinal: '¡Ahora descubre dónde hay programas!',
            )),
        PasoBio('¿Dónde hay programas?', TipoPasoBio.explicacion, 'p1_m1_tarj', (a) => tarjetas(
              a,
              seccion: '2. A tu alrededor',
              titulo: '¿Dónde hay programas?',
              color: _c1,
              textoZati: 'Los programas están en muchos aparatos que usas todos los días. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('En casa', Color(0xFFEF6C00), Icons.home_rounded, [
                  TarjetaInfo(Icons.tv_rounded, 'Televisión', 'Un programa cambia de canal cuando presionas el control.'),
                  TarjetaInfo(Icons.local_laundry_service_rounded, 'Lavadora', 'Su programa decide cuánto tiempo lavar y enjuagar.'),
                  TarjetaInfo(Icons.microwave_rounded, 'Microondas', 'Cuenta el tiempo y se apaga solo.'),
                ]),
                GrupoTarjetas('En tu mano', _c1, Icons.smartphone_rounded, [
                  TarjetaInfo(Icons.sports_esports_rounded, 'Videojuegos', 'Cada movimiento del personaje está programado.'),
                  TarjetaInfo(Icons.apps_rounded, 'Apps', 'Mapas, mensajes y cámara son programas.'),
                  TarjetaInfo(Icons.calculate_rounded, 'Calculadora', 'Sigue instrucciones para hacer operaciones.'),
                ]),
                GrupoTarjetas('En la ciudad', Color(0xFF00897B), Icons.location_city_rounded, [
                  TarjetaInfo(Icons.traffic_rounded, 'Semáforos', 'Un programa cambia las luces a tiempo.'),
                  TarjetaInfo(Icons.atm_rounded, 'Cajero', 'Revisa tu tarjeta y entrega el dinero.'),
                  TarjetaInfo(Icons.elevator_rounded, 'Elevador', 'Decide a qué piso ir primero.'),
                ]),
              ],
              mensajeFinal: '¡Hay programas en todas partes!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p1_m1_video', (a) => video(a,
            clave: 'programacion_1', titulo: 'Video: ¿qué es programar?', tema: 'qué es un programa y qué hace un programador', siguiente: '¡A clasificar!')),
        PasoBio('¿Sigue un programa?', TipoPasoBio.laboratorio, 'p1_m1_clas', (a) => clasificar(
              a,
              seccion: '3. Clasifica',
              titulo: '¿Sigue un programa?',
              color: _c1,
              instruccion: 'Arrastra cada objeto al grupo correcto.',
              grupos: const [GrupoClasificar('Sigue un programa', '💻', _c1), GrupoClasificar('No tiene programa', '🪨', Color(0xFF8D6E63))],
              items: const [
                ItemClasificar('📱', 'Celular', 0, 'Todo en el celular funciona con programas.'),
                ItemClasificar('🚦', 'Semáforo', 0, 'Un programa controla sus luces.'),
                ItemClasificar('🎮', 'Videoconsola', 0, 'Los juegos son programas.'),
                ItemClasificar('🤖', 'Robot', 0, 'Un robot sigue su programa.'),
                ItemClasificar('✏️', 'Lápiz', 1, 'El lápiz no tiene circuitos ni programas.'),
                ItemClasificar('🪑', 'Silla', 1, 'Una silla no sigue instrucciones.'),
                ItemClasificar('📕', 'Libro de papel', 1, 'El libro de papel no tiene programa.'),
                ItemClasificar('⚽', 'Balón', 1, 'Un balón no tiene programa.'),
              ],
              mensajeFinal: 'Los aparatos electrónicos siguen programas que alguien escribió.',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p1_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilProgramar, const {'programador': 'Programador', 'algoritmo': 'Algoritmo', 'programa': 'Programa', 'resultado': 'Ejecución'}, color: _c1),
                faseRelacionar(const [
                  ('Programa', 'Instrucciones que sigue la computadora.'),
                  ('Programador', 'Persona que escribe el programa.'),
                  ('Lenguaje de programación', 'Reglas para escribir instrucciones a la computadora.'),
                  ('Ejecutar', 'Cuando la computadora sigue el programa.'),
                ], color: _c1, instruccion: 'Relaciona cada palabra con su significado.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Puede una computadora hacer algo que nadie le programó?',
                    opciones: ['No, solo sigue las instrucciones de su programa', 'Sí, piensa sola', 'Solo si está encendida mucho tiempo'],
                    correcta: 0,
                    explicacion: 'La computadora hace exactamente lo que dice su programa.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Sabes qué es un programa y qué hace un programador.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Pensamiento computacional',
      emoji: '🧩',
      color: _c2,
      intro: 'Los programadores usan una forma especial de pensar para resolver problemas: el pensamiento computacional. ¡Conoce sus 4 superpoderes!',
      mensajeFinal: '¡Ya piensas como programador!',
      pasos: [
        PasoBio('Los 4 superpoderes', TipoPasoBio.explicacion, 'p1_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Pensamiento computacional',
              titulo: 'Pensamiento computacional',
              color: _c2,
              il: ilPensamiento,
              textos: const [
                'El pensamiento computacional es una forma de resolver problemas como lo haría un programador. Se usa en la computación, pero también en la vida diaria.',
                'Sirve para resolver problemas grandes y difíciles: los partes, encuentras lo que se repite, te quedas con lo importante y escribes los pasos.',
                'Descomponer: dividir un problema grande en partes pequeñas. Patrones: encontrar lo que se repite. Abstraer: quitar los detalles que no importan. Algoritmo: escribir los pasos en orden.',
                'Para organizar una fiesta: la descompones (comida, música, invitaciones), notas patrones (cada invitación lleva lo mismo), ignoras detalles (el color del lápiz) y haces una lista de pasos.',
              ],
              izquierda: const [
                Parte('descomposicion', 'Descomponer', '(partir el problema)', '🧩', Color(0xFF1E88E5), 'Un problema grande se divide en problemas pequeños, más fáciles de resolver.'),
                Parte('abstraccion', 'Abstraer', '(lo importante)', '🗺️', Color(0xFF43A047), 'Quedarse con lo importante, como un mapa que solo muestra las calles.'),
              ],
              derecha: const [
                Parte('patrones', 'Patrones', '(lo que se repite)', '🔁', Color(0xFFEC407A), 'Encontrar lo que se repite ayuda a resolver más rápido.'),
                Parte('algoritmo', 'Algoritmo', '(los pasos)', '📜', Color(0xFFFFAB19), 'Escribir la solución como pasos ordenados.'),
              ],
              resaltar: const {
                2: {'descomposicion', 'patrones', 'abstraccion', 'algoritmo'},
              },
              mensajeFinal: '¡Ahora usa tus superpoderes!',
            )),
        PasoBio('¿Qué superpoder es?', TipoPasoBio.laboratorio, 'p1_m2_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Qué superpoder usas?',
              color: _c2,
              instruccion: 'Arrastra cada ejemplo al superpoder del pensamiento computacional que usa.',
              grupos: const [
                GrupoClasificar('Descomponer', '🧩', Color(0xFF1E88E5)),
                GrupoClasificar('Patrones', '🔁', Color(0xFFEC407A)),
                GrupoClasificar('Abstraer', '🗺️', Color(0xFF43A047)),
                GrupoClasificar('Algoritmo', '📜', Color(0xFFFFAB19)),
              ],
              items: const [
                ItemClasificar('🧹', 'Dividir la limpieza del salón por equipos', 0, 'Partes un problema grande en tareas pequeñas.'),
                ItemClasificar('🍕', 'Separar una pizza en rebanadas para repartir', 0, 'Partes el todo en partes.'),
                ItemClasificar('🎵', 'Notar que el coro de la canción se repite', 1, 'Encuentras lo que se repite.'),
                ItemClasificar('🔢', 'Ver que 2, 4, 6, 8 aumenta de 2 en 2', 1, 'Descubres un patrón.'),
                ItemClasificar('🚇', 'Usar el mapa del metro sin dibujar los edificios', 2, 'Solo importan las líneas y estaciones.'),
                ItemClasificar('⚽', 'Para jugar fútbol no importa el color de los tenis', 2, 'Ignoras detalles que no cambian el problema.'),
                ItemClasificar('🍳', 'Escribir la receta paso a paso', 3, 'Una receta es un algoritmo.'),
                ItemClasificar('🧭', 'Dar instrucciones para llegar a la escuela', 3, 'Son pasos ordenados.'),
              ],
              mensajeFinal: '¡Usas los 4 superpoderes del pensamiento computacional!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p1_m2_video', (a) => video(a,
            clave: 'programacion_2', titulo: 'Video: pensamiento computacional', tema: 'los cuatro pilares del pensamiento computacional', siguiente: '¡A jugar memorama!')),
        PasoBio('Memorama de superpoderes', TipoPasoBio.juego, 'p1_m2_mem', (a) => memorama(
              a,
              titulo: 'Memorama del programador',
              color: _c2,
              instruccion: 'Encuentra cada palabra con su significado.',
              pares: const [
                ('🧩', 'Descomponer', 'Partir en partes pequeñas'),
                ('🔁', 'Patrón', 'Algo que se repite'),
                ('🗺️', 'Abstraer', 'Quedarse con lo importante'),
                ('📜', 'Algoritmo', 'Pasos en orden'),
                ('💻', 'Programa', 'Instrucciones para la computadora'),
                ('🐞', 'Error', 'Algo que falla en el programa'),
              ],
              mensajeFinal: '¡Memoria de programador!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p1_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseEtiquetar(ilPensamiento, const {'descomposicion': 'Descomponer', 'patrones': 'Patrones', 'abstraccion': 'Abstraer', 'algoritmo': 'Algoritmo'}, color: _c2,
                    instruccion: 'Nombra cada superpoder del pensamiento computacional.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Vas a hacer un álbum de 30 páginas y lo divides en 5 partes con un compañero. ¿Qué superpoder usas?',
                    opciones: ['Descomponer', 'Abstraer', 'Patrones'],
                    correcta: 0,
                    explicacion: 'Partes un problema grande en partes pequeñas.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Conoces el pensamiento computacional.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Resuelve paso a paso',
      emoji: '🪜',
      color: _c3,
      intro: 'Los programadores resuelven los problemas siguiendo unos pasos. ¡Aprende el método y programa a tu primer robot!',
      mensajeFinal: '¡Resolviste tus primeros problemas como programador!',
      pasos: [
        PasoBio('Entrada, proceso y salida', TipoPasoBio.explicacion, 'p1_m3_exp', (a) => explicacion(
              a,
              seccion: '1. Analizar',
              titulo: 'Analiza el problema',
              color: _c3,
              il: ilEntradaProceso,
              textos: const [
                'Antes de programar hay que analizar el problema: ¿qué datos tengo (entrada)?, ¿qué tengo que hacer con ellos (proceso)? y ¿qué resultado quiero (salida)?',
                'Así sabemos exactamente qué debe hacer el programa. Por ejemplo, para calcular el área de un rectángulo necesitamos saber su base y su altura.',
                'Entrada: base = 5 y altura = 3. Proceso: área = base × altura. Salida: el programa muestra “Área = 15”. Después se diseña el algoritmo, se escribe el programa, se prueba y se corrige.',
                'Una calculadora, un videojuego o una app de mapas siempre reciben datos, los procesan y muestran un resultado.',
              ],
              izquierda: const [
                Parte('entrada', 'Entrada', '(los datos)', '⌨️', Color(0xFF8E24AA), 'La información que necesita el programa: aquí, la base y la altura.'),
                Parte('rectangulo', 'El problema', '(rectángulo de 5 × 3)', '📐', Color(0xFF0277BD), 'Queremos saber cuántos cuadritos caben en el rectángulo.'),
              ],
              derecha: const [
                Parte('proceso', 'Proceso', '(lo que se calcula)', '⚙️', Color(0xFFEF6C00), 'Las operaciones con los datos: multiplicar la base por la altura.'),
                Parte('salida', 'Salida', '(el resultado)', '🖥️', Color(0xFF1E88E5), 'Lo que el programa muestra: “Área = 15”.'),
              ],
              resaltar: const {
                1: {'entrada', 'salida'},
                2: {'proceso'},
              },
              mensajeFinal: '¡Ahora ordena los pasos para resolver un problema!',
            )),
        PasoBio('Los pasos del programador', TipoPasoBio.juego, 'p1_m3_ord', (a) => ordenar(
              a,
              seccion: '2. El método',
              titulo: 'Los pasos del programador',
              color: _c3,
              instruccion: 'Ordena los pasos que sigue un programador para resolver un problema.',
              pasos: const [
                ('🔍', 'Analizar el problema'),
                ('📜', 'Diseñar el algoritmo'),
                ('⌨️', 'Escribir el programa'),
                ('▶️', 'Ejecutar el programa'),
                ('🐞', 'Probar y corregir errores'),
                ('📝', 'Documentar'),
              ],
              explicacion: 'Primero se piensa, después se programa, y al final se prueba y se explica cómo funciona.',
              mensajeFinal: '¡Conoces el método del programador!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p1_m3_video', (a) => video(a,
            clave: 'programacion_3', titulo: 'Video: resolver problemas', tema: 'cómo resolver problemas paso a paso', siguiente: '¡Programa tu primer robot!')),
        PasoBio('Tu primer robot', TipoPasoBio.simulacion, 'p1_m3_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Tu primer robot',
              color: _c3,
              mensajeFinal: '¡Diste tus primeras instrucciones a un robot! Una computadora hace exactamente lo que le dices.',
              niveles: const [
                NivelRobot(
                  titulo: 'Hasta la meta',
                  instruccion: 'Lleva al robot a la bandera 🏁. Toca “avanzar” para agregar bloques al programa y luego presiona “Ejecutar”.',
                  mapa: ['S...M'],
                  logro: 'El robot siguió tus instrucciones una por una.',
                  pista: 'Cuenta cuántos cuadros hay hasta la meta.',
                ),
                NivelRobot(
                  titulo: 'Da la vuelta',
                  instruccion: 'Ahora hay que girar. Fíjate hacia dónde mira el robot (la flecha naranja) antes de girar.',
                  mapa: ['S..#', '##.#', '##.M'],
                  logro: 'Usaste giros: la computadora necesita instrucciones muy precisas.',
                  pista: 'Avanza 2, gira a la derecha, avanza 2, gira a la izquierda y avanza 1.',
                ),
              ],
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p1_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseEtiquetar(ilEntradaProceso, const {'entrada': 'Entrada', 'proceso': 'Proceso', 'salida': 'Salida'}, color: _c3),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Un programa suma tus calificaciones y muestra el promedio. ¿Qué es la salida?',
                    opciones: ['El promedio que aparece en la pantalla', 'Las calificaciones', 'La suma'],
                    correcta: 0,
                    explicacion: 'La salida es el resultado que se muestra.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué se hace primero para resolver un problema?',
                    opciones: ['Analizar el problema', 'Escribir el programa', 'Corregir errores'],
                    correcta: 0,
                    explicacion: 'Primero hay que entender qué se necesita.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Sabes analizar un problema y resolverlo paso a paso.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El robot cocinero',
      emoji: '🏆',
      color: Color(0xFFC2185B),
      intro: '¡Último desafío! Ayuda a programar al robot cocinero del castillo para que prepare un sándwich.',
      mensajeFinal: '¡El robot cocinero preparó el sándwich!',
      pasos: [
        PasoBio('El robot cocinero', TipoPasoBio.reto, 'p1_int_sit', (a) => situacion(
              a,
              titulo: 'El robot cocinero',
              color: const Color(0xFFC2185B),
              escenas: const [
                EscenaBio(
                  titulo: 'La orden',
                  narracion: 'El rey le dice al robot: “Hazme un sándwich”. El robot se queda quieto sin saber qué hacer.',
                  emojis: '🤴🤖',
                  pregunta: '¿Por qué no hace nada el robot?',
                  opciones: ['Porque necesita instrucciones paso a paso', 'Porque está cansado', 'Porque no le gustan los sándwiches'],
                  correcta: 0,
                  explicacion: 'Las computadoras necesitan un algoritmo: pasos claros y ordenados.',
                ),
                EscenaBio(
                  titulo: 'Descomponer',
                  narracion: 'Decides partir el problema: pan, ingredientes y armado.',
                  emojis: '🍞🧀🥬',
                  pregunta: '¿Qué superpoder usaste?',
                  opciones: ['Descomponer', 'Abstraer', 'Patrones'],
                  correcta: 0,
                  explicacion: 'Dividiste un problema grande en partes pequeñas.',
                ),
                EscenaBio(
                  titulo: 'Instrucción precisa',
                  narracion: 'El robot debe poner el jamón. Le escribes una instrucción.',
                  emojis: '🍖🤖',
                  pregunta: '¿Cuál instrucción es más precisa?',
                  opciones: ['Pon una rebanada de jamón sobre el pan', 'Pon algo rico', 'Haz lo que quieras con el jamón'],
                  correcta: 0,
                  explicacion: 'Un algoritmo debe ser preciso: sin dudas.',
                ),
                EscenaBio(
                  titulo: 'El orden',
                  narracion: 'El robot cerró el sándwich antes de poner el queso.',
                  emojis: '🥪😕',
                  pregunta: '¿Qué falló?',
                  opciones: ['El orden de los pasos', 'El color del pan', 'El tamaño del robot'],
                  correcta: 0,
                  explicacion: 'Un algoritmo debe ser ordenado.',
                ),
                EscenaBio(
                  titulo: '¡Listo!',
                  narracion: 'Corregiste el orden y probaste otra vez. ¡El sándwich quedó perfecto!',
                  emojis: '🥪🎉',
                  pregunta: '¿Qué hiciste al final como buen programador?',
                  opciones: ['Probar y corregir', 'Rendirme', 'Apagar al robot'],
                  correcta: 0,
                  explicacion: 'Probar y corregir es parte del trabajo del programador.',
                ),
              ],
              mensajeFinal: '¡El rey disfrutó su sándwich!',
            )),
        PasoBio('Supercerebro del programador', TipoPasoBio.reto, 'p1_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFC2185B),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué es un programa?',
                    opciones: ['Instrucciones que sigue una computadora', 'Un dibujo', 'Una computadora nueva'],
                    correcta: 0,
                    explicacion: 'Se escribe en un lenguaje de programación.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué superpoder es quedarse solo con lo importante?',
                    opciones: ['Abstraer', 'Descomponer', 'Patrones'],
                    correcta: 0,
                    explicacion: 'Abstraer quita los detalles que no importan.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'En “área = base × altura”, ¿qué parte es el proceso?',
                    opciones: ['Multiplicar base por altura', 'Leer la base', 'Mostrar el área'],
                    correcta: 0,
                    explicacion: 'El proceso son los cálculos.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Cómo es un buen programa?',
                    opciones: ['Claro, conciso y eficaz', 'Muy largo y confuso', 'Con muchos errores'],
                    correcta: 0,
                    explicacion: 'Fácil de entender, sin pasos de sobra y que funcione.',
                  ),
                ], color: const Color(0xFFC2185B), instruccion: 'Demuestra todo lo que sabes.'),
              ],
              mensajeFinal: '¡Eres un Pensador Computacional!',
            )),
      ],
    ),
  ],
);
