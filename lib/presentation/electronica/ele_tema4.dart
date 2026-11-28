import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'circuito.dart';
import 'ele_tema1.dart' show pz, taller;
import 'fondos.dart';
import 'ilustraciones_ele.dart';
import 'sims_ele.dart';
import 'taller.dart';

/// Electrónica · Tema 4: Máquinas en movimiento.

const _c1 = Color(0xFFF4511E);
const _c2 = Color(0xFF00897B);
const _c3 = Color(0xFF5C6BC0);
const _ci = Color(0xFF546E7A);

final eleTema4 = TemaBio(
  numero: 4,
  mundo: 'ele',
  estilo: estiloEle(FondoEle.fabrica),
  titulo: 'Máquinas en movimiento',
  saludo: 'Ventiladores, licuadoras, carritos y robots… ¡todos se mueven gracias a motores y mecanismos! Vamos a descubrir cómo la electricidad se convierte en movimiento.',
  misionDelTema: 'La fábrica de juguetes de la ciudad se detuvo. Aprende cómo funcionan los motores y los mecanismos para echar a andar de nuevo sus máquinas.',
  color: _ci,
  insignia: 'Ingeniero en Movimiento',
  emojiInsignia: '⚙️',
  emojisPanel: const ['🌀', '🚗', '🤖', '🔩', '🏭'],
  videos: const {
    'maquinas_1': 'assets/videos/maquinas_motor.mp4',
    'maquinas_2': 'assets/videos/maquinas_mecanismos.mp4',
    'maquinas_3': 'assets/videos/maquinas_aparatos.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'El motor eléctrico',
      emoji: '🌀',
      color: _c1,
      intro: 'El corazón de cada máquina de la fábrica es un motor. ¡Descubre qué tiene por dentro y cómo controlarlo!',
      mensajeFinal: '¡Sabes encender, invertir y controlar un motor!',
      pasos: [
        PasoBio('¿Cómo funciona un motor?', TipoPasoBio.explicacion, 'e4_m1_exp', (a) => explicacion(
              a,
              seccion: '1. El motor',
              titulo: 'El motor eléctrico',
              color: _c1,
              il: ilMotorPartes,
              textos: const [
                'Un motor eléctrico es una máquina que convierte la energía eléctrica en movimiento. El motor de corriente directa (CD) es el que usan los juguetes y el que encuentras en Tinkercad.',
                'Hace girar ruedas, aspas y engranes. Es la pieza que da movimiento a ventiladores, licuadoras, carritos, drones y robots.',
                'Por dentro tiene imanes y una bobina de alambre de cobre. Cuando pasa la corriente, la bobina se vuelve un imán que es empujado por los otros imanes: ¡y gira! Las escobillas le llevan la corriente al eje que gira.',
                'Si inviertes los cables de la pila, el motor gira al revés. Así un carrito a control remoto puede ir hacia adelante o hacia atrás.',
              ],
              izquierda: const [
                Parte('iman', 'Imanes', '(norte y sur)', '🧲', Color(0xFFE53935), 'Están fijos en la carcasa y empujan a la bobina.'),
                Parte('bobina', 'Bobina', '(alambre enrollado)', '🌀', Color(0xFFB87333), 'Al pasar corriente se convierte en un electroimán y gira.'),
              ],
              derecha: const [
                Parte('escobillas', 'Escobillas', '(llevan la corriente)', '🪮', Color(0xFF424242), 'Tocan la parte que gira para que la corriente llegue a la bobina.'),
                Parte('eje', 'Eje', '(lo que gira)', '⚙️', Color(0xFFFFB300), 'Sale del motor; ahí se pone una rueda, una hélice o un engrane.'),
              ],
              resaltar: const {
                2: {'iman', 'bobina', 'escobillas'},
                3: {'eje'},
              },
              mensajeFinal: '¡Ahora conecta motores en la simulación!',
            )),
        PasoBio('Controla el motor', TipoPasoBio.simulacion, 'e4_m1_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: 'Controla el motor',
              color: _c1,
              mensajeFinal: '¡Encendiste un motor, cambiaste su sentido de giro y controlaste su velocidad!',
              retos: [
                RetoCircuito(
                  titulo: 'Enciende el motor',
                  instruccion: 'Conecta la pila, el interruptor y el motor en un solo camino. Simula y enciende el interruptor.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 90, 240), pz('sw', TipoPieza.interruptor, 290, 100), pz('m', TipoPieza.motor, 470, 200)],
                  condiciones: [Condicion('El motor gira con el interruptor', (e) => e.gira('m') && e.piezas['sw']!.cerrado)],
                  logro: 'El motor convirtió la electricidad en movimiento.',
                ),
                RetoCircuito(
                  titulo: 'Cambia el sentido',
                  instruccion: 'Conecta el motor a la pila y simula. Luego detén la simulación, invierte los cables (quita y vuelve a conectar al revés) y simula otra vez.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 140, 240), pz('m', TipoPieza.motor, 420, 190)],
                  condiciones: [
                    Condicion('Gira en un sentido ↻', (e) => e.velocidad('m') > 0.1),
                    Condicion('Gira en el sentido contrario ↺', (e) => e.velocidad('m') < -0.1),
                  ],
                  logro: 'Al invertir el + y el −, la corriente cambia de sentido y el motor también.',
                ),
                RetoCircuito(
                  titulo: 'Control de velocidad',
                  instruccion: 'Usa el potenciómetro: conecta una orilla y la pata central (limpiador) entre la pila y el motor. Simula y gira la perilla 🎛️.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 90, 240), pz('pot', TipoPieza.potenciometro, 290, 130, ohms: 300, pot: 0.5), pz('m', TipoPieza.motor, 480, 210)],
                  condiciones: [
                    Condicion('El motor gira rápido', (e) => e.velocidad('m').abs() > 0.8),
                    Condicion('El motor gira lento', (e) => e.velocidad('m').abs() > 0.08 && e.velocidad('m').abs() < 0.35),
                  ],
                  logro: 'El potenciómetro cambia la resistencia: más resistencia, menos corriente y menos velocidad.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e4_m1_video', (a) => video(a,
            clave: 'maquinas_1', titulo: 'Video: el motor eléctrico', tema: 'cómo la electricidad se convierte en movimiento', siguiente: '¡Ordena cómo gira un motor!')),
        PasoBio('¿Cómo gira un motor?', TipoPasoBio.juego, 'e4_m1_ord', (a) => ordenar(
              a,
              seccion: '2. Paso a paso',
              titulo: '¿Cómo gira un motor?',
              color: _c1,
              instruccion: 'Ordena lo que pasa dentro del motor desde que cierras el interruptor.',
              pasos: const [
                ('🎚️', 'Cierras el interruptor'),
                ('⚡', 'La corriente llega a la bobina'),
                ('🧲', 'La bobina se vuelve imán'),
                ('↔️', 'Los imanes la empujan'),
                ('🌀', 'El eje gira'),
              ],
              explicacion: 'La energía eléctrica se transforma en energía de movimiento.',
              mensajeFinal: '¡Entiendes el corazón de las máquinas!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e4_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilMotorPartes, const {'iman': 'Imán', 'bobina': 'Bobina', 'escobillas': 'Escobillas', 'eje': 'Eje'}, color: _c1),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué energía transforma un motor eléctrico?',
                    opciones: ['Energía eléctrica en movimiento', 'Luz en sonido', 'Calor en agua'],
                    correcta: 0,
                    explicacion: 'Por eso hace girar ruedas y aspas.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Cómo haces que un motor gire al revés?',
                    opciones: ['Invirtiendo los cables de la pila', 'Pintándolo', 'Poniéndolo de cabeza'],
                    correcta: 0,
                    explicacion: 'La corriente cambia de sentido.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Conoces las partes del motor y cómo controlarlo.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Mecanismos',
      emoji: '⚙️',
      color: _c2,
      intro: 'El motor gira, pero las máquinas necesitan más fuerza, más velocidad u otro tipo de movimiento. ¡Para eso están los mecanismos!',
      mensajeFinal: '¡Dominas los engranes y los mecanismos!',
      pasos: [
        PasoBio('Los mecanismos', TipoPasoBio.explicacion, 'e4_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Mecanismos',
              titulo: 'Los mecanismos',
              color: _c2,
              il: ilMecanismos,
              textos: const [
                'Un mecanismo es un conjunto de piezas que transmite o transforma el movimiento. Por ejemplo, lleva el giro del motor a las ruedas de un carrito.',
                'Sirven para cambiar la velocidad, la fuerza o la dirección del movimiento, o para convertir un giro en un movimiento de ida y vuelta.',
                'Los engranes son ruedas con dientes que se empujan entre sí. Las poleas se unen con una banda. La rueda y el eje hacen rodar. La biela y la manivela convierten el giro en un movimiento de ida y vuelta, como el de un pistón.',
                'La bicicleta usa engranes y cadena; los relojes de manecillas, engranes; los elevadores, poleas; y las máquinas de coser, biela y manivela.',
              ],
              izquierda: const [
                Parte('engranes', 'Engranes', '(ruedas con dientes)', '⚙️', Color(0xFFFFB300), 'Uno empuja al otro. Si son de distinto tamaño, cambian la velocidad.'),
                Parte('poleas', 'Poleas', '(con banda)', '🛞', Color(0xFF607D8B), 'Pasan el giro de una rueda a otra que está lejos.'),
              ],
              derecha: const [
                Parte('rueda', 'Rueda y eje', '(hacen rodar)', '🚗', Color(0xFFE53935), 'El eje gira y las ruedas mueven al vehículo.'),
                Parte('biela', 'Biela y manivela', '(ida y vuelta)', '↔️', Color(0xFF7E57C2), 'Convierte un giro en un movimiento recto de ida y vuelta.'),
              ],
              resaltar: const {
                1: {'engranes', 'poleas'},
                2: {'biela'},
              },
              mensajeFinal: '¡Ahora experimenta con engranes!',
            )),
        PasoBio('Engranes en acción', TipoPasoBio.simulacion, 'e4_m2_sim', (a) => SimEngranes(actividad: a, color: _c2)),
        PasoBio('Video del tema', TipoPasoBio.video, 'e4_m2_video', (a) => video(a,
            clave: 'maquinas_2', titulo: 'Video: los mecanismos', tema: 'engranes, poleas, ruedas y bielas', siguiente: '¡A clasificar mecanismos!')),
        PasoBio('¿Qué mecanismo usa?', TipoPasoBio.laboratorio, 'e4_m2_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Qué mecanismo usa?',
              color: _c2,
              instruccion: 'Arrastra cada objeto al mecanismo principal que usa.',
              grupos: const [
                GrupoClasificar('Engranes', '⚙️', Color(0xFFFFB300)),
                GrupoClasificar('Poleas', '🛞', Color(0xFF607D8B)),
                GrupoClasificar('Rueda y eje', '🚗', Color(0xFFE53935)),
                GrupoClasificar('Biela', '↔️', Color(0xFF7E57C2)),
              ],
              items: const [
                ItemClasificar('🕰️', 'Reloj de manecillas', 0, 'Sus engranes mueven las manecillas.'),
                ItemClasificar('🚲', 'Bicicleta', 0, 'Los engranes y la cadena mueven la rueda.'),
                ItemClasificar('🏗️', 'Grúa', 1, 'Levanta cargas con poleas y cables.'),
                ItemClasificar('🛗', 'Elevador', 1, 'Sube y baja con poleas.'),
                ItemClasificar('🛹', 'Patineta', 2, 'Sus ruedas giran sobre ejes.'),
                ItemClasificar('🛒', 'Carrito del súper', 2, 'Rueda gracias a sus ejes.'),
                ItemClasificar('🧵', 'Máquina de coser', 3, 'La aguja sube y baja con biela y manivela.'),
                ItemClasificar('🚂', 'Tren de vapor', 3, 'Sus bielas hacen girar las ruedas.'),
              ],
              mensajeFinal: 'Los mecanismos están en muchas máquinas que usas a diario.',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e4_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseEtiquetar(ilMecanismos, const {'engranes': 'Engranes', 'poleas': 'Poleas', 'rueda': 'Rueda y eje', 'biela': 'Biela y manivela'}, color: _c2),
                faseRelacionar(const [
                  ('Engranes', 'Ruedas con dientes que se empujan.'),
                  ('Poleas', 'Ruedas unidas por una banda.'),
                  ('Rueda loca', 'Engrane en medio que cambia el sentido.'),
                  ('Biela y manivela', 'Convierten el giro en ida y vuelta.'),
                ], color: _c2, instruccion: 'Relaciona cada mecanismo con lo que hace.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Un engrane pequeño mueve a uno grande. ¿Qué pasa con el grande?',
                    opciones: ['Gira más lento pero con más fuerza', 'Gira más rápido', 'No gira'],
                    correcta: 0,
                    explicacion: 'Se gana fuerza y se pierde velocidad.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Sabes cómo los mecanismos transforman el movimiento.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Máquinas de todos los días',
      emoji: '🏠',
      color: _c3,
      intro: 'Los motores y mecanismos están en tu casa y en la escuela. ¡Vamos a encontrarlos y a armar un ventilador!',
      mensajeFinal: '¡Reconoces las máquinas que te rodean!',
      pasos: [
        PasoBio('Aparatos con motor', TipoPasoBio.explicacion, 'e4_m3_tarj', (a) => tarjetas(
              a,
              seccion: '1. En casa',
              titulo: 'Máquinas de todos los días',
              color: _c3,
              textoZati: 'Muchos aparatos tienen un motor escondido. Toca cada tarjeta para descubrirlo.',
              grupos: const [
                GrupoTarjetas('En casa', _c3, Icons.home_rounded, [
                  TarjetaInfo(Icons.mode_fan_off_rounded, 'Ventilador', 'Su motor hace girar las aspas.'),
                  TarjetaInfo(Icons.blender_rounded, 'Licuadora', 'Su motor gira las cuchillas muy rápido.'),
                  TarjetaInfo(Icons.local_laundry_service_rounded, 'Lavadora', 'Su motor gira el tambor.'),
                  TarjetaInfo(Icons.kitchen_rounded, 'Refrigerador', 'Un motor mueve el gas que enfría.'),
                ]),
                GrupoTarjetas('Se mueven solos', Color(0xFFEF6C00), Icons.smart_toy_rounded, [
                  TarjetaInfo(Icons.cleaning_services_rounded, 'Robot aspiradora', 'Motores para sus ruedas y su cepillo, y sensores para no chocar.'),
                  TarjetaInfo(Icons.escalator_rounded, 'Escalera eléctrica', 'Un motor grande mueve los escalones con cadenas.'),
                  TarjetaInfo(Icons.toys_rounded, 'Carrito a control', 'Un motor para avanzar y otro para dar vuelta.'),
                  TarjetaInfo(Icons.garage_rounded, 'Puerta de cochera', 'Un motor la sube y la baja.'),
                ]),
              ],
              mensajeFinal: '¡Los motores trabajan para nosotros todo el día!',
            )),
        PasoBio('¿Tiene motor?', TipoPasoBio.laboratorio, 'e4_m3_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Tiene motor?',
              color: _c3,
              instruccion: 'Arrastra cada aparato al grupo correcto.',
              grupos: const [GrupoClasificar('Tiene motor', '🌀', Color(0xFF2E7D32)), GrupoClasificar('No tiene motor', '🚫', Color(0xFF9E9E9E))],
              items: const [
                ItemClasificar('🌀', 'Ventilador', 0, 'Su motor gira las aspas.'),
                ItemClasificar('🚗', 'Carrito de juguete', 0, 'Su motor mueve las ruedas.'),
                ItemClasificar('🚁', 'Dron', 0, 'Tiene un motor para cada hélice.'),
                ItemClasificar('🪚', 'Taladro', 0, 'Su motor gira la broca.'),
                ItemClasificar('💡', 'Foco', 1, 'Solo da luz, no se mueve.'),
                ItemClasificar('🧮', 'Calculadora', 1, 'Usa un circuito, pero no tiene motor.'),
                ItemClasificar('🔦', 'Linterna', 1, 'Tiene pila y foco, sin motor.'),
                ItemClasificar('📻', 'Radio', 1, 'Hace sonido, pero no tiene motor.'),
              ],
              mensajeFinal: 'Los aparatos que giran o se mueven tienen un motor.',
            )),
        PasoBio('Ventilador con luz piloto', TipoPasoBio.simulacion, 'e4_m3_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: 'Ventilador con luz piloto',
              color: _c3,
              mensajeFinal: 'Tu ventilador tiene una luz piloto que avisa cuando está encendido, como los aparatos de verdad.',
              retos: [
                RetoCircuito(
                  titulo: 'Ventilador',
                  instruccion: 'Arma un ventilador: el interruptor controla al motor. Agrega en paralelo una luz piloto (resistencia + LED) que encienda junto con el motor.',
                  piezas: () => [
                    pz('pila', TipoPieza.pila9v, 70, 240),
                    pz('sw', TipoPieza.interruptor, 200, 90),
                    pz('m', TipoPieza.motor, 370, 210),
                    pz('r', TipoPieza.resistencia, 470, 80),
                    pz('led', TipoPieza.led, 540, 200, color: ColorLed.verde),
                  ],
                  condiciones: [
                    Condicion('El motor gira con el interruptor', (e) => e.gira('m') && e.piezas['sw']!.cerrado),
                    Condicion('La luz piloto enciende junto con el motor', (e) => e.gira('m') && e.encendido('led')),
                  ],
                  logro: 'El motor y la luz piloto están en paralelo y el interruptor controla a los dos.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e4_m3_video', (a) => video(a,
            clave: 'maquinas_3', titulo: 'Video: máquinas en casa', tema: 'aparatos que usan motores y mecanismos', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e4_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseAcciones('Máquinas seguras', 'Toca las acciones seguras al usar aparatos con motor y presiona “Comprobar”.', const [
                  Accion(Icons.power_off_rounded, 'Desconectar la licuadora antes de limpiarla', true, 'Así no se enciende por accidente.'),
                  Accion(Icons.back_hand_rounded, 'Mantener los dedos lejos de las aspas', true, 'Las aspas giran muy rápido.'),
                  Accion(Icons.family_restroom_rounded, 'Pedir ayuda a un adulto con herramientas', true, 'Un taladro puede lastimar.'),
                  Accion(Icons.energy_savings_leaf_rounded, 'Apagar los aparatos al terminar', true, 'Ahorras energía y evitas accidentes.'),
                  Accion(Icons.cable_rounded, 'Jalar el cable para desconectar', false, 'Se daña el cable y puede quedar pelado.'),
                  Accion(Icons.pan_tool_rounded, 'Detener un ventilador con la mano', false, 'Te puedes lastimar.'),
                  Accion(Icons.water_drop_rounded, 'Usar aparatos eléctricos cerca del agua', false, 'El agua conduce la electricidad.'),
                ], color: _c3),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué tienen en común el ventilador, la licuadora y la lavadora?',
                    opciones: ['Tienen un motor eléctrico', 'Tienen un foco', 'Funcionan con agua'],
                    correcta: 0,
                    explicacion: 'Su motor produce el movimiento.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Reconoces los motores a tu alrededor y los usas con seguridad.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El carrito de la feria',
      emoji: '🏆',
      color: Color(0xFFD84315),
      intro: '¡Último desafío! Diseña el carrito eléctrico de la fábrica para la feria de ciencias.',
      mensajeFinal: '¡Tu carrito ganó la carrera de la feria!',
      pasos: [
        PasoBio('El carrito de la feria', TipoPasoBio.reto, 'e4_int_sit', (a) => situacion(
              a,
              titulo: 'El carrito de la feria',
              color: const Color(0xFFD84315),
              escenas: const [
                EscenaBio(
                  titulo: 'El motor',
                  narracion: 'El equipo quiere que su carrito avance solo, sin empujarlo.',
                  emojis: '🚗🔋',
                  pregunta: '¿Qué componente le dará movimiento?',
                  opciones: ['Un motor eléctrico', 'Un LED', 'Un sensor de luz'],
                  correcta: 0,
                  explicacion: 'El motor convierte la electricidad en movimiento.',
                ),
                EscenaBio(
                  titulo: 'Hacia atrás',
                  narracion: 'El carrito avanza, pero también necesitan que pueda ir en reversa.',
                  emojis: '↩️🚗',
                  pregunta: '¿Qué deben hacer?',
                  opciones: ['Invertir el + y el − del motor', 'Poner otra rueda', 'Apagar la pila'],
                  correcta: 0,
                  explicacion: 'Al invertir la corriente, el motor gira al revés.',
                ),
                EscenaBio(
                  titulo: 'La subida',
                  narracion: 'En la pista hay una rampa y el carrito no tiene fuerza para subirla.',
                  emojis: '⛰️⚙️',
                  pregunta: '¿Qué engranes ayudan a tener más fuerza?',
                  opciones: ['Un engrane pequeño en el motor que mueve uno grande en la rueda', 'Un engrane grande que mueve uno pequeño', 'Quitar los engranes'],
                  correcta: 0,
                  explicacion: 'Pequeño mueve grande: más fuerza, menos velocidad.',
                ),
                EscenaBio(
                  titulo: 'La velocidad',
                  narracion: 'En la recta quieren poder ir más rápido o más lento.',
                  emojis: '🏁🎛️',
                  pregunta: '¿Qué componente les ayuda a cambiar la velocidad?',
                  opciones: ['Un potenciómetro', 'Un zumbador', 'Una resistencia de colores fija'],
                  correcta: 0,
                  explicacion: 'Al girar la perilla cambia la corriente del motor.',
                ),
                EscenaBio(
                  titulo: 'Las luces',
                  narracion: 'Por último le ponen luces que encienden cuando el motor funciona.',
                  emojis: '💡🚗',
                  pregunta: '¿Cómo conectan los LED para que no dependan del motor si se descompone?',
                  opciones: ['En paralelo, cada uno con su resistencia', 'En serie con el motor', 'Sin resistencia'],
                  correcta: 0,
                  explicacion: 'En paralelo, cada componente tiene su propio camino.',
                ),
              ],
              mensajeFinal: '¡El carrito está listo para la carrera!',
            )),
        PasoBio('Supercerebro de máquinas', TipoPasoBio.reto, 'e4_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFD84315),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué hay dentro de un motor de corriente directa?',
                    opciones: ['Imanes y una bobina', 'Agua y arena', 'Un LED'],
                    correcta: 0,
                    explicacion: 'La bobina se vuelve imán y gira.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Para qué sirve la rueda loca entre dos engranes?',
                    opciones: ['Para que la salida gire en el mismo sentido que el motor', 'Para detener todo', 'Para hacer ruido'],
                    correcta: 0,
                    explicacion: 'Cada engrane invierte el sentido.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué mecanismo convierte el giro en movimiento de ida y vuelta?',
                    opciones: ['La biela y la manivela', 'La polea', 'La rueda'],
                    correcta: 0,
                    explicacion: 'Como el pistón de un motor.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué aparato NO necesita motor?',
                    opciones: ['La calculadora', 'El ventilador', 'La licuadora'],
                    correcta: 0,
                    explicacion: 'La calculadora no se mueve.',
                  ),
                ], color: const Color(0xFFD84315), instruccion: 'Demuestra todo lo que sabes de máquinas.'),
              ],
              mensajeFinal: '¡Ganaste la insignia «Ingeniero en Movimiento»!',
            )),
      ],
    ),
  ],
);
