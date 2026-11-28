import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_ia.dart';
import 'ilustraciones_ia.dart';
import 'proyectos_ia.dart';
import 'sims_ia.dart';

/// Inteligencia Artificial · Tema 5: Usa la IA con cuidado.

const _c1 = Color(0xFF1565C0);
const _c2 = Color(0xFF00897B);
const _c3 = Color(0xFFE65100);
const _ci = Color(0xFF0D47A1);

final iaTema5 = TemaBio(
  numero: 5,
  mundo: 'ia',
  estilo: estiloIA(FondoIA.cuidado),
  titulo: 'Usa la IA con cuidado',
  saludo:
      'La IA es una herramienta poderosa, pero puede equivocarse, aprender cosas injustas o usar mal nuestros datos. ¡Vamos a aprender a usarla de forma responsable!',
  misionDelTema: 'Tu salón quiere usar IA para hacer tareas y proyectos. Descubre sus límites y riesgos, y escribe el reglamento para usarla con cuidado.',
  color: _ci,
  insignia: 'Guardián Digital Responsable',
  emojiInsignia: '🛡️',
  emojisPanel: const ['🛡️', '🔒', '⚖️', '🧐', '✅'],
  videos: const {
    'cuidado_1': 'assets/videos/ia_limites.mp4',
    'cuidado_2': 'assets/videos/ia_privacidad.mp4',
    'cuidado_3': 'assets/videos/ia_responsable.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Límites y errores de la IA',
      emoji: '⚖️',
      color: _c1,
      intro: 'La IA no es perfecta. ¡Descubre por qué puede equivocarse!',
      mensajeFinal: '¡Conoces los límites de la IA!',
      pasos: [
        PasoBio(
            'Límites y riesgos',
            TipoPasoBio.explicacion,
            'i5_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Límites',
                  titulo: 'Límites y riesgos de la IA',
                  color: _c1,
                  il: ilRiesgos,
                  textos: const [
                    'La IA no piensa ni siente como una persona: solo encuentra patrones en sus datos. Por eso puede equivocarse, inventar respuestas o no entender bromas y emociones.',
                    'Conocer sus límites nos ayuda a usarla mejor: revisar lo que responde, no creerle todo y decidir nosotros.',
                    'Si sus datos tienen errores o no son variados, la IA aprende cosas injustas: a eso se le llama sesgo. También puede usar mal nuestros datos personales o crear imágenes y noticias falsas.',
                    'La IA depende de la calidad de sus datos: una IA que solo vio un tipo de ejemplos no sabrá qué hacer con los demás.',
                  ],
                  izquierda: const [
                    Parte('sesgo', 'Sesgo', '(datos injustos)', '⚖️', Color(0xFFF57C00), 'Aprende mal si sus datos no son variados.'),
                    Parte('falsas', 'Contenido falso', '(engaños)', '🎭', Color(0xFF8E24AA), 'Imágenes, voces o noticias inventadas.'),
                    Parte('persona', 'Tú decides', '(con criterio)', '🧑', Color(0xFF1565C0), 'La persona es la responsable.'),
                  ],
                  derecha: const [
                    Parte('privacidad', 'Privacidad', '(tus datos)', '🔒', Color(0xFF00897B), 'Tus datos personales son tuyos.'),
                    Parte('errores', 'Errores', '(se equivoca)', '❌', Color(0xFFE53935), 'Puede dar respuestas incorrectas.'),
                  ],
                  resaltar: const {
                    1: {'persona'},
                    2: {'sesgo', 'privacidad', 'falsas'},
                    3: {'sesgo'},
                  },
                  mensajeFinal: '¡Ahora descubre un sesgo!',
                )),
        PasoBio('La IA con sesgo', TipoPasoBio.simulacion, 'i5_m1_sim', (a) => SimEntrenar(actividad: a, color: _c1, proyecto: proyectoManzanas, sesgo: true)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i5_m1_video',
            (a) => video(a,
                clave: 'cuidado_1', titulo: 'Video: la IA se equivoca', tema: 'límites, errores y sesgos de la IA', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i5_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilRiesgos, const {'sesgo': 'Sesgo', 'privacidad': 'Privacidad', 'falsas': 'Contenido falso', 'errores': 'Errores'},
                        color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué es un sesgo en la IA?',
                          opciones: ['Aprender algo injusto o incompleto porque sus datos no eran variados', 'Un tipo de cable', 'Una IA muy rápida'],
                          correcta: 0,
                          explicacion: 'Se corrige con datos variados.'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Conoces los límites de la IA.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Privacidad y datos personales',
      emoji: '🔒',
      color: _c2,
      intro: 'Tus datos son valiosos. ¡Aprende a protegerlos!',
      mensajeFinal: '¡Proteges tus datos personales!',
      pasos: [
        PasoBio(
            '¿Lo puedo compartir?',
            TipoPasoBio.laboratorio,
            'i5_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '1. Clasifica',
                  titulo: '¿Lo puedo compartir con una app o un chat?',
                  color: _c2,
                  instruccion: 'Arrastra cada dato: ¿lo puedes compartir o es privado?',
                  grupos: const [GrupoClasificar('Puedo compartirlo', '👍', Color(0xFF43A047)), GrupoClasificar('Es privado', '🔒', Color(0xFFE53935))],
                  items: const [
                    ItemClasificar('🎨', 'Mi color favorito', 0, 'No dice quién eres ni dónde vives.'),
                    ItemClasificar('🦖', 'Que me gustan los dinosaurios', 0, 'Es un gusto general.'),
                    ItemClasificar('🏠', 'Mi dirección', 1, 'Dice dónde vives.'),
                    ItemClasificar('🔑', 'Mis contraseñas', 1, '¡Nunca las compartas!'),
                    ItemClasificar('📞', 'Mi número de teléfono', 1, 'Es un dato personal.'),
                    ItemClasificar('🤳', 'Fotos de mi cara o de mi escuela', 1, 'Pueden identificarte.'),
                  ],
                  mensajeFinal: 'Tus datos personales te pertenecen: compártelos solo con permiso de un adulto de confianza.',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'i5_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Tus datos valen mucho',
                  color: _c2,
                  textoZati: 'Las IA necesitan datos, y muchos son nuestros. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.cloud_rounded, 'La nube', 'Muchos datos se guardan en computadoras lejanas llamadas “la nube”, no en tu teléfono.'),
                      TarjetaInfo(Icons.face_retouching_natural_rounded, 'Tu cara es un dato',
                          'El reconocimiento facial convierte tu rostro en números que pueden identificarte.'),
                      TarjetaInfo(Icons.chat_rounded, 'Los chats con IA', 'Lo que escribes en un chat puede guardarse. No escribas datos personales.'),
                    ]),
                  ],
                  mensajeFinal: '¡Cuida tus datos!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i5_m2_video',
            (a) =>
                video(a, clave: 'cuidado_2', titulo: 'Video: cuida tus datos', tema: 'privacidad y datos personales', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i5_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseAcciones(
                        'Cuida tu privacidad',
                        'Toca las acciones seguras y presiona “Comprobar”.',
                        const [
                          Accion(Icons.family_restroom_rounded, 'Pedir permiso a un adulto antes de usar una app nueva', true, 'Te ayuda a decidir.'),
                          Accion(Icons.password_rounded, 'Usar contraseñas difíciles y no compartirlas', true, 'Protege tus cuentas.'),
                          Accion(Icons.no_photography_rounded, 'Pensarlo antes de subir una foto', true, 'Las fotos pueden identificarte.'),
                          Accion(Icons.home_rounded, 'Escribir mi dirección en un chat con IA', false, 'Es un dato privado.'),
                          Accion(Icons.share_rounded, 'Compartir la contraseña con un amigo', false, '¡Es solo tuya!'),
                        ],
                        color: _c2),
                  ],
                  mensajeFinal: 'Proteges tu privacidad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Contenido falso y uso responsable',
      emoji: '🧐',
      color: _c3,
      intro: 'La IA puede crear imágenes y textos. ¡Aprende a usarla con honestidad!',
      mensajeFinal: '¡Usas la IA con responsabilidad!',
      pasos: [
        PasoBio(
            'Crear con IA',
            TipoPasoBio.explicacion,
            'i5_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Usar bien la IA',
                  titulo: 'Crear con IA… con cuidado',
                  color: _c3,
                  textoZati: 'La IA generativa crea textos, imágenes y voces. Toca cada tarjeta para saber cómo usarla bien.',
                  grupos: const [
                    GrupoTarjetas('Riesgos', Color(0xFFE53935), Icons.warning_rounded, [
                      TarjetaInfo(Icons.theater_comedy_rounded, 'Contenido falso', 'Puede crear fotos, videos o voces que parecen reales pero son inventados.'),
                      TarjetaInfo(Icons.newspaper_rounded, 'Noticias falsas',
                          'Puede usarse para difundir mentiras; las personas también pueden hacerlo. El problema es el mal uso.'),
                      TarjetaInfo(Icons.error_outline_rounded, 'Respuestas inventadas', 'A veces responde con seguridad cosas que no son ciertas.'),
                    ]),
                    GrupoTarjetas('Buenos usos', Color(0xFF43A047), Icons.verified_rounded, [
                      TarjetaInfo(
                          Icons.tips_and_updates_rounded, 'Para ideas', 'Úsala para generar ideas o hacer un esquema, no para copiar tareas completas.'),
                      TarjetaInfo(
                          Icons.fact_check_rounded, 'Verifica', 'Revisa, analiza y corrige lo que te responde, comparando con libros y fuentes confiables.'),
                      TarjetaInfo(
                          Icons.accessibility_new_rounded, 'Ayuda a incluir', 'Crea subtítulos y lee textos en voz alta para personas con discapacidad.'),
                    ]),
                  ],
                  mensajeFinal: '¡La IA es una herramienta: tú eres responsable de cómo la usas!',
                )),
        PasoBio(
            '¿Uso responsable?',
            TipoPasoBio.juego,
            'i5_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Uso responsable o no?',
                  color: _c3,
                  instruccion: 'Arrastra cada situación al grupo correcto.',
                  grupos: const [GrupoClasificar('Responsable', '✅', Color(0xFF43A047)), GrupoClasificar('No responsable', '🚫', Color(0xFFE53935))],
                  items: const [
                    ItemClasificar('💡', 'Pedirle ideas para mi proyecto y luego hacerlo yo', 0, 'La IA te ayuda; el trabajo es tuyo.'),
                    ItemClasificar('🔎', 'Comprobar sus respuestas en un libro', 0, 'Así evitas errores.'),
                    ItemClasificar('🗣️', 'Decir que usé IA cuando me ayudó', 0, 'Ser honesto es importante.'),
                    ItemClasificar('📄', 'Copiar la tarea completa que escribió la IA', 1, 'No aprendes y no es honesto.'),
                    ItemClasificar('🎭', 'Crear una foto falsa de un compañero', 1, 'Puede lastimar y engañar.'),
                    ItemClasificar('📢', 'Compartir una noticia sin verificarla', 1, 'Puede ser falsa.'),
                  ],
                  mensajeFinal: 'Usar la IA con honestidad y verificando es usarla con responsabilidad.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i5_m3_video',
            (a) => video(a,
                clave: 'cuidado_3',
                titulo: 'Video: usa la IA con responsabilidad',
                tema: 'contenido falso y uso ético de la IA',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i5_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: 'Ves un video de un famoso diciendo algo muy raro. ¿Qué haces?',
                          opciones: ['Verifico en fuentes confiables: podría estar hecho con IA', 'Lo comparto rápido', 'Le creo todo'],
                          correcta: 0,
                          explicacion: 'Existen videos falsos muy realistas.'),
                      PreguntaQuiz(
                          pregunta: '¿Para qué conviene usar la IA en la escuela?',
                          opciones: ['Para generar ideas y luego hacer mi propio trabajo', 'Para copiar las tareas', 'Para no leer nunca'],
                          correcta: 0,
                          explicacion: 'Tú sigues siendo el autor.'),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Usas la IA con responsabilidad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El reglamento de IA del salón',
      emoji: '🏆',
      color: Color(0xFF0D2F6B),
      intro: '¡Último desafío! Ayuda a tu salón a escribir su reglamento para usar IA.',
      mensajeFinal: '¡Tu salón usa la IA con cuidado!',
      pasos: [
        PasoBio(
            'El reglamento de IA',
            TipoPasoBio.reto,
            'i5_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El reglamento de IA del salón',
                  color: const Color(0xFF0D2F6B),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Regla 1',
                      narracion: 'Luis le pidió a una IA el resumen de un libro y tenía datos equivocados.',
                      emojis: '📚🤖❌',
                      pregunta: '¿Qué regla proponen?',
                      opciones: ['Siempre verificar lo que responde la IA', 'Nunca leer libros', 'Creerle todo a la IA'],
                      correcta: 0,
                      explicacion: 'La IA puede equivocarse.',
                    ),
                    EscenaBio(
                      titulo: 'Regla 2',
                      narracion: 'Una app de dibujos pide la dirección y la foto de cada alumno.',
                      emojis: '📱🏠🤳',
                      pregunta: '¿Qué regla proponen?',
                      opciones: ['No dar datos personales y pedir ayuda a un adulto', 'Dar todos los datos', 'Inventar datos de otros'],
                      correcta: 0,
                      explicacion: 'Tus datos son privados.',
                    ),
                    EscenaBio(
                      titulo: 'Regla 3',
                      narracion: 'Una IA para elegir al equipo de fútbol solo vio datos de niños, nunca de niñas.',
                      emojis: '⚽⚖️',
                      pregunta: '¿Qué problema tiene?',
                      opciones: ['Tiene sesgo: sus datos no eran variados', 'Ninguno', 'Es demasiado rápida'],
                      correcta: 0,
                      explicacion: 'Datos variados = decisiones más justas.',
                    ),
                    EscenaBio(
                      titulo: 'Regla 4',
                      narracion: 'Ana quiere usar IA para su tarea de ciencias.',
                      emojis: '📝💡',
                      pregunta: '¿Qué regla proponen?',
                      opciones: ['Usarla para ideas y decir que la usamos', 'Copiar todo sin decir nada', 'Prohibir pensar'],
                      correcta: 0,
                      explicacion: 'Honestidad y aprendizaje primero.',
                    ),
                  ],
                  mensajeFinal: '¡Reglamento listo!',
                )),
        PasoBio(
            'Supercerebro responsable',
            TipoPasoBio.reto,
            'i5_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF0D2F6B),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Quién es responsable de lo que se hace con la IA?',
                          opciones: ['Las personas que la usan y la crean', 'Nadie', 'Solo la máquina'],
                          correcta: 0,
                          explicacion: 'La IA es una herramienta.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo se corrige un sesgo?',
                          opciones: ['Con datos más variados y revisando los resultados', 'Apagando la pantalla', 'Con más luz'],
                          correcta: 0,
                          explicacion: 'Como en el detector de manzanas.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál es un dato privado?',
                          opciones: ['Mi contraseña', 'Mi fruta favorita', 'Mi color favorito'],
                          correcta: 0,
                          explicacion: '¡Nunca la compartas!'),
                    ], color: const Color(0xFF0D2F6B), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Guardián Digital Responsable»!',
                )),
      ],
    ),
  ],
);
