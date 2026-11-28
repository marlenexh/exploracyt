import 'package:flutter/material.dart';

import '../biology/temas/fabrica.dart';
import '../biology/temas/motor.dart';
import 'cazaerrores.dart';
import 'fondos_pro.dart';
import 'ilustraciones_pro.dart';
import 'pro_tema1.dart' show robot, cazar, conGemas;
import 'robot.dart';

/// Programación · Tema 5: Encuentra el error (depuración).

const _c1 = Color(0xFFE53935);
const _c2 = Color(0xFF00897B);
const _c3 = Color(0xFF5E35B1);
const _ci = Color(0xFF455A64);

const programasDepurar = [
  ProgramaConErrores(
    titulo: 'Lavarse los dientes',
    objetivo: 'cepillarse los dientes en el orden correcto.',
    logro: 'Un algoritmo con los pasos en desorden no funciona.',
    lineas: [
      LineaCodigo('Inicio'),
      LineaCodigo('Tomar el cepillo'),
      LineaCodigo('Cepillar los dientes',
          opciones: ['Poner pasta en el cepillo', 'Guardar el cepillo', 'Enjuagar la boca'], tipo: 'Error de orden', explicacion: 'Primero va la pasta y después se cepilla.'),
      LineaCodigo('Poner pasta en el cepillo',
          opciones: ['Cepillar los dientes', 'Tomar el cepillo', 'Fin'], tipo: 'Error de orden', explicacion: 'Después de la pasta, se cepilla.'),
      LineaCodigo('Enjuagar la boca'),
      LineaCodigo('Fin'),
    ],
  ),
  ProgramaConErrores(
    titulo: 'Área del rectángulo',
    objetivo: 'leer la base y la altura, y mostrar el área.',
    logro: 'Corregiste un error lógico y uno de sintaxis.',
    lineas: [
      LineaCodigo('inicio'),
      LineaCodigo('leer base, altura'),
      LineaCodigo('area = base + altura',
          opciones: ['area = base × altura', 'area = base − altura', 'area = base ÷ altura'],
          tipo: 'Error lógico',
          explicacion: 'El área se calcula multiplicando. El programa corría, pero daba un resultado equivocado.'),
      LineaCodigo('imprimir "Área = , area',
          opciones: ['imprimir "Área = ", area', 'imprimir Área = area"', 'leer "Área = ", area'],
          tipo: 'Error de sintaxis',
          explicacion: 'Faltaban unas comillas: el texto debe abrir y cerrar con ".'),
      LineaCodigo('fin'),
    ],
  ),
  ProgramaConErrores(
    titulo: 'Aprobado o reprobado',
    objetivo: 'imprimir “Aprobado” si la calificación es 70 o más, y “Reprobado” si no.',
    logro: 'La condición equivocada hacía que el programa decidiera mal.',
    lineas: [
      LineaCodigo('inicio'),
      LineaCodigo('leer calificacion'),
      LineaCodigo('si (calificacion < 70) entonces',
          opciones: ['si (calificacion >= 70) entonces', 'si (calificacion = 0) entonces', 'mientras (calificacion < 70) hacer'],
          tipo: 'Error en la condición',
          explicacion: 'Para aprobar, la calificación debe ser mayor o igual a 70.'),
      LineaCodigo('imprimir "Aprobado"', sangria: 1),
      LineaCodigo('si no'),
      LineaCodigo('imprimir "Reprobado"', sangria: 1),
      LineaCodigo('fin si'),
      LineaCodigo('fin'),
    ],
  ),
  ProgramaConErrores(
    titulo: 'Contar del 1 al 5',
    objetivo: 'imprimir los números 1, 2, 3, 4 y 5.',
    logro: 'El número nunca llegaba a 6: era un ciclo infinito.',
    lineas: [
      LineaCodigo('inicio'),
      LineaCodigo('numero = 1'),
      LineaCodigo('mientras (numero <= 5) hacer'),
      LineaCodigo('imprimir numero', sangria: 1),
      LineaCodigo('numero = numero − 1',
          sangria: 1,
          opciones: ['numero = numero + 1', 'numero = 1', 'numero = numero × 0'],
          tipo: 'Ciclo infinito',
          explicacion: 'Restando, el número nunca pasa de 5 y el ciclo no termina.'),
      LineaCodigo('fin mientras'),
      LineaCodigo('fin'),
    ],
  ),
];

const programasFinales = [
  ProgramaConErrores(
    titulo: 'Comprar zapatos',
    objetivo: 'repetir hasta comprar unos zapatos que te queden.',
    logro: 'Ahora el ciclo termina cuando compras los zapatos.',
    lineas: [
      LineaCodigo('Inicio'),
      LineaCodigo('compre = falso'),
      LineaCodigo('mientras (compre = falso) hacer'),
      LineaCodigo('seleccionar zapatos', sangria: 1),
      LineaCodigo('probar zapatos', sangria: 1),
      LineaCodigo('si (me quedan) entonces', sangria: 1),
      LineaCodigo('compre = falso',
          sangria: 2,
          opciones: ['compre = verdadero', 'probar zapatos', 'compre = falso otra vez'],
          tipo: 'Ciclo infinito',
          explicacion: 'Si nunca cambia a verdadero, nunca sales de la tienda.'),
      LineaCodigo('fin si', sangria: 1),
      LineaCodigo('fin mientras'),
      LineaCodigo('Fin'),
    ],
  ),
  ProgramaConErrores(
    titulo: 'Promedio de 3 calificaciones',
    objetivo: 'calcular el promedio de a, b y c y mostrarlo.',
    logro: 'Los paréntesis hacen que primero se sume y luego se divida.',
    lineas: [
      LineaCodigo('inicio'),
      LineaCodigo('leer a, b, c'),
      LineaCodigo('promedio = a + b + c / 3',
          opciones: ['promedio = (a + b + c) / 3', 'promedio = a + b + c', 'promedio = a × b × c / 3'],
          tipo: 'Error lógico',
          explicacion: 'Sin paréntesis, solo c se divide entre 3. Primero hay que sumar todo.'),
      LineaCodigo('imprimir promedio'),
      LineaCodigo('imprimr "¡Listo!"',
          opciones: ['imprimir "¡Listo!"', 'imprimr ¡Listo!', 'leer "¡Listo!"'], tipo: 'Error de sintaxis', explicacion: 'La palabra estaba mal escrita: la computadora no la entiende.'),
      LineaCodigo('fin'),
    ],
  ),
];

final proTema5 = TemaBio(
  numero: 5,
  mundo: 'pro',
  estilo: estiloPro(FondoPro.bichos),
  titulo: 'Encuentra el error',
  saludo: 'Todos los programadores se equivocan… ¡hasta los expertos! Lo importante es saber encontrar los errores (los “bugs”) y corregirlos. ¡Vamos a cazar bichos!',
  misionDelTema: 'Unos bichos se metieron en los programas del reino y nada funciona bien. Aprende qué tipos de errores hay, depura algoritmos y arregla los programas del robot.',
  color: _ci,
  insignia: 'Cazador de Errores',
  emojiInsignia: '🐞',
  emojisPanel: const ['🔍', '🐛', '🛠️', '✅', '💻'],
  videos: const {
    'errores_1': 'assets/videos/errores_que_son.mp4',
    'errores_2': 'assets/videos/errores_algoritmos.mp4',
    'errores_3': 'assets/videos/errores_programas.mp4',
  },
  misiones: [
    MisionBio(
      titulo: 'Misión 1',
      subtitulo: '¿Qué es un bug?',
      emoji: '🐞',
      color: _c1,
      intro: 'A los errores de los programas se les llama “bugs” (bichos). ¡Descubre de dónde viene el nombre y qué tipos hay!',
      mensajeFinal: '¡Ya reconoces los tipos de errores!',
      pasos: [
        PasoBio('Los errores', TipoPasoBio.explicacion, 'p5_m1_exp', (a) => explicacion(
              a,
              seccion: '1. Errores',
              titulo: 'Los errores (bugs)',
              color: _c1,
              il: ilErrores,
              textos: const [
                'Un error o “bug” es algo en el programa que hace que no funcione como debería. Depurar es encontrar los errores y corregirlos. ¡Es una parte normal del trabajo del programador!',
                'Encontrar errores evita que un videojuego se trabe, que una app calcule mal o que un robot choque. Por eso los programas se prueban muchas veces.',
                'Hay errores de sintaxis (algo mal escrito, la computadora no lo entiende), errores lógicos (el programa corre pero da un resultado equivocado) y errores de ejecución (el programa se detiene, como al dividir entre cero).',
                'En 1947, la programadora Grace Hopper encontró una polilla atrapada dentro de una computadora que fallaba. ¡Desde entonces a los errores se les dice “bugs”!',
              ],
              izquierda: const [
                Parte('sintaxis', 'Error de sintaxis', '(mal escrito)', '✍️', Color(0xFFE53935), 'Falta una comilla o una palabra está mal escrita. La computadora no entiende la instrucción.'),
                Parte('logico', 'Error lógico', '(resultado equivocado)', '🤔', Color(0xFFFB8C00), 'El programa funciona, pero hace otra cosa: sumar en lugar de multiplicar.'),
              ],
              derecha: const [
                Parte('ejecucion', 'Error de ejecución', '(se detiene)', '💥', Color(0xFF8E24AA), 'Ocurre mientras corre el programa: dividir entre cero, chocar con una pared.'),
                Parte('depurar', 'Depurar', '(buscar y corregir)', '🔍', Color(0xFF00897B), 'Probar, encontrar el error, corregirlo y volver a probar.'),
              ],
              resaltar: const {
                2: {'sintaxis', 'logico', 'ejecucion'},
                3: {'depurar'},
              },
              mensajeFinal: '¡Ahora clasifica errores!',
            )),
        PasoBio('¿Qué tipo de error es?', TipoPasoBio.laboratorio, 'p5_m1_clas', (a) => clasificar(
              a,
              seccion: '2. Clasifica',
              titulo: '¿Qué tipo de error es?',
              color: _c1,
              instruccion: 'Arrastra cada error a su tipo.',
              grupos: const [
                GrupoClasificar('Sintaxis ✍️', '✍️', Color(0xFFE53935)),
                GrupoClasificar('Lógico 🤔', '🤔', Color(0xFFFB8C00)),
                GrupoClasificar('Ejecución 💥', '💥', Color(0xFF8E24AA)),
              ],
              items: const [
                ItemClasificar('📝', 'Escribir “imprimr” en vez de “imprimir”', 0, 'Está mal escrito.'),
                ItemClasificar('❝', 'Olvidar cerrar las comillas', 0, 'Rompe las reglas del lenguaje.'),
                ItemClasificar('➕', 'Sumar cuando había que multiplicar', 1, 'Corre, pero el resultado está mal.'),
                ItemClasificar('🎮', 'El juego suma puntos al chocar con un enemigo', 1, 'Hace algo distinto a lo planeado.'),
                ItemClasificar('➗', 'Dividir un número entre cero', 2, 'El programa se detiene al ejecutarse.'),
                ItemClasificar('🧱', 'El robot choca con una pared', 2, 'Falla mientras se ejecuta.'),
              ],
              mensajeFinal: 'Saber el tipo de error ayuda a encontrarlo más rápido.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p5_m1_video', (a) => video(a,
            clave: 'errores_1', titulo: 'Video: los bugs', tema: 'qué son los errores en programación', siguiente: '¡Ordena cómo se depura!')),
        PasoBio('Cómo depurar', TipoPasoBio.juego, 'p5_m1_ord', (a) => ordenar(
              a,
              seccion: '3. Paso a paso',
              titulo: 'Los pasos para depurar',
              color: _c1,
              instruccion: 'Ordena los pasos que sigue un programador para depurar un programa.',
              pasos: const [
                ('▶️', 'Ejecutar el programa'),
                ('👀', 'Observar qué falla'),
                ('🔍', 'Encontrar la línea con el error'),
                ('🛠️', 'Corregir el error'),
                ('🔁', 'Volver a probar'),
              ],
              explicacion: 'Si vuelve a fallar, se repite el proceso: ¡es un ciclo!',
              mensajeFinal: '¡Así depuran los programadores!',
              ciclo: true,
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p5_m1_mini', (a) => miniMision(
              a,
              color: _c1,
              fases: [
                faseEtiquetar(ilErrores, const {'sintaxis': 'Sintaxis', 'logico': 'Lógico', 'ejecucion': 'Ejecución', 'depurar': 'Depurar'}, color: _c1,
                    instruccion: 'Identifica cada tipo de error en el editor.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Qué significa depurar?',
                    opciones: ['Encontrar y corregir los errores de un programa', 'Borrar todo el programa', 'Comprar otra computadora'],
                    correcta: 0,
                    explicacion: 'Depurar es cazar bichos.',
                  ),
                ], color: _c1),
              ],
              mensajeFinal: 'Conoces los tipos de errores.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 2',
      subtitulo: 'Depura algoritmos',
      emoji: '🔍',
      color: _c2,
      intro: 'Estos algoritmos y programas en pseudocódigo tienen bichos escondidos. ¡Encuéntralos y corrígelos!',
      mensajeFinal: '¡Depuraste algoritmos como un experto!',
      pasos: [
        PasoBio('Prueba de escritorio', TipoPasoBio.explicacion, 'p5_m2_tarj', (a) => tarjetas(
              a,
              seccion: '1. Técnicas',
              titulo: 'Trucos para encontrar errores',
              color: _c2,
              textoZati: 'Los programadores tienen trucos para encontrar errores. Toca cada tarjeta.',
              grupos: const [
                GrupoTarjetas('Trucos', _c2, Icons.tips_and_updates_rounded, [
                  TarjetaInfo(Icons.edit_note_rounded, 'Prueba de escritorio', 'Sigue el algoritmo con lápiz y papel, paso por paso, anotando los valores.'),
                  TarjetaInfo(Icons.record_voice_over_rounded, 'Explícalo en voz alta', 'Al explicar cada línea, el error aparece.'),
                  TarjetaInfo(Icons.science_rounded, 'Prueba con datos', 'Usa números fáciles, como 85 y 60, para ver si decide bien.'),
                ]),
                GrupoTarjetas('Qué revisar', Color(0xFFE53935), Icons.checklist_rounded, [
                  TarjetaInfo(Icons.swap_vert_rounded, 'El orden', '¿Algún paso está antes de tiempo?'),
                  TarjetaInfo(Icons.rule_rounded, 'Las condiciones', '¿Dice < cuando debería decir ≥?'),
                  TarjetaInfo(Icons.loop_rounded, 'Los ciclos', '¿El ciclo termina alguna vez?'),
                  TarjetaInfo(Icons.spellcheck_rounded, 'La escritura', '¿Faltan comillas o hay palabras mal escritas?'),
                ]),
              ],
              mensajeFinal: '¡Con estos trucos encontrarás cualquier bicho!',
            )),
        PasoBio('Caza los bichos', TipoPasoBio.laboratorio, 'p5_m2_caza', (a) => cazar(
              a,
              seccion: 'Laboratorio',
              titulo: 'Caza los bichos',
              color: _c2,
              programas: programasDepurar,
              mensajeFinal: 'Encontraste errores de orden, lógicos, de sintaxis, de condición y un ciclo infinito.',
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p5_m2_video', (a) => video(a,
            clave: 'errores_2', titulo: 'Video: depurar algoritmos', tema: 'cómo encontrar errores con una prueba de escritorio', siguiente: '¡Último reto de la misión!')),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p5_m2_mini', (a) => miniMision(
              a,
              color: _c2,
              fases: [
                faseRelacionar(const [
                  ('Prueba de escritorio', 'Seguir el algoritmo en papel paso a paso.'),
                  ('Error de orden', 'Un paso está antes de tiempo.'),
                  ('Ciclo infinito', 'El ciclo nunca termina.'),
                  ('Error de condición', 'El “si” revisa algo equivocado.'),
                ], color: _c2, instruccion: 'Relaciona cada palabra con su significado.'),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'numero = 1; mientras (numero ≤ 3): imprimir numero, numero = numero + 1. ¿Cuánto vale “numero” al terminar?',
                    opciones: ['4', '3', '1'],
                    correcta: 0,
                    explicacion: 'Con 4 la condición es falsa y el ciclo termina.',
                  ),
                ], color: _c2),
              ],
              mensajeFinal: 'Depuras algoritmos y haces pruebas de escritorio.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Misión 3',
      subtitulo: 'Depura programas',
      emoji: '🛠️',
      color: _c3,
      intro: 'Los programas del robot tienen errores. Ejecútalos, observa qué falla y corrígelos.',
      mensajeFinal: '¡Arreglaste todos los programas del robot!',
      pasos: [
        PasoBio('Arregla el robot', TipoPasoBio.simulacion, 'p5_m3_robot', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Arregla el robot',
              color: _c3,
              mensajeFinal: 'Depuraste programas: ejecutaste, observaste, encontraste el error y lo corregiste.',
              niveles: [
                NivelRobot(
                  titulo: 'Falta un paso',
                  instruccion: 'Este programa ya está escrito, pero el robot no llega. Ejecútalo, observa dónde se queda y corrígelo.',
                  mapa: const ['S...M'],
                  inicial: () => [av(), av(), av()],
                  logro: 'Faltaba un “avanzar”.',
                ),
                NivelRobot(
                  titulo: 'El giro equivocado',
                  instruccion: 'El robot choca. Ejecuta el programa y busca el bloque que lo manda por el camino equivocado. Tócalo, bórralo 🗑️ y pon el correcto.',
                  mapa: const ['S.#', '#.#', '#.M'],
                  inicial: () => [av(), gi(), av(), av(), gi(), av()],
                  logro: 'El primer giro debía ser a la derecha.',
                  pista: 'Después de avanzar 1, el robot debe ir hacia abajo: eso es girar a la DERECHA.',
                ),
                NivelRobot(
                  titulo: 'La gema olvidada',
                  instruccion: 'El robot llega a la meta, pero no recoge la gema. Corrige el programa.',
                  mapa: const ['S.G.M'],
                  bloques: conGemas.union({TipoBloque.repetir}),
                  inicial: () => [rep(4, [av()]), rc()],
                  logro: 'Hay que recoger la gema cuando el robot está sobre ella, no al final.',
                  pista: 'Cambia “repetir 4” por “repetir 2”, recoge, y después avanza 2 más.',
                ),
                NivelRobot(
                  titulo: 'El ciclo infinito',
                  instruccion: 'Este programa nunca termina. ¿Qué bloque dentro del “mientras” está mal?',
                  mapa: const ['S...M'],
                  bloques: const {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.mientras},
                  condiciones: const [Cond.noMeta],
                  inicial: () => [mientras(Cond.noMeta, [gd()])],
                  logro: 'Girar nunca acerca al robot a la meta; avanzar sí.',
                  pista: 'Toca el bloque “girar a la derecha” que está dentro del ciclo, bórralo y agrega “avanzar”.',
                ),
              ],
            )),
        PasoBio('Video del tema', TipoPasoBio.video, 'p5_m3_video', (a) => video(a,
            clave: 'errores_3', titulo: 'Video: depurar programas', tema: 'cómo probar y corregir programas', siguiente: '¡Arregla un dibujo!')),
        PasoBio('Arregla el dibujo', TipoPasoBio.simulacion, 'p5_m3_dibujo', (a) => robot(
              a,
              seccion: 'Simulación',
              titulo: 'Arregla el dibujo',
              color: _c3,
              mensajeFinal: 'Un solo número equivocado puede cambiar todo el resultado.',
              niveles: [
                NivelRobot(
                  titulo: 'Al cuadrado le falta un lado',
                  instruccion: 'Este programa debería dibujar un cuadrado, pero le falta un lado. Toca el número del “repetir” para corregirlo.',
                  mapa: const ['.....', '.....', '.....', '.....'],
                  dir: Dir.arriba,
                  bloques: const {TipoBloque.avanzar, TipoBloque.derecha, TipoBloque.repetir},
                  dibujo: figura(const [(0, 3), (0, 1), (2, 1), (2, 3), (0, 3)]),
                  inicial: () => [
                    rep(3, [av(), av(), gd()])
                  ],
                  logro: 'El cuadrado tiene 4 lados: el ciclo debía repetirse 4 veces.',
                ).conInicio(0, 3),
              ],
            )),
        PasoBio('Pon a prueba lo que aprendiste', TipoPasoBio.reto, 'p5_m3_mini', (a) => miniMision(
              a,
              color: _c3,
              fases: [
                faseAcciones('Actitud de programador', 'Toca lo que hace un buen programador cuando encuentra un error y presiona “Comprobar”.', const [
                  Accion(Icons.psychology_rounded, 'Mantener la calma y pensar', true, 'Los errores son normales.'),
                  Accion(Icons.search_rounded, 'Revisar línea por línea', true, 'Así se encuentra el bicho.'),
                  Accion(Icons.replay_rounded, 'Probar otra vez después de corregir', true, 'Para comprobar que funciona.'),
                  Accion(Icons.groups_rounded, 'Pedir a un compañero que lo revise', true, 'Otros ojos ven lo que tú no.'),
                  Accion(Icons.delete_forever_rounded, 'Borrar todo sin buscar el error', false, 'Perderías lo que sí funcionaba.'),
                  Accion(Icons.sentiment_very_dissatisfied_rounded, 'Rendirse', false, 'Todos los programadores se equivocan y lo corrigen.'),
                  Accion(Icons.casino_rounded, 'Cambiar bloques al azar', false, 'Es mejor entender qué falla.'),
                ], color: _c3),
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: 'El robot chocó en el tercer bloque. ¿Dónde buscas el error primero?',
                    opciones: ['En el bloque donde chocó y los anteriores', 'En el último bloque', 'En la pantalla'],
                    correcta: 0,
                    explicacion: 'El error está antes del choque.',
                  ),
                ], color: _c3),
              ],
              mensajeFinal: 'Depuras programas con paciencia y método.',
            )),
      ],
    ),
    MisionBio(
      titulo: 'Integradora',
      subtitulo: 'El videojuego con bichos',
      emoji: '🏆',
      color: Color(0xFFC62828),
      intro: '¡Último desafío! El videojuego del reino está lleno de bichos. Encuéntralos todos para que se pueda jugar.',
      mensajeFinal: '¡El videojuego del reino ya no tiene bichos!',
      pasos: [
        PasoBio('Reportes de los jugadores', TipoPasoBio.reto, 'p5_int_sit', (a) => situacion(
              a,
              titulo: 'Reportes de los jugadores',
              color: const Color(0xFFC62828),
              escenas: const [
                EscenaBio(
                  titulo: 'Puntos al revés',
                  narracion: 'Los jugadores dicen: “Cuando toco una estrella, pierdo una vida”.',
                  emojis: '⭐💔',
                  pregunta: '¿Qué tipo de error es?',
                  opciones: ['Error lógico', 'Error de sintaxis', 'No es un error'],
                  correcta: 0,
                  explicacion: 'El juego corre, pero hace algo distinto a lo planeado.',
                ),
                EscenaBio(
                  titulo: 'No arranca',
                  narracion: 'El programa no inicia y marca: “imprimr no existe”.',
                  emojis: '🖥️❗',
                  pregunta: '¿Qué tipo de error es?',
                  opciones: ['Error de sintaxis', 'Error lógico', 'Ciclo infinito'],
                  correcta: 0,
                  explicacion: 'Una palabra mal escrita.',
                ),
                EscenaBio(
                  titulo: 'El juego no termina',
                  narracion: 'Aunque el jugador se queda sin vidas, el juego sigue y sigue.',
                  emojis: '♾️🎮',
                  pregunta: '¿Qué falta en el programa?',
                  opciones: ['Una condición: si vidas = 0, terminar el juego', 'Más enemigos', 'Otro color'],
                  correcta: 0,
                  explicacion: 'Falta una decisión para terminar.',
                ),
                EscenaBio(
                  titulo: 'Corregido',
                  narracion: 'Ya corregiste todo. ¿Qué haces antes de publicar el juego?',
                  emojis: '🛠️✅',
                  pregunta: '¿Qué sigue?',
                  opciones: ['Volver a probarlo', 'Publicarlo sin probar', 'Borrarlo'],
                  correcta: 0,
                  explicacion: 'Siempre hay que comprobar que la corrección funciona.',
                ),
              ],
              mensajeFinal: '¡Gracias a ti el juego se puede jugar!',
            )),
        PasoBio('Los últimos bichos', TipoPasoBio.laboratorio, 'p5_int_caza', (a) => cazar(
              a,
              seccion: 'Integradora',
              titulo: 'Los últimos bichos',
              color: const Color(0xFFC62828),
              programas: programasFinales,
              mensajeFinal: '¡No quedó ni un bicho en el reino!',
            )),
        PasoBio('Supercerebro de errores', TipoPasoBio.reto, 'p5_int_quiz', (a) => miniMision(
              a,
              color: const Color(0xFFC62828),
              fases: [
                fasePreguntas(const [
                  PreguntaQuiz(
                    pregunta: '¿Por qué a los errores se les llama “bugs”?',
                    opciones: ['Porque una vez una polilla causó una falla en una computadora', 'Porque los programas tienen patas', 'Por un videojuego'],
                    correcta: 0,
                    explicacion: 'La encontró el equipo de Grace Hopper en 1947.',
                  ),
                  PreguntaQuiz(
                    pregunta: 'Un programa calcula 2 + 2 y muestra 5. ¿Qué tipo de error es?',
                    opciones: ['Lógico', 'De sintaxis', 'Ninguno'],
                    correcta: 0,
                    explicacion: 'Funciona, pero el resultado está mal.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué hace que un ciclo “mientras” sea infinito?',
                    opciones: ['Que su condición nunca deje de cumplirse', 'Que tenga pocos bloques', 'Que se repita 3 veces'],
                    correcta: 0,
                    explicacion: 'Algo dentro del ciclo debe cambiar la condición.',
                  ),
                  PreguntaQuiz(
                    pregunta: '¿Qué es una prueba de escritorio?',
                    opciones: ['Seguir el algoritmo en papel paso a paso', 'Limpiar el escritorio', 'Probar el teclado'],
                    correcta: 0,
                    explicacion: 'Sirve para encontrar errores antes de ejecutar.',
                  ),
                ], color: const Color(0xFFC62828), instruccion: 'Demuestra todo lo que sabes de errores.'),
              ],
              mensajeFinal: '¡Ganaste la insignia «Cazador de Errores»!',
            )),
      ],
    ),
  ],
);
