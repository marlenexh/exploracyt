
import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../game_widgets.dart';
import 'test_intereses_screen.dart';
import 'explora_profesiones_screen.dart';
import 'personas_transforman_screen.dart';
import 'mis_descubrimientos_screen.dart';

class VocacionScreen extends StatelessWidget {
  const VocacionScreen({super.key});

  static const List<_OpcionVocacion> opciones = [
    _OpcionVocacion(
      titulo: 'Descubre tus intereses',
      descripcion:
          'Explora tus gustos, curiosidades y habilidades mediante '
          'preguntas y situaciones divertidas.',
      icono: Icons.explore,
      color: Color(0xFF3D5AFE),
    ),
    _OpcionVocacion(
      titulo: 'Explora profesiones',
      descripcion:
          'Conoce profesiones relacionadas con Biología, Química, '
          'Física, Electrónica, Inteligencia Artificial y Programación.',
      icono: Icons.work_outline,
      color: Color(0xFFE87932),
    ),
    _OpcionVocacion(
      titulo: 'Personas que transforman el mundo',
      descripcion:
          'Conoce científicos, ingenieros, programadores, '
          'investigadores y desarrolladores.',
      icono: Icons.lightbulb_outline,
      color: Color(0xFF26965A),
    ),
    _OpcionVocacion(
      titulo: 'Mis descubrimientos',
      descripcion:
          'Consulta las profesiones, áreas e insignias que '
          'has descubierto.',
      icono: Icons.workspace_premium,
      color: Color(0xFFB8860B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/fondo.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Container(color: const Color(0xFFEAF2E3)),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final esComputadora = constraints.maxWidth > 700;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(esComputadora ? 24 : 12),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1270),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              IconButton.filled(
                                tooltip: 'Volver',
                                style: IconButton.styleFrom(
                                  backgroundColor: C.tinta,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () =>
                                    Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back),
                              ),
                              const Spacer(),
                              const Text(
                                'VOCACIÓN',
                                style: TextStyle(
                                  color: C.tinta,
                                  fontSize: 25,
                                  fontFamily: 'LilitaOne',
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              const SizedBox(width: 48),
                            ],
                          ),

                          const SizedBox(height: 12),

                          const Zati(size: 125),

                          const SizedBox(height: 8),

                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: const Color(0xFF8CC8F0),
                                width: 2,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Column(
                              children: [
                                Text(
                                  '¡Explora tu futuro!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: C.tinta,
                                    fontSize: 27,
                                    fontFamily: 'LilitaOne',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'La ciencia y la tecnología tienen '
                                  'muchas posibilidades. Descubre '
                                  'qué te gusta, conoce nuevas '
                                  'profesiones y encuentra todo '
                                  'lo que puedes llegar a crear.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: C.tinta,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            '¿Qué quieres descubrir hoy?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: C.tinta,
                              fontSize: 22,
                              fontFamily: 'LilitaOne',
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 14),

                          GridView.builder(
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount: opciones.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  esComputadora ? 2 : 1,
                              mainAxisExtent:
                                  esComputadora ? 165 : 145,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemBuilder: (context, index) {
                              final opcion = opciones[index];

                              return _TarjetaVocacion(
                                opcion: opcion,
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                         builder: (_) => const TestInteresesScreen(),
                                      ),
                                    );
                                    } else if (index == 1) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ExploraProfesionesScreen(),
                                          ),
                                        );
                                    } else if (index == 2) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const PersonasTransformanScreen(),
                                          ),
                                        );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const MisDescubrimientosScreen(),
                                        ),
                                    );
                                  }
                                },
                              );
                            },
                          ),

                          const SizedBox(height: 18),

                          const Text(
                            '¡No hay una sola manera de construir tu futuro!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: C.tinta,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 5,
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
        ],
      ),
    );
  }
}

class _OpcionVocacion {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final Color color;

  const _OpcionVocacion({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.color,
  });
}

class _TarjetaVocacion extends StatelessWidget {
  final _OpcionVocacion opcion;
  final VoidCallback onTap;

  const _TarjetaVocacion({
    required this.opcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(opcion.color, Colors.white, .28)!,
                opcion.color,
                Color.lerp(opcion.color, Colors.black, .18)!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white,
              width: 2.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 7,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.22),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    opcion.icono,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opcion.titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'LilitaOne',
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 3,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        opcion.descripcion,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pantalla temporal para conectar los cuatro apartados.
/// Cada apartado tendrá su propia implementación.
class ApartadoVocacionScreen extends StatelessWidget {
  final _OpcionVocacion opcion;

  const ApartadoVocacionScreen({
    super.key,
    required this.opcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(opcion.titulo),
        backgroundColor: opcion.color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                opcion.icono,
                color: opcion.color,
                size: 75,
              ),
              const SizedBox(height: 16),
              Text(
                opcion.titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'LilitaOne',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                opcion.descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 18),
              const Text(
                'Este apartado se desarrollará proximamente.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
