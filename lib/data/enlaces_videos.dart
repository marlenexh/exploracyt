/// Enlaces de YouTube de los videos del juego.
///
/// Pega entre las comillas el enlace de YouTube de cada video, por ejemplo:
///   'ia_1': 'https://www.youtube.com/watch?v=XXXXXXXXXXX',
/// Sirven enlaces de youtube.com/watch, youtu.be, shorts y embed.
///
/// Si un enlace queda vacío (''), el juego busca el archivo en assets/videos/
/// y, si tampoco existe, muestra el aviso "Aquí va el video del tema" y deja
/// continuar la misión.
///
/// Importante: el video debe permitir "insertarse" en otros sitios (opción de
/// YouTube Studio); si no, el juego avisa y deja continuar.
const enlacesVideos = <String, String>{
  // ===== Biología · Tema 1: El cuerpo humano y sus sistemas =====
  'circulatorio': '', // Sistema circulatorio
  'respiratorio': '', // Sistema respiratorio
  'inmune': '', // Sistema inmunológico

  // ===== Biología · Tema 2: El mundo de las células =====
  'celulas_1': '', // Misión 1 · ¿qué es una célula?
  'celulas_2': '', // Misión 2 · células animales y vegetales
  'celulas_3': '', // Misión 3 · la importancia de las células

  // ===== Biología · Tema 3: Alimentación saludable =====
  'alimentacion_1': '', // Misión 1 · los nutrientes
  'alimentacion_2': '', // Misión 2 · el Plato del Bien Comer
  'alimentacion_3': '', // Misión 3 · hábitos saludables

  // ===== Biología · Tema 4: La vida a nuestro alrededor =====
  'seres_vivos_1': '', // Misión 1 · los seres vivos
  'seres_vivos_2': '', // Misión 2 · las plantas
  'seres_vivos_3': '', // Misión 3 · los animales

  // ===== Biología · Tema 5: Biodiversidad y ecosistemas =====
  'ecosistemas_1': '', // Misión 1 · los ecosistemas
  'ecosistemas_2': '', // Misión 2 · cadenas alimenticias
  'ecosistemas_3': '', // Misión 3 · la biodiversidad

  // ===== Electrónica · Tema 1: Conoce los componentes =====
  'componentes_1': '', // Misión 1 · componentes electrónicos
  'componentes_2': '', // Misión 2 · el LED y la resistencia
  'componentes_3': '', // Misión 3 · pilas e interruptores

  // ===== Electrónica · Tema 2: Conecta y enciende =====
  'circuitos_1': '', // Misión 1 · el circuito eléctrico
  'circuitos_2': '', // Misión 2 · serie y paralelo
  'circuitos_3': '', // Misión 3 · conductores y aislantes

  // ===== Electrónica · Tema 3: Detectives electrónicos =====
  'sensores_1': '', // Misión 1 · ¿qué es un sensor?
  'sensores_2': '', // Misión 2 · cómo funcionan los sensores
  'sensores_3': '', // Misión 3 · sensores en la vida diaria

  // ===== Electrónica · Tema 4: Máquinas en movimiento =====
  'maquinas_1': '', // Misión 1 · el motor eléctrico
  'maquinas_2': '', // Misión 2 · los mecanismos
  'maquinas_3': '', // Misión 3 · máquinas en casa

  // ===== Electrónica · Tema 5: Lámpara automática =====
  'inventos_1': '', // Misión 1 · sistemas automáticos
  'inventos_2': '', // Misión 2 · programación por bloques
  'inventos_3': '', // Misión 3 · diseña tu invento

  // ===== Programación · Tema 1: Piensa como programador =====
  'programacion_1': '', // Misión 1 · ¿qué es programar?
  'programacion_2': '', // Misión 2 · pensamiento computacional
  'programacion_3': '', // Misión 3 · resolver problemas

  // ===== Programación · Tema 2: Sigue las instrucciones =====
  'algoritmos_1': '', // Misión 1 · los algoritmos
  'algoritmos_2': '', // Misión 2 · las secuencias
  'algoritmos_3': '', // Misión 3 · diagramas de flujo

  // ===== Programación · Tema 3: Programa con bloques =====
  'bloques_1': '', // Misión 1 · programar con bloques
  'bloques_2': '', // Misión 2 · programa al robot
  'bloques_3': '', // Misión 3 · dibuja con código

  // ===== Programación · Tema 4: Repite y decide =====
  'repite_1': '', // Misión 1 · las decisiones
  'repite_2': '', // Misión 2 · los ciclos
  'repite_3': '', // Misión 3 · ciclos y decisiones

  // ===== Programación · Tema 5: Encuentra el error =====
  'errores_1': '', // Misión 1 · los bugs
  'errores_2': '', // Misión 2 · depurar algoritmos
  'errores_3': '', // Misión 3 · depurar programas

  // ===== Química · Tema 1: El mundo de los materiales =====
  'materiales_1': '', // Misión 1 · los materiales
  'materiales_2': '', // Misión 2 · propiedades de los materiales
  'materiales_3': '', // Misión 3 · usos de los materiales

  // ===== Química · Tema 2: Los gases y sus propiedades =====
  'gases_1': '', // Misión 1 · los gases
  'gases_2': '', // Misión 2 · propiedades de los gases
  'gases_3': '', // Misión 3 · gases en casa

  // ===== Química · Tema 3: Todo se transforma =====
  'cambios_1': '', // Misión 1 · cambios temporales
  'cambios_2': '', // Misión 2 · cambios permanentes
  'cambios_3': '', // Misión 3 · cambios de estado

  // ===== Química · Tema 4: Cocción y descomposición de los alimentos =====
  'coccion_1': '', // Misión 1 · la cocción
  'coccion_2': '', // Misión 2 · la descomposición
  'coccion_3': '', // Misión 3 · conservar alimentos

  // ===== Química · Tema 5: Combustión y oxidación =====
  'combustion_1': '', // Misión 1 · la combustión
  'combustion_2': '', // Misión 2 · la oxidación
  'combustion_3': '', // Misión 3 · el fuego y el ambiente

  // ===== Física · Tema 1: El magnetismo y sus misterios =====
  'magnetismo_1': '', // Misión 1 · los imanes
  'magnetismo_2': '', // Misión 2 · materiales magnéticos
  'magnetismo_3': '', // Misión 3 · la Tierra y la brújula

  // ===== Física · Tema 2: La gravedad en acción =====
  'gravedad_1': '', // Misión 1 · la gravedad
  'gravedad_2': '', // Misión 2 · la caída libre
  'gravedad_3': '', // Misión 3 · efectos de la gravedad

  // ===== Física · Tema 3: Calor y energía térmica =====
  'calor_1': '', // Misión 1 · temperatura y calor
  'calor_2': '', // Misión 2 · transferencia de calor
  'calor_3': '', // Misión 3 · conductores y aislantes

  // ===== Física · Tema 4: La energía que nos rodea =====
  'energia_1': '', // Misión 1 · la electricidad
  'energia_2': '', // Misión 2 · conductores y aislantes
  'energia_3': '', // Misión 3 · ahorra energía

  // ===== Física · Tema 5: Explorando el Sistema Solar =====
  'espacio_1': '', // Misión 1 · el Sistema Solar
  'espacio_2': '', // Misión 2 · los planetas
  'espacio_3': '', // Misión 3 · los movimientos de la Tierra

  // ===== Inteligencia Artificial · Tema 1: Máquinas inteligentes =====
  'ia_1': '', // Misión 1 · ¿qué es la IA?
  'ia_2': '', // Misión 2 · la prueba de Turing
  'ia_3': '', // Misión 3 · agentes inteligentes

  // ===== Inteligencia Artificial · Tema 2: Encuentra el patrón =====
  'patrones_1': '', // Misión 1 · características y semejanzas
  'patrones_2': '', // Misión 2 · secuencias y patrones
  'patrones_3': '', // Misión 3 · las máquinas ven

  // ===== Inteligencia Artificial · Tema 3: Enseña a una máquina =====
  'aprendizaje_1': '', // Misión 1 · ¿cómo aprende una máquina?
  'aprendizaje_2': '', // Misión 2 · entrena una IA
  'aprendizaje_3': '', // Misión 3 · redes neuronales

  // ===== Inteligencia Artificial · Tema 4: Inteligencia en acción =====
  'accion_1': '', // Misión 1 · asistentes inteligentes
  'accion_2': '', // Misión 2 · recomendaciones
  'accion_3': '', // Misión 3 · la IA que ayuda

  // ===== Inteligencia Artificial · Tema 5: Usa la IA con cuidado =====
  'cuidado_1': '', // Misión 1 · la IA se equivoca
  'cuidado_2': '', // Misión 2 · cuida tus datos
  'cuidado_3': '', // Misión 3 · usa la IA con responsabilidad
};
