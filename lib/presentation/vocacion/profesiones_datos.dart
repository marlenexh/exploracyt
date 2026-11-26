import 'package:flutter/material.dart';

/// Datos de las profesiones de ciencia y tecnología de “Explora profesiones”.
class ProfesionInfo {
  const ProfesionInfo({
    required this.nombre,
    required this.emoji,
    required this.area,
    required this.color,
    required this.descripcion,
    required this.queHace,
    required this.herramientas,
    required this.dondeTrabaja,
    required this.dia,
    required this.mundos,
    required this.reto,
    required this.dato,
  });
  final String nombre, emoji, area, descripcion, dato;
  final Color color;
  final List<String> queHace;

  /// (emoji, nombre)
  final List<(String, String)> herramientas;

  /// (emoji, lugar)
  final List<(String, String)> dondeTrabaja;

  /// (hora, emoji, actividad)
  final List<(String, String, String)> dia;

  /// Mundos del juego relacionados.
  final List<String> mundos;

  /// (pregunta, opciones, índice correcto, explicación)
  final (String, List<String>, int, String) reto;
}

/// Áreas para filtrar: (nombre, emoji, color).
const areasProfesiones = [
  ('Biología', '🌿', Color(0xFF2E9E5B)),
  ('Química', '🧪', Color(0xFF8E24AA)),
  ('Física', '⚛️', Color(0xFF1E88E5)),
  ('Electrónica', '⚡', Color(0xFFEF6C00)),
  ('Inteligencia Artificial', '🤖', Color(0xFFD81B60)),
  ('Programación', '💻', Color(0xFF00897B)),
  ('Salud', '🩺', Color(0xFFE53935)),
  ('Espacio', '🚀', Color(0xFF3949AB)),
  ('Planeta', '🌎', Color(0xFF558B2F)),
  ('Ingeniería', '🏗️', Color(0xFF6D4C41)),
];

Color colorArea(String area) => areasProfesiones.firstWhere((a) => a.$1 == area, orElse: () => areasProfesiones.first).$3;
String emojiArea(String area) => areasProfesiones.firstWhere((a) => a.$1 == area, orElse: () => areasProfesiones.first).$2;

const profesiones = [
  // Biología
  ProfesionInfo(
    nombre: 'Bióloga / Biólogo',
    emoji: '🌿',
    area: 'Biología',
    color: Color(0xFF2E9E5B),
    descripcion: 'Estudia a los seres vivos: plantas, animales, hongos y microorganismos, y cómo se relacionan con su ambiente.',
    queHace: [
      'Observa y describe especies en su hábitat.',
      'Investiga cómo viven, crecen y se reproducen los organismos.',
      'Ayuda a proteger especies en peligro.'
    ],
    herramientas: [('🔬', 'Microscopio'), ('🔭', 'Binoculares'), ('📓', 'Bitácora de campo'), ('📷', 'Cámara trampa')],
    dondeTrabaja: [('🌳', 'Bosques y selvas'), ('🏛️', 'Museos'), ('🧫', 'Laboratorios')],
    dia: [
      ('7:00', '🥾', 'Camina al bosque para revisar las cámaras trampa.'),
      ('10:00', '🦋', 'Cuenta mariposas y anota sus colores.'),
      ('14:00', '🔬', 'Observa hojas al microscopio en el laboratorio.'),
      ('17:00', '📝', 'Escribe un informe para proteger la zona.')
    ],
    mundos: ['Biología'],
    reto: (
      'Encuentras una planta desconocida. ¿Qué haces primero?',
      ['Observarla y anotar sus características', 'Arrancarla para llevártela', 'Ignorarla'],
      0,
      'La ciencia empieza observando con cuidado y sin dañar.'
    ),
    dato: 'Cada año se descubren miles de especies nuevas: ¡todavía hay muchísimas por conocer!',
  ),
  ProfesionInfo(
    nombre: 'Veterinaria / Veterinario',
    emoji: '🐾',
    area: 'Biología',
    color: Color(0xFF43A047),
    descripcion: 'Cuida la salud de los animales: mascotas, animales de granja y fauna silvestre.',
    queHace: ['Revisa y cura animales enfermos.', 'Pone vacunas para prevenir enfermedades.', 'Enseña a las familias a cuidar a sus mascotas.'],
    herramientas: [('🩺', 'Estetoscopio'), ('💉', 'Vacunas'), ('⚖️', 'Báscula'), ('🩻', 'Rayos X')],
    dondeTrabaja: [('🏥', 'Clínicas veterinarias'), ('🐄', 'Granjas'), ('🦁', 'Zoológicos')],
    dia: [
      ('8:00', '🐶', 'Revisa a un perrito que no quiere comer.'),
      ('11:00', '💉', 'Vacuna a varios gatitos.'),
      ('15:00', '🐄', 'Visita una granja para revisar a las vacas.'),
      ('18:00', '🦉', 'Atiende a un búho herido que trajeron al refugio.')
    ],
    mundos: ['Biología'],
    reto: (
      '¿Por qué se vacuna a las mascotas?',
      ['Para prevenir enfermedades', 'Para que crezcan más', 'Para que no ladren'],
      0,
      'Las vacunas preparan sus defensas, como las nuestras.'
    ),
    dato: 'Los veterinarios de zoológico atienden desde ranas diminutas hasta elefantes de más de 5 toneladas.',
  ),
  ProfesionInfo(
    nombre: 'Genetista',
    emoji: '🧬',
    area: 'Biología',
    color: Color(0xFF00897B),
    descripcion: 'Estudia el ADN: las instrucciones que cada ser vivo hereda de sus padres.',
    queHace: ['Investiga cómo se heredan características como el color de ojos.', 'Busca el origen de algunas enfermedades.', 'Ayuda a mejorar cultivos.'],
    herramientas: [('🧬', 'Secuenciador de ADN'), ('🧫', 'Cajas de Petri'), ('🔬', 'Microscopio'), ('💻', 'Computadora')],
    dondeTrabaja: [('🧪', 'Laboratorios'), ('🏥', 'Hospitales'), ('🎓', 'Universidades')],
    dia: [
      ('9:00', '🧫', 'Prepara muestras de ADN.'),
      ('11:00', '🧬', 'Usa una máquina que lee las letras del ADN.'),
      ('14:00', '💻', 'Compara millones de letras con la computadora.'),
      ('17:00', '👩‍⚕️', 'Explica los resultados a un médico.')
    ],
    mundos: ['Biología', 'Programación'],
    reto: (
      '¿Qué guarda el ADN?',
      ['Las instrucciones de un ser vivo', 'La energía del Sol', 'El agua del cuerpo'],
      0,
      'El ADN es como el manual de instrucciones de cada ser vivo.'
    ),
    dato: 'Si estiraras todo el ADN de una sola célula humana, ¡mediría cerca de 2 metros!',
  ),
  // Química
  ProfesionInfo(
    nombre: 'Química / Químico',
    emoji: '🧪',
    area: 'Química',
    color: Color(0xFF8E24AA),
    descripcion: 'Estudia de qué están hechas las cosas y cómo se transforman al mezclarse o calentarse.',
    queHace: [
      'Hace experimentos con sustancias.',
      'Crea materiales nuevos, como plásticos que se degradan.',
      'Revisa que el agua y los alimentos sean seguros.'
    ],
    herramientas: [('⚗️', 'Matraz'), ('🧪', 'Tubos de ensayo'), ('🥽', 'Lentes de seguridad'), ('⚖️', 'Balanza')],
    dondeTrabaja: [('🧪', 'Laboratorios'), ('🏭', 'Fábricas'), ('💧', 'Plantas de agua')],
    dia: [
      ('8:00', '🥽', 'Se pone bata, lentes y guantes.'),
      ('10:00', '⚗️', 'Mezcla sustancias y mide la temperatura.'),
      ('13:00', '📊', 'Anota qué cambió en cada prueba.'),
      ('16:00', '🧴', 'Prueba un jabón nuevo que cuida el ambiente.')
    ],
    mundos: ['Química'],
    reto: (
      '¿Qué es lo primero en un laboratorio?',
      ['Ponerse el equipo de seguridad', 'Probar las sustancias', 'Mezclar todo rápido'],
      0,
      'La seguridad siempre va primero.'
    ),
    dato: 'Todo lo que te rodea, incluso tú, está hecho de unos 118 elementos químicos combinados.',
  ),
  ProfesionInfo(
    nombre: 'Farmacéutica / Farmacéutico',
    emoji: '💊',
    area: 'Química',
    color: Color(0xFFAB47BC),
    descripcion: 'Investiga y prepara medicamentos, y enseña a usarlos de forma segura.',
    queHace: ['Crea y prueba medicinas nuevas.', 'Revisa que cada medicina tenga la dosis correcta.', 'Explica a las personas cómo tomar sus medicamentos.'],
    herramientas: [('⚖️', 'Balanza de precisión'), ('🧪', 'Probetas'), ('💊', 'Cápsulas'), ('📋', 'Recetas')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🏪', 'Farmacias'), ('🧪', 'Laboratorios')],
    dia: [
      ('9:00', '📋', 'Revisa las recetas del día.'),
      ('11:00', '⚖️', 'Mide con precisión los ingredientes de un jarabe.'),
      ('14:00', '🧪', 'Prueba que una medicina nueva sea estable.'),
      ('17:00', '🗣️', 'Explica a una abuelita cómo tomar su tratamiento.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Por qué es importante medir bien una medicina?',
      ['Porque la dosis correcta cura y una incorrecta puede dañar', 'Porque sabe mejor', 'No importa'],
      0,
      'En las medicinas, la cantidad exacta hace la diferencia.'
    ),
    dato: 'La aspirina se hizo a partir de una sustancia que se encuentra en la corteza del sauce.',
  ),
  ProfesionInfo(
    nombre: 'Científica de alimentos',
    emoji: '🍞',
    area: 'Química',
    color: Color(0xFFFF8F00),
    descripcion: 'Estudia los alimentos para que sean nutritivos, sabrosos y duren más sin echarse a perder.',
    queHace: ['Inventa formas de conservar los alimentos.', 'Revisa que no tengan microbios dañinos.', 'Mejora el sabor y la nutrición.'],
    herramientas: [('🌡️', 'Termómetro'), ('🧫', 'Cultivos'), ('🔬', 'Microscopio'), ('🥣', 'Cocina de pruebas')],
    dondeTrabaja: [('🏭', 'Fábricas de alimentos'), ('🧪', 'Laboratorios'), ('🌽', 'Campos de cultivo')],
    dia: [
      ('8:00', '🧫', 'Busca microbios en muestras de leche.'),
      ('10:00', '🌡️', 'Prueba a qué temperatura se conserva mejor un yogur.'),
      ('13:00', '😋', 'Hace una cata de sabores con su equipo.'),
      ('16:00', '🏷️', 'Escribe la información nutrimental de la etiqueta.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Cómo se conservan los alimentos por más tiempo?',
      ['En frío o sin humedad', 'Al sol y húmedos', 'Abiertos al aire'],
      0,
      'El frío y la falta de agua frenan a los microbios.'
    ),
    dato: 'La miel bien guardada casi nunca se echa a perder.',
  ),
  // Física
  ProfesionInfo(
    nombre: 'Física / Físico',
    emoji: '⚛️',
    area: 'Física',
    color: Color(0xFF1E88E5),
    descripcion: 'Investiga cómo funcionan la energía, la luz, el movimiento, el calor y el universo.',
    queHace: ['Hace experimentos para entender fuerzas y energía.', 'Usa las matemáticas para explicar la naturaleza.', 'Ayuda a crear tecnología nueva.'],
    herramientas: [('🧲', 'Imanes'), ('🔦', 'Láser'), ('🧮', 'Matemáticas'), ('💻', 'Simulaciones')],
    dondeTrabaja: [('🎓', 'Universidades'), ('🔬', 'Laboratorios'), ('🏢', 'Empresas de tecnología')],
    dia: [
      ('9:00', '🔦', 'Prepara un experimento con un láser.'),
      ('11:00', '📏', 'Mide con mucha precisión cómo se mueve la luz.'),
      ('14:00', '🧮', 'Resuelve ecuaciones con su equipo.'),
      ('17:00', '🎤', 'Da una charla para estudiantes.')
    ],
    mundos: ['Física'],
    reto: (
      '¿Qué hace que una pelota lanzada caiga al suelo?',
      ['La gravedad', 'El magnetismo', 'El sonido'],
      0,
      'La gravedad jala todo hacia el centro de la Tierra.'
    ),
    dato: 'La luz es tan rápida que podría darle casi 7.5 vueltas a la Tierra en un segundo.',
  ),
  ProfesionInfo(
    nombre: 'Meteoróloga / Meteorólogo',
    emoji: '🌦️',
    area: 'Física',
    color: Color(0xFF039BE5),
    descripcion: 'Estudia la atmósfera para pronosticar el clima y avisar de huracanes y tormentas.',
    queHace: ['Mide temperatura, viento y humedad.', 'Pronostica el clima de los próximos días.', 'Avisa a tiempo cuando viene un huracán.'],
    herramientas: [('🛰️', 'Satélites'), ('🎈', 'Globos meteorológicos'), ('🌡️', 'Termómetros'), ('📡', 'Radar')],
    dondeTrabaja: [('📡', 'Servicio meteorológico'), ('📺', 'Televisión'), ('✈️', 'Aeropuertos')],
    dia: [
      ('6:00', '🎈', 'Suelta un globo que mide el aire allá arriba.'),
      ('9:00', '🛰️', 'Revisa imágenes de satélite de las nubes.'),
      ('12:00', '💻', 'Corre un modelo del clima en la computadora.'),
      ('19:00', '📺', 'Presenta el pronóstico del tiempo.')
    ],
    mundos: ['Física', 'Programación'],
    reto: (
      'Si el radar muestra nubes muy oscuras acercándose, ¿qué pronosticas?',
      ['Lluvia o tormenta', 'Un día soleado', 'Nieve en la playa'],
      0,
      'Las nubes densas suelen traer lluvia.'
    ),
    dato: 'Los huracanes se forman sobre el mar caliente y pueden medir cientos de kilómetros.',
  ),
  ProfesionInfo(
    nombre: 'Sismóloga / Sismólogo',
    emoji: '🌋',
    area: 'Planeta',
    color: Color(0xFF6D4C41),
    descripcion: 'Estudia los sismos y los volcanes para entender cómo se mueve el interior de la Tierra.',
    queHace: ['Registra los temblores con sismógrafos.', 'Vigila volcanes activos.', 'Ayuda a crear alertas sísmicas.'],
    herramientas: [('📈', 'Sismógrafo'), ('🛰️', 'GPS'), ('🗺️', 'Mapas geológicos'), ('🌡️', 'Sensores de gas')],
    dondeTrabaja: [('🏛️', 'Servicio Sismológico'), ('🌋', 'Observatorios de volcanes'), ('🎓', 'Universidades')],
    dia: [
      ('8:00', '📈', 'Revisa los temblores registrados en la noche.'),
      ('10:00', '🌋', 'Sube a medir los gases de un volcán.'),
      ('14:00', '🗺️', 'Marca en el mapa dónde ocurrieron los sismos.'),
      ('17:00', '🚨', 'Prueba el sistema de alerta sísmica.')
    ],
    mundos: ['Física'],
    reto: ('¿Qué mide un sismógrafo?', ['El movimiento de la tierra', 'La temperatura', 'La lluvia'], 0, 'Dibuja las vibraciones del suelo.'),
    dato: 'México tiene una de las alertas sísmicas más antiguas del mundo: avisa segundos antes de que llegue el temblor.',
  ),
  // Electrónica
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero electrónico',
    emoji: '🔌',
    area: 'Electrónica',
    color: Color(0xFFEF6C00),
    descripcion: 'Diseña los circuitos que hacen funcionar celulares, computadoras, autos y aparatos médicos.',
    queHace: ['Diseña circuitos y placas electrónicas.', 'Prueba que los aparatos funcionen bien.', 'Repara y mejora máquinas.'],
    herramientas: [('🔌', 'Protoboard'), ('📟', 'Multímetro'), ('🔥', 'Cautín'), ('💻', 'Simulador de circuitos')],
    dondeTrabaja: [('🏭', 'Fábricas'), ('🏥', 'Hospitales'), ('🏢', 'Empresas de tecnología')],
    dia: [
      ('9:00', '💻', 'Simula un circuito nuevo en la computadora.'),
      ('11:00', '🔌', 'Lo arma en una protoboard.'),
      ('14:00', '📟', 'Mide voltajes con el multímetro.'),
      ('16:00', '🔥', 'Suelda las piezas en la placa final.')
    ],
    mundos: ['Electrónica'],
    reto: (
      '¿Para qué sirve una resistencia junto a un LED?',
      ['Para que no se queme', 'Para que brille de colores', 'Para que haga sonido'],
      0,
      'Limita la corriente que pasa por el LED.'
    ),
    dato: 'Un celular moderno tiene miles de millones de transistores más pequeños que un virus.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero en robótica',
    emoji: '🦾',
    area: 'Electrónica',
    color: Color(0xFFF4511E),
    descripcion: 'Crea robots que ayudan en fábricas, hospitales, casas e incluso en otros planetas.',
    queHace: ['Diseña el cuerpo y los motores del robot.', 'Conecta sensores para que el robot perciba.', 'Lo programa para que decida qué hacer.'],
    herramientas: [('⚙️', 'Motores'), ('📷', 'Sensores'), ('🧠', 'Microcontrolador'), ('🖨️', 'Impresora 3D')],
    dondeTrabaja: [('🏭', 'Fábricas'), ('🚀', 'Agencias espaciales'), ('🏥', 'Hospitales')],
    dia: [
      ('9:00', '🖨️', 'Imprime en 3D la mano de un robot.'),
      ('11:00', '⚙️', 'Le conecta motores para mover los dedos.'),
      ('14:00', '💻', 'Programa cómo debe agarrar objetos.'),
      ('17:00', '🤖', 'Prueba el robot y corrige errores.')
    ],
    mundos: ['Electrónica', 'Programación', 'Inteligencia Artificial'],
    reto: ('¿Qué necesita un robot para “ver” un obstáculo?', ['Un sensor', 'Una pila más grande', 'Pintura'], 0, 'Los sensores son sus sentidos.'),
    dato: 'Los vehículos exploradores de Marte son robots que se manejan desde la Tierra, ¡a millones de kilómetros!',
  ),
  ProfesionInfo(
    nombre: 'Especialista en energías renovables',
    emoji: '☀️',
    area: 'Electrónica',
    color: Color(0xFFFFA000),
    descripcion: 'Instala y mejora paneles solares, aerogeneradores y otras fuentes de energía limpia.',
    queHace: ['Calcula cuánta energía necesita una casa o escuela.', 'Instala paneles solares y baterías.', 'Busca formas de contaminar menos.'],
    herramientas: [('☀️', 'Paneles solares'), ('🌬️', 'Aerogeneradores'), ('🔋', 'Baterías'), ('📟', 'Medidor de energía')],
    dondeTrabaja: [('🏠', 'Casas y escuelas'), ('🌾', 'Parques eólicos'), ('🏢', 'Empresas de energía')],
    dia: [
      ('8:00', '🧮', 'Calcula cuántos paneles necesita una escuela.'),
      ('10:00', '☀️', 'Instala paneles en el techo.'),
      ('14:00', '🔋', 'Conecta las baterías.'),
      ('16:00', '📊', 'Revisa cuánta energía produjeron hoy.')
    ],
    mundos: ['Electrónica', 'Física'],
    reto: ('¿Cuál es una fuente de energía renovable?', ['El Sol', 'El petróleo', 'El carbón'], 0, 'La energía del Sol no se acaba.'),
    dato: 'En Oaxaca, en el Istmo de Tehuantepec, hay grandes parques de aerogeneradores por sus fuertes vientos.',
  ),
  // Inteligencia Artificial
  ProfesionInfo(
    nombre: 'Especialista en inteligencia artificial',
    emoji: '🤖',
    area: 'Inteligencia Artificial',
    color: Color(0xFFD81B60),
    descripcion: 'Enseña a las computadoras a reconocer patrones, entender el lenguaje y tomar decisiones.',
    queHace: ['Reúne y prepara datos de ejemplo.', 'Entrena modelos de IA.', 'Revisa que la IA sea justa y no tenga sesgos.'],
    herramientas: [('📊', 'Datos'), ('🧠', 'Redes neuronales'), ('💻', 'Computadoras potentes'), ('🏷️', 'Etiquetas')],
    dondeTrabaja: [('🏢', 'Empresas de tecnología'), ('🏥', 'Hospitales'), ('🎓', 'Universidades')],
    dia: [
      ('9:00', '📊', 'Revisa miles de imágenes de ejemplo.'),
      ('11:00', '🏷️', 'Corrige etiquetas equivocadas.'),
      ('14:00', '🏋️', 'Entrena su modelo de IA.'),
      ('17:00', '⚖️', 'Prueba que la IA trate igual a todas las personas.')
    ],
    mundos: ['Inteligencia Artificial'],
    reto: (
      'Una IA solo vio fotos de gatos negros y no reconoce un gato blanco. ¿Qué haces?',
      ['Agregar datos más variados', 'Apagarla', 'Pintar al gato'],
      0,
      'Con datos variados la IA aprende mejor.'
    ),
    dato: 'Algunas IA ayudan a los médicos a encontrar enfermedades en radiografías.',
  ),
  ProfesionInfo(
    nombre: 'Científica / Científico de datos',
    emoji: '📊',
    area: 'Inteligencia Artificial',
    color: Color(0xFFC2185B),
    descripcion: 'Busca patrones en grandes cantidades de datos para responder preguntas y tomar mejores decisiones.',
    queHace: ['Junta y ordena datos.', 'Hace gráficas para encontrar patrones.', 'Predice lo que puede pasar.'],
    herramientas: [('📈', 'Gráficas'), ('🗄️', 'Bases de datos'), ('🐍', 'Python'), ('🧮', 'Estadística')],
    dondeTrabaja: [('🏢', 'Empresas'), ('🏛️', 'Gobierno'), ('⚽', 'Equipos deportivos')],
    dia: [
      ('9:00', '🗄️', 'Descarga los datos de ventas de una tienda.'),
      ('11:00', '🧹', 'Limpia datos repetidos o con errores.'),
      ('14:00', '📈', 'Hace gráficas y encuentra un patrón.'),
      ('16:00', '🗣️', 'Explica sus descubrimientos al equipo.')
    ],
    mundos: ['Inteligencia Artificial', 'Programación'],
    reto: (
      '¿Para qué sirve una gráfica?',
      ['Para ver patrones en los datos', 'Para decorar', 'Para borrar datos'],
      0,
      'Las gráficas muestran lo que los números esconden.'
    ),
    dato: 'Los equipos de fútbol usan datos para saber dónde patean más sus rivales.',
  ),
  // Programación
  ProfesionInfo(
    nombre: 'Programadora / Programador',
    emoji: '💻',
    area: 'Programación',
    color: Color(0xFF00897B),
    descripcion: 'Escribe las instrucciones (código) que hacen funcionar apps, páginas web y videojuegos.',
    queHace: ['Crea algoritmos para resolver problemas.', 'Escribe y prueba código.', 'Busca y corrige errores (bugs).'],
    herramientas: [('⌨️', 'Teclado'), ('🧩', 'Lenguajes de programación'), ('🐞', 'Depurador'), ('☁️', 'Internet')],
    dondeTrabaja: [('🏢', 'Empresas de software'), ('🏠', 'Desde casa'), ('🏦', 'Bancos y tiendas')],
    dia: [
      ('9:00', '☕', 'Planea con su equipo qué van a construir.'),
      ('10:00', '⌨️', 'Escribe el código de una función nueva.'),
      ('14:00', '🐞', 'Encuentra y corrige un bug.'),
      ('17:00', '🚀', 'Publica la nueva versión de la app.')
    ],
    mundos: ['Programación'],
    reto: (
      '¿Qué es un bug?',
      ['Un error en el programa', 'Un tipo de computadora', 'Un videojuego'],
      0,
      'Los programadores dedican mucho tiempo a encontrar y corregir bugs.'
    ),
    dato: 'Se cuenta que en 1947 encontraron una polilla atorada en una computadora: de ahí la palabra “bug” (bicho).',
  ),
  ProfesionInfo(
    nombre: 'Desarrolladora de videojuegos',
    emoji: '🎮',
    area: 'Programación',
    color: Color(0xFF7E57C2),
    descripcion: 'Crea videojuegos: inventa la historia, programa las reglas y diseña los mundos y personajes.',
    queHace: ['Diseña niveles y retos.', 'Programa cómo se mueven los personajes.', 'Prueba el juego con jugadores.'],
    herramientas: [('🕹️', 'Motor de videojuegos'), ('🎨', 'Tableta de dibujo'), ('🎵', 'Música y efectos'), ('🐞', 'Pruebas')],
    dondeTrabaja: [('🏢', 'Estudios de videojuegos'), ('🏠', 'Estudios independientes'), ('🎓', 'Escuelas')],
    dia: [
      ('10:00', '✏️', 'Dibuja el plano de un nivel nuevo.'),
      ('12:00', '💻', 'Programa un enemigo que salta.'),
      ('15:00', '🕹️', 'Niños prueban el juego y dan ideas.'),
      ('17:00', '🔧', 'Ajusta lo que estaba muy difícil.')
    ],
    mundos: ['Programación', 'Física'],
    reto: (
      'En un juego de plataformas, ¿qué ciencia hace que el personaje caiga después de saltar?',
      ['La física (gravedad)', 'La biología', 'La química'],
      0,
      'Los juegos simulan la gravedad.'
    ),
    dato: 'En muchos videojuegos trabajan programadores, artistas, músicos, escritores y testers juntos.',
  ),
  ProfesionInfo(
    nombre: 'Especialista en ciberseguridad',
    emoji: '🛡️',
    area: 'Programación',
    color: Color(0xFF283593),
    descripcion: 'Protege las computadoras, las redes y nuestros datos de ataques y robos de información.',
    queHace: ['Busca puntos débiles en los sistemas.', 'Crea contraseñas y candados digitales.', 'Detiene virus y ataques.'],
    herramientas: [('🔐', 'Cifrado'), ('🧱', 'Cortafuegos'), ('🕵️', 'Monitoreo'), ('🔑', 'Contraseñas seguras')],
    dondeTrabaja: [('🏦', 'Bancos'), ('🏛️', 'Gobierno'), ('🏢', 'Empresas')],
    dia: [
      ('9:00', '🕵️', 'Revisa alertas de actividad extraña.'),
      ('11:00', '🔐', 'Prueba si una app guarda bien las contraseñas.'),
      ('14:00', '🧱', 'Bloquea un intento de ataque.'),
      ('16:00', '👩‍🏫', 'Enseña a sus compañeros a no caer en engaños.')
    ],
    mundos: ['Programación', 'Inteligencia Artificial'],
    reto: ('¿Cuál es la contraseña más segura?', ['Gato.Luna7!Verde', '123456', 'contraseña'], 0, 'Larga, con letras, números y símbolos.'),
    dato: 'Una contraseña larga es mucho más difícil de adivinar que una corta, aunque sea sencilla de recordar.',
  ),
  // Salud
  ProfesionInfo(
    nombre: 'Médica / Médico',
    emoji: '🩺',
    area: 'Salud',
    color: Color(0xFFE53935),
    descripcion: 'Previene, diagnostica y trata enfermedades para cuidar la salud de las personas.',
    queHace: ['Revisa a sus pacientes y escucha lo que sienten.', 'Pide estudios para encontrar la causa.', 'Indica tratamientos y hábitos saludables.'],
    herramientas: [('🩺', 'Estetoscopio'), ('🌡️', 'Termómetro'), ('🩻', 'Radiografías'), ('💉', 'Vacunas')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🏘️', 'Centros de salud'), ('🚑', 'Ambulancias')],
    dia: [
      ('8:00', '🩺', 'Escucha el corazón de un niño.'),
      ('10:00', '🩻', 'Revisa una radiografía de un brazo.'),
      ('13:00', '💉', 'Vacuna a bebés en el centro de salud.'),
      ('16:00', '📚', 'Estudia los avances más nuevos.')
    ],
    mundos: ['Biología', 'Química'],
    reto: (
      '¿Qué escucha el médico con el estetoscopio?',
      ['El corazón y los pulmones', 'La radio', 'El estómago cantar'],
      0,
      'Así revisa cómo late el corazón y cómo respiras.'
    ),
    dato: 'Tu corazón late unas 100 000 veces al día.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero biomédico',
    emoji: '🦿',
    area: 'Salud',
    color: Color(0xFFEC407A),
    descripcion: 'Une la medicina con la ingeniería para crear prótesis, aparatos médicos y tecnología que salva vidas.',
    queHace: ['Diseña prótesis de brazos y piernas.', 'Crea y repara aparatos de hospital.', 'Inventa sensores para medir la salud.'],
    herramientas: [('🖨️', 'Impresora 3D'), ('🔌', 'Sensores'), ('💻', 'Diseño por computadora'), ('🩺', 'Equipos médicos')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🏭', 'Fábricas de equipo médico'), ('🎓', 'Universidades')],
    dia: [
      ('9:00', '📏', 'Mide la pierna de un paciente.'),
      ('11:00', '💻', 'Diseña una prótesis a su medida.'),
      ('14:00', '🖨️', 'La imprime en 3D.'),
      ('16:00', '🚶', 'Ayuda al paciente a dar sus primeros pasos con ella.')
    ],
    mundos: ['Biología', 'Electrónica'],
    reto: (
      '¿Qué hace una prótesis?',
      ['Reemplaza una parte del cuerpo', 'Mide la temperatura', 'Cura resfriados'],
      0,
      'Ayuda a las personas a moverse y a realizar sus actividades.'
    ),
    dato: 'Hay prótesis de mano que se mueven con las señales eléctricas de los músculos.',
  ),
  // Espacio
  ProfesionInfo(
    nombre: 'Astronauta',
    emoji: '👩‍🚀',
    area: 'Espacio',
    color: Color(0xFF3949AB),
    descripcion: 'Viaja al espacio para hacer experimentos, reparar satélites y explorar.',
    queHace: ['Hace experimentos en la Estación Espacial.', 'Repara equipos en caminatas espaciales.', 'Entrena muchos años antes de viajar.'],
    herramientas: [('🚀', 'Cohete'), ('👨‍🚀', 'Traje espacial'), ('🛰️', 'Estación espacial'), ('🦾', 'Brazo robótico')],
    dondeTrabaja: [('🛰️', 'Estación Espacial Internacional'), ('🏛️', 'Agencias espaciales'), ('🏊', 'Albercas de entrenamiento')],
    dia: [
      ('6:00', '🏋️', 'Hace ejercicio para que sus huesos no se debiliten.'),
      ('9:00', '🧪', 'Estudia cómo crecen plantas sin gravedad.'),
      ('13:00', '🛠️', 'Sale a una caminata espacial.'),
      ('20:00', '🌍', 'Mira la Tierra por la ventana antes de dormir.')
    ],
    mundos: ['Física', 'Biología'],
    reto: (
      '¿Por qué los astronautas flotan en la estación espacial?',
      ['Porque caen junto con la estación alrededor de la Tierra', 'Porque no hay gravedad en ningún lado', 'Porque son muy ligeros'],
      0,
      'Están en caída libre continua.'
    ),
    dato: 'Rodolfo Neri Vela fue el primer astronauta mexicano: viajó al espacio en 1985.',
  ),
  ProfesionInfo(
    nombre: 'Astrónoma / Astrónomo',
    emoji: '🔭',
    area: 'Espacio',
    color: Color(0xFF5C6BC0),
    descripcion: 'Estudia las estrellas, los planetas, las galaxias y todo lo que hay en el universo.',
    queHace: ['Observa el cielo con telescopios.', 'Descubre planetas alrededor de otras estrellas.', 'Calcula distancias enormes.'],
    herramientas: [('🔭', 'Telescopio'), ('📷', 'Cámaras especiales'), ('🛰️', 'Telescopios espaciales'), ('💻', 'Computadoras')],
    dondeTrabaja: [('🏔️', 'Observatorios'), ('🎓', 'Universidades'), ('🪐', 'Planetarios')],
    dia: [
      ('14:00', '💻', 'Prepara la lista de estrellas a observar.'),
      ('20:00', '🔭', 'Abre la cúpula del observatorio.'),
      ('23:00', '📷', 'Toma fotos de una galaxia lejana.'),
      ('3:00', '🌠', 'Registra una lluvia de estrellas.')
    ],
    mundos: ['Física'],
    reto: (
      '¿Por qué los observatorios están en montañas altas?',
      ['Hay menos nubes y menos luz de las ciudades', 'Para estar más cerca del Sol', 'Porque hace calor'],
      0,
      'El cielo se ve más claro y oscuro.'
    ),
    dato: 'En el volcán Sierra Negra, en Puebla, está el Gran Telescopio Milimétrico, uno de los más grandes de su tipo.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero aeroespacial',
    emoji: '🚀',
    area: 'Espacio',
    color: Color(0xFF1A237E),
    descripcion: 'Diseña aviones, cohetes, satélites y naves espaciales.',
    queHace: ['Calcula cómo vuela una nave.', 'Diseña motores y alas.', 'Prueba los materiales en condiciones extremas.'],
    herramientas: [('🌬️', 'Túnel de viento'), ('💻', 'Simulaciones'), ('🛰️', 'Satélites'), ('🧮', 'Matemáticas')],
    dondeTrabaja: [('🏭', 'Fábricas de aviones'), ('🚀', 'Agencias espaciales'), ('🎓', 'Universidades')],
    dia: [
      ('9:00', '💻', 'Simula el despegue de un cohete.'),
      ('11:00', '🌬️', 'Prueba un ala en el túnel de viento.'),
      ('14:00', '🛰️', 'Revisa los paneles de un satélite.'),
      ('17:00', '🧮', 'Calcula cuánto combustible se necesita.')
    ],
    mundos: ['Física', 'Electrónica'],
    reto: (
      '¿Qué ayuda a un avión a mantenerse en el aire?',
      ['La forma de sus alas y la velocidad', 'Que pesa muy poco', 'Los imanes'],
      0,
      'El aire empuja las alas hacia arriba.'
    ),
    dato: 'Querétaro es uno de los estados de México con más fábricas de partes para aviones.',
  ),
  // Planeta e ingeniería
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero ambiental',
    emoji: '♻️',
    area: 'Planeta',
    color: Color(0xFF558B2F),
    descripcion: 'Busca soluciones para cuidar el agua, el aire y el suelo, y reducir la contaminación.',
    queHace: ['Diseña plantas para limpiar el agua.', 'Mide la contaminación del aire.', 'Crea planes de reciclaje.'],
    herramientas: [('💧', 'Análisis de agua'), ('🌫️', 'Medidores de aire'), ('♻️', 'Reciclaje'), ('🗺️', 'Mapas')],
    dondeTrabaja: [('💧', 'Plantas de tratamiento'), ('🏛️', 'Gobierno'), ('🌳', 'Reservas naturales')],
    dia: [
      ('8:00', '💧', 'Toma muestras del agua de un río.'),
      ('10:00', '🧪', 'Analiza si tiene contaminantes.'),
      ('13:00', '♻️', 'Diseña un plan de reciclaje para una escuela.'),
      ('16:00', '🌳', 'Reforesta con voluntarios.')
    ],
    mundos: ['Química', 'Biología'],
    reto: ('¿Qué ayuda a reducir la basura?', ['Reducir, reutilizar y reciclar', 'Quemar todo', 'Tirarla al río'], 0, 'Las 3R cuidan el planeta.'),
    dato: 'Una botella de plástico puede tardar cientos de años en degradarse.',
  ),
  ProfesionInfo(
    nombre: 'Oceanógrafa / Oceanógrafo',
    emoji: '🌊',
    area: 'Planeta',
    color: Color(0xFF0277BD),
    descripcion: 'Estudia los océanos: sus corrientes, su vida marina y cómo influyen en el clima.',
    queHace: ['Explora el fondo del mar.', 'Estudia arrecifes y animales marinos.', 'Mide la temperatura del océano.'],
    herramientas: [('🤿', 'Equipo de buceo'), ('🚢', 'Barco de investigación'), ('🤖', 'Robots submarinos'), ('🌡️', 'Boyas con sensores')],
    dondeTrabaja: [('🚢', 'Barcos'), ('🏝️', 'Costas'), ('🐠', 'Acuarios')],
    dia: [
      ('7:00', '🚢', 'Sale en el barco de investigación.'),
      ('9:00', '🤿', 'Bucea para revisar un arrecife de coral.'),
      ('13:00', '🤖', 'Manda un robot a lo más profundo.'),
      ('17:00', '📊', 'Compara la temperatura del agua con años anteriores.')
    ],
    mundos: ['Biología', 'Física'],
    reto: (
      '¿Qué parte de la Tierra está cubierta por océanos?',
      ['Más de dos terceras partes', 'Una décima parte', 'La mitad exacta'],
      0,
      'Alrededor del 70 % del planeta es océano.'
    ),
    dato: 'El Mar de Cortés, en México, es llamado “el acuario del mundo” por su enorme biodiversidad.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniera / Ingeniero civil',
    emoji: '🏗️',
    area: 'Ingeniería',
    color: Color(0xFF6D4C41),
    descripcion: 'Diseña y construye puentes, edificios, carreteras y presas seguras y resistentes.',
    queHace: ['Calcula cuánto peso aguanta una estructura.', 'Diseña construcciones resistentes a sismos.', 'Supervisa obras.'],
    herramientas: [('📐', 'Planos'), ('🧮', 'Cálculos'), ('🦺', 'Casco y chaleco'), ('🚧', 'Maquinaria')],
    dondeTrabaja: [('🏗️', 'Obras'), ('🏢', 'Oficinas de diseño'), ('🛣️', 'Carreteras')],
    dia: [
      ('8:00', '🦺', 'Se pone el casco y llega a la obra.'),
      ('10:00', '📐', 'Revisa que los planos se cumplan.'),
      ('13:00', '🧮', 'Calcula cuánto peso aguanta una viga.'),
      ('16:00', '🌉', 'Prueba un modelo de puente.')
    ],
    mundos: ['Física'],
    reto: (
      '¿Por qué los edificios en México deben resistir sismos?',
      ['Porque el país tiene muchos temblores', 'Para que se vean bonitos', 'Por el calor'],
      0,
      'Las construcciones seguras salvan vidas.'
    ),
    dato: 'Los triángulos se usan mucho en puentes porque son figuras muy resistentes.',
  ),
];
