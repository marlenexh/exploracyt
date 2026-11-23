import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_pro.dart';
import 'ilustraciones_pro.dart';
import 'pro_tema1.dart' show robot;
import 'robot.dart';

/// Programación · Tema 4: Repite y decide (condiciones y ciclos).

const _c1 = Color(0xFF00897B);
const _c2 = Color(0xFFFFAB19);
const _c3 = Color(0xFF7E57C2);
const _ci = Color(0xFF00838F);


final proTema4 = TemaBio(
  numero: 4,
  mundo: 'pro',
  estilo: estiloPro(FondoPro.bucles),
  titulo: 'Repite y decide',
  saludo: 'Los programas pueden tomar decisiones (“si pasa esto, haz aquello”) y repetir instrucciones sin escribirlas muchas veces. ¡Con eso tus programas se vuelven inteligentes y cortos!',
  misionDelTema: 'El laberinto giratorio del reino cambia de forma. Aprende a usar condiciones y ciclos para que tu robot decida solo y repita sin cansarse.',
  color: _ci,
  insignia: 'Experto en Ciclos y Decisiones',
  emojiInsignia: '🔁',
  emojisPanel: const ['🔀', '🔄', '❓', '✅', '🔁'],
  videos: const {
    'repite_1': 'assets/videos/repite_decisiones.mp4',
    'repite_2': 'assets/videos/repite_ciclos.mp4',
    'repite_3': 'assets/videos/repite_combina.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Decisiones: si… si no',
      emoji: '🔀',
      color: _c1,
      intro: 'Todos los días tomas decisiones: si llueve, llevas paraguas. ¡Los programas también deciden!',
      mensajeFinal: '¡Tus programas ya toman decisiones!',
      pasos: [
        PasoBio('Las decisiones', TipoPasoBio.explicacion, 'p4_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Decisiones',
              titulo: 'Si… entonces… si no',
              color: _c1,
              il: ilDecision,
              textos: const [
                'Una estructura de decisión (o selectiva) revisa una condición: algo que puede ser verdadero o falso. Si es verdadera, hace unas instrucciones; si no, puede hacer otras.',
                'Sirve para que el programa reaccione a lo que pasa: un videojuego decide si ganaste, una app decide si tu contraseña es correcta.',
                'En pseudocódigo se escribe: si (calificación ≥ 70) imprimir “Aprobado”, si no imprimir “Reprobado”. En el diagrama de flujo, la condición va en un rombo con dos caminos: sí y no.',
                'Si el semáforo está en rojo, entonces me detengo; si no, avanzo. ¡Tú usas decisiones todo el tiempo!',
              ],
              izquierda: const [
                Parte('condicion', 'Condición', '(¿verdadero o falso?)', '❓', Color(0xFF00897B), 'La pregunta que revisa el programa: ¿la calificación es 70 o más?'),
                Parte('verdadero', 'Si es verdadera', '(camino “sí”)', '✅', Color(0xFF43A047), 'Instrucciones que se hacen cuando se cumple la condición.'),
              ],
              derecha: const [
                Parte('falso', 'Si no', '(camino “no”)', '❌', Color(0xFFE53935), 'Instrucciones que se hacen cuando NO se cumple.'),
                Parte('ejemplo', 'Ejemplo', '(85 o 60)', '📝', Color(0xFF7E57C2), 'Con 85 imprime “Aprobado”; con 60, “Reprobado”.'),
              ],
              resaltar: const {
                1: {'verdadero', 'falso'},
                2: {'condicion'},
              },
              mensajeFinal: '¡Ahora clasifica decisiones!',
            )),
        PasoBio('¿Verdadero o falso?', TipoPasoBio.laboratorio, 'p4_m1_clas', (a) => clasificar(
              a,
              seccion: '2. Condiciones',
              titulo: '¿La condición se cumple?',
              color: _c1,
              instruccion: 'Lee cada condición con su dato y decide si es verdadera o falsa.',
              grupos: const [GrupoClasificar('Verdadera ✅', '✅', Color(0xFF43A047)), GrupoClasificar('Falsa ❌', '❌', Color(0xFFE53935))],
              items: const [
                ItemClasificar('📝', 'calificación ≥ 70, si calificación = 85', 0, '85 es mayor que 70.'),
                ItemClasificar('🌡️', 'temperatura > 30, si temperatura = 35', 0, '35 es mayor que 30.'),
                ItemClasificar('🔑', 'contraseña = “sol”, si escribiste “sol”', 0, 'Son iguales.'),
                ItemClasificar('🎮', 'vidas = 0, si vidas = 0', 0, 'Se cumple: fin del juego.'),
                ItemClasificar('📝', 'calificación ≥ 70, si calificación = 60', 1, '60 es menor que 70.'),
                ItemClasificar('🌧️', 'está lloviendo, si hay sol', 1, 'No se cumple.'),
                ItemClasificar('🔢', 'número < 5, si número = 9', 1, '9 no es menor que 5.'),
                ItemClasificar('🎮', 'puntos = 10, si puntos = 7', 1, 'Todavía no llega a 10.'),
              ],
              mensajeFinal: 'Las condiciones siempre son verdaderas o falsas.',
            )),
        PasoBio('El robot decide', TipoPasoBio.simulacion, 'p4_m1_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'El robot decide',
              color: _c1,
              mensajeFinal: 'Tu robot usó condiciones para decidir qué hacer en cada cuadro.',
              niveles: const [
                NivelRobot(
                  titulo: '¿Hay gema?',
                  instruccion: 'Hay gemas en algunos cuadros. Usa “repetir” con “si hay una gema aquí → recoger gema” dentro. Máximo 4 bloques.',
                  mapa: ['SG.G.GM'],
                  bloques: {TipoBloque.avanzar, TipoBloque.recoger, TipoBloque.repetir, TipoBloque.si},
                  condiciones: [Cond.gema, Cond.camino],
                  maxBloques: 4,
                  logro: 'El robot revisa cada cuadro y solo recoge donde hay gema.',
                  pista: 'repetir 6 veces: avanzar y luego si hay una gema aquí, recoger gema.',
                ),
                NivelRobot(
                  titulo: '¿Hay camino?',
                  instruccion: 'Usa “si… si no”: si hay camino adelante, avanza; si no, gira a la derecha. Repítelo las veces necesarias. Máximo 4 bloques.',
                  mapa: ['S..#', '##.#', '##.#', 'M..#'],
                  bloques: {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.repetir, TipoBloque.siSino},
                  condiciones: [Cond.camino, Cond.pared],
                  maxBloques: 4,
                  logro: 'El robot decidió solo cuándo avanzar y cuándo girar.',
                  pista: 'repetir 9 veces: si hay camino adelante → avanzar, si no → girar a la derecha.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p4_m1_video', (a) => video(a,
            clave: 'repite_1', titulo: 'Video: las decisiones', tema: 'estructuras de decisión si… entonces… si no', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p4_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilDecision, const {'condicion': 'Condición', 'verdadero': 'Camino “sí”', 'falso': 'Camino “no”'}, color: _c1),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'si (puntos ≥ 10) imprimir “Ganaste” si no imprimir “Sigue jugando”. Si puntos = 12, ¿qué se imprime?',
                    opciones: ['Ganaste', 'Sigue jugando', 'Nada'],
                    correcta: 0,
                    explicacion: '12 es mayor o igual que 10: la condición es verdadera.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Sabes usar decisiones en tus programas.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Ciclos: repetir',
      emoji: '🔁',
      color: _c2,
      intro: 'Si una instrucción se repite, ¡no la escribas muchas veces! Usa un ciclo.',
      mensajeFinal: '¡Tus programas son cortos y poderosos!',
      pasos: [
        PasoBio('Los ciclos', TipoPasoBio.explicacion, 'p4_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Ciclos',
              titulo: 'Los ciclos (repetir y mientras)',
              color: _c2,
              il: ilCiclo,
              textos: const [
                'Un ciclo (o estructura de repetición) ejecuta varias veces las mismas instrucciones. “Repetir” lo hace un número fijo de veces; “mientras” lo hace mientras una condición sea verdadera.',
                'Los ciclos hacen los programas más cortos y fáciles de cambiar. ¡Imagina escribir 100 veces “avanzar”!',
                'En el algoritmo para comprar zapatos: mientras no he comprado zapatos, elijo unos, me los pruebo y si me quedan los compro. Cuando la condición ya no se cumple, el ciclo termina.',
                'Dar 10 vueltas a la cancha, lavar todos los platos o cepillar cada diente son ciclos de la vida diaria.',
              ],
              izquierda: const [
                Parte('regreso', 'Regreso', '(otra vuelta)', '🔁', Color(0xFF7E57C2), 'Después de las instrucciones, regresa a revisar la condición.'),
                Parte('cuerpo', 'Instrucciones', '(lo que se repite)', '📦', Color(0xFFEF6C00), 'Los pasos que se hacen en cada vuelta.'),
              ],
              derecha: const [
                Parte('condicion', 'Condición', '(¿sigo?)', '❓', Color(0xFF00897B), 'Se revisa antes de cada vuelta. Si es verdadera, se repite.'),
                Parte('salida', 'Salida del ciclo', '(cuando ya no se cumple)', '🚪', Color(0xFF1E88E5), 'Cuando ya compraste los zapatos, sales del ciclo.'),
              ],
              resaltar: const {
                1: {'cuerpo'},
                2: {'condicion', 'regreso', 'salida'},
              },
              mensajeFinal: '¡Ahora programa con ciclos!',
            )),
        PasoBio('Repite y ahorra bloques', TipoPasoBio.simulacion, 'p4_m2_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Repite y ahorra bloques',
              color: _c2,
              mensajeFinal: 'Con “repetir” tus programas son concisos: menos bloques, mismo resultado.',
              niveles: [
                const NivelRobot(
                  titulo: 'El pasillo largo',
                  instruccion: 'Llega a la meta usando máximo 2 bloques. Pista: “repetir” y toca el número para cambiar las veces.',
                  mapa: ['S......M'],
                  bloques: {TipoBloque.avanzar, TipoBloque.repetir},
                  maxBloques: 2,
                  logro: 'Un ciclo reemplazó 7 bloques.',
                ),
                const NivelRobot(
                  titulo: 'Escalera de piedra',
                  instruccion: 'Encuentra el patrón que se repite y úsalo dentro de “repetir”. Máximo 7 bloques.',
                  mapa: ['S.####', '#..###', '##..##', '###..M'],
                  bloques: {TipoBloque.avanzar, TipoBloque.izquierda, TipoBloque.derecha, TipoBloque.repetir},
                  maxBloques: 7,
                  logro: 'Encontraste el patrón de la escalera.',
                  pista: 'repetir 3 veces: avanzar, girar a la derecha, avanzar, girar a la izquierda. Después avanza 2.',
                ),
                NivelRobot(
                  titulo: 'Cuadrado con repetir',
                  instruccion: 'Dibuja el cuadrado con máximo 4 bloques.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.arriba,
                  bloques: const {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.repetir},
                  maxBloques: 4,
                  dibujo: figura(const [(0, 3), (0, 1), (2, 1), (2, 3), (0, 3)]),
                  logro: '¡El mismo cuadrado con solo 4 bloques!',
                  pista: 'repetir 4 veces: avanzar, avanzar, girar a la derecha.',
                ).conInicio(0, 3),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p4_m2_video', (a) => video(a,
            clave: 'repite_2', titulo: 'Video: los ciclos', tema: 'cómo repetir instrucciones con repetir y mientras', siguiente: '¡Ordena el ciclo de los zapatos!')),
        PasoBio('El ciclo de los zapatos', TipoPasoBio.juego, 'p4_m2_ord', (a) => ordenar(
              a,
              seccion: '2. Ordena',
              titulo: 'Algoritmo para comprar zapatos',
              color: _c2,
              instruccion: 'Ordena el algoritmo con ciclo para comprar zapatos.',
              pasos: const [
                ('🟢', 'Inicio'),
                ('🔄', 'Mientras no he comprado zapatos:'),
                ('👟', 'Elijo unos zapatos'),
                ('🦶', 'Me los pruebo'),
                ('🛍️', 'Si me quedan, los compro'),
                ('🔴', 'Fin'),
              ],
              explicacion: 'Los pasos dentro del “mientras” se repiten hasta comprar los zapatos.',
              mensajeFinal: '¡Ordenaste un algoritmo con ciclo!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p4_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseEtiquetar(ilCiclo, const {'condicion': 'Condición', 'cuerpo': 'Lo que se repite', 'regreso': 'Regreso', 'salida': 'Salida'}, color: _c2),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Cuántas veces se imprime “Hola” con: repetir 3 veces { imprimir “Hola” }?',
                    opciones: ['3', '1', '30'],
                    correcta: 0,
                    explicacion: 'El ciclo da 3 vueltas.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Sabes usar ciclos.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Combina ciclos y decisiones',
      emoji: '🧠',
      color: _c3,
      intro: 'Los programas más inteligentes combinan ciclos y decisiones. ¡Haz que el robot encuentre el camino solo!',
      mensajeFinal: '¡Tu robot es autónomo!',
      pasos: [
        PasoBio('¿Ciclo o decisión?', TipoPasoBio.laboratorio, 'p4_m3_clas', (a) => clasificar(
              a,
              seccion: '1. Clasifica',
              titulo: '¿Ciclo o decisión?',
              color: _c3,
              instruccion: 'Arrastra cada situación al tipo de estructura que necesita.',
              grupos: const [GrupoClasificar('Ciclo 🔁', '🔁', Color(0xFFFFAB19)), GrupoClasificar('Decisión 🔀', '🔀', Color(0xFF00897B))],
              items: const [
                ItemClasificar('🏃', 'Dar 10 vueltas a la cancha', 0, 'Se repite 10 veces.'),
                ItemClasificar('🍽️', 'Lavar platos mientras haya sucios', 0, 'Se repite mientras se cumpla.'),
                ItemClasificar('🎵', 'Cantar el coro 3 veces', 0, 'Se repite.'),
                ItemClasificar('🌧️', 'Si llueve, llevar paraguas', 1, 'Depende de una condición.'),
                ItemClasificar('🚦', 'Si el semáforo está en rojo, detenerse', 1, 'Es una decisión.'),
                ItemClasificar('🔑', 'Si la contraseña es correcta, entrar', 1, 'Decide si deja entrar.'),
              ],
              mensajeFinal: 'Ciclos: repetir. Decisiones: elegir.',
            )),
        PasoBio('El robot autónomo', TipoPasoBio.simulacion, 'p4_m3_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'El robot autónomo',
              color: _c3,
              mensajeFinal: 'Combinaste “mientras” y “si”: tu robot llega solo a la meta, sin que cuentes los pasos.',
              niveles: const [
                NivelRobot(
                  titulo: 'Mientras no llegue',
                  instruccion: 'Usa “mientras no he llegado a la meta → avanzar”. ¡No necesitas contar los cuadros! Máximo 2 bloques.',
                  mapa: ['S.......M'],
                  bloques: {TipoBloque.avanzar, TipoBloque.mientras},
                  condiciones: [Cond.noMeta, Cond.camino],
                  maxBloques: 2,
                  logro: 'El ciclo “mientras” se detuvo solo al llegar.',
                ),
                NivelRobot(
                  titulo: 'Recolector automático',
                  instruccion: 'Mientras no llegues a la meta: avanza y, si hay una gema, recógela. Máximo 4 bloques.',
                  mapa: ['SG.GG.G.M'],
                  bloques: {TipoBloque.avanzar, TipoBloque.recoger, TipoBloque.mientras, TipoBloque.si},
                  condiciones: [Cond.noMeta, Cond.gema, Cond.camino],
                  maxBloques: 4,
                  logro: 'Tu programa funciona sin importar cuántas gemas haya.',
                ),
                NivelRobot(
                  titulo: 'El laberinto',
                  instruccion: 'Mientras no llegues: si hay camino, avanza; si no, gira a la derecha. ¡El mismo programa resuelve muchos laberintos! Máximo 4 bloques.',
                  mapa: ['S...#', '###.#', '###.#', 'M...#'],
                  bloques: {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.mientras, TipoBloque.siSino},
                  condiciones: [Cond.noMeta, Cond.camino, Cond.pared],
                  maxBloques: 4,
                  logro: '¡Tu robot recorrió el laberinto tomando decisiones él solo!',
                  pista: 'mientras no he llegado a la meta: si hay camino adelante → avanzar, si no → girar a la derecha.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p4_m3_video', (a) => video(a,
            clave: 'repite_3', titulo: 'Video: ciclos y decisiones', tema: 'cómo combinar ciclos y decisiones', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p4_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseRelacionar(const [
                  ('repetir', 'Hace algo un número fijo de veces.'),
                  ('mientras', 'Repite mientras la condición sea verdadera.'),
                  ('si', 'Hace algo solo si se cumple la condición.'),
                  ('si no', 'Lo que se hace cuando NO se cumple.'),
                ], color: _c3, instruccion: 'Relaciona cada bloque con lo que hace.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué pasa si la condición de un “mientras” nunca deja de cumplirse?',
                    opciones: ['Se repite para siempre: un ciclo infinito', 'Se detiene solo', 'Se borra el programa'],
                    correcta: 0,
                    explicacion: 'Es un error común: el ciclo infinito.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Combinas ciclos y decisiones.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El laberinto giratorio',
      emoji: '🏆',
      color: Color(0xFFD81B60),
      intro: '¡Último desafío! Escribe UN programa inteligente que recoja las gemas y salga del laberinto giratorio.',
      mensajeFinal: '¡Escapaste del laberinto giratorio!',
      pasos: [
        PasoBio('Piensa antes de programar', TipoPasoBio.reto, 'p4_int_sit', (a) => situacion(
              a,
              titulo: 'El laberinto giratorio',
              color: const Color(0xFFD81B60),
              escenas: const [
                EscenaBio(
                  titulo: 'El problema',
                  narracion: 'El laberinto cambia de forma cada día. Un programa con pasos contados ya no sirve.',
                  emojis: '🌀🧱',
                  pregunta: '¿Qué estructura repite hasta llegar a la meta sin contar pasos?',
                  opciones: ['mientras no he llegado a la meta', 'repetir 5 veces', 'una secuencia fija'],
                  correcta: 0,
                  explicacion: 'El “mientras” revisa la condición en cada vuelta.',
                ),
                EscenaBio(
                  titulo: 'Las paredes',
                  narracion: 'A veces hay pared enfrente y a veces no.',
                  emojis: '🤖🧱',
                  pregunta: '¿Qué usa el robot para elegir entre avanzar o girar?',
                  opciones: ['si hay camino → avanzar, si no → girar', 'avanzar siempre', 'girar siempre'],
                  correcta: 0,
                  explicacion: 'Una decisión si… si no.',
                ),
                EscenaBio(
                  titulo: 'Las gemas',
                  narracion: 'Hay gemas en algunos cuadros, pero no sabes en cuáles.',
                  emojis: '💎❓',
                  pregunta: '¿Cómo las recoges?',
                  opciones: ['si hay una gema aquí → recoger gema', 'recoger en todos los cuadros sin revisar', 'no recogerlas'],
                  correcta: 0,
                  explicacion: 'El robot revisa antes de recoger.',
                ),
              ],
              mensajeFinal: '¡Ya tienes el plan! Ahora prográmalo.',
            )),
        PasoBio('Programa el escape', TipoPasoBio.simulacion, 'p4_int_robot', (a) => robot(
              a,
              seccion: 'Integradora',
              titulo: 'Escapa del laberinto',
              color: const Color(0xFFD81B60),
              mensajeFinal: 'Un programa con ciclos y decisiones resolvió el laberinto. ¡Eso es pensar como programador!',
              niveles: const [
                NivelRobot(
                  titulo: 'El escape',
                  instruccion: 'Escribe un programa que: mientras no llegue a la meta, recoja la gema si hay, y avance si hay camino o gire a la derecha si no. Máximo 6 bloques.',
                  mapa: ['S.G#', '##.#', 'MG.#'],
                  bloques: {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.recoger, TipoBloque.mientras, TipoBloque.si, TipoBloque.siSino},
                  condiciones: [Cond.noMeta, Cond.gema, Cond.camino, Cond.pared],
                  maxBloques: 6,
                  logro: '¡Escapaste del laberinto con todas las gemas!',
                  pista: 'mientras no he llegado: { si hay gema → recoger; si hay camino → avanzar, si no → girar a la derecha }.',
                ),
              ],
            )),
        PasoBio('Supercerebro de ciclos', TipoPasoBio.reto, 'p4_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFD81B60),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué figura representa una decisión en un diagrama de flujo?',
                    opciones: ['El rombo', 'El óvalo', 'El paralelogramo'],
                    correcta: 0,
                    explicacion: 'Tiene dos salidas: sí y no.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué estructura usarías para que un personaje salte 5 veces?',
                    opciones: ['repetir 5 veces: saltar', 'si… entonces', 'una sola instrucción'],
                    correcta: 0,
                    explicacion: 'Un número fijo de repeticiones.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'mientras (número ≤ 3) imprimir número, número = número + 1. Si número empieza en 1, ¿qué se imprime?',
                    opciones: ['1, 2, 3', '1, 2, 3, 4', 'Solo 1'],
                    correcta: 0,
                    explicacion: 'Cuando número llega a 4, la condición es falsa y el ciclo termina.',
                  ),
                ], color: const Color(0xFFD81B60), instruccion: 'Demuestra todo lo que sabes.'),
              ],
              mensajeFinal: '¡Eres un Experto en Ciclos y Decisiones!',
            )),
      ],
    ),
  ],
);
