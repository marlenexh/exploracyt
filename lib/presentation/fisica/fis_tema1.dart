import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import '../ciencia/fondos_ciencia.dart';
import 'ilustraciones_fis.dart';
import 'sims_fis.dart';

/// Física · Tema 1: El magnetismo y sus misterios.

const _c1 = Color(0xFFD32F2F);
const _c2 = Color(0xFF5E35B1);
const _c3 = Color(0xFF00897B);
const _ci = Color(0xFFC62828);

final fisTema1 = TemaBio(
  numero: 1,
  mundo: 'fis',
  estilo: estiloCiencia(FondoCiencia.magnetismo),
  titulo: 'El magnetismo y sus misterios',
  saludo: 'Los imanes parecen mágicos: atraen objetos sin tocarlos y se jalan o se empujan entre sí. ¡Vamos a resolver los misterios del magnetismo!',
  misionDelTema: 'Un explorador perdió su brújula y un anillo en el fondo de un pozo. Investiga los imanes, sus polos y sus usos para ayudarlo.',
  color: _ci,
  insignia: 'Maestro de los Imanes',
  emojiInsignia: '🧲',
  emojisPanel: const ['🧭', '📎', '🔩', '🌍', '🧲'],
  videos: const {
    'magnetismo_1': 'assets/videos/magnetismo_polos.mp4',
    'magnetismo_2': 'assets/videos/magnetismo_materiales.mp4',
    'magnetismo_3': 'assets/videos/magnetismo_usos.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Imanes y polos',
      emoji: '🧲',
      color: _c1,
      intro: 'Todo imán tiene dos polos. ¿Qué pasa cuando los acercas?',
      mensajeFinal: '¡Conoces los polos de los imanes!',
      pasos: [
        PasoBio(
            '¿Qué es el magnetismo?',
            TipoPasoBio.explicacion,
            'f1_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Imanes',
                  titulo: 'Los imanes y sus polos',
                  color: _c1,
                  il: ilImanes,
                  textos: const [
                    'El magnetismo es la fuerza con la que los imanes atraen algunos metales, como el hierro, sin tocarlos. Alrededor de un imán hay un campo magnético invisible.',
                    'Los imanes sirven para cerrar puertas de refrigerador, en bocinas, motores, brújulas y hasta en trenes que flotan.',
                    'Todo imán tiene un polo norte (N) y un polo sur (S). Polos diferentes se atraen y polos iguales se repelen. Si partes un imán a la mitad, ¡cada pedazo tiene otra vez N y S!',
                    'La fuerza del imán es mayor en sus polos. Si echas limaduras de hierro cerca de un imán, dibujan las líneas de su campo magnético.',
                  ],
                  izquierda: const [
                    Parte('clip', 'Clip de acero', '(es atraído)', '📎', Color(0xFF78909C), 'Los objetos de hierro o acero son atraídos por el imán.'),
                  ],
                  derecha: const [
                    Parte('clavo', 'Clavo de hierro', '(es atraído)', '🔩', Color(0xFF546E7A), 'El hierro es un material magnético.'),
                  ],
                  resaltar: const {},
                  mensajeFinal: '¡Ahora experimenta con los polos!',
                )),
        PasoBio('Polos magnéticos', TipoPasoBio.simulacion, 'f1_m1_sim', (a) => SimImanes(actividad: a, color: _c1)),
        PasoBio('Video del tema', TipoPasoBio.video, 'f1_m1_video',
            (a) => video(a, clave: 'magnetismo_1', titulo: 'Video: los imanes', tema: 'polos, atracción y repulsión', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f1_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseRelacionar(const [
                      ('Polo norte y polo sur', 'Se atraen.'),
                      ('Dos polos norte', 'Se repelen.'),
                      ('Campo magnético', 'Zona invisible donde actúa el imán.'),
                      ('Magnetismo', 'Fuerza de los imanes.'),
                    ], color: _c1, instruccion: 'Relaciona cada concepto.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: 'Si partes un imán a la mitad, ¿qué obtienes?',
                        opciones: ['Dos imanes, cada uno con polo norte y polo sur', 'Un polo norte y un polo sur separados', 'Ya no es imán'],
                        correcta: 0,
                        explicacion: 'Nunca existe un polo solo.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Conoces los polos magnéticos.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: '¿Qué atrae un imán?',
      emoji: '📎',
      color: _c2,
      intro: '¿Un imán atrae todos los metales? ¡Ponlo a prueba!',
      mensajeFinal: '¡Sabes qué materiales son magnéticos!',
      pasos: [
        PasoBio(
            'Prueba con el imán',
            TipoPasoBio.laboratorio,
            'f1_m2_lab',
            (a) => lab(
                  a,
                  titulo: '¿Lo atrae el imán?',
                  color: _c2,
                  instruccion: 'Acerca el imán a cada objeto. Anota si es de metal y si el imán lo atrae. Toca cada “?”.',
                  pruebas: const [
                    Prueba('¿Es de metal?', '🔍', 'Metal', 'No metal'),
                    Prueba('Acercar el imán', '🧲', 'Lo atrae', 'No lo atrae'),
                  ],
                  muestras: const [
                    Muestra('Clip', '📎', [true, true], datos: ['Es de acero.', 'El acero tiene hierro.']),
                    Muestra('Clavo', '🔩', [true, true], datos: ['Es de hierro.', '¡Se pega al imán!']),
                    Muestra('Lata de refresco', '🥫', [true, false], datos: ['Es de aluminio.', 'El aluminio no es magnético.']),
                    Muestra('Llave dorada', '🔑', [true, false], datos: ['Es de latón (cobre y zinc).', 'No la atrae.']),
                    Muestra('Lápiz', '✏️', [false, false], datos: ['Es de madera y grafito.', 'No es magnético.']),
                    Muestra('Goma', '🧽', [false, false], datos: ['Es de hule.', 'No la atrae.']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: '¿Los imanes atraen todos los metales?',
                    opciones: ['No, solo algunos como el hierro, el acero y el níquel', 'Sí, todos los metales', 'Solo el aluminio'],
                    correcta: 0,
                    explicacion: 'El aluminio, el cobre y el oro no son atraídos.',
                  ),
                  mensajeFinal: 'Los imanes atraen materiales con hierro, níquel o cobalto, como el acero.',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'f1_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Misterios magnéticos',
                  color: _c2,
                  textoZati: 'Los imanes tienen una historia sorprendente. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.landscape_rounded, 'La magnetita',
                          'Es una roca que es imán natural. Los antiguos griegos la encontraron en una región llamada Magnesia.'),
                      TarjetaInfo(Icons.explore_rounded, 'La primera brújula', 'Los chinos inventaron la brújula hace más de 2 000 años.'),
                      TarjetaInfo(Icons.train_rounded, 'Trenes que flotan', 'Los trenes maglev flotan sobre imanes y pueden ir a más de 400 km/h.'),
                      TarjetaInfo(Icons.whatshot_rounded, 'El calor', 'Si calientas mucho un imán, pierde su magnetismo.'),
                    ]),
                  ],
                  mensajeFinal: '¡El magnetismo es sorprendente!',
                )),
        PasoBio('Video del tema', TipoPasoBio.video, 'f1_m2_video',
            (a) => video(a, clave: 'magnetismo_2', titulo: 'Video: materiales magnéticos', tema: 'qué atrae un imán', siguiente: '¡A atrapar con el imán!')),
        PasoBio(
            'Atrapa con el imán',
            TipoPasoBio.juego,
            'f1_m2_juego',
            (a) => atrapar(
                  a,
                  titulo: 'El imán atrapa-todo',
                  instrucciones: 'Mueve el imán con tu dedo. Atrapa solo los objetos que el imán puede atraer.',
                  color: _c2,
                  recolector: '🧲',
                  cosas: const [
                    CosaQueCae('📎', true),
                    CosaQueCae('🔩', true),
                    CosaQueCae('🪛', true),
                    CosaQueCae('✂️', true),
                    CosaQueCae('🥫', false, mensaje: 'La lata de aluminio no es magnética.'),
                    CosaQueCae('✏️', false, mensaje: 'La madera no es magnética.'),
                    CosaQueCae('🧸', false, mensaje: 'La tela no es atraída.'),
                    CosaQueCae('🪙', false, mensaje: 'Las monedas de cobre no son atraídas.'),
                  ],
                  mensajeFinal: '¡Tu imán atrapó todos los objetos de hierro y acero!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f1_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuál de estos objetos atrae un imán?',
                          opciones: ['Unas tijeras de acero', 'Una lata de aluminio', 'Un lápiz'],
                          correcta: 0,
                          explicacion: 'El acero tiene hierro.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué es la magnetita?',
                          opciones: ['Una roca que es imán natural', 'Un tipo de plástico', 'Una brújula'],
                          correcta: 0,
                          explicacion: 'Es un imán que se encuentra en la naturaleza.'),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Sabes qué materiales son magnéticos.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'La Tierra es un imán',
      emoji: '🧭',
      color: _c3,
      intro: '¿Por qué la brújula siempre apunta al norte? ¡La Tierra guarda un secreto!',
      mensajeFinal: '¡Conoces los usos del magnetismo!',
      pasos: [
        PasoBio(
            'La Tierra, un gran imán',
            TipoPasoBio.explicacion,
            'f1_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. La Tierra',
                  titulo: 'La Tierra es un gran imán',
                  color: _c3,
                  il: ilTierraIman,
                  textos: const [
                    'El centro de la Tierra tiene hierro fundido en movimiento que la convierte en un enorme imán, con un campo magnético a su alrededor.',
                    'Gracias a él funciona la brújula y muchos animales, como algunas aves y tortugas marinas, se orientan en sus viajes. Además nos protege de partículas que vienen del Sol.',
                    'La aguja de la brújula es un pequeño imán que gira libremente y se alinea con el campo magnético de la Tierra: su punta señala el norte.',
                    'Cerca de los polos, las partículas del Sol chocan con el campo magnético y forman las auroras: luces de colores en el cielo.',
                  ],
                  izquierda: const [
                    Parte('aurora', 'Auroras', '(luces en el cielo)', '🌌', Color(0xFF26A69A), 'Aparecen cerca de los polos.'),
                    Parte('brujula', 'Brújula', '(apunta al norte)', '🧭', Color(0xFFE53935), 'Su aguja magnética se orienta con la Tierra.'),
                  ],
                  derecha: const [
                    Parte('tierra', 'Tierra', '(gran imán)', '🌍', Color(0xFF1E88E5), 'Su núcleo de hierro produce el campo magnético.'),
                    Parte('ave', 'Aves migratorias', '(se orientan)', '🐦', Color(0xFF8D6E63), 'Sienten el campo magnético para no perderse.'),
                  ],
                  resaltar: const {
                    1: {'brujula', 'ave'},
                    3: {'aurora'},
                  },
                  mensajeFinal: '¡Ahora descubre los usos de los imanes!',
                )),
        PasoBio(
            'Usos del magnetismo',
            TipoPasoBio.explicacion,
            'f1_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Aplicaciones',
                  titulo: 'Los imanes trabajan para nosotros',
                  color: _c3,
                  textoZati: 'Hay imanes en muchos aparatos. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Aplicaciones', _c3, Icons.build_rounded, [
                      TarjetaInfo(Icons.kitchen_rounded, 'Refrigerador', 'Un imán en la puerta la mantiene cerrada.'),
                      TarjetaInfo(Icons.speaker_rounded, 'Bocinas', 'Un imán hace vibrar la bocina para producir sonido.'),
                      TarjetaInfo(Icons.precision_manufacturing_rounded, 'Grúas de chatarra', 'Usan electroimanes que se encienden y apagan.'),
                      TarjetaInfo(Icons.medical_services_rounded, 'Resonancia magnética', 'Los médicos ven el interior del cuerpo con imanes gigantes.'),
                    ]),
                  ],
                  mensajeFinal: '¡El magnetismo está por todas partes!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f1_m3_video',
            (a) => video(a,
                clave: 'magnetismo_3',
                titulo: 'Video: la Tierra y la brújula',
                tema: 'el magnetismo terrestre y sus aplicaciones',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f1_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseEtiquetar(ilTierraIman, const {'tierra': 'Tierra', 'brujula': 'Brújula', 'aurora': 'Aurora', 'ave': 'Ave migratoria'}, color: _c3),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué la brújula señala el norte?',
                        opciones: ['Su aguja es un imán que se alinea con el campo magnético de la Tierra', 'Porque el viento la mueve', 'Porque está pintada'],
                        correcta: 0,
                        explicacion: 'La Tierra se comporta como un gran imán.',
                      ),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Conoces el magnetismo terrestre.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El explorador perdido',
      emoji: '🏆',
      color: Color(0xFF6A1B9A),
      intro: '¡Último desafío! Ayuda al explorador a orientarse y a rescatar su anillo.',
      mensajeFinal: '¡El explorador encontró el camino y su anillo!',
      pasos: [
        PasoBio(
            'El explorador perdido',
            TipoPasoBio.reto,
            'f1_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El explorador perdido',
                  color: const Color(0xFF6A1B9A),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Sin brújula',
                      narracion: 'El explorador tiene una aguja de coser, un imán y un vaso con agua.',
                      emojis: '🪡🧲💧',
                      pregunta: '¿Cómo puede hacer una brújula?',
                      opciones: ['Frotar la aguja con el imán y ponerla a flotar en el agua sobre una hoja', 'Pintar la aguja', 'Calentar el agua'],
                      correcta: 0,
                      explicacion: 'La aguja se magnetiza y se orienta al norte.',
                    ),
                    EscenaBio(
                      titulo: 'El pozo',
                      narracion: 'Se le cayó un anillo de hierro a un pozo profundo.',
                      emojis: '💍🕳️',
                      pregunta: '¿Cómo lo saca?',
                      opciones: ['Con un imán atado a una cuerda', 'Con un palito de madera', 'Gritando'],
                      correcta: 0,
                      explicacion: 'El imán atrae el hierro.',
                    ),
                    EscenaBio(
                      titulo: 'Otro objeto',
                      narracion: 'También cayó una moneda de cobre y el imán no la atrae.',
                      emojis: '🪙🧲',
                      pregunta: '¿Por qué?',
                      opciones: ['El cobre no es un material magnético', 'El imán está roto', 'Está muy oscuro'],
                      correcta: 0,
                      explicacion: 'Solo algunos metales son magnéticos.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro magnético',
            TipoPasoBio.reto,
            'f1_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF6A1B9A),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué pasa si acercas dos polos sur?',
                          opciones: ['Se repelen', 'Se atraen', 'Nada'],
                          correcta: 0,
                          explicacion: 'Polos iguales se repelen.'),
                      PreguntaQuiz(
                          pregunta: '¿Dónde es más fuerte un imán?',
                          opciones: ['En sus polos', 'En el centro', 'Es igual en todas partes'],
                          correcta: 0,
                          explicacion: 'Ahí se juntan más limaduras.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué metal NO atrae un imán?',
                          opciones: ['Aluminio', 'Hierro', 'Acero'],
                          correcta: 0,
                          explicacion: 'El aluminio no es magnético.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué forman las partículas del Sol cerca de los polos?',
                          opciones: ['Auroras', 'Arcoíris', 'Nubes'],
                          correcta: 0,
                          explicacion: 'Luces de colores en el cielo.'),
                    ], color: const Color(0xFF6A1B9A), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Maestro de los Imanes!',
                )),
      ],
    ),
  ],
);
