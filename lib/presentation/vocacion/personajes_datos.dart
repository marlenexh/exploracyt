import 'package:flutter/material.dart';

/// Personas del museo “Personas que transforman el mundo”.
class PersonajeInfo {
  const PersonajeInfo({
    required this.nombre,
    required this.avatar,
    required this.pais,
    required this.anios,
    required this.sala,
    required this.aporte,
    required this.historia,
    required this.objeto,
    required this.dato,
    required this.ensenanza,
    required this.pista,
  });
  final String nombre, avatar, pais, anios, sala, aporte, dato, ensenanza, pista;

  /// Retrato en assets/images/museo/ (si no existe se muestra [avatar]).
  String get imagen => 'assets/images/museo/${archivoRetrato(nombre)}.webp';

  /// (año, lo que pasó)
  final List<(String, String)> historia;

  /// (emoji, nombre) del objeto de la vitrina.
  final (String, String) objeto;
}

/// Nombre de archivo del retrato: minúsculas, sin acentos y con guiones bajos.
String archivoRetrato(String nombre) {
  const acentos = {'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ü': 'u', 'ñ': 'n'};
  final b = StringBuffer();
  for (final ch in nombre.toLowerCase().split('')) {
    b.write(acentos[ch] ?? (RegExp(r'[a-z0-9]').hasMatch(ch) ? ch : '_'));
  }
  return b.toString().replaceAll(RegExp('_+'), '_');
}

/// Salas del museo: (nombre, emoji, color).
const salasMuseo = [
  ('Vida y salud', '🧬', Color(0xFF2E9E5B)),
  ('Química', '🧪', Color(0xFF8E24AA)),
  ('Física', '⚛️', Color(0xFF1E88E5)),
  ('Electrónica y tecnología', '⚡', Color(0xFFEF6C00)),
  ('Computación e IA', '💻', Color(0xFF00897B)),
  ('Espacio', '🚀', Color(0xFF3949AB)),
];

Color colorSala(String sala) => salasMuseo.firstWhere((s) => s.$1 == sala).$3;
String emojiSala(String sala) => salasMuseo.firstWhere((s) => s.$1 == sala).$2;

const personajes = [
  // Vida y salud
  PersonajeInfo(
    nombre: 'Charles Darwin',
    avatar: '👨‍🔬',
    pais: '🇬🇧 Inglaterra',
    anios: '1809 – 1882',
    sala: 'Vida y salud',
    aporte: 'Explicó cómo las especies cambian con el tiempo: la evolución por selección natural.',
    historia: [
      ('1831', 'Sube al barco Beagle para un viaje de casi 5 años alrededor del mundo.'),
      ('1835', 'Estudia tortugas y aves en las islas Galápagos.'),
      ('1859', 'Publica “El origen de las especies”.')
    ],
    objeto: ('🐢', 'Tortuga de Galápagos'),
    dato: 'Notó que los pinzones de cada isla de Galápagos tenían picos distintos según lo que comían.',
    ensenanza: 'Observar con paciencia y anotar todo puede cambiar lo que sabemos del mundo.',
    pista: 'Viajé en el barco Beagle y estudié las tortugas de las islas Galápagos.',
  ),
  PersonajeInfo(
    nombre: 'Jane Goodall',
    avatar: '👩‍🔬',
    pais: '🇬🇧 Inglaterra',
    anios: '1934 – 2025',
    sala: 'Vida y salud',
    aporte: 'Estudió a los chimpancés en libertad y descubrió que usan herramientas.',
    historia: [
      ('1960', 'Llega a Gombe, en Tanzania, para observar chimpancés.'),
      ('1960', 'Ve a un chimpancé usar una ramita para sacar termitas.'),
      ('1977', 'Crea un instituto para proteger a los chimpancés y su hábitat.')
    ],
    objeto: ('🐒', 'Chimpancé'),
    dato: 'Les puso nombre a los chimpancés que estudiaba, como David Greybeard.',
    ensenanza: 'Cuidar a los animales y su hogar también es cuidar el planeta.',
    pista: 'Viví en la selva de Tanzania observando chimpancés.',
  ),
  PersonajeInfo(
    nombre: 'Rosalind Franklin',
    avatar: '👩‍🔬',
    pais: '🇬🇧 Inglaterra',
    anios: '1920 – 1958',
    sala: 'Vida y salud',
    aporte: 'Tomó la famosa “Fotografía 51”, que ayudó a descubrir la forma de doble hélice del ADN.',
    historia: [
      ('1951', 'Usa rayos X para estudiar el ADN.'),
      ('1952', 'Obtiene la Fotografía 51.'),
      ('1953', 'Su imagen ayuda a describir la doble hélice del ADN.')
    ],
    objeto: ('🧬', 'Doble hélice de ADN'),
    dato: 'También estudió los virus y la estructura del carbón.',
    ensenanza: 'Un experimento cuidadoso puede ser la pieza clave de un gran descubrimiento.',
    pista: 'Mi Fotografía 51 mostró la forma del ADN.',
  ),
  PersonajeInfo(
    nombre: 'Louis Pasteur',
    avatar: '👨‍🔬',
    pais: '🇫🇷 Francia',
    anios: '1822 – 1895',
    sala: 'Vida y salud',
    aporte: 'Demostró que los microbios causan enfermedades e inventó la pasteurización.',
    historia: [
      ('1862', 'Prueba que los microbios no aparecen de la nada.'),
      ('1864', 'Calienta el vino y la leche para eliminar microbios: la pasteurización.'),
      ('1885', 'Aplica con éxito la vacuna contra la rabia a un niño.')
    ],
    objeto: ('🥛', 'Leche pasteurizada'),
    dato: 'Por él la leche que tomas dice “pasteurizada”.',
    ensenanza: 'La ciencia nos ayuda a prevenir enfermedades.',
    pista: 'Si tu leche dice “pasteurizada”, es gracias a mí.',
  ),
  PersonajeInfo(
    nombre: 'Alexander Fleming',
    avatar: '👨‍⚕️',
    pais: '🇬🇧 Escocia',
    anios: '1881 – 1955',
    sala: 'Vida y salud',
    aporte: 'Descubrió la penicilina, el primer antibiótico, gracias a un moho.',
    historia: [
      ('1928', 'Regresa de vacaciones y ve que un moho había eliminado las bacterias de su cultivo.'),
      ('1929', 'Publica su descubrimiento de la penicilina.'),
      ('1945', 'Recibe el Premio Nobel de Medicina.')
    ],
    objeto: ('🍄', 'Moho Penicillium'),
    dato: 'Su descubrimiento empezó por un cultivo olvidado: ¡a veces el desorden ayuda!',
    ensenanza: 'Hay que estar atentos a lo inesperado: ahí pueden esconderse grandes descubrimientos.',
    pista: 'Un moho en mi laboratorio me llevó a descubrir el primer antibiótico.',
  ),
  PersonajeInfo(
    nombre: 'Gregor Mendel',
    avatar: '👨‍🌾',
    pais: '🇨🇿 Silesia (hoy República Checa)',
    anios: '1822 – 1884',
    sala: 'Vida y salud',
    aporte: 'Descubrió las reglas de la herencia cultivando plantas de chícharo.',
    historia: [
      ('1856', 'Empieza a cultivar miles de plantas de chícharo en su monasterio.'),
      ('1865', 'Presenta sus leyes de la herencia.'),
      ('1900', 'Otros científicos redescubren su trabajo: nace la genética.')
    ],
    objeto: ('🌱', 'Planta de chícharo'),
    dato: 'Cultivó y anotó las características de casi 30 000 plantas.',
    ensenanza: 'Los grandes descubrimientos requieren paciencia y muchos datos.',
    pista: 'Cultivé chícharos para descubrir cómo se heredan las características.',
  ),
  // Química
  PersonajeInfo(
    nombre: 'Marie Curie',
    avatar: '👩‍🔬',
    pais: '🇵🇱 Polonia y 🇫🇷 Francia',
    anios: '1867 – 1934',
    sala: 'Química',
    aporte: 'Investigó la radiactividad y descubrió los elementos polonio y radio.',
    historia: [
      ('1898', 'Descubre el polonio y el radio junto con Pierre Curie.'),
      ('1903', 'Gana el Premio Nobel de Física.'),
      ('1911', 'Gana el Premio Nobel de Química.')
    ],
    objeto: ('☢️', 'Muestra de radio'),
    dato: 'Fue la primera persona en ganar dos Premios Nobel en ciencias distintas.',
    ensenanza: 'La curiosidad y el esfuerzo abren puertas que parecían cerradas.',
    pista: 'Gané dos Premios Nobel y descubrí el polonio y el radio.',
  ),
  PersonajeInfo(
    nombre: 'Mario Molina',
    avatar: '👨‍🔬',
    pais: '🇲🇽 México',
    anios: '1943 – 2020',
    sala: 'Química',
    aporte: 'Descubrió que algunos gases de aerosoles y refrigeradores dañaban la capa de ozono.',
    historia: [
      ('1974', 'Publica su investigación sobre los gases CFC y la capa de ozono.'),
      ('1987', 'Muchos países firman el Protocolo de Montreal para proteger el ozono.'),
      ('1995', 'Gana el Premio Nobel de Química.')
    ],
    objeto: ('🌍', 'La capa de ozono'),
    dato: 'Es el primer mexicano en ganar un Premio Nobel en ciencias.',
    ensenanza: 'La ciencia puede ayudar a todos los países a cuidar el planeta juntos.',
    pista: 'Soy mexicano y ayudé a proteger la capa de ozono.',
  ),
  PersonajeInfo(
    nombre: 'Dmitri Mendeléyev',
    avatar: '👨‍🏫',
    pais: '🇷🇺 Rusia',
    anios: '1834 – 1907',
    sala: 'Química',
    aporte: 'Ordenó los elementos químicos en la tabla periódica.',
    historia: [
      ('1869', 'Presenta su tabla periódica de los elementos.'),
      ('1871', 'Predice elementos que todavía nadie había descubierto.'),
      ('1875', 'Se descubre el galio, uno de los elementos que predijo.')
    ],
    objeto: ('🧪', 'Tabla periódica'),
    dato: 'Dejó huecos en su tabla para elementos que aún no se conocían… ¡y acertó!',
    ensenanza: 'Encontrar patrones permite predecir lo que todavía no conocemos.',
    pista: 'Ordené los elementos químicos en una tabla y dejé huecos para los que faltaban.',
  ),
  PersonajeInfo(
    nombre: 'Antoine Lavoisier',
    avatar: '👨‍🔬',
    pais: '🇫🇷 Francia',
    anios: '1743 – 1794',
    sala: 'Química',
    aporte: 'Demostró que en una reacción química la masa no se pierde: solo se transforma.',
    historia: [
      ('1774', 'Hace experimentos pesando con mucha precisión antes y después de cada reacción.'),
      ('1778', 'Explica el papel del oxígeno en la combustión.'),
      ('1789', 'Publica un libro que ayuda a crear la química moderna.')
    ],
    objeto: ('⚖️', 'Balanza de precisión'),
    dato: 'Se le recuerda por la idea “nada se pierde, todo se transforma”.',
    ensenanza: 'Medir con cuidado es la base de la ciencia.',
    pista: 'Con mi balanza demostré que en las reacciones nada se pierde, todo se transforma.',
  ),
  // Física
  PersonajeInfo(
    nombre: 'Isaac Newton',
    avatar: '👨‍🔬',
    pais: '🇬🇧 Inglaterra',
    anios: '1643 – 1727',
    sala: 'Física',
    aporte: 'Explicó las leyes del movimiento y la gravitación universal.',
    historia: [
      ('1666', 'Estudia la luz con prismas y ve que la luz blanca tiene todos los colores.'),
      ('1668', 'Construye un telescopio con espejos.'),
      ('1687', 'Publica sus leyes del movimiento y de la gravedad.')
    ],
    objeto: ('🍎', 'La manzana'),
    dato: 'Se cuenta que pensó en la gravedad al ver caer una manzana.',
    ensenanza: 'Preguntarse por cosas cotidianas puede llevar a grandes ideas.',
    pista: 'Una manzana que cae me hizo pensar en la gravedad.',
  ),
  PersonajeInfo(
    nombre: 'Albert Einstein',
    avatar: '👨‍🦳',
    pais: '🇩🇪 Alemania',
    anios: '1879 – 1955',
    sala: 'Física',
    aporte: 'Creó la teoría de la relatividad, que explica el espacio, el tiempo y la gravedad.',
    historia: [
      ('1905', 'Publica cuatro artículos que cambian la física, incluido E = mc².'),
      ('1915', 'Presenta la teoría de la relatividad general.'),
      ('1921', 'Gana el Premio Nobel de Física.')
    ],
    objeto: ('🕰️', 'El tiempo relativo'),
    dato: 'Su ecuación E = mc² es una de las más famosas del mundo.',
    ensenanza: 'La imaginación es una herramienta poderosa para la ciencia.',
    pista: 'Mi ecuación más famosa es E = mc².',
  ),
  PersonajeInfo(
    nombre: 'Galileo Galilei',
    avatar: '🧔',
    pais: '🇮🇹 Italia',
    anios: '1564 – 1642',
    sala: 'Física',
    aporte: 'Usó el telescopio para estudiar el cielo y descubrió cuatro lunas de Júpiter.',
    historia: [
      ('1609', 'Mejora un telescopio y lo apunta al cielo.'),
      ('1610', 'Descubre cuatro lunas que giran alrededor de Júpiter.'),
      ('1638', 'Publica sus estudios sobre el movimiento y la caída de los objetos.')
    ],
    objeto: ('🔭', 'Telescopio'),
    dato: 'Las cuatro lunas grandes de Júpiter se llaman “lunas galileanas” en su honor.',
    ensenanza: 'Hay que comprobar las ideas con experimentos y observaciones.',
    pista: 'Con mi telescopio descubrí lunas alrededor de Júpiter.',
  ),
  PersonajeInfo(
    nombre: 'Nikola Tesla',
    avatar: '👨‍🔧',
    pais: '🇭🇷 Nació en la actual Croacia',
    anios: '1856 – 1943',
    sala: 'Física',
    aporte: 'Desarrolló la corriente alterna, la forma en que llega la electricidad a las casas.',
    historia: [
      ('1884', 'Llega a Estados Unidos con grandes ideas.'),
      ('1888', 'Patenta su motor de corriente alterna.'),
      ('1893', 'La corriente alterna ilumina una gran feria en Chicago.')
    ],
    objeto: ('⚡', 'Bobina de Tesla'),
    dato: 'La unidad del campo magnético, el “tesla”, lleva su nombre.',
    ensenanza: 'Una buena idea necesita perseverancia para hacerse realidad.',
    pista: 'Gracias a mi corriente alterna llega la electricidad a tu casa.',
  ),
  // Electrónica y tecnología
  PersonajeInfo(
    nombre: 'Guillermo González Camarena',
    avatar: '👨‍🔧',
    pais: '🇲🇽 México',
    anios: '1917 – 1965',
    sala: 'Electrónica y tecnología',
    aporte: 'Inventó un sistema para transmitir televisión a color.',
    historia: [
      ('1934', 'Construye su propia cámara de televisión cuando era joven.'),
      ('1940', 'Patenta en México su sistema de televisión a color.'),
      ('1962', 'Presenta un sistema de color más sencillo y económico.')
    ],
    objeto: ('📺', 'Televisión a color'),
    dato: 'Registró su primera patente de televisión a color cuando tenía apenas 23 años.',
    ensenanza: 'Desde México también se crean inventos que cambian el mundo.',
    pista: 'Soy mexicano e inventé un sistema de televisión a color.',
  ),
  PersonajeInfo(
    nombre: 'Hedy Lamarr',
    avatar: '👩‍🔧',
    pais: '🇦🇹 Austria',
    anios: '1914 – 2000',
    sala: 'Electrónica y tecnología',
    aporte: 'Coinventó un sistema de “salto de frecuencia”, idea en la que se basan tecnologías como el wifi y el Bluetooth.',
    historia: [
      ('1938', 'Se vuelve una famosa actriz de Hollywood.'),
      ('1942', 'Patenta el salto de frecuencia junto con el músico George Antheil.'),
      ('1997', 'Recibe un premio por su invento.')
    ],
    objeto: ('📡', 'Señales de radio'),
    dato: 'De día era actriz de Hollywood y en su tiempo libre inventaba.',
    ensenanza: 'Puedes tener muchos talentos: el arte y la ciencia pueden ir juntos.',
    pista: 'Fui actriz de cine e inventé una idea que usan el wifi y el Bluetooth.',
  ),
  PersonajeInfo(
    nombre: 'Tim Berners-Lee',
    avatar: '👨‍💻',
    pais: '🇬🇧 Inglaterra',
    anios: '1955 –',
    sala: 'Electrónica y tecnología',
    aporte: 'Inventó la World Wide Web: las páginas web que visitamos en internet.',
    historia: [
      ('1989', 'Propone la World Wide Web mientras trabaja en el CERN, en Suiza.'),
      ('1990', 'Crea la primera página web y el primer navegador.'),
      ('1994', 'Funda una organización para cuidar los estándares de la web.')
    ],
    objeto: ('🌐', 'La primera página web'),
    dato: 'Decidió que la web fuera gratuita para que todos pudieran usarla.',
    ensenanza: 'Compartir el conocimiento puede ayudar a millones de personas.',
    pista: 'Inventé las páginas web e hice que fueran gratuitas para todos.',
  ),
  // Computación e IA
  PersonajeInfo(
    nombre: 'Ada Lovelace',
    avatar: '👩‍💻',
    pais: '🇬🇧 Inglaterra',
    anios: '1815 – 1852',
    sala: 'Computación e IA',
    aporte: 'Escribió el primer algoritmo pensado para una máquina: es considerada la primera programadora.',
    historia: [
      ('1833', 'Conoce a Charles Babbage y su máquina para calcular.'),
      ('1843', 'Publica sus notas con un algoritmo para la máquina analítica.'),
      ('1980', 'Un lenguaje de programación recibe su nombre: Ada.')
    ],
    objeto: ('⚙️', 'Máquina analítica'),
    dato: 'Imaginó que las máquinas podrían algún día componer música.',
    ensenanza: 'Imaginar lo que todavía no existe es el primer paso para crearlo.',
    pista: 'Escribí el primer algoritmo para una máquina, hace casi 200 años.',
  ),
  PersonajeInfo(
    nombre: 'Alan Turing',
    avatar: '👨‍💻',
    pais: '🇬🇧 Inglaterra',
    anios: '1912 – 1954',
    sala: 'Computación e IA',
    aporte: 'Creó las bases de la computación y se preguntó si las máquinas pueden pensar.',
    historia: [
      ('1936', 'Describe la “máquina de Turing”, la idea de la computadora moderna.'),
      ('1940', 'Ayuda a descifrar mensajes secretos de la máquina Enigma.'),
      ('1950', 'Propone la prueba de Turing.')
    ],
    objeto: ('🤖', 'La prueba de Turing'),
    dato: 'Es considerado el padre de la computación y de la inteligencia artificial.',
    ensenanza: 'Las preguntas grandes, como “¿pueden pensar las máquinas?”, impulsan la ciencia.',
    pista: 'Propuse una prueba para saber si una máquina es inteligente.',
  ),
  PersonajeInfo(
    nombre: 'Grace Hopper',
    avatar: '👩‍✈️',
    pais: '🇺🇸 Estados Unidos',
    anios: '1906 – 1992',
    sala: 'Computación e IA',
    aporte: 'Creó uno de los primeros compiladores, que traduce instrucciones a lenguaje de máquina.',
    historia: [
      ('1944', 'Programa una de las primeras computadoras, la Mark I.'),
      ('1947', 'Su equipo encuentra una polilla atorada en una computadora: ¡un “bug”!'),
      ('1952', 'Crea uno de los primeros compiladores.')
    ],
    objeto: ('🐞', 'El primer “bug”'),
    dato: 'Fue almirante de la Marina de Estados Unidos.',
    ensenanza: 'Hacer la tecnología más fácil de usar ayuda a que más personas programen.',
    pista: 'Mi equipo encontró una polilla dentro de una computadora: ¡el famoso bug!',
  ),
  PersonajeInfo(
    nombre: 'Katherine Johnson',
    avatar: '👩‍🏫',
    pais: '🇺🇸 Estados Unidos',
    anios: '1918 – 2020',
    sala: 'Computación e IA',
    aporte: 'Calculó a mano las trayectorias de vuelos espaciales de la NASA.',
    historia: [
      ('1953', 'Empieza a trabajar como “computadora humana” en la NACA, que luego sería la NASA.'),
      ('1962', 'Revisa los cálculos del vuelo de John Glenn alrededor de la Tierra.'),
      ('1969', 'Ayuda con los cálculos de la misión Apolo 11 a la Luna.')
    ],
    objeto: ('🧮', 'Cálculos de trayectoria'),
    dato: 'El astronauta John Glenn pidió que ella revisara los cálculos de la computadora antes de volar.',
    ensenanza: 'Las matemáticas pueden llevarnos hasta la Luna.',
    pista: 'Mis cálculos ayudaron a llevar astronautas a la Luna.',
  ),
  // Espacio
  PersonajeInfo(
    nombre: 'Rodolfo Neri Vela',
    avatar: '👨‍🚀',
    pais: '🇲🇽 México',
    anios: '1952 –',
    sala: 'Espacio',
    aporte: 'Fue el primer astronauta mexicano en viajar al espacio.',
    historia: [
      ('1985', 'Viaja en el transbordador espacial Atlantis.'),
      ('1985', 'Ayuda a poner en órbita el satélite mexicano Morelos II.'),
      ('1985', 'Hace experimentos científicos en el espacio.')
    ],
    objeto: ('🛰️', 'Satélite Morelos'),
    dato: 'Es ingeniero y se ha dedicado a enseñar y divulgar la ciencia espacial.',
    ensenanza: 'Los sueños más altos se alcanzan estudiando y preparándose.',
    pista: 'Soy el primer astronauta mexicano.',
  ),
  PersonajeInfo(
    nombre: 'Ellen Ochoa',
    avatar: '👩‍🚀',
    pais: '🇺🇸 Estados Unidos',
    anios: '1958 –',
    sala: 'Espacio',
    aporte: 'Fue la primera mujer latina en viajar al espacio y dirigió un centro espacial de la NASA.',
    historia: [
      ('1993', 'Viaja al espacio en el transbordador Discovery.'),
      ('2002', 'Completa su cuarta misión espacial.'),
      ('2013', 'Se convierte en directora del Centro Espacial Johnson.')
    ],
    objeto: ('🎵', 'Su flauta en el espacio'),
    dato: 'Llevó su flauta al espacio y la tocó en órbita.',
    ensenanza: 'Puedes ser científica, ingeniera y artista a la vez.',
    pista: 'Fui la primera mujer latina en el espacio y llevé mi flauta.',
  ),
  PersonajeInfo(
    nombre: 'Julieta Fierro',
    avatar: '👩‍🏫',
    pais: '🇲🇽 México',
    anios: '1948 –',
    sala: 'Espacio',
    aporte: 'Astrónoma de la UNAM que dedica su vida a explicar la ciencia de forma divertida.',
    historia: [
      ('1970s', 'Estudia física y astronomía en la UNAM.'),
      ('1980s', 'Escribe libros y da charlas para acercar el universo a niñas y niños.'),
      ('1995', 'Recibe el Premio Kalinga de la UNESCO por divulgar la ciencia.')
    ],
    objeto: ('🔭', 'Telescopio'),
    dato: 'Es famosa por sus charlas llenas de experimentos sencillos y mucho humor.',
    ensenanza: 'Compartir la ciencia con alegría inspira a muchas personas.',
    pista: 'Soy astrónoma mexicana y me encanta explicar el universo con humor.',
  ),
];
