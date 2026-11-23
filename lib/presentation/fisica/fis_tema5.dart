import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fondos_ciencia.dart';
import 'ilustraciones_fis.dart';
import 'sims_fis.dart';

/// Física · Tema 5: Explorando el Sistema Solar.

const _c1 = Color(0xFFFF8F00);
const _c2 = Color(0xFF3949AB);
const _c3 = Color(0xFF00897B);
const _ci = Color(0xFF283593);

final fisTema5 = TemaBio(
  numero: 5,
  mundo: 'fis',
  estilo: estiloCiencia(FondoCiencia.espacio),
  titulo: 'Explorando el Sistema Solar',
  saludo: '¡Prepara tu nave! Vamos a viajar por el Sistema Solar para conocer al Sol, los ocho planetas y cómo se mueven en el espacio.',
  misionDelTema:
      'Eres parte de la tripulación de una nave exploradora. Visita cada planeta, anota sus características y descubre por qué hay días, noches y estaciones.',
  color: _ci,
  insignia: 'Astronauta Explorador',
  emojiInsignia: '🚀',
  emojisPanel: const ['☀️', '🌍', '🪐', '🌙', '☄️'],
  videos: const {
    'espacio_1': 'assets/videos/espacio_sistema_solar.mp4',
    'espacio_2': 'assets/videos/espacio_planetas.mp4',
    'espacio_3': 'assets/videos/espacio_movimientos.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'El Sol y los planetas',
      emoji: '☀️',
      color: _c1,
      intro: 'El Sol es el centro de nuestro sistema. ¡Despega y conoce a sus planetas!',
      mensajeFinal: '¡Conoces el Sistema Solar!',
      pasos: [
        PasoBio(
            'El Sistema Solar',
            TipoPasoBio.explicacion,
            'f5_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Sistema Solar',
                  titulo: 'El Sol y sus planetas',
                  color: _c1,
                  il: ilSistemaSolar,
                  textos: const [
                    'El Sistema Solar está formado por el Sol, ocho planetas con sus lunas, planetas enanos como Plutón, asteroides y cometas. El Sol es una estrella: una enorme esfera de gases muy calientes.',
                    'El Sol nos da luz y calor; sin él no habría vida en la Tierra. Las plantas lo usan para fabricar su alimento.',
                    'La gravedad del Sol mantiene a los planetas girando a su alrededor en caminos llamados órbitas. En orden: Mercurio, Venus, Tierra, Marte, Júpiter, Saturno, Urano y Neptuno.',
                    'La luz del Sol tarda unos 8 minutos en llegar a la Tierra. ¡Lo que ves es el Sol de hace 8 minutos!',
                  ],
                  izquierda: const [
                    Parte('sol', 'El Sol', '(estrella)', '☀️', Color(0xFFFF8F00), 'Es la estrella del centro.'),
                    Parte('mercurio', 'Mercurio', '(1.º)', '⚫', Color(0xFF9E9E9E), 'El más cercano al Sol.'),
                    Parte('tierra', 'Tierra', '(3.º)', '🌍', Color(0xFF42A5F5), 'Nuestro hogar.'),
                    Parte('jupiter', 'Júpiter', '(5.º)', '🟠', Color(0xFFFFB74D), 'El más grande.'),
                    Parte('urano', 'Urano', '(7.º)', '🔵', Color(0xFF80DEEA), 'Gira de lado.'),
                  ],
                  derecha: const [
                    Parte('venus', 'Venus', '(2.º)', '🟡', Color(0xFFFFCC80), 'El más caliente.'),
                    Parte('marte', 'Marte', '(4.º)', '🔴', Color(0xFFE53935), 'El planeta rojo.'),
                    Parte('saturno', 'Saturno', '(6.º)', '🪐', Color(0xFFFFE082), 'Tiene anillos.'),
                    Parte('neptuno', 'Neptuno', '(8.º)', '🔷', Color(0xFF3949AB), 'El más lejano.'),
                  ],
                  resaltar: const {
                    0: {'sol'},
                    1: {'sol', 'tierra'},
                  },
                  mensajeFinal: '¡Ahora despega y visita cada planeta!',
                )),
        PasoBio('Viaje por los planetas', TipoPasoBio.simulacion, 'f5_m1_sim', (a) => SimSistemaSolar(actividad: a, color: _c1)),
        PasoBio(
            'Ordena los planetas',
            TipoPasoBio.juego,
            'f5_m1_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Ordena',
                  titulo: 'Del más cercano al más lejano',
                  color: _c1,
                  instruccion: 'Ordena los planetas desde el más cercano al Sol.',
                  pasos: const [
                    ('⚫', 'Mercurio'),
                    ('🟡', 'Venus'),
                    ('🌍', 'Tierra'),
                    ('🔴', 'Marte'),
                    ('🟠', 'Júpiter'),
                    ('🪐', 'Saturno'),
                    ('🔵', 'Urano'),
                    ('🔷', 'Neptuno'),
                  ],
                  explicacion: 'Un truco: “Mi Vieja Tía Marta Jamás Supo Usar Néctar”.',
                  mensajeFinal: '¡Conoces el orden de los planetas!',
                )),
        PasoBio('Video del tema', TipoPasoBio.video, 'f5_m1_video',
            (a) => video(a, clave: 'espacio_1', titulo: 'Video: el Sistema Solar', tema: 'el Sol y los planetas', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f5_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilSistemaSolar, const {'sol': 'Sol', 'tierra': 'Tierra', 'marte': 'Marte', 'saturno': 'Saturno'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué es el Sol?',
                          opciones: ['Una estrella', 'Un planeta', 'Una luna'],
                          correcta: 0,
                          explicacion: 'Es la estrella más cercana a la Tierra.'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Conoces el Sistema Solar.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Características de los planetas',
      emoji: '🪐',
      color: _c2,
      intro: 'Cada planeta es diferente. ¡Descubre sus secretos!',
      mensajeFinal: '¡Conoces las características de los planetas!',
      pasos: [
        PasoBio(
            'Rocosos y gaseosos',
            TipoPasoBio.explicacion,
            'f5_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Planetas',
                  titulo: 'Rocosos y gaseosos',
                  color: _c2,
                  textoZati: 'Los planetas se dividen en dos grupos. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Planetas rocosos', Color(0xFF8D6E63), Icons.landscape_rounded, [
                      TarjetaInfo(Icons.public_rounded, 'Interiores', 'Mercurio, Venus, Tierra y Marte: pequeños, con superficie sólida.'),
                      TarjetaInfo(Icons.water_drop_rounded, 'La Tierra', 'Es el único con agua líquida en su superficie y vida.'),
                    ]),
                    GrupoTarjetas('Planetas gaseosos', Color(0xFF3949AB), Icons.cloud_rounded, [
                      TarjetaInfo(Icons.blur_circular_rounded, 'Gigantes', 'Júpiter, Saturno, Urano y Neptuno: enormes, de gases y hielo, sin suelo firme.'),
                      TarjetaInfo(Icons.radio_button_checked_rounded, 'Anillos', 'Los cuatro tienen anillos, aunque los de Saturno son los más vistosos.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.nightlight_rounded, 'Lunas', 'Saturno y Júpiter tienen decenas de lunas; la Tierra solo una.'),
                      TarjetaInfo(Icons.thermostat_rounded, 'Venus', 'Aunque Mercurio está más cerca del Sol, Venus es más caliente por sus nubes.'),
                      TarjetaInfo(Icons.star_rounded, 'Plutón', 'Desde 2006 se considera un planeta enano.'),
                    ]),
                  ],
                  mensajeFinal: '¡Cada planeta es único!',
                )),
        PasoBio(
            '¿Rocoso o gaseoso?',
            TipoPasoBio.laboratorio,
            'f5_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Rocoso o gaseoso?',
                  color: _c2,
                  instruccion: 'Arrastra cada planeta a su grupo.',
                  grupos: const [GrupoClasificar('Rocoso', '🪨', Color(0xFF8D6E63)), GrupoClasificar('Gaseoso', '☁️', Color(0xFF3949AB))],
                  items: const [
                    ItemClasificar('⚫', 'Mercurio', 0, 'Es rocoso y pequeño.'),
                    ItemClasificar('🟡', 'Venus', 0, 'Rocoso con nubes espesas.'),
                    ItemClasificar('🌍', 'Tierra', 0, 'Rocoso con agua.'),
                    ItemClasificar('🔴', 'Marte', 0, 'Rocoso y rojo.'),
                    ItemClasificar('🟠', 'Júpiter', 1, 'Gigante gaseoso.'),
                    ItemClasificar('🪐', 'Saturno', 1, 'Gigante gaseoso con anillos.'),
                    ItemClasificar('🔵', 'Urano', 1, 'Gigante de hielo.'),
                    ItemClasificar('🔷', 'Neptuno', 1, 'Gigante de hielo.'),
                  ],
                  mensajeFinal: 'Los rocosos están cerca del Sol y los gaseosos más lejos.',
                )),
        PasoBio(
            'Memorama planetario',
            TipoPasoBio.juego,
            'f5_m2_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama planetario',
                  color: _c2,
                  instruccion: 'Encuentra cada planeta con su característica.',
                  pares: const [
                    ('⚫', 'Mercurio', 'El más cercano al Sol'),
                    ('🟡', 'Venus', 'El más caliente'),
                    ('🔴', 'Marte', 'El planeta rojo'),
                    ('🟠', 'Júpiter', 'El más grande'),
                    ('🪐', 'Saturno', 'Anillos vistosos'),
                    ('🔷', 'Neptuno', 'El más lejano'),
                  ],
                  mensajeFinal: '¡Memoria de astronauta!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f5_m2_video',
            (a) =>
                video(a, clave: 'espacio_2', titulo: 'Video: los planetas', tema: 'características de los planetas', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f5_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuál es el planeta más grande?',
                          opciones: ['Júpiter', 'La Tierra', 'Marte'],
                          correcta: 0,
                          explicacion: 'Cabrían más de 1 300 Tierras.'),
                      PreguntaQuiz(
                          pregunta: '¿Por qué Marte se ve rojo?',
                          opciones: ['Su suelo tiene óxido de hierro', 'Está en llamas', 'Está cubierto de flores'],
                          correcta: 0,
                          explicacion: '¡Es como el óxido de un clavo!'),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Conoces las características de los planetas.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Los movimientos de la Tierra',
      emoji: '🌍',
      color: _c3,
      intro: '¿Por qué hay día y noche? ¿Por qué cambian las estaciones? ¡La Tierra se mueve!',
      mensajeFinal: '¡Entiendes los movimientos de la Tierra y la Luna!',
      pasos: [
        PasoBio(
            'Rotación y traslación',
            TipoPasoBio.explicacion,
            'f5_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Movimientos',
                  titulo: 'Rotación y traslación',
                  color: _c3,
                  il: ilMovimientos,
                  textos: const [
                    'La Tierra tiene dos movimientos principales: la rotación, cuando gira sobre sí misma, y la traslación, cuando da la vuelta alrededor del Sol.',
                    'La rotación produce el día y la noche. La traslación, junto con la inclinación de la Tierra, produce las estaciones del año: primavera, verano, otoño e invierno.',
                    'Una rotación dura casi 24 horas (un día) y una traslación dura 365 días y 6 horas (un año). Por eso cada 4 años hay un año bisiesto con un día extra: el 29 de febrero.',
                    'La Luna gira alrededor de la Tierra en unos 29 días. Según cómo la ilumina el Sol, la vemos en distintas fases: nueva, creciente, llena y menguante.',
                  ],
                  izquierda: const [
                    Parte('sol', 'El Sol', '(ilumina)', '☀️', Color(0xFFFF8F00), 'Ilumina la mitad de la Tierra: ahí es de día.'),
                  ],
                  derecha: const [
                    Parte('luna', 'La Luna', '(fases)', '🌙', Color(0xFF78909C), 'Gira alrededor de la Tierra en unos 29 días.'),
                  ],
                  resaltar: const {
                    3: {'luna'},
                  },
                  mensajeFinal: '¡Ahora ordena las fases de la Luna!',
                )),
        PasoBio(
            'Las fases de la Luna',
            TipoPasoBio.juego,
            'f5_m3_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Ordena',
                  titulo: 'Las fases de la Luna',
                  color: _c3,
                  instruccion: 'Ordena las fases de la Luna empezando por la luna nueva.',
                  ciclo: true,
                  pasos: const [
                    ('🌑', 'Luna nueva'),
                    ('🌓', 'Cuarto creciente'),
                    ('🌕', 'Luna llena'),
                    ('🌗', 'Cuarto menguante'),
                  ],
                  explicacion: 'Las fases se repiten cada 29 días aproximadamente.',
                  mensajeFinal: '¡Conoces las fases de la Luna!',
                )),
        PasoBio(
            '¿Rotación o traslación?',
            TipoPasoBio.laboratorio,
            'f5_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '3. Clasifica',
                  titulo: '¿Rotación o traslación?',
                  color: _c3,
                  instruccion: 'Arrastra cada efecto al movimiento que lo produce.',
                  grupos: const [GrupoClasificar('Rotación', '🔄', Color(0xFF1E88E5)), GrupoClasificar('Traslación', '☀️', Color(0xFF43A047))],
                  items: const [
                    ItemClasificar('🌗', 'El día y la noche', 0, 'La Tierra gira sobre sí misma.'),
                    ItemClasificar('🌅', 'El Sol "sale" por el este', 0, 'Es la Tierra la que gira.'),
                    ItemClasificar('⏰', 'Dura 24 horas', 0, 'Un día.'),
                    ItemClasificar('🍂', 'Las estaciones del año', 1, 'Con la inclinación de la Tierra.'),
                    ItemClasificar('🎂', 'Dura 365 días', 1, 'Un año.'),
                    ItemClasificar('📅', 'El año bisiesto', 1, 'Por las 6 horas extra de cada vuelta.'),
                  ],
                  mensajeFinal: '¡La Tierra nunca deja de moverse!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f5_m3_video',
            (a) => video(a,
                clave: 'espacio_3',
                titulo: 'Video: los movimientos de la Tierra',
                tema: 'rotación, traslación y fases de la Luna',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f5_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseRelacionar(const [
                      ('Rotación', 'La Tierra gira sobre sí misma.'),
                      ('Traslación', 'La Tierra gira alrededor del Sol.'),
                      ('Luna llena', 'Vemos la Luna completa iluminada.'),
                      ('Año bisiesto', 'Tiene 366 días.'),
                    ], color: _c3, instruccion: 'Relaciona cada concepto.'),
                  ],
                  mensajeFinal: 'Entiendes los movimientos de la Tierra.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'Viaje espacial',
      emoji: '🏆',
      color: Color(0xFF4527A0),
      intro: '¡Último desafío! Guía a la nave exploradora en su viaje por el Sistema Solar.',
      mensajeFinal: '¡La nave regresó a salvo con muchos descubrimientos!',
      pasos: [
        PasoBio(
            'Viaje espacial',
            TipoPasoBio.reto,
            'f5_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'Viaje espacial',
                  color: const Color(0xFF4527A0),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Primer destino',
                      narracion: 'La nave quiere visitar el planeta más cercano al Sol.',
                      emojis: '🚀☀️',
                      pregunta: '¿A cuál va?',
                      opciones: ['Mercurio', 'Neptuno', 'Júpiter'],
                      correcta: 0,
                      explicacion: 'Mercurio es el primero.',
                    ),
                    EscenaBio(
                      titulo: 'Los anillos',
                      narracion: 'Desde la ventana ven un planeta con enormes anillos brillantes.',
                      emojis: '🪐✨',
                      pregunta: '¿Qué planeta es?',
                      opciones: ['Saturno', 'Marte', 'Venus'],
                      correcta: 0,
                      explicacion: 'Sus anillos son de hielo y roca.',
                    ),
                    EscenaBio(
                      titulo: 'Aterrizaje',
                      narracion: 'Quieren aterrizar en un planeta, pero uno no tiene suelo firme.',
                      emojis: '🟠☁️',
                      pregunta: '¿En cuál NO se puede aterrizar?',
                      opciones: ['Júpiter, porque es gaseoso', 'Marte', 'Mercurio'],
                      correcta: 0,
                      explicacion: 'Los gigantes gaseosos no tienen superficie sólida.',
                    ),
                    EscenaBio(
                      titulo: 'De regreso',
                      narracion: 'Al volver, ven que en México es de noche mientras en China es de día.',
                      emojis: '🌍🌗',
                      pregunta: '¿Por qué?',
                      opciones: ['Por la rotación de la Tierra', 'Por la traslación', 'Porque se apagó el Sol'],
                      correcta: 0,
                      explicacion: 'El Sol ilumina solo la mitad de la Tierra.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro espacial',
            TipoPasoBio.reto,
            'f5_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF4527A0),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuántos planetas tiene el Sistema Solar?',
                          opciones: ['Ocho', 'Nueve', 'Cinco'],
                          correcta: 0,
                          explicacion: 'Plutón es un planeta enano.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué mantiene a los planetas en órbita?',
                          opciones: ['La gravedad del Sol', 'El viento solar', 'Los imanes'],
                          correcta: 0,
                          explicacion: '¡La gravedad en acción!'),
                      PreguntaQuiz(
                          pregunta: '¿Cuánto dura una traslación de la Tierra?',
                          opciones: ['Un año', 'Un día', 'Un mes'],
                          correcta: 0,
                          explicacion: '365 días y 6 horas.'),
                    ], color: const Color(0xFF4527A0), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Astronauta Explorador!',
                )),
      ],
    ),
  ],
);
