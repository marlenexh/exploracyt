import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'fondos_qui.dart';
import 'ilustraciones_qui.dart';
import 'sims_qui.dart';

/// Química · Tema 4: Cocción y descomposición de los alimentos.

const _c1 = Color(0xFFFB8C00);
const _c2 = Color(0xFF7CB342);
const _c3 = Color(0xFF1E88E5);
const _ci = Color(0xFFE65100);

final quiTema4 = TemaBio(
  numero: 4,
  mundo: 'qui',
  estilo: estiloQui(FondoQui.cocina),
  titulo: 'Cocción y descomposición de los alimentos',
  saludo:
      'En la cocina ocurren muchas transformaciones: cocinamos los alimentos para que sean seguros y sabrosos, y los conservamos para que no se echen a perder. ¡Ponte el mandil de científico!',
  misionDelTema:
      'El comedor de la escuela necesita un Chef Científico que sepa cocinar con seguridad y conservar los alimentos. Investiga el efecto de la temperatura y el tiempo.',
  color: _ci,
  insignia: 'Chef Científico',
  emojiInsignia: '👩‍🍳',
  emojisPanel: const ['🍲', '🍞', '🧊', '🧂', '🦠'],
  videos: const {
    'coccion_1': 'assets/videos/coccion_alimentos.mp4',
    'coccion_2': 'assets/videos/coccion_descomposicion.mp4',
    'coccion_3': 'assets/videos/coccion_conservacion.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: 'La cocción',
      emoji: '🍲',
      color: _c1,
      intro: '¿Por qué cocinamos los alimentos? ¡El calor y el tiempo los transforman!',
      mensajeFinal: '¡Cocinas con ciencia!',
      pasos: [
        PasoBio(
            '¿Qué pasa al cocinar?',
            TipoPasoBio.explicacion,
            'q4_m1_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Cocción',
                  titulo: 'La cocción de los alimentos',
                  color: _c1,
                  il: ilCoccion,
                  textos: const [
                    'Cocinar es aplicar calor a los alimentos durante un tiempo. La cocción es un cambio permanente: cambian el color, la textura, el olor y el sabor.',
                    'Cocinar hace que algunos alimentos sean más fáciles de digerir y, sobre todo, elimina muchos microorganismos que pueden enfermarnos.',
                    'La temperatura y el tiempo importan: con poco calor o poco tiempo el alimento queda crudo; con demasiado, se quema. Se puede hervir, freír, asar, hornear o cocer al vapor.',
                    'La carne, el pollo, el huevo y los frijoles siempre deben cocinarse bien. Las frutas y verduras crudas se lavan y desinfectan antes de comerlas.',
                  ],
                  izquierda: const [
                    Parte('tiempo', 'Tiempo', '(cuánto se cocina)', '⏲️', Color(0xFF5E35B1), 'Cada alimento necesita su tiempo de cocción.'),
                    Parte('crudo', 'Crudo', '(antes)', '🥩', Color(0xFFE53935), 'Puede tener microorganismos dañinos.'),
                    Parte('calor', 'Calor', '(la temperatura)', '🔥', Color(0xFFFF7043), 'La energía que transforma el alimento.'),
                  ],
                  derecha: const [
                    Parte('microbios', 'Microbios', '(se eliminan)', '🦠', Color(0xFF7CB342), 'El calor elimina muchas bacterias.'),
                    Parte('cocido', 'Cocido', '(después)', '🍖', Color(0xFF8D6E63), 'Cambia de color, textura y sabor.'),
                    Parte('olla', 'La olla', '(hervir)', '🍲', Color(0xFF1E88E5), 'El agua hirviendo cocina los alimentos.'),
                  ],
                  resaltar: const {
                    1: {'microbios'},
                    2: {'calor', 'tiempo'},
                  },
                  mensajeFinal: '¡Ahora clasifica los alimentos!',
                )),
        PasoBio(
            '¿Crudo o cocido?',
            TipoPasoBio.laboratorio,
            'q4_m1_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Cómo es más seguro comerlo?',
                  color: _c1,
                  instruccion: 'Arrastra cada alimento al grupo correcto.',
                  grupos: const [GrupoClasificar('Siempre cocido', '🔥', Color(0xFFE65100)), GrupoClasificar('Crudo, bien lavado', '💧', Color(0xFF43A047))],
                  items: const [
                    ItemClasificar('🍗', 'Pollo', 0, 'Puede tener bacterias como la salmonela.'),
                    ItemClasificar('🥚', 'Huevo', 0, 'Cocido es más seguro.'),
                    ItemClasificar('🫘', 'Frijoles', 0, 'Crudos no se pueden digerir.'),
                    ItemClasificar('🥩', 'Carne', 0, 'Se cocina bien para eliminar microbios.'),
                    ItemClasificar('🍎', 'Manzana', 1, 'Se lava y se come cruda.'),
                    ItemClasificar('🥕', 'Zanahoria', 1, 'Lavada y desinfectada, se come cruda.'),
                    ItemClasificar('🍌', 'Plátano', 1, 'Su cáscara lo protege.'),
                  ],
                  mensajeFinal: 'Cocinar bien los alimentos nos protege de enfermedades.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q4_m1_video',
            (a) => video(a,
                clave: 'coccion_1', titulo: 'Video: la cocción', tema: 'cómo el calor transforma los alimentos', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q4_m1_mini',
            (a) => miniMision(
                  a,
                  color: _c1,
                  fases: [
                    faseEtiquetar(ilCoccion, const {'calor': 'Calor', 'tiempo': 'Tiempo', 'crudo': 'Crudo', 'cocido': 'Cocido'}, color: _c1),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué es importante cocinar bien el pollo?',
                        opciones: ['El calor elimina microorganismos dañinos', 'Para que se vea bonito', 'No es importante'],
                        correcta: 0,
                        explicacion: 'Así evitamos enfermedades del estómago.',
                      ),
                    ], color: _c1),
                  ],
                  mensajeFinal: 'Sabes por qué y cómo se cocinan los alimentos.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'La descomposición',
      emoji: '🦠',
      color: _c2,
      intro: 'Si dejas pan al aire varios días, ¡le sale moho! ¿Qué está pasando?',
      mensajeFinal: '¡Entiendes por qué se descomponen los alimentos!',
      pasos: [
        PasoBio(
            '¿Qué es la descomposición?',
            TipoPasoBio.explicacion,
            'q4_m2_exp',
            (a) => explicacion(
                  a,
                  seccion: '1. Descomposición',
                  titulo: 'La descomposición',
                  color: _c2,
                  il: ilDescomposicion,
                  textos: const [
                    'La descomposición es un cambio permanente: microorganismos como bacterias y hongos se alimentan del alimento y lo transforman. Aparece moho, mal olor, cambio de color y de textura.',
                    'Es importante reconocerla para no comer alimentos echados a perder. ¡Pero también es útil! En la naturaleza, la descomposición regresa nutrientes al suelo.',
                    'Los microorganismos crecen más rápido con calor, humedad y tiempo. Por eso la leche fuera del refrigerador se agria en un día, pero dentro dura varios.',
                    'El moho verde del pan es un hongo. Nunca lo huelas de cerca ni lo comas: tira el alimento completo.',
                  ],
                  izquierda: const [
                    Parte('bacterias', 'Bacterias', '(microscópicas)', '🦠', Color(0xFF7CB342), 'Seres vivos diminutos que descomponen los alimentos.'),
                    Parte('calor', 'Calor', '(acelera)', '🌡️', Color(0xFFE53935), 'Con calor los microbios se multiplican más rápido.'),
                  ],
                  derecha: const [
                    Parte('hongos', 'Hongos', '(moho)', '🍄', Color(0xFF8D6E63), 'Forman manchas verdes, blancas o negras.'),
                    Parte('humedad', 'Humedad', '(acelera)', '💧', Color(0xFF29B6F6), 'Sin agua, los microbios casi no crecen.'),
                    Parte('alimento', 'Alimento', '(se descompone)', '🍞', Color(0xFFFFB300), 'Cambia su color, olor y textura.'),
                  ],
                  resaltar: const {
                    2: {'calor', 'humedad'},
                  },
                  mensajeFinal: '¡Ahora experimenta con la conservación!',
                )),
        PasoBio('Conserva los alimentos', TipoPasoBio.laboratorio, 'q4_m2_sim', (a) => SimConservacion(actividad: a, color: _c2)),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q4_m2_video',
            (a) => video(a,
                clave: 'coccion_2',
                titulo: 'Video: la descomposición',
                tema: 'microorganismos, temperatura y tiempo',
                siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q4_m2_mini',
            (a) => miniMision(
                  a,
                  color: _c2,
                  fases: [
                    faseEtiquetar(ilDescomposicion, const {'bacterias': 'Bacterias', 'hongos': 'Hongos', 'calor': 'Calor', 'humedad': 'Humedad'}, color: _c2),
                    fasePreguntas(const [
                      PreguntaQuiz(
                        pregunta: '¿Por qué los alimentos duran más en el refrigerador?',
                        opciones: ['El frío hace que los microorganismos crezcan más lento', 'Porque está oscuro', 'Porque tiene puerta'],
                        correcta: 0,
                        explicacion: 'El frío frena a bacterias y hongos.',
                      ),
                    ], color: _c2),
                  ],
                  mensajeFinal: 'Entiendes la descomposición.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'La conservación',
      emoji: '🧊',
      color: _c3,
      intro: 'Desde hace miles de años las personas inventan formas de conservar los alimentos. ¡Conócelas!',
      mensajeFinal: '¡Conservas los alimentos como un experto!',
      pasos: [
        PasoBio(
            'Métodos de conservación',
            TipoPasoBio.explicacion,
            'q4_m3_tarj',
            (a) => tarjetas(
                  a,
                  seccion: '1. Conservación',
                  titulo: 'Métodos de conservación',
                  color: _c3,
                  textoZati:
                      'Conservar es frenar a los microorganismos: con frío, quitando el agua, con sal o azúcar, o con calor y envases cerrados. Toca cada tarjeta.',
                  grupos: const [
                    GrupoTarjetas('Métodos', _c3, Icons.kitchen_rounded, [
                      TarjetaInfo(Icons.ac_unit_rounded, 'Refrigerar y congelar', 'El frío frena a los microorganismos.'),
                      TarjetaInfo(Icons.wb_sunny_rounded, 'Deshidratar', 'Sin agua no pueden crecer: chiles secos, pasas, carne seca.'),
                      TarjetaInfo(Icons.grain_rounded, 'Salar y endulzar', 'La sal y el azúcar quitan el agua: cecina, ates y mermeladas.'),
                      TarjetaInfo(Icons.inventory_2_rounded, 'Enlatar y pasteurizar', 'Se calientan para eliminar microbios y se cierran sin aire.'),
                    ]),
                    GrupoTarjetas('¿Sabías que…?', Color(0xFFFF8F00), Icons.lightbulb_rounded, [
                      TarjetaInfo(Icons.history_edu_rounded, 'Los pueblos antiguos', 'Los mexicas secaban chile, maíz y pescado al sol para guardarlos meses.'),
                      TarjetaInfo(
                          Icons.science_rounded, 'Louis Pasteur', 'Descubrió que calentar la leche elimina microbios: por eso se llama “pasteurizada”.'),
                      TarjetaInfo(Icons.emoji_food_beverage_rounded, 'La miel', 'Bien guardada puede durar muchísimos años sin echarse a perder.'),
                    ]),
                  ],
                  mensajeFinal: '¡Conservar los alimentos evita desperdiciarlos!',
                )),
        PasoBio(
            '¿Qué método usa?',
            TipoPasoBio.laboratorio,
            'q4_m3_clas',
            (a) => clasificar(
                  a,
                  seccion: '2. Clasifica',
                  titulo: '¿Qué método de conservación usa?',
                  color: _c3,
                  instruccion: 'Arrastra cada alimento al método con el que se conserva.',
                  grupos: const [
                    GrupoClasificar('Frío', '❄️', Color(0xFF1E88E5)),
                    GrupoClasificar('Sin agua', '☀️', Color(0xFFFFB300)),
                    GrupoClasificar('Sal o azúcar', '🧂', Color(0xFF8D6E63)),
                  ],
                  items: const [
                    ItemClasificar('🍦', 'Helado', 0, 'Se guarda congelado.'),
                    ItemClasificar('🐟', 'Pescado congelado', 0, 'El congelador lo conserva meses.'),
                    ItemClasificar('🌶️', 'Chile seco', 1, 'Se seca al sol.'),
                    ItemClasificar('🍇', 'Pasas', 1, 'Son uvas deshidratadas.'),
                    ItemClasificar('🥓', 'Cecina', 2, 'Carne salada y seca.'),
                    ItemClasificar('🍓', 'Mermelada', 2, 'Mucha azúcar la conserva.'),
                  ],
                  mensajeFinal: 'Cada método frena a los microorganismos de una forma distinta.',
                )),
        PasoBio(
            'Video del tema',
            TipoPasoBio.video,
            'q4_m3_video',
            (a) =>
                video(a, clave: 'coccion_3', titulo: 'Video: conservar alimentos', tema: 'métodos de conservación', siguiente: '¡Último reto de la misión!')),
        PasoBio(
            'Pon a prueba lo que aprendiste',
            TipoPasoBio.reto,
            'q4_m3_mini',
            (a) => miniMision(
                  a,
                  color: _c3,
                  fases: [
                    faseAcciones(
                        'Higiene en la cocina',
                        'Toca las acciones que mantienen seguros los alimentos y presiona “Comprobar”.',
                        const [
                          Accion(Icons.clean_hands_rounded, 'Lavarse las manos antes de cocinar', true, 'Evita llevar microbios a la comida.'),
                          Accion(Icons.kitchen_rounded, 'Guardar las sobras en el refrigerador', true, 'El frío las conserva.'),
                          Accion(Icons.event_rounded, 'Revisar la fecha de caducidad', true, 'Indica hasta cuándo es seguro.'),
                          Accion(Icons.water_drop_rounded, 'Lavar y desinfectar frutas y verduras', true, 'Elimina tierra y microbios.'),
                          Accion(Icons.sunny, 'Dejar la leche al sol todo el día', false, 'El calor hace que se agríe rápido.'),
                          Accion(Icons.no_food_rounded, 'Quitar el moho y comer el resto del pan', false, 'El hongo se extiende por dentro.'),
                        ],
                        color: _c3),
                  ],
                  mensajeFinal: 'Mantienes seguros los alimentos.',
                )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El refrigerador descompuesto',
      emoji: '🏆',
      color: Color(0xFF6A1B9A),
      intro: '¡Último desafío! El refrigerador del comedor se descompuso. ¡Salva la comida!',
      mensajeFinal: '¡Salvaste la comida del comedor!',
      pasos: [
        PasoBio(
            'El refrigerador descompuesto',
            TipoPasoBio.reto,
            'q4_int_sit',
            (a) => situacion(
                  a,
                  titulo: 'El refrigerador descompuesto',
                  color: const Color(0xFF6A1B9A),
                  escenas: const [
                    EscenaBio(
                      titulo: 'Sin frío',
                      narracion: 'El refrigerador dejó de enfriar en un día de mucho calor.',
                      emojis: '🧊❌☀️',
                      pregunta: '¿Qué alimento corre más peligro?',
                      opciones: ['La leche y la carne', 'El arroz crudo', 'Los chiles secos'],
                      correcta: 0,
                      explicacion: 'Tienen mucha agua y se descomponen rápido.',
                    ),
                    EscenaBio(
                      titulo: 'La solución',
                      narracion: 'Hay hielo en una hielera.',
                      emojis: '🧊🧺',
                      pregunta: '¿Qué conviene hacer?',
                      opciones: ['Pasar la leche y la carne a la hielera con hielo', 'Dejarlos al sol', 'Taparlos con papel'],
                      correcta: 0,
                      explicacion: 'El frío frena a los microbios.',
                    ),
                    EscenaBio(
                      titulo: 'Las frutas',
                      narracion: 'Sobran muchas manzanas que no se van a comer pronto.',
                      emojis: '🍎🍎',
                      pregunta: '¿Cómo podrían conservarlas mucho tiempo sin refrigerador?',
                      opciones: ['Deshidratarlas en rebanadas', 'Mojarlas todos los días', 'Ponerlas junto a la estufa'],
                      correcta: 0,
                      explicacion: 'Sin agua los microorganismos no crecen.',
                    ),
                    EscenaBio(
                      titulo: 'La comida',
                      narracion: 'Van a preparar pollo para el almuerzo.',
                      emojis: '🍗🔥',
                      pregunta: '¿Cómo debe cocinarse?',
                      opciones: ['Bien cocido, sin partes rosadas', 'Casi crudo', 'Solo calentarlo un segundo'],
                      correcta: 0,
                      explicacion: 'El calor elimina las bacterias.',
                    ),
                  ],
                  mensajeFinal: '¡La comida está a salvo!',
                )),
        PasoBio(
            'Supercerebro de la cocina',
            TipoPasoBio.reto,
            'q4_int_quiz',
            (a) => miniMision(
                  a,
                  color: const Color(0xFF6A1B9A),
                  fases: [
                    fasePreguntas(const [
                      PreguntaQuiz(
                          pregunta: '¿Qué hace que un alimento se descomponga?',
                          opciones: ['Microorganismos como bacterias y hongos', 'La luz de la luna', 'El color del plato'],
                          correcta: 0,
                          explicacion: 'Se alimentan de él.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué acelera la descomposición?',
                          opciones: ['Calor y humedad', 'Frío y sequedad', 'Sal'],
                          correcta: 0,
                          explicacion: 'Los microbios crecen rápido así.'),
                      PreguntaQuiz(
                          pregunta: '¿Qué método usa la cecina?',
                          opciones: ['Salado y secado', 'Congelación', 'Enlatado'],
                          correcta: 0,
                          explicacion: 'La sal le quita el agua.'),
                      PreguntaQuiz(
                          pregunta: '¿La cocción es un cambio…?',
                          opciones: ['Permanente', 'Temporal', 'De estado'],
                          correcta: 0,
                          explicacion: 'El alimento no vuelve a estar crudo.'),
                    ], color: const Color(0xFF6A1B9A), instruccion: 'Demuestra todo lo que sabes.'),
                  ],
                  mensajeFinal: '¡Ganaste la insignia «Chef Científico»!',
                )),
      ],
    ),
  ],
);
