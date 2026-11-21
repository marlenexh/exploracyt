import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'circuito.dart';
import 'ele_tema1.dart' show pz, taller;
import 'fondos.dart';
import 'ilustraciones_ele.dart';
import 'sims_ele.dart';
import 'taller.dart';

/// Electrónica · Tema 3: Detectives electrónicos (sensores).

const _c1 = Color(0xFF00897B);
const _c2 = Color(0xFF5E35B1);
const _c3 = Color(0xFF00ACC1);
const _ci = Color(0xFF00796B);

final eleTema3 = TemaBio(
  numero: 3,
  mundo: 'ele',
  estilo: estiloEle(FondoEle.detective),
  titulo: 'Detectives electrónicos',
  saludo: 'Los aparatos también pueden “sentir”: detectan la luz, el calor, el movimiento y la distancia. ¡Conviértete en detective y descubre cómo funcionan los sensores!',
  misionDelTema: 'Alguien se mete de noche al museo de la ciudad. Investiga los sensores, descubre cómo funcionan y dónde se usan para proteger el museo.',
  color: _ci,
  insignia: 'Detective Electrónico',
  emojiInsignia: '🕵️',
  emojisPanel: const ['👁️', '🌡️', '📡', '🔦', '🔍'],
  videos: const {
    'sensores_1': 'assets/videos/sensores_que_son.mp4',
    'sensores_2': 'assets/videos/sensores_como_funcionan.mp4',
    'sensores_3': 'assets/videos/sensores_donde_se_usan.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es un sensor?',
      emoji: '👁️',
      color: _c1,
      intro: 'Para atrapar al intruso necesitamos aparatos que detecten cosas. ¡Conoce a los sensores!',
      mensajeFinal: '¡Ya sabes qué es un sensor y conoces varios tipos!',
      pasos: [
        PasoBio('¿Qué es un sensor?', TipoPasoBio.explicacion, 'e3_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Sensores',
              titulo: '¿Qué es un sensor?',
              color: _c1,
              il: ilSensores,
              textos: const [
                'Un sensor es un componente que detecta algo del ambiente, como la luz, la temperatura, el movimiento o la distancia, y lo convierte en una señal eléctrica.',
                'Los sensores son como los sentidos de los aparatos. Gracias a ellos, una máquina puede “darse cuenta” de lo que pasa y reaccionar.',
                'Muchos sensores cambian su resistencia o su voltaje según lo que detectan. Por ejemplo, la fotorresistencia deja pasar más corriente cuando hay más luz.',
                'Las puertas del supermercado se abren solas, la pantalla del celular gira y las lámparas de la calle se encienden de noche: ¡todo gracias a sensores!',
              ],
              izquierda: const [
                Parte('luz', 'Fotorresistencia', '(sensor de luz)', '☀️', Color(0xFFFF8F00), 'Cambia su resistencia con la luz. En Tinkercad se llama fotorresistencia.'),
                Parte('movimiento', 'Sensor PIR', '(movimiento)', '🚶', Color(0xFF2E7D32), 'Detecta el calor de una persona o animal que se mueve frente a él.'),
                Parte('tacto', 'Botón', '(presión)', '👆', Color(0xFFE53935), 'También es un sensor sencillo: detecta cuando lo presionas.'),
              ],
              derecha: const [
                Parte('temperatura', 'Sensor de temperatura', '(calor y frío)', '🌡️', Color(0xFF424242), 'Da más voltaje cuando hace más calor. En Tinkercad es el TMP36.'),
                Parte('distancia', 'Sensor ultrasónico', '(distancia)', '📏', Color(0xFF1565C0), 'Mide la distancia con sonidos que no escuchamos, como los murciélagos.'),
              ],
              resaltar: const {
                1: {'luz', 'temperatura', 'movimiento', 'distancia'},
                2: {'luz'},
              },
              mensajeFinal: '¡Conociste los sensores! Ahora compáralos con tus sentidos.',
            )),
        PasoBio('Sentidos y sensores', TipoPasoBio.explicacion, 'e3_m1_tarj', (a) => tarjetas(
              a,
              seccion: '2. Como tus sentidos',
              titulo: 'Tus sentidos y los sensores',
              color: _c1,
              textoZati: 'Tú sientes el mundo con tus sentidos; los aparatos, con sensores. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Tus sentidos', Color(0xFFEC407A), Icons.face_rounded, [
                  TarjetaInfo(Icons.visibility_rounded, 'Vista', 'Tus ojos detectan la luz.'),
                  TarjetaInfo(Icons.pan_tool_rounded, 'Tacto', 'Tu piel siente el calor, el frío y la presión.'),
                  TarjetaInfo(Icons.hearing_rounded, 'Oído', 'Tus oídos detectan los sonidos.'),
                ]),
                GrupoTarjetas('Los sensores', _c1, Icons.sensors_rounded, [
                  TarjetaInfo(Icons.light_mode_rounded, 'Sensor de luz', 'Como los ojos: detecta si hay luz.'),
                  TarjetaInfo(Icons.thermostat_rounded, 'Sensor de temperatura', 'Como la piel: detecta el calor.'),
                  TarjetaInfo(Icons.mic_rounded, 'Micrófono', 'Como el oído: detecta el sonido.'),
                  TarjetaInfo(Icons.radar_rounded, 'Ultrasónico', 'Como un murciélago: mide distancias con eco.'),
                ]),
              ],
              mensajeFinal: '¡Los sensores son los sentidos de las máquinas!',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e3_m1_video', (a) => video(a,
            clave: 'sensores_1', titulo: 'Video: ¿qué es un sensor?', tema: 'qué son los sensores', siguiente: '¡A jugar memorama!')),
        PasoBio('Memorama de sensores', TipoPasoBio.juego, 'e3_m1_mem', (a) => memorama(
              a,
              titulo: 'Memorama de sensores',
              color: _c1,
              instruccion: 'Encuentra cada sensor con lo que detecta.',
              pares: const [
                ('☀️', 'Fotorresistencia', 'Detecta la luz'),
                ('🌡️', 'TMP36', 'Detecta la temperatura'),
                ('🚶', 'Sensor PIR', 'Detecta el movimiento'),
                ('📏', 'Ultrasónico', 'Mide la distancia'),
                ('🎤', 'Micrófono', 'Detecta el sonido'),
                ('👆', 'Botón', 'Detecta la presión'),
              ],
              mensajeFinal: '¡Memoria de detective!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e3_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilSensores, const {'luz': 'Luz', 'temperatura': 'Temperatura', 'movimiento': 'Movimiento', 'distancia': 'Distancia'}, color: _c1,
                    instruccion: 'Identifica qué detecta cada sensor: arrastra el nombre a su lugar.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué hace un sensor?',
                    opciones: ['Detecta algo del ambiente y lo convierte en señal eléctrica', 'Guarda energía', 'Produce movimiento'],
                    correcta: 0,
                    explicacion: 'Es como un sentido para el aparato.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué sensor usarías para saber si ya es de noche?',
                    opciones: ['Sensor de luz', 'Sensor de temperatura', 'Botón'],
                    correcta: 0,
                    explicacion: 'La fotorresistencia detecta la falta de luz.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Sabes qué es un sensor y qué detecta cada uno.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: '¿Cómo funcionan?',
      emoji: '🔍',
      color: _c2,
      intro: 'Vamos al laboratorio a probar los sensores. ¿Cómo convierten lo que detectan en electricidad?',
      mensajeFinal: '¡Entiendes cómo trabaja un sensor!',
      pasos: [
        PasoBio('Entrada, proceso y salida', TipoPasoBio.explicacion, 'e3_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Cómo funcionan',
              titulo: 'Del sensor a la acción',
              color: _c2,
              il: ilEntradaSalida,
              textos: const [
                'Un sensor es la ENTRADA de un sistema: recoge información. Esa información viaja como una señal eléctrica hacia un controlador.',
                'El controlador, como la placa Arduino que usa Tinkercad, es el PROCESO: decide qué hacer. Después activa la SALIDA, como un LED, un motor o un zumbador.',
                'Ejemplo de una alarma: el sensor PIR detecta movimiento, manda una señal, el Arduino la recibe y decide encender el zumbador. ¡Todo en menos de un segundo!',
                'El termostato del aire acondicionado mide la temperatura y, si hace calor, enciende el ventilador. Es entrada, proceso y salida.',
              ],
              izquierda: const [
                Parte('sensor', 'Entrada', '(sensor)', '🚶', Color(0xFF8E24AA), 'Detecta lo que pasa: aquí, el movimiento.'),
                Parte('senal', 'Señal', '(electricidad)', '⚡', Color(0xFFFFB300), 'El sensor manda un pequeño voltaje que lleva la información.'),
              ],
              derecha: const [
                Parte('controlador', 'Proceso', '(Arduino)', '🧠', Color(0xFFEF6C00), 'Es el “cerebro”: sigue un programa para decidir.'),
                Parte('actuador', 'Salida', '(zumbador)', '🔔', Color(0xFF1E88E5), 'Hace la acción: sonar, encender, mover.'),
              ],
              resaltar: const {
                1: {'controlador', 'actuador'},
                2: {'sensor', 'senal'},
              },
              mensajeFinal: '¡Ahora prueba los sensores en el laboratorio!',
            )),
        PasoBio('Laboratorio de sensores', TipoPasoBio.laboratorio, 'e3_m2_lab', (a) => LabSensores(actividad: a, color: _c2)),
        PasoBio('El sensor de luz en un circuito', TipoPasoBio.simulacion, 'e3_m2_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: 'Sensor de luz en el circuito',
              color: _c2,
              mensajeFinal: 'La fotorresistencia cambió la corriente según la luz. Para que una lámpara encienda de noche, un controlador como Arduino “invierte” la decisión: ¡lo harás en Crea tu invento!',
              retos: [
                RetoCircuito(
                  titulo: 'Fotorresistencia',
                  instruccion: 'Conecta en un solo camino: pila + → fotorresistencia → resistencia → LED → pila −. Simula y mueve el control de luz (☀️/🌙).',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 80, 240), pz('ldr', TipoPieza.ldr, 210, 140), pz('r', TipoPieza.resistencia, 340, 230), pz('led', TipoPieza.led, 500, 200)],
                  condiciones: [
                    Condicion('Con mucha luz, el LED brilla', (e) => e.encendido('led') && e.luz > 0.7),
                    Condicion('A oscuras, casi no pasa corriente', (e) => !e.encendido('led') && e.luz < 0.3 && e.voltaje('ldr').abs() > 1),
                  ],
                  logro: 'La fotorresistencia es un sensor: deja pasar más corriente cuando hay más luz.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e3_m2_video', (a) => video(a,
            clave: 'sensores_2', titulo: 'Video: cómo funcionan los sensores', tema: 'entrada, proceso y salida', siguiente: '¡Ordena cómo funciona una alarma!')),
        PasoBio('¿Cómo funciona una alarma?', TipoPasoBio.juego, 'e3_m2_ord', (a) => ordenar(
              a,
              seccion: '2. Paso a paso',
              titulo: '¿Cómo funciona una alarma?',
              color: _c2,
              instruccion: 'Ordena lo que pasa desde que alguien entra al museo hasta que suena la alarma.',
              pasos: const [
                ('🦹', 'Alguien se mueve en la sala'),
                ('🚶', 'El sensor PIR lo detecta'),
                ('⚡', 'Manda una señal eléctrica'),
                ('🧠', 'El Arduino decide'),
                ('🔔', 'Suena el zumbador'),
              ],
              explicacion: 'Entrada (sensor) → proceso (controlador) → salida (zumbador).',
              mensajeFinal: '¡Así protege una alarma!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e3_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseEtiquetar(ilEntradaSalida, const {'sensor': 'Entrada', 'controlador': 'Proceso', 'actuador': 'Salida'}, color: _c2, instruccion: 'Nombra cada parte del sistema.'),
                faseRelacionar(const [
                  ('Entrada', 'El sensor que recoge información.'),
                  ('Proceso', 'El controlador que decide.'),
                  ('Salida', 'El componente que hace la acción.'),
                  ('Señal', 'Electricidad que lleva la información.'),
                ], color: _c2, instruccion: 'Relaciona cada palabra con su significado.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué le pasa a la fotorresistencia cuando hay más luz?',
                    opciones: ['Su resistencia baja y pasa más corriente', 'Se apaga', 'Hace ruido'],
                    correcta: 0,
                    explicacion: 'Con luz, su resistencia baja.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Entiendes cómo funcionan los sensores.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Sensores a nuestro alrededor',
      emoji: '🏙️',
      color: _c3,
      intro: 'Los sensores están en casa, en la calle y en tu bolsillo. ¡Vamos a encontrarlos!',
      mensajeFinal: '¡Encuentras sensores en todas partes!',
      pasos: [
        PasoBio('¿Dónde se usan?', TipoPasoBio.explicacion, 'e3_m3_tarj', (a) => tarjetas(
              a,
              seccion: '1. Dónde se usan',
              titulo: 'Sensores a nuestro alrededor',
              color: _c3,
              textoZati: 'Los sensores nos ayudan a estar seguros, ahorrar energía y vivir más cómodos. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('En casa', Color(0xFFEF6C00), Icons.home_rounded, [
                  TarjetaInfo(Icons.settings_remote_rounded, 'Control remoto', 'La tele tiene un sensor que recibe la luz infrarroja del control.'),
                  TarjetaInfo(Icons.smoke_free_rounded, 'Detector de humo', 'Suena si detecta humo de un incendio.'),
                  TarjetaInfo(Icons.thermostat_rounded, 'Termostato', 'Mide la temperatura y enciende el clima.'),
                ]),
                GrupoTarjetas('En la calle', Color(0xFF3949AB), Icons.location_city_rounded, [
                  TarjetaInfo(Icons.light_rounded, 'Alumbrado público', 'Un sensor de luz enciende las lámparas al anochecer.'),
                  TarjetaInfo(Icons.door_sliding_rounded, 'Puertas automáticas', 'Se abren al detectar movimiento.'),
                  TarjetaInfo(Icons.directions_car_rounded, 'Sensor de reversa', 'Mide la distancia con ultrasonido y pita si estás cerca.'),
                ]),
                GrupoTarjetas('En tu bolsillo', _c3, Icons.smartphone_rounded, [
                  TarjetaInfo(Icons.fingerprint_rounded, 'Huella digital', 'Reconoce tu dedo para desbloquear.'),
                  TarjetaInfo(Icons.screen_rotation_rounded, 'Giro de pantalla', 'Detecta cómo sostienes el celular.'),
                  TarjetaInfo(Icons.brightness_auto_rounded, 'Brillo automático', 'Mide la luz para ajustar la pantalla.'),
                ]),
              ],
              mensajeFinal: '¡Hay sensores en casi todos los aparatos modernos!',
            )),
        PasoBio('¿Qué sensor usa?', TipoPasoBio.laboratorio, 'e3_m3_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Qué sensor usa?',
              color: _c3,
              instruccion: 'Arrastra cada aparato al sensor que necesita.',
              grupos: const [
                GrupoClasificar('Luz', '☀️', Color(0xFFFF8F00)),
                GrupoClasificar('Temperatura', '🌡️', Color(0xFFE53935)),
                GrupoClasificar('Movimiento', '🚶', Color(0xFF2E7D32)),
                GrupoClasificar('Distancia', '📏', Color(0xFF1565C0)),
              ],
              items: const [
                ItemClasificar('🏮', 'Lámpara de la calle', 0, 'Enciende cuando oscurece.'),
                ItemClasificar('🔆', 'Brillo del celular', 0, 'Se ajusta con la luz.'),
                ItemClasificar('❄️', 'Aire acondicionado', 1, 'Enfría si hace calor.'),
                ItemClasificar('🤒', 'Termómetro digital', 1, 'Mide la temperatura del cuerpo.'),
                ItemClasificar('🚪', 'Puerta del súper', 2, 'Se abre al detectar movimiento.'),
                ItemClasificar('🚨', 'Alarma de la casa', 2, 'Suena si alguien se mueve.'),
                ItemClasificar('🚗', 'Reversa del coche', 3, 'Mide qué tan cerca está la pared.'),
                ItemClasificar('🤖', 'Robot que esquiva', 3, 'Mide la distancia a los obstáculos.'),
              ],
              mensajeFinal: 'Cada aparato usa el sensor que necesita para su trabajo.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e3_m3_video', (a) => video(a,
            clave: 'sensores_3', titulo: 'Video: sensores en la vida diaria', tema: 'dónde se usan los sensores', siguiente: '¡A atrapar aparatos con sensores!')),
        PasoBio('Atrapa los aparatos con sensores', TipoPasoBio.juego, 'e3_m3_juego', (a) => atrapar(
              a,
              titulo: 'Atrapa los aparatos con sensores',
              instrucciones: 'Mueve la lupa con tu dedo. Atrapa los aparatos que usan sensores y deja caer los objetos que no tienen.',
              color: _c3,
              recolector: '🔍',
              cosas: const [
                CosaQueCae('📱', true),
                CosaQueCae('🌡️', true),
                CosaQueCae('🚨', true),
                CosaQueCae('📷', true),
                CosaQueCae('⌚', true),
                CosaQueCae('🚦', true),
                CosaQueCae('🥄', false, mensaje: 'Una cuchara no tiene sensores.'),
                CosaQueCae('📕', false, mensaje: 'Un libro no tiene sensores.'),
                CosaQueCae('🪨', false, mensaje: 'Una piedra no es un aparato.'),
                CosaQueCae('🧦', false, mensaje: 'Un calcetín no tiene sensores.'),
              ],
              mensajeFinal: '¡Encontraste muchos sensores!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e3_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseRelacionar(const [
                  ('Lámpara de la calle', 'Sensor de luz'),
                  ('Puerta automática', 'Sensor de movimiento'),
                  ('Sensor de reversa', 'Sensor ultrasónico'),
                  ('Termostato', 'Sensor de temperatura'),
                ], color: _c3, instruccion: 'Relaciona cada aparato con su sensor.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Para qué sirve el sensor del alumbrado público?',
                    opciones: ['Para encender las lámparas solo de noche y ahorrar energía', 'Para medir la lluvia', 'Para sonar una alarma'],
                    correcta: 0,
                    explicacion: 'Detecta la falta de luz.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Cómo mide la distancia un sensor ultrasónico?',
                    opciones: ['Con el eco de un sonido que no oímos', 'Con una regla', 'Con el calor'],
                    correcta: 0,
                    explicacion: 'Mide cuánto tarda en regresar el eco.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Sabes dónde se usan los sensores.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El misterio del museo',
      emoji: '🏆',
      color: Color(0xFFC2185B),
      intro: '¡Último desafío! Usa los sensores para proteger el museo y descubrir al intruso.',
      mensajeFinal: '¡Resolviste el misterio del museo!',
      pasos: [
        PasoBio('El misterio del museo', TipoPasoBio.reto, 'e3_int_sit', (a) => situacion(
              a,
              titulo: 'El misterio del museo',
              color: const Color(0xFFC2185B),
              escenas: const [
                EscenaBio(
                  titulo: 'La sala oscura',
                  narracion: 'El intruso entra cuando la sala está a oscuras. Queremos saber si alguien camina por ahí.',
                  emojis: '🌙🦹',
                  pregunta: '¿Qué sensor detecta a una persona que camina?',
                  opciones: ['Sensor PIR de movimiento', 'Sensor de luz', 'Termómetro'],
                  correcta: 0,
                  explicacion: 'El PIR detecta el calor que se mueve, aunque esté oscuro.',
                ),
                EscenaBio(
                  titulo: 'La vitrina',
                  narracion: 'El diamante está en una vitrina. Hay que saber si alguien acerca la mano a menos de 10 cm.',
                  emojis: '💎✋',
                  pregunta: '¿Qué sensor conviene?',
                  opciones: ['Sensor ultrasónico de distancia', 'Sensor de temperatura', 'Un foco'],
                  correcta: 0,
                  explicacion: 'Mide qué tan cerca está algo.',
                ),
                EscenaBio(
                  titulo: 'Las luces',
                  narracion: 'Al anochecer, las luces del museo deben encenderse solas.',
                  emojis: '🌆💡',
                  pregunta: '¿Qué sensor usarías?',
                  opciones: ['Sensor de luz', 'Botón', 'Motor'],
                  correcta: 0,
                  explicacion: 'Detecta cuando ya no hay luz del sol.',
                ),
                EscenaBio(
                  titulo: 'La alarma',
                  narracion: 'Cuando un sensor detecta al intruso, algo debe avisar al guardia.',
                  emojis: '🔔👮',
                  pregunta: '¿Qué componente es la salida de la alarma?',
                  opciones: ['El zumbador', 'El sensor PIR', 'La pila'],
                  correcta: 0,
                  explicacion: 'El zumbador hace el sonido: es la salida.',
                ),
                EscenaBio(
                  titulo: '¡Atrapado!',
                  narracion: 'La alarma sonó y el guardia descubrió al intruso: ¡era un gato que entraba por la ventana!',
                  emojis: '🐈😹',
                  pregunta: '¿Qué hizo el Arduino en este sistema?',
                  opciones: ['Recibió la señal del sensor y decidió sonar la alarma', 'Dio la energía', 'Detectó el calor'],
                  correcta: 0,
                  explicacion: 'Es el proceso: el cerebro del sistema.',
                ),
              ],
              mensajeFinal: '¡Caso cerrado, detective!',
            )),
        PasoBio('Supercerebro de sensores', TipoPasoBio.reto, 'e3_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFC2185B),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué sensor da más voltaje cuando hace más calor?',
                    opciones: ['El sensor de temperatura', 'El sensor de luz', 'El ultrasónico'],
                    correcta: 0,
                    explicacion: 'El TMP36 da 10 milivoltios más por cada grado.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'En un sistema automático, ¿qué parte es el sensor?',
                    opciones: ['La entrada', 'El proceso', 'La salida'],
                    correcta: 0,
                    explicacion: 'Recoge la información.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué animal usa algo parecido al sensor ultrasónico?',
                    opciones: ['El murciélago', 'La tortuga', 'La gallina'],
                    correcta: 0,
                    explicacion: 'Se orienta con el eco de sus chillidos.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué detecta el sensor PIR?',
                    opciones: ['El calor que se mueve', 'El color', 'El sabor'],
                    correcta: 0,
                    explicacion: 'Por eso detecta personas y animales.',
                  ),
                ], color: const Color(0xFFC2185B), instruccion: 'Demuestra todo lo que sabes de sensores.'),
              ],
              mensajeFinal: '¡Eres un Detective Electrónico!',
            )),
      ],
    ),
  ],
);
