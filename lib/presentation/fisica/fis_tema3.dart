import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import 'fondos_fis.dart';
import 'ilustraciones_fis.dart';
import 'sims_fis.dart';

/// Física · Tema 3: Calor y energía térmica.

const _c1 = Color(0xFFFF8F00);
const _c2 = Color(0xFFE64A19);
const _c3 = Color(0xFF6D4C41);
const _ci = Color(0xFFEF6C00);

final fisTema3 = TemaBio(
  numero: 3,
  mundo: 'fis',
  estilo: estiloFis(FondoFis.calor),
  titulo: 'Calor y energía térmica',
  saludo:
      'El chocolate caliente, el hielo que se derrite, el Sol que calienta la tierra… ¡el calor está en todas partes! Vamos a descubrir cómo viaja y cómo lo medimos.',
  misionDelTema: 'La abuela prepara pozole para toda la familia. Ayúdale a entender la temperatura y cómo viaja el calor para cocinar sin quemarse.',
  color: _ci,
  insignia: 'Experto en Calor',
  emojiInsignia: '🌡️',
  emojisPanel: const ['☀️', '🔥', '🧊', '☕', '🧤'],
  videos: const {
    'calor_1': 'assets/videos/calor_temperatura.mp4',
    'calor_2': 'assets/videos/calor_transferencia.mp4',
    'calor_3': 'assets/videos/calor_conductores.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Temperatura y calor',
      emoji: '🌡️',
      color: _c1,
      intro: '¿Calor y temperatura son lo mismo? ¡Descúbrelo!',
      mensajeFinal: '¡Distingues el calor de la temperatura!',
      pasos: [
        PasoBio(
            'Temperatura y calor',
            TipoPasoBio.explicacion,
            'f3_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Temperatura',
                  titulo: 'Temperatura y calor',
                  color: _c1,
                  il: ilTemperatura,
                  textos: const [
                    'La temperatura indica qué tan caliente o frío está algo y se mide con un termómetro en grados Celsius (°C). El calor es la energía que pasa de un cuerpo más caliente a uno más frío.',
                    'Medir la temperatura nos ayuda a saber si tenemos fiebre, a cocinar bien los alimentos y a saber cómo vestirnos según el clima.',
                    'El calor siempre viaja de lo caliente a lo frío, hasta que los dos tienen la misma temperatura. Por eso tu chocolate caliente se enfría y tu agua fría se calienta en la mesa.',
                    'Tu cuerpo está a unos 36.5 °C. El agua se congela a 0 °C y hierve a 100 °C.',
                  ],
                  izquierda: const [
                    Parte('caliente', 'Caliente', '(cede calor)', '☕', Color(0xFFE53935), 'Le pasa calor a lo que está más frío.'),
                    Parte('cuerpo', 'Tu cuerpo', '(36.5 °C)', '🧒', Color(0xFFFF7043), 'Si sube a más de 37.5 °C, tienes fiebre.'),
                  ],
                  derecha: const [
                    Parte('termometro', 'Termómetro', '(mide en °C)', '🌡️', Color(0xFFD32F2F), 'Mide la temperatura.'),
                    Parte('frio', 'Frío', '(recibe calor)', '🧊', Color(0xFF29B6F6), 'Recibe calor y se derrite.'),
                    Parte('hervir', 'Agua hirviendo', '(100 °C)', '♨️', Color(0xFF78909C), 'Al nivel del mar, el agua hierve a 100 °C.'),
                  ],
                  resaltar: const {
                    0: {'termometro'},
                    2: {'caliente', 'frio'},
                  },
                  mensajeFinal: '¡Ahora ordena las temperaturas!',
                )),
        PasoBio(
            'Del más frío al más caliente',
            TipoPasoBio.juego,
            'f3_m1_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Ordena',
                  titulo: 'Del más frío al más caliente',
                  color: _c1,
                  instruccion: 'Ordena de la temperatura más baja a la más alta.',
                  pasos: const [
                    ('🧊', 'Hielo (0 °C)'),
                    ('🥛', 'Leche del refri (4 °C)'),
                    ('🧒', 'Tu cuerpo (36.5 °C)'),
                    ('♨️', 'Agua hirviendo (100 °C)'),
                    ('🍕', 'Horno de pizza (250 °C)'),
                  ],
                  explicacion: 'El termómetro nos dice exactamente qué tan caliente está algo.',
                  mensajeFinal: '¡Sabes comparar temperaturas!',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'f3_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '3. Datos curiosos',
                  titulo: 'Temperaturas extremas',
                  color: _c1,
                  textoZati: '¡Hay lugares muy calientes y muy fríos! Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.wb_sunny_rounded, 'Mexicali', 'Es una de las ciudades más calurosas de México: ¡ha llegado a más de 50 °C!'),
                      TarjetaInfo(Icons.brightness_7_rounded, 'El Sol', 'Su superficie está a unos 5 500 °C.'),
                      TarjetaInfo(Icons.ac_unit_rounded, 'La Antártida', 'Ahí se midió una de las temperaturas más bajas de la Tierra: unos −89 °C.'),
                      TarjetaInfo(Icons.landscape_rounded, 'El Pico de Orizaba', 'Su cima tiene nieve todo el año porque en las alturas hace mucho frío.'),
                    ]),
                  ],
                  mensajeFinal: '¡El calor y el frío extremos son impresionantes!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f3_m1_video',
            (a) => video(a,
                clave: 'calor_1',
                titulo: 'Video: temperatura y calor',
                tema: 'la diferencia entre calor y temperatura',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f3_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Con qué se mide la temperatura?',
                          opciones: ['Con un termómetro', 'Con una regla', 'Con una balanza'],
                          correcta: 0,
                          explicacion: 'En grados Celsius (°C).'),
                      PreguntaQuiz(
                          pregunta: 'Dejas un vaso de agua fría en la mesa. ¿Qué pasa?',
                          opciones: ['Recibe calor del aire y se calienta', 'Se enfría más', 'Se congela'],
                          correcta: 0,
                          explicacion: 'El calor va de lo caliente a lo frío.'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes qué son el calor y la temperatura.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: '¿Cómo viaja el calor?',
      emoji: '🔥',
      color: _c2,
      intro: 'El calor viaja de tres formas. ¡Descúbrelas!',
      mensajeFinal: '¡Conoces las formas de transferencia de calor!',
      pasos: [
        PasoBio(
            'Conducción, convección y radiación',
            TipoPasoBio.explicacion,
            'f3_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Transferencia',
                  titulo: 'Cómo viaja el calor',
                  color: _c2,
                  il: ilTransferencia,
                  textos: const [
                    'El calor viaja de tres formas: por conducción (por contacto, a través de un material), por convección (con el movimiento de líquidos y gases) y por radiación (en ondas, sin necesitar materia).',
                    'Entenderlas nos ayuda a cocinar, a calentar o enfriar las casas y a protegernos del Sol.',
                    'Una cuchara en una sopa caliente se calienta por conducción. En una olla, el agua caliente sube y la fría baja: es convección. El calor del Sol llega hasta la Tierra por radiación, ¡atravesando el espacio vacío!',
                    'Sientes la radiación cuando te acercas a una fogata: aunque no la toques, te calienta la cara.',
                  ],
                  izquierda: const [
                    Parte('conduccion', 'Conducción', '(por contacto)', '🥄', Color(0xFF78909C),
                        'El calor pasa de partícula en partícula a través del material.'),
                    Parte('radiacion', 'Radiación', '(en ondas)', '☀️', Color(0xFFFFB300), 'Viaja incluso por el espacio vacío.'),
                  ],
                  derecha: const [
                    Parte('convencion', 'Convección', '(corrientes)', '🍲', Color(0xFFE64A19), 'El líquido o gas caliente sube y el frío baja.'),
                    Parte('fogata', 'Fogata', '(radiación)', '🔥', Color(0xFFFF7043), 'Te calienta aunque no la toques.'),
                  ],
                  resaltar: const {
                    2: {'conduccion', 'convencion', 'radiacion'},
                  },
                  mensajeFinal: '¡Ahora experimenta con los bloques!',
                )),
        PasoBio('El viaje del calor', TipoPasoBio.simulacion, 'f3_m2_sim', (a) => SimCalor(actividad: a, color: _c2)),
        PasoBio(
            '¿Cómo viaja aquí?',
            TipoPasoBio.laboratorio,
            'f3_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Cómo viaja el calor aquí?',
                  color: _c2,
                  instruccion: 'Arrastra cada ejemplo a la forma en que viaja el calor.',
                  grupos: const [
                    GrupoClasificar('Conducción', '🥄', Color(0xFF78909C)),
                    GrupoClasificar('Convección', '🍲', Color(0xFFE64A19)),
                    GrupoClasificar('Radiación', '☀️', Color(0xFFFFB300)),
                  ],
                  items: const [
                    ItemClasificar('🍳', 'Se calienta el mango de la sartén', 0, 'Por contacto con el metal caliente.'),
                    ItemClasificar('🧊', 'Un hielo se derrite en tu mano', 0, 'Tu mano le pasa calor por contacto.'),
                    ItemClasificar('♨️', 'El agua de la olla circula al hervir', 1, 'El agua caliente sube y la fría baja.'),
                    ItemClasificar('🎈', 'El aire caliente sube en un globo', 1, 'Es una corriente de convección.'),
                    ItemClasificar('🏖️', 'El Sol calienta la arena', 2, 'Llega por radiación.'),
                    ItemClasificar('🔥', 'Una fogata te calienta la cara', 2, 'Sin tocarla.'),
                  ],
                  mensajeFinal: 'El calor siempre encuentra cómo viajar.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f3_m2_video',
            (a) => video(a,
                clave: 'calor_2',
                titulo: 'Video: transferencia de calor',
                tema: 'conducción, convección y radiación',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f3_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilTransferencia, const {'conduccion': 'Conducción', 'convencion': 'Convección', 'radiacion': 'Radiación'}, color: _c2),
                  ],
                  mensajeFinal: 'Conoces cómo viaja el calor.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Conductores y aislantes',
      emoji: '🧤',
      color: _c3,
      intro: 'Algunos materiales dejan pasar el calor y otros lo detienen. ¡Ponlos a prueba!',
      mensajeFinal: '¡Usas el calor con seguridad!',
      pasos: [
        PasoBio(
            'Cucharas en el té',
            TipoPasoBio.laboratorio,
            'f3_m3_lab',
            (a) => lab(
                  a,
                  titulo: 'Cucharas en el té caliente',
                  color: _c3,
                  instruccion: 'Pusimos cucharas de distintos materiales en té caliente. Después de 2 minutos, toca el mango: ¿se calentó?',
                  pruebas: const [
                    Prueba('Mango a los 2 minutos', '✋', 'Caliente', 'Frío'),
                    Prueba('El material es…', '🔍', 'Conductor', 'Aislante'),
                  ],
                  muestras: const [
                    Muestra('Cuchara de metal', '🥄', [true, true], datos: ['¡Se calentó mucho!', 'Los metales conducen bien el calor.']),
                    Muestra('Cuchara de madera', '🪵', [false, false], datos: ['Sigue fría.', 'La madera es aislante.']),
                    Muestra('Cuchara de plástico', '🍴', [false, false], datos: ['Casi no se calentó.', 'El plástico es aislante.']),
                    Muestra('Clavo de hierro', '🔩', [true, true], datos: ['Se calentó.', 'El hierro es conductor.']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: '¿Por qué las ollas tienen mango de madera o plástico?',
                    opciones: ['Porque son aislantes y no te quemas', 'Porque son conductores', 'Para que pesen más'],
                    correcta: 0,
                    explicacion: 'El metal de la olla conduce el calor a la comida y el mango aislante protege tu mano.',
                  ),
                  mensajeFinal: 'Los metales conducen el calor; la madera y el plástico lo aíslan.',
                )),
        PasoBio(
            'Aislantes útiles',
            TipoPasoBio.explicacion,
            'f3_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Usos',
                  titulo: 'Conductores y aislantes en casa',
                  color: _c3,
                  textoZati: 'Usamos conductores y aislantes térmicos todos los días. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Usos', _c3, Icons.home_rounded, [
                      TarjetaInfo(Icons.soup_kitchen_rounded, 'Ollas', 'De metal (conductor) con mango aislante.'),
                      TarjetaInfo(Icons.local_cafe_rounded, 'Termos', 'Tienen una capa aislante que guarda el calor o el frío.'),
                      TarjetaInfo(Icons.checkroom_rounded, 'Ropa de lana', 'Atrapa aire y aísla el calor de tu cuerpo.'),
                      TarjetaInfo(Icons.ac_unit_rounded, 'Iglús', 'La nieve compacta es aislante y mantiene el calor adentro.'),
                    ]),
                  ],
                  mensajeFinal: '¡Ya sabes para qué sirven!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f3_m3_video',
            (a) => video(a,
                clave: 'calor_3',
                titulo: 'Video: conductores y aislantes',
                tema: 'materiales que conducen o aíslan el calor',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f3_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'Cuidado con el calor',
                        'Toca las acciones seguras en la cocina y presiona “Comprobar”.',
                        const [
                          Accion(Icons.back_hand_rounded, 'Usar guantes o agarraderas', true, 'Son aislantes y protegen tus manos.'),
                          Accion(Icons.soup_kitchen_rounded, 'Voltear el mango de la olla hacia adentro', true, 'Así nadie la tira.'),
                          Accion(Icons.family_restroom_rounded, 'Cocinar con un adulto', true, 'Es más seguro.'),
                          Accion(Icons.dangerous_rounded, 'Tocar una sartén caliente con la mano', false, 'El metal conduce el calor: te quemas.'),
                          Accion(Icons.flatware_rounded, 'Dejar una cuchara de metal en la olla hirviendo y tocarla', false, 'Se calienta por conducción.'),
                        ],
                        color: _c3),
                  ],
                  mensajeFinal: 'Usas el calor con seguridad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El pozole de la abuela',
      emoji: '🏆',
      color: Color(0xFFC62828),
      intro: '¡Último desafío! Ayuda a la abuela a preparar el pozole familiar.',
      mensajeFinal: '¡El pozole quedó delicioso!',
      pasos: [
        PasoBio(
            'El pozole de la abuela',
            TipoPasoBio.reto,
            'f3_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El pozole de la abuela',
                  color: const Color(0xFFC62828),
                  escenas: const [
                    EscenaBio(
                      titulo: 'La olla',
                      narracion: 'La abuela elige una olla de metal para cocinar el pozole.',
                      emojis: '🍲🔥',
                      pregunta: '¿Por qué de metal?',
                      opciones: ['Porque conduce bien el calor', 'Porque es aislante', 'Porque es más bonita'],
                      correcta: 0,
                      explicacion: 'El calor pasa rápido a la comida.',
                    ),
                    EscenaBio(
                      titulo: 'El hervor',
                      narracion: 'El caldo burbujea y el maíz sube y baja dentro de la olla.',
                      emojis: '♨️🌽',
                      pregunta: '¿Cómo se llama ese movimiento del calor?',
                      opciones: ['Convección', 'Radiación', 'Magnetismo'],
                      correcta: 0,
                      explicacion: 'El líquido caliente sube y el frío baja.',
                    ),
                    EscenaBio(
                      titulo: 'A servir',
                      narracion: 'Hay que mover la olla caliente a la mesa.',
                      emojis: '🧤🍲',
                      pregunta: '¿Qué conviene usar?',
                      opciones: ['Agarraderas de tela gruesa', 'Las manos mojadas', 'Una cuchara de metal'],
                      correcta: 0,
                      explicacion: 'La tela gruesa es aislante.',
                    ),
                    EscenaBio(
                      titulo: 'Se enfría',
                      narracion: 'El plato servido se enfría poco a poco en la mesa.',
                      emojis: '🍜⏲️',
                      pregunta: '¿Por qué?',
                      opciones: ['Le pasa su calor al aire y al plato, que están más fríos', 'Porque se le acaba el sabor', 'Por la gravedad'],
                      correcta: 0,
                      explicacion: 'Hasta llegar a la misma temperatura.',
                    ),
                  ],
                  mensajeFinal: '¡A comer!',
                )),
        PasoBio(
            'Supercerebro del calor',
            TipoPasoBio.reto,
            'f3_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFFC62828),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Hacia dónde viaja siempre el calor?',
                          opciones: ['De lo caliente a lo frío', 'De lo frío a lo caliente', 'Hacia arriba'],
                          correcta: 0,
                          explicacion: 'Hasta igualar temperaturas.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo llega el calor del Sol a la Tierra?',
                          opciones: ['Por radiación', 'Por conducción', 'Por convección'],
                          correcta: 0,
                          explicacion: 'Atraviesa el espacio vacío.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál es un buen aislante térmico?',
                          opciones: ['La madera', 'El cobre', 'El hierro'],
                          correcta: 0,
                          explicacion: 'Casi no deja pasar el calor.'),
                    ], color: const Color(0xFFC62828), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Experto en Calor»!',
                )),
      ],
    ),
  ],
);
