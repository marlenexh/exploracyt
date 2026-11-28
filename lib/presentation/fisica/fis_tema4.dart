import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/fabrica_ciencia.dart';
import 'fondos_fis.dart';
import '../electronica/circuito.dart';
import '../electronica/ele_tema1.dart' show abiertoYListo, pz, taller;
import '../electronica/taller.dart';
import 'ilustraciones_fis.dart';
import 'sims_fis.dart';

/// Física · Tema 4: La energía que nos rodea.

const _c1 = Color(0xFFF9A825);
const _c2 = Color(0xFF00838F);
const _c3 = Color(0xFF2E7D32);
const _ci = Color(0xFFF57F17);

final fisTema4 = TemaBio(
  numero: 4,
  mundo: 'fis',
  estilo: estiloFis(FondoFis.energia),
  titulo: 'La energía que nos rodea',
  saludo:
      'La luz de tu casa, la tele y el refrigerador funcionan con electricidad. ¡Vamos a descubrir de dónde viene, qué materiales la dejan pasar y cómo ahorrarla!',
  misionDelTema:
      'El recibo de luz de la familia de Zati llegó muy caro. Investiga la electricidad y conviértete en guardián de la energía para que su casa ahorre.',
  color: _ci,
  insignia: 'Guardián de la Energía',
  emojiInsignia: '⚡',
  emojisPanel: const ['💡', '🔋', '🔌', '☀️', '🌬️'],
  videos: const {
    'energia_1': 'assets/videos/energia_electricidad.mp4',
    'energia_2': 'assets/videos/energia_conductores.mp4',
    'energia_3': 'assets/videos/energia_ahorro.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'La electricidad',
      emoji: '💡',
      color: _c1,
      intro: '¿Cómo llega la electricidad hasta tu casa? ¡Síguela!',
      mensajeFinal: '¡Sabes qué es la electricidad!',
      pasos: [
        PasoBio(
            '¿Qué es la electricidad?',
            TipoPasoBio.explicacion,
            'f4_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Electricidad',
                  titulo: 'La electricidad',
                  color: _c1,
                  il: ilEnergia,
                  textos: const [
                    'La electricidad es una forma de energía producida por el movimiento de cargas eléctricas. Viaja por cables, como el agua por una tubería.',
                    'Con ella encendemos focos, cargamos celulares, enfriamos la comida en el refrigerador y hacemos funcionar máquinas y hospitales.',
                    'Se produce en centrales eléctricas con agua, viento, sol, vapor o combustibles. Llega por cables en torres hasta tu casa. Para que funcione un aparato se necesita un circuito cerrado: un camino completo.',
                    'Las pilas guardan energía química y la convierten en electricidad para juguetes, controles y linternas.',
                  ],
                  izquierda: const [
                    Parte('central', 'Central eléctrica', '(produce)', '🏭', Color(0xFF6D4C41), 'Ahí se produce la electricidad.'),
                    Parte('solar', 'Energía solar', '(del Sol)', '☀️', Color(0xFFFFB300), 'Los paneles convierten la luz en electricidad.'),
                    Parte('eolica', 'Energía eólica', '(del viento)', '🌬️', Color(0xFF26A69A), 'El viento mueve aerogeneradores.'),
                  ],
                  derecha: const [
                    Parte('torre', 'Torres y cables', '(transportan)', '🗼', Color(0xFF546E7A), 'Llevan la electricidad muy lejos.'),
                    Parte('casa', 'Tu casa', '(la usa)', '🏠', Color(0xFFE64A19), 'Llega a los contactos y apagadores.'),
                    Parte('foco', 'Foco', '(luz)', '💡', Color(0xFFFBC02D), 'Transforma la electricidad en luz.'),
                  ],
                  resaltar: const {
                    2: {'central', 'torre', 'casa'},
                  },
                  mensajeFinal: '¡Ahora arma tu propio circuito!',
                )),
        PasoBio(
            'Tu primer circuito',
            TipoPasoBio.simulacion,
            'f4_m1_taller',
            (a) => taller(
                  a,
                  seccion: 'Simulación',
                  titulo: 'Tu primer circuito',
                  color: _c1,
                  mensajeFinal: 'Un circuito cerrado deja pasar la corriente y enciende el foco.',
                  retos: [
                    RetoCircuito(
                      titulo: 'Enciende el foco',
                      instruccion: 'Une la pila, el interruptor y el foco en un solo camino. Simula y toca el interruptor para encender y apagar.',
                      piezas: () => [pz('pila', TipoPieza.pila3v, 100, 230), pz('sw', TipoPieza.interruptor, 300, 100), pz('foco', TipoPieza.foco, 480, 200)],
                      condiciones: [
                        Condicion('El foco enciende con el circuito cerrado', (e) => e.luzFoco('foco') > 0.3 && e.piezas['sw']!.cerrado),
                        Condicion('El foco se apaga con el circuito abierto', (e) => abiertoYListo(e, 'sw')),
                      ],
                      logro: 'La corriente solo circula si el camino está completo.',
                    ),
                  ],
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f4_m1_video',
            (a) => video(a,
                clave: 'energia_1',
                titulo: 'Video: la electricidad',
                tema: 'cómo se produce y llega la electricidad',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f4_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilEnergia, const {'central': 'Central eléctrica', 'torre': 'Torres y cables', 'casa': 'Casa', 'solar': 'Energía solar'},
                        color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Qué necesita un foco para encender?',
                        opciones: ['Un circuito cerrado con una fuente de energía', 'Solo un cable suelto', 'Estar cerca de un imán'],
                        correcta: 0,
                        explicacion: 'La corriente necesita un camino completo.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes qué es la electricidad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Conductores y aislantes',
      emoji: '🔌',
      color: _c2,
      intro: 'Algunos materiales dejan pasar la electricidad y otros no. ¡Ponlos a prueba!',
      mensajeFinal: '¡Distingues conductores y aislantes!',
      pasos: [
        PasoBio(
            'Probador de materiales',
            TipoPasoBio.laboratorio,
            'f4_m2_lab',
            (a) => lab(
                  a,
                  titulo: '¿Enciende el foco?',
                  color: _c2,
                  instruccion: 'Pon cada objeto en el hueco del circuito. Observa si el foco enciende y decide si es conductor. Toca cada “?”.',
                  pruebas: const [
                    Prueba('Ponerlo en el circuito', '💡', 'Enciende', 'No enciende'),
                    Prueba('El material es…', '🔍', 'Conductor', 'Aislante'),
                  ],
                  muestras: const [
                    Muestra('Clip', '📎', [true, true], datos: ['¡El foco enciende!', 'Los metales conducen la electricidad.']),
                    Muestra('Moneda', '🪙', [true, true], datos: ['¡Enciende!', 'Es de metal.']),
                    Muestra('Papel aluminio', '🥫', [true, true], datos: ['¡Enciende!', 'El aluminio es buen conductor.']),
                    Muestra('Lápiz de madera', '✏️', [false, false], datos: ['No enciende.', 'La madera es aislante.']),
                    Muestra('Goma', '🧽', [false, false], datos: ['No enciende.', 'El hule es aislante.']),
                    Muestra('Popote de plástico', '🥤', [false, false], datos: ['No enciende.', 'El plástico es aislante.']),
                  ],
                  pregunta: const PreguntaQuiz(
                    pregunta: '¿Por qué los cables tienen cobre por dentro y plástico por fuera?',
                    opciones: ['El cobre conduce la electricidad y el plástico nos protege', 'Para que se vean bonitos', 'El plástico conduce mejor'],
                    correcta: 0,
                    explicacion: 'El plástico es aislante y evita descargas.',
                  ),
                  mensajeFinal: 'Los metales son conductores; el plástico, la madera y el hule son aislantes.',
                )),
        PasoBio(
            '¿Conductor o aislante?',
            TipoPasoBio.juego,
            'f4_m2_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Conductor o aislante?',
                  color: _c2,
                  instruccion: 'Arrastra cada objeto a su grupo.',
                  grupos: const [GrupoClasificar('Conductor', '⚡', Color(0xFFF9A825)), GrupoClasificar('Aislante', '🛡️', Color(0xFF78909C))],
                  items: const [
                    ItemClasificar('🔑', 'Llave de metal', 0, 'Los metales conducen.'),
                    ItemClasificar('🥄', 'Cuchara de acero', 0, 'El acero conduce.'),
                    ItemClasificar('💧', 'Agua de la llave', 0, 'Tiene sales que conducen: ¡nunca toques aparatos con las manos mojadas!'),
                    ItemClasificar('🧤', 'Guantes de hule', 1, 'Los usan los electricistas.'),
                    ItemClasificar('🪵', 'Tabla de madera seca', 1, 'No deja pasar la corriente.'),
                    ItemClasificar('🧵', 'Hilo de lana', 1, 'Es aislante.'),
                  ],
                  mensajeFinal: '¡Ya los distingues!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f4_m2_video',
            (a) => video(a,
                clave: 'energia_2',
                titulo: 'Video: conductores y aislantes',
                tema: 'materiales que conducen la electricidad',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f4_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseAcciones(
                        'Seguridad eléctrica',
                        'Toca las acciones seguras y presiona “Comprobar”.',
                        const [
                          Accion(Icons.back_hand_rounded, 'Secarme las manos antes de conectar un aparato', true, 'El agua conduce la electricidad.'),
                          Accion(Icons.power_rounded, 'Desconectar jalando la clavija, no el cable', true, 'Así no se dañan los cables.'),
                          Accion(Icons.toys_rounded, 'Volar papalotes lejos de los cables de luz', true, 'Evitas accidentes.'),
                          Accion(Icons.dangerous_rounded, 'Meter objetos de metal en el contacto', false, '¡Es muy peligroso!'),
                          Accion(Icons.electrical_services_rounded, 'Conectar muchos aparatos en un solo contacto', false, 'Se puede sobrecalentar.'),
                        ],
                        color: _c2),
                  ],
                  mensajeFinal: 'Usas la electricidad con seguridad.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Uso responsable de la energía',
      emoji: '🌱',
      color: _c3,
      intro: 'La energía no es infinita. ¡Aprende a ahorrarla y cuidar el planeta!',
      mensajeFinal: '¡Cuidas muy bien la energía!',
      pasos: [
        PasoBio(
            'Fuentes de energía',
            TipoPasoBio.explicacion,
            'f4_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Fuentes',
                  titulo: 'Fuentes de energía',
                  color: _c3,
                  textoZati: 'La electricidad se produce de distintas fuentes. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Renovables', Color(0xFF43A047), Icons.eco_rounded, [
                      TarjetaInfo(Icons.wb_sunny_rounded, 'Solar', 'Paneles que transforman la luz del Sol en electricidad.'),
                      TarjetaInfo(Icons.air_rounded, 'Eólica', 'Aerogeneradores que gira el viento, como los de Oaxaca.'),
                      TarjetaInfo(Icons.water_rounded, 'Hidroeléctrica', 'Presas donde el agua mueve turbinas.'),
                    ]),
                    GrupoTarjetas('No renovables', Color(0xFF6D4C41), Icons.local_gas_station_rounded, [
                      TarjetaInfo(Icons.oil_barrel_rounded, 'Petróleo y gas', 'Se acaban y contaminan el aire al quemarse.'),
                      TarjetaInfo(Icons.landscape_rounded, 'Carbón', 'Produce mucho humo y gases.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.volcano_rounded, 'Cerro Prieto',
                          'En Baja California hay una de las centrales geotérmicas más grandes del mundo: usa el calor del interior de la Tierra.'),
                      TarjetaInfo(Icons.light_rounded, 'Focos LED', 'Gastan hasta 80 % menos energía que los focos antiguos.'),
                    ]),
                  ],
                  mensajeFinal: '¡Las energías renovables cuidan el planeta!',
                )),
        PasoBio('La casa que ahorra', TipoPasoBio.simulacion, 'f4_m3_sim', (a) => SimAhorro(actividad: a, color: _c3)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'f4_m3_video',
            (a) => video(a,
                clave: 'energia_3', titulo: 'Video: ahorra energía', tema: 'el uso responsable de la energía', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'f4_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'Ahorra energía',
                        'Toca las acciones que ahorran energía y presiona “Comprobar”.',
                        const [
                          Accion(Icons.lightbulb_outline_rounded, 'Apagar la luz al salir de un cuarto', true, 'No gastas sin usarla.'),
                          Accion(Icons.wb_sunny_rounded, 'Aprovechar la luz del Sol de día', true, 'Es gratis.'),
                          Accion(Icons.power_off_rounded, 'Desconectar el cargador cuando no se usa', true, 'Aun sin celular gasta un poco.'),
                          Accion(Icons.kitchen_rounded, 'Dejar el refrigerador abierto mientras decides', false, 'Gasta mucha energía al volver a enfriar.'),
                          Accion(Icons.tv_rounded, 'Dormir con la tele encendida', false, 'Gasta energía sin que nadie la vea.'),
                        ],
                        color: _c3),
                  ],
                  mensajeFinal: 'Usas la energía de forma responsable.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El recibo de luz',
      emoji: '🏆',
      color: Color(0xFFE65100),
      intro: '¡Último desafío! Ayuda a la familia de Zati a pagar menos de luz.',
      mensajeFinal: '¡La familia ahorra energía y dinero!',
      pasos: [
        PasoBio(
            'El recibo de luz',
            TipoPasoBio.reto,
            'f4_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El recibo de luz',
                  color: const Color(0xFFE65100),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Los focos',
                      narracion: 'En casa tienen focos antiguos que se calientan mucho.',
                      emojis: '💡🔥',
                      pregunta: '¿Qué conviene hacer?',
                      opciones: ['Cambiarlos por focos LED', 'Dejarlos siempre prendidos', 'Poner más focos'],
                      correcta: 0,
                      explicacion: 'Los LED gastan mucho menos.',
                    ),
                    EscenaBio(
                      titulo: 'El cable pelado',
                      narracion: 'La plancha tiene el cable roto y se ve el cobre.',
                      emojis: '🔌⚠️',
                      pregunta: '¿Qué hacen?',
                      opciones: ['No usarla y pedir a un adulto que la repare', 'Tocar el cobre para ver si funciona', 'Mojarlo'],
                      correcta: 0,
                      explicacion: 'Sin el aislante, puedes recibir una descarga.',
                    ),
                    EscenaBio(
                      titulo: 'El techo',
                      narracion: 'Quieren producir su propia electricidad limpia.',
                      emojis: '🏠☀️',
                      pregunta: '¿Qué pueden instalar?',
                      opciones: ['Paneles solares', 'Una chimenea de carbón', 'Un imán gigante'],
                      correcta: 0,
                      explicacion: 'Es energía renovable.',
                    ),
                  ],
                  mensajeFinal: '¡Misión cumplida!',
                )),
        PasoBio(
            'Supercerebro de la energía',
            TipoPasoBio.reto,
            'f4_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFFE65100),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Cuál es un buen conductor de electricidad?',
                          opciones: ['El cobre', 'El plástico', 'La madera'],
                          correcta: 0,
                          explicacion: 'Por eso los cables son de cobre.'),
                      PreguntaQuiz(
                          pregunta: '¿Cuál es una fuente renovable?',
                          opciones: ['El viento', 'El petróleo', 'El carbón'],
                          correcta: 0,
                          explicacion: 'No se acaba.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué pasa si el circuito está abierto?',
                          opciones: ['No pasa la corriente', 'El foco brilla más', 'Se carga la pila'],
                          correcta: 0,
                          explicacion: 'Falta un camino completo.'),
                    ], color: const Color(0xFFE65100), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Guardián de la Energía»!',
                )),
      ],
    ),
  ],
);
