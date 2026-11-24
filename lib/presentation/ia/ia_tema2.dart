import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_ia.dart';
import 'ilustraciones_ia.dart';
import 'sims_ia.dart';

/// Inteligencia Artificial · Tema 2: Encuentra el patrón.

const _c1 = Color(0xFFF57C00);
const _c2 = Color(0xFF00897B);
const _c3 = Color(0xFF1E88E5);
const _ci = Color(0xFFEF6C00);

final iaTema2 = TemaBio(
  numero: 2,
  mundo: 'ia',
  estilo: estiloIA(FondoIA.patrones),
  titulo: 'Encuentra el patrón',
  saludo:
      'Reconoces a tu mejor amigo aunque lleve gorra o lentes. ¡Tu cerebro es experto en encontrar patrones! Vamos a descubrir cómo observamos características, semejanzas y patrones… y cómo lo hacen las máquinas.',
  misionDelTema:
      'El museo de la ciudad perdió las fichas de sus colecciones. Usa tu ojo de detective para encontrar características, semejanzas y patrones, y enséñale a la computadora del museo a reconocerlos.',
  color: _ci,
  insignia: 'Detective de Patrones',
  emojiInsignia: '🔍',
  emojisPanel: const ['🔺', '🔵', '🔍', '🧩', '🖼️'],
  videos: const {
    'patrones_1': 'assets/videos/patrones_caracteristicas.mp4',
    'patrones_2': 'assets/videos/patrones_secuencias.mp4',
    'patrones_3': 'assets/videos/patrones_maquinas.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Características y semejanzas',
      emoji: '🔺',
      color: _c1,
      intro: 'Para comparar cosas hay que fijarse en sus características.',
      mensajeFinal: '¡Comparas como un detective!',
      pasos: [
        PasoBio(
            'Características',
            TipoPasoBio.explicacion,
            'i2_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Rasgos',
                  titulo: 'Características y semejanzas',
                  color: _c1,
                  il: ilPatrones,
                  textos: const [
                    'Una característica (o rasgo) es algo que podemos observar o medir de un objeto: su forma, su color, su tamaño, su textura, el sonido que hace…',
                    'Las características nos sirven para comparar: encontrar semejanzas (en qué se parecen) y diferencias (en qué no se parecen), y así agrupar las cosas.',
                    'Para agrupar, elegimos una característica y juntamos lo que la comparte: todos los rojos, todos los redondos… Las computadoras hacen lo mismo con números: miden rasgos y los comparan.',
                    'Clasificamos todo el tiempo: la ropa por colores, los útiles por tipo, los animales por cómo se cubre su cuerpo.',
                  ],
                  izquierda: const [
                    Parte('forma', 'Forma', '(redondo, cuadrado…)', '🔺', Color(0xFFE53935), 'Su figura o contorno.'),
                    Parte('tamano', 'Tamaño', '(grande, chico…)', '📏', Color(0xFF6D4C41), 'Qué tan grande es.'),
                  ],
                  derecha: const [
                    Parte('color', 'Color', '(rojo, azul…)', '🎨', Color(0xFF1E88E5), 'Cómo se ve con la luz.'),
                    Parte('textura', 'Textura', '(liso, rugoso…)', '🧶', Color(0xFF8E24AA), 'Cómo se siente al tocarlo.'),
                    Parte('lupa', 'Observar', '(comparar)', '🔍', Color(0xFFF57C00), 'Buscar semejanzas y diferencias.'),
                  ],
                  resaltar: const {
                    1: {'lupa'},
                    2: {'forma', 'color'},
                  },
                  mensajeFinal: '¡Ahora agrupa por características!',
                )),
        PasoBio(
            'Agrupa por forma',
            TipoPasoBio.juego,
            'i2_m1_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Redondo o con esquinas?',
                  color: _c1,
                  instruccion: 'Fíjate solo en la FORMA (no en el color) y arrastra cada objeto a su grupo.',
                  grupos: const [GrupoClasificar('Redondo', '⚪', Color(0xFFF57C00)), GrupoClasificar('Con esquinas', '🟥', Color(0xFF5E35B1))],
                  items: const [
                    ItemClasificar('⚽', 'Balón', 0, 'Es redondo.'),
                    ItemClasificar('🍊', 'Naranja', 0, 'Es redonda.'),
                    ItemClasificar('🪙', 'Moneda', 0, 'Es redonda.'),
                    ItemClasificar('📦', 'Caja', 1, 'Tiene esquinas.'),
                    ItemClasificar('📘', 'Libro', 1, 'Tiene esquinas.'),
                    ItemClasificar('🧀', 'Queso', 1, 'Tiene forma de triángulo.'),
                  ],
                  mensajeFinal: 'Elegiste una característica (la forma) y agrupaste: ¡así clasifica una IA!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i2_m1_video',
            (a) => video(a,
                clave: 'patrones_1',
                titulo: 'Video: características y semejanzas',
                tema: 'observar, comparar y agrupar',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i2_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué tienen en común 🍌, 🌻 y 🐥?',
                          opciones: ['Son amarillos', 'Son frutas', 'Vuelan'],
                          correcta: 0,
                          explicacion: 'Su semejanza es el color.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué es una característica?',
                          opciones: ['Algo que podemos observar o medir de un objeto', 'El nombre del dueño', 'El precio'],
                          correcta: 0,
                          explicacion: 'Forma, color, tamaño, textura…'),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes comparar por características.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Secuencias y patrones',
      emoji: '🧩',
      color: _c2,
      intro: 'Un patrón es algo que se repite o que sigue una regla. ¡Encuéntralos!',
      mensajeFinal: '¡Eres detective de patrones!',
      pasos: [
        PasoBio('Detective de patrones', TipoPasoBio.simulacion, 'i2_m2_sim', (a) => SimPatrones(actividad: a, color: _c2)),
        PasoBio(
            '¿Sabías que…?',
            TipoPasoBio.explicacion,
            'i2_m2_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '2. Datos curiosos',
                  titulo: 'Patrones por todas partes',
                  color: _c2,
                  textoZati: 'Los patrones están en la naturaleza, en tu cuerpo y en las máquinas. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.psychology_rounded, 'Tu cerebro',
                          'Está especialmente preparado para reconocer patrones: así reconoces caras aunque lleven lentes o bufanda.'),
                      TarjetaInfo(Icons.fingerprint_rounded, 'Huellas digitales',
                          'Cada persona tiene un patrón de huellas único; los celulares lo reconocen para desbloquearse.'),
                      TarjetaInfo(Icons.directions_car_rounded, 'Lectores de placas',
                          'Una IA lee los números de las placas de los coches reconociendo el patrón de cada letra.'),
                      TarjetaInfo(Icons.hive_rounded, 'Las abejas', 'Construyen panales con un patrón de hexágonos que se repite.'),
                    ]),
                  ],
                  mensajeFinal: '¡Los patrones están en todas partes!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i2_m2_video',
            (a) => video(a,
                clave: 'patrones_2',
                titulo: 'Video: secuencias y patrones',
                tema: 'qué es un patrón y cómo encontrarlo',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i2_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué sigue? 🟡 🟣 🟣 🟡 🟣 🟣 🟡 …',
                          opciones: ['🟣', '🟡', '🔴'],
                          correcta: 0,
                          explicacion: 'Se repite: amarillo, morado, morado.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué número sigue? 5, 10, 15, 20, …', opciones: ['25', '21', '30'], correcta: 0, explicacion: 'Se suma 5 cada vez.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál no pertenece? 🍎 🍌 🥕 🍇', opciones: ['🥕', '🍌', '🍇'], correcta: 0, explicacion: 'La zanahoria es verdura.'),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Encuentras patrones.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Las máquinas reconocen patrones',
      emoji: '🖼️',
      color: _c3,
      intro: '¿Cómo “ve” una computadora una imagen? ¡En números!',
      mensajeFinal: '¡Sabes cómo reconoce patrones una máquina!',
      pasos: [
        PasoBio(
            'Así ve una computadora',
            TipoPasoBio.explicacion,
            'i2_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Pixeles',
                  titulo: 'Así ve una computadora',
                  color: _c3,
                  il: ilPixeles,
                  textos: const [
                    'Para una computadora, una foto es una cuadrícula de muchísimos cuadritos llamados pixeles. Cada pixel es un número que dice qué color tiene.',
                    'Con esos números, una IA puede reconocer rostros, leer letras escritas a mano, encontrar enfermedades en radiografías o vigilar bosques desde satélites.',
                    'La IA busca patrones en los números: bordes, formas y colores que se repiten. Compara lo que ve con los patrones que aprendió y elige el más parecido.',
                    'Para nosotros reconocer a un amigo es fácil; para una computadora es muy difícil: si cambia la luz o la persona se pone lentes, ¡los números cambian!',
                  ],
                  izquierda: const [
                    Parte('foto', 'Imagen', '(lo que vemos)', '🐱', Color(0xFFF57C00), 'Una foto de un gato.'),
                    Parte('camara', 'Cámara', '(captura)', '📸', Color(0xFF546E7A), 'Convierte la luz en números.'),
                  ],
                  derecha: const [
                    Parte('computadora', 'Computadora', '(busca patrones)', '💻', Color(0xFF1E88E5), 'Compara los números con lo que aprendió.'),
                  ],
                  resaltar: const {
                    0: {'foto', 'camara'},
                    2: {'computadora'},
                  },
                  mensajeFinal: '¡Ahora dibuja con pixeles!',
                )),
        PasoBio('La máquina reconoce figuras', TipoPasoBio.simulacion, 'i2_m3_sim', (a) => SimPixeles(actividad: a, color: _c3)),
        PasoBio(
            'Memorama de patrones',
            TipoPasoBio.juego,
            'i2_m3_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama de patrones',
                  color: _c3,
                  instruccion: 'Encuentra cada pareja.',
                  pares: const [
                    ('🔍', 'Característica', 'Rasgo que se observa'),
                    ('🧩', 'Patrón', 'Algo que se repite'),
                    ('🟦', 'Pixel', 'Cuadrito de una imagen'),
                    ('👯', 'Semejanza', 'En qué se parecen'),
                    ('🔀', 'Diferencia', 'En qué no se parecen'),
                    ('🗂️', 'Agrupar', 'Juntar lo parecido'),
                  ],
                  mensajeFinal: '¡Memoria de detective!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'i2_m3_video',
            (a) => video(a,
                clave: 'patrones_3', titulo: 'Video: las máquinas ven', tema: 'pixeles y reconocimiento de patrones', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'i2_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué es un pixel?',
                          opciones: ['Un cuadrito de una imagen digital', 'Un tipo de robot', 'Una cámara'],
                          correcta: 0,
                          explicacion: 'Las imágenes están hechas de pixeles.'),
                      PreguntaQuiz(
                          pregunta: '¿Cómo reconoce una IA una figura?',
                          opciones: ['La compara con los patrones que aprendió', 'La adivina sin datos', 'Le pregunta a una persona'],
                          correcta: 0,
                          explicacion: 'Elige el patrón más parecido.'),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Sabes cómo ven las máquinas.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El museo de los patrones',
      emoji: '🏆',
      color: Color(0xFFBF360C),
      intro: '¡Último desafío! Ayuda al museo a ordenar sus colecciones.',
      mensajeFinal: '¡El museo quedó ordenado!',
      pasos: [
        PasoBio(
            'El museo de los patrones',
            TipoPasoBio.reto,
            'i2_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El museo de los patrones',
                  color: const Color(0xFFBF360C),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Las vasijas',
                      narracion: 'Hay vasijas antiguas con dibujos de grecas que se repiten.',
                      emojis: '🏺🔁',
                      pregunta: '¿Qué forman los dibujos que se repiten?',
                      opciones: ['Un patrón', 'Un error', 'Un pixel'],
                      correcta: 0,
                      explicacion: 'Las grecas mexicanas son patrones.',
                    ),
                    EscenaBio(
                      titulo: 'La colección de minerales',
                      narracion: 'Hay que separar las piedras en vitrinas.',
                      emojis: '💎🪨',
                      pregunta: '¿Qué conviene hacer primero?',
                      opciones: ['Elegir una característica, como el color o el brillo', 'Ponerlas al azar', 'Tirar las feas'],
                      correcta: 0,
                      explicacion: 'Agrupar es juntar lo que comparte una característica.',
                    ),
                    EscenaBio(
                      titulo: 'La cámara del museo',
                      narracion: 'La computadora del museo reconoce las pinturas con su cámara.',
                      emojis: '📸🖼️',
                      pregunta: '¿Qué ve la computadora en realidad?',
                      opciones: ['Números de los pixeles', 'Colores como nosotros', 'Nada'],
                      correcta: 0,
                      explicacion: 'Cada pixel es un número.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro de patrones',
            TipoPasoBio.reto,
            'i2_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFFBF360C),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué sigue? 🔺 🔺 🟦 🔺 🔺 🟦 🔺 …',
                          opciones: ['🔺', '🟦', '🟢'],
                          correcta: 0,
                          explicacion: 'Dos triángulos y un cuadro.'),
                      PreguntaQuiz(
                          pregunta: '¿Por qué a una computadora le cuesta reconocer a alguien con lentes?',
                          opciones: ['Porque cambian los números de los pixeles', 'Porque no le gustan los lentes', 'Porque se apaga'],
                          correcta: 0,
                          explicacion: 'Para la máquina, la imagen es diferente.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué es una semejanza?',
                          opciones: ['En qué se parecen dos cosas', 'En qué son diferentes', 'Su precio'],
                          correcta: 0,
                          explicacion: 'Comparar es buscar semejanzas y diferencias.'),
                    ], color: const Color(0xFFBF360C), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Eres un Detective de Patrones!',
                )),
      ],
    ),
  ],
);
