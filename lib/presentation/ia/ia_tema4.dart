import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_ia.dart';
import 'ilustraciones_ia.dart';
import 'sims_ia.dart';

/// Inteligencia Artificial · Tema 4: Inteligencia en acción.

const _c1 = Color(0xFF00838F);
const _c2 = Color(0xFFD81B60);
const _c3 = Color(0xFF3949AB);
const _ci = Color(0xFF006064);

final iaTema4 = TemaBio(
  numero: 4,
  mundo: 'ia',
  estilo: estiloIA(FondoIA.accion),
  titulo: 'Inteligencia en acción',
  saludo:
      'Cuando le hablas a un asistente, buscas un video o usas un mapa en el celular, ¡estás usando inteligencia artificial! Vamos a descubrir la IA que está en los aparatos y servicios de todos los días.',
  misionDelTema: 'Acompaña a la familia de Zati durante un día y descubre cuántas veces usan inteligencia artificial sin darse cuenta.',
  color: _ci,
  insignia: 'Detective de la IA Cotidiana',
  emojiInsignia: '📱',
  emojisPanel: const ['📱', '🗣️', '🗺️', '🎬', '🚗'],
  videos: const {
    'accion_1': 'assets/videos/ia_asistentes.mp4',
    'accion_2': 'assets/videos/ia_recomendaciones.mp4',
    'accion_3': 'assets/videos/ia_que_ayuda.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'La IA en tu casa y tu bolsillo',
      emoji: '🗣️',
      color: _c1,
      intro: 'Asistentes, mapas, traductores… ¡la IA vive en tu celular!',
      mensajeFinal: '¡Encontraste la IA de todos los días!',
      pasos: [
        PasoBio(
            'IA de todos los días',
            TipoPasoBio.explicacion,
            'i4_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Aparatos',
                  titulo: 'La IA de todos los días',
                  color: _c1,
                  il: ilAplicaciones,
                  textos: const [
                    'Muchos aparatos y servicios que usamos tienen IA: asistentes de voz, mapas, traductores, cámaras, apps de videos y hasta coches que ayudan a frenar.',
                    'Nos ayudan a encontrar caminos sin perdernos, hablar con personas de otros idiomas, buscar información y ahorrar tiempo.',
                    'Funcionan con datos: el mapa usa la ubicación de miles de teléfonos para saber dónde hay tráfico; la cámara reconoce caras para enfocar; el traductor aprendió de millones de textos.',
                    'Los coches autónomos usan cámaras y sensores para “ver” la calle y decidir en tiempo real. ¡Todavía se están probando para que sean seguros!',
                  ],
                  izquierda: const [
                    Parte('asistente', 'Asistente de voz', '(entiende)', '🗣️', Color(0xFF00897B), 'Entiende lo que dices.'),
                    Parte('traductor', 'Traductor', '(idiomas)', '🌐', Color(0xFF1E88E5), 'Traduce textos y voz.'),
                    Parte('camara', 'Cámara', '(reconoce)', '📸', Color(0xFF6D4C41), 'Reconoce caras y objetos.'),
                  ],
                  derecha: const [
                    Parte('mapa', 'Mapas', '(rutas)', '🗺️', Color(0xFF43A047), 'Calcula el mejor camino.'),
                    Parte('recomendador', 'Videos y música', '(recomienda)', '🎬', Color(0xFFD81B60), 'Te sugiere qué ver.'),
                    Parte('coche', 'Coche autónomo', '(maneja)', '🚗', Color(0xFFE53935), 'Ve la calle y decide.'),
                  ],
                  resaltar: const {
                    2: {'mapa', 'camara', 'traductor'},
                    3: {'coche'},
                  },
                  mensajeFinal: '¡Ahora habla con un asistente!',
                )),
        PasoBio('El asistente de voz', TipoPasoBio.simulacion, 'i4_m1_sim', (a) => SimAsistente(actividad: a, color: _c1)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i4_m1_video',
            (a) => video(a,
                clave: 'accion_1', titulo: 'Video: asistentes inteligentes', tema: 'la IA en el celular y en casa', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i4_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilAplicaciones, const {'asistente': 'Asistente', 'mapa': 'Mapa', 'traductor': 'Traductor', 'coche': 'Coche autónomo'},
                        color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué hace primero un asistente de voz?',
                          opciones: ['Escucha tu voz y la convierte en texto', 'Responde sin escuchar', 'Se apaga'],
                          correcta: 0,
                          explicacion: 'Luego entiende y responde.'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Conoces la IA de tu casa.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Recomendaciones y búsquedas',
      emoji: '🎬',
      color: _c2,
      intro: '¿Cómo sabe la app qué video te va a gustar?',
      mensajeFinal: '¡Descubriste cómo funcionan las recomendaciones!',
      pasos: [
        PasoBio('El recomendador', TipoPasoBio.simulacion, 'i4_m2_sim', (a) => SimRecomendador(actividad: a, color: _c2)),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'i4_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'La IA en internet',
                  color: _c2,
                  textoZati: 'Cada vez que usas internet, una IA aprende de lo que haces. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.search_rounded, 'Buscadores', 'Aprenden de los clics de millones de personas para mostrar mejores resultados.'),
                      TarjetaInfo(Icons.shopping_cart_rounded, 'Tiendas en línea', 'Te sugieren productos según lo que compraste o miraste antes.'),
                      TarjetaInfo(Icons.translate_rounded, 'Traductores', 'Usan enormes cantidades de textos para aprender a traducir cada vez mejor.'),
                      TarjetaInfo(
                          Icons.bubble_chart_rounded, 'La burbuja', 'Si solo ves un tipo de videos, la IA te mostrará casi solo eso. ¡Explora otros temas!'),
                    ]),
                  ],
                  mensajeFinal: '¡La IA aprende de lo que hacemos en internet!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i4_m2_video',
            (a) => video(a,
                clave: 'accion_2', titulo: 'Video: recomendaciones', tema: 'cómo nos recomienda contenido la IA', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i4_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Con qué datos te recomienda videos la IA?',
                          opciones: ['Con lo que ves y lo que te gusta', 'Con tu estatura', 'Al azar'],
                          correcta: 0,
                          explicacion: 'Aprende de tus gustos.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo sales de la “burbuja” de recomendaciones?',
                          opciones: ['Explorando temas diferentes', 'Viendo siempre lo mismo', 'Apagando la tele para siempre'],
                          correcta: 0,
                          explicacion: 'La variedad te ayuda a aprender más.'),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Entiendes las recomendaciones.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'La IA que ayuda',
      emoji: '🩺',
      color: _c3,
      intro: 'La IA también ayuda a cuidar la salud, el planeta y las ciudades.',
      mensajeFinal: '¡Conoces cómo ayuda la IA!',
      pasos: [
        PasoBio(
            'IA que ayuda',
            TipoPasoBio.explicacion,
            'i4_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Aplicaciones',
                  titulo: 'La IA que ayuda',
                  color: _c3,
                  textoZati: 'La IA se usa en muchas áreas para ayudar a las personas. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Salud y escuela', Color(0xFFE53935), Icons.favorite_rounded, [
                      TarjetaInfo(
                          Icons.medical_services_rounded, 'Medicina', 'Ayuda a los médicos a encontrar enfermedades en radiografías y a descubrir medicinas.'),
                      TarjetaInfo(Icons.school_rounded, 'Tutores inteligentes',
                          'Programas que se adaptan a cómo aprende cada estudiante y le dan ayuda personalizada.'),
                    ]),
                    GrupoTarjetas('Planeta y ciudad', Color(0xFF43A047), Icons.public_rounded, [
                      TarjetaInfo(Icons.forest_rounded, 'Cuidar bosques',
                          'Analiza imágenes de satélite para detectar la tala de árboles y vigilar animales silvestres.'),
                      TarjetaInfo(Icons.thunderstorm_rounded, 'Desastres', 'Ayuda a predecir huracanes e inundaciones para avisar a tiempo.'),
                      TarjetaInfo(Icons.traffic_rounded, 'Semáforos inteligentes', 'Cambian según el tráfico, la hora y el clima.'),
                    ]),
                    GrupoTarjetas('Industria', Color(0xFF546E7A), Icons.factory_rounded, [
                      TarjetaInfo(Icons.precision_manufacturing_rounded, 'Fábricas inteligentes',
                          'Predicen cuándo una máquina se va a descomponer y revisan la calidad de los productos.'),
                    ]),
                  ],
                  mensajeFinal: '¡La IA puede ayudar mucho!',
                )),
        PasoBio(
            '¿Qué hace esta IA?',
            TipoPasoBio.laboratorio,
            'i4_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Qué hace esta IA?',
                  color: _c3,
                  instruccion: 'Arrastra cada ejemplo a lo que hace la IA.',
                  grupos: const [
                    GrupoClasificar('Ve imágenes', '👀', Color(0xFF1E88E5)),
                    GrupoClasificar('Entiende lenguaje', '💬', Color(0xFF8E24AA)),
                    GrupoClasificar('Recomienda', '⭐', Color(0xFFF57C00)),
                  ],
                  items: const [
                    ItemClasificar('📸', 'La cámara enfoca tu cara', 0, 'Reconoce rostros.'),
                    ItemClasificar('🩻', 'Revisar radiografías', 0, 'Analiza imágenes médicas.'),
                    ItemClasificar('🛰️', 'Vigilar bosques con satélites', 0, 'Analiza fotos del espacio.'),
                    ItemClasificar('🌐', 'Traducir una conversación', 1, 'Procesa el lenguaje.'),
                    ItemClasificar('🗣️', 'Responder preguntas habladas', 1, 'Entiende la voz.'),
                    ItemClasificar('🎵', 'Sugerir canciones', 2, 'Aprende tus gustos.'),
                    ItemClasificar('🛒', 'Sugerir productos en una tienda', 2, 'Usa lo que compraste antes.'),
                  ],
                  mensajeFinal: 'Hay IA que ve, IA que entiende el lenguaje e IA que recomienda.',
                )),
        PasoBio(
            'Memorama de la IA',
            TipoPasoBio.juego,
            'i4_m3_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama de la IA',
                  color: _c3,
                  instruccion: 'Encuentra cada aparato con lo que hace.',
                  pares: const [
                    ('🗺️', 'Mapa', 'Calcula la mejor ruta'),
                    ('🌐', 'Traductor', 'Cambia de idioma'),
                    ('🗣️', 'Asistente', 'Entiende tu voz'),
                    ('🎬', 'Recomendador', 'Sugiere videos'),
                    ('🚗', 'Coche autónomo', 'Ve la calle'),
                    ('🩺', 'IA médica', 'Ayuda a diagnosticar'),
                  ],
                  mensajeFinal: '¡Memoria inteligente!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i4_m3_video',
            (a) => video(a,
                clave: 'accion_3',
                titulo: 'Video: la IA que ayuda',
                tema: 'la IA en la salud, el ambiente y la ciudad',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i4_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseRelacionar(const [
                      ('Medicina', 'Encontrar enfermedades en radiografías.'),
                      ('Medio ambiente', 'Detectar la tala de árboles.'),
                      ('Ciudad', 'Semáforos que se adaptan al tráfico.'),
                      ('Escuela', 'Tutores que se adaptan a cada alumno.'),
                    ], color: _c3, instruccion: 'Relaciona cada área con su ejemplo.'),
                  ],
                  mensajeFinal: 'Conoces cómo ayuda la IA.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'Un día con la IA',
      emoji: '🏆',
      color: Color(0xFF004D57),
      intro: '¡Último desafío! Encuentra la IA en el día de la familia de Zati.',
      mensajeFinal: '¡Encontraste la IA en cada momento del día!',
      pasos: [
        PasoBio(
            'Un día con la IA',
            TipoPasoBio.reto,
            'i4_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'Un día con la IA',
                  color: const Color(0xFF004D57),
                  escenas: const [
                    EscenaBio(
                      titulo: 'En la mañana',
                      narracion: 'Mamá pregunta en voz alta: “¿Va a llover hoy?” y una bocina le responde.',
                      emojis: '🔊🌦️',
                      pregunta: '¿Qué tipo de IA usa?',
                      opciones: ['Un asistente de voz', 'Un recomendador de videos', 'Una calculadora'],
                      correcta: 0,
                      explicacion: 'Entiende el lenguaje hablado.',
                    ),
                    EscenaBio(
                      titulo: 'Rumbo a la escuela',
                      narracion: 'Papá usa una app que le avisa del tráfico y le cambia la ruta.',
                      emojis: '🗺️🚗',
                      pregunta: '¿Cómo sabe dónde hay tráfico?',
                      opciones: ['Con datos de ubicación de muchos teléfonos', 'Lo adivina', 'Por la radio'],
                      correcta: 0,
                      explicacion: 'Aprende de muchos datos.',
                    ),
                    EscenaBio(
                      titulo: 'En la tarde',
                      narracion: 'Zati ve videos de dinosaurios y la app le muestra más y más dinosaurios.',
                      emojis: '🦕📺',
                      pregunta: '¿Por qué pasa esto?',
                      opciones: ['El recomendador aprendió lo que le gusta', 'La app solo tiene dinosaurios', 'Es casualidad'],
                      correcta: 0,
                      explicacion: 'Conviene explorar otros temas.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro en acción',
            TipoPasoBio.reto,
            'i4_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF004D57),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué usan los coches autónomos para “ver”?',
                          opciones: ['Cámaras y sensores', 'Un mapa de papel', 'Nada'],
                          correcta: 0,
                          explicacion: 'Y deciden en tiempo real.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo ayuda la IA al medio ambiente?',
                          opciones: ['Analiza imágenes de satélite para cuidar bosques', 'Tala árboles', 'No puede ayudar'],
                          correcta: 0,
                          explicacion: 'También ayuda a predecir desastres.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué aprende un buscador de internet?',
                          opciones: ['De los clics de las personas', 'De los colores de la pantalla', 'Del clima'],
                          correcta: 0,
                          explicacion: 'Así muestra mejores resultados.'),
                    ], color: const Color(0xFF004D57), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Detective de la IA Cotidiana!',
                )),
      ],
    ),
  ],
);
