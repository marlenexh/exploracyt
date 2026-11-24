import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_ia.dart';
import 'ilustraciones_ia.dart';
import 'sims_ia.dart';

/// Inteligencia Artificial · Tema 1: Máquinas inteligentes.

const _c1 = Color(0xFF5E35B1);
const _c2 = Color(0xFFD81B60);
const _c3 = Color(0xFF2E7D32);
const _ci = Color(0xFF4527A0);

final iaTema1 = TemaBio(
  numero: 1,
  mundo: 'ia',
  estilo: estiloIA(FondoIA.maquinas),
  titulo: 'Máquinas inteligentes',
  saludo:
      'Hay teléfonos, relojes y televisiones “inteligentes”… pero ¿qué hace que una máquina sea inteligente? ¡Vamos a descubrir qué es la inteligencia artificial y dónde se usa!',
  misionDelTema:
      'La escuela organiza la Feria de los Robots. Aprende qué es la IA, cómo saber si una máquina es inteligente y para qué sirve, para ser el guía de la feria.',
  color: _ci,
  insignia: 'Explorador de Máquinas Inteligentes',
  emojiInsignia: '🤖',
  emojisPanel: const ['🤖', '🧠', '💬', '👀', '🦾'],
  videos: const {
    'ia_1': 'assets/videos/ia_que_es.mp4',
    'ia_2': 'assets/videos/ia_turing.mp4',
    'ia_3': 'assets/videos/ia_agentes.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es la inteligencia artificial?',
      emoji: '🤖',
      color: _c1,
      intro: '¿Una máquina puede pensar? Conoce qué es la IA y cómo nació.',
      mensajeFinal: '¡Sabes qué es la inteligencia artificial!',
      pasos: [
        PasoBio(
            '¿Qué es la IA?',
            TipoPasoBio.explicacion,
            'i1_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. La IA',
                  titulo: '¿Qué es la inteligencia artificial?',
                  color: _c1,
                  il: ilQueEsIA,
                  textos: const [
                    'La inteligencia artificial (IA) es la ciencia que crea programas y máquinas capaces de hacer tareas que necesitan inteligencia: entender lo que decimos, aprender de ejemplos, razonar y tomar decisiones.',
                    'La IA nos ayuda a resolver problemas difíciles: traducir idiomas, reconocer rostros en fotos, recomendar videos, detectar correos basura, ayudar a los médicos y guiar coches que se manejan solos.',
                    'Una máquina inteligente necesita varias capacidades: entender el lenguaje que hablamos, razonar para sacar conclusiones, aprender de ejemplos y guardar lo que sabe. Para moverse en el mundo, además necesita visión y brazos o ruedas (robótica).',
                    'La IA no piensa ni siente como una persona: sigue programas que aprenden de muchos datos. ¡Por eso debemos usarla con cuidado!',
                  ],
                  izquierda: const [
                    Parte(
                        'lenguaje', 'Lenguaje', '(entiende y habla)', '💬', Color(0xFF7C4DFF), 'Procesamiento del lenguaje natural: entender nuestro idioma.'),
                    Parte('aprender', 'Aprendizaje', '(con ejemplos)', '📚', Color(0xFF43A047), 'Aprende a partir de muchos ejemplos.'),
                    Parte('actuar', 'Robótica', '(se mueve)', '🦾', Color(0xFF6D4C41), 'Manipula objetos con brazos o ruedas.'),
                  ],
                  derecha: const [
                    Parte('razonar', 'Razonamiento', '(saca conclusiones)', '🧠', Color(0xFFE91E63), 'Si llueve, el suelo estará mojado y resbaloso.'),
                    Parte('vision', 'Visión', '(ve con cámaras)', '👀', Color(0xFF1E88E5), 'Interpreta lo que ve en imágenes.'),
                    Parte('robot', 'Máquina inteligente', '(IA)', '🤖', Color(0xFF5E35B1), 'Combina varias capacidades.'),
                  ],
                  resaltar: const {
                    2: {'lenguaje', 'razonar', 'aprender', 'vision', 'actuar'},
                  },
                  mensajeFinal: '¡Ahora conoce la historia de la IA!',
                )),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'i1_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Historia',
                  titulo: 'Así nació la IA',
                  color: _c1,
                  textoZati: 'La IA tiene una historia de más de 80 años. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Momentos clave', _c1, Icons.history_edu_rounded, [
                      TarjetaInfo(Icons.hub_rounded, '1943: la primera neurona',
                          'McCulloch y Pitts crearon el primer modelo de red neuronal artificial, inspirado en el cerebro.'),
                      TarjetaInfo(Icons.person_rounded, '1950: Alan Turing', 'Preguntó si las máquinas pueden pensar y propuso una prueba para saberlo.'),
                      TarjetaInfo(Icons.school_rounded, '1956: nace el nombre',
                          'John McCarthy usó por primera vez el término “inteligencia artificial” en una reunión de científicos.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(
                          Icons.auto_stories_rounded, 'Ramon Llull', 'Hace más de 700 años, en 1315, este filósofo ya imaginaba máquinas que razonaran.'),
                      TarjetaInfo(Icons.casino_rounded, 'Ajedrez',
                          'Turing ayudó a crear uno de los primeros programas para jugar ajedrez. Hoy las máquinas ganan a los campeones.'),
                      TarjetaInfo(
                          Icons.mark_email_unread_rounded, 'Correo basura', 'Tu correo usa IA para separar el “spam”: aprende de millones de mensajes.'),
                    ]),
                  ],
                  mensajeFinal: '¡La IA tiene una gran historia!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i1_m1_video',
            (a) =>
                video(a, clave: 'ia_1', titulo: 'Video: ¿qué es la IA?', tema: 'qué es la inteligencia artificial', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i1_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseRelacionar(const [
                      ('Lenguaje natural', 'Entender el idioma que hablamos.'),
                      ('Aprendizaje', 'Mejorar con ejemplos.'),
                      ('Visión artificial', 'Interpretar imágenes.'),
                      ('Robótica', 'Mover y manipular objetos.'),
                    ], color: _c1, instruccion: 'Relaciona cada capacidad de la IA.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Quién usó por primera vez el nombre “inteligencia artificial”?',
                        opciones: ['John McCarthy', 'Isaac Newton', 'Galileo Galilei'],
                        correcta: 0,
                        explicacion: 'Fue en 1956.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes qué es la IA.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'La prueba de Turing',
      emoji: '🧑‍⚖️',
      color: _c2,
      intro: '¿Cómo saber si una máquina es inteligente? Alan Turing propuso un juego.',
      mensajeFinal: '¡Fuiste juez de la prueba de Turing!',
      pasos: [
        PasoBio(
            'La prueba de Turing',
            TipoPasoBio.explicacion,
            'i1_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Turing',
                  titulo: 'La prueba de Turing',
                  color: _c2,
                  il: ilTuring,
                  textos: const [
                    'En 1950 el matemático Alan Turing, considerado el padre de la computación, propuso una prueba para saber si una máquina es inteligente.',
                    'Sirve para pensar qué significa ser inteligente: si una máquina actúa como una persona al conversar, ¿podemos decir que es inteligente?',
                    'Un juez conversa por escrito con alguien que está en otra habitación: puede ser una persona o una máquina. Si después de platicar el juez no logra distinguir si era una máquina, decimos que la máquina pasó la prueba.',
                    'Hoy algunos programas conversan tan bien que es difícil saber si son personas. Por eso hay que pensar críticamente antes de creer todo lo que leemos.',
                  ],
                  izquierda: const [
                    Parte('persona', 'Persona', '(oculta)', '🧑', Color(0xFF43A047), 'Responde como humano.'),
                    Parte('pantalla', 'Conversación', '(por escrito)', '💻', Color(0xFF546E7A), 'Solo se ven los mensajes.'),
                  ],
                  derecha: const [
                    Parte('maquina', 'Máquina', '(oculta)', '🤖', Color(0xFFE91E63), 'Intenta responder como persona.'),
                    Parte('juez', 'Juez', '(decide)', '🧑‍⚖️', Color(0xFF5E35B1), 'Debe adivinar quién es la máquina.'),
                  ],
                  resaltar: const {
                    2: {'juez', 'pantalla'},
                  },
                  mensajeFinal: '¡Ahora tú serás el juez!',
                )),
        PasoBio('Sé el juez', TipoPasoBio.simulacion, 'i1_m2_sim', (a) => SimTuring(actividad: a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i1_m2_video',
            (a) => video(a,
                clave: 'ia_2',
                titulo: 'Video: la prueba de Turing',
                tema: '¿cómo saber si una máquina es inteligente?',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i1_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilTuring, const {'juez': 'Juez', 'persona': 'Persona', 'maquina': 'Máquina', 'pantalla': 'Conversación'}, color: _c2),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Cuándo pasa una máquina la prueba de Turing?',
                        opciones: ['Cuando el juez no puede distinguirla de una persona', 'Cuando gana una carrera', 'Cuando es muy grande'],
                        correcta: 0,
                        explicacion: 'Se trata de conversar como una persona.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Conoces la prueba de Turing.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Agentes y tipos de IA',
      emoji: '🦾',
      color: _c3,
      intro: 'Una IA percibe, decide y actúa. ¡Descubre cómo y dónde está!',
      mensajeFinal: '¡Reconoces las máquinas inteligentes!',
      pasos: [
        PasoBio(
            'El agente inteligente',
            TipoPasoBio.explicacion,
            'i1_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Agentes',
                  titulo: 'El agente inteligente',
                  color: _c3,
                  il: ilAgente,
                  textos: const [
                    'Un agente inteligente es un sistema que percibe su ambiente con sensores, interpreta y procesa esa información con su conocimiento, y actúa para lograr un objetivo.',
                    'Así funcionan una aspiradora robot que limpia sola, un videojuego con enemigos que te persiguen o un semáforo que cambia según el tráfico.',
                    'El ciclo es: 1) percibe con sensores (cámaras, micrófonos), 2) decide con su base de conocimiento, 3) actúa con actuadores (motores, bocinas, pantallas) y 4) vuelve a percibir los cambios.',
                    'Casi todas las IA de hoy son “particulares”: saben hacer una sola tarea muy bien. Una IA “general”, que aprenda de todo como una persona, todavía no existe.',
                  ],
                  izquierda: const [
                    Parte('sensores', 'Sensores', '(percibe)', '📷', Color(0xFF1E88E5), 'Cámaras, micrófonos, sensores de distancia.'),
                    Parte('ambiente', 'Ambiente', '(el entorno)', '🏞️', Color(0xFF43A047), 'Lo que rodea al agente.'),
                  ],
                  derecha: const [
                    Parte('conocimiento', 'Conocimiento', '(decide)', '🧠', Color(0xFFE91E63), 'Reglas y lo que aprendió.'),
                    Parte('actuadores', 'Actuadores', '(actúa)', '🦾', Color(0xFF6D4C41), 'Motores, ruedas, bocinas.'),
                    Parte('robot', 'Agente', '(la IA)', '🤖', Color(0xFF5E35B1), 'Persigue un objetivo.'),
                  ],
                  resaltar: const {
                    2: {'sensores', 'conocimiento', 'actuadores'},
                  },
                  mensajeFinal: '¡Ahora conoce los tipos de IA!',
                )),
        PasoBio(
            'Tipos de IA',
            TipoPasoBio.explicacion,
            'i1_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Tipos',
                  titulo: 'Tipos de inteligencia artificial',
                  color: _c3,
                  textoZati: 'Los científicos clasifican la IA en tres grandes ramas. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Ramas de la IA', _c3, Icons.account_tree_rounded, [
                      TarjetaInfo(Icons.filter_1_rounded, 'IA particular',
                          'Hace una sola tarea: recomendar videos, ubicarte en un mapa o clasificar datos. Es la que usamos hoy.'),
                      TarjetaInfo(
                          Icons.all_inclusive_rounded, 'IA general', 'Aprendería cualquier cosa y se adaptaría a todo, como una persona. Aún se investiga.'),
                      TarjetaInfo(
                          Icons.groups_rounded, 'IA social', 'Aprendería a convivir con personas entendiendo emociones y comportamientos. Está en desarrollo.'),
                    ]),
                  ],
                  mensajeFinal: '¡Ya conoces los tipos de IA!',
                )),
        PasoBio(
            '¿Usa IA o no?',
            TipoPasoBio.laboratorio,
            'i1_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '3. Clasifica',
                  titulo: '¿Usa inteligencia artificial?',
                  color: _c3,
                  instruccion: 'Arrastra cada aparato: ¿aprende o decide con IA, o solo sigue una orden fija?',
                  grupos: const [GrupoClasificar('Usa IA', '🤖', Color(0xFF5E35B1)), GrupoClasificar('No usa IA', '⚙️', Color(0xFF78909C))],
                  items: const [
                    ItemClasificar('🗣️', 'Asistente de voz', 0, 'Entiende lo que le dices.'),
                    ItemClasificar('🌐', 'Traductor en el celular', 0, 'Aprendió de millones de textos.'),
                    ItemClasificar('📧', 'Filtro de correo basura', 0, 'Aprende qué mensajes son spam.'),
                    ItemClasificar('🧹', 'Aspiradora robot', 0, 'Percibe obstáculos y decide por dónde ir.'),
                    ItemClasificar('🧮', 'Calculadora sencilla', 1, 'Solo hace las operaciones que le ordenas.'),
                    ItemClasificar('💡', 'Foco con apagador', 1, 'Solo prende y apaga.'),
                    ItemClasificar('⏰', 'Reloj despertador', 1, 'Suena a la hora fija.'),
                  ],
                  mensajeFinal: 'Una IA percibe, aprende o decide; una máquina común solo sigue una orden fija.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i1_m3_video',
            (a) => video(a,
                clave: 'ia_3', titulo: 'Video: agentes inteligentes', tema: 'cómo percibe, decide y actúa una IA', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i1_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseEtiquetar(ilAgente, const {'sensores': 'Sensores', 'conocimiento': 'Conocimiento', 'actuadores': 'Actuadores', 'ambiente': 'Ambiente'},
                        color: _c3),
                  ],
                  mensajeFinal: 'Conoces cómo funciona un agente inteligente.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La Feria de los Robots',
      emoji: '🏆',
      color: Color(0xFF6A1B9A),
      intro: '¡Último desafío! Guía a los visitantes por la Feria de los Robots.',
      mensajeFinal: '¡Fuiste el mejor guía de la feria!',
      pasos: [
        PasoBio(
            'La Feria de los Robots',
            TipoPasoBio.reto,
            'i1_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'La Feria de los Robots',
                  color: const Color(0xFF6A1B9A),
                  escenas: const [
                    EscenaBio(
                      titulo: 'El robot jardinero',
                      narracion: 'Un robot riega las plantas solo cuando su sensor detecta tierra seca.',
                      emojis: '🤖🌱💧',
                      pregunta: '¿Qué parte le permite saber si la tierra está seca?',
                      opciones: ['Su sensor', 'Su color', 'Su nombre'],
                      correcta: 0,
                      explicacion: 'Los sensores le ayudan a percibir el ambiente.',
                    ),
                    EscenaBio(
                      titulo: 'El chat misterioso',
                      narracion: 'En un puesto puedes chatear con alguien que no ves y adivinar si es persona o máquina.',
                      emojis: '💬❓',
                      pregunta: '¿Cómo se llama esta prueba?',
                      opciones: ['Prueba de Turing', 'Prueba de Newton', 'Prueba del ajedrez'],
                      correcta: 0,
                      explicacion: 'La propuso Alan Turing en 1950.',
                    ),
                    EscenaBio(
                      titulo: 'La tostadora',
                      narracion: 'Un visitante dice que su tostadora con temporizador tiene IA.',
                      emojis: '🍞⏲️',
                      pregunta: '¿Tiene razón?',
                      opciones: ['No: solo sigue una orden fija, no aprende ni decide', 'Sí, todas las máquinas tienen IA', 'Sí, porque es eléctrica'],
                      correcta: 0,
                      explicacion: 'Que sea eléctrica no la hace inteligente.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro robótico',
            TipoPasoBio.reto,
            'i1_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF6A1B9A),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué hace un agente inteligente?',
                          opciones: ['Percibe, decide y actúa', 'Solo se enciende', 'Solo guarda fotos'],
                          correcta: 0,
                          explicacion: 'Es su ciclo.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué tipo de IA usamos hoy?',
                          opciones: ['IA particular: hace una tarea específica', 'IA general que sabe todo', 'Ninguna'],
                          correcta: 0,
                          explicacion: 'La IA general aún no existe.'),
                      PreguntaQuiz(
                          pregunta: '¿En qué se inspiró la primera red neuronal artificial?',
                          opciones: ['En el cerebro', 'En un motor', 'En una planta'],
                          correcta: 0,
                          explicacion: 'Imita a las neuronas.'),
                    ], color: const Color(0xFF6A1B9A), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Explorador de Máquinas Inteligentes!',
                )),
      ],
    ),
  ],
);
