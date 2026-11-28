import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import 'fondos_qui.dart';
import 'ilustraciones_qui.dart';
import 'sims_qui.dart';

/// Química · Tema 5: Combustión y oxidación.

const _c1 = Color(0xFFE64A19);
const _c2 = Color(0xFF8D6E63);
const _c3 = Color(0xFF43A047);
const _ci = Color(0xFFBF360C);

final quiTema5 = TemaBio(
  numero: 5,
  mundo: 'qui',
  estilo: estiloQui(FondoQui.fuego),
  titulo: 'Combustión y oxidación',
  saludo:
      'El fuego de la estufa, el óxido de un clavo y la manzana que se pone café tienen algo en común: ¡el oxígeno! Vamos a investigar estas transformaciones y cómo afectan al ambiente.',
  misionDelTema:
      'Vas de campamento con tu grupo. Aprende cómo funciona el fuego, por qué se oxidan los metales y cómo cuidar el ambiente para tener un campamento seguro.',
  color: _ci,
  insignia: 'Guardián del Fuego',
  emojiInsignia: '🔥',
  emojisPanel: const ['🕯️', '🪵', '🔩', '🍎', '🌲'],
  videos: const {
    'combustion_1': 'assets/videos/combustion_fuego.mp4',
    'combustion_2': 'assets/videos/combustion_oxidacion.mp4',
    'combustion_3': 'assets/videos/combustion_ambiente.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'La combustión',
      emoji: '🔥',
      color: _c1,
      intro: '¿Qué necesita el fuego para existir? ¡Descúbrelo con la vela!',
      mensajeFinal: '¡Conoces el triángulo del fuego!',
      pasos: [
        PasoBio(
            '¿Qué es la combustión?',
            TipoPasoBio.explicacion,
            'q5_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Combustión',
                  titulo: 'La combustión',
                  color: _c1,
                  il: ilCombustion,
                  textos: const [
                    'La combustión es un cambio permanente rápido: un material (el combustible) reacciona con el oxígeno del aire y libera luz y calor. Para que ocurra se necesitan tres cosas: combustible, oxígeno y calor. Es el triángulo del fuego.',
                    'La usamos para cocinar, calentar el agua, mover los coches y producir electricidad.',
                    'Si quitas uno de los tres lados del triángulo, el fuego se apaga: los bomberos echan agua (quitan calor) o usan extintores que cubren el fuego (quitan oxígeno).',
                    'Al quemarse, el combustible se transforma en gases como el dióxido de carbono y en humo y cenizas.',
                  ],
                  izquierda: const [
                    Parte('combustible', 'Combustible', '(lo que se quema)', '🪵', Color(0xFF8D6E63), 'Madera, papel, gas, gasolina o cera.'),
                    Parte('calor', 'Calor', '(lo enciende)', '🌡️', Color(0xFFE53935), 'Una chispa o un cerillo inician la combustión.'),
                  ],
                  derecha: const [
                    Parte('oxigeno', 'Oxígeno', '(del aire)', '💨', Color(0xFF29B6F6), 'Sin oxígeno no hay fuego.'),
                    Parte('fuego', 'Fuego', '(luz y calor)', '🔥', Color(0xFFFF7043), 'Lo que vemos cuando hay combustión.'),
                    Parte('humo', 'Humo y gases', '(productos)', '☁️', Color(0xFF78909C), 'Dióxido de carbono, vapor de agua y humo.'),
                  ],
                  resaltar: const {
                    0: {'combustible', 'oxigeno', 'calor'},
                    2: {'oxigeno', 'calor'},
                  },
                  mensajeFinal: '¡Ahora experimenta con la vela!',
                )),
        PasoBio('La vela y el triángulo del fuego', TipoPasoBio.laboratorio, 'q5_m1_sim', (a) => SimCombustion(actividad: a, color: _c1)),
        PasoBio('Video del tema', TipoPasoBio.video, 'q5_m1_video',
            (a) => video(a, clave: 'combustion_1', titulo: 'Video: la combustión', tema: 'qué necesita el fuego', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q5_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilCombustion, const {'combustible': 'Combustible', 'oxigeno': 'Oxígeno', 'calor': 'Calor', 'humo': 'Humo y CO₂'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: 'Si tapas una vela con un frasco, se apaga. ¿Por qué?',
                        opciones: ['Se acaba el oxígeno dentro del frasco', 'El frasco está frío', 'Se acaba la cera'],
                        correcta: 0,
                        explicacion: 'Sin oxígeno no hay combustión.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Entiendes la combustión.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'La oxidación',
      emoji: '🔩',
      color: _c2,
      intro: 'Algunas transformaciones con oxígeno son muy lentas. ¡Investiga el óxido!',
      mensajeFinal: '¡Sabes cómo evitar la oxidación!',
      pasos: [
        PasoBio(
            '¿Qué es la oxidación?',
            TipoPasoBio.explicacion,
            'q5_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Oxidación',
                  titulo: 'La oxidación',
                  color: _c2,
                  il: ilOxidacion,
                  textos: const [
                    'La oxidación es un cambio permanente en el que un material reacciona con el oxígeno. Puede ser lenta, como el óxido del hierro, o rápida, como la combustión.',
                    'Conocerla nos ayuda a proteger herramientas, bicicletas y puentes, y a conservar los alimentos.',
                    'El hierro se oxida con oxígeno y humedad y forma una capa rojiza y quebradiza: el óxido. Una manzana partida se pone café porque su pulpa reacciona con el oxígeno del aire.',
                    'Pintar, engrasar o mantener secos los objetos de hierro los protege. Unas gotas de limón evitan que la manzana o el aguacate se pongan cafés tan rápido.',
                  ],
                  izquierda: const [
                    Parte('clavo', 'Clavo oxidado', '(hierro + oxígeno + agua)', '🔩', Color(0xFFBF360C), 'El óxido es rojizo y hace que el metal se rompa.'),
                    Parte('manzana', 'Manzana partida', '(se oscurece)', '🍎', Color(0xFFE53935), 'Su pulpa reacciona con el oxígeno.'),
                  ],
                  derecha: const [
                    Parte('bici', 'Bicicleta', '(se protege)', '🚲', Color(0xFF1E88E5), 'La pintura y el aceite la protegen del óxido.'),
                    Parte('oxigeno', 'Oxígeno', '(del aire)', '💨', Color(0xFF29B6F6), 'Participa en la oxidación.'),
                    Parte('agua', 'Humedad', '(acelera)', '💧', Color(0xFF0288D1), 'El agua acelera que el hierro se oxide.'),
                  ],
                  resaltar: const {
                    2: {'oxigeno', 'agua'},
                    3: {'bici'},
                  },
                  mensajeFinal: '¡Ahora haz el experimento de los clavos!',
                )),
        PasoBio(
            'El experimento de los clavos',
            TipoPasoBio.laboratorio,
            'q5_m2_lab',
            (a) => lab(
                  a,
                  titulo: '¿Se oxida el clavo?',
                  color: _c2,
                  instruccion: 'Pusimos clavos de hierro en diferentes condiciones durante una semana. Revisa cada uno: ¿tenía oxígeno y agua?, ¿se oxidó?',
                  pruebas: const [
                    Prueba('Oxígeno y agua', '💧', 'Sí tiene', 'Le falta'),
                    Prueba('Después de una semana', '📅', 'Oxidado', 'Sin óxido'),
                  ],
                  muestras: const [
                    Muestra('Clavo en agua', '🥛', [true, true], datos: ['El agua tiene oxígeno disuelto.', 'Se cubrió de óxido rojizo.']),
                    Muestra('Clavo al aire húmedo', '🌫️', [true, true], datos: ['Hay aire y humedad.', 'Se oxidó.']),
                    Muestra('Clavo en aceite', '🫒', [false, false], datos: ['El aceite no deja pasar el aire.', 'Quedó brillante.']),
                    Muestra('Clavo pintado', '🎨', [false, false], datos: ['La pintura lo cubre.', 'No se oxidó.']),
                    Muestra('Clavo en frasco seco', '🫙', [false, false], datos: ['No hay humedad.', 'Casi no se oxidó.']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: '¿Qué necesita el hierro para oxidarse?',
                    opciones: ['Oxígeno y humedad', 'Solo oscuridad', 'Aceite'],
                    correcta: 0,
                    explicacion: 'Por eso pintarlo o engrasarlo lo protege.',
                  ),
                  mensajeFinal: 'El hierro se oxida con oxígeno y agua; cubrirlo lo protege.',
                )),
        PasoBio(
            '¿Rápida o lenta?',
            TipoPasoBio.juego,
            'q5_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Oxidación rápida o lenta?',
                  color: _c2,
                  instruccion: 'Arrastra cada ejemplo al grupo correcto.',
                  grupos: const [GrupoClasificar('Rápida (combustión)', '🔥', Color(0xFFE64A19)), GrupoClasificar('Lenta', '🐌', Color(0xFF8D6E63))],
                  items: const [
                    ItemClasificar('🪵', 'Leña en la fogata', 0, 'Se quema en minutos.'),
                    ItemClasificar('🕯️', 'Vela encendida', 0, 'Libera luz y calor.'),
                    ItemClasificar('🚗', 'Gasolina en el motor', 0, 'Se quema dentro del motor.'),
                    ItemClasificar('🔩', 'Clavo oxidado', 1, 'Tarda días o semanas.'),
                    ItemClasificar('🍎', 'Manzana partida', 1, 'Se oscurece en minutos u horas.'),
                    ItemClasificar('🚲', 'Bici oxidada', 1, 'Tarda meses en la intemperie.'),
                  ],
                  mensajeFinal: 'La combustión es una oxidación muy rápida.',
                )),
        PasoBio('Video del tema', TipoPasoBio.video, 'q5_m2_video',
            (a) => video(a, clave: 'combustion_2', titulo: 'Video: la oxidación', tema: 'el óxido y cómo evitarlo', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q5_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilOxidacion, const {'clavo': 'Clavo oxidado', 'manzana': 'Manzana', 'oxigeno': 'Oxígeno', 'agua': 'Humedad'}, color: _c2),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Cómo proteges tu bicicleta del óxido?',
                        opciones: ['Guardándola seca y con aceite en la cadena', 'Dejándola bajo la lluvia', 'Lavándola con agua y dejándola mojada'],
                        correcta: 0,
                        explicacion: 'Así le quitas la humedad y el contacto con el aire.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Sabes prevenir la oxidación.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Fuego y ambiente',
      emoji: '🌲',
      color: _c3,
      intro: 'La combustión nos ayuda, pero también contamina y puede provocar incendios. ¡Aprende a cuidarte y a cuidar el planeta!',
      mensajeFinal: '¡Usas el fuego con responsabilidad!',
      pasos: [
        PasoBio(
            'Implicaciones de la combustión',
            TipoPasoBio.explicacion,
            'q5_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Ambiente',
                  titulo: 'La combustión y el ambiente',
                  color: _c3,
                  textoZati: 'Al quemar combustibles se liberan gases y humo. Toca cada tarjeta para conocer sus efectos y datos curiosos.',
                  grupos: const [
                    GrupoTarjetas('Efectos', Color(0xFF78909C), Icons.cloud_rounded, [
                      TarjetaInfo(Icons.thermostat_rounded, 'Calentamiento global', 'El dióxido de carbono atrapa el calor y calienta el planeta.'),
                      TarjetaInfo(Icons.masks_rounded, 'Contaminación del aire', 'El humo de coches y fábricas daña los pulmones.'),
                      TarjetaInfo(Icons.forest_rounded, 'Incendios forestales', 'Destruyen bosques y el hogar de muchos animales.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.local_fire_department_rounded, 'La mayoría de los incendios',
                          'En México, la mayoría de los incendios forestales los provocan las personas.'),
                      TarjetaInfo(Icons.park_rounded, 'Los árboles', 'Absorben dióxido de carbono y liberan oxígeno: ¡plantar árboles ayuda!'),
                      TarjetaInfo(Icons.science_rounded, 'El extintor', 'Muchos extintores cubren el fuego con un polvo o gas que le quita el oxígeno.'),
                    ]),
                  ],
                  mensajeFinal: '¡Hay que usar el fuego con cuidado!',
                )),
        PasoBio(
            '¿Ayuda o daña?',
            TipoPasoBio.laboratorio,
            'q5_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Ayuda o daña al ambiente?',
                  color: _c3,
                  instruccion: 'Arrastra cada acción al grupo correcto.',
                  grupos: const [GrupoClasificar('Ayuda 💚', '💚', Color(0xFF43A047)), GrupoClasificar('Daña ⚠️', '⚠️', Color(0xFFE53935))],
                  items: const [
                    ItemClasificar('🚲', 'Ir en bici a la escuela', 0, 'No quema combustible.'),
                    ItemClasificar('🌳', 'Plantar árboles', 0, 'Absorben dióxido de carbono.'),
                    ItemClasificar('☀️', 'Usar calentador solar', 0, 'Usa la energía del Sol.'),
                    ItemClasificar('🗑️', 'Quemar basura', 1, 'Libera humo tóxico.'),
                    ItemClasificar('🚗', 'Dejar el coche encendido sin necesidad', 1, 'Gasta combustible y contamina.'),
                    ItemClasificar('🔥', 'Dejar una fogata sin apagar', 1, 'Puede provocar un incendio.'),
                  ],
                  mensajeFinal: 'Pequeñas acciones reducen la contaminación.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q5_m3_video',
            (a) => video(a,
                clave: 'combustion_3',
                titulo: 'Video: el fuego y el ambiente',
                tema: 'implicaciones ambientales de la combustión',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q5_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'Seguridad con el fuego',
                        'Toca las acciones seguras y presiona “Comprobar”.',
                        const [
                          Accion(Icons.water_drop_rounded, 'Apagar la fogata con agua y tierra', true, 'Así no queda ninguna brasa.'),
                          Accion(Icons.family_restroom_rounded, 'Usar cerillos solo con un adulto', true, 'El fuego es peligroso.'),
                          Accion(Icons.phone_in_talk_rounded, 'Llamar al 911 si ves un incendio', true, 'Avisar rápido salva bosques y vidas.'),
                          Accion(Icons.kitchen_rounded, 'Alejar lo que se quema de la estufa', true, 'Evitas que se encienda.'),
                          Accion(Icons.delete_rounded, 'Quemar la basura en el patio', false, 'Contamina y puede salirse de control.'),
                          Accion(Icons.smoking_rooms_rounded, 'Tirar cerillos encendidos al pasto', false, 'Causa incendios forestales.'),
                        ],
                        color: _c3),
                  ],
                  mensajeFinal: 'Usas el fuego de forma segura.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'Campamento seguro',
      emoji: '🏆',
      color: Color(0xFF2E7D32),
      intro: '¡Último desafío! Organiza un campamento seguro y que cuide el bosque.',
      mensajeFinal: '¡Fue un campamento seguro y limpio!',
      pasos: [
        PasoBio(
            'Campamento seguro',
            TipoPasoBio.reto,
            'q5_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'Campamento seguro',
                  color: const Color(0xFF2E7D32),
                  escenas: const [
                    EscenaBio(
                      titulo: 'La fogata',
                      narracion: 'Quieren hacer una fogata para cocinar.',
                      emojis: '🪵🔥',
                      pregunta: '¿Qué tres cosas necesita el fuego?',
                      opciones: ['Combustible, oxígeno y calor', 'Agua, tierra y sol', 'Solo leña'],
                      correcta: 0,
                      explicacion: 'Es el triángulo del fuego.',
                    ),
                    EscenaBio(
                      titulo: 'El lugar',
                      narracion: 'Deben elegir dónde hacer la fogata.',
                      emojis: '🌲⭕',
                      pregunta: '¿Cuál es el lugar más seguro?',
                      opciones: ['Un círculo de piedras lejos de árboles y pasto seco', 'Bajo un árbol', 'Junto a las tiendas'],
                      correcta: 0,
                      explicacion: 'Así el fuego no se extiende.',
                    ),
                    EscenaBio(
                      titulo: 'Las herramientas',
                      narracion: 'Al día siguiente, el machete que dejaron afuera tiene manchas rojizas.',
                      emojis: '🔪💧',
                      pregunta: '¿Qué le pasó?',
                      opciones: ['Se oxidó por el aire y la humedad del rocío', 'Se quemó', 'Se derritió'],
                      correcta: 0,
                      explicacion: 'Hay que guardarlo seco.',
                    ),
                    EscenaBio(
                      titulo: 'Antes de irse',
                      narracion: 'Es hora de regresar a casa.',
                      emojis: '🔥➡️💧',
                      pregunta: '¿Qué deben hacer con la fogata?',
                      opciones: ['Apagarla con agua y tierra hasta que esté fría', 'Dejarla que se apague sola', 'Echarle más leña'],
                      correcta: 0,
                      explicacion: 'Una brasa puede iniciar un incendio forestal.',
                    ),
                  ],
                  mensajeFinal: '¡El bosque quedó intacto!',
                )),
        PasoBio(
            'Supercerebro del fuego',
            TipoPasoBio.reto,
            'q5_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF2E7D32),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué gas del aire participa en la combustión y la oxidación?',
                          opciones: ['Oxígeno', 'Helio', 'Nitrógeno'],
                          correcta: 0,
                          explicacion: 'Sin él no hay fuego ni óxido.'),
                      PreguntaQuiz(
                          pregunta: '¿Por qué se oscurece una manzana partida?',
                          opciones: ['Por la oxidación con el aire', 'Porque se congela', 'Por la luz de la luna'],
                          correcta: 0,
                          explicacion: 'Unas gotas de limón la retrasan.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué gas de la combustión contribuye al calentamiento global?',
                          opciones: ['Dióxido de carbono', 'Oxígeno', 'Vapor de agua del mar'],
                          correcta: 0,
                          explicacion: 'Atrapa el calor en la atmósfera.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo apagan el fuego los bomberos con agua?',
                          opciones: ['Le quitan el calor', 'Le agregan combustible', 'Le dan más oxígeno'],
                          correcta: 0,
                          explicacion: 'Rompen el triángulo del fuego.'),
                    ], color: const Color(0xFF2E7D32), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Guardián del Fuego»!',
                )),
      ],
    ),
  ],
);
