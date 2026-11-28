import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_pro.dart';
import 'ilustraciones_pro.dart';
import 'pro_tema1.dart' show robot, conGemas;
import 'robot.dart';
import '../minijuegos/minijuegos.dart';

/// Programación · Tema 3: Programa con bloques.

const _c1 = Color(0xFFFFAB19);
const _c2 = Color(0xFF4C97FF);
const _c3 = Color(0xFF9966FF);
const _ci = Color(0xFFEF6C00);

final proTema3 = TemaBio(
  numero: 3,
  mundo: 'pro',
  estilo: estiloPro(FondoPro.bloques),
  titulo: 'Programa con bloques',
  saludo: 'En la programación por bloques, las instrucciones son piezas de colores que se encajan como un rompecabezas. ¡Así programan millones de niños en Scratch, Code.org y Tinkercad!',
  misionDelTema: 'La fábrica de bloques del reino necesita programadores. Conoce los tipos de bloques, programa al robot y dibuja figuras con código.',
  color: _ci,
  insignia: 'Programador de Bloques',
  emojiInsignia: '🧩',
  emojisPanel: const ['🟨', '🟦', '🟧', '🟪', '🟩'],
  videos: const {
    'bloques_1': 'assets/videos/bloques_que_son.mp4',
    'bloques_2': 'assets/videos/bloques_robot.mp4',
    'bloques_3': 'assets/videos/bloques_dibujo.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué son los bloques?',
      emoji: '🧩',
      color: _c1,
      intro: 'Los bloques de programación tienen colores y formas que te ayudan a armar programas sin errores de escritura. ¡Conócelos!',
      mensajeFinal: '¡Ya conoces los bloques de programación!',
      pasos: [
        PasoBio('Los bloques de colores', TipoPasoBio.explicacion, 'p3_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Bloques',
              titulo: 'Programar con bloques',
              color: _c1,
              il: ilBloques,
              textos: const [
                'La programación por bloques usa piezas visuales en lugar de escribir código. Cada bloque es una instrucción, y se encajan unos con otros para formar un programa.',
                'Es perfecta para aprender: no hay errores de escritura, y puedes concentrarte en la lógica. Con bloques se crean juegos, animaciones e historias.',
                'Cada color es una categoría: amarillo para eventos (cuándo empieza), azul para movimiento, morado para apariencia, naranja para control (repetir y decidir) y celeste para sensores (preguntas).',
                'Scratch, Code.org, MakeCode y los Bloques de código de Tinkercad usan bloques. ¡Muchos programadores empezaron así!',
              ],
              izquierda: const [
                Parte('eventos', 'Eventos', '(amarillo)', '🟨', Color(0xFFFFBF00), 'Indican cuándo empieza el programa, por ejemplo “al hacer clic en la bandera”.'),
                Parte('movimiento', 'Movimiento', '(azul)', '🟦', Color(0xFF4C97FF), 'Mueven y giran al personaje.'),
                Parte('apariencia', 'Apariencia', '(morado)', '🟪', Color(0xFF9966FF), 'Hacen que el personaje hable o cambie de disfraz.'),
              ],
              derecha: const [
                Parte('control', 'Control', '(naranja)', '🟧', Color(0xFFFFAB19), 'Repiten instrucciones o deciden qué hacer.'),
                Parte('sensores', 'Sensores', '(celeste)', '🟦', Color(0xFF5CB1D6), 'Hacen preguntas: ¿toca el borde?, ¿presionaron una tecla?'),
                Parte('escenario', 'Escenario', '(donde pasa todo)', '🐱', Color(0xFF66BB6A), 'Ahí se ve lo que hace tu programa.'),
              ],
              resaltar: const {
                2: {'eventos', 'movimiento', 'apariencia', 'control', 'sensores'},
                3: {'escenario'},
              },
              mensajeFinal: '¡Ahora conoce dónde se programa con bloques!',
            )),
        PasoBio('Programas de bloques', TipoPasoBio.explicacion, 'p3_m1_tarj', (a) => tarjetas(
              a,
              seccion: '2. Herramientas',
              titulo: '¿Dónde se programa con bloques?',
              color: _c1,
              textoZati: 'Hay muchas herramientas gratuitas para programar con bloques. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Herramientas', _c1, Icons.extension_rounded, [
                  TarjetaInfo(Icons.pets_rounded, 'Scratch', 'Creas historias y juegos con un gatito. La hizo el MIT.'),
                  TarjetaInfo(Icons.school_rounded, 'Code.org', 'Retos con laberintos y personajes de juegos famosos.'),
                  TarjetaInfo(Icons.memory_rounded, 'Tinkercad', 'Programa un Arduino con bloques de código.'),
                  TarjetaInfo(Icons.developer_board_rounded, 'MakeCode', 'Programa tarjetas como la micro:bit.'),
                ]),
                GrupoTarjetas('Cómo se usan', _c2, Icons.touch_app_rounded, [
                  TarjetaInfo(Icons.pan_tool_alt_rounded, 'Arrastrar', 'Tomas un bloque de la paleta y lo llevas al programa.'),
                  TarjetaInfo(Icons.link_rounded, 'Encajar', 'Los bloques se unen solo si tienen sentido juntos.'),
                  TarjetaInfo(Icons.play_circle_rounded, 'Ejecutar', 'Presionas la bandera o “Ejecutar” y ves el resultado.'),
                ]),
              ],
              mensajeFinal: '¡Con bloques cualquiera puede programar!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p3_m1_video', (a) => video(a,
            clave: 'bloques_1', titulo: 'Video: programar con bloques', tema: 'qué son los bloques de programación', siguiente: '¡A ordenar los bloques!')),
        PasoBio('¿De qué color es?', TipoPasoBio.laboratorio, 'p3_m1_clas', (a) => clasificar(
              a,
              seccion: '3. Clasifica',
              titulo: '¿A qué categoría pertenece?',
              color: _c1,
              instruccion: 'Arrastra cada bloque a su categoría.',
              grupos: const [
                GrupoClasificar('Eventos', '🟨', Color(0xFFFFBF00)),
                GrupoClasificar('Movimiento', '🟦', Color(0xFF4C97FF)),
                GrupoClasificar('Apariencia', '🟪', Color(0xFF9966FF)),
                GrupoClasificar('Control', '🟧', Color(0xFFFFAB19)),
              ],
              items: const [
                ItemClasificar('🚩', 'al hacer clic en la bandera', 0, 'Indica cuándo empieza el programa.'),
                ItemClasificar('⌨️', 'al presionar una tecla', 0, 'Es un evento.'),
                ItemClasificar('👣', 'mover 10 pasos', 1, 'Mueve al personaje.'),
                ItemClasificar('↻', 'girar 90 grados', 1, 'Es de movimiento.'),
                ItemClasificar('💬', 'decir ¡Hola!', 2, 'Cambia lo que se ve.'),
                ItemClasificar('👕', 'cambiar de disfraz', 2, 'Es de apariencia.'),
                ItemClasificar('🔁', 'repetir 10 veces', 3, 'Controla cuántas veces se hace algo.'),
                ItemClasificar('❓', 'si… entonces', 3, 'Toma decisiones.'),
              ],
              mensajeFinal: 'Los colores te ayudan a encontrar el bloque que necesitas.',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p3_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilBloques, const {'eventos': 'Eventos', 'movimiento': 'Movimiento', 'apariencia': 'Apariencia', 'control': 'Control'}, color: _c1,
                    instruccion: 'Nombra cada categoría de bloques.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Por qué es más fácil empezar con bloques?',
                    opciones: ['No hay errores de escritura y te concentras en la lógica', 'Porque no hacen nada', 'Porque son más caros'],
                    correcta: 0,
                    explicacion: 'Los bloques solo encajan si tienen sentido.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Conoces las categorías de bloques.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Mueve al robot',
      emoji: '🤖',
      color: _c2,
      intro: 'Arma programas con bloques para guiar al robot y recoger todas las gemas.',
      mensajeFinal: '¡Programas con bloques como un experto!',
      pasos: [
        PasoBio('Programa con bloques', TipoPasoBio.simulacion, 'p3_m2_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Mueve al robot',
              color: _c2,
              mensajeFinal: 'Armaste programas de bloques y el robot los ejecutó uno por uno.',
              niveles: const [
                NivelRobot(
                  titulo: 'El pasillo',
                  instruccion: 'Arma el programa con los bloques azules de movimiento y lleva al robot a la meta.',
                  mapa: ['S....#', '####.#', '####.M'],
                  logro: 'Usaste bloques de movimiento en secuencia.',
                  pista: 'Avanza 4, gira a la derecha, avanza 2, gira a la izquierda y avanza 1.',
                ),
                NivelRobot(
                  titulo: 'Las tres gemas',
                  instruccion: 'Recoge las 3 gemas 💎 y llega a la meta. Si te equivocas, toca un bloque y usa 🗑️ para borrarlo.',
                  mapa: ['SG.G', '###.', 'M.G.'],
                  bloques: conGemas,
                  logro: 'Recogiste todas las gemas con un programa largo… ¡pronto aprenderás a hacerlo más corto!',
                  pista: 'En la orilla derecha gira a la derecha para bajar; abajo, gira otra vez a la derecha para regresar.',
                ),
              ],
            )),
        PasoBio('Plataformas con bloques', TipoPasoBio.juego, 'p3_m2_flame', (a) => juegoPlataformas(a, color: _c2)),
        PasoBio('Video del tema', TipoPasoBio.video, 'p3_m2_video', (a) => video(a,
            clave: 'bloques_2', titulo: 'Video: programa al robot', tema: 'cómo armar programas con bloques', siguiente: '¡A ordenar un programa de Scratch!')),
        PasoBio('Programa de Scratch', TipoPasoBio.juego, 'p3_m2_ord', (a) => ordenar(
              a,
              seccion: '2. Ordena',
              titulo: 'Arma el programa del gato',
              color: _c2,
              instruccion: 'Ordena los bloques para que el gato salude, camine y maúlle.',
              pasos: const [
                ('🚩', 'al hacer clic en la bandera'),
                ('💬', 'decir ¡Hola! por 2 segundos'),
                ('👣', 'mover 10 pasos'),
                ('↻', 'girar 15 grados'),
                ('🔊', 'tocar sonido miau'),
              ],
              explicacion: 'El evento va primero: el programa empieza cuando alguien hace clic en la bandera.',
              mensajeFinal: '¡Tu gato está programado!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p3_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseRelacionar(const [
                  ('avanzar', 'Mueve al robot un cuadro hacia donde mira.'),
                  ('girar a la derecha', 'Cambia hacia dónde mira, sin moverse.'),
                  ('recoger gema', 'Toma la gema del cuadro actual.'),
                  ('al empezar', 'Evento con el que inicia el programa.'),
                ], color: _c2, instruccion: 'Relaciona cada bloque con lo que hace.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Pusiste un bloque equivocado en tu programa. ¿Qué haces?',
                    opciones: ['Lo selecciono y lo borro o lo cambio de lugar', 'Apago la computadora', 'Empiezo todo desde cero siempre'],
                    correcta: 0,
                    explicacion: 'Los bloques se pueden mover y borrar fácilmente.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Sabes armar y editar programas de bloques.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Dibuja con código',
      emoji: '✏️',
      color: _c3,
      intro: 'Si el robot lleva un lápiz, ¡cada movimiento deja una línea! Programa al robot para dibujar figuras.',
      mensajeFinal: '¡Dibujaste con código!',
      pasos: [
        PasoBio('El robot dibujante', TipoPasoBio.explicacion, 'p3_m3_tarj', (a) => tarjetas(
              a,
              seccion: '1. Dibujar',
              titulo: 'Dibujar con código',
              color: _c3,
              textoZati: 'Muchos programadores aprendieron dibujando con una “tortuga” que deja un rastro. Cada “avanzar” traza una línea y cada “girar” cambia la dirección 90 grados. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Cómo dibuja', _c3, Icons.draw_rounded, [
                  TarjetaInfo(Icons.straight_rounded, 'Avanzar', 'Traza una línea de un punto al siguiente.'),
                  TarjetaInfo(Icons.turn_right_rounded, 'Girar', 'Cambia la dirección: un cuarto de vuelta.'),
                  TarjetaInfo(Icons.crop_square_rounded, 'Cuadrado', 'Lados iguales y 4 giros iguales.'),
                ]),
                GrupoTarjetas('Para pensar', Color(0xFF00897B), Icons.lightbulb_rounded, [
                  TarjetaInfo(Icons.visibility_rounded, 'Observa el modelo', 'Las líneas punteadas muestran lo que debes dibujar.'),
                  TarjetaInfo(Icons.navigation_rounded, 'Ponte en su lugar', 'Piensa hacia dónde mira el robot antes de girar.'),
                ]),
              ],
              mensajeFinal: '¡A dibujar!',
            )),
        PasoBio('Dibuja figuras', TipoPasoBio.simulacion, 'p3_m3_dibujo', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Dibuja con código',
              color: _c3,
              mensajeFinal: 'Programaste dibujos. ¿Viste que en el cuadrado se repetían los mismos bloques? En el próximo tema aprenderás a repetir.',
              niveles: [
                NivelRobot(
                  titulo: 'La letra L',
                  instruccion: 'Dibuja la letra L siguiendo el modelo punteado. El robot empieza arriba, mirando hacia abajo.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.abajo,
                  dibujo: figura(const [(0, 0), (0, 3), (2, 3)]),
                  logro: 'Dibujaste la L: dos líneas y un giro.',
                  pista: 'Avanza 3, gira a la izquierda (¡mirando hacia abajo!) y avanza 2.',
                ).conInicio(0, 0),
                NivelRobot(
                  titulo: 'La escalera',
                  instruccion: 'Dibuja la escalera: sube un escalón y avanza uno, tres veces.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.arriba,
                  dibujo: figura(const [(0, 3), (0, 2), (1, 2), (1, 1), (2, 1), (2, 0), (3, 0)]),
                  logro: '¿Notaste el patrón? Los mismos bloques se repiten.',
                  pista: 'Avanzar, girar a la derecha, avanzar, girar a la izquierda… y otra vez.',
                ).conInicio(0, 3),
                NivelRobot(
                  titulo: 'El cuadrado',
                  instruccion: 'Dibuja un cuadrado de 2 cuadros por lado.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.arriba,
                  dibujo: figura(const [(0, 3), (0, 1), (2, 1), (2, 3), (0, 3)]),
                  logro: '¡Un cuadrado! 4 lados iguales y 4 giros iguales.',
                  pista: 'Cada lado: avanzar, avanzar, girar a la derecha.',
                ).conInicio(0, 3),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p3_m3_video', (a) => video(a,
            clave: 'bloques_3', titulo: 'Video: dibuja con código', tema: 'cómo dibujar figuras con instrucciones', siguiente: '¡A jugar memorama!')),
        PasoBio('Memorama de bloques', TipoPasoBio.juego, 'p3_m3_mem', (a) => memorama(
              a,
              titulo: 'Memorama de bloques',
              color: _c3,
              instruccion: 'Encuentra cada color de bloque con lo que hace.',
              pares: const [
                ('🟨', 'Amarillo', 'Eventos: cuándo empieza'),
                ('🟦', 'Azul', 'Movimiento'),
                ('🟪', 'Morado', 'Apariencia'),
                ('🟧', 'Naranja', 'Control: repetir y decidir'),
                ('🟩', 'Verde', 'Operadores y acciones'),
                ('🩵', 'Celeste', 'Sensores: preguntas'),
              ],
              mensajeFinal: '¡Conoces los colores de los bloques!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p3_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Para dibujar un cuadrado, ¿cuántas veces giras?',
                    opciones: ['4 veces', '2 veces', '8 veces'],
                    correcta: 0,
                    explicacion: 'Un giro en cada esquina.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'En el cuadrado repetiste “avanzar, avanzar, girar” 4 veces. ¿Qué encontraste?',
                    opciones: ['Un patrón', 'Un error', 'Un sensor'],
                    correcta: 0,
                    explicacion: 'Los patrones se pueden programar con “repetir”.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Dibujas con código y encuentras patrones.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La gran fábrica',
      emoji: '🏆',
      color: Color(0xFF00897B),
      intro: '¡Último desafío! Programa al robot de la fábrica para recoger las piezas y dibujar el logo del reino.',
      mensajeFinal: '¡La fábrica de bloques funciona gracias a ti!',
      pasos: [
        PasoBio('El robot de la fábrica', TipoPasoBio.simulacion, 'p3_int_robot', (a) => robot(
              a,
              seccion: 'Integradora',
              titulo: 'El robot de la fábrica',
              color: const Color(0xFF00897B),
              mensajeFinal: '¡Programaste al robot de la fábrica con bloques!',
              niveles: [
                const NivelRobot(
                  titulo: 'Las piezas',
                  instruccion: 'Recoge las 2 piezas 💎 de la fábrica y llega a la meta.',
                  mapa: ['S.G#', '##.#', 'MG.#'],
                  bloques: conGemas,
                  logro: 'Recogiste las piezas.',
                  pista: 'Avanza, avanza y recoge; gira a la derecha, avanza 2, gira a la derecha, avanza, recoge y avanza.',
                ),
                NivelRobot(
                  titulo: 'El logo',
                  instruccion: 'Dibuja el logo del reino: una letra T.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.derecha,
                  dibujo: figura(const [(0, 0), (4, 0)])..addAll(figura(const [(2, 0), (2, 3)])),
                  logro: '¡El logo del reino quedó perfecto!',
                  pista: 'Avanza 2, gira a la derecha, avanza 3; luego regresa (2 giros), avanza 3, gira a la derecha y avanza 2.',
                ).conInicio(0, 0),
              ],
            )),
        PasoBio('Supercerebro de bloques', TipoPasoBio.reto, 'p3_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFF00897B),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué bloque se usa para que un programa empiece?',
                    opciones: ['Un bloque de eventos, como “al hacer clic en la bandera”', 'Un bloque de apariencia', 'Ninguno'],
                    correcta: 0,
                    explicacion: 'Los eventos dicen cuándo empieza.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué color tienen los bloques de control en Scratch?',
                    opciones: ['Naranja', 'Azul', 'Morado'],
                    correcta: 0,
                    explicacion: 'Ahí están repetir y si… entonces.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué hace “girar a la derecha” al robot?',
                    opciones: ['Cambia hacia dónde mira sin moverse', 'Lo mueve dos cuadros', 'Recoge una gema'],
                    correcta: 0,
                    explicacion: 'Gira en su lugar.',
                  ),
                ], color: const Color(0xFF00897B), instruccion: 'Demuestra todo lo que sabes de bloques.'),
              ],
              mensajeFinal: '¡Eres un Programador de Bloques!',
            )),
      ],
    ),
  ],
);
