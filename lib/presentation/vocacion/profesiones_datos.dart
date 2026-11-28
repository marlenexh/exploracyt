import 'package:flutter/material.dart';

/// Profesiones (carreras) de ciencia y tecnología de “Explora profesiones”.
/// Cada una tiene una escena animada (ver escena_profesion.dart).
enum EscenaProfesion {
  naturaleza,
  adn,
  salud,
  laboratorio,
  comida,
  atomos,
  cerebro,
  computadora,
  taller,
  fabrica,
  construccion,
  espacio,
  energia,
  datos,
  ia,
  red
}

class ProfesionInfo {
  const ProfesionInfo({
    required this.nombre,
    required this.emoji,
    required this.area,
    required this.color,
    required this.escena,
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
  final EscenaProfesion escena;
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
  ('Ciencias de la vida', '🧬', Color(0xFF2E9E5B)),
  ('Planeta y energía', '🌎', Color(0xFF558B2F)),
  ('Química', '🧪', Color(0xFF8E24AA)),
  ('Física', '⚛️', Color(0xFF1E88E5)),
  ('Computación', '💻', Color(0xFF00897B)),
  ('Ingeniería', '⚙️', Color(0xFFEF6C00)),
];

Color colorArea(String area) => areasProfesiones.firstWhere((a) => a.$1 == area, orElse: () => areasProfesiones.first).$3;
String emojiArea(String area) => areasProfesiones.firstWhere((a) => a.$1 == area, orElse: () => areasProfesiones.first).$2;

const profesiones = [
  ProfesionInfo(
    nombre: 'Biología',
    emoji: '🔬',
    area: 'Ciencias de la vida',
    color: Color(0xFF2E9E5B),
    escena: EscenaProfesion.naturaleza,
    descripcion: 'Estudia a los seres vivos: plantas, animales, hongos y microorganismos, y cómo se relacionan con su ambiente.',
    queHace: [
      'Observa y describe especies en su hábitat.',
      'Investiga cómo viven, crecen y se reproducen los organismos.',
      'Ayuda a proteger especies en peligro.'
    ],
    herramientas: [('🔬', 'Microscopio'), ('🔭', 'Binoculares'), ('📓', 'Bitácora de campo'), ('📷', 'Cámara trampa')],
    dondeTrabaja: [('🌳', 'Bosques y selvas'), ('🧫', 'Laboratorios'), ('🏛️', 'Museos')],
    dia: [
      ('7:00', '🥾', 'Camina al bosque para revisar las cámaras trampa.'),
      ('10:00', '🦋', 'Cuenta mariposas y anota sus colores.'),
      ('14:00', '🔬', 'Observa hojas al microscopio.'),
      ('17:00', '📝', 'Escribe un informe para proteger la zona.')
    ],
    mundos: ['Biología'],
    reto: (
      'Encuentras una planta desconocida. ¿Qué haces primero?',
      ['Observarla y anotar cómo es', 'Arrancarla para llevártela', 'Ignorarla'],
      0,
      'La ciencia empieza observando con cuidado y sin dañar.'
    ),
    dato: 'Cada año se descubren miles de especies nuevas: ¡todavía hay muchísimas por conocer!',
  ),
  ProfesionInfo(
    nombre: 'Ecología',
    emoji: '🦋',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.naturaleza,
    descripcion: 'Estudia cómo se relacionan los seres vivos entre sí y con su ambiente: quién come a quién, quién ayuda a quién.',
    queHace: ['Estudia cadenas alimenticias y ecosistemas.', 'Mide cómo cambia un bosque, un río o un arrecife.', 'Propone cómo restaurar lugares dañados.'],
    herramientas: [('🗺️', 'Mapas'), ('📏', 'Cinta métrica'), ('🛰️', 'Imágenes de satélite'), ('📓', 'Bitácora')],
    dondeTrabaja: [('🏞️', 'Áreas naturales protegidas'), ('🏫', 'Universidades'), ('🏢', 'Organizaciones ambientales')],
    dia: [
      ('7:00', '🌅', 'Llega temprano a un humedal para contar aves.'),
      ('11:00', '🐸', 'Revisa cuántas ranas viven en el estanque.'),
      ('15:00', '💻', 'Compara sus datos con los del año pasado.'),
      ('18:00', '🗣️', 'Explica a la comunidad cómo cuidar el humedal.')
    ],
    mundos: ['Biología'],
    reto: (
      'Si desaparecen las abejas de un lugar, ¿qué les pasa a las plantas con flor?',
      ['Tienen menos semillas porque nadie las poliniza', 'Crecen más', 'No les pasa nada'],
      0,
      'Las abejas llevan el polen de flor en flor: sin ellas, muchas plantas no producen frutos.'
    ),
    dato: 'Un solo árbol grande puede ser el hogar de cientos de especies de insectos, aves y hongos.',
  ),
  ProfesionInfo(
    nombre: 'Ciencias Ambientales',
    emoji: '🌎',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.naturaleza,
    descripcion: 'Busca soluciones a los problemas del ambiente: contaminación, basura, agua y cambio climático.',
    queHace: ['Mide la calidad del aire, del agua y del suelo.', 'Diseña planes para reducir la basura.', 'Ayuda a comunidades a cuidar sus recursos.'],
    herramientas: [('🧪', 'Kits de análisis de agua'), ('🌡️', 'Sensores de temperatura'), ('📊', 'Gráficas'), ('🗺️', 'Mapas')],
    dondeTrabaja: [('🏞️', 'Ríos y lagos'), ('🏛️', 'Gobierno'), ('🏭', 'Empresas')],
    dia: [
      ('8:00', '🚰', 'Toma muestras de agua de un río.'),
      ('11:00', '🧪', 'Analiza si el agua está limpia.'),
      ('15:00', '♻️', 'Visita una escuela para enseñar a separar basura.'),
      ('17:00', '📊', 'Prepara una gráfica con sus resultados.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Qué ayuda más a reducir la basura?',
      ['Reusar y reciclar', 'Quemar la basura', 'Tirarla en el río'],
      0,
      'Reusar y reciclar evita que la basura llegue a ríos y mares.'
    ),
    dato: 'Una botella de plástico puede tardar cientos de años en desaparecer.',
  ),
  ProfesionInfo(
    nombre: 'Ciencias Genómicas',
    emoji: '🧬',
    area: 'Ciencias de la vida',
    color: Color(0xFF2E9E5B),
    escena: EscenaProfesion.adn,
    descripcion: 'Estudia el ADN: las instrucciones que tienen todas las células para formar y hacer funcionar a un ser vivo.',
    queHace: ['Lee el ADN de plantas, animales y microbios.', 'Busca qué genes causan algunas enfermedades.', 'Ayuda a crear cultivos más resistentes.'],
    herramientas: [('🧬', 'Secuenciador de ADN'), ('🧫', 'Cajas de cultivo'), ('💻', 'Computadora'), ('🧊', 'Congelador especial')],
    dondeTrabaja: [('🧫', 'Laboratorios de genética'), ('🏥', 'Hospitales'), ('🏫', 'Universidades')],
    dia: [
      ('9:00', '🧪', 'Saca el ADN de unas hojas de maíz.'),
      ('11:00', '🧬', 'Pone las muestras en el secuenciador.'),
      ('14:00', '💻', 'Compara millones de letras de ADN en la computadora.'),
      ('17:00', '📝', 'Escribe qué encontró.')
    ],
    mundos: ['Biología', 'Programación'],
    reto: (
      '¿Dónde está el ADN?',
      ['Dentro de las células', 'Solo en la sangre', 'En el aire'],
      0,
      'Casi todas las células tienen ADN en su interior, con las instrucciones del ser vivo.'
    ),
    dato: 'Si estiraras el ADN de una sola célula humana, ¡mediría casi 2 metros!',
  ),
  ProfesionInfo(
    nombre: 'Bioquímica Diagnóstica',
    emoji: '🧫',
    area: 'Ciencias de la vida',
    color: Color(0xFF2E9E5B),
    escena: EscenaProfesion.salud,
    descripcion: 'Analiza muestras de sangre y otros líquidos del cuerpo para ayudar a saber si una persona está sana o enferma.',
    queHace: ['Hace análisis de sangre y de orina.', 'Detecta bacterias y virus.', 'Entrega resultados para que los médicos decidan el tratamiento.'],
    herramientas: [('🧪', 'Tubos de ensayo'), ('🔬', 'Microscopio'), ('🌀', 'Centrífuga'), ('🧤', 'Guantes')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🧫', 'Laboratorios clínicos'), ('🏫', 'Universidades')],
    dia: [
      ('7:00', '🩸', 'Recibe muestras de sangre.'),
      ('9:00', '🌀', 'Separa la sangre con la centrífuga.'),
      ('12:00', '🔬', 'Busca bacterias al microscopio.'),
      ('16:00', '📄', 'Entrega los resultados al médico.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Para qué sirve un análisis de sangre?',
      ['Para saber cómo está la salud', 'Para pintar', 'Para medir la estatura'],
      0,
      'La sangre da muchas pistas de cómo funciona el cuerpo.'
    ),
    dato: 'Una gota de sangre tiene millones de glóbulos rojos.',
  ),
  ProfesionInfo(
    nombre: 'Química',
    emoji: '⚗️',
    area: 'Química',
    color: Color(0xFF8E24AA),
    escena: EscenaProfesion.laboratorio,
    descripcion: 'Estudia de qué están hechas las cosas y cómo se transforman al mezclarse, calentarse o reaccionar.',
    queHace: ['Mezcla sustancias para crear materiales nuevos.', 'Analiza de qué está hecho un material.', 'Busca formas más limpias de fabricar productos.'],
    herramientas: [('⚗️', 'Matraces'), ('🧪', 'Tubos de ensayo'), ('⚖️', 'Balanza'), ('🥽', 'Lentes de seguridad')],
    dondeTrabaja: [('🧫', 'Laboratorios'), ('🏭', 'Industrias'), ('🏫', 'Universidades')],
    dia: [
      ('8:00', '🥽', 'Se pone bata y lentes de seguridad.'),
      ('10:00', '⚗️', 'Mezcla dos sustancias y observa el cambio de color.'),
      ('13:00', '⚖️', 'Pesa con cuidado el nuevo material.'),
      ('16:00', '📓', 'Anota todo en su bitácora.')
    ],
    mundos: ['Química'],
    reto: (
      'Antes de un experimento, ¿qué es lo más importante?',
      ['Ponerse el equipo de seguridad', 'Probar las sustancias', 'Correr'],
      0,
      'La seguridad va primero: bata, lentes y guantes.'
    ),
    dato: 'Todo lo que existe está hecho de poco más de 100 tipos de átomos.',
  ),
  ProfesionInfo(
    nombre: 'Química de Alimentos',
    emoji: '🍞',
    area: 'Química',
    color: Color(0xFF8E24AA),
    escena: EscenaProfesion.comida,
    descripcion: 'Estudia de qué están hechos los alimentos y cómo hacer que sean más nutritivos, seguros y sabrosos.',
    queHace: ['Analiza los nutrientes de los alimentos.', 'Busca cómo conservarlos más tiempo sin que se echen a perder.', 'Revisa que la comida sea segura.'],
    herramientas: [('🧪', 'Tubos de ensayo'), ('🌡️', 'Termómetro'), ('⚖️', 'Balanza'), ('🔬', 'Microscopio')],
    dondeTrabaja: [('🏭', 'Fábricas de alimentos'), ('🧫', 'Laboratorios de calidad'), ('🍽️', 'Restaurantes')],
    dia: [
      ('8:00', '🍓', 'Revisa una nueva mermelada.'),
      ('10:00', '🌡️', 'Mide a qué temperatura se conserva mejor.'),
      ('13:00', '🔬', 'Busca microbios en una muestra.'),
      ('16:00', '📋', 'Escribe la etiqueta de nutrientes.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Por qué refrigeramos la leche?',
      ['Para que los microbios crezcan más lento', 'Para que cambie de color', 'Para que pese menos'],
      0,
      'El frío frena a los microbios que echan a perder la comida.'
    ),
    dato: 'La miel bien guardada casi nunca se echa a perder: ¡se ha encontrado miel de miles de años!',
  ),
  ProfesionInfo(
    nombre: 'Química Farmacéutico Biológica',
    emoji: '💊',
    area: 'Química',
    color: Color(0xFF8E24AA),
    escena: EscenaProfesion.laboratorio,
    descripcion: 'Crea y prueba medicinas para que sean seguras y ayuden a curar enfermedades.',
    queHace: ['Diseña y prepara medicamentos.', 'Prueba que las medicinas funcionen y sean seguras.', 'Orienta a las personas sobre cómo tomarlas.'],
    herramientas: [('💊', 'Medicinas'), ('🧪', 'Tubos de ensayo'), ('⚖️', 'Balanza de precisión'), ('🧤', 'Guantes')],
    dondeTrabaja: [('🏭', 'Laboratorios farmacéuticos'), ('🏥', 'Hospitales'), ('💊', 'Farmacias')],
    dia: [
      ('8:00', '🧤', 'Prepara su área de trabajo limpia.'),
      ('10:00', '⚗️', 'Mezcla los ingredientes de un jarabe.'),
      ('13:00', '🔬', 'Revisa que no tenga microbios.'),
      ('16:00', '💬', 'Explica a una persona cómo tomar su medicina.')
    ],
    mundos: ['Química', 'Biología'],
    reto: (
      '¿Por qué no debemos tomar medicinas sin receta?',
      ['Porque pueden hacer daño si no son las adecuadas', 'Porque saben feo', 'Porque son caras'],
      0,
      'Cada medicina sirve para algo específico y en cierta cantidad.'
    ),
    dato: 'La penicilina, una de las primeras medicinas contra bacterias, se descubrió por un moho.',
  ),
  ProfesionInfo(
    nombre: 'Física',
    emoji: '⚛️',
    area: 'Física',
    color: Color(0xFF1E88E5),
    escena: EscenaProfesion.atomos,
    descripcion: 'Estudia cómo funciona el universo: la luz, el movimiento, la energía, la electricidad y los átomos.',
    queHace: ['Hace experimentos con luz, imanes y movimiento.', 'Usa las matemáticas para explicar la naturaleza.', 'Ayuda a crear nuevas tecnologías.'],
    herramientas: [('🔭', 'Telescopio'), ('🧲', 'Imanes'), ('💡', 'Láser'), ('🧮', 'Matemáticas')],
    dondeTrabaja: [('🏫', 'Universidades'), ('🔭', 'Observatorios'), ('🧫', 'Laboratorios')],
    dia: [
      ('9:00', '🧲', 'Prepara un experimento con imanes.'),
      ('11:00', '💡', 'Mide la velocidad de la luz en un láser.'),
      ('15:00', '🧮', 'Resuelve ecuaciones en el pizarrón.'),
      ('20:00', '🔭', 'Observa estrellas en el observatorio.')
    ],
    mundos: ['Física'],
    reto: ('¿Por qué las cosas caen al suelo?', ['Por la gravedad', 'Por el viento', 'Por magia'], 0, 'La gravedad jala todo hacia el centro de la Tierra.'),
    dato: 'La luz del Sol tarda unos 8 minutos en llegar a la Tierra.',
  ),
  ProfesionInfo(
    nombre: 'Física Biomédica',
    emoji: '🩻',
    area: 'Física',
    color: Color(0xFF1E88E5),
    escena: EscenaProfesion.salud,
    descripcion: 'Usa la física para cuidar la salud: rayos X, ultrasonidos, resonancias y aparatos médicos.',
    queHace: ['Opera y mejora aparatos como los de rayos X.', 'Calcula dosis seguras de radiación.', 'Ayuda a ver el interior del cuerpo sin cirugía.'],
    herramientas: [('🩻', 'Rayos X'), ('🧲', 'Resonancia magnética'), ('🔊', 'Ultrasonido'), ('💻', 'Computadora')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🧫', 'Centros de investigación'), ('🏫', 'Universidades')],
    dia: [
      ('8:00', '🩻', 'Revisa que la máquina de rayos X funcione bien.'),
      ('11:00', '🧲', 'Ayuda en un estudio de resonancia.'),
      ('14:00', '🧮', 'Calcula una dosis segura para un tratamiento.'),
      ('17:00', '💻', 'Mejora un programa que muestra imágenes del cuerpo.')
    ],
    mundos: ['Física', 'Electrónica'],
    reto: (
      '¿Qué permite ver un hueso sin abrir el cuerpo?',
      ['Los rayos X', 'Una lupa', 'Una linterna'],
      0,
      'Los rayos X atraviesan la piel pero no tanto los huesos.'
    ),
    dato: 'Las resonancias usan imanes miles de veces más fuertes que los del refrigerador.',
  ),
  ProfesionInfo(
    nombre: 'Ciencia de la Nutrición Humana',
    emoji: '🥗',
    area: 'Ciencias de la vida',
    color: Color(0xFF2E9E5B),
    escena: EscenaProfesion.comida,
    descripcion: 'Estudia cómo los alimentos ayudan al cuerpo y diseña dietas para que las personas crezcan sanas.',
    queHace: ['Diseña planes de alimentación saludables.', 'Investiga cómo los nutrientes afectan la salud.', 'Enseña a comer bien.'],
    herramientas: [('⚖️', 'Báscula'), ('📏', 'Cinta métrica'), ('🥦', 'Plato del bien comer'), ('💻', 'Computadora')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🏫', 'Escuelas'), ('⚽', 'Equipos deportivos')],
    dia: [
      ('8:00', '🥣', 'Platica con una familia sobre el desayuno.'),
      ('11:00', '⚖️', 'Mide el crecimiento de unos niños y niñas.'),
      ('14:00', '📋', 'Diseña un menú para una escuela.'),
      ('17:00', '⚽', 'Ayuda a un equipo a comer mejor.')
    ],
    mundos: ['Biología'],
    reto: (
      '¿Qué bebida es mejor para tu cuerpo todos los días?',
      ['Agua simple', 'Refresco', 'Bebida energética'],
      0,
      'El agua simple hidrata sin azúcar extra.'
    ),
    dato: 'Tu cuerpo es casi 60 % agua.',
  ),
  ProfesionInfo(
    nombre: 'Ciencias Agroforestales',
    emoji: '🌲',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.naturaleza,
    descripcion: 'Cuida y aprovecha los bosques y el campo juntos: árboles, cultivos y animales de forma sustentable.',
    queHace: ['Planta árboles junto con cultivos.', 'Cuida que los bosques no se acaben.', 'Ayuda a familias del campo a producir mejor.'],
    herramientas: [('🌱', 'Semillas'), ('🪓', 'Herramientas de campo'), ('📏', 'Medidor de árboles'), ('🛰️', 'Mapas satelitales')],
    dondeTrabaja: [('🌲', 'Bosques'), ('🌾', 'Campos de cultivo'), ('🏡', 'Comunidades rurales')],
    dia: [
      ('7:00', '🌲', 'Mide qué tanto crecieron unos árboles.'),
      ('10:00', '🌱', 'Siembra café bajo la sombra de los árboles.'),
      ('14:00', '🗺️', 'Hace un mapa del bosque.'),
      ('17:00', '🤝', 'Se reúne con productores del pueblo.')
    ],
    mundos: ['Biología'],
    reto: (
      '¿Por qué es bueno sembrar árboles junto a los cultivos?',
      ['Dan sombra, cuidan el suelo y el agua', 'Tapan el sol para siempre', 'No sirve de nada'],
      0,
      'Los árboles protegen el suelo y ayudan a guardar agua.'
    ),
    dato: 'Los bosques de México guardan miles de especies de árboles distintas.',
  ),
  ProfesionInfo(
    nombre: 'Ciencias Agrogenómicas',
    emoji: '🌽',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.adn,
    descripcion: 'Usa la genética para mejorar los cultivos: plantas más nutritivas y resistentes a plagas y sequías.',
    queHace: ['Estudia el ADN de las plantas.', 'Busca variedades que resistan la sequía.', 'Conserva semillas nativas como las del maíz.'],
    herramientas: [('🧬', 'Análisis de ADN'), ('🌱', 'Invernadero'), ('🔬', 'Microscopio'), ('💻', 'Computadora')],
    dondeTrabaja: [('🌱', 'Invernaderos'), ('🌽', 'Campos experimentales'), ('🧫', 'Laboratorios')],
    dia: [
      ('8:00', '🌽', 'Revisa plantas de maíz en el invernadero.'),
      ('10:00', '🧬', 'Saca ADN de unas hojas.'),
      ('14:00', '💻', 'Compara genes de distintas semillas.'),
      ('17:00', '🫘', 'Guarda semillas nativas en el banco de semillas.')
    ],
    mundos: ['Biología', 'Programación'],
    reto: (
      '¿Por qué es importante guardar semillas nativas?',
      ['Para conservar la variedad de plantas', 'Para no sembrar nunca', 'Para venderlas todas'],
      0,
      'Las semillas nativas tienen genes valiosos que podrían ayudarnos en el futuro.'
    ),
    dato: 'En México hay más de 60 razas de maíz distintas.',
  ),
  ProfesionInfo(
    nombre: 'Neurociencias',
    emoji: '🧠',
    area: 'Ciencias de la vida',
    color: Color(0xFF2E9E5B),
    escena: EscenaProfesion.cerebro,
    descripcion: 'Estudia el cerebro y el sistema nervioso: cómo pensamos, aprendemos, sentimos y recordamos.',
    queHace: ['Investiga cómo se comunican las neuronas.', 'Estudia cómo aprendemos y recordamos.', 'Busca tratamientos para enfermedades del cerebro.'],
    herramientas: [('🧠', 'Modelos del cerebro'), ('🔬', 'Microscopio'), ('📈', 'Electroencefalograma'), ('💻', 'Computadora')],
    dondeTrabaja: [('🏥', 'Hospitales'), ('🧫', 'Laboratorios'), ('🏫', 'Universidades')],
    dia: [
      ('9:00', '🔬', 'Observa neuronas al microscopio.'),
      ('11:00', '📈', 'Mide la actividad del cerebro mientras alguien lee.'),
      ('14:00', '💻', 'Analiza los datos.'),
      ('17:00', '🗣️', 'Explica sus descubrimientos en una plática.')
    ],
    mundos: ['Biología', 'Inteligencia Artificial'],
    reto: ('¿Qué ayuda más a tu cerebro a aprender?', ['Dormir bien', 'Desvelarse', 'No comer'], 0, 'Mientras duermes, tu cerebro ordena lo que aprendiste.'),
    dato: 'Tu cerebro tiene unos 86 mil millones de neuronas.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería en Computación',
    emoji: '🖥️',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.computadora,
    descripcion: 'Diseña computadoras y sus partes, y hace que el hardware y los programas trabajen juntos.',
    queHace: ['Diseña circuitos y piezas de computadoras.', 'Programa dispositivos y robots.', 'Mejora la velocidad de los equipos.'],
    herramientas: [('💻', 'Computadora'), ('🔌', 'Circuitos'), ('🧰', 'Herramientas'), ('📟', 'Osciloscopio')],
    dondeTrabaja: [('🏢', 'Empresas de tecnología'), ('🏭', 'Fábricas de electrónicos'), ('🏫', 'Universidades')],
    dia: [
      ('9:00', '🔌', 'Arma el prototipo de una tarjeta electrónica.'),
      ('11:00', '💻', 'Programa un microcontrolador.'),
      ('14:00', '📟', 'Mide señales con el osciloscopio.'),
      ('17:00', '🤖', 'Prueba que el robot responda.')
    ],
    mundos: ['Electrónica', 'Programación'],
    reto: (
      '¿Qué parte de la computadora hace los cálculos?',
      ['El procesador', 'El monitor', 'El teclado'],
      0,
      'El procesador es como el cerebro de la computadora.'
    ),
    dato: 'Un celular de hoy es miles de veces más poderoso que las computadoras que llevaron humanos a la Luna.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería en Sistemas Computacionales',
    emoji: '🗄️',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.computadora,
    descripcion: 'Organiza y conecta los sistemas informáticos de escuelas, hospitales y empresas para que funcionen bien y seguros.',
    queHace: ['Diseña sistemas para guardar y ordenar información.', 'Conecta computadoras en redes.', 'Protege los datos de ataques.'],
    herramientas: [('💻', 'Computadora'), ('🗄️', 'Servidores'), ('🔒', 'Seguridad'), ('🌐', 'Redes')],
    dondeTrabaja: [('🏢', 'Empresas'), ('🏥', 'Hospitales'), ('🏦', 'Bancos')],
    dia: [
      ('8:00', '🗄️', 'Revisa que los servidores funcionen.'),
      ('10:00', '🔒', 'Actualiza la seguridad del sistema.'),
      ('13:00', '💻', 'Diseña la base de datos de una escuela.'),
      ('16:00', '🤝', 'Explica el sistema a quienes lo usarán.')
    ],
    mundos: ['Programación'],
    reto: (
      '¿Qué es una contraseña segura?',
      ['Una larga, con letras, números y símbolos', 'Tu nombre', '1234'],
      0,
      'Las contraseñas largas y variadas son más difíciles de adivinar.'
    ),
    dato: 'Cada día se envían miles de millones de correos electrónicos en el mundo.',
  ),
  ProfesionInfo(
    nombre: 'Ciencias de la Computación',
    emoji: '🧮',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.computadora,
    descripcion: 'Estudia cómo resolver problemas con algoritmos y cómo funcionan los programas por dentro.',
    queHace: ['Inventa algoritmos rápidos.', 'Estudia qué problemas pueden resolver las computadoras.', 'Crea nuevos lenguajes y herramientas.'],
    herramientas: [('🧮', 'Matemáticas'), ('💻', 'Computadora'), ('📝', 'Pizarrón'), ('🧩', 'Algoritmos')],
    dondeTrabaja: [('🏫', 'Universidades'), ('🏢', 'Empresas de tecnología'), ('🧫', 'Centros de investigación')],
    dia: [
      ('9:00', '📝', 'Dibuja un algoritmo en el pizarrón.'),
      ('11:00', '💻', 'Lo programa y lo prueba.'),
      ('14:00', '⏱️', 'Mide qué tan rápido funciona.'),
      ('17:00', '👩‍🏫', 'Enseña una clase de programación.')
    ],
    mundos: ['Programación', 'Inteligencia Artificial'],
    reto: (
      '¿Qué es un algoritmo?',
      ['Una lista de pasos para resolver algo', 'Un tipo de computadora', 'Un videojuego'],
      0,
      'Las recetas de cocina también son algoritmos.'
    ),
    dato: 'El primer algoritmo para una máquina lo escribió Ada Lovelace hace casi 200 años.',
  ),
  ProfesionInfo(
    nombre: 'Desarrollo de software',
    emoji: '📱',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.computadora,
    descripcion: 'Crea aplicaciones, páginas web y videojuegos que usamos todos los días.',
    queHace: ['Programa apps y páginas web.', 'Busca y corrige errores (bugs).', 'Trabaja en equipo para crear videojuegos.'],
    herramientas: [('💻', 'Computadora'), ('📱', 'Celular de pruebas'), ('🐞', 'Depurador'), ('🎨', 'Diseño')],
    dondeTrabaja: [('🏢', 'Empresas de software'), ('🏡', 'Desde casa'), ('🎮', 'Estudios de videojuegos')],
    dia: [
      ('9:00', '☕', 'Se reúne con su equipo para planear el día.'),
      ('10:00', '💻', 'Programa una nueva pantalla de la app.'),
      ('14:00', '🐞', 'Encuentra y corrige un bug.'),
      ('17:00', '📱', 'Prueba la app en un celular.')
    ],
    mundos: ['Programación'],
    reto: (
      'Tu app tiene un error. ¿Qué haces?',
      ['Revisar el código paso a paso', 'Tirar la computadora', 'Ignorarlo'],
      0,
      'Depurar es revisar con calma hasta encontrar el error.'
    ),
    dato: 'Algunos videojuegos tienen millones de líneas de código.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Mecánica',
    emoji: '⚙️',
    area: 'Ingeniería',
    color: Color(0xFFEF6C00),
    escena: EscenaProfesion.taller,
    descripcion: 'Diseña y construye máquinas: motores, autos, bicicletas, robots y herramientas.',
    queHace: ['Diseña piezas y máquinas.', 'Calcula si una pieza resistirá el uso.', 'Repara y mejora motores.'],
    herramientas: [('⚙️', 'Engranes'), ('🔧', 'Llaves'), ('📐', 'Planos'), ('💻', 'Diseño por computadora')],
    dondeTrabaja: [('🏭', 'Fábricas'), ('🚗', 'Industria automotriz'), ('✈️', 'Industria aeronáutica')],
    dia: [
      ('8:00', '📐', 'Dibuja el plano de una pieza.'),
      ('10:00', '💻', 'Hace un modelo 3D en la computadora.'),
      ('13:00', '🔧', 'Arma un prototipo en el taller.'),
      ('16:00', '🧪', 'Prueba si la pieza resiste.')
    ],
    mundos: ['Física', 'Electrónica'],
    reto: (
      '¿Para qué sirven los engranes?',
      ['Para pasar el movimiento de una pieza a otra', 'Para decorar', 'Para dar luz'],
      0,
      'Los engranes giran juntos y pueden cambiar la velocidad o la fuerza.'
    ),
    dato: 'Un auto tiene alrededor de 30 mil piezas.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Industrial',
    emoji: '🏭',
    area: 'Ingeniería',
    color: Color(0xFFEF6C00),
    escena: EscenaProfesion.fabrica,
    descripcion: 'Organiza fábricas y procesos para que todo funcione mejor, más rápido, seguro y con menos desperdicio.',
    queHace: ['Mejora cómo se fabrican los productos.', 'Cuida la seguridad de quienes trabajan.', 'Reduce el desperdicio de material y energía.'],
    herramientas: [('📊', 'Gráficas'), ('⏱️', 'Cronómetro'), ('📋', 'Listas de control'), ('💻', 'Simulación')],
    dondeTrabaja: [('🏭', 'Fábricas'), ('📦', 'Centros de distribución'), ('🏥', 'Hospitales')],
    dia: [
      ('8:00', '🏭', 'Recorre la línea de producción.'),
      ('10:00', '⏱️', 'Mide cuánto tarda cada paso.'),
      ('13:00', '📊', 'Encuentra dónde se atora el proceso.'),
      ('16:00', '💡', 'Propone una mejora al equipo.')
    ],
    mundos: ['Programación'],
    reto: (
      '¿Qué es lo más importante en una fábrica?',
      ['La seguridad de las personas', 'Ir lo más rápido posible', 'Gastar más'],
      0,
      'Primero la seguridad, después la rapidez.'
    ),
    dato: 'Organizar mejor una fábrica puede ahorrar mucha energía sin comprar máquinas nuevas.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Civil',
    emoji: '🏗️',
    area: 'Ingeniería',
    color: Color(0xFFEF6C00),
    escena: EscenaProfesion.construccion,
    descripcion: 'Diseña y construye puentes, carreteras, edificios, presas y sistemas de agua potable.',
    queHace: ['Diseña estructuras seguras ante sismos.', 'Supervisa obras de construcción.', 'Planea calles y redes de agua.'],
    herramientas: [('📐', 'Planos'), ('🏗️', 'Grúas'), ('🦺', 'Casco y chaleco'), ('🧱', 'Materiales')],
    dondeTrabaja: [('🏗️', 'Obras de construcción'), ('🏛️', 'Gobierno'), ('🏢', 'Constructoras')],
    dia: [
      ('7:00', '🦺', 'Se pone casco y chaleco para entrar a la obra.'),
      ('9:00', '📐', 'Revisa que la obra siga los planos.'),
      ('13:00', '🧱', 'Prueba la resistencia del concreto.'),
      ('16:00', '💻', 'Calcula cómo resistirá el edificio un sismo.')
    ],
    mundos: ['Física'],
    reto: (
      '¿Por qué los edificios deben resistir sismos?',
      ['Para proteger a las personas', 'Para verse bonitos', 'Para ser más altos'],
      0,
      'En México tiembla seguido: por eso se diseñan estructuras seguras.'
    ),
    dato: 'El puente Baluarte, entre Durango y Sinaloa, es uno de los puentes atirantados más altos del mundo.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Química',
    emoji: '🧴',
    area: 'Química',
    color: Color(0xFF8E24AA),
    escena: EscenaProfesion.fabrica,
    descripcion: 'Lleva los experimentos del laboratorio a la fábrica para producir materiales, combustibles, medicinas y alimentos.',
    queHace: ['Diseña plantas para producir sustancias.', 'Cuida que los procesos sean seguros y limpios.', 'Busca reducir la contaminación.'],
    herramientas: [('⚗️', 'Reactores'), ('🌡️', 'Sensores'), ('🧪', 'Laboratorio'), ('📊', 'Gráficas')],
    dondeTrabaja: [('🏭', 'Industria química'), ('⚡', 'Plantas de energía'), ('🍫', 'Fábricas de alimentos')],
    dia: [
      ('8:00', '🏭', 'Revisa los tanques de la planta.'),
      ('10:00', '🌡️', 'Ajusta la temperatura de un reactor.'),
      ('13:00', '🧪', 'Analiza la calidad del producto.'),
      ('16:00', '♻️', 'Diseña cómo reutilizar el agua.')
    ],
    mundos: ['Química'],
    reto: (
      '¿Qué hace una planta química?',
      ['Produce sustancias en gran cantidad', 'Cultiva flores', 'Vende ropa'],
      0,
      'Lo que en el laboratorio se hace en un tubo, en la planta se hace en tanques enormes.'
    ),
    dato: 'El jabón que usas se fabrica con procesos de ingeniería química.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Mecatrónica',
    emoji: '🤖',
    area: 'Ingeniería',
    color: Color(0xFFEF6C00),
    escena: EscenaProfesion.taller,
    descripcion: 'Une la mecánica, la electrónica y la programación para crear robots y máquinas inteligentes.',
    queHace: ['Diseña y programa robots.', 'Automatiza máquinas en fábricas.', 'Crea prototipos con sensores y motores.'],
    herramientas: [('🤖', 'Robots'), ('🔌', 'Sensores'), ('⚙️', 'Motores'), ('💻', 'Programación')],
    dondeTrabaja: [('🏭', 'Fábricas automatizadas'), ('🚗', 'Industria automotriz'), ('🏥', 'Robótica médica')],
    dia: [
      ('8:00', '🔧', 'Arma el brazo de un robot.'),
      ('10:00', '🔌', 'Conecta los sensores.'),
      ('13:00', '💻', 'Programa sus movimientos.'),
      ('16:00', '🤖', 'Prueba que el robot tome objetos.')
    ],
    mundos: ['Electrónica', 'Programación'],
    reto: (
      '¿Qué necesita un robot para saber que hay un obstáculo?',
      ['Un sensor', 'Una pintura', 'Un adorno'],
      0,
      'Los sensores son los “sentidos” del robot.'
    ),
    dato: 'Algunos robots ayudan a hacer cirugías con mucha precisión.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería en Electrónica',
    emoji: '💡',
    area: 'Ingeniería',
    color: Color(0xFFEF6C00),
    escena: EscenaProfesion.taller,
    descripcion: 'Diseña circuitos y aparatos electrónicos: celulares, sensores, luces y sistemas de control.',
    queHace: ['Diseña circuitos electrónicos.', 'Prueba y repara aparatos.', 'Crea sensores para casas y ciudades inteligentes.'],
    herramientas: [('🔌', 'Protoboard'), ('📟', 'Multímetro'), ('🔥', 'Cautín'), ('💻', 'Simulador de circuitos')],
    dondeTrabaja: [('🏭', 'Fábricas de electrónicos'), ('🏢', 'Empresas de tecnología'), ('⚡', 'Compañías de energía')],
    dia: [
      ('9:00', '💻', 'Simula un circuito en la computadora.'),
      ('11:00', '🔌', 'Lo arma en una protoboard.'),
      ('14:00', '📟', 'Mide el voltaje con el multímetro.'),
      ('17:00', '💡', 'Celebra que el LED encendió.')
    ],
    mundos: ['Electrónica'],
    reto: (
      '¿Qué protege a un LED de quemarse?',
      ['Una resistencia', 'Más pilas', 'Un cable más largo'],
      0,
      'La resistencia frena la corriente para proteger al LED.'
    ),
    dato: 'Un celular tiene miles de millones de transistores diminutos.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Aeroespacial',
    emoji: '🚀',
    area: 'Física',
    color: Color(0xFF1E88E5),
    escena: EscenaProfesion.espacio,
    descripcion: 'Diseña aviones, satélites, cohetes y naves espaciales.',
    queHace: ['Diseña la forma de aviones y cohetes.', 'Calcula cómo vuelan y cómo llegan al espacio.', 'Construye y prueba satélites.'],
    herramientas: [('🚀', 'Cohetes'), ('🛰️', 'Satélites'), ('🌬️', 'Túnel de viento'), ('💻', 'Simulaciones')],
    dondeTrabaja: [('✈️', 'Industria aeronáutica'), ('🛰️', 'Agencias espaciales'), ('🏫', 'Universidades')],
    dia: [
      ('8:00', '🌬️', 'Prueba un ala en el túnel de viento.'),
      ('11:00', '💻', 'Simula el despegue de un cohete.'),
      ('14:00', '🛰️', 'Revisa las piezas de un satélite.'),
      ('17:00', '📡', 'Recibe datos de un satélite en órbita.')
    ],
    mundos: ['Física'],
    reto: (
      '¿Qué necesita un cohete para salir de la Tierra?',
      ['Mucha fuerza para vencer la gravedad', 'Alas grandes', 'Ruedas'],
      0,
      'El cohete empuja gases hacia abajo con mucha fuerza para subir.'
    ),
    dato: 'Hay satélites mexicanos en órbita que ayudan en las comunicaciones.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería Ambiental',
    emoji: '♻️',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.naturaleza,
    descripcion: 'Diseña soluciones de ingeniería para cuidar el ambiente: limpiar agua, tratar basura y reducir la contaminación.',
    queHace: ['Diseña plantas que limpian agua.', 'Planea rellenos y centros de reciclaje.', 'Mide y reduce la contaminación del aire.'],
    herramientas: [('🚰', 'Filtros de agua'), ('♻️', 'Reciclaje'), ('🌡️', 'Sensores'), ('📐', 'Planos')],
    dondeTrabaja: [('🚰', 'Plantas de tratamiento'), ('🏛️', 'Gobierno'), ('🏭', 'Industrias')],
    dia: [
      ('8:00', '🚰', 'Revisa una planta que limpia agua.'),
      ('10:00', '🧪', 'Mide si el agua ya está limpia.'),
      ('13:00', '📐', 'Diseña un sistema de captación de lluvia.'),
      ('16:00', '🗣️', 'Enseña a una comunidad a reciclar.')
    ],
    mundos: ['Química', 'Biología'],
    reto: ('¿Qué es captar agua de lluvia?', ['Guardarla para usarla después', 'Tirarla', 'Calentarla'], 0, 'Guardar agua de lluvia ayuda donde falta agua.'),
    dato: 'Limpiar el agua usada permite regarla de nuevo en parques y campos.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería en Energías Renovables',
    emoji: '🌬️',
    area: 'Planeta y energía',
    color: Color(0xFF558B2F),
    escena: EscenaProfesion.energia,
    descripcion: 'Diseña sistemas que producen electricidad con el sol, el viento, el agua y el calor de la Tierra.',
    queHace: ['Instala paneles solares.', 'Diseña parques eólicos.', 'Busca formas de guardar la energía.'],
    herramientas: [('☀️', 'Paneles solares'), ('🌬️', 'Aerogeneradores'), ('🔋', 'Baterías'), ('📟', 'Medidores')],
    dondeTrabaja: [('☀️', 'Parques solares'), ('🌬️', 'Parques eólicos'), ('🏢', 'Empresas de energía')],
    dia: [
      ('8:00', '☀️', 'Instala paneles solares en una escuela.'),
      ('11:00', '📟', 'Mide cuánta energía producen.'),
      ('14:00', '🌬️', 'Revisa un aerogenerador.'),
      ('17:00', '🔋', 'Diseña cómo guardar la energía en baterías.')
    ],
    mundos: ['Física', 'Electrónica'],
    reto: (
      '¿Qué energía viene del Sol?',
      ['La energía solar', 'La del carbón', 'La del petróleo'],
      0,
      'Los paneles solares convierten la luz del Sol en electricidad.'
    ),
    dato: 'Oaxaca tiene algunos de los parques eólicos más grandes de América Latina.',
  ),
  ProfesionInfo(
    nombre: 'Tecnologías para la Información en Ciencias',
    emoji: '📊',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.datos,
    descripcion: 'Usa la computación para guardar, analizar y mostrar grandes cantidades de datos científicos.',
    queHace: ['Organiza datos de experimentos.', 'Crea gráficas y mapas interactivos.', 'Programa herramientas para científicas y científicos.'],
    herramientas: [('💻', 'Computadora'), ('📊', 'Gráficas'), ('🗄️', 'Bases de datos'), ('🛰️', 'Datos de satélite')],
    dondeTrabaja: [('🧫', 'Centros de investigación'), ('🏫', 'Universidades'), ('🏢', 'Empresas de datos')],
    dia: [
      ('9:00', '🗄️', 'Ordena datos del clima de muchos años.'),
      ('11:00', '💻', 'Programa un análisis.'),
      ('14:00', '📊', 'Hace una gráfica que muestra el cambio.'),
      ('17:00', '🗣️', 'Explica los resultados a un equipo de ciencia.')
    ],
    mundos: ['Programación', 'Inteligencia Artificial'],
    reto: (
      '¿Para qué sirve una gráfica?',
      ['Para ver datos de forma fácil', 'Para pintar', 'Para jugar'],
      0,
      'Las gráficas convierten muchos números en una imagen fácil de entender.'
    ),
    dato: 'Los telescopios modernos producen tantos datos que se necesitan computadoras para revisarlos.',
  ),
  ProfesionInfo(
    nombre: 'Nanotecnología',
    emoji: '🔹',
    area: 'Física',
    color: Color(0xFF1E88E5),
    escena: EscenaProfesion.atomos,
    descripcion: 'Trabaja con cosas diminutas, del tamaño de los átomos, para crear materiales y aparatos nuevos.',
    queHace: ['Crea materiales súper resistentes y ligeros.', 'Diseña medicinas que llegan justo a donde se necesitan.', 'Mejora pantallas y baterías.'],
    herramientas: [('🔬', 'Microscopio electrónico'), ('⚛️', 'Modelos de átomos'), ('🧪', 'Laboratorio limpio'), ('💻', 'Simulaciones')],
    dondeTrabaja: [('🧫', 'Laboratorios'), ('🏫', 'Universidades'), ('🏭', 'Industria electrónica')],
    dia: [
      ('9:00', '🥼', 'Entra al cuarto limpio con traje especial.'),
      ('11:00', '🔬', 'Observa átomos con el microscopio electrónico.'),
      ('14:00', '⚛️', 'Arma un material nuevo capa por capa.'),
      ('17:00', '💻', 'Simula cómo se comporta.')
    ],
    mundos: ['Física', 'Química'],
    reto: (
      '¿Qué tan pequeño es un nanómetro?',
      ['Muchísimo más delgado que un cabello', 'Como una hormiga', 'Como un lápiz'],
      0,
      'Un cabello mide unos 80 mil nanómetros de grosor.'
    ),
    dato: 'Las alas de algunas mariposas brillan por estructuras de tamaño nano.',
  ),
  ProfesionInfo(
    nombre: 'Inteligencia artificial',
    emoji: '🧠',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.ia,
    descripcion: 'Crea programas que aprenden de datos para reconocer imágenes, entender la voz o ayudar a decidir.',
    queHace: ['Entrena modelos con muchos datos.', 'Revisa que la IA no tenga sesgos.', 'Crea asistentes y herramientas útiles.'],
    herramientas: [('💻', 'Computadora'), ('📊', 'Datos'), ('🧠', 'Redes neuronales'), ('☁️', 'La nube')],
    dondeTrabaja: [('🏢', 'Empresas de tecnología'), ('🏥', 'Hospitales'), ('🏫', 'Universidades')],
    dia: [
      ('9:00', '📊', 'Reúne y limpia datos.'),
      ('11:00', '🏷️', 'Revisa que los datos estén bien etiquetados.'),
      ('14:00', '🧠', 'Entrena una red neuronal.'),
      ('17:00', '🧪', 'Prueba la IA con datos nuevos.')
    ],
    mundos: ['Inteligencia Artificial', 'Programación'],
    reto: (
      '¿De qué aprende una IA?',
      ['De muchos ejemplos (datos)', 'De la nada', 'De la suerte'],
      0,
      'Una IA es tan buena como los datos con los que aprende.'
    ),
    dato: 'Algunas IA ayudan a encontrar enfermedades en imágenes médicas.',
  ),
  ProfesionInfo(
    nombre: 'Ingeniería de telecomunicaciones',
    emoji: '📡',
    area: 'Computación',
    color: Color(0xFF00897B),
    escena: EscenaProfesion.red,
    descripcion: 'Diseña las redes que nos comunican: internet, telefonía, radio, televisión y satélites.',
    queHace: ['Instala antenas y fibra óptica.', 'Diseña redes de internet.', 'Mejora la señal de celulares y radios.'],
    herramientas: [('📡', 'Antenas'), ('🛰️', 'Satélites'), ('🔦', 'Fibra óptica'), ('📟', 'Analizador de señales')],
    dondeTrabaja: [('📶', 'Compañías de telefonía'), ('📺', 'Radio y televisión'), ('🛰️', 'Centros satelitales')],
    dia: [
      ('8:00', '📡', 'Sube a revisar una antena.'),
      ('10:00', '📟', 'Mide la fuerza de la señal.'),
      ('13:00', '🔦', 'Conecta fibra óptica.'),
      ('16:00', '🌐', 'Lleva internet a una comunidad.')
    ],
    mundos: ['Electrónica', 'Programación'],
    reto: (
      '¿Cómo viaja internet por la fibra óptica?',
      ['Como pulsos de luz', 'Como agua', 'Como sonido'],
      0,
      'La fibra óptica lleva la información en forma de luz.'
    ),
    dato: 'Por cables bajo el mar viaja casi todo el internet entre continentes.',
  ),
];
