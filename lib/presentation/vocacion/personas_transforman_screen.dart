
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonasTransformanScreen extends StatelessWidget {
  const PersonasTransformanScreen({super.key});

  static const Color fondo = Color(0xFF14213D);
  static const Color panel = Color(0xFF213454);
  static const Color dorado = Color(0xFFF5C96A);
  static const Color turquesa = Color(0xFF7DD6D0);

  static const List<_Personaje> personajes = [
    _Personaje(
      nombre: 'Marie Curie',
      area: 'Química y Física',
      epoca: '1867 – 1934',
      imagen: 'assets/personajes/marie_curie.jpg',
      icono: Icons.science,
      color: Color(0xFFB58BCE),
      descripcion:
          'Fue una científica que investigó la radiactividad '
          'y realizó descubrimientos fundamentales para la ciencia.',
      historia:
          'Marie Curie nació en Polonia y desarrolló gran parte '
          'de su trabajo científico en Francia. Estudió fenómenos '
          'que permitieron comprender mejor la radiactividad.',
      aportes: [
        'Investigó la radiactividad.',
        'Descubrió los elementos polonio y radio junto con Pierre Curie.',
        'Fue la primera mujer en recibir un Premio Nobel.',
      ],
      dato:
          'Fue la primera persona en recibir dos premios Nobel '
          'en distintas disciplinas científicas: Física y Química.',
      reto:
          '¿Por qué crees que estudiar los elementos de la naturaleza '
          'puede ayudar a crear nuevos conocimientos y tecnologías?',
    ),
    _Personaje(
      nombre: 'Katherine Johnson',
      area: 'Matemáticas y espacio',
      epoca: '1918 – 2020',
      imagen: 'assets/personajes/katherine_johnson.jpg',
      icono: Icons.rocket_launch,
      color: Color(0xFF5DADE2),
      descripcion:
          'Fue una matemática cuyos cálculos ayudaron a planificar '
          'importantes vuelos espaciales de Estados Unidos.',
      historia:
          'Katherine Johnson trabajó en la NASA. Sus cálculos '
          'matemáticos fueron importantes para determinar '
          'trayectorias y rutas de las naves espaciales.',
      aportes: [
        'Calculó trayectorias para vuelos espaciales.',
        'Contribuyó a la misión orbital de John Glenn.',
        'Ayudó a realizar cálculos para misiones del programa Apolo.',
      ],
      dato:
          'Desde pequeña mostró una gran facilidad para las matemáticas '
          'y terminó la preparatoria a una edad muy temprana.',
      reto:
          'Si una nave necesita llegar a otro planeta, '
          '¿por qué sería importante calcular su trayectoria?',
    ),
    _Personaje(
      nombre: 'Guillermo González Camarena',
      area: 'Electrónica',
      epoca: '1917 – 1965',
      imagen: 'assets/personajes/guillermo_camarena.jpg',
      icono: Icons.tv,
      color: Color(0xFFE6A04B),
      descripcion:
          'Fue un ingeniero e inventor mexicano que desarrolló '
          'un sistema para transmitir televisión a color.',
      historia:
          'Desde joven mostró interés por la electricidad '
          'y la construcción de aparatos. Trabajó en el desarrollo '
          'de sistemas que hicieron posible transmitir imágenes '
          'en color.',
      aportes: [
        'Desarrolló un sistema de televisión a color.',
        'Registró una patente relacionada con su sistema en México.',
        'Contribuyó al desarrollo de la televisión.',
      ],
      dato:
          'Construyó aparatos y experimentó con componentes electrónicos '
          'desde que era muy joven.',
      reto:
          '¿Qué componentes electrónicos imaginas que se necesitan '
          'para mostrar una imagen en una pantalla?',
    ),
    _Personaje(
      nombre: 'Ada Lovelace',
      area: 'Programación',
      epoca: '1815 – 1852',
      imagen: 'assets/personajes/ada_lovelace.jpg',
      icono: Icons.code,
      color: Color(0xFFE58EAD),
      descripcion:
          'Fue una matemática que escribió un algoritmo pensado '
          'para ser procesado por una máquina.',
      historia:
          'Ada Lovelace estudió la máquina analítica diseñada '
          'por Charles Babbage. Comprendió que una máquina '
          'podría manipular símbolos y no solamente realizar cálculos.',
      aportes: [
        'Escribió un algoritmo para la máquina analítica.',
        'Imaginó otros usos de las máquinas además de calcular.',
        'Es considerada una pionera de la programación.',
      ],
      dato:
          'Imaginó que las máquinas podrían trabajar con música '
          'y otros tipos de información si se les daban instrucciones.',
      reto:
          'Si pudieras programar una máquina para resolver '
          'un problema cotidiano, ¿qué tarea elegirías?',
    ),
    _Personaje(
      nombre: 'Mario Molina',
      area: 'Química y medio ambiente',
      epoca: '1943 – 2020',
      imagen: 'assets/personajes/mario_molina.jpg',
      icono: Icons.public,
      color: Color(0xFF56B99A),
      descripcion:
          'Fue un químico mexicano que investigó cómo ciertos '
          'compuestos afectan la capa de ozono.',
      historia:
          'Mario Molina realizó investigaciones sobre los efectos '
          'de los clorofluorocarbonos (CFC) en la atmósfera. '
          'Su trabajo ayudó a comprender el problema del deterioro '
          'de la capa de ozono.',
      aportes: [
        'Investigó los efectos de los CFC en la capa de ozono.',
        'Contribuyó a impulsar la protección de la atmósfera.',
        'Recibió el Premio Nobel de Química en 1995.',
      ],
      dato:
          'Fue uno de los primeros científicos mexicanos '
          'en recibir un Premio Nobel de Química.',
      reto:
          '¿Qué acciones podríamos realizar para cuidar '
          'el aire y el medio ambiente?',
    ),
    _Personaje(
      nombre: 'Tim Berners-Lee',
      area: 'Tecnología e Internet',
      epoca: '1955 – actualidad',
      imagen: 'assets/personajes/tim_berners_lee.jpg',
      icono: Icons.language,
      color: Color(0xFF65B8C9),
      descripcion:
          'Es el inventor de la World Wide Web, un sistema '
          'que permite consultar páginas y compartir información '
          'a través de Internet.',
      historia:
          'Tim Berners-Lee propuso un sistema para compartir '
          'información entre computadoras. Desarrolló elementos '
          'fundamentales de la Web, como HTML, HTTP y las URL.',
      aportes: [
        'Inventó la World Wide Web.',
        'Desarrolló el primer navegador y servidor web.',
        'Impulsó una Web abierta y accesible.',
      ],
      dato:
          'La primera página web se publicó en 1991.',
      reto:
          'Si crearas una página web para compartir conocimientos '
          'con otros niños, ¿qué información incluirías?',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esComputadora = constraints.maxWidth > 750;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: esComputadora ? 35 : 16,
                vertical: 18,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton.filled(
                            tooltip: 'Volver',
                            style: IconButton.styleFrom(
                              backgroundColor: panel,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.auto_awesome,
                            color: dorado,
                          ),
                          const SizedBox(width: 7),
                          const Text(
                            'MUSEO DE IDEAS',
                            style: TextStyle(
                              color: dorado,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      const Text(
                        'PERSONAS QUE',
                        style: TextStyle(
                          color: turquesa,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 5),

                      const Text(
                        'transforman el mundo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontFamily: 'LilitaOne',
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Conoce las historias de personas cuyas '
                        'ideas y descubrimientos cambiaron nuestra '
                        'forma de comprender y transformar el mundo.',
                        style: TextStyle(
                          color: Color(0xFFD5E1F5),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _PanelPresentacion(
                        esComputadora: esComputadora,
                      ),

                      const SizedBox(height: 30),

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Galería de personajes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontFamily: 'LilitaOne',
                              ),
                            ),
                          ),
                          Text(
                            '${personajes.length} historias',
                            style: const TextStyle(
                              color: dorado,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      const Text(
                        'Selecciona una persona para conocer su historia.',
                        style: TextStyle(
                          color: Color(0xFFB9C8DE),
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 17),

                      GridView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: personajes.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              esComputadora ? 3 : 1,
                          mainAxisExtent:
                              esComputadora ? 265 : 205,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          final personaje = personajes[index];

                          return _TarjetaPersonaje(
                            personaje: personaje,
                            numero: index + 1,
                            onTap: () async {
                              // Guardar que el explorador visitó a este personaje.
                              await _registrarPersonajeVisitado(personaje.nombre);
                              
                              if (!context.mounted) return;
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetallePersonajeScreen(
                                    personaje: personaje,
                                    ),
                                  ),
                                );
                              },
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      Center(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: dorado,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Las grandes ideas comienzan con una pregunta.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sigue explorando y descubre lo que tú también '
                              'puedes llegar a crear.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(.65),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PanelPresentacion extends StatelessWidget {
  final bool esComputadora;

  const _PanelPresentacion({
    required this.esComputadora,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF304A70),
            Color(0xFF213454),
            Color(0xFF192A47),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF526A8B),
          width: 1.5,
        ),
      ),
      child: Flex(
        direction:
            esComputadora ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: esComputadora ? 145 : 105,
            height: esComputadora ? 145 : 105,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF405B7F),
              border: Border.all(
                color: PersonasTransformanScreen.dorado,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.travel_explore,
              size: 70,
              color: PersonasTransformanScreen.dorado,
            ),
          ),

          SizedBox(
            width: esComputadora ? 22 : 0,
            height: esComputadora ? 0 : 15,
          ),

          Expanded(
            flex: esComputadora ? 1 : 0,
            child: Column(
              crossAxisAlignment: esComputadora
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                const Text(
                  '¡Bienvenido al museo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF5C96A),
                    fontSize: 23,
                    fontFamily: 'LilitaOne',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Cada persona tiene una historia. '
                  'Algunas comenzaron con una pregunta, '
                  'otras con un experimento y muchas con '
                  'el deseo de resolver un problema.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Personaje {
  final String nombre;
  final String area;
  final String epoca;
  final String imagen;
  final String descripcion;
  final String historia;
  final List<String> aportes;
  final String dato;
  final String reto;
  final IconData icono;
  final Color color;

  const _Personaje({
    required this.nombre,
    required this.area,
    required this.epoca,
    required this.imagen,
    required this.descripcion,
    required this.historia,
    required this.aportes,
    required this.dato,
    required this.reto,
    required this.icono,
    required this.color,
  });
}

class _TarjetaPersonaje extends StatelessWidget {
  final _Personaje personaje;
  final int numero;
  final VoidCallback onTap;

  const _TarjetaPersonaje({
    required this.personaje,
    required this.numero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF213454),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    personaje.imagen,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: personaje.color.withOpacity(.22),
                        child: Icon(
                          personaje.icono,
                          size: 65,
                          color: personaje.color,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF14213D)
                            .withOpacity(.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'PERSONAJE $numero',
                        style: const TextStyle(
                          color: Color(0xFFF5C96A),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    personaje.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'LilitaOne',
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        personaje.icono,
                        size: 15,
                        color: personaje.color,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          personaje.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFB9C8DE),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFFF5C96A),
                        size: 19,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetallePersonajeScreen extends StatelessWidget {
  final _Personaje personaje;

  const DetallePersonajeScreen({
    super.key,
    required this.personaje,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PersonasTransformanScreen.fondo,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final esComputadora = constraints.maxWidth > 750;

            return SingleChildScrollView(
              padding: EdgeInsets.all(
                esComputadora ? 28 : 15,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 850,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton.filled(
                            tooltip: 'Regresar al museo',
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  PersonasTransformanScreen.panel,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () =>
                                Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          const Text(
                            'EXPEDIENTE DEL MUSEO',
                            style: TextStyle(
                              color:
                                  PersonasTransformanScreen.dorado,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: PersonasTransformanScreen.panel,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: personaje.color,
                            width: 2,
                          ),
                        ),
                        child: Flex(
                          direction: esComputadora
                              ? Axis.horizontal
                              : Axis.vertical,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(18),
                              child: SizedBox(
                                width: esComputadora ? 220 : 180,
                                height: esComputadora ? 220 : 180,
                                child: Image.asset(
                                  personaje.imagen,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) {
                                    return Container(
                                      color: personaje.color
                                          .withOpacity(.2),
                                      child: Icon(
                                        personaje.icono,
                                        color: personaje.color,
                                        size: 75,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: esComputadora ? 22 : 0,
                              height: esComputadora ? 0 : 18,
                            ),
                            Expanded(
                              flex: esComputadora ? 1 : 0,
                              child: Column(
                                crossAxisAlignment:
                                    esComputadora
                                        ? CrossAxisAlignment.start
                                        : CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    personaje.area.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: personaje.color,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    personaje.nombre,
                                    textAlign: esComputadora
                                        ? TextAlign.left
                                        : TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 27,
                                      fontFamily: 'LilitaOne',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    personaje.epoca,
                                    style: const TextStyle(
                                      color: Color(0xFFF5C96A),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    personaje.descripcion,
                                    textAlign: esComputadora
                                        ? TextAlign.left
                                        : TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0xFFD5E1F5),
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      _BloqueMuseo(
                        titulo: 'Su historia',
                        icono: Icons.menu_book,
                        color: personaje.color,
                        contenido: Text(
                          personaje.historia,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      _BloqueMuseo(
                        titulo: 'Sus grandes aportes',
                        icono: Icons.workspace_premium,
                        color: personaje.color,
                        contenido: Column(
                          children: personaje.aportes.map((aporte) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: personaje.color,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      aporte,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 14),

                      _BloqueMuseo(
                        titulo: 'Un dato sorprendente',
                        icono: Icons.auto_awesome,
                        color: const Color(0xFFF5C96A),
                        contenido: Text(
                          personaje.dato,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      _BloqueMuseo(
                        titulo: 'Desafío del explorador',
                        icono: Icons.psychology,
                        color: const Color(0xFF7DD6D0),
                        contenido: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              personaje.reto,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '¡Piensa tu respuesta y comparte tu idea!',
                              style: TextStyle(
                                color: Color(0xFF7DD6D0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: personaje.color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.museum),
                          label: const Text(
                            'Volver a la galería',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Guarda los personajes que el explorador ha visitado.
Future<void> _registrarPersonajeVisitado(String nombre) async {
  final preferencias = await SharedPreferences.getInstance();

  final visitados =
      preferencias.getStringList('personas_visitadas') ?? [];

  if (!visitados.contains(nombre)) {
    visitados.add(nombre);

    await preferencias.setStringList(
      'personas_visitadas',
      visitados,
    );
  }
}

class _BloqueMuseo extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final Widget contenido;

  const _BloqueMuseo({
    required this.titulo,
    required this.icono,
    required this.color,
    required this.contenido,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: PersonasTransformanScreen.panel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(.55),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontFamily: 'LilitaOne',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          contenido,
        ],
      ),
    );
  }
}
