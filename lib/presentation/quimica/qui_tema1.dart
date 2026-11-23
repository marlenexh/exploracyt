import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import '../ciencia/fondos_ciencia.dart';
import 'ilustraciones_qui.dart';

/// Química · Tema 1: El mundo de los materiales.

const _c1 = Color(0xFF8D6E63);
const _c2 = Color(0xFF5E35B1);
const _c3 = Color(0xFF00897B);
const _ci = Color(0xFF6D4C41);

final quiTema1 = TemaBio(
  numero: 1,
  mundo: 'qui',
  estilo: estiloCiencia(FondoCiencia.materiales),
  titulo: 'El mundo de los materiales',
  saludo:
      'Todo lo que te rodea está hecho de materiales: tu mesa, tu ropa, tu lápiz. Cada material tiene propiedades, como ser duro, flexible o dejar pasar el agua. ¡Vamos a investigarlas!',
  misionDelTema:
      'En el laboratorio de los materiales misteriosos hay que elegir los mejores materiales para construir objetos útiles. Descubre sus propiedades con experimentos.',
  color: _ci,
  insignia: 'Detective de Materiales',
  emojiInsignia: '🧱',
  emojisPanel: const ['🪵', '🪨', '🧽', '☂️', '🔩'],
  videos: const {
    'materiales_1': 'assets/videos/materiales_que_son.mp4',
    'materiales_2': 'assets/videos/materiales_propiedades.mp4',
    'materiales_3': 'assets/videos/materiales_usos.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿De qué están hechas las cosas?',
      emoji: '🪵',
      color: _c1,
      intro: 'Mira a tu alrededor: cada objeto está hecho de uno o varios materiales. ¿De dónde vienen?',
      mensajeFinal: '¡Reconoces los materiales y su origen!',
      pasos: [
        PasoBio(
            'Los materiales',
            TipoPasoBio.explicacion,
            'q1_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Materiales',
                  titulo: 'Materiales naturales y artificiales',
                  color: _c1,
                  il: ilNaturalArtificial,
                  textos: const [
                    'Un material es aquello de lo que están hechos los objetos. Los materiales naturales se obtienen de la naturaleza (madera, algodón, lana, piedra) y los artificiales los fabrican las personas transformando otros materiales (plástico, vidrio, papel).',
                    'Elegimos el material de un objeto según para qué lo vamos a usar: una silla necesita ser resistente; una cobija, suave y calientita.',
                    'Los materiales artificiales se obtienen al transformar los naturales: el vidrio se hace con arena muy caliente, el papel con la madera de los árboles y el plástico con petróleo.',
                    'Tu mochila puede tener tela, plástico y metal (en el cierre). ¡Un solo objeto puede tener muchos materiales!',
                  ],
                  izquierda: const [
                    Parte('madera', 'Madera', '(natural)', '🪵', Color(0xFF8D6E63), 'Viene de los árboles. Se usa en muebles, lápices y casas.'),
                    Parte('algodon', 'Algodón', '(natural)', '🌿', Color(0xFF43A047), 'Fibra de una planta. Con él se hace mucha ropa.'),
                    Parte('piedra', 'Piedra', '(natural)', '🪨', Color(0xFF78909C), 'Se usa para construir. Es dura y pesada.'),
                  ],
                  derecha: const [
                    Parte('plastico', 'Plástico', '(artificial)', '🧴', Color(0xFF1E88E5), 'Se fabrica con petróleo. Es ligero y no deja pasar el agua.'),
                    Parte('vidrio', 'Vidrio', '(artificial)', '🫙', Color(0xFF26C6DA), 'Se hace fundiendo arena. Es transparente y frágil.'),
                    Parte('papel', 'Papel', '(artificial)', '📄', Color(0xFFFFB300), 'Se fabrica con fibras de madera.'),
                  ],
                  resaltar: const {
                    2: {'vidrio', 'papel', 'plastico'},
                  },
                  mensajeFinal: '¡Ahora descubre datos curiosos de los materiales!',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'q1_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Materiales sorprendentes',
                  color: _c1,
                  textoZati: 'Los materiales tienen historias increíbles. Toca cada tarjeta para descubrirlas.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.diamond_rounded, 'El diamante', 'Es el material natural más duro: solo otro diamante puede rayarlo.'),
                      TarjetaInfo(Icons.timer_rounded, 'El plástico', 'Una botella de plástico puede tardar más de 400 años en degradarse.'),
                      TarjetaInfo(Icons.wb_sunny_rounded, 'El vidrio', 'Se hace con arena calentada a más de 1 500 °C.'),
                      TarjetaInfo(Icons.recycling_rounded, 'El aluminio', 'Se puede reciclar una y otra vez sin perder sus propiedades.'),
                    ]),
                    GrupoTarjetas('En México', _c1, Icons.flag_rounded, [
                      TarjetaInfo(
                          Icons.palette_rounded, 'Barro', 'Con barro se hacen ollas y cántaros desde hace miles de años, como el barro negro de Oaxaca.'),
                      TarjetaInfo(Icons.grass_rounded, 'Fibras naturales', 'Con henequén y palma se tejen sombreros, petates y bolsas.'),
                    ]),
                  ],
                  mensajeFinal: '¡Los materiales son fascinantes!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q1_m1_video',
            (a) => video(a,
                clave: 'materiales_1', titulo: 'Video: los materiales', tema: 'materiales naturales y artificiales', siguiente: '¡A clasificar materiales!')),
        PasoBio(
            '¿Natural o artificial?',
            TipoPasoBio.laboratorio,
            'q1_m1_clas',
            (a) => clasificar(
                  a,
                  seccion: '3. Clasifica',
                  titulo: '¿Natural o artificial?',
                  color: _c1,
                  instruccion: 'Arrastra cada material al grupo correcto.',
                  grupos: const [GrupoClasificar('Natural', '🌳', Color(0xFF43A047)), GrupoClasificar('Artificial', '🏭', Color(0xFF1E88E5))],
                  items: const [
                    ItemClasificar('🪵', 'Madera', 0, 'Viene directo de los árboles.'),
                    ItemClasificar('🐑', 'Lana', 0, 'Se obtiene del pelo de las ovejas.'),
                    ItemClasificar('🪨', 'Piedra', 0, 'Se saca de la naturaleza.'),
                    ItemClasificar('🌿', 'Algodón', 0, 'Es una fibra de una planta.'),
                    ItemClasificar('🧴', 'Plástico', 1, 'Se fabrica con petróleo.'),
                    ItemClasificar('🫙', 'Vidrio', 1, 'Se hace fundiendo arena.'),
                    ItemClasificar('🧦', 'Nailon', 1, 'Es una fibra fabricada por las personas.'),
                    ItemClasificar('📄', 'Papel', 1, 'Se fabrica transformando la madera.'),
                  ],
                  mensajeFinal: 'Los materiales artificiales vienen de transformar los naturales.',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q1_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilNaturalArtificial, const {'madera': 'Madera', 'piedra': 'Piedra', 'plastico': 'Plástico', 'vidrio': 'Vidrio'},
                        color: _c1, instruccion: 'Nombra cada material.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿De qué material natural se obtiene el papel?',
                        opciones: ['De la madera', 'Del vidrio', 'Del plástico'],
                        correcta: 0,
                        explicacion: 'El papel se fabrica con fibras de madera.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Distingues materiales naturales y artificiales.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Dureza, flexibilidad y permeabilidad',
      emoji: '🧪',
      color: _c2,
      intro: 'Los científicos prueban los materiales para conocer sus propiedades. ¡Entra al laboratorio!',
      mensajeFinal: '¡Investigaste las propiedades de los materiales!',
      pasos: [
        PasoBio(
            'Las propiedades',
            TipoPasoBio.explicacion,
            'q1_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Propiedades',
                  titulo: 'Propiedades de los materiales',
                  color: _c2,
                  il: ilPropiedades,
                  textos: const [
                    'Las propiedades son las características de un material: cómo es y cómo se comporta. Tres muy importantes son la dureza, la flexibilidad y la permeabilidad.',
                    'Conocerlas nos ayuda a escoger el material adecuado: un impermeable para la lluvia, un material duro para un martillo o uno flexible para una manguera.',
                    'Dureza: qué tanto resiste a ser rayado (un material duro no se raya fácilmente). Flexibilidad: si se puede doblar sin romperse. Permeabilidad: si deja pasar el agua. Si no la deja pasar, es impermeable.',
                    'La esponja es permeable y absorbe el agua; el paraguas es impermeable. El vidrio es duro pero frágil: no se raya fácil, pero se rompe con un golpe.',
                  ],
                  izquierda: const [
                    Parte('dureza', 'Dureza', '(no se raya)', '💎', Color(0xFF5E35B1), 'Un material duro resiste que lo rayen. El diamante es el más duro.'),
                    Parte('flexibilidad', 'Flexibilidad', '(se dobla)', '🪢', Color(0xFF00897B), 'Se dobla sin romperse, como una cuerda o una manguera.'),
                    Parte(
                        'permeable', 'Permeable', '(deja pasar el agua)', '🧽', Color(0xFF29B6F6), 'Deja pasar o absorbe el agua, como la tela o la esponja.'),
                  ],
                  derecha: const [
                    Parte('fragil', 'Fragilidad', '(se rompe)', '🍷', Color(0xFFEC407A), 'Se rompe con facilidad al golpearlo, como el vidrio.'),
                    Parte('elasticidad', 'Elasticidad', '(regresa a su forma)', '🎈', Color(0xFFFF7043),
                        'Se estira y vuelve a su forma, como el hule de un globo.'),
                    Parte('impermeable', 'Impermeable', '(no deja pasar el agua)', '☂️', Color(0xFF1565C0),
                        'No deja pasar el agua, como el plástico de un paraguas.'),
                  ],
                  resaltar: const {
                    2: {'dureza', 'flexibilidad', 'permeable'},
                    3: {'fragil', 'impermeable'},
                  },
                  mensajeFinal: '¡Ahora pon a prueba los materiales!',
                )),
        PasoBio(
            'Laboratorio de materiales',
            TipoPasoBio.laboratorio,
            'q1_m2_lab',
            (a) => lab(
                  a,
                  titulo: 'Prueba los materiales',
                  color: _c2,
                  instruccion:
                      'Haz las tres pruebas a cada material: rayarlo con un clavo (dureza), doblarlo (flexibilidad) y echarle agua (permeabilidad). Toca cada “?”.',
                  pruebas: const [
                    Prueba('Rayar con un clavo', '🔩', 'Duro', 'Se raya'),
                    Prueba('Doblar', '🤲', 'Flexible', 'Rígido'),
                    Prueba('Echar agua', '💧', 'Permeable', 'Impermeable'),
                  ],
                  muestras: const [
                    Muestra('Vidrio', '🫙', [true, false, false], datos: ['El clavo no lo raya.', 'Si lo doblas, se rompe.', 'El agua resbala.']),
                    Muestra('Madera', '🪵', [false, false, true], datos: ['El clavo deja una marca.', 'Es rígida.', 'Absorbe un poco de agua.']),
                    Muestra('Hule', '🧤', [false, true, false], datos: ['Se marca.', 'Se dobla sin romperse.', 'No deja pasar el agua.']),
                    Muestra('Cuchara de metal', '🥄', [true, false, false], datos: ['Resiste al clavo.', 'Es difícil de doblar.', 'El agua no pasa.']),
                    Muestra('Tela', '👕', [false, true, true], datos: ['Es suave.', 'Se dobla fácilmente.', 'El agua la atraviesa.']),
                    Muestra('Esponja', '🧽', [false, true, true], datos: ['Es blanda.', 'Se dobla y aplasta.', '¡Absorbe mucha agua!']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: 'Según tus resultados, ¿qué material usarías para hacer un impermeable para la lluvia?',
                    opciones: ['Hule', 'Tela', 'Esponja'],
                    correcta: 0,
                    explicacion: 'El hule es flexible e impermeable: no deja pasar el agua.',
                  ),
                  mensajeFinal: 'Cada material tiene propiedades diferentes y por eso sirve para cosas distintas.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q1_m2_video',
            (a) => video(a,
                clave: 'materiales_2',
                titulo: 'Video: propiedades de los materiales',
                tema: 'dureza, flexibilidad y permeabilidad',
                siguiente: '¡A jugar memorama!')),
        PasoBio(
            'Memorama de propiedades',
            TipoPasoBio.juego,
            'q1_m2_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama de propiedades',
                  color: _c2,
                  instruccion: 'Encuentra cada propiedad con un ejemplo.',
                  pares: const [
                    ('💎', 'Dureza', 'El diamante no se raya'),
                    ('🪢', 'Flexibilidad', 'La cuerda se dobla'),
                    ('🧽', 'Permeable', 'La esponja absorbe agua'),
                    ('☂️', 'Impermeable', 'El paraguas no deja pasar agua'),
                    ('🍷', 'Fragilidad', 'El vidrio se rompe'),
                    ('🎈', 'Elasticidad', 'El globo se estira'),
                  ],
                  mensajeFinal: '¡Memoria de científico!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q1_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilPropiedades, const {'dureza': 'Duro', 'flexibilidad': 'Flexible', 'permeable': 'Permeable', 'impermeable': 'Impermeable'},
                        color: _c2, instruccion: 'Nombra la propiedad de cada objeto.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Cómo sabes si un material es duro?',
                        opciones: ['Si no se raya fácilmente', 'Si es de color oscuro', 'Si es muy grande'],
                        correcta: 0,
                        explicacion: 'La dureza es la resistencia a ser rayado.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Conoces las propiedades de los materiales.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'El material correcto',
      emoji: '🛠️',
      color: _c3,
      intro: 'Los inventores eligen el material según la propiedad que necesitan. ¡Ayúdales a decidir!',
      mensajeFinal: '¡Eliges materiales como un ingeniero!',
      pasos: [
        PasoBio(
            'Propiedad y uso',
            TipoPasoBio.explicacion,
            'q1_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Usos',
                  titulo: 'Cada material para su uso',
                  color: _c3,
                  textoZati: 'Las propiedades de un material deciden para qué sirve. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Para qué sirven', _c3, Icons.handyman_rounded, [
                      TarjetaInfo(Icons.umbrella_rounded, 'Impermeable', 'Paraguas, botas, techos y tinacos.'),
                      TarjetaInfo(Icons.hardware_rounded, 'Duro', 'Martillos, cuchillos, herramientas y pisos.'),
                      TarjetaInfo(Icons.cable_rounded, 'Flexible', 'Mangueras, cables, ropa y ligas.'),
                      TarjetaInfo(Icons.coffee_rounded, 'Permeable', 'Filtros de café, coladores de tela y toallas.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.spa_rounded, 'La seda de araña', 'Es más resistente que un hilo de acero del mismo grosor.'),
                      TarjetaInfo(
                          Icons.recycling_rounded, 'Reciclar', 'Reciclar una lata de aluminio ahorra la energía para tener una tele encendida 3 horas.'),
                    ]),
                  ],
                  mensajeFinal: '¡Las propiedades nos ayudan a elegir bien!',
                )),
        PasoBio(
            '¿Qué propiedad necesita?',
            TipoPasoBio.laboratorio,
            'q1_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Qué propiedad necesita?',
                  color: _c3,
                  instruccion: 'Arrastra cada objeto a la propiedad más importante de su material.',
                  grupos: const [
                    GrupoClasificar('Impermeable', '☂️', Color(0xFF1565C0)),
                    GrupoClasificar('Duro', '💎', Color(0xFF5E35B1)),
                    GrupoClasificar('Flexible', '🪢', Color(0xFF00897B)),
                  ],
                  items: const [
                    ItemClasificar('☂️', 'Paraguas', 0, 'No debe dejar pasar la lluvia.'),
                    ItemClasificar('🥾', 'Botas de lluvia', 0, 'Mantienen tus pies secos.'),
                    ItemClasificar('🔨', 'Martillo', 1, 'Debe resistir golpes sin rayarse.'),
                    ItemClasificar('🔪', 'Cuchillo', 1, 'Su filo debe ser duro.'),
                    ItemClasificar('🧶', 'Estambre', 2, 'Se dobla para tejer.'),
                    ItemClasificar('🪀', 'Cuerda del yoyo', 2, 'Debe enrollarse.'),
                  ],
                  mensajeFinal: 'Para cada objeto se busca la propiedad que más necesita.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q1_m3_video',
            (a) => video(a,
                clave: 'materiales_3', titulo: 'Video: usos de los materiales', tema: 'cómo se elige un material', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q1_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'Cuida los materiales',
                        'Toca las acciones que ayudan a cuidar los materiales y el planeta y presiona “Comprobar”.',
                        const [
                          Accion(Icons.recycling_rounded, 'Separar la basura para reciclar', true, 'Así los materiales se vuelven a usar.'),
                          Accion(Icons.shopping_bag_rounded, 'Usar bolsas de tela', true, 'Se reutilizan muchas veces.'),
                          Accion(Icons.local_drink_rounded, 'Rellenar tu botella de agua', true, 'Usas menos plástico.'),
                          Accion(Icons.edit_note_rounded, 'Usar las hojas por los dos lados', true, 'Ahorras papel y árboles.'),
                          Accion(Icons.delete_rounded, 'Tirar el vidrio con la basura de comida', false, 'El vidrio se puede reciclar si se separa.'),
                          Accion(Icons.no_drinks_rounded, 'Usar popotes desechables', false, 'Son plástico que dura cientos de años.'),
                        ],
                        color: _c3),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué los filtros de café son de papel?',
                        opciones: ['Porque el papel es permeable y deja pasar el agua', 'Porque es muy duro', 'Porque es impermeable'],
                        correcta: 0,
                        explicacion: 'El agua pasa y los granos de café se quedan.',
                      ),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Eliges materiales y los cuidas.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La mochila para la lluvia',
      emoji: '🏆',
      color: Color(0xFF1565C0),
      intro: '¡Último desafío! Diseña una mochila escolar que aguante la temporada de lluvias.',
      mensajeFinal: '¡Tu mochila mantuvo secos los cuadernos!',
      pasos: [
        PasoBio(
            'Diseña la mochila',
            TipoPasoBio.reto,
            'q1_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'La mochila para la lluvia',
                  color: const Color(0xFF1565C0),
                  escenas: const [
                    EscenaBio(
                      titulo: 'La tela',
                      narracion: 'En temporada de lluvias los cuadernos de Ana se mojan dentro de su mochila.',
                      emojis: '🎒🌧️',
                      pregunta: '¿Qué propiedad debe tener la tela de la nueva mochila?',
                      opciones: ['Impermeable', 'Permeable', 'Frágil'],
                      correcta: 0,
                      explicacion: 'Así el agua no pasa.',
                    ),
                    EscenaBio(
                      titulo: 'Las correas',
                      narracion: 'Las correas deben acomodarse a la espalda.',
                      emojis: '🎒🪢',
                      pregunta: '¿Qué propiedad necesitan?',
                      opciones: ['Flexibilidad', 'Dureza', 'Fragilidad'],
                      correcta: 0,
                      explicacion: 'Se doblan sin romperse.',
                    ),
                    EscenaBio(
                      titulo: 'El cierre',
                      narracion: 'El cierre se abre y cierra muchas veces al día.',
                      emojis: '🤐🔩',
                      pregunta: '¿Qué material resiste mejor el uso?',
                      opciones: ['Metal o plástico resistente', 'Papel', 'Hielo'],
                      correcta: 0,
                      explicacion: 'Son duros y resistentes.',
                    ),
                    EscenaBio(
                      titulo: 'Para el planeta',
                      narracion: 'Quieren que la mochila contamine poco.',
                      emojis: '♻️🌎',
                      pregunta: '¿Qué pueden hacer?',
                      opciones: ['Usar plástico reciclado y cuidarla para que dure', 'Comprar una nueva cada mes', 'Tirarla al río'],
                      correcta: 0,
                      explicacion: 'Reducir, reutilizar y reciclar.',
                    ),
                  ],
                  mensajeFinal: '¡La mochila quedó perfecta!',
                )),
        PasoBio(
            'Supercerebro de materiales',
            TipoPasoBio.reto,
            'q1_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF1565C0),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuál es un material natural?',
                          opciones: ['Lana', 'Plástico', 'Nailon'],
                          correcta: 0,
                          explicacion: 'Viene de las ovejas.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué significa que un material sea permeable?',
                          opciones: ['Que deja pasar el agua', 'Que es duro', 'Que brilla'],
                          correcta: 0,
                          explicacion: 'Como la esponja.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál es el material natural más duro?',
                          opciones: ['El diamante', 'La madera', 'El hule'],
                          correcta: 0,
                          explicacion: 'Solo otro diamante lo raya.'),
                      PreguntaQuiz(
                          pregunta: 'El vidrio no se raya fácil, pero se rompe al caer. Es…',
                          opciones: ['Duro y frágil', 'Blando y flexible', 'Permeable'],
                          correcta: 0,
                          explicacion: 'Dureza y fragilidad son propiedades distintas.'),
                    ], color: const Color(0xFF1565C0), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Detective de Materiales!',
                )),
      ],
    ),
  ],
);
