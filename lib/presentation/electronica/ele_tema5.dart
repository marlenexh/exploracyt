import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'bloques.dart';
import 'circuito.dart';
import 'ele_tema1.dart' show pz, taller;
import 'fondos.dart';
import 'ilustraciones_ele.dart';
import 'taller.dart';

/// Electrónica · Tema 5: Crea tu invento (sistemas automatizados sencillos).

const _c1 = Color(0xFF7C4DFF);
const _c2 = Color(0xFFF39C12);
const _c3 = Color(0xFF2E86DE);
const _ci = Color(0xFF5E35B1);

Widget programa(String a, {required String seccion, required String titulo, required Color color, required List<RetoProg> retos, required String mensajeFinal}) =>
    ProgramaBloques(actividad: a, seccion: seccion, titulo: titulo, color: color, retos: retos, mensajeFinal: mensajeFinal);

final retoLampara = RetoProg(
  titulo: 'Lámpara automática',
  instruccion: 'Programa una lámpara que se encienda sola cuando hay poca luz. Elige el valor correcto y presiona “Probar programa”.',
  sensores: const [sensorLuz],
  salidas: const [salidaFoco],
  momentos: const [
    Momento('Mañana', '🌄', {'luz': 85}),
    Momento('Mediodía', '🌞', {'luz': 100}),
    Momento('Nublado', '⛅', {'luz': 60}),
    Momento('Atardecer', '🌇', {'luz': 30}),
    Momento('Noche', '🌙', {'luz': 5}),
  ],
  esperado: (l) => {'foco': l['luz']! < 50},
  logro: 'La lámpara solo gasta energía cuando hace falta. ¡Así funciona el alumbrado público!',
);

final retoVentilador = RetoProg(
  titulo: 'Ventilador inteligente',
  instruccion: 'El ventilador debe encenderse solo cuando hace calor (más de 28 °C). Ojo: ¡elige el sensor correcto!',
  sensores: const [sensorLuz, sensorTemp],
  salidas: const [salidaVentilador],
  momentos: const [
    Momento('Mañana fresca', '🌄', {'luz': 70, 'temp': 18}),
    Momento('Mediodía', '🌞', {'luz': 100, 'temp': 35}),
    Momento('Tarde', '🌤️', {'luz': 80, 'temp': 30}),
    Momento('Noche', '🌙', {'luz': 5, 'temp': 20}),
    Momento('Ola de calor', '🔥', {'luz': 90, 'temp': 42}),
  ],
  esperado: (l) => {'ventilador': l['temp']! > 28},
  logro: 'El sensor de temperatura es la entrada, el programa decide y el ventilador es la salida.',
);

final retoAlarma = RetoProg(
  titulo: 'Alarma del museo',
  instruccion: 'La alarma debe sonar SOLO cuando el sensor detecte movimiento. Elige el sensor, la condición y la salida correctas.',
  sensores: const [sensorLuz, sensorMov],
  salidas: const [salidaFoco, salidaAlarma],
  momentos: const [
    Momento('Sala vacía', '🏛️', {'luz': 10, 'mov': 0}),
    Momento('Pasa alguien', '🦹', {'luz': 10, 'mov': 1}),
    Momento('Todo tranquilo', '😴', {'luz': 15, 'mov': 0}),
    Momento('Una sombra', '👤', {'luz': 5, 'mov': 1}),
  ],
  esperado: (l) => {'alarma': l['mov']! > 0.5},
  logro: '¡Tu alarma protege el museo!',
);

final retoBarrera = RetoProg(
  titulo: 'Barrera del estacionamiento',
  instruccion: 'La barrera debe subir cuando un vehículo esté cerca (a menos de 30 cm del sensor), pero no cuando alguien pasa a lo lejos.',
  sensores: const [sensorTemp, sensorDist],
  salidas: const [salidaBarrera],
  momentos: const [
    Momento('Sin coches', '🅿️', {'temp': 25, 'dist': 200}),
    Momento('Llega un coche', '🚗', {'temp': 25, 'dist': 8}),
    Momento('Persona lejos', '🚶', {'temp': 26, 'dist': 60}),
    Momento('Llega una moto', '🏍️', {'temp': 26, 'dist': 25}),
    Momento('El coche se fue', '💨', {'temp': 25, 'dist': 150}),
  ],
  esperado: (l) => {'barrera': l['dist']! < 30},
  logro: 'El sensor ultrasónico mide la distancia y el programa decide cuándo subir la barrera.',
);

final retoInvernadero = RetoProg(
  titulo: 'Invernadero automático',
  reglas: 2,
  instruccion: 'Programa DOS reglas: la lámpara debe encender con poca luz (menos de 50 %) y la bomba debe regar cuando la tierra esté seca (humedad menor que 40 %).',
  sensores: const [sensorLuz, sensorHum, sensorTemp],
  salidas: const [salidaFoco, salidaBomba],
  momentos: const [
    Momento('Mañana', '🌄', {'luz': 80, 'hum': 60, 'temp': 20}),
    Momento('Mediodía seco', '🌞', {'luz': 100, 'hum': 25, 'temp': 33}),
    Momento('Tarde nublada', '⛅', {'luz': 30, 'hum': 45, 'temp': 24}),
    Momento('Noche húmeda', '🌙', {'luz': 5, 'hum': 70, 'temp': 16}),
    Momento('Noche seca', '🌌', {'luz': 10, 'hum': 15, 'temp': 18}),
  ],
  esperado: (l) => {'foco': l['luz']! < 50, 'bomba': l['hum']! < 40},
  logro: 'Tu invernadero cuida a las plantas solito: da luz de noche y agua cuando la tierra está seca.',
);

final eleTema5 = TemaBio(
  numero: 5,
  mundo: 'ele',
  estilo: estiloEle(FondoEle.planos),
  titulo: 'Crea tu invento',
  saludo: 'Ya conoces los componentes, los circuitos, los sensores y los motores. ¡Ahora vas a unirlos para crear inventos que funcionan solos, programándolos con bloques como en Tinkercad!',
  misionDelTema: 'La escuela organiza un concurso de inventos. Aprende cómo trabajan los sistemas automáticos, prográmalos con bloques y construye un invernadero que cuide las plantas solo.',
  color: _ci,
  insignia: 'Inventor Electrónico',
  emojiInsignia: '🤖',
  emojisPanel: const ['🧩', '💡', '🚧', '🌱', '🧠'],
  videos: const {
    'inventos_1': 'assets/videos/inventos_sistemas.mp4',
    'inventos_2': 'assets/videos/inventos_bloques.mp4',
    'inventos_3': 'assets/videos/inventos_disena.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'Sistemas automáticos',
      emoji: '🤖',
      color: _c1,
      intro: 'Muchos aparatos hacen su trabajo solos. ¿Cómo lo logran? ¡Descubre los sistemas automáticos!',
      mensajeFinal: '¡Programaste tu primera lámpara automática!',
      pasos: [
        PasoBio('La casa inteligente', TipoPasoBio.explicacion, 'e5_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Automático',
              titulo: '¿Qué es un sistema automático?',
              color: _c1,
              il: ilCasaInteligente,
              textos: const [
                'Un sistema automático hace su trabajo solo, sin que una persona lo encienda o lo apague. Une sensores, un controlador con un programa y actuadores.',
                'Nos ayudan a ahorrar energía, a estar seguros y a hacer tareas difíciles o repetitivas, como regar las plantas o abrir una puerta.',
                'El sensor mide (entrada), el controlador sigue un programa con reglas “SI… ENTONCES…” (proceso) y el actuador hace la acción (salida). En Tinkercad, el controlador es una placa Arduino que se programa con bloques de código.',
                'Una casa inteligente enciende la luz al anochecer, prende el ventilador con calor, abre la puerta al detectar a alguien y riega el jardín cuando la tierra está seca.',
              ],
              izquierda: const [
                Parte('foco', 'Luz automática', '(sensor de luz)', '💡', Color(0xFFFFB300), 'SI hay poca luz, ENTONCES enciende el foco.'),
                Parte('riego', 'Riego automático', '(humedad)', '🚿', Color(0xFF29B6F6), 'SI la tierra está seca, ENTONCES riega.'),
              ],
              derecha: const [
                Parte('ventilador', 'Ventilador', '(temperatura)', '🌀', Color(0xFF00ACC1), 'SI hace calor, ENTONCES enciende el ventilador.'),
                Parte('puerta', 'Puerta automática', '(movimiento)', '🚪', Color(0xFF6D4C41), 'SI detecta a alguien, ENTONCES abre la puerta.'),
              ],
              resaltar: const {
                1: {'foco', 'riego'},
                2: {'ventilador', 'puerta'},
              },
              mensajeFinal: '¡Ahora conoce las tres partes de todo invento automático!',
            )),
        PasoBio('Entrada, proceso y salida', TipoPasoBio.explicacion, 'e5_m1_tarj', (a) => tarjetas(
              a,
              seccion: '2. Las tres partes',
              titulo: 'Entrada, proceso y salida',
              color: _c1,
              textoZati: 'Todo invento automático tiene tres partes, igual que en Tinkercad: entradas, el cerebro y salidas. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Entradas', colorEntrada, Icons.input_rounded, [
                  TarjetaInfo(Icons.sensors_rounded, 'Sensores', 'Luz, temperatura, movimiento, distancia, humedad.'),
                  TarjetaInfo(Icons.radio_button_checked_rounded, 'Botones', 'La persona da una orden.'),
                ]),
                GrupoTarjetas('Proceso', colorControl, Icons.memory_rounded, [
                  TarjetaInfo(Icons.developer_board_rounded, 'Arduino', 'Una pequeña computadora llamada microcontrolador.'),
                  TarjetaInfo(Icons.code_rounded, 'Programa', 'Las reglas que decide quien inventa: “si… entonces…”.'),
                ]),
                GrupoTarjetas('Salidas', colorSalida, Icons.output_rounded, [
                  TarjetaInfo(Icons.lightbulb_rounded, 'Luz', 'LED o foco que se encienden.'),
                  TarjetaInfo(Icons.cyclone_rounded, 'Movimiento', 'Motores y servomotores.'),
                  TarjetaInfo(Icons.volume_up_rounded, 'Sonido', 'Zumbadores y bocinas.'),
                ]),
              ],
              mensajeFinal: 'Entrada → proceso → salida: ¡la receta de todo invento automático!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e5_m1_video', (a) => video(a,
            clave: 'inventos_1', titulo: 'Video: sistemas automáticos', tema: 'cómo trabajan los sistemas automatizados', siguiente: '¡A programar tu primera lámpara!')),
        PasoBio('Lámpara automática', TipoPasoBio.simulacion, 'e5_m1_prog', (a) => programa(
              a,
              seccion: 'Programa',
              titulo: 'Lámpara automática',
              color: _c1,
              retos: [retoLampara],
              mensajeFinal: 'Programaste tu primer sistema automático con bloques.',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e5_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilCasaInteligente, const {'foco': 'Luz automática', 'ventilador': 'Ventilador', 'puerta': 'Puerta automática', 'riego': 'Riego'}, color: _c1,
                    instruccion: 'Identifica cada sistema automático de la casa.'),
                faseRelacionar(const [
                  ('Entrada', 'El sensor que mide.'),
                  ('Proceso', 'El Arduino con su programa.'),
                  ('Salida', 'El actuador que hace la acción.'),
                  ('Programa', 'Las reglas si… entonces…'),
                ], color: _c1, instruccion: 'Relaciona cada parte con lo que es.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué hace un sistema automático?',
                    opciones: ['Su trabajo solo, usando sensores y un programa', 'Nada sin una persona', 'Solo da luz'],
                    correcta: 0,
                    explicacion: 'Mide, decide y actúa por sí mismo.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Entiendes cómo funcionan los sistemas automáticos.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Programa con bloques',
      emoji: '🧩',
      color: _c2,
      intro: 'En Tinkercad, el Arduino se programa uniendo bloques de colores. ¡Programa un ventilador y una alarma!',
      mensajeFinal: '¡Ya programas como en Tinkercad!',
      pasos: [
        PasoBio('El cerebro del invento', TipoPasoBio.explicacion, 'e5_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Arduino',
              titulo: 'El cerebro: Arduino',
              color: _c2,
              il: ilEntradaSalida,
              textos: const [
                'Arduino es una pequeña placa con un microcontrolador: una computadora diminuta. Tiene pines para conectar sensores (entradas) y LED, motores o zumbadores (salidas).',
                'Por sí solo no sabe qué hacer: hay que darle un programa. El programa son instrucciones en orden que el Arduino repite muy rápido, miles de veces por segundo.',
                'En la pestaña “Código” de Tinkercad hay bloques de colores: los morados leen las ENTRADAS, los naranjas son de CONTROL (como “si… entonces… si no…”) y los azules mandan las SALIDAS.',
                'Las lavadoras, los microondas y los juguetes robot tienen un microcontrolador con un programa adentro.',
              ],
              izquierda: const [
                Parte('sensor', 'Entrada', '(bloques morados)', '🟪', colorEntrada, 'Bloques que leen lo que mide el sensor.'),
                Parte('senal', 'Señal', '(viaja por un cable)', '⚡', Color(0xFFFFB300), 'Llega a un pin de entrada del Arduino.'),
              ],
              derecha: const [
                Parte('controlador', 'Control', '(bloques naranjas)', '🟧', colorControl, 'Bloques que deciden: si… entonces… si no…'),
                Parte('actuador', 'Salida', '(bloques azules)', '🟦', colorSalida, 'Bloques que encienden o apagan las salidas.'),
              ],
              resaltar: const {
                1: {'controlador'},
                2: {'sensor', 'controlador', 'actuador'},
              },
              mensajeFinal: '¡Ahora programa con bloques!',
            )),
        PasoBio('Ventilador y alarma', TipoPasoBio.simulacion, 'e5_m2_prog', (a) => programa(
              a,
              seccion: 'Programa',
              titulo: 'Inventos con bloques',
              color: _c2,
              retos: [retoVentilador, retoAlarma],
              mensajeFinal: 'Programaste un ventilador inteligente y una alarma.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e5_m2_video', (a) => video(a,
            clave: 'inventos_2', titulo: 'Video: programación por bloques', tema: 'cómo programar un Arduino con bloques', siguiente: '¡Ordena los pasos de un programador!')),
        PasoBio('Pasos para programar', TipoPasoBio.juego, 'e5_m2_ord', (a) => ordenar(
              a,
              seccion: '2. Paso a paso',
              titulo: 'Cómo crear un programa',
              color: _c2,
              instruccion: 'Ordena los pasos que sigue un inventor para programar su invento.',
              pasos: const [
                ('🤔', 'Pensar qué problema resolver'),
                ('🟪', 'Elegir el sensor (entrada)'),
                ('🟦', 'Elegir la salida'),
                ('🟧', 'Escribir la regla si… entonces'),
                ('▶️', 'Probar la simulación'),
                ('🔧', 'Corregir y mejorar'),
              ],
              explicacion: 'Los programadores prueban y corrigen muchas veces hasta que todo funciona.',
              mensajeFinal: '¡Piensas como programador!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e5_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseRelacionar(const [
                  ('Bloques morados', 'Leen las entradas (sensores).'),
                  ('Bloques naranjas', 'Controlan: si… entonces…'),
                  ('Bloques azules', 'Mandan las salidas.'),
                  ('Arduino', 'El cerebro que sigue el programa.'),
                ], color: _c2, instruccion: 'Relaciona cada bloque con lo que hace.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'En la regla “SI la temperatura es mayor que 28 °C ENTONCES encender ventilador”, ¿cuál es la entrada?',
                    opciones: ['La temperatura', 'El ventilador', 'El número 28'],
                    correcta: 0,
                    explicacion: 'La lee el sensor de temperatura.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué hace el bloque “si no”?',
                    opciones: ['Dice qué hacer cuando la condición NO se cumple', 'Apaga el Arduino', 'Repite todo'],
                    correcta: 0,
                    explicacion: 'Por ejemplo, apagar el ventilador si no hace calor.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Sabes programar reglas con bloques.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Diseña tu invento',
      emoji: '💡',
      color: _c3,
      intro: 'Es hora de diseñar inventos completos: arma el prototipo, programa su cerebro y pruébalo.',
      mensajeFinal: '¡Diseñaste y probaste tus propios inventos!',
      pasos: [
        PasoBio('Barrera del estacionamiento', TipoPasoBio.simulacion, 'e5_m3_prog', (a) => programa(
              a,
              seccion: 'Programa',
              titulo: 'Barrera del estacionamiento',
              color: _c3,
              retos: [retoBarrera],
              mensajeFinal: 'Tu barrera automática deja pasar a los vehículos.',
            )),
        PasoBio('Prototipo de alarma', TipoPasoBio.simulacion, 'e5_m3_taller', (a) => taller(
              a,
              seccion: 'Prototipo',
              titulo: 'Prototipo de alarma',
              color: _c3,
              mensajeFinal: 'Tu prototipo tiene una salida de sonido y una de luz controladas por la misma entrada.',
              retos: [
                RetoCircuito(
                  titulo: 'Alarma con luz',
                  instruccion: 'Arma el prototipo de una alarma: al presionar el botón deben sonar el zumbador Y encenderse el LED (con su resistencia). Pista: el zumbador y el LED van en paralelo después del botón.',
                  piezas: () => [
                    pz('pila', TipoPieza.pila9v, 70, 240),
                    pz('b', TipoPieza.boton, 210, 90),
                    pz('z', TipoPieza.zumbador, 380, 200),
                    pz('r', TipoPieza.resistencia, 470, 80),
                    pz('led', TipoPieza.led, 540, 210),
                  ],
                  condiciones: [Condicion('El botón activa el sonido y la luz a la vez', (e) => e.piezas['b']!.presionado && e.suena('z') && e.encendido('led'))],
                  logro: 'Una entrada puede controlar varias salidas.',
                ),
              ],
            )),
        PasoBio('¿Entrada, proceso o salida?', TipoPasoBio.laboratorio, 'e5_m3_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Entrada, proceso o salida?',
              color: _c3,
              instruccion: 'Arrastra cada pieza a la parte del invento a la que pertenece.',
              grupos: const [
                GrupoClasificar('Entrada', '🟪', colorEntrada),
                GrupoClasificar('Proceso', '🟧', colorControl),
                GrupoClasificar('Salida', '🟦', colorSalida),
              ],
              items: const [
                ItemClasificar('☀️', 'Sensor de luz', 0, 'Mide la luz: es una entrada.'),
                ItemClasificar('🔘', 'Botón', 0, 'La persona da una orden: entrada.'),
                ItemClasificar('🌡️', 'Sensor de temperatura', 0, 'Mide el calor: entrada.'),
                ItemClasificar('🧠', 'Arduino', 1, 'El cerebro que decide: proceso.'),
                ItemClasificar('📜', 'Programa', 1, 'Las reglas del proceso.'),
                ItemClasificar('💡', 'LED', 2, 'Da luz: salida.'),
                ItemClasificar('🌀', 'Motor', 2, 'Da movimiento: salida.'),
                ItemClasificar('🔔', 'Zumbador', 2, 'Da sonido: salida.'),
              ],
              mensajeFinal: '¡Sabes de qué está hecho un invento!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e5_m3_video', (a) => video(a,
            clave: 'inventos_3', titulo: 'Video: diseña tu invento', tema: 'cómo diseñar y probar un invento', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e5_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseAcciones('Hábitos de un buen inventor', 'Toca las actitudes de un buen inventor y presiona “Comprobar”.', const [
                  Accion(Icons.science_rounded, 'Probar y corregir muchas veces', true, 'Los errores enseñan cómo mejorar.'),
                  Accion(Icons.groups_rounded, 'Trabajar en equipo', true, 'Las ideas de todos hacen mejor el invento.'),
                  Accion(Icons.volunteer_activism_rounded, 'Pensar cómo ayudar a otros', true, 'Los mejores inventos resuelven problemas reales.'),
                  Accion(Icons.recycling_rounded, 'Reutilizar materiales', true, 'Cuidas el planeta y ahorras.'),
                  Accion(Icons.computer_rounded, 'Simular antes de construir', true, 'En Tinkercad no se quema nada de verdad.'),
                  Accion(Icons.sentiment_very_dissatisfied_rounded, 'Rendirse si falla la primera vez', false, 'Casi ningún invento funciona al primer intento.'),
                  Accion(Icons.bolt_rounded, 'Conectar inventos a la corriente de la casa sin ayuda', false, 'Usa pilas y pide ayuda a un adulto.'),
                ], color: _c3),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'Tu barrera sube cuando pasa una persona lejos. ¿Qué cambiarías?',
                    opciones: ['El valor de distancia de la regla', 'El color de la barrera', 'Nada'],
                    correcta: 0,
                    explicacion: 'Un valor menor hace que solo suba con vehículos cerca.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Diseñas, pruebas y mejoras como un inventor.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El invernadero automático',
      emoji: '🏆',
      color: Color(0xFF00897B),
      intro: '¡Último desafío! Diseña un invernadero que cuide las plantas de la escuela solo.',
      mensajeFinal: '¡Tu invernadero ganó el concurso de inventos!',
      pasos: [
        PasoBio('Diseña el invernadero', TipoPasoBio.reto, 'e5_int_sit', (a) => situacion(
              a,
              titulo: 'Diseña el invernadero',
              color: const Color(0xFF00897B),
              escenas: const [
                EscenaBio(
                  titulo: 'El problema',
                  narracion: 'En vacaciones nadie riega las plantas de la escuela y en invierno les falta luz.',
                  emojis: '🥀🏫',
                  pregunta: '¿Qué tipo de invento puede ayudar?',
                  opciones: ['Un sistema automático', 'Una linterna', 'Un timbre'],
                  correcta: 0,
                  explicacion: 'Puede regar y dar luz sin que alguien esté ahí.',
                ),
                EscenaBio(
                  titulo: 'Las entradas',
                  narracion: 'El invento debe saber si la tierra está seca y si hay poca luz.',
                  emojis: '💧☀️',
                  pregunta: '¿Qué sensores necesita?',
                  opciones: ['Sensor de humedad y sensor de luz', 'Sensor de distancia y botón', 'Solo un motor'],
                  correcta: 0,
                  explicacion: 'Son las entradas del sistema.',
                ),
                EscenaBio(
                  titulo: 'Las salidas',
                  narracion: 'El invento debe dar agua y luz a las plantas.',
                  emojis: '🚿💡',
                  pregunta: '¿Qué salidas usa?',
                  opciones: ['Una bomba de agua y una lámpara', 'Un zumbador y un ventilador', 'Una pila y un cable'],
                  correcta: 0,
                  explicacion: 'Son los actuadores del invernadero.',
                ),
                EscenaBio(
                  titulo: 'El cerebro',
                  narracion: 'Hay que decidir cuándo regar y cuándo encender la luz.',
                  emojis: '🧠🧩',
                  pregunta: '¿Qué componente decide con un programa?',
                  opciones: ['El Arduino', 'La bomba', 'El sensor de luz'],
                  correcta: 0,
                  explicacion: 'Es el proceso del sistema.',
                ),
              ],
              mensajeFinal: '¡El diseño está listo! Ahora prográmalo.',
            )),
        PasoBio('Programa el invernadero', TipoPasoBio.simulacion, 'e5_int_prog', (a) => programa(
              a,
              seccion: 'Integradora',
              titulo: 'Invernadero automático',
              color: const Color(0xFF00897B),
              retos: [retoInvernadero],
              mensajeFinal: 'Integraste sensores, programa y actuadores en un sistema automático completo.',
            )),
        PasoBio('Supercerebro de inventos', TipoPasoBio.reto, 'e5_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFF00897B),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Cuáles son las tres partes de un sistema automático?',
                    opciones: ['Entrada, proceso y salida', 'Pila, cable y foco', 'Inicio, medio y fin'],
                    correcta: 0,
                    explicacion: 'Sensor, controlador y actuador.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué programa enciende una lámpara de noche?',
                    opciones: ['SI la luz es menor que 50 % ENTONCES encender', 'SI la luz es mayor que 80 % ENTONCES encender', 'Encender siempre'],
                    correcta: 0,
                    explicacion: 'Con poca luz, se enciende.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué componente es una salida de movimiento?',
                    opciones: ['El motor', 'El sensor PIR', 'El botón'],
                    correcta: 0,
                    explicacion: 'El motor produce movimiento.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Para qué sirve simular en Tinkercad antes de construir?',
                    opciones: ['Para probar y corregir sin quemar piezas reales', 'Para gastar más pilas', 'No sirve'],
                    correcta: 0,
                    explicacion: 'Ahorra tiempo, dinero y materiales.',
                  ),
                ], color: const Color(0xFF00897B), instruccion: 'Demuestra todo lo que sabes de inventos.'),
              ],
              mensajeFinal: '¡Ganaste la insignia «Inventor Electrónico»!',
            )),
      ],
    ),
  ],
);
