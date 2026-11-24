import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_qui.dart';
import 'ilustraciones_qui.dart';
import 'sims_qui.dart';

/// Química · Tema 2: Los gases y sus propiedades.

const _c1 = Color(0xFF039BE5);
const _c2 = Color(0xFF7E57C2);
const _c3 = Color(0xFF00897B);
const _ci = Color(0xFF0277BD);

final quiTema2 = TemaBio(
  numero: 2,
  mundo: 'qui',
  estilo: estiloQui(FondoQui.gases),
  titulo: 'Los gases y sus propiedades',
  saludo:
      'No los vemos, pero los gases están en todas partes: el aire que respiras, el gas de la estufa, las burbujas del refresco. ¡Vamos a descubrir cómo se comportan!',
  misionDelTema: 'La feria del pueblo necesita inflar su globo aerostático. Investiga las propiedades de los gases para lograr que se eleve.',
  color: _ci,
  insignia: 'Explorador de los Gases',
  emojiInsignia: '🎈',
  emojisPanel: const ['💨', '🫧', '🛞', '🌬️', '☁️'],
  videos: const {
    'gases_1': 'assets/videos/gases_que_son.mp4',
    'gases_2': 'assets/videos/gases_propiedades.mp4',
    'gases_3': 'assets/videos/gases_vida_diaria.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Sólidos, líquidos y gases',
      emoji: '💨',
      color: _c1,
      intro: 'La materia se presenta en tres estados. ¿En qué se distinguen los gases?',
      mensajeFinal: '¡Conoces los estados de la materia!',
      pasos: [
        PasoBio(
            'Los estados de la materia',
            TipoPasoBio.explicacion,
            'q2_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Estados',
                  titulo: 'Sólidos, líquidos y gases',
                  color: _c1,
                  il: ilEstados,
                  textos: const [
                    'La materia está formada por partículas diminutas. En los sólidos están muy juntas, en los líquidos un poco separadas y en los gases muy separadas y moviéndose rápido.',
                    'Por eso los sólidos tienen forma propia, los líquidos toman la forma del recipiente, y los gases ocupan todo el espacio disponible.',
                    'Las partículas de los gases chocan entre sí y con las paredes del recipiente. Esos choques son la presión del gas: lo que mantiene inflado un globo.',
                    'El aire es una mezcla de gases: casi 4 de cada 5 partes son nitrógeno y 1 de cada 5 es oxígeno, el gas que necesitamos para respirar.',
                  ],
                  izquierda: const [
                    Parte('solido', 'Sólido', '(partículas juntas)', '🧊', Color(0xFF1E88E5), 'Tiene forma y volumen propios. Sus partículas solo vibran.'),
                    Parte('liquido', 'Líquido', '(partículas que se deslizan)', '💧', Color(0xFF29B6F6),
                        'Tiene volumen fijo, pero toma la forma del recipiente.'),
                  ],
                  derecha: const [
                    Parte('gas', 'Gas', '(partículas libres)', '💨', Color(0xFF90A4AE), 'No tiene forma ni volumen propios: ocupa todo el espacio.'),
                  ],
                  resaltar: const {
                    1: {'gas'},
                    2: {'gas'},
                  },
                  mensajeFinal: '¡Ahora descubre datos curiosos de los gases!',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'q2_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Gases sorprendentes',
                  color: _c1,
                  textoZati: 'Los gases esconden muchas sorpresas. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(
                          Icons.local_fire_department_rounded, 'El gas de la estufa', 'No tiene olor: le agregan un olor fuerte para que detectemos una fuga.'),
                      TarjetaInfo(
                          Icons.bubble_chart_rounded, 'Las burbujas', 'Las burbujas del refresco son dióxido de carbono disuelto que escapa al abrirlo.'),
                      TarjetaInfo(Icons.air_rounded, 'El aire pesa', 'El aire de tu salón puede pesar tanto como un niño de tu edad.'),
                      TarjetaInfo(Icons.celebration_rounded, 'El helio', 'Es más ligero que el aire, por eso los globos con helio suben.'),
                    ]),
                    GrupoTarjetas('Gases importantes', _c1, Icons.cloud_rounded, [
                      TarjetaInfo(Icons.favorite_rounded, 'Oxígeno', 'Lo respiramos los animales y las plantas.'),
                      TarjetaInfo(Icons.eco_rounded, 'Dióxido de carbono', 'Lo exhalamos; las plantas lo usan para fabricar su alimento.'),
                      TarjetaInfo(Icons.water_drop_rounded, 'Vapor de agua', 'Forma las nubes.'),
                    ]),
                  ],
                  mensajeFinal: '¡Los gases están en todas partes!',
                )),
        PasoBio('Video del tema', TipoPasoBio.video, 'q2_m1_video',
            (a) => video(a, clave: 'gases_1', titulo: 'Video: los gases', tema: 'los estados de la materia y los gases', siguiente: '¡A clasificar!')),
        PasoBio(
            '¿Sólido, líquido o gas?',
            TipoPasoBio.laboratorio,
            'q2_m1_clas',
            (a) => clasificar(
                  a,
                  seccion: '3. Clasifica',
                  titulo: '¿Sólido, líquido o gas?',
                  color: _c1,
                  instruccion: 'Arrastra cada sustancia a su estado.',
                  grupos: const [
                    GrupoClasificar('Sólido', '🧊', Color(0xFF1E88E5)),
                    GrupoClasificar('Líquido', '💧', Color(0xFF29B6F6)),
                    GrupoClasificar('Gas', '💨', Color(0xFF90A4AE)),
                  ],
                  items: const [
                    ItemClasificar('🪨', 'Piedra', 0, 'Tiene forma propia.'),
                    ItemClasificar('🧊', 'Hielo', 0, 'Es agua en estado sólido.'),
                    ItemClasificar('🥛', 'Leche', 1, 'Toma la forma del vaso.'),
                    ItemClasificar('🍯', 'Miel', 1, 'Es un líquido espeso.'),
                    ItemClasificar('🌬️', 'Aire', 2, 'Ocupa todo el espacio.'),
                    ItemClasificar('♨️', 'Vapor de agua', 2, 'Es agua en estado gaseoso.'),
                  ],
                  mensajeFinal: 'El agua puede estar en los tres estados.',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q2_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilEstados, const {'solido': 'Sólido', 'liquido': 'Líquido', 'gas': 'Gas'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Cómo están las partículas de un gas?',
                        opciones: ['Muy separadas y moviéndose rápido', 'Muy juntas y quietas', 'No tiene partículas'],
                        correcta: 0,
                        explicacion: 'Por eso ocupan todo el espacio.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Distingues los estados de la materia.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Las propiedades de los gases',
      emoji: '🎈',
      color: _c2,
      intro: 'Los gases tienen masa, ocupan un volumen, se comprimen, fluyen y se expanden. ¡Compruébalo!',
      mensajeFinal: '¡Comprobaste las propiedades de los gases!',
      pasos: [
        PasoBio(
            'Las propiedades',
            TipoPasoBio.explicacion,
            'q2_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Propiedades',
                  titulo: 'Propiedades de los gases',
                  color: _c2,
                  il: ilGases,
                  textos: const [
                    'Los gases son materia: tienen masa y ocupan un volumen. Además se pueden comprimir (apretar en menos espacio), fluyen (se mueven y se esparcen) y se expanden (ocupan más espacio) cuando se calientan.',
                    'Estas propiedades se aprovechan todos los días: el aire comprimido infla las llantas, la expansión eleva los globos aerostáticos y la fluidez lleva el aroma de la comida hasta tu nariz.',
                    'Al comprimir un gas, sus partículas quedan más juntas. Al calentarlo, se mueven más rápido, chocan con más fuerza y se separan: el gas se expande.',
                    'Un balón inflado pesa un poquito más que desinflado. Y si dejas un globo inflado al sol, ¡se hace más grande!',
                  ],
                  izquierda: const [
                    Parte('masa', 'Masa', '(pesa)', '⚖️', Color(0xFF7E57C2), 'Un globo inflado pesa más que uno desinflado.'),
                    Parte('fluidez', 'Fluidez', '(se esparce)', '🌸', Color(0xFFEC407A), 'El aroma de un perfume llega hasta el otro lado del cuarto.'),
                    Parte('volumen', 'Volumen', '(ocupa espacio)', '🫙', Color(0xFF78909C), 'Un gas ocupa todo el recipiente que lo contiene.'),
                  ],
                  derecha: const [
                    Parte('compresible', 'Compresibilidad', '(se aprieta)', '🛞', Color(0xFF455A64), 'Las llantas guardan mucho aire en poco espacio.'),
                    Parte('expansion', 'Expansión', '(crece con el calor)', '🎈', Color(0xFFFF7043), 'Al calentarse, el gas ocupa más espacio.'),
                  ],
                  resaltar: const {
                    1: {'compresible', 'expansion', 'fluidez'},
                    2: {'compresible', 'expansion'},
                  },
                  mensajeFinal: '¡Ahora compruébalo en la jeringa!',
                )),
        PasoBio('La jeringa de gas', TipoPasoBio.simulacion, 'q2_m2_sim', (a) => SimGases(actividad: a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q2_m2_video',
            (a) => video(a,
                clave: 'gases_2',
                titulo: 'Video: propiedades de los gases',
                tema: 'masa, volumen, compresión y expansión',
                siguiente: '¡Ordena el experimento!')),
        PasoBio(
            'El globo que se infla solo',
            TipoPasoBio.laboratorio,
            'q2_m2_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Experimento',
                  titulo: 'El globo que se infla solo',
                  color: _c2,
                  instruccion: 'Ordena los pasos del experimento (con ayuda de un adulto, por el agua caliente).',
                  pasos: const [
                    ('🎈', 'Pon un globo en la boca de una botella vacía'),
                    ('♨️', 'Mete la botella en agua caliente'),
                    ('🌡️', 'El aire de la botella se calienta'),
                    ('💨', 'El aire se expande'),
                    ('🎉', '¡El globo se infla!'),
                  ],
                  explicacion: 'Si pasas la botella a agua fría, el aire se contrae y el globo se desinfla.',
                  mensajeFinal: '¡Así funciona la expansión de los gases!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q2_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilGases, const {'masa': 'Masa', 'compresible': 'Compresibilidad', 'fluidez': 'Fluidez', 'expansion': 'Expansión'},
                        color: _c2, instruccion: 'Nombra la propiedad que muestra cada objeto.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Qué le pasa a un gas cuando se calienta?',
                        opciones: ['Se expande', 'Se hace sólido', 'Desaparece'],
                        correcta: 0,
                        explicacion: 'Sus partículas se mueven más rápido y ocupan más espacio.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Conoces las propiedades de los gases.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Gases en la vida diaria',
      emoji: '🛞',
      color: _c3,
      intro: 'Los gases nos ayudan todos los días. ¡Y también hay que usarlos con cuidado!',
      mensajeFinal: '¡Usas los gases de forma segura!',
      pasos: [
        PasoBio(
            'Usos de los gases',
            TipoPasoBio.explicacion,
            'q2_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Usos',
                  titulo: 'Gases en la vida diaria',
                  color: _c3,
                  textoZati: 'Toca cada tarjeta para descubrir cómo aprovechamos los gases.',
                  grupos: const [
                    GrupoTarjetas('Los usamos para…', _c3, Icons.build_rounded, [
                      TarjetaInfo(Icons.tire_repair_rounded, 'Inflar llantas', 'El aire comprimido amortigua los golpes del camino.'),
                      TarjetaInfo(Icons.scuba_diving_rounded, 'Bucear', 'Los tanques guardan mucho aire comprimido.'),
                      TarjetaInfo(Icons.outdoor_grill_rounded, 'Cocinar', 'El gas LP de la estufa es un combustible.'),
                      TarjetaInfo(Icons.paragliding_rounded, 'Volar en globo', 'El aire caliente se expande y eleva el globo.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.landscape_rounded, 'Globos en Teotihuacan', 'Cada año cientos de globos aerostáticos vuelan sobre las pirámides.'),
                      TarjetaInfo(Icons.cookie_rounded, 'Palomitas', 'El agua dentro del maíz se vuelve vapor, se expande ¡y la palomita revienta!'),
                    ]),
                  ],
                  mensajeFinal: '¡Los gases trabajan para nosotros!',
                )),
        PasoBio(
            '¿Qué propiedad aprovecha?',
            TipoPasoBio.laboratorio,
            'q2_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Qué propiedad aprovecha?',
                  color: _c3,
                  instruccion: 'Arrastra cada ejemplo a la propiedad del gas que aprovecha.',
                  grupos: const [
                    GrupoClasificar('Compresión', '🛞', Color(0xFF455A64)),
                    GrupoClasificar('Expansión', '🎈', Color(0xFFFF7043)),
                    GrupoClasificar('Fluidez', '🌸', Color(0xFFEC407A)),
                  ],
                  items: const [
                    ItemClasificar('🤿', 'Tanque de buceo', 0, 'Guarda mucho aire en poco espacio.'),
                    ItemClasificar('⚽', 'Balón inflado', 0, 'El aire comprimido lo hace rebotar.'),
                    ItemClasificar('🎈', 'Globo aerostático', 1, 'El aire caliente se expande.'),
                    ItemClasificar('🍿', 'Palomitas', 1, 'El vapor se expande y las revienta.'),
                    ItemClasificar('🌺', 'Aroma de perfume', 2, 'Se esparce por el aire.'),
                    ItemClasificar('🍲', 'Olor de la comida', 2, 'Viaja hasta tu nariz.'),
                  ],
                  mensajeFinal: 'Cada aparato aprovecha una propiedad de los gases.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q2_m3_video',
            (a) =>
                video(a, clave: 'gases_3', titulo: 'Video: gases en casa', tema: 'usos de los gases y su uso seguro', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q2_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'El gas de la estufa',
                        'Toca lo que debes hacer si en casa huele a gas y presiona “Comprobar”.',
                        const [
                          Accion(Icons.window_rounded, 'Abrir puertas y ventanas', true, 'El gas fluye hacia afuera.'),
                          Accion(Icons.family_restroom_rounded, 'Avisar a un adulto', true, 'Debe cerrar la llave del tanque.'),
                          Accion(Icons.directions_walk_rounded, 'Salir de la cocina', true, 'Es más seguro.'),
                          Accion(Icons.light_rounded, 'Encender la luz o un cerillo', false, 'Una chispa puede provocar una explosión.'),
                          Accion(Icons.bed_rounded, 'Quedarse a dormir ahí', false, 'El gas es peligroso al respirarlo.'),
                        ],
                        color: _c3),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué el gas de la estufa tiene un olor tan fuerte?',
                        opciones: ['Le agregan olor para poder detectar fugas', 'Porque es comida', 'Porque es perfume'],
                        correcta: 0,
                        explicacion: 'El gas no tiene olor por sí mismo.',
                      ),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Sabes aprovechar los gases con seguridad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El globo de la feria',
      emoji: '🏆',
      color: Color(0xFFE65100),
      intro: '¡Último desafío! Ayuda a elevar el globo aerostático de la feria del pueblo.',
      mensajeFinal: '¡El globo aerostático se elevó sobre la feria!',
      pasos: [
        PasoBio(
            'El globo de la feria',
            TipoPasoBio.reto,
            'q2_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El globo de la feria',
                  color: const Color(0xFFE65100),
                  escenas: const [
                    EscenaBio(
                      titulo: 'El globo desinflado',
                      narracion: 'El globo está tendido en el pasto. Hay que llenarlo de aire.',
                      emojis: '🎈🌾',
                      pregunta: 'Al llenarlo, ¿qué propiedad de los gases observamos?',
                      opciones: ['Ocupan un volumen y todo el espacio', 'Son sólidos', 'No pesan'],
                      correcta: 0,
                      explicacion: 'El aire ocupa todo el globo.',
                    ),
                    EscenaBio(
                      titulo: 'El quemador',
                      narracion: 'El piloto enciende el quemador y calienta el aire del globo.',
                      emojis: '🔥🎈',
                      pregunta: '¿Qué le pasa al aire caliente?',
                      opciones: ['Se expande y se vuelve más ligero', 'Se congela', 'Se vuelve líquido'],
                      correcta: 0,
                      explicacion: 'El aire caliente es menos denso y sube.',
                    ),
                    EscenaBio(
                      titulo: 'Bajar',
                      narracion: 'Para aterrizar, el piloto deja que el aire se enfríe.',
                      emojis: '🎈⬇️',
                      pregunta: '¿Qué pasa con el aire frío?',
                      opciones: ['Se contrae y el globo baja', 'Se expande más', 'Desaparece'],
                      correcta: 0,
                      explicacion: 'El aire frío ocupa menos espacio y pesa más.',
                    ),
                  ],
                  mensajeFinal: '¡El globo voló sobre la feria!',
                )),
        PasoBio(
            'Supercerebro de gases',
            TipoPasoBio.reto,
            'q2_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFFE65100),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Los gases tienen masa?',
                          opciones: ['Sí, aunque no los veamos', 'No, no pesan nada', 'Solo el helio'],
                          correcta: 0,
                          explicacion: 'Un globo inflado pesa más.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué gas necesitamos para respirar?',
                          opciones: ['Oxígeno', 'Helio', 'Gas LP'],
                          correcta: 0,
                          explicacion: 'Es 1 de cada 5 partes del aire.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué propiedad permite guardar mucho aire en un tanque de buceo?',
                          opciones: ['Compresibilidad', 'Fluidez', 'Fragilidad'],
                          correcta: 0,
                          explicacion: 'Los gases se pueden apretar.'),
                      PreguntaQuiz(
                          pregunta: '¿Por qué el aroma del pan recién horneado llega a toda la casa?',
                          opciones: ['Porque los gases fluyen', 'Porque el pan camina', 'Por la luz'],
                          correcta: 0,
                          explicacion: 'Las partículas se esparcen.'),
                    ], color: const Color(0xFFE65100), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Explorador de los Gases!',
                )),
      ],
    ),
  ],
);
