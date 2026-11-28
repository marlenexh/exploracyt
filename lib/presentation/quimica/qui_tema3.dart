import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import 'fondos_qui.dart';
import '../ciencia/juego_rapido.dart';
import 'ilustraciones_qui.dart';
import '../minijuegos/minijuegos.dart';

/// Química · Tema 3: Todo se transforma (cambios temporales y permanentes).

const _c1 = Color(0xFF00ACC1);
const _c2 = Color(0xFFE53935);
const _c3 = Color(0xFF1E88E5);
const _ci = Color(0xFF00838F);

final quiTema3 = TemaBio(
  numero: 3,
  mundo: 'qui',
  estilo: estiloQui(FondoQui.transforma),
  titulo: 'Todo se transforma',
  saludo:
      'El hielo se derrite, el pan se hornea, el papel se quema… Los materiales cambian todo el tiempo. Algunos cambios se pueden revertir y otros no. ¡Vamos a descubrirlo!',
  misionDelTema:
      'En la cocina del laboratorio todo está cambiando. Investiga qué cambios son temporales y cuáles son permanentes para preparar la fiesta de cumpleaños.',
  color: _ci,
  insignia: 'Maestro de las Transformaciones',
  emojiInsignia: '🔄',
  emojisPanel: const ['🧊', '🍫', '🥚', '🔥', '💧'],
  videos: const {
    'cambios_1': 'assets/videos/cambios_temporales.mp4',
    'cambios_2': 'assets/videos/cambios_permanentes.mp4',
    'cambios_3': 'assets/videos/cambios_estado.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Cambios temporales',
      emoji: '🧊',
      color: _c1,
      intro: 'Algunos materiales cambian de forma o estado, pero pueden regresar a como estaban. ¡Experimenta!',
      mensajeFinal: '¡Reconoces los cambios temporales!',
      pasos: [
        PasoBio(
            'Temporales y permanentes',
            TipoPasoBio.explicacion,
            'q3_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Los cambios',
                  titulo: 'Cambios temporales y permanentes',
                  color: _c1,
                  il: ilCambios,
                  textos: const [
                    'Un cambio temporal (o físico) modifica la forma o el estado de un material, pero sigue siendo el mismo material y puede regresar a como era. Un cambio permanente (o químico) forma materiales nuevos y ya no se puede revertir.',
                    'Saber qué tipo de cambio ocurre nos ayuda en la cocina, en la industria y para cuidar los objetos.',
                    'El hielo se derrite con el calor y, si lo enfrías, vuelve a ser hielo: es temporal. Pero un huevo cocido nunca vuelve a estar crudo y el papel quemado no vuelve a ser papel: son permanentes.',
                    'Cuando derrites chocolate para hacer figuras y se endurece en el refrigerador, ¡sigue siendo chocolate! Es un cambio temporal.',
                  ],
                  izquierda: const [
                    Parte('hielo', 'Hielo', '(se derrite)', '🧊', Color(0xFF29B6F6), 'Con calor se vuelve agua; con frío vuelve a ser hielo.'),
                    Parte('chocolate', 'Chocolate', '(se funde)', '🍫', Color(0xFF6D4C41), 'Se derrite y se vuelve a endurecer.'),
                    Parte('huevo', 'Huevo crudo', '(se cuece)', '🥚', Color(0xFFFFB300), 'Al cocerse cambia para siempre.'),
                  ],
                  derecha: const [
                    Parte('agua', 'Agua', '(se congela)', '💧', Color(0xFF1E88E5), 'Puede volver a ser hielo.'),
                    Parte('estrellado', 'Huevo estrellado', '(no regresa)', '🍳', Color(0xFFFF7043), 'No puede volver a estar crudo.'),
                    Parte('ceniza', 'Papel quemado', '(cenizas y humo)', '🔥', Color(0xFFE53935), 'Se forman materiales nuevos: cenizas y gases.'),
                  ],
                  resaltar: const {
                    0: {'hielo', 'agua', 'chocolate'},
                    2: {'huevo', 'estrellado', 'ceniza'},
                  },
                  mensajeFinal: '¡Ahora experimenta en el laboratorio!',
                )),
        PasoBio(
            '¿Regresa o no regresa?',
            TipoPasoBio.laboratorio,
            'q3_m1_lab',
            (a) => lab(
                  a,
                  titulo: '¿Regresa o no regresa?',
                  color: _c1,
                  instruccion: 'Calienta cada material y después enfríalo. ¿Vuelve a ser como antes? Toca cada “?”.',
                  pruebas: const [
                    Prueba('Calentar', '🔥', 'Cambia', 'No cambia'),
                    Prueba('Enfriar después', '❄️', 'Regresa', 'No regresa'),
                  ],
                  muestras: const [
                    Muestra('Hielo', '🧊', [true, true], datos: ['Se derrite y se vuelve agua.', 'Vuelve a ser hielo en el congelador.']),
                    Muestra('Chocolate', '🍫', [true, true], datos: ['Se funde.', 'Se endurece otra vez.']),
                    Muestra('Cera de vela', '🕯️', [true, true], datos: ['Se derrite.', 'Se solidifica de nuevo.']),
                    Muestra('Huevo', '🥚', [true, false], datos: ['La clara se pone blanca y dura.', '¡No vuelve a estar crudo!']),
                    Muestra('Pan', '🍞', [true, false], datos: ['Se tuesta y se dora.', 'No vuelve a ser pan suave.']),
                    Muestra('Papel', '📄', [true, false], datos: ['Se quema: cenizas y humo.', 'No vuelve a ser papel.']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: 'Según tus resultados, ¿qué tienen en común el huevo, el pan y el papel?',
                    opciones: ['Tuvieron cambios permanentes: no regresan', 'Se derriten', 'No cambiaron'],
                    correcta: 0,
                    explicacion: 'Se formaron materiales nuevos.',
                  ),
                  mensajeFinal: 'Los cambios temporales se pueden revertir; los permanentes no.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q3_m1_video',
            (a) => video(a,
                clave: 'cambios_1', titulo: 'Video: cambios temporales', tema: 'cambios que se pueden revertir', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q3_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilCambios, const {'hielo': 'Hielo', 'chocolate': 'Chocolate', 'huevo': 'Huevo crudo', 'papel': 'Papel'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: 'Derrites mantequilla y luego la metes al refrigerador. ¿Qué tipo de cambio fue?',
                        opciones: ['Temporal', 'Permanente', 'Ninguno'],
                        correcta: 0,
                        explicacion: 'Vuelve a ser mantequilla sólida.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Identificas los cambios temporales.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Cambios permanentes',
      emoji: '🍳',
      color: _c2,
      intro: 'Cuando se forma un material nuevo, ya no hay vuelta atrás. ¿Cómo darte cuenta?',
      mensajeFinal: '¡Reconoces los cambios permanentes!',
      pasos: [
        PasoBio(
            'Señales de un cambio permanente',
            TipoPasoBio.explicacion,
            'q3_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Señales',
                  titulo: '¿Cómo saber si es permanente?',
                  color: _c2,
                  textoZati: 'Hay pistas que delatan un cambio permanente. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Pistas', _c2, Icons.search_rounded, [
                      TarjetaInfo(Icons.palette_rounded, 'Cambia de color', 'Como el pan que se dora o la fruta que madura.'),
                      TarjetaInfo(Icons.air_rounded, 'Sale gas o humo', 'Como al quemar papel o al mezclar vinagre con bicarbonato.'),
                      TarjetaInfo(Icons.sentiment_dissatisfied_rounded, 'Cambia el olor o sabor', 'Como la leche que se agria.'),
                      TarjetaInfo(Icons.whatshot_rounded, 'Libera luz o calor', 'Como la madera al arder.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.bakery_dining_rounded, 'El pan', 'Las levaduras producen un gas que hace las burbujas del pan: por eso es esponjoso.'),
                      TarjetaInfo(Icons.science_rounded, 'El volcán de bicarbonato', 'El vinagre y el bicarbonato forman un gas nuevo: ¡dióxido de carbono!'),
                    ]),
                  ],
                  mensajeFinal: '¡Ya sabes buscar las pistas!',
                )),
        PasoBio(
            '¿Temporal o permanente?',
            TipoPasoBio.laboratorio,
            'q3_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Temporal o permanente?',
                  color: _c2,
                  instruccion: 'Arrastra cada cambio al grupo correcto.',
                  grupos: const [GrupoClasificar('Temporal', '🔁', Color(0xFF00ACC1)), GrupoClasificar('Permanente', '⛔', Color(0xFFE53935))],
                  items: const [
                    ItemClasificar('🧊', 'Derretir hielo', 0, 'El agua puede volver a congelarse.'),
                    ItemClasificar('📄', 'Doblar una hoja', 0, 'Puedes desdoblarla.'),
                    ItemClasificar('🧂', 'Disolver sal en agua', 0, 'Si se evapora el agua, la sal reaparece.'),
                    ItemClasificar('🫧', 'Inflar un globo', 0, 'Se puede desinflar.'),
                    ItemClasificar('🎂', 'Hornear un pastel', 1, 'La masa no vuelve a ser cruda.'),
                    ItemClasificar('🔥', 'Quemar madera', 1, 'Quedan cenizas y humo.'),
                    ItemClasificar('🍌', 'Plátano que madura', 1, 'No vuelve a estar verde.'),
                    ItemClasificar('🥛', 'Leche que se agria', 1, 'Cambia su olor y sabor.'),
                  ],
                  mensajeFinal: 'Los cambios permanentes forman materiales nuevos.',
                )),
        PasoBio('Arma moléculas', TipoPasoBio.juego, 'q3_m2_flame', (a) => juegoMoleculas(a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q3_m2_video',
            (a) => video(a,
                clave: 'cambios_2', titulo: 'Video: cambios permanentes', tema: 'cambios químicos en la vida diaria', siguiente: '¡A la máquina de los cambios!')),
        PasoBio(
            'La máquina de los cambios',
            TipoPasoBio.juego,
            'q3_m2_mem',
            (a) => JuegoRapido(
                  actividad: a,
                  seccion: 'Juego',
                  titulo: 'La máquina de los cambios',
                  color: _c2,
                  instruccion:
                      'Los objetos entran a la máquina y cambian. Antes de que se acabe el tiempo, decide: ¿el cambio se puede regresar (temporal) o ya no (permanente)? Presiona “¡Empezar!”.',
                  opciones: const [
                    OpcionRapida('↩️', 'Temporal', Color(0xFF29B6F6)),
                    OpcionRapida('🚫', 'Permanente', Color(0xFFE64A19)),
                  ],
                  objetos: const [
                    ObjetoRapido('🧊', '💧', 'Hielo que se derrite', 0, 'Si lo congelas otra vez, vuelve a ser hielo.'),
                    ObjetoRapido('🥚', '🍳', 'Huevo que se fríe', 1, 'El huevo cocido ya no vuelve a ser crudo.'),
                    ObjetoRapido('🍫', '🫕', 'Chocolate que se funde', 0, 'Al enfriarse vuelve a ser sólido.'),
                    ObjetoRapido('📄', '🔥', 'Papel que se quema', 1, 'Se convierte en ceniza y humo: ya no es papel.'),
                    ObjetoRapido('🔩', '🟤', 'Clavo que se oxida', 1, 'El óxido es una sustancia nueva.'),
                    ObjetoRapido('👕', '🧺', 'Camisa que se dobla', 0, 'Puedes desdoblarla: sigue siendo la misma.'),
                    ObjetoRapido('🍞', '🥪', 'Pan que se tuesta', 1, 'El pan tostado cambió de color, sabor y textura para siempre.'),
                    ObjetoRapido('🎈', '💨', 'Globo que se desinfla', 0, 'Si lo vuelves a inflar, regresa a como estaba.'),
                  ],
                  mensajeFinal: 'Los cambios temporales se pueden regresar; los permanentes forman sustancias nuevas.',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q3_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseRelacionar(const [
                      ('Cambio temporal', 'El material puede volver a ser como antes.'),
                      ('Cambio permanente', 'Se forma un material nuevo.'),
                      ('Sale humo', 'Señal de un cambio permanente.'),
                      ('Derretir', 'Pasar de sólido a líquido con calor.'),
                    ], color: _c2, instruccion: 'Relaciona cada concepto.'),
                  ],
                  mensajeFinal: 'Distingues los tipos de cambio.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Los cambios de estado',
      emoji: '💧',
      color: _c3,
      intro: 'El agua viaja por todo el planeta cambiando de estado. ¡Sigue su camino!',
      mensajeFinal: '¡Conoces los cambios de estado!',
      pasos: [
        PasoBio(
            'El ciclo del agua',
            TipoPasoBio.explicacion,
            'q3_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Cambios de estado',
                  titulo: 'Los cambios de estado',
                  color: _c3,
                  il: ilCicloAgua,
                  textos: const [
                    'Los cambios de estado son cambios temporales: el material sigue siendo el mismo. Fusión: de sólido a líquido. Evaporación: de líquido a gas. Condensación: de gas a líquido. Solidificación: de líquido a sólido.',
                    'Gracias a ellos existe el ciclo del agua, que lleva agua dulce a ríos, lagos y a nuestras casas.',
                    'El Sol calienta el agua del mar y se evapora; el vapor sube, se enfría y se condensa en nubes; luego cae como lluvia y escurre de vuelta al mar.',
                    'Cuando sacas un refresco frío, se forman gotitas por fuera del vaso: es el vapor del aire que se condensa.',
                  ],
                  izquierda: const [
                    Parte('sol', 'Sol', '(calor)', '☀️', Color(0xFFFFB300), 'Da la energía para que el agua se evapore.'),
                    Parte('mar', 'Mar', '(evaporación)', '🌊', Color(0xFF1E88E5), 'El agua líquida se vuelve vapor.'),
                  ],
                  derecha: const [
                    Parte('nube', 'Nubes', '(condensación)', '☁️', Color(0xFF90A4AE), 'El vapor se enfría y forma gotitas.'),
                    Parte('lluvia', 'Lluvia', '(precipitación)', '🌧️', Color(0xFF29B6F6), 'Las gotas caen a la tierra.'),
                    Parte('montana', 'Montaña', '(solidificación)', '🏔️', Color(0xFF78909C), 'En lo alto hace frío y el agua se congela en nieve.'),
                  ],
                  resaltar: const {
                    2: {'mar', 'nube', 'lluvia'},
                  },
                  mensajeFinal: '¡Ahora ordena el ciclo del agua!',
                )),
        PasoBio(
            'Ordena el ciclo del agua',
            TipoPasoBio.juego,
            'q3_m3_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Ordena',
                  titulo: 'El viaje de una gota',
                  color: _c3,
                  instruccion: 'Ordena el viaje de una gota de agua por el ciclo del agua.',
                  pasos: const [
                    ('🌊', 'Está en el mar'),
                    ('☀️', 'El Sol la calienta y se evapora'),
                    ('☁️', 'Se condensa en una nube'),
                    ('🌧️', 'Cae como lluvia'),
                    ('🏞️', 'Escurre por un río'),
                  ],
                  explicacion: 'El río la lleva otra vez al mar: ¡el ciclo nunca termina!',
                  mensajeFinal: '¡La gota completó su viaje!',
                  ciclo: true,
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'q3_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '3. Datos curiosos',
                  titulo: 'El agua es especial',
                  color: _c3,
                  textoZati: '¡El agua es una sustancia muy especial! Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.water_rounded, 'Tres estados',
                          'El agua es de las pocas sustancias que encontramos en la naturaleza como sólido, líquido y gas.'),
                      TarjetaInfo(Icons.ac_unit_rounded, 'El hielo flota',
                          'Al congelarse, el agua ocupa más espacio. Por eso el hielo flota y los peces viven bajo el hielo.'),
                      TarjetaInfo(Icons.thermostat_rounded, 'Puntos clave',
                          'El agua se congela a 0 °C y hierve a 100 °C al nivel del mar. En la Ciudad de México hierve a unos 93 °C.'),
                    ]),
                  ],
                  mensajeFinal: '¡El agua es asombrosa!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q3_m3_video',
            (a) => video(a,
                clave: 'cambios_3',
                titulo: 'Video: cambios de estado',
                tema: 'fusión, evaporación, condensación y solidificación',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q3_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseRelacionar(const [
                      ('Fusión', 'De sólido a líquido.'),
                      ('Evaporación', 'De líquido a gas.'),
                      ('Condensación', 'De gas a líquido.'),
                      ('Solidificación', 'De líquido a sólido.'),
                    ], color: _c3, instruccion: 'Relaciona cada cambio de estado.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: 'Se forman gotitas por fuera de un vaso con agua fría. ¿Qué cambio de estado es?',
                        opciones: ['Condensación', 'Fusión', 'Evaporación'],
                        correcta: 0,
                        explicacion: 'El vapor del aire se enfría y se vuelve líquido.',
                      ),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Conoces los cambios de estado.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La fiesta de cumpleaños',
      emoji: '🏆',
      color: Color(0xFF8E24AA),
      intro: '¡Último desafío! En la fiesta de cumpleaños hay cambios por todas partes. ¿Puedes identificarlos?',
      mensajeFinal: '¡Fue la fiesta más científica!',
      pasos: [
        PasoBio(
            'La fiesta de cumpleaños',
            TipoPasoBio.reto,
            'q3_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'La fiesta de cumpleaños',
                  color: const Color(0xFF8E24AA),
                  escenas: const [
                    EscenaBio(
                      titulo: 'El pastel',
                      narracion: 'Mamá hornea el pastel: la masa líquida se vuelve esponjosa y dorada.',
                      emojis: '🎂🔥',
                      pregunta: '¿Qué tipo de cambio es?',
                      opciones: ['Permanente', 'Temporal', 'Ninguno'],
                      correcta: 0,
                      explicacion: 'El pastel no vuelve a ser masa cruda.',
                    ),
                    EscenaBio(
                      titulo: 'Las velas',
                      narracion: 'Al soplar las velas, un poco de cera derretida se endurece en el pastel.',
                      emojis: '🕯️💨',
                      pregunta: 'La cera que se derrite y se endurece tuvo un cambio…',
                      opciones: ['Temporal', 'Permanente', 'Mágico'],
                      correcta: 0,
                      explicacion: 'Sigue siendo cera.',
                    ),
                    EscenaBio(
                      titulo: 'Las paletas',
                      narracion: 'Las paletas de hielo se derriten con el calor de la tarde.',
                      emojis: '🍧☀️',
                      pregunta: '¿Cómo se llama ese cambio de estado?',
                      opciones: ['Fusión', 'Evaporación', 'Combustión'],
                      correcta: 0,
                      explicacion: 'De sólido a líquido.',
                    ),
                    EscenaBio(
                      titulo: 'La piñata',
                      narracion: 'Los niños rompen la piñata de papel en muchos pedazos.',
                      emojis: '🪅🎉',
                      pregunta: 'Romper el papel en pedazos es un cambio…',
                      opciones: ['Temporal: sigue siendo papel', 'Permanente: es otro material', 'De estado'],
                      correcta: 0,
                      explicacion: 'Cambia la forma, pero sigue siendo papel.',
                    ),
                  ],
                  mensajeFinal: '¡Encontraste todos los cambios de la fiesta!',
                )),
        PasoBio(
            'Supercerebro de cambios',
            TipoPasoBio.reto,
            'q3_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF8E24AA),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuál es un cambio permanente?',
                          opciones: ['Freír un huevo', 'Congelar agua', 'Doblar papel'],
                          correcta: 0,
                          explicacion: 'El huevo no regresa a estar crudo.'),
                      PreguntaQuiz(
                          pregunta: '¿A qué temperatura se congela el agua?',
                          opciones: ['0 °C', '100 °C', '50 °C'],
                          correcta: 0,
                          explicacion: 'Y hierve a 100 °C al nivel del mar.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál es una señal de un cambio permanente?',
                          opciones: ['Sale humo o cambia el olor', 'Cambia de forma', 'Se moja'],
                          correcta: 0,
                          explicacion: 'Indica que se formó algo nuevo.'),
                    ], color: const Color(0xFF8E24AA), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Maestro de las Transformaciones»!',
                )),
      ],
    ),
  ],
);
