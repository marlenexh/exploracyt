import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import '../ciencia/escena.dart';
import 'circuito.dart';
import 'fondos.dart';
import 'ilustraciones_ele.dart';
import 'sims_ele.dart';
import 'taller.dart';

/// Electrónica · Tema 1: Conoce los componentes.

const _c1 = Color(0xFFFF8F00);
const _c2 = Color(0xFFE53935);
const _c3 = Color(0xFF00897B);
const _ci = Color(0xFFEF6C00);

Pieza pz(String id, TipoPieza t, double x, double y, {double ohms = 220, bool editable = false, ColorLed color = ColorLed.rojo, double pot = 0.5}) =>
    Pieza(id, t, Offset(x, y), ohms: ohms, editable: editable, colorLed: color, posicion: pot, escala: 1.45);

Widget taller(String a,
        {required String seccion, required String titulo, required Color color, required List<RetoCircuito> retos, required String mensajeFinal}) =>
    TallerCircuitos(actividad: a, seccion: seccion, titulo: titulo, color: color, retos: retos, mensajeFinal: mensajeFinal);

/// La electrónica en la vida diaria: la electricidad viaja por circuitos
/// dentro de los aparatos.
final ilElectronica = escena(const [
  ObjEscena('rayo', '⚡', 0.5, 0.14, tam: 0.18, anim: Anim.latir),
  ObjEscena('celular', '📱', 0.2, 0.42, tam: 0.15),
  ObjEscena('control', '🎮', 0.8, 0.42, tam: 0.15),
  ObjEscena('circuito', '🔌', 0.5, 0.56, tam: 0.15, anim: Anim.nada),
  ObjEscena('robot', '🤖', 0.22, 0.84, tam: 0.15),
  ObjEscena('compu', '💻', 0.78, 0.84, tam: 0.15),
], fondo: const [
  Color(0xFFFFF3E0),
  Color(0xFFFFE0B2)
], antes: _caminos);

void _caminos(Canvas c, Rect r, double t, double s) {
  final cen = en(r, 0.5, 0.56);
  for (final p in const [Offset(0.5, 0.14), Offset(0.2, 0.42), Offset(0.8, 0.42), Offset(0.22, 0.84), Offset(0.78, 0.84)]) {
    final a = en(r, p.dx, p.dy);
    c.drawLine(
        a,
        cen,
        Paint()
          ..color = const Color(0x66FF8F00)
          ..strokeWidth = 3 * s);
    final f = (t * 0.6 + p.dx + p.dy) % 1;
    c.drawCircle(Offset.lerp(cen, a, f)!, 4 * s, Paint()..color = const Color(0xFFFFD54F));
  }
}

/// Interruptor abierto, pero el resto del circuito ya está conectado.
bool abiertoYListo(EstadoCircuito e, String sw) => !e.piezas[sw]!.cerrado && e.voltaje(sw).abs() > 1;

final eleTema1 = TemaBio(
  numero: 1,
  mundo: 'ele',
  estilo: estiloEle(FondoEle.taller),
  titulo: 'Conoce los componentes',
  saludo:
      'El celular, la tele, los videojuegos y los robots funcionan gracias a la electrónica. ¡Vamos a descubrir qué es, a conocer sus piezas más importantes (el LED, la resistencia, la pila, el interruptor y más) y a armar circuitos como en Tinkercad!',
  misionDelTema:
      'El taller de Zati está lleno de piezas revueltas. Aprende a reconocer cada componente y para qué sirve para construir tu primer aparato: una linterna.',
  color: _ci,
  insignia: 'Conocedor de Componentes',
  emojiInsignia: '🔌',
  emojisPanel: const ['🔋', '💡', '🎛️', '🔊', '⚙️'],
  videos: const {
    'componentes_1': 'assets/videos/componentes_basicos.mp4',
    'componentes_2': 'assets/videos/componentes_led_resistencia.mp4',
    'componentes_3': 'assets/videos/componentes_pilas_interruptores.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'La caja de componentes',
      emoji: '🧰',
      color: _c1,
      intro: 'Abramos la caja de componentes del taller. ¿Qué es cada pieza y qué trabajo hace?',
      mensajeFinal: '¡Ya reconoces los componentes básicos!',
      pasos: [
        PasoBio(
            '¿Qué es la electrónica?',
            TipoPasoBio.explicacion,
            'e1_m1_intro',
            (a) => explicacion(
                  a,
                  seccion: '1. Electrónica',
                  titulo: '¿Qué es la electrónica?',
                  color: _c1,
                  il: ilElectronica,
                  textos: const [
                    'La electrónica es la ciencia y la tecnología que usa la electricidad para hacer que los aparatos funcionen y hagan cosas: encender luces, mostrar imágenes, sonar, moverse o hasta pensar con un programa.',
                    'Gracias a la electrónica existen el celular, la televisión, las computadoras, los videojuegos, los semáforos, los robots y los aparatos que usan los médicos en los hospitales.',
                    'La electricidad viaja por caminos llamados circuitos. En el camino hay piezas pequeñas, los componentes, y cada una tiene un trabajo: dar energía, controlar, proteger o producir luz, sonido y movimiento.',
                    'Dentro de un control remoto, de un juguete que habla o de un reloj digital hay una placa verde llena de componentes unidos por caminos de metal. ¡Eso es electrónica!',
                  ],
                  izquierda: const [
                    Parte('rayo', 'Electricidad', '(la energía)', '⚡', Color(0xFFFFB300),
                        'Es la energía que viaja por los cables y hace funcionar los aparatos.'),
                    Parte('celular', 'Celular', '(electrónica)', '📱', Color(0xFF1E88E5), 'Tiene millones de componentes diminutos.'),
                    Parte('robot', 'Robots', '(se mueven)', '🤖', Color(0xFF7E57C2), 'Usan motores, sensores y un programa.'),
                  ],
                  derecha: const [
                    Parte('circuito', 'Circuito', '(el camino)', '🔌', _c1, 'Camino por donde viaja la electricidad.'),
                    Parte('control', 'Videojuegos', '(diversión)', '🎮', Color(0xFFE53935), 'Botones, luces y pantallas: ¡pura electrónica!'),
                    Parte('compu', 'Computadora', '(procesa)', '💻', Color(0xFF546E7A), 'Sigue programas para hacer muchas tareas.'),
                  ],
                  resaltar: const {
                    1: {'celular', 'control', 'robot', 'compu'},
                    2: {'rayo', 'circuito'},
                  },
                  mensajeFinal: '¡Ahora conoce la herramienta con la que vamos a practicar!',
                )),
        PasoBio(
            '¿Qué es Tinkercad?',
            TipoPasoBio.explicacion,
            'e1_m1_tinkercad',
            (a) => tarjetas(
                  a,
                  seccion: '2. Tinkercad',
                  titulo: 'Tinkercad: un taller en la computadora',
                  color: _c1,
                  textoZati:
                      'Los ingenieros prueban sus circuitos en la computadora antes de construirlos. Nosotros usaremos un taller parecido a Tinkercad. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('¿Qué es Tinkercad?', _c1, Icons.computer_rounded, [
                      TarjetaInfo(Icons.language_rounded, 'Un programa gratuito',
                          'Tinkercad es una página de internet gratuita para diseñar en 3D y armar circuitos electrónicos virtuales.',
                          emoji: '💻'),
                      TarjetaInfo(Icons.electrical_services_rounded, 'Circuits',
                          'En su parte llamada “Circuits” arrastras pilas, LED, cables y motores a una mesa de trabajo, como si fueran de verdad.',
                          emoji: '🔌'),
                      TarjetaInfo(Icons.play_circle_rounded, 'Simular',
                          'Con el botón “Iniciar simulación” el circuito funciona en la pantalla: los LED brillan y los motores giran.',
                          emoji: '▶️'),
                    ]),
                    GrupoTarjetas('¿Por qué usarlo?', Color(0xFF43A047), Icons.thumb_up_alt_rounded, [
                      TarjetaInfo(Icons.health_and_safety_rounded, 'Sin peligro',
                          'Si te equivocas, nada se quema de verdad: solo aparece un aviso y lo vuelves a intentar.',
                          emoji: '🛡️'),
                      TarjetaInfo(Icons.savings_rounded, 'Sin gastar', 'No necesitas comprar piezas para practicar: todas están en la pantalla.', emoji: '🪙'),
                      TarjetaInfo(Icons.build_circle_rounded, 'Nuestro taller',
                          'En este juego tienes un taller de circuitos que funciona como Tinkercad. ¡Ahí armarás tus inventos!',
                          emoji: '🧰'),
                    ]),
                  ],
                  mensajeFinal: '¡Listo! Ahora abre la caja de componentes.',
                )),
        PasoBio(
            '¿Qué son los componentes?',
            TipoPasoBio.explicacion,
            'e1_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '3. Componentes',
                  titulo: 'Los componentes electrónicos',
                  color: _c1,
                  il: ilComponentes,
                  textos: const [
                    'Los componentes electrónicos son las piezas con las que se construyen los aparatos: el control de la tele, un juguete o un celular. Cada uno tiene un trabajo especial.',
                    'Unos dan energía (la pila), otros controlan el paso de la corriente (el interruptor), otros la protegen (la resistencia) y otros producen luz, sonido o movimiento (LED, foco, zumbador y motor).',
                    'Los componentes se unen con cables formando un camino. Por ese camino viaja la corriente eléctrica y cada pieza hace su trabajo cuando la corriente pasa por ella.',
                    'Una linterna tiene pila, interruptor y foco. El control remoto tiene pilas, botones y un LED que no vemos (infrarrojo). ¡Los componentes están en todas partes!',
                  ],
                  izquierda: const [
                    Parte('pila', 'Pila', '(da energía)', '🔋', Color(0xFF455A64),
                        'Guarda energía y la entrega al circuito. Tiene un polo positivo (+) y uno negativo (−).'),
                    Parte('interruptor', 'Interruptor', '(controla)', '🎚️', Color(0xFF546E7A), 'Abre o cierra el camino de la corriente: enciende y apaga.'),
                    Parte('zumbador', 'Zumbador', '(sonido)', '🔊', Color(0xFF424242), 'Convierte la electricidad en sonido, como en los timbres y alarmas.'),
                  ],
                  derecha: const [
                    Parte('led', 'LED', '(luz)', '💡', _c2, 'Pequeña luz que gasta muy poca energía. Está en pantallas, semáforos y juguetes.'),
                    Parte('resistencia', 'Resistencia', '(protege)', '🟫', Color(0xFF8D6E63),
                        'Limita la corriente para que otras piezas, como el LED, no se quemen.'),
                    Parte('motor', 'Motor', '(movimiento)', '🌀', Color(0xFF29B6F6), 'Convierte la electricidad en movimiento: su eje gira.'),
                    Parte('foco', 'Foco', '(luz)', '💡', Color(0xFFFFB300), 'Bombilla que da luz cuando pasa corriente por su filamento.'),
                  ],
                  resaltar: const {
                    1: {'pila', 'interruptor', 'resistencia'},
                    2: {'led', 'motor', 'zumbador'},
                  },
                  mensajeFinal: '¡Conociste los componentes! Ahora descubre qué trabajo hace cada uno.',
                )),
        PasoBio(
            'El trabajo de cada componente',
            TipoPasoBio.explicacion,
            'e1_m1_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '4. ¿Qué hacen?',
                  titulo: 'El trabajo de cada componente',
                  color: _c1,
                  textoZati: 'En el panel de componentes de Tinkercad las piezas se agrupan según su trabajo. Toca cada tarjeta para conocerlas.',
                  grupos: const [
                    GrupoTarjetas('Dan energía', Color(0xFF455A64), Icons.battery_charging_full_rounded, [
                      TarjetaInfo(Icons.battery_full_rounded, 'Pila de 9 V', 'Rectangular, con dos broches arriba: + y −.'),
                      TarjetaInfo(Icons.battery_std_rounded, 'Portapilas', 'Guarda pilas AA; sus cables rojo (+) y negro (−) van al circuito.'),
                      TarjetaInfo(Icons.circle_outlined, 'Pila de botón', 'Pequeña y plana, como la de los relojes.'),
                    ]),
                    GrupoTarjetas('Controlan', Color(0xFF546E7A), Icons.toggle_on_rounded, [
                      TarjetaInfo(Icons.toggle_off_rounded, 'Interruptor', 'Se queda encendido o apagado.'),
                      TarjetaInfo(Icons.radio_button_checked_rounded, 'Botón', 'Funciona solo mientras lo presionas, como un timbre.'),
                      TarjetaInfo(Icons.tune_rounded, 'Potenciómetro', 'Perilla que se gira, como la del volumen.'),
                    ]),
                    GrupoTarjetas('Producen algo', _c2, Icons.auto_awesome_rounded, [
                      TarjetaInfo(Icons.lightbulb_rounded, 'LED y foco', 'Producen luz.'),
                      TarjetaInfo(Icons.volume_up_rounded, 'Zumbador', 'Produce sonido.'),
                      TarjetaInfo(Icons.cyclone_rounded, 'Motor', 'Produce movimiento.'),
                    ]),
                  ],
                  mensajeFinal: '¡Cada componente tiene un trabajo especial en el circuito!',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'e1_m1_video',
            (a) => video(a,
                clave: 'componentes_1',
                titulo: 'Video: componentes electrónicos',
                tema: 'los componentes básicos y su trabajo',
                siguiente: '¡A ordenar el taller!')),
        PasoBio(
            'Ordena la caja',
            TipoPasoBio.laboratorio,
            'e1_m1_clas',
            (a) => clasificar(
                  a,
                  seccion: '5. Clasifica',
                  titulo: 'Ordena la caja de componentes',
                  color: _c1,
                  instruccion: 'Arrastra cada componente al cajón del trabajo que hace.',
                  grupos: const [
                    GrupoClasificar('Dan energía', '🔋', Color(0xFF455A64)),
                    GrupoClasificar('Controlan', '🎛️', Color(0xFF7E57C2)),
                    GrupoClasificar('Luz, sonido o movimiento', '💡', _c2),
                  ],
                  items: const [
                    ItemClasificar('🔋', 'Pila de 9 V', 0, 'La pila da la energía.'),
                    ItemClasificar('🪫', 'Portapilas', 0, 'El portapilas guarda pilas que dan energía.'),
                    ItemClasificar('🎚️', 'Interruptor', 1, 'El interruptor enciende y apaga.'),
                    ItemClasificar('🔘', 'Botón', 1, 'El botón controla mientras lo presionas.'),
                    ItemClasificar('🎛️', 'Potenciómetro', 1, 'El potenciómetro regula girando su perilla.'),
                    ItemClasificar('💡', 'LED', 2, 'El LED produce luz.'),
                    ItemClasificar('🔊', 'Zumbador', 2, 'El zumbador produce sonido.'),
                    ItemClasificar('🌀', 'Motor', 2, 'El motor produce movimiento.'),
                  ],
                  mensajeFinal: 'La resistencia es especial: no da energía ni controla, ¡protege! La verás en la siguiente misión.',
                )),
        PasoBio(
            'Atrapa los componentes',
            TipoPasoBio.juego,
            'e1_m1_juego',
            (a) => atrapar(
                  a,
                  titulo: 'Atrapa los componentes',
                  instrucciones: 'Mueve la caja con tu dedo. Atrapa solo piezas electrónicas y deja caer lo que no sirve para un circuito.',
                  color: _c1,
                  recolector: '🧰',
                  cosas: const [
                    CosaQueCae('🔋', true),
                    CosaQueCae('💡', true),
                    CosaQueCae('🔌', true),
                    CosaQueCae('🎛️', true),
                    CosaQueCae('🔊', true),
                    CosaQueCae('🎚️', true),
                    CosaQueCae('🍌', false, mensaje: 'Un plátano no es un componente electrónico.'),
                    CosaQueCae('🧦', false, mensaje: 'Un calcetín no sirve en un circuito.'),
                    CosaQueCae('🧸', false, mensaje: 'Un osito de peluche no es un componente.'),
                    CosaQueCae('🍪', false, mensaje: 'Una galleta no es un componente electrónico.'),
                  ],
                  mensajeFinal: '¡Tu caja de componentes está lista!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'e1_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(
                        ilComponentes, const {'pila': 'Pila', 'led': 'LED', 'resistencia': 'Resistencia', 'interruptor': 'Interruptor', 'motor': 'Motor'},
                        color: _c1),
                    faseRelacionar(const [
                      ('Pila', 'Da la energía al circuito.'),
                      ('LED', 'Produce luz gastando poca energía.'),
                      ('Resistencia', 'Limita la corriente para proteger.'),
                      ('Interruptor', 'Abre y cierra el circuito.'),
                    ], color: _c1, instruccion: 'Relaciona cada componente con su trabajo.'),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Qué componente convierte la electricidad en movimiento?',
                        opciones: ['El LED', 'El motor', 'La pila'],
                        correcta: 1,
                        explicacion: 'El motor hace girar su eje.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Identificas los componentes y el trabajo de cada uno.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'El LED y la resistencia',
      emoji: '💡',
      color: _c2,
      intro: 'El LED es la luz favorita de los inventores, pero hay que saber conectarlo. ¡Y la resistencia es su guardaespaldas!',
      mensajeFinal: '¡Ya sabes conectar un LED sin quemarlo!',
      pasos: [
        PasoBio(
            'El LED y la resistencia',
            TipoPasoBio.explicacion,
            'e1_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. LED',
                  titulo: 'El LED y la resistencia',
                  color: _c2,
                  il: ilLedResistencia,
                  textos: const [
                    'LED significa “diodo emisor de luz”. Es una luz pequeña que gasta muy poca energía. Tiene dos patas y polaridad: importa cómo lo conectas.',
                    'La resistencia se opone al paso de la corriente. Se conecta junto al LED para que no le llegue demasiada corriente. ¡Es su guardaespaldas!',
                    'La corriente debe entrar por el ánodo (+, la pata larga; en Tinkercad es la pata doblada) y salir por el cátodo (−). Si lo volteas, no enciende. Sin resistencia, el LED se quema: en Tinkercad aparece una explosión.',
                    'Los semáforos, las pantallas, las luces de Navidad y las lámparas modernas usan LED porque duran mucho y ahorran energía.',
                  ],
                  izquierda: const [
                    Parte('domo', 'Cápsula', '(de donde sale la luz)', '💡', _c2, 'Es de plástico de color. Por dentro tiene un chip diminuto que brilla.'),
                    Parte('catodo', 'Cátodo (−)', '(pata recta)', '➖', Color(0xFF212121),
                        'Pata corta. Va hacia el polo negativo (−) de la pila. Del lado del cátodo la cápsula tiene un borde plano.'),
                  ],
                  derecha: const [
                    Parte('anodo', 'Ánodo (+)', '(pata doblada)', '➕', Color(0xFFD32F2F),
                        'Pata larga. Por aquí debe entrar la corriente que viene del polo positivo (+).'),
                    Parte('bandas', 'Franjas de color', '(su valor)', '🌈', Color(0xFF8D6E63),
                        'Las franjas dicen cuánto se opone la resistencia a la corriente. Se mide en ohmios (Ω).'),
                    Parte('resistencia', 'Resistencia', '(protege al LED)', '🛡️', Color(0xFF6D4C41),
                        'Con una pila de 9 V, una resistencia de 220 Ω protege bien a un LED.'),
                  ],
                  resaltar: const {
                    1: {'bandas', 'resistencia'},
                    2: {'anodo', 'catodo'},
                  },
                  mensajeFinal: '¡Conoces al LED y a su guardaespaldas! Ahora aprende a leer las franjas.',
                )),
        PasoBio('Código de colores', TipoPasoBio.laboratorio, 'e1_m2_bandas', (a) => SimBandasResistencia(actividad: a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'e1_m2_video',
            (a) => video(a,
                clave: 'componentes_2',
                titulo: 'Video: el LED y la resistencia',
                tema: 'cómo conectar un LED con su resistencia',
                siguiente: '¡A encender tu primer LED!')),
        PasoBio(
            'Enciende tu primer LED',
            TipoPasoBio.simulacion,
            'e1_m2_taller',
            (a) => taller(
                  a,
                  seccion: 'Simulación',
                  titulo: 'Enciende tu primer LED',
                  color: _c2,
                  mensajeFinal: '¡Encendiste LED como en Tinkercad! Recuerda: ánodo al +, cátodo al − y siempre una resistencia.',
                  retos: [
                    RetoCircuito(
                      titulo: 'Tu primer LED',
                      instruccion:
                          'Une con cables: + de la pila → resistencia → ánodo del LED (pata doblada). Luego cátodo del LED → − de la pila. Después presiona “Iniciar simulación”.',
                      piezas: () => [pz('pila', TipoPieza.pila9v, 90, 230), pz('r', TipoPieza.resistencia, 290, 110), pz('led', TipoPieza.led, 470, 200)],
                      condiciones: [Condicion('El LED enciende sin quemarse', (e) => e.encendido('led'))],
                      logro: 'La corriente sale del +, pasa por la resistencia y entra al LED por el ánodo.',
                    ),
                    RetoCircuito(
                      titulo: '¿Y si lo volteas?',
                      instruccion: 'La pila y la resistencia ya están unidas. Primero conecta el LED AL REVÉS y simula. Luego corrígelo para que encienda.',
                      piezas: () => [pz('pila', TipoPieza.pila9v, 90, 230), pz('r', TipoPieza.resistencia, 290, 110), pz('led', TipoPieza.led, 470, 200)],
                      cables: const [('pila.0', 'r.0')],
                      condiciones: [
                        Condicion('Observa: al revés el LED no enciende', (e) => e.invertido('led')),
                        Condicion('Corrígelo: el LED enciende', (e) => e.encendido('led')),
                      ],
                      logro: 'El LED solo deja pasar la corriente en un sentido: del ánodo al cátodo.',
                    ),
                    RetoCircuito(
                      titulo: 'Elige la resistencia',
                      instruccion: 'Conecta el circuito. Toca la resistencia para cambiar su valor en el Inspector y observa cómo cambia el brillo del LED.',
                      piezas: () => [
                        pz('pila', TipoPieza.pila9v, 90, 230),
                        pz('r', TipoPieza.resistencia, 290, 110, ohms: 1000, editable: true),
                        pz('led', TipoPieza.led, 470, 200, editable: true)
                      ],
                      condiciones: [
                        Condicion('LED con brillo bajo (1 kΩ)', (e) => e.encendido('led') && e.brillo('led') < 0.5),
                        Condicion('LED con brillo fuerte (220 Ω)', (e) => e.brillo('led') > 0.9),
                      ],
                      logro: 'A mayor resistencia, menos corriente y menos brillo.',
                    ),
                  ],
                )),
        PasoBio(
            'Memorama del LED',
            TipoPasoBio.juego,
            'e1_m2_mem',
            (a) => memorama(
                  a,
                  titulo: 'Memorama del LED',
                  color: _c2,
                  instruccion: 'Encuentra cada pareja. Toca dos tarjetas a la vez.',
                  pares: const [
                    ('💡', 'LED', 'Produce luz'),
                    ('➕', 'Ánodo', 'Pata larga, va al +'),
                    ('➖', 'Cátodo', 'Pata corta, va al −'),
                    ('🛡️', 'Resistencia', 'Limita la corriente'),
                    ('🔴', 'Rojo-rojo-marrón', '220 Ω'),
                    ('💥', 'Sin resistencia', 'El LED se quema'),
                  ],
                  mensajeFinal: '¡Memoria de inventor!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'e1_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilLedResistencia, const {'domo': 'Cápsula', 'anodo': 'Ánodo (+)', 'catodo': 'Cátodo (−)', 'bandas': 'Franjas'}, color: _c2),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué se pone una resistencia junto al LED?',
                        opciones: ['Para que brille de colores', 'Para limitar la corriente y que no se queme', 'Para que gire'],
                        correcta: 1,
                        explicacion: 'Sin resistencia pasa demasiada corriente y el LED se quema.',
                      ),
                      PreguntaQuiz(
                        pregunta: 'Conectaste un LED y no enciende, pero no se quemó. ¿Qué revisas primero?',
                        opciones: ['Que el ánodo vaya hacia el + de la pila', 'Que el LED sea azul', 'Que la mesa esté limpia'],
                        correcta: 0,
                        explicacion: 'Si está al revés, el LED no deja pasar la corriente.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Sabes conectar un LED con su resistencia.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Pilas, interruptores y más',
      emoji: '🔋',
      color: _c3,
      intro: 'Para construir una linterna necesitas energía y una forma de encenderla. ¡Conoce las pilas, los interruptores y los botones!',
      mensajeFinal: '¡Construiste una linterna y un timbre!',
      pasos: [
        PasoBio(
            'Energía y control',
            TipoPasoBio.explicacion,
            'e1_m3_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Energía y control',
                  titulo: 'Pilas, interruptores y botones',
                  color: _c3,
                  il: ilEnergiaControl,
                  textos: const [
                    'La pila guarda energía química y la entrega como energía eléctrica. Su fuerza se mide en voltios (V): una pila de 9 V empuja más que dos pilas AA (3 V).',
                    'El interruptor y el botón controlan cuándo pasa la corriente. El potenciómetro deja pasar más o menos corriente según gires su perilla.',
                    'El interruptor se queda en encendido (ON) o apagado (OFF). El botón cierra el circuito solo mientras lo presionas. En la simulación de Tinkercad puedes tocarlos para usarlos.',
                    'Una linterna tiene pilas, un interruptor y un foco. El timbre de tu casa usa un botón. El volumen de una bocina usa un potenciómetro.',
                  ],
                  izquierda: const [
                    Parte('pila9v', 'Pila de 9 V', '(9 voltios)', '🔋', Color(0xFF263238), 'Muy usada en Tinkercad. Sus broches de arriba son el + y el −.'),
                    Parte('interruptor', 'Interruptor', '(ON / OFF)', '🎚️', Color(0xFF546E7A), 'Se desliza para encender o apagar y se queda así.'),
                  ],
                  derecha: const [
                    Parte('pila3v', 'Portapilas', '(3 voltios)', '🪫', Color(0xFF37474F),
                        'Dos pilas AA de 1.5 V juntas dan 3 V. El cable rojo es + y el negro es −.'),
                    Parte('boton', 'Botón', '(mientras presionas)', '🔘', Color(0xFFE53935), 'Al soltarlo, el circuito se abre otra vez.'),
                    Parte('potenciometro', 'Potenciómetro', '(perilla)', '🎛️', Color(0xFF1565C0),
                        'Tiene tres patas. Al girar la perilla cambia su resistencia.'),
                  ],
                  resaltar: const {
                    1: {'interruptor', 'boton', 'potenciometro'},
                    3: {'interruptor'},
                  },
                  mensajeFinal: '¡Ahora construye una linterna y un timbre!',
                )),
        PasoBio(
            'Linterna y timbre',
            TipoPasoBio.simulacion,
            'e1_m3_taller',
            (a) => taller(
                  a,
                  seccion: 'Simulación',
                  titulo: 'Linterna y timbre',
                  color: _c3,
                  mensajeFinal: 'Construiste dos aparatos de verdad: una linterna con interruptor y un timbre con botón.',
                  retos: [
                    RetoCircuito(
                      titulo: 'Linterna',
                      instruccion:
                          'Arma una linterna: une el portapilas, el interruptor y el foco en un solo camino. Simula y toca el interruptor para encender y apagar.',
                      piezas: () => [pz('pila', TipoPieza.pila3v, 100, 230), pz('sw', TipoPieza.interruptor, 300, 100), pz('foco', TipoPieza.foco, 480, 200)],
                      condiciones: [
                        Condicion('El foco enciende con el interruptor', (e) => e.luzFoco('foco') > 0.3 && e.piezas['sw']!.cerrado),
                        Condicion('El foco se apaga al abrir el interruptor', (e) => abiertoYListo(e, 'sw')),
                      ],
                      logro: 'El interruptor abre y cierra el camino de la corriente.',
                    ),
                    RetoCircuito(
                      titulo: 'Timbre',
                      instruccion:
                          'Arma un timbre con la pila de 9 V, el botón y el zumbador (su + va hacia el + de la pila). Simula y mantén presionado el botón.',
                      piezas: () => [pz('pila', TipoPieza.pila9v, 100, 230), pz('b', TipoPieza.boton, 300, 100), pz('z', TipoPieza.zumbador, 480, 200)],
                      condiciones: [
                        Condicion('Suena mientras presionas el botón', (e) => e.suena('z') && e.piezas['b']!.presionado),
                        Condicion('Al soltarlo, se hace silencio', (e) => !e.piezas['b']!.presionado && e.voltaje('b').abs() > 1),
                      ],
                      logro: 'El botón solo cierra el circuito mientras lo presionas.',
                    ),
                  ],
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'e1_m3_video',
            (a) => video(a,
                clave: 'componentes_3',
                titulo: 'Video: pilas e interruptores',
                tema: 'cómo funcionan las pilas, interruptores y botones',
                siguiente: '¡Ordena los pasos!')),
        PasoBio(
            'Pasos en Tinkercad',
            TipoPasoBio.juego,
            'e1_m3_ord',
            (a) => ordenar(
                  a,
                  seccion: '2. Paso a paso',
                  titulo: 'Arma un circuito en Tinkercad',
                  color: _c3,
                  instruccion: 'Ordena los pasos para armar y probar un circuito en Tinkercad Circuits.',
                  pasos: const [
                    ('🆕', 'Crear un circuito nuevo'),
                    ('🧲', 'Arrastrar los componentes'),
                    ('〰️', 'Unir terminales con cables'),
                    ('➕', 'Revisar el + y el −'),
                    ('▶️', 'Iniciar simulación'),
                    ('🔧', 'Observar y corregir'),
                  ],
                  explicacion: 'Si algo no funciona, detén la simulación, corrige y vuelve a probar: así trabajan los ingenieros.',
                  mensajeFinal: '¡Sigues los pasos de un ingeniero!',
                )),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'e1_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseEtiquetar(
                        ilEnergiaControl,
                        const {
                          'pila9v': 'Pila de 9 V',
                          'pila3v': 'Portapilas',
                          'interruptor': 'Interruptor',
                          'boton': 'Botón',
                          'potenciometro': 'Potenciómetro'
                        },
                        color: _c3),
                    faseAcciones(
                        'Experimenta con seguridad',
                        'Toca las acciones seguras para experimentar con electricidad y presiona “Comprobar”.',
                        const [
                          Accion(
                              Icons.battery_full_rounded, 'Usar pilas en los experimentos', true, 'Las pilas tienen poco voltaje: son seguras para aprender.'),
                          Accion(Icons.family_restroom_rounded, 'Pedir ayuda a un adulto', true, 'Un adulto te puede guiar y cuidar.'),
                          Accion(Icons.power_off_rounded, 'Desconectar antes de cambiar piezas', true, 'Así evitas cortocircuitos.'),
                          Accion(Icons.computer_rounded, 'Probar primero en Tinkercad', true, 'En la simulación nada se quema de verdad.'),
                          Accion(Icons.electrical_services_rounded, 'Meter objetos en un enchufe', false, 'La corriente de la casa es muy peligrosa.'),
                          Accion(Icons.water_drop_rounded, 'Tocar aparatos con las manos mojadas', false, 'El agua conduce la electricidad.'),
                          Accion(Icons.content_cut_rounded, 'Abrir o morder una pila', false, 'Tiene sustancias dañinas.'),
                        ],
                        color: _c3),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Qué diferencia hay entre un interruptor y un botón?',
                        opciones: ['El botón solo funciona mientras lo presionas', 'Son exactamente iguales', 'El interruptor hace sonido'],
                        correcta: 0,
                        explicacion: 'El interruptor se queda en ON u OFF; el botón regresa al soltarlo.',
                      ),
                    ], color: _c3),
                  ],
                  mensajeFinal: 'Conoces las fuentes de energía y los componentes de control.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'La linterna de emergencia',
      emoji: '🏆',
      color: Color(0xFF6A1B9A),
      intro: '¡Último desafío! Se fue la luz en la escuela y hay que construir una linterna de emergencia.',
      mensajeFinal: '¡La escuela tiene luz gracias a tu linterna!',
      pasos: [
        PasoBio(
            'La linterna de emergencia',
            TipoPasoBio.reto,
            'e1_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'La linterna de emergencia',
                  color: const Color(0xFF6A1B9A),
                  escenas: const [
                    EscenaBio(
                      titulo: '¡Se fue la luz!',
                      narracion: 'Durante una tormenta se va la luz en el salón. La maestra encuentra una caja con piezas electrónicas.',
                      emojis: '⛈️🧰',
                      pregunta: '¿Qué componente dará la energía a la linterna?',
                      opciones: ['El interruptor', 'La pila', 'La resistencia'],
                      correcta: 1,
                      explicacion: 'La pila es la fuente de energía.',
                    ),
                    EscenaBio(
                      titulo: 'La luz',
                      narracion: 'Quieren una luz que gaste poca energía para que la pila dure toda la noche.',
                      emojis: '💡🔋',
                      pregunta: '¿Qué componente conviene usar?',
                      opciones: ['Un LED', 'Un motor', 'Un zumbador'],
                      correcta: 0,
                      explicacion: 'El LED da luz y gasta muy poca energía.',
                    ),
                    EscenaBio(
                      titulo: 'El guardaespaldas',
                      narracion: 'Van a usar una pila de 9 V. Mateo quiere conectar el LED directo a la pila.',
                      emojis: '🧒💥',
                      pregunta: '¿Qué le falta al circuito?',
                      opciones: ['Una resistencia para que el LED no se queme', 'Otro LED', 'Nada'],
                      correcta: 0,
                      explicacion: 'La resistencia limita la corriente.',
                    ),
                    EscenaBio(
                      titulo: 'No enciende',
                      narracion: 'Armaron el circuito, pero el LED no prende y tampoco se quemó.',
                      emojis: '🤔💡',
                      pregunta: '¿Qué pudo pasar?',
                      opciones: ['El LED está al revés', 'La pila es demasiado nueva', 'El cable es verde'],
                      correcta: 0,
                      explicacion: 'El ánodo (pata larga) debe ir hacia el + de la pila.',
                    ),
                    EscenaBio(
                      titulo: 'Encender y apagar',
                      narracion: 'La linterna ya funciona, pero quieren apagarla para ahorrar pila.',
                      emojis: '🔦🎚️',
                      pregunta: '¿Qué componente agregan?',
                      opciones: ['Un interruptor', 'Un motor', 'Una segunda pila'],
                      correcta: 0,
                      explicacion: 'El interruptor abre el circuito para apagar.',
                    ),
                  ],
                  mensajeFinal: '¡La linterna de emergencia funciona!',
                )),
        PasoBio(
            'Supercerebro de componentes',
            TipoPasoBio.reto,
            'e1_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF6A1B9A),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Qué significa LED?',
                        opciones: ['Diodo emisor de luz', 'Lámpara eléctrica doble', 'Luz en descanso'],
                        correcta: 0,
                        explicacion: 'Light Emitting Diode: diodo emisor de luz.',
                      ),
                      PreguntaQuiz(
                        pregunta: '¿Qué valor tiene una resistencia rojo-rojo-marrón?',
                        opciones: ['22 Ω', '220 Ω', '2 200 Ω'],
                        correcta: 1,
                        explicacion: '2, 2 y un cero: 220 Ω.',
                      ),
                      PreguntaQuiz(
                        pregunta: '¿En qué se mide la fuerza de una pila?',
                        opciones: ['En voltios (V)', 'En metros', 'En litros'],
                        correcta: 0,
                        explicacion: 'Una pila cuadrada da 9 V.',
                      ),
                      PreguntaQuiz(
                        pregunta: '¿Qué componente sirve para un timbre?',
                        opciones: ['Un botón y un zumbador', 'Un motor y un foco', 'Solo una resistencia'],
                        correcta: 0,
                        explicacion: 'El botón controla y el zumbador suena.',
                      ),
                    ], color: const Color(0xFF6A1B9A), instruccion: 'Demuestra todo lo que sabes de componentes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Conocedor de Componentes»!',
                )),
      ],
    ),
  ],
);
