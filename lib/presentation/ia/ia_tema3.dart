import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_ia.dart';
import 'ilustraciones_ia.dart';
import 'proyectos_ia.dart';
import 'sims_ia.dart';
import 'sim_3d_red.dart';

/// Inteligencia Artificial · Tema 3: Enseña a una máquina.

const _c1 = Color(0xFF2E7D32);
const _c2 = Color(0xFF6A1B9A);
const _c3 = Color(0xFFC2185B);
const _ci = Color(0xFF1B5E20);

final iaTema3 = TemaBio(
  numero: 3,
  mundo: 'ia',
  estilo: estiloIA(FondoIA.ensena),
  titulo: 'Enseña a una máquina',
  saludo:
      'Tú aprendiste a reconocer a un perro viendo muchos perros. ¡Las máquinas también aprenden con ejemplos! Vamos a descubrir el aprendizaje automático y a entrenar nuestra propia IA.',
  misionDelTema:
      'La escuela de robots necesita maestros. Aprende cómo aprende una máquina, entrena una IA con ejemplos y una neurona artificial, y ayuda al robot que separa la basura.',
  color: _ci,
  insignia: 'Entrenador de Máquinas',
  emojiInsignia: '🎓',
  emojisPanel: const ['📚', '🏷️', '🏋️', '🤖', '✅'],
  videos: const {
    'aprendizaje_1': 'assets/videos/aprendizaje_como.mp4',
    'aprendizaje_2': 'assets/videos/aprendizaje_entrenar.mp4',
    'aprendizaje_3': 'assets/videos/aprendizaje_neuronas.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Cómo aprende una máquina?',
      emoji: '📚',
      color: _c1,
      intro: 'Una máquina aprende con datos y ejemplos. ¡Descubre cómo!',
      mensajeFinal: '¡Sabes cómo aprende una máquina!',
      pasos: [
        PasoBio(
            'El aprendizaje automático',
            TipoPasoBio.explicacion,
            'i3_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Aprender',
                  titulo: 'El aprendizaje automático',
                  color: _c1,
                  il: ilAprendizaje,
                  textos: const [
                    'El aprendizaje automático es la parte de la IA en la que las máquinas aprenden de los datos, en lugar de que alguien les escriba todas las reglas.',
                    'Si una máquina no puede aprender, difícilmente se adapta a cosas nuevas. Aprender le permite reconocer imágenes, entender la voz o recomendar canciones.',
                    'En el aprendizaje supervisado: 1) reunimos datos de ejemplo, 2) les ponemos etiqueta (por ejemplo “gato” o “perro”), 3) entrenamos a la IA para que encuentre el patrón y 4) el modelo predice la etiqueta de ejemplos nuevos que nunca vio.',
                    'Mientras más datos y de mejor calidad, mejor aprende. ¡Datos con errores enseñan errores!',
                  ],
                  izquierda: const [
                    Parte('datos', 'Datos', '(ejemplos)', '🗂️', Color(0xFF1E88E5), 'Muchos ejemplos del problema.'),
                    Parte('entrenar', 'Entrenar', '(buscar patrones)', '🏋️', Color(0xFFF57C00), 'La IA compara los ejemplos.'),
                    Parte('nuevo', 'Dato nuevo', '(nunca visto)', '🍎', Color(0xFFE53935), 'Un ejemplo nuevo para probar.'),
                  ],
                  derecha: const [
                    Parte('etiquetas', 'Etiquetas', '(respuestas)', '🏷️', Color(0xFF8E24AA), 'Lo que es cada ejemplo.'),
                    Parte('modelo', 'Modelo', '(lo aprendido)', '🤖', Color(0xFF2E7D32), 'Lo que la IA aprendió.'),
                    Parte('prediccion', 'Predicción', '(respuesta)', '✅', Color(0xFF43A047), 'Lo que la IA cree que es.'),
                  ],
                  resaltar: const {
                    2: {'datos', 'etiquetas', 'entrenar', 'modelo', 'prediccion'},
                    3: {'datos'},
                  },
                  mensajeFinal: '¡Ordena los pasos del aprendizaje!',
                )),
        PasoBio(
            'Los pasos para enseñar',
            TipoPasoBio.juego,
            'i3_m1_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Ordena',
                  titulo: 'Así se enseña a una máquina',
                  color: _c1,
                  instruccion: 'Ordena los pasos del aprendizaje supervisado.',
                  pasos: const [
                    ('🗂️', 'Reunir muchos datos de ejemplo'),
                    ('🏷️', 'Ponerle etiqueta a cada ejemplo'),
                    ('🏋️', 'Entrenar a la IA'),
                    ('🧪', 'Probar con ejemplos nuevos'),
                    ('✅', 'Usar la IA para predecir'),
                  ],
                  explicacion: 'Si al probar se equivoca mucho, se regresa a revisar los datos y a entrenar otra vez.',
                  mensajeFinal: '¡Ya sabes enseñar a una máquina!',
                )),
        PasoBio(
            'Formas de aprender',
            TipoPasoBio.explicacion,
            'i3_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '3. Formas',
                  titulo: 'Tres formas de aprender',
                  color: _c1,
                  textoZati: 'Las máquinas aprenden de tres formas principales. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Tipos de aprendizaje', _c1, Icons.school_rounded, [
                      TarjetaInfo(Icons.sell_rounded, 'Supervisado', 'Aprende con ejemplos que tienen etiqueta: “esto es un gato”, “esto es un perro”.'),
                      TarjetaInfo(Icons.bubble_chart_rounded, 'No supervisado',
                          'Sin etiquetas: agrupa los datos que se parecen. Por ejemplo, separa días de lluvia, frío o nieve.'),
                      TarjetaInfo(Icons.emoji_events_rounded, 'Por refuerzo',
                          'Aprende por prueba y error con premios y castigos, como al jugar. Así se pueden controlar semáforos.'),
                    ]),
                  ],
                  mensajeFinal: '¡Conoces las formas de aprender!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i3_m1_video',
            (a) => video(a,
                clave: 'aprendizaje_1',
                titulo: 'Video: ¿cómo aprende una máquina?',
                tema: 'el aprendizaje automático',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i3_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilAprendizaje, const {'datos': 'Datos', 'etiquetas': 'Etiquetas', 'modelo': 'Modelo', 'prediccion': 'Predicción'},
                        color: _c1),
                    faseRelacionar(const [
                      ('Supervisado', 'Aprende con ejemplos etiquetados.'),
                      ('No supervisado', 'Agrupa datos parecidos sin etiquetas.'),
                      ('Por refuerzo', 'Aprende con premios y castigos.'),
                    ], color: _c1, instruccion: 'Relaciona cada forma de aprender.'),
                  ],
                  mensajeFinal: 'Sabes cómo aprende una máquina.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Entrena tu clasificador',
      emoji: '🏷️',
      color: _c2,
      intro: '¡Tú serás el maestro! Etiqueta ejemplos y entrena una IA.',
      mensajeFinal: '¡Entrenaste tu primera IA!',
      pasos: [
        PasoBio('¿Mamífero o ave?', TipoPasoBio.laboratorio, 'i3_m2_sim', (a) => SimEntrenar(actividad: a, color: _c2, proyecto: proyectoMamiferoAve)),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'i3_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Clasificadores famosos',
                  color: _c2,
                  textoZati: 'Los clasificadores están en muchos lugares. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.mark_email_unread_rounded, 'Anti-spam',
                          'Tu correo clasifica los mensajes en “basura” o “no basura” y mejora con cada mensaje.'),
                      TarjetaInfo(Icons.text_fields_rounded, 'Leer letras', 'Hay IA que reconocen letras escritas a mano o en placas de coches (OCR).'),
                      TarjetaInfo(
                          Icons.dataset_rounded, 'Muchos datos', 'Las IA modernas se entrenan con millones de ejemplos y necesitan computadoras muy potentes.'),
                    ]),
                  ],
                  mensajeFinal: '¡Los clasificadores están por todas partes!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i3_m2_video',
            (a) => video(a,
                clave: 'aprendizaje_2', titulo: 'Video: entrena una IA', tema: 'datos, etiquetas y clasificación', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i3_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué pasa si le enseñas a la IA con etiquetas equivocadas?',
                          opciones: ['Aprende mal y se equivoca', 'Aprende mejor', 'No pasa nada'],
                          correcta: 0,
                          explicacion: 'La IA aprende lo que le enseñamos.'),
                      PreguntaQuiz(
                          pregunta: '¿Para qué se prueba la IA con ejemplos nuevos?',
                          opciones: ['Para saber si de verdad aprendió el patrón', 'Para borrarla', 'Para que se canse'],
                          correcta: 0,
                          explicacion: 'Debe acertar con datos que nunca vio.'),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Sabes entrenar un clasificador.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'La neurona artificial',
      emoji: '🧠',
      color: _c3,
      intro: 'Las redes neuronales se inspiran en el cerebro. ¡Entrena una neurona!',
      mensajeFinal: '¡Entrenaste una neurona artificial!',
      pasos: [
        PasoBio(
            'Neuronas de verdad y artificiales',
            TipoPasoBio.explicacion,
            'i3_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Neuronas',
                  titulo: 'La neurona artificial',
                  color: _c3,
                  il: ilNeurona,
                  textos: const [
                    'Tu cerebro tiene miles de millones de neuronas conectadas. Una neurona recibe señales y, si son suficientes, se activa y manda una señal a otras.',
                    'Las redes neuronales artificiales imitan esta idea y son muy buenas para reconocer imágenes, voces y textos.',
                    'La neurona artificial más sencilla se llama perceptrón: recibe entradas, multiplica cada una por un peso (su importancia), las suma y, si la suma pasa un umbral, se activa. Aprender es ajustar los pesos.',
                    'Cada neurona de tu cerebro está conectada en promedio con otras mil. ¡Las redes artificiales todavía son mucho más simples!',
                  ],
                  izquierda: const [
                    Parte('entradas', 'Entradas', '(datos)', '🔢', Color(0xFF7C4DFF), 'La información que llega.'),
                    Parte('pesos', 'Pesos', '(importancia)', '⚖️', Color(0xFFFFB300), 'Cuánto importa cada entrada.'),
                  ],
                  derecha: const [
                    Parte('neurona', 'Neurona', '(suma)', '🟣', Color(0xFFC2185B), 'Suma y compara con el umbral.'),
                    Parte('salida', 'Salida', '(respuesta)', '💡', Color(0xFFFBC02D), 'Se activa o no.'),
                    Parte('cerebro', 'Cerebro', '(inspiración)', '🧠', Color(0xFFE91E63), 'Las redes se inspiran en él.'),
                  ],
                  resaltar: const {
                    0: {'cerebro'},
                    2: {'entradas', 'pesos', 'neurona', 'salida'},
                  },
                  mensajeFinal: '¡Ahora entrena una neurona!',
                )),
        PasoBio('Entrena una neurona', TipoPasoBio.simulacion, 'i3_m3_sim', (a) => SimNeurona(actividad: a, color: _c3)),
        PasoBio('Red neuronal en 3D', TipoPasoBio.simulacion, 'i3_m3_3d', (a) => SimRedNeuronal3D(actividad: a, color: _c3)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i3_m3_video',
            (a) => video(a,
                clave: 'aprendizaje_3', titulo: 'Video: redes neuronales', tema: 'neuronas, pesos y aprendizaje', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i3_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseEtiquetar(ilNeurona, const {'entradas': 'Entradas', 'pesos': 'Pesos', 'neurona': 'Neurona', 'salida': 'Salida'}, color: _c3),
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué significa que una red neuronal “aprende”?',
                          opciones: ['Que ajusta sus pesos para equivocarse menos', 'Que crece de tamaño', 'Que se conecta a internet'],
                          correcta: 0,
                          explicacion: 'Los pesos guardan lo aprendido.'),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Conoces la neurona artificial.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El robot que separa la basura',
      emoji: '🏆',
      color: Color(0xFF33691E),
      intro: '¡Último desafío! Enseña al robot de la escuela a separar la basura.',
      mensajeFinal: '¡El robot separa la basura como experto!',
      pasos: [
        PasoBio(
            'El robot que separa la basura',
            TipoPasoBio.reto,
            'i3_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El robot que separa la basura',
                  color: const Color(0xFF33691E),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Reunir datos',
                      narracion: 'Para enseñarle, el equipo toma fotos de basura.',
                      emojis: '📸🍌🧴',
                      pregunta: '¿Qué fotos conviene reunir?',
                      opciones: ['Muchas fotos variadas de basura orgánica y reciclable', 'Una sola foto', 'Solo fotos de plátanos'],
                      correcta: 0,
                      explicacion: 'Muchos datos variados ayudan a aprender.',
                    ),
                    EscenaBio(
                      titulo: 'Etiquetar',
                      narracion: 'Alguien etiquetó una botella de plástico como “orgánica”.',
                      emojis: '🧴🏷️❌',
                      pregunta: '¿Qué puede pasar?',
                      opciones: ['El robot aprenderá mal', 'El robot aprenderá mejor', 'Nada'],
                      correcta: 0,
                      explicacion: 'Las etiquetas deben ser correctas.',
                    ),
                    EscenaBio(
                      titulo: 'Probar',
                      narracion: 'El robot ve una cáscara de mango que nunca había visto.',
                      emojis: '🤖🥭',
                      pregunta: '¿Cómo decide?',
                      opciones: ['Compara sus rasgos con lo que aprendió', 'Lo adivina al azar', 'No puede hacer nada'],
                      correcta: 0,
                      explicacion: 'Busca el patrón más parecido.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro del aprendizaje',
            TipoPasoBio.reto,
            'i3_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF33691E),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué son las etiquetas?',
                          opciones: ['La respuesta correcta de cada ejemplo', 'El precio de la IA', 'Los cables'],
                          correcta: 0,
                          explicacion: 'Por ejemplo: “gato”.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué tipo de aprendizaje agrupa datos sin etiquetas?',
                          opciones: ['No supervisado', 'Supervisado', 'Por refuerzo'],
                          correcta: 0,
                          explicacion: 'Busca semejanzas por sí solo.'),
                      PreguntaQuiz(
                          pregunta: '¿En qué se inspiran las redes neuronales?',
                          opciones: ['En las neuronas del cerebro', 'En las raíces de un árbol', 'En los relojes'],
                          correcta: 0,
                          explicacion: 'Por eso se llaman neuronales.'),
                    ], color: const Color(0xFF33691E), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Entrenador de Máquinas!',
                )),
      ],
    ),
  ],
);
