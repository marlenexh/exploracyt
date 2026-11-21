import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'circuito.dart';
import 'ele_tema1.dart' show pz, taller, abiertoYListo;
import 'fondos.dart';
import 'ilustraciones_ele.dart';
import 'taller.dart';

/// Electrónica · Tema 2: Conecta y enciende.

const _c1 = Color(0xFF1E88E5);
const _c2 = Color(0xFF8E24AA);
const _c3 = Color(0xFFD81B60);
const _ci = Color(0xFF3949AB);

final eleTema2 = TemaBio(
  numero: 2,
  mundo: 'ele',
  estilo: estiloEle(FondoEle.ciudad),
  titulo: 'Conecta y enciende',
  saludo: 'La ciudad de los circuitos necesita tu ayuda para volver a encender sus luces. ¡Vamos a descubrir qué es un circuito, cómo viaja la corriente y cómo se conectan los componentes!',
  misionDelTema: 'Una tormenta apagó la ciudad de los circuitos. Aprende cómo fluye la corriente, arma circuitos en serie y en paralelo y encuentra las fallas para encender cada barrio.',
  color: _ci,
  insignia: 'Maestro de los Circuitos',
  emojiInsignia: '⚡',
  emojisPanel: const ['🏙️', '💡', '🔋', '〰️', '🔌'],
  videos: const {
    'circuitos_1': 'assets/videos/circuitos_que_es.mp4',
    'circuitos_2': 'assets/videos/circuitos_serie_paralelo.mp4',
    'circuitos_3': 'assets/videos/circuitos_conductores.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es un circuito?',
      emoji: '🔁',
      color: _c1,
      intro: 'Para encender una luz, la corriente necesita un camino completo. ¡Descubre qué es un circuito eléctrico!',
      mensajeFinal: '¡Ya sabes cómo viaja la corriente por un circuito!',
      pasos: [
        PasoBio('El circuito eléctrico', TipoPasoBio.explicacion, 'e2_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Circuito',
              titulo: '¿Qué es un circuito?',
              color: _c1,
              il: ilCircuitoSimple,
              textos: const [
                'Un circuito eléctrico es un camino cerrado por donde viaja la corriente eléctrica. La corriente es el movimiento de partículas diminutas llamadas electrones.',
                'Todo circuito tiene una fuente de energía (la pila), conductores (los cables), un receptor que aprovecha la energía (el LED) y, muchas veces, un control (el interruptor).',
                'La corriente sale del polo + de la pila, recorre los cables y los componentes, y regresa al polo −. Si el camino se rompe en cualquier punto, la corriente se detiene: es un circuito abierto.',
                'Cuando apagas la luz de tu cuarto, el interruptor abre el circuito. Al encenderla, lo cierra y la corriente vuelve a llegar al foco.',
              ],
              izquierda: const [
                Parte('pila', 'Fuente', '(la pila)', '🔋', Color(0xFF263238), 'Empuja la corriente. Sin fuente no hay corriente.'),
                Parte('cable', 'Conductores', '(los cables)', '〰️', Color(0xFF2E7D32), 'Llevan la corriente de un componente a otro. Por dentro son de cobre.'),
              ],
              derecha: const [
                Parte('interruptor', 'Control', '(interruptor)', '🎚️', Color(0xFF546E7A), 'Abre o cierra el camino.'),
                Parte('resistencia', 'Resistencia', '(protección)', '🛡️', Color(0xFF8D6E63), 'Limita la corriente que llega al LED.'),
                Parte('led', 'Receptor', '(el LED)', '💡', Color(0xFFE53935), 'Transforma la energía eléctrica en luz.'),
              ],
              resaltar: const {
                1: {'pila', 'cable', 'led', 'interruptor'},
                2: {'cable'},
                3: {'interruptor'},
              },
              mensajeFinal: '¡Conociste las partes de un circuito! Ahora conoce tres palabras clave.',
            )),
        PasoBio('Corriente, voltaje y resistencia', TipoPasoBio.explicacion, 'e2_m1_tarj', (a) => tarjetas(
              a,
              seccion: '2. Palabras clave',
              titulo: 'Corriente, voltaje y resistencia',
              color: _c1,
              textoZati: 'Imagina el circuito como una tubería con agua. Así es más fácil entender estas palabras. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Tres palabras clave', _c1, Icons.bolt_rounded, [
                  TarjetaInfo(Icons.water_rounded, 'Corriente', 'Es la electricidad que fluye, como el agua por el tubo. Se mide en amperios (A).'),
                  TarjetaInfo(Icons.compress_rounded, 'Voltaje', 'Es el empuje que da la pila, como la fuerza de una bomba de agua. Se mide en voltios (V).'),
                  TarjetaInfo(Icons.filter_alt_rounded, 'Resistencia', 'Es lo que frena la corriente, como un tubo angosto. Se mide en ohmios (Ω).'),
                ]),
                GrupoTarjetas('Abierto o cerrado', Color(0xFF00897B), Icons.sync_alt_rounded, [
                  TarjetaInfo(Icons.link_rounded, 'Circuito cerrado', 'El camino está completo: la corriente circula y el LED enciende.'),
                  TarjetaInfo(Icons.link_off_rounded, 'Circuito abierto', 'Hay un corte: un cable suelto o el interruptor apagado.'),
                  TarjetaInfo(Icons.speed_rounded, 'Multímetro', 'Aparato que mide voltaje y corriente. Tinkercad tiene uno.'),
                ]),
              ],
              mensajeFinal: 'La pila empuja (voltaje), la electricidad fluye (corriente) y la resistencia la frena.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e2_m1_video', (a) => video(a,
            clave: 'circuitos_1', titulo: 'Video: el circuito eléctrico', tema: 'qué es un circuito y cómo fluye la corriente', siguiente: '¡A encender el primer barrio!')),
        PasoBio('Enciende el barrio', TipoPasoBio.simulacion, 'e2_m1_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: 'Enciende el barrio',
              color: _c1,
              mensajeFinal: 'Cerraste circuitos y encontraste una falla. ¡Los ingenieros hacen eso todos los días!',
              retos: [
                RetoCircuito(
                  titulo: 'Circuito con interruptor',
                  instruccion: 'Arma un circuito cerrado: pila → interruptor → resistencia → LED → pila. Simula y toca el interruptor para encender y apagar.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 80, 240), pz('sw', TipoPieza.interruptor, 210, 100), pz('r', TipoPieza.resistencia, 390, 100), pz('led', TipoPieza.led, 520, 220)],
                  condiciones: [
                    Condicion('Circuito cerrado: el LED enciende', (e) => e.encendido('led') && e.piezas['sw']!.cerrado),
                    Condicion('Circuito abierto: el LED se apaga', (e) => abiertoYListo(e, 'sw')),
                  ],
                  logro: 'El interruptor abre y cierra el camino de la corriente.',
                ),
                RetoCircuito(
                  titulo: 'Encuentra la falla',
                  instruccion: 'Este circuito ya está armado… ¡pero no enciende! Simula, observa los puntitos de corriente y encuentra qué cable falta.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 80, 240), pz('sw', TipoPieza.interruptor, 210, 100)..cerrado = true, pz('r', TipoPieza.resistencia, 390, 100), pz('led', TipoPieza.led, 520, 220)],
                  cables: const [('pila.0', 'sw.0'), ('sw.1', 'r.0'), ('led.1', 'pila.1')],
                  condiciones: [Condicion('Reparaste la falla: el LED enciende', (e) => e.encendido('led'))],
                  logro: 'Faltaba unir la resistencia con el ánodo del LED: el circuito estaba abierto.',
                ),
              ],
            )),
        PasoBio('El viaje de la corriente', TipoPasoBio.juego, 'e2_m1_ord', (a) => ordenar(
              a,
              seccion: '3. El recorrido',
              titulo: 'El viaje de la corriente',
              color: _c1,
              instruccion: 'Ordena el recorrido de la corriente en el circuito del barrio.',
              pasos: const [
                ('🔋', 'Sale del polo + de la pila'),
                ('〰️', 'Viaja por el cable'),
                ('🎚️', 'Cruza el interruptor cerrado'),
                ('🛡️', 'Pasa por la resistencia'),
                ('💡', 'Enciende el LED'),
                ('➖', 'Regresa al polo −'),
              ],
              explicacion: 'La corriente da la vuelta completa: por eso se llama circuito.',
              mensajeFinal: '¡Sigues el viaje de la corriente!',
              ciclo: true,
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e2_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilCircuitoSimple, const {'pila': 'Fuente', 'cable': 'Conductor', 'interruptor': 'Control', 'resistencia': 'Resistencia', 'led': 'Receptor'}, color: _c1),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué es un circuito abierto?',
                    opciones: ['Un circuito con el camino cortado: no pasa corriente', 'Un circuito muy grande', 'Un circuito con dos pilas'],
                    correcta: 0,
                    explicacion: 'Si el camino se rompe, la corriente se detiene.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué empuja a la corriente por el circuito?',
                    opciones: ['El voltaje de la pila', 'El color del cable', 'El LED'],
                    correcta: 0,
                    explicacion: 'La pila da el empuje: el voltaje.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Sabes qué es un circuito y cómo fluye la corriente.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Serie y paralelo',
      emoji: '🔀',
      color: _c2,
      intro: 'Las calles tienen muchas lámparas. ¿Cómo se conectan varias luces? ¡En serie o en paralelo!',
      mensajeFinal: '¡Ya sabes conectar en serie y en paralelo!',
      pasos: [
        PasoBio('Serie y paralelo', TipoPasoBio.explicacion, 'e2_m2_exp', (a) => explicacion(
              a,
              seccion: '1. Conexiones',
              titulo: 'Serie y paralelo',
              color: _c2,
              il: ilSerieParalelo,
              textos: const [
                'Hay dos formas de conectar varios componentes. En serie van uno detrás de otro, en un solo camino. En paralelo, cada uno tiene su propio camino.',
                'En serie, si un foco se funde o se desconecta, todos se apagan. En paralelo, si uno falla, los demás siguen encendidos.',
                'En serie el voltaje de la pila se reparte entre los componentes, por eso brillan menos. En paralelo cada uno recibe el voltaje completo y brilla más, pero la pila se gasta más rápido.',
                'Los focos y contactos de tu casa están en paralelo: puedes apagar uno sin apagar los demás. Algunas series de luces de Navidad están en serie.',
              ],
              izquierda: const [
                Parte('serie', 'En serie', '(un solo camino)', '➡️', Color(0xFF2E7D32), 'La corriente pasa por un LED y luego por el otro. Es la misma corriente para todos.'),
              ],
              derecha: const [
                Parte('paralelo', 'En paralelo', '(varios caminos)', '🔀', Color(0xFF1565C0), 'La corriente se divide: una parte va por cada camino.'),
              ],
              resaltar: const {
                1: {'serie'},
                2: {'paralelo'},
              },
              mensajeFinal: '¡Ahora arma los dos tipos de circuito!',
            )),
        PasoBio('Arma serie y paralelo', TipoPasoBio.simulacion, 'e2_m2_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: 'Luces de la avenida',
              color: _c2,
              mensajeFinal: 'Armaste circuitos en serie y en paralelo. ¿Notaste que en paralelo brillan más?',
              retos: [
                RetoCircuito(
                  titulo: 'En serie',
                  instruccion: 'Conecta los dos LED EN SERIE: pila + → resistencia → LED 1 → LED 2 → pila −. Recuerda: ánodo (pata doblada) hacia el +.',
                  piezas: () => [pz('pila', TipoPieza.pila9v, 80, 240), pz('r', TipoPieza.resistencia, 220, 90), pz('a', TipoPieza.led, 380, 150), pz('b', TipoPieza.led, 520, 230, color: ColorLed.verde)],
                  condiciones: [Condicion('Los dos LED encienden en serie', (e) => e.encendido('a') && e.encendido('b') && (e.corriente('a') - e.corriente('b')).abs() < 0.001)],
                  logro: 'En serie la misma corriente pasa por los dos LED.',
                ),
                RetoCircuito(
                  titulo: 'En paralelo',
                  instruccion: 'Ahora conecta cada LED con SU PROPIA resistencia, cada uno en un camino distinto desde el + hasta el − de la pila.',
                  piezas: () => [
                    pz('pila', TipoPieza.pila9v, 70, 240),
                    pz('r1', TipoPieza.resistencia, 250, 80),
                    pz('r2', TipoPieza.resistencia, 250, 220),
                    pz('a', TipoPieza.led, 440, 110),
                    pz('b', TipoPieza.led, 440, 260, color: ColorLed.verde)
                  ],
                  condiciones: [Condicion('Los dos LED brillan al máximo, cada uno en su camino', (e) => e.corriente('a') > 0.026 && e.corriente('b') > 0.026)],
                  logro: 'En paralelo cada LED recibe todo el voltaje de la pila.',
                ),
              ],
            )),
        PasoBio('¿Serie o paralelo?', TipoPasoBio.laboratorio, 'e2_m2_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Serie o paralelo?',
              color: _c2,
              instruccion: 'Arrastra cada ejemplo al tipo de conexión que usa.',
              grupos: const [GrupoClasificar('En serie', '➡️', Color(0xFF2E7D32)), GrupoClasificar('En paralelo', '🔀', Color(0xFF1565C0))],
              items: const [
                ItemClasificar('🎄', 'Luces de Navidad antiguas', 0, 'Si se fundía un foquito, se apagaba toda la serie.'),
                ItemClasificar('🔦', 'Pilas de una linterna', 0, 'Van una tras otra para sumar su voltaje.'),
                ItemClasificar('📺', 'Pilas del control remoto', 0, 'También van en serie para sumar voltaje.'),
                ItemClasificar('🏠', 'Focos de tu casa', 1, 'Puedes apagar uno sin apagar los demás.'),
                ItemClasificar('🔌', 'Contactos de la pared', 1, 'Cada contacto recibe el voltaje completo.'),
                ItemClasificar('🚗', 'Faros del coche', 1, 'Si se funde uno, el otro sigue encendido.'),
              ],
              mensajeFinal: 'En serie: un camino. En paralelo: varios caminos.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e2_m2_video', (a) => video(a,
            clave: 'circuitos_2', titulo: 'Video: serie y paralelo', tema: 'cómo se conectan varios componentes', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e2_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseEtiquetar(ilSerieParalelo, const {'serie': 'En serie', 'paralelo': 'En paralelo'}, color: _c2, instruccion: 'Identifica cada tipo de conexión.'),
                faseRelacionar(const [
                  ('En serie', 'Un solo camino: si uno falla, se apagan todos.'),
                  ('En paralelo', 'Varios caminos: si uno falla, los demás siguen.'),
                  ('Circuito abierto', 'El camino está cortado.'),
                  ('Circuito cerrado', 'La corriente circula completa.'),
                ], color: _c2, instruccion: 'Relaciona cada término con su significado.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'En tu casa se fundió el foco de la cocina, pero la sala sigue iluminada. ¿Cómo están conectados?',
                    opciones: ['En paralelo', 'En serie', 'No están conectados'],
                    correcta: 0,
                    explicacion: 'Cada foco tiene su propio camino.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Distingues los circuitos en serie y en paralelo.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Conductores y seguridad',
      emoji: '🛡️',
      color: _c3,
      intro: 'No todos los materiales dejan pasar la corriente. ¡Descubre los conductores, los aislantes y cómo evitar un cortocircuito!',
      mensajeFinal: '¡Sabes usar la electricidad con seguridad!',
      pasos: [
        PasoBio('Conductores y aislantes', TipoPasoBio.explicacion, 'e2_m3_exp', (a) => explicacion(
              a,
              seccion: '1. Materiales',
              titulo: 'Conductores y aislantes',
              color: _c3,
              il: ilConductores,
              textos: const [
                'Los conductores son materiales que dejan pasar la corriente con facilidad, como los metales. Los aislantes casi no la dejan pasar, como el plástico, la madera seca y la goma.',
                'Los cables tienen cobre por dentro (conductor) para llevar la corriente y plástico por fuera (aislante) para protegernos.',
                'Si unes el + y el − de la pila directamente con un cable, la corriente no pasa por ningún componente: es un cortocircuito. La corriente es enorme y los cables y la pila se calientan.',
                'Los electricistas usan guantes y herramientas con mango de goma. El agua de la llave tiene sales que conducen: por eso nunca toques aparatos con las manos mojadas.',
              ],
              izquierda: const [
                Parte('metal', 'Metales', '(conductores)', '📎', Color(0xFF607D8B), 'Clips, llaves, monedas y papel aluminio dejan pasar la corriente.'),
                Parte('plastico', 'Plástico', '(aislante)', '🧴', Color(0xFF7E57C2), 'Recubre los cables para que no nos pase la corriente.'),
              ],
              derecha: const [
                Parte('cobre', 'Cobre', '(conductor)', '🔌', Color(0xFFB87333), 'El metal de los cables: conduce muy bien.'),
                Parte('agua', 'Agua con sales', '(conduce)', '💧', Color(0xFF29B6F6), 'El agua de la llave conduce: ¡peligro con la electricidad!'),
                Parte('goma', 'Goma', '(aislante)', '🧤', Color(0xFFE65100), 'Por eso los electricistas usan guantes de goma.'),
                Parte('madera', 'Madera seca', '(aislante)', '🪵', Color(0xFF8D6E63), 'No deja pasar la corriente.'),
              ],
              resaltar: const {
                1: {'cobre', 'plastico'},
                3: {'agua', 'goma'},
              },
              mensajeFinal: '¡Ahora clasifica materiales!',
            )),
        PasoBio('¿Conductor o aislante?', TipoPasoBio.laboratorio, 'e2_m3_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Conductor o aislante?',
              color: _c3,
              instruccion: 'Arrastra cada objeto al grupo correcto.',
              grupos: const [GrupoClasificar('Conductor', '⚡', Color(0xFF2E7D32)), GrupoClasificar('Aislante', '🚫', Color(0xFFC62828))],
              items: const [
                ItemClasificar('📎', 'Clip de metal', 0, 'El metal conduce.'),
                ItemClasificar('🪙', 'Moneda', 0, 'Las monedas son de metal.'),
                ItemClasificar('🔑', 'Llave', 0, 'La llave es de metal.'),
                ItemClasificar('✏️', 'Punta de lápiz', 0, '¡Sorpresa! El grafito del lápiz conduce un poco.'),
                ItemClasificar('📏', 'Regla de plástico', 1, 'El plástico es aislante.'),
                ItemClasificar('🧤', 'Guante de goma', 1, 'La goma no deja pasar la corriente.'),
                ItemClasificar('🪵', 'Madera seca', 1, 'La madera seca es aislante.'),
                ItemClasificar('🎈', 'Globo', 1, 'El hule del globo es aislante.'),
              ],
              mensajeFinal: 'Metales: conductores. Plástico, goma y madera: aislantes.',
            )),
        PasoBio('¡Cuidado, cortocircuito!', TipoPasoBio.simulacion, 'e2_m3_taller', (a) => taller(
              a,
              seccion: 'Simulación',
              titulo: '¡Cuidado, cortocircuito!',
              color: _c3,
              mensajeFinal: 'Viste un cortocircuito en la simulación, donde no hay peligro. En la vida real, ¡nunca unas el + y el − directamente!',
              retos: [
                RetoCircuito(
                  titulo: 'Cortocircuito',
                  instruccion: 'En la simulación es seguro: une con un cable el + y el − de la pila y simula para ver qué pasa. Luego quita ese cable y arma un circuito seguro con el LED.',
                  quemarEsError: false,
                  piezas: () => [pz('pila', TipoPieza.pila9v, 100, 240), pz('r', TipoPieza.resistencia, 300, 100), pz('led', TipoPieza.led, 480, 210)],
                  condiciones: [
                    Condicion('Observa un cortocircuito', (e) => e.cortocircuito),
                    Condicion('Circuito seguro: el LED enciende', (e) => e.encendido('led') && !e.cortocircuito),
                  ],
                  logro: 'En un cortocircuito la corriente no pasa por ningún componente y la pila se calienta.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'e2_m3_video', (a) => video(a,
            clave: 'circuitos_3', titulo: 'Video: conductores y aislantes', tema: 'qué materiales conducen y cómo protegernos', siguiente: '¡A atrapar conductores!')),
        PasoBio('Atrapa los conductores', TipoPasoBio.juego, 'e2_m3_juego', (a) => atrapar(
              a,
              titulo: 'Atrapa los conductores',
              instrucciones: 'Mueve el imán con tu dedo. Atrapa solo los objetos que conducen la electricidad.',
              color: _c3,
              recolector: '🧲',
              cosas: const [
                CosaQueCae('📎', true),
                CosaQueCae('🔑', true),
                CosaQueCae('🪙', true),
                CosaQueCae('🥄', true),
                CosaQueCae('🔩', true),
                CosaQueCae('🧸', false, mensaje: 'La tela del osito es aislante.'),
                CosaQueCae('🪵', false, mensaje: 'La madera seca es aislante.'),
                CosaQueCae('🧤', false, mensaje: 'La goma es aislante.'),
                CosaQueCae('🎈', false, mensaje: 'El globo es aislante.'),
              ],
              mensajeFinal: '¡Encontraste todos los conductores!',
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'e2_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseAcciones('Electricidad segura en casa', 'Toca las acciones seguras y presiona “Comprobar”.', const [
                  Accion(Icons.power_rounded, 'Desconectar jalando la clavija, no el cable', true, 'Así no se dañan los cables.'),
                  Accion(Icons.back_hand_rounded, 'Secarse las manos antes de usar aparatos', true, 'El agua conduce la electricidad.'),
                  Accion(Icons.report_rounded, 'Avisar a un adulto si un cable está pelado', true, 'Un cable sin aislante es peligroso.'),
                  Accion(Icons.air_rounded, 'Volar papalotes lejos de los cables de luz', true, 'Los cables de la calle tienen mucho voltaje.'),
                  Accion(Icons.electrical_services_rounded, 'Conectar muchos aparatos en un solo contacto', false, 'Se calientan los cables y puede haber un incendio.'),
                  Accion(Icons.bathtub_rounded, 'Usar la secadora de pelo en la tina', false, '¡Agua y electricidad juntas son muy peligrosas!'),
                  Accion(Icons.cable_rounded, 'Unir los polos de una pila con un clip', false, 'Es un cortocircuito: se calienta.'),
                ], color: _c3),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Por qué los cables tienen plástico por fuera?',
                    opciones: ['Porque el plástico es aislante y nos protege', 'Para que sean más pesados', 'Para conducir mejor'],
                    correcta: 0,
                    explicacion: 'El cobre de adentro conduce y el plástico aísla.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Conoces los conductores, los aislantes y cómo protegerte.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La ciudad a oscuras',
      emoji: '🏆',
      color: Color(0xFFFF6F00),
      intro: '¡Último desafío! Ayuda a los técnicos a encender de nuevo la ciudad de los circuitos.',
      mensajeFinal: '¡La ciudad de los circuitos brilla otra vez!',
      pasos: [
        PasoBio('La ciudad a oscuras', TipoPasoBio.reto, 'e2_int_sit', (a) => situacion(
              a,
              titulo: 'La ciudad a oscuras',
              color: const Color(0xFFFF6F00),
              escenas: const [
                EscenaBio(
                  titulo: 'La calle apagada',
                  narracion: 'En la calle principal todas las lámparas se apagaron cuando se fundió solo una.',
                  emojis: '🏮🏮🏮',
                  pregunta: '¿Cómo estaban conectadas?',
                  opciones: ['En serie', 'En paralelo', 'No tenían cables'],
                  correcta: 0,
                  explicacion: 'En serie hay un solo camino: si uno falla, se apagan todos.',
                ),
                EscenaBio(
                  titulo: 'La mejor solución',
                  narracion: 'Los técnicos quieren que, si falla una lámpara, las demás sigan encendidas.',
                  emojis: '👷💡',
                  pregunta: '¿Cómo deben conectarlas?',
                  opciones: ['En paralelo', 'En serie', 'Con un solo cable'],
                  correcta: 0,
                  explicacion: 'En paralelo cada lámpara tiene su propio camino.',
                ),
                EscenaBio(
                  titulo: 'El cable roto',
                  narracion: 'En otro barrio encontraron un cable cortado por la tormenta.',
                  emojis: '〰️✂️',
                  pregunta: '¿Qué tipo de circuito se formó?',
                  opciones: ['Un circuito abierto', 'Un circuito cerrado', 'Un circuito en paralelo'],
                  correcta: 0,
                  explicacion: 'El camino está cortado: la corriente no puede pasar.',
                ),
                EscenaBio(
                  titulo: 'Herramientas',
                  narracion: 'Para reparar el cable, el técnico elige sus herramientas.',
                  emojis: '🧤🔧',
                  pregunta: '¿Qué debe usar para protegerse?',
                  opciones: ['Guantes y pinzas con mango de goma', 'Guantes mojados', 'Una cuchara de metal'],
                  correcta: 0,
                  explicacion: 'La goma es aislante.',
                ),
                EscenaBio(
                  titulo: 'Las chispas',
                  narracion: 'Un vecino unió dos cables pelados y saltaron chispas.',
                  emojis: '⚡😱',
                  pregunta: '¿Qué pasó?',
                  opciones: ['Un cortocircuito', 'Un circuito en serie', 'Nada peligroso'],
                  correcta: 0,
                  explicacion: 'La corriente tomó un atajo sin pasar por ningún aparato.',
                ),
              ],
              mensajeFinal: '¡Encendiste la ciudad!',
            )),
        PasoBio('Supercerebro de circuitos', TipoPasoBio.reto, 'e2_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFFF6F00),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Hacia dónde viaja la corriente en un circuito con pila?',
                    opciones: ['Del polo + al polo − pasando por los componentes', 'Solo dentro de la pila', 'Del LED al aire'],
                    correcta: 0,
                    explicacion: 'Recorre todo el circuito.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿En qué unidad se mide la resistencia?',
                    opciones: ['Voltios', 'Ohmios', 'Metros'],
                    correcta: 1,
                    explicacion: 'Su símbolo es Ω.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Cuál es un material aislante?',
                    opciones: ['El cobre', 'La goma', 'El aluminio'],
                    correcta: 1,
                    explicacion: 'La goma no deja pasar la corriente.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'En paralelo, ¿qué pasa si un LED se desconecta?',
                    opciones: ['Los demás siguen encendidos', 'Se apagan todos', 'La pila explota'],
                    correcta: 0,
                    explicacion: 'Cada LED tiene su propio camino.',
                  ),
                ], color: const Color(0xFFFF6F00), instruccion: 'Demuestra todo lo que sabes de circuitos.'),
              ],
              mensajeFinal: '¡Eres un Maestro de los Circuitos!',
            )),
      ],
    ),
  ],
);
