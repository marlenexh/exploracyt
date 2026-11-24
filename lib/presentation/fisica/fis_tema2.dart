import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_fis.dart';
import 'ilustraciones_fis.dart';
import 'sims_fis.dart';

/// Física · Tema 2: La gravedad en acción.

const _c1 = Color(0xFF43A047);
const _c2 = Color(0xFF1E88E5);
const _c3 = Color(0xFF7E57C2);
const _ci = Color(0xFF2E7D32);

final fisTema2 = TemaBio(
  numero: 2,
  mundo: 'fis',
  estilo: estiloFis(FondoFis.gravedad),
  titulo: 'La gravedad en acción',
  saludo: '¿Por qué las cosas caen hacia abajo? ¿Por qué no salimos volando? ¡Gracias a la gravedad! Vamos a descubrir cómo funciona esta fuerza invisible.',
  misionDelTema: 'La agencia espacial prepara una misión a la Luna. Investiga la gravedad y la caída de los objetos para entrenar a los astronautas.',
  color: _ci,
  insignia: 'Explorador de la Gravedad',
  emojiInsignia: '🍎',
  emojisPanel: const ['🌍', '🌕', '🪂', '🪶', '🚀'],
  videos: const {
    'gravedad_1': 'assets/videos/gravedad_que_es.mp4',
    'gravedad_2': 'assets/videos/gravedad_caida.mp4',
    'gravedad_3': 'assets/videos/gravedad_efectos.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es la gravedad?',
      emoji: '🌍',
      color: _c1,
      intro: 'Una fuerza invisible nos mantiene pegados al suelo. ¡Conócela!',
      mensajeFinal: '¡Sabes qué es la gravedad!',
      pasos: [
        PasoBio(
            'La gravedad',
            TipoPasoBio.explicacion,
            'f2_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Gravedad',
                  titulo: '¿Qué es la gravedad?',
                  color: _c1,
                  il: ilGravedad,
                  textos: const [
                    'La gravedad es la fuerza con la que la Tierra atrae a los objetos hacia su centro. Todos los objetos con masa se atraen, pero la de la Tierra es la que sentimos.',
                    'Gracias a la gravedad caen la lluvia y los objetos, los ríos bajan de las montañas, no salimos volando y la Luna gira alrededor de la Tierra.',
                    'Jala hacia el centro del planeta, por eso las personas del otro lado del mundo no se caen. El peso es la fuerza con que la gravedad nos jala: en la Luna pesaríamos 6 veces menos.',
                    'Cuando saltas, la gravedad te regresa al suelo. ¡En la Luna podrías saltar mucho más alto!',
                  ],
                  izquierda: const [
                    Parte('manzana', 'La manzana', '(cae)', '🍎', Color(0xFFE53935), 'Cae porque la Tierra la atrae.'),
                    Parte('nino', 'Las personas', '(pegados al suelo)', '🧒', Color(0xFFFF8F00), 'La gravedad nos mantiene sobre la Tierra.'),
                  ],
                  derecha: const [
                    Parte('tierra', 'La Tierra', '(atrae)', '🌍', Color(0xFF1E88E5), 'Jala todo hacia su centro.'),
                    Parte('luna', 'La Luna', '(órbita)', '🌕', Color(0xFF78909C), 'La gravedad la mantiene girando alrededor de la Tierra.'),
                    Parte('balanza', 'El peso', '(fuerza de gravedad)', '⚖️', Color(0xFF6D4C41), 'Qué tan fuerte nos jala la gravedad.'),
                  ],
                  resaltar: const {
                    1: {'luna', 'manzana'},
                    2: {'balanza'},
                  },
                  mensajeFinal: '¡Ahora descubre datos curiosos!',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'f2_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'La gravedad sorprendente',
                  color: _c1,
                  textoZati: 'La gravedad tiene datos increíbles. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.park_rounded, 'Isaac Newton', 'Se cuenta que pensó en la gravedad al ver caer una manzana de un árbol.'),
                      TarjetaInfo(Icons.nightlight_rounded, 'En la Luna', 'La gravedad es 6 veces menor: un niño de 30 kg pesaría como uno de 5 kg.'),
                      TarjetaInfo(Icons.waves_rounded, 'Las mareas', 'La gravedad de la Luna jala el agua de los océanos y produce las mareas.'),
                      TarjetaInfo(
                          Icons.rocket_launch_rounded, 'Los astronautas', 'Flotan en la estación espacial porque caen junto con ella alrededor de la Tierra.'),
                    ]),
                  ],
                  mensajeFinal: '¡La gravedad es fascinante!',
                )),
        PasoBio('Video del tema', TipoPasoBio.video, 'f2_m1_video',
            (a) => video(a, clave: 'gravedad_1', titulo: 'Video: la gravedad', tema: 'qué es la gravedad', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f2_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilGravedad, const {'tierra': 'Tierra', 'luna': 'Luna', 'manzana': 'Objeto que cae', 'balanza': 'Peso'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Hacia dónde jala la gravedad de la Tierra?',
                          opciones: ['Hacia su centro', 'Hacia el Sol', 'Hacia arriba'],
                          correcta: 0,
                          explicacion: 'Por eso nadie se cae del planeta.'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes qué es la gravedad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'La caída de los objetos',
      emoji: '🪶',
      color: _c2,
      intro: '¿Una piedra cae más rápido que una pluma? ¡Haz el experimento de Galileo!',
      mensajeFinal: '¡Descubriste cómo caen los objetos!',
      pasos: [
        PasoBio(
            'Galileo y la caída',
            TipoPasoBio.explicacion,
            'f2_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Caída',
                  titulo: 'La caída de los objetos',
                  color: _c2,
                  il: ilCaida,
                  textos: const [
                    'Cuando soltamos un objeto, la gravedad lo hace caer. Sin aire, todos los objetos caerían al mismo tiempo, sin importar cuánto pesen.',
                    'En la Tierra, el aire frena a los objetos ligeros y extendidos, como una pluma o una hoja. A esto se le llama resistencia del aire, y la usan los paracaídas.',
                    'Galileo Galilei estudió la caída de los objetos hace más de 400 años, y se cuenta que soltó objetos desde la Torre de Pisa. En la Luna, un astronauta soltó un martillo y una pluma: ¡cayeron juntos!',
                    'Si arrugas una hoja de papel, cae más rápido que una hoja lisa: tiene menos superficie que choque con el aire.',
                  ],
                  izquierda: const [
                    Parte('torre', 'Torre de Pisa', '(Galileo)', '🗼', Color(0xFF8D6E63), 'Galileo estudió cómo caen los objetos.'),
                    Parte('galileo', 'Galileo Galilei', '(científico)', '👨‍🔬', Color(0xFF5E35B1), 'Descubrió que la masa no cambia la velocidad de caída.'),
                  ],
                  derecha: const [
                    Parte('piedra', 'Piedra', '(cae rápido)', '🪨', Color(0xFF78909C), 'El aire casi no la frena.'),
                    Parte('pluma', 'Pluma', '(cae lento)', '🪶', Color(0xFF26A69A), 'El aire la frena mucho.'),
                    Parte('paracaidas', 'Paracaídas', '(resistencia del aire)', '🪂', Color(0xFFFF7043), 'Su tela grande atrapa el aire y frena la caída.'),
                  ],
                  resaltar: const {
                    1: {'pluma', 'paracaidas'},
                    2: {'galileo', 'torre'},
                  },
                  mensajeFinal: '¡Ahora haz el experimento!',
                )),
        PasoBio('¿Cuál cae primero?', TipoPasoBio.simulacion, 'f2_m2_sim', (a) => SimCaida(actividad: a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f2_m2_video',
            (a) => video(a,
                clave: 'gravedad_2',
                titulo: 'Video: la caída libre',
                tema: 'cómo caen los objetos y la resistencia del aire',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f2_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilCaida, const {'piedra': 'Piedra', 'pluma': 'Pluma', 'paracaidas': 'Paracaídas', 'galileo': 'Galileo'}, color: _c2),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: 'En la Luna se sueltan una pluma y un martillo. ¿Qué pasa?',
                        opciones: ['Caen al mismo tiempo porque no hay aire', 'El martillo cae primero', 'La pluma flota'],
                        correcta: 0,
                        explicacion: 'Sin aire no hay resistencia.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Entiendes la caída de los objetos.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Efectos de la gravedad',
      emoji: '🌊',
      color: _c3,
      intro: 'La gravedad está detrás de muchas cosas que pasan a tu alrededor. ¡Encuéntralas!',
      mensajeFinal: '¡Reconoces los efectos de la gravedad!',
      pasos: [
        PasoBio(
            '¿Es por la gravedad?',
            TipoPasoBio.laboratorio,
            'f2_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '1. Clasifica',
                  titulo: '¿Es por la gravedad?',
                  color: _c3,
                  instruccion: 'Arrastra cada situación al grupo correcto.',
                  grupos: const [GrupoClasificar('Por la gravedad', '🌍', Color(0xFF43A047)), GrupoClasificar('Por otra causa', '❓', Color(0xFF78909C))],
                  items: const [
                    ItemClasificar('🌧️', 'La lluvia cae', 0, 'La gravedad jala las gotas.'),
                    ItemClasificar('🏞️', 'El río baja de la montaña', 0, 'El agua baja por la gravedad.'),
                    ItemClasificar('🌕', 'La Luna gira alrededor de la Tierra', 0, 'La gravedad la mantiene en órbita.'),
                    ItemClasificar('🛝', 'Bajas por la resbaladilla', 0, 'La gravedad te jala hacia abajo.'),
                    ItemClasificar('🧲', 'Un imán atrae un clip', 1, 'Es el magnetismo.'),
                    ItemClasificar('🎈', 'Un globo de helio sube', 1, 'El aire lo empuja hacia arriba porque es más ligero.'),
                    ItemClasificar('🌬️', 'El viento mueve las hojas', 1, 'Es el aire en movimiento.'),
                  ],
                  mensajeFinal: 'La gravedad actúa todo el tiempo a nuestro alrededor.',
                )),
        PasoBio(
            'Memorama de la gravedad',
            TipoPasoBio.juego,
            'f2_m3_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama de la gravedad',
                  color: _c3,
                  instruccion: 'Encuentra cada pareja.',
                  pares: const [
                    ('🍎', 'Newton', 'Pensó en la manzana que cae'),
                    ('🗼', 'Galileo', 'Estudió la caída de los objetos'),
                    ('🌕', 'Luna', 'Gravedad 6 veces menor'),
                    ('🪂', 'Paracaídas', 'Resistencia del aire'),
                    ('🌊', 'Mareas', 'Las produce la Luna'),
                    ('⚖️', 'Peso', 'Fuerza de la gravedad'),
                  ],
                  mensajeFinal: '¡Memoria de astronauta!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f2_m3_video',
            (a) => video(a,
                clave: 'gravedad_3',
                titulo: 'Video: efectos de la gravedad',
                tema: 'la gravedad en la vida diaria y en el espacio',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f2_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseRelacionar(const [
                      ('Gravedad', 'Fuerza que atrae los objetos hacia la Tierra.'),
                      ('Peso', 'Qué tan fuerte nos jala la gravedad.'),
                      ('Resistencia del aire', 'Frena a los objetos que caen.'),
                      ('Órbita', 'Camino de la Luna alrededor de la Tierra.'),
                    ], color: _c3, instruccion: 'Relaciona cada concepto.'),
                  ],
                  mensajeFinal: 'Reconoces los efectos de la gravedad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'Misión a la Luna',
      emoji: '🏆',
      color: Color(0xFF283593),
      intro: '¡Último desafío! Entrena a los astronautas para su misión a la Luna.',
      mensajeFinal: '¡Los astronautas están listos para la Luna!',
      pasos: [
        PasoBio(
            'Misión a la Luna',
            TipoPasoBio.reto,
            'f2_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'Misión a la Luna',
                  color: const Color(0xFF283593),
                  escenas: const [
                    EscenaBio(
                      titulo: 'El peso en la Luna',
                      narracion: 'La astronauta Sofía pesa 60 kg en la Tierra.',
                      emojis: '👩‍🚀⚖️',
                      pregunta: '¿Cuánto pesaría aproximadamente en la Luna?',
                      opciones: ['Unos 10 kg', '120 kg', '60 kg'],
                      correcta: 0,
                      explicacion: 'La gravedad de la Luna es 6 veces menor.',
                    ),
                    EscenaBio(
                      titulo: 'Saltos',
                      narracion: 'En el entrenamiento practican saltar en la Luna.',
                      emojis: '🌕🦘',
                      pregunta: '¿Cómo serán sus saltos?',
                      opciones: ['Mucho más altos', 'Más bajos', 'Iguales'],
                      correcta: 0,
                      explicacion: 'La gravedad los jala con menos fuerza.',
                    ),
                    EscenaBio(
                      titulo: 'El regreso',
                      narracion: 'La cápsula regresa a la Tierra y necesita frenar antes de caer al mar.',
                      emojis: '🚀🪂',
                      pregunta: '¿Qué usan para frenar?',
                      opciones: ['Paracaídas', 'Imanes', 'Un globo de helio'],
                      correcta: 0,
                      explicacion: 'La resistencia del aire frena la caída.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro de la gravedad',
            TipoPasoBio.reto,
            'f2_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF283593),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué hace que la lluvia caiga?',
                          opciones: ['La gravedad', 'El magnetismo', 'El viento'],
                          correcta: 0,
                          explicacion: 'La Tierra jala las gotas.'),
                      PreguntaQuiz(
                          pregunta: '¿Por qué la hoja lisa cae más lento que la arrugada?',
                          opciones: ['El aire la frena más', 'Pesa más', 'La gravedad no la jala'],
                          correcta: 0,
                          explicacion: 'Tiene más superficie.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué produce las mareas?',
                          opciones: ['La gravedad de la Luna', 'Los peces', 'Las nubes'],
                          correcta: 0,
                          explicacion: 'La Luna jala el agua de los océanos.'),
                    ], color: const Color(0xFF283593), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Explorador de la Gravedad!',
                )),
      ],
    ),
  ],
);
