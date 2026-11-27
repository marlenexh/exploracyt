/// Enlaces de YouTube de los videos del juego.
///
/// Los videos son opcionales y complementarios: aparecen al final de la
/// misión con la leyenda “¿Te quedaron dudas?”. Si un enlace queda vacío, ese
/// paso de video no se muestra.
///
/// Pega entre las comillas el enlace de YouTube de cada video, por ejemplo:
///   'ia_1': 'https://www.youtube.com/watch?v=XXXXXXXXXXX',
/// Sirven enlaces de youtube.com/watch, youtu.be, shorts y embed.
///
/// Importante: el video debe permitir "insertarse" en otros sitios (opción de
/// YouTube Studio); si no, el juego avisa y deja continuar.
const enlacesVideos = <String, String>{
  // ===== Biología · Tema 1: El cuerpo humano y sus sistemas =====
  'circulatorio': 'https://youtu.be/ZzATGDMNKYw?si=dk-NVnMY9i4z6fB6', // Sistema circulatorio
  'respiratorio': 'https://youtu.be/uUpdItCbr24?si=aTC45XJiXvKAcn1f', // Sistema respiratorio
  'inmune': 'https://youtu.be/wkzh7_59p1Q?si=NHchbN73--D2D4mV', // Sistema inmunológico

  // ===== Biología · Tema 2: El mundo de las células =====
  'celulas_1': '', // Misión 1 · ¿qué es una célula?
  'celulas_2': '', // Misión 2 · células animales y vegetales
  'celulas_3': 'https://youtu.be/JFeTBoY-QSc?si=eDWV16LmpA1Loed3', // Misión 3 · la importancia de las células

  // ===== Biología · Tema 3: Alimentación saludable =====
  'alimentacion_1': '', // Misión 1 · los nutrientes
  'alimentacion_2': '', // Misión 2 · el Plato del Bien Comer
  'alimentacion_3': 'https://youtu.be/Wr0_wULJnBE?si=cZQw9vy2bBnIorjw', // Misión 3 · hábitos saludables

  // ===== Biología · Tema 4: La vida a nuestro alrededor =====
  'seres_vivos_1': '', // Misión 1 · los seres vivos
  'seres_vivos_2': '', // Misión 2 · las plantas
  'seres_vivos_3': 'https://youtu.be/HJDSOa_5Zzs?si=-RjrMaaXhE7S65Aa', // Misión 3 · los animales

  // ===== Biología · Tema 5: Biodiversidad y ecosistemas =====
  'ecosistemas_1': '', // Misión 1 · los ecosistemas
  'ecosistemas_2': '', // Misión 2 · cadenas alimenticias
  'ecosistemas_3': 'https://youtu.be/qJx4eirdfPI?si=6hiVbhhxlXVdQD4G', // Misión 3 · la biodiversidad

  // ===== Electrónica · Tema 1: Conoce los componentes =====
  'componentes_1': '', // Misión 1 · componentes electrónicos
  'componentes_2': '', // Misión 2 · el LED y la resistencia
  'componentes_3': 'https://youtu.be/nLioomm3e_c?si=VFEQzq7SXb69LhV0', // Misión 3 · pilas e interruptores

  // ===== Electrónica · Tema 2: Conecta y enciende =====
  'circuitos_1': '', // Misión 1 · el circuito eléctrico
  'circuitos_2': '', // Misión 2 · serie y paralelo
  'circuitos_3': 'https://youtu.be/0aFwgEovuws?si=WtEKTE-X9H-OjO_Z', // Misión 3 · conductores y aislantes

  // ===== Electrónica · Tema 3: Detectives electrónicos =====
  'sensores_1': '', // Misión 1 · ¿qué es un sensor?
  'sensores_2': '', // Misión 2 · cómo funcionan los sensores
  'sensores_3': 'https://youtu.be/2qnw_65E_r0?si=isWqUIh0oEgqk9TW', // Misión 3 · sensores en la vida diaria

  // ===== Electrónica · Tema 4: Máquinas en movimiento =====
  'maquinas_1': '', // Misión 1 · el motor eléctrico
  'maquinas_2': '', // Misión 2 · los mecanismos
  'maquinas_3': 'https://youtu.be/vx71UniH_Xg?si=WkrBbwKmvGrYMRda', // Misión 3 · máquinas en casa

  // ===== Electrónica · Tema 5: Lámpara automática =====
  'inventos_1': '', // Misión 1 · sistemas automáticos
  'inventos_2': '', // Misión 2 · programación por bloques
  'inventos_3': 'https://youtu.be/z5IqRReRKtA?si=tcmvymlXn_yMH5L6', // Misión 3 · diseña tu invento

  // ===== Programación · Tema 1: Piensa como programador =====
  'programacion_1': '', // Misión 1 · ¿qué es programar?
  'programacion_2': '', // Misión 2 · pensamiento computacional
  'programacion_3': 'https://youtu.be/ibsOa90EYq0?si=i6IjkLMn2cZU1fyU', // Misión 3 · resolver problemas

  // ===== Programación · Tema 2: Sigue las instrucciones =====
  'algoritmos_1': '', // Misión 1 · los algoritmos
  'algoritmos_2': '', // Misión 2 · las secuencias
  'algoritmos_3': 'https://youtu.be/VZe9tjqa9xw?si=lYzrQe97rWZJ09L0', // Misión 3 · diagramas de flujo

  // ===== Programación · Tema 3: Programa con bloques =====
  'bloques_1': '', // Misión 1 · programar con bloques
  'bloques_2': '', // Misión 2 · programa al robot
  'bloques_3': 'https://youtu.be/LtCQhxqGeZY?si=lw5x3ASWvHE7h_CH', // Misión 3 · dibuja con código

  // ===== Programación · Tema 4: Repite y decide =====
  'repite_1': '', // Misión 1 · las decisiones
  'repite_2': '', // Misión 2 · los ciclos
  'repite_3': 'https://youtu.be/rNY5eWogl18?si=0vp90NI8GWJhT7wy', // Misión 3 · ciclos y decisiones

  // ===== Programación · Tema 5: Encuentra el error =====
  'errores_1': '', // Misión 1 · los bugs
  'errores_2': '', // Misión 2 · depurar algoritmos
  'errores_3': 'https://youtu.be/eJ89uDLNzco?si=rLHa45QnSsLeyg5S', // Misión 3 · depurar programas

  // ===== Química · Tema 1: El mundo de los materiales =====
  'materiales_1': '', // Misión 1 · los materiales
  'materiales_2': '', // Misión 2 · propiedades de los materiales
  'materiales_3': 'https://youtu.be/-TfjELsFEWk?si=mE3qtIgUdDlByD6m', // Misión 3 · usos de los materiales

  // ===== Química · Tema 2: Los gases y sus propiedades =====
  'gases_1': '', // Misión 1 · los gases
  'gases_2': '', // Misión 2 · propiedades de los gases
  'gases_3': 'https://youtu.be/ducBHqyNjNg?si=Qhxr7PlOBJtwGA5O', // Misión 3 · gases en casa

  // ===== Química · Tema 3: Todo se transforma =====
  'cambios_1': '', // Misión 1 · cambios temporales
  'cambios_2': '', // Misión 2 · cambios permanentes
  'cambios_3': 'https://youtu.be/jL8HtGR_7FU?si=R5Dt55Rra9yITeNi', // Misión 3 · cambios de estado

  // ===== Química · Tema 4: Cocción y descomposición de los alimentos =====
  'coccion_1': '', // Misión 1 · la cocción
  'coccion_2': '', // Misión 2 · la descomposición
  'coccion_3': 'https://youtu.be/SR9SWaN-cOY?si=cFYX72JoxyCmmVqR', // Misión 3 · conservar alimentos

  // ===== Química · Tema 5: Combustión y oxidación =====
  'combustion_1': '', // Misión 1 · la combustión
  'combustion_2': '', // Misión 2 · la oxidación
  'combustion_3': 'https://youtu.be/T4GGmBIvS-M?si=wlxPPFD8FvylQAGK', // Misión 3 · el fuego y el ambiente

  // ===== Física · Tema 1: El magnetismo y sus misterios =====
  'magnetismo_1': '', // Misión 1 · los imanes
  'magnetismo_2': '', // Misión 2 · materiales magnéticos
  'magnetismo_3': 'https://youtu.be/Et8mcU6SJgg?si=LZroeGB1n5aPsRX1', // Misión 3 · la Tierra y la brújula

  // ===== Física · Tema 2: La gravedad en acción =====
  'gravedad_1': '', // Misión 1 · la gravedad
  'gravedad_2': '', // Misión 2 · la caída libre
  'gravedad_3': 'https://youtu.be/CLwNWVrMbGY?si=Hwi9RypbkwWbiwk6', // Misión 3 · efectos de la gravedad

  // ===== Física · Tema 3: Calor y energía térmica =====
  'calor_1': '', // Misión 1 · temperatura y calor
  'calor_2': '', // Misión 2 · transferencia de calor
  'calor_3': 'https://youtu.be/3AF_8Y5yS4U?si=Msb5f2E8SBCr-tor', // Misión 3 · conductores y aislantes

  // ===== Física · Tema 4: La energía que nos rodea =====
  'energia_1': '', // Misión 1 · la electricidad
  'energia_2': '', // Misión 2 · conductores y aislantes
  'energia_3': 'https://youtu.be/a4mY3YMNLz8?si=Ro8st9DyOeIOw0kJ', // Misión 3 · ahorra energía

  // ===== Física · Tema 5: Explorando el Sistema Solar =====
  'espacio_1': '', // Misión 1 · el Sistema Solar
  'espacio_2': '', // Misión 2 · los planetas
  'espacio_3': 'https://youtu.be/cuAFkLBGcWg?si=BUufeEOkXhdcfoAi', // Misión 3 · los movimientos de la Tierra

  // ===== Inteligencia Artificial · Tema 1: Máquinas inteligentes =====
  'ia_1': '', // Misión 1 · ¿qué es la IA?
  'ia_2': '', // Misión 2 · la prueba de Turing
  'ia_3': 'https://youtu.be/UKncFg0PyEk?si=TsZUJZ-5HzVpjDWH', // Misión 3 · agentes inteligentes

  // ===== Inteligencia Artificial · Tema 2: Encuentra el patrón =====
  'patrones_1': '', // Misión 1 · características y semejanzas
  'patrones_2': '', // Misión 2 · secuencias y patrones
  'patrones_3': 'https://youtu.be/KhE3e8knHSw?si=YB_a66cPzN8mtYew', // Misión 3 · las máquinas ven

  // ===== Inteligencia Artificial · Tema 3: Enseña a una máquina =====
  'aprendizaje_1': '', // Misión 1 · ¿cómo aprende una máquina?
  'aprendizaje_2': '', // Misión 2 · entrena una IA
  'aprendizaje_3': 'https://youtu.be/NdNyYcAJQr8?si=jxsEAK4c0-uNx2Hv', // Misión 3 · redes neuronales

  // ===== Inteligencia Artificial · Tema 4: Inteligencia en acción =====
  'accion_1': '', // Misión 1 · asistentes inteligentes
  'accion_2': '', // Misión 2 · recomendaciones
  'accion_3': 'https://youtu.be/EkDCEHEjBes?si=7af4bbsIIXVRC97U', // Misión 3 · la IA que ayuda

  // ===== Inteligencia Artificial · Tema 5: Usa la IA con cuidado =====
  'cuidado_1': '', // Misión 1 · la IA se equivoca
  'cuidado_2': '', // Misión 2 · cuida tus datos
  'cuidado_3': 'https://youtu.be/yq_9LGdveVA?si=_JiJb6u16U9gvW85', // Misión 3 · usa la IA con responsabilidad
};
