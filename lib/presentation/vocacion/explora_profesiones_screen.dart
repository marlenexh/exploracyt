
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../game_widgets.dart';

// PANTALLA PRINCIPAL: EXPLORA PROFESIONES

class ExploraProfesionesScreen extends StatefulWidget {
  const ExploraProfesionesScreen({super.key});

  static const String claveFavoritas = 'profesiones_favoritas';

  static const List<_Profesion> profesiones = [
    _Profesion(
      nombre: 'Bióloga / Biólogo',
      area: 'Biología',
      descripcion: 'Investiga los seres vivos, las plantas, '
          'los animales y los ecosistemas.',
      queHace: [
        'Observa plantas y animales.',
        'Investiga cómo viven los organismos.',
        'Ayuda a proteger la naturaleza.',
      ],
      actividad: 'Imagina que encuentras una planta desconocida. '
          '¿Qué características observarías para conocerla?',
      curiosidad: 'Algunas personas que estudian biología '
          'investigan especies que todavía no conocemos.',
      icono: Icons.eco,
      color: Color(0xFF26965A),
      emoji: '🌿',
    ),
    _Profesion(
      nombre: 'Química / Químico',
      area: 'Química',
      descripcion: 'Estudia de qué están hechas las sustancias '
          'y cómo pueden transformarse.',
      queHace: [
        'Realiza experimentos.',
        'Analiza diferentes materiales.',
        'Investiga nuevas sustancias.',
      ],
      actividad: 'Piensa en una mezcla que puedas preparar '
          'con agua y otros materiales. ¿Qué crees que sucedería?',
      curiosidad: 'La química está presente en los alimentos, '
          'los medicamentos y muchos objetos cotidianos.',
      icono: Icons.science,
      color: Color(0xFFE87932),
      emoji: '🧪',
    ),
    _Profesion(
      nombre: 'Física / Físico',
      area: 'Física',
      descripcion: 'Investiga cómo funcionan la energía, '
          'el movimiento, la luz y las fuerzas.',
      queHace: [
        'Realiza experimentos.',
        'Estudia el movimiento de los objetos.',
        'Busca explicar fenómenos naturales.',
      ],
      actividad: 'Si lanzas una pelota hacia arriba, '
          '¿qué crees que sucede antes de que vuelva a caer?',
      curiosidad: 'La física ayuda a comprender cómo funcionan '
          'los cohetes, los imanes y la electricidad.',
      icono: Icons.bolt,
      color: Color(0xFF3D5AFE),
      emoji: '⚡',
    ),
    _Profesion(
      nombre: 'Ingeniera / Ingeniero electrónico',
      area: 'Electrónica',
      descripcion: 'Diseña y construye circuitos y dispositivos '
          'electrónicos.',
      queHace: [
        'Diseña circuitos.',
        'Construye prototipos.',
        'Investiga cómo mejorar dispositivos.',
      ],
      actividad: 'Imagina que quieres construir una lámpara '
          'que se encienda automáticamente. ¿Qué necesitarías?',
      curiosidad: 'Los circuitos electrónicos están presentes '
          'en teléfonos, computadoras y robots.',
      icono: Icons.memory,
      color: Color(0xFF9B59B6),
      emoji: '🔌',
    ),
    _Profesion(
      nombre: 'Especialista en inteligencia artificial',
      area: 'Inteligencia Artificial',
      descripcion: 'Desarrolla sistemas capaces de reconocer '
          'patrones y aprender a partir de datos.',
      queHace: [
        'Entrena modelos de inteligencia artificial.',
        'Analiza información.',
        'Desarrolla soluciones tecnológicas.',
      ],
      actividad: '¿Cómo enseñarías a una computadora a '
          'distinguir entre fotografías de perros y gatos?',
      curiosidad: 'La inteligencia artificial puede ayudar '
          'a reconocer imágenes, traducir idiomas y detectar patrones.',
      icono: Icons.smart_toy,
      color: Color(0xFF168CBA),
      emoji: '🤖',
    ),
    _Profesion(
      nombre: 'Programadora / Programador',
      area: 'Programación',
      descripcion: 'Crea instrucciones para desarrollar '
          'aplicaciones, videojuegos y programas.',
      queHace: [
        'Escribe código.',
        'Diseña aplicaciones.',
        'Resuelve problemas mediante programas.',
      ],
      actividad: 'Si crearas un videojuego, ¿qué personaje, '
          'misión y desafío tendría?',
      curiosidad: 'Los videojuegos, las aplicaciones y muchas '
          'páginas web funcionan gracias a la programación.',
      icono: Icons.code,
      color: Color(0xFFDB4D86),
      emoji: '💻',
    ),
  ];

  @override
  State<ExploraProfesionesScreen> createState() =>
      _ExploraProfesionesScreenState();
}

class _ExploraProfesionesScreenState
    extends State<ExploraProfesionesScreen> {
  Set<String> favoritas = {};
  bool cargando = true;
  bool mostrarSoloFavoritas = false;

  @override
  void initState() {
    super.initState();
    _cargarFavoritas();
  }

  Future<void> _cargarFavoritas() async {
    final preferencias = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      favoritas = preferencias
          .getStringList(ExploraProfesionesScreen.claveFavoritas)
          ?.toSet() ?? {};
      cargando = false;
    });
  }

  Future<void> _alternarFavorita(String area) async {
    final preferencias = await SharedPreferences.getInstance();

    setState(() {
      if (favoritas.contains(area)) {
        favoritas.remove(area);
      } else {
        favoritas.add(area);
      }
    });

    await preferencias.setStringList(
      ExploraProfesionesScreen.claveFavoritas,
      favoritas.toList(),
    );
  }

  Future<void> _abrirProfesion(_Profesion profesion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProfesionScreen(
          profesion: profesion,
        ),
      ),
    );

    _cargarFavoritas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101B3D),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF172750),
              Color(0xFF273C70),
              Color(0xFF172750),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ancho = constraints.maxWidth;
              final computadora = ancho > 850;
              final columnas = ancho > 850
                  ? 3
                  : ancho > 550
                      ? 2
                      : 1;

              final lista = ExploraProfesionesScreen.profesiones
                  .where((p) =>
                      !mostrarSoloFavoritas ||
                      favoritas.contains(p.area))
                  .toList();

              return SingleChildScrollView(
                padding: EdgeInsets.all(computadora ? 25 : 14),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 1150,
                    ),
                    child: Column(
                      children: [
                        // ENCABEZADO
                        Row(
                          children: [
                            _BotonRegresar(
                              onTap: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            const Text(
                              'CENTRO DE EXPLORACIÓN',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 45),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // PORTADA
                        _PortadaProfesiones(
                          computadora: computadora,
                          totalFavoritas: favoritas.length,
                        ),

                        const SizedBox(height: 25),

                        // FILTROS
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'ELIGE TU PRÓXIMA AVENTURA',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: .5,
                                ),
                              ),
                            ),
                            Text(
                              '${lista.length} mundos',
                              style: const TextStyle(
                                color: Color(0xFFFFD66B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 13),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _FiltroBoton(
                                texto: 'Todos',
                                icono: Icons.explore,
                                seleccionado: !mostrarSoloFavoritas,
                                onTap: () {
                                  setState(() {
                                    mostrarSoloFavoritas = false;
                                  });
                                },
                              ),
                              _FiltroBoton(
                                texto: 'Mis favoritas',
                                icono: Icons.star,
                                seleccionado: mostrarSoloFavoritas,
                                onTap: () {
                                  setState(() {
                                    mostrarSoloFavoritas = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // TARJETAS DE PROFESIONES
                        if (cargando)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(
                              color: Color(0xFFFFD66B),
                            ),
                          )
                        else if (lista.isEmpty)
                          _SinFavoritas()
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: lista.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: columnas,
                              mainAxisExtent: 205,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                            ),
                            itemBuilder: (context, index) {
                              final profesion = lista[index];

                              return _TarjetaProfesion(
                                key: ValueKey(profesion.area),
                                profesion: profesion,
                                favorita:
                                    favoritas.contains(profesion.area),
                                retraso: index * 90,
                                onTap: () =>
                                    _abrirProfesion(profesion),
                                onFavorita: () =>
                                    _alternarFavorita(profesion.area),
                              );
                            },
                          ),

                        const SizedBox(height: 25),

                        const Text(
                          '¡Tu curiosidad puede llevarte muy lejos!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFFD66B),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// =======================================================
// MODELO DE PROFESIÓN

class _Profesion {
  final String nombre;
  final String area;
  final String descripcion;
  final List<String> queHace;
  final String actividad;
  final String curiosidad;
  final IconData icono;
  final Color color;
  final String emoji;

  const _Profesion({
    required this.nombre,
    required this.area,
    required this.descripcion,
    required this.queHace,
    required this.actividad,
    required this.curiosidad,
    required this.icono,
    required this.color,
    required this.emoji,
  });
}

// =======================================================
// PORTADA ANIMADA

class _PortadaProfesiones extends StatelessWidget {
  final bool computadora;
  final int totalFavoritas;

  const _PortadaProfesiones({
    required this.computadora,
    required this.totalFavoritas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF5146B8),
            Color(0xFF2879B9),
            Color(0xFF22A6A1),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(.65),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.25),
            blurRadius: 15,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: computadora
          ? Row(
              children: [
                const Expanded(
                  flex: 3,
                  child: _TextoPortada(),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: _ZatiPortada(
                    totalFavoritas: totalFavoritas,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const _TextoPortada(),
                const SizedBox(height: 15),
                _ZatiPortada(
                  totalFavoritas: totalFavoritas,
                ),
              ],
            ),
    );
  }
}

class _TextoPortada extends StatelessWidget {
  const _TextoPortada();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '¡HOLA, EXPLORADOR!',
          style: TextStyle(
            color: Color(0xFFFFDF7A),
            fontSize: 15,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Conoce nuevos futuros',
          style: TextStyle(
            color: Colors.white,
            fontSize: 31,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Descubre profesiones increíbles, conoce sus secretos '
          'y encuentra las áreas que despiertan tu curiosidad.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ZatiPortada extends StatelessWidget {
  final int totalFavoritas;

  const _ZatiPortada({
    required this.totalFavoritas,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.85, end: 1),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, valor, child) {
            return Transform.scale(
              scale: valor,
              child: child,
            );
          },
          child: const Zati(size: 125),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.2),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white38),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.star,
                color: Color(0xFFFFDF7A),
                size: 20,
              ),
              const SizedBox(width: 7),
              Text(
                '$totalFavoritas profesiones favoritas',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =======================================================
// TARJETA ANIMADA DE PROFESIÓN

class _TarjetaProfesion extends StatefulWidget {
  final _Profesion profesion;
  final bool favorita;
  final VoidCallback onTap;
  final VoidCallback onFavorita;
  final int retraso;

  const _TarjetaProfesion({
    super.key,
    required this.profesion,
    required this.favorita,
    required this.onTap,
    required this.onFavorita,
    required this.retraso,
  });

  @override
  State<_TarjetaProfesion> createState() =>
      _TarjetaProfesionState();
}

class _TarjetaProfesionState extends State<_TarjetaProfesion> {
  bool presionada = false;

  @override
  Widget build(BuildContext context) {
    final profesion = widget.profesion;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(
        milliseconds: 450 + widget.retraso,
      ),
      curve: Curves.easeOutBack,
      builder: (context, valor, child) {
        return Opacity(
          opacity: valor.clamp(0, 1),
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - valor)),
            child: Transform.scale(
              scale: .94 + (.06 * valor),
              child: child,
            ),
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => presionada = true),
        onExit: (_) => setState(() => presionada = false),
        child: AnimatedScale(
          scale: presionada ? 1.025 : 1,
          duration: const Duration(milliseconds: 180),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: widget.onTap,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.lerp(
                        profesion.color,
                        Colors.white,
                        .22,
                      )!,
                      profesion.color,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(.8),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: profesion.color.withOpacity(.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -30,
                      child: Icon(
                        profesion.icono,
                        size: 125,
                        color: Colors.white.withOpacity(.10),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.23),
                                  borderRadius:
                                      BorderRadius.circular(17),
                                  border: Border.all(
                                    color: Colors.white54,
                                  ),
                                ),
                                child: Icon(
                                  profesion.icono,
                                  color: Colors.white,
                                  size: 34,
                                ),
                              ),
                              const Spacer(),

                              IconButton(
                                tooltip: widget.favorita
                                    ? 'Quitar de favoritas'
                                    : 'Agregar a favoritas',
                                onPressed: widget.onFavorita,
                                icon: AnimatedSwitcher(
                                  duration: const Duration(
                                    milliseconds: 250,
                                  ),
                                  transitionBuilder:
                                      (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    widget.favorita
                                        ? Icons.star
                                        : Icons.star_border,
                                    key: ValueKey(widget.favorita),
                                    color: const Color(0xFFFFE47A),
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Spacer(),

                          Text(
                            profesion.area.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            profesion.nombre,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 7),

                          Row(
                            children: const [
                              Text(
                                'Descubrir profesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 17,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =======================================================
// FILTROS Y BOTONES

class _FiltroBoton extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onTap;

  const _FiltroBoton({
    required this.texto,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: seleccionado
            ? const Color(0xFFFFD66B)
            : const Color(0xFF2D416C),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: seleccionado
              ? Colors.white
              : Colors.white30,
          width: 1.5,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 11,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                size: 19,
                color: seleccionado
                    ? const Color(0xFF273454)
                    : Colors.white,
              ),
              const SizedBox(width: 7),
              Text(
                texto,
                style: TextStyle(
                  color: seleccionado
                      ? const Color(0xFF273454)
                      : Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotonRegresar extends StatelessWidget {
  final VoidCallback onTap;

  const _BotonRegresar({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF344B78),
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: 'Volver',
        onPressed: onTap,
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _SinFavoritas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFF273C70),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white30),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.star_border_rounded,
            color: Color(0xFFFFD66B),
            size: 65,
          ),
          SizedBox(height: 12),
          Text(
            '¡Todavía no tienes favoritas!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Explora las profesiones y toca la estrella '
            'para guardar las que más te gusten.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// =======================================================
// DETALLE DE PROFESIÓN

class DetalleProfesionScreen extends StatefulWidget {
  final _Profesion profesion;

  const DetalleProfesionScreen({
    super.key,
    required this.profesion,
  });

  @override
  State<DetalleProfesionScreen> createState() =>
      _DetalleProfesionScreenState();
}

class _DetalleProfesionScreenState
    extends State<DetalleProfesionScreen> {
  bool favorita = false;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarEstadoFavorita();
  }

  Future<void> _cargarEstadoFavorita() async {
    final preferencias = await SharedPreferences.getInstance();
    final lista = preferencias.getStringList(
          ExploraProfesionesScreen.claveFavoritas,
        ) ??
        [];

    if (!mounted) return;

    setState(() {
      favorita = lista.contains(widget.profesion.area);
      cargando = false;
    });
  }

  Future<void> _alternarFavorita() async {
    final preferencias = await SharedPreferences.getInstance();

    final lista = preferencias.getStringList(
          ExploraProfesionesScreen.claveFavoritas,
        ) ??
        [];

    if (favorita) {
      lista.remove(widget.profesion.area);
    } else {
      lista.add(widget.profesion.area);
    }

    await preferencias.setStringList(
      ExploraProfesionesScreen.claveFavoritas,
      lista,
    );

    if (!mounted) return;

    setState(() {
      favorita = !favorita;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profesion = widget.profesion;

    return Scaffold(
      backgroundColor: const Color(0xFF172750),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF172750),
              Color(0xFF273C70),
              Color(0xFF172750),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final computadora = constraints.maxWidth > 700;

              return SingleChildScrollView(
                padding: EdgeInsets.all(
                  computadora ? 25 : 14,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 850,
                    ),
                    child: Column(
                      children: [
                        // ENCABEZADO
                        Row(
                          children: [
                            _BotonRegresar(
                              onTap: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            const Text(
                              'FICHA DE EXPLORACIÓN',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(width: 45),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // PRESENTACIÓN
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: .8, end: 1),
                          duration: const Duration(
                            milliseconds: 700,
                          ),
                          curve: Curves.elasticOut,
                          builder: (context, valor, child) {
                            return Transform.scale(
                              scale: valor,
                              child: child,
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.lerp(
                                    profesion.color,
                                    Colors.white,
                                    .18,
                                  )!,
                                  profesion.color,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: profesion.color.withOpacity(.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white70,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    profesion.icono,
                                    color: Colors.white,
                                    size: 65,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  profesion.area.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  profesion.nombre,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 29,
                                    fontWeight: FontWeight.w900,
                                    height: 1.2,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                Text(
                                  profesion.descripcion,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                FilledButton.icon(
                                  onPressed: cargando
                                      ? null
                                      : _alternarFavorita,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: profesion.color,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  icon: Icon(
                                    favorita
                                        ? Icons.star
                                        : Icons.star_border,
                                  ),
                                  label: Text(
                                    favorita
                                        ? 'Quitar de favoritas'
                                        : 'Agregar a favoritas',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // QUÉ HACE
                        _SeccionDetalle(
                          titulo: '¿Qué hace?',
                          icono: Icons.lightbulb,
                          color: profesion.color,
                          contenido: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: profesion.queHace.map(
                              (actividad) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: profesion.color,
                                        size: 21,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          actividad,
                                          style: const TextStyle(
                                            color: Color(0xFF273454),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // ACTIVIDAD
                        _SeccionDetalle(
                          titulo: '¡Activa tu imaginación!',
                          icono: Icons.psychology,
                          color: profesion.color,
                          contenido: Text(
                            profesion.actividad,
                            style: const TextStyle(
                              color: Color(0xFF273454),
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // CURIOSIDAD
                        _SeccionDetalle(
                          titulo: 'Dato curioso',
                          icono: Icons.auto_awesome,
                          color: profesion.color,
                          contenido: Text(
                            profesion.curiosidad,
                            style: const TextStyle(
                              color: Color(0xFF273454),
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.pop(context),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFFFD66B),
                              foregroundColor: const Color(0xFF273454),
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            icon: const Icon(Icons.explore),
                            label: const Text(
                              'Explorar otras profesiones',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
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
      ),
    );
  }
}

// =======================================================
// SECCIONES DEL DETALLE

class _SeccionDetalle extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Color color;
  final Widget contenido;

  const _SeccionDetalle({
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(.5),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(.13),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icono,
                  color: color,
                  size: 25,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          contenido,
        ],
      ),
    );
  }
}
