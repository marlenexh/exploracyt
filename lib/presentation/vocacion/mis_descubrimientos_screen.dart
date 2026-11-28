import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fondo_vocacion.dart';

class MisDescubrimientosScreen extends StatefulWidget {
  const MisDescubrimientosScreen({super.key});

  @override
  State<MisDescubrimientosScreen> createState() => _MisDescubrimientosScreenState();
}

class _MisDescubrimientosScreenState extends State<MisDescubrimientosScreen> {
  static const Color fondo = Color(0xFF14213D);
  static const Color panel = Color(0xFF213454);
  static const Color dorado = Color(0xFFF5C96A);
  static const Color turquesa = Color(0xFF7DD6D0);

  bool cargando = true;

  List<Map<String, dynamic>> resultados = [];
  List<String> profesionesFavoritas = [];
  List<String> personasVisitadas = [];

  String? fechaTest;

  @override
  void initState() {
    super.initState();
    _cargarDescubrimientos();
  }

  Future<void> _cargarDescubrimientos() async {
    final preferencias = await SharedPreferences.getInstance();

    // Recuperar resultado del test de intereses.
    final datosTest = preferencias.getString('resultado_test_intereses');

    List<Map<String, dynamic>> nuevosResultados = [];
    String? nuevaFecha;

    if (datosTest != null) {
      try {
        final datos = jsonDecode(datosTest) as Map<String, dynamic>;

        final lista = datos['resultados'];

        if (lista is List) {
          nuevosResultados = lista
              .whereType<Map>()
              .map(
                (elemento) => Map<String, dynamic>.from(elemento),
              )
              .toList();

          nuevosResultados.sort((a, b) {
            final puntosA = (a['puntos'] as num?) ?? 0;
            final puntosB = (b['puntos'] as num?) ?? 0;
            return puntosB.compareTo(puntosA);
          });
        }

        nuevaFecha = datos['fecha']?.toString();
      } catch (_) {
        nuevosResultados = [];
      }
    }

    // Recuperar profesiones favoritas.
    final nuevasFavoritas = preferencias.getStringList('profesiones_favoritas') ?? [];

    // Recuperar personas visitadas.
    final nuevasVisitas = preferencias.getStringList('personas_visitadas') ?? [];

    if (!mounted) return;

    setState(() {
      resultados = nuevosResultados;
      profesionesFavoritas = nuevasFavoritas;
      personasVisitadas = nuevasVisitas;
      fechaTest = nuevaFecha;
      cargando = false;
    });
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return '';

    try {
      final date = DateTime.parse(fecha).toLocal();

      final dia = date.day.toString().padLeft(2, '0');
      final mes = date.month.toString().padLeft(2, '0');
      final anio = date.year.toString();

      return 'Último test: $dia/$mes/$anio';
    } catch (_) {
      return '';
    }
  }

  int get insigniasDesbloqueadas {
    int cantidad = 0;

    if (resultados.isNotEmpty) cantidad++;
    if (profesionesFavoritas.isNotEmpty) cantidad++;
    if (personasVisitadas.isNotEmpty) cantidad++;

    return cantidad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: Stack(fit: StackFit.expand, children: [
        const FondoVocacion(velo: 0.3),
        SafeArea(
          child: cargando
              ? const Center(
                  child: CircularProgressIndicator(
                    color: dorado,
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final computadora = constraints.maxWidth > 750;

                    return SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: computadora ? 32 : 16,
                        vertical: 18,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 1050,
                          ),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, hijo) =>
                                Transform.translate(offset: Offset(0, (1 - v) * 50), child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Encabezado.
                                Row(
                                  children: [
                                    IconButton.filled(
                                      tooltip: 'Volver a vocación',
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
                                      'MI EXPEDIENTE',
                                      style: TextStyle(
                                        color: dorado,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                const Text(
                                  'MIS DESCUBRIMIENTOS',
                                  style: TextStyle(
                                    color: turquesa,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                const Text(
                                  '¡Este es tu camino!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontFamily: 'LilitaOne',
                                  ),
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  'Aquí puedes consultar lo que has '
                                  'descubierto en tu aventura por la '
                                  'ciencia y la tecnología.',
                                  style: TextStyle(
                                    color: Color(0xFFD5E1F5),
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),

                                const SizedBox(height: 22),

                                // Resumen del progreso.
                                _PanelProgreso(
                                  insignias: insigniasDesbloqueadas,
                                  resultados: resultados.isNotEmpty,
                                  favoritas: profesionesFavoritas.length,
                                  visitas: personasVisitadas.length,
                                ),

                                const SizedBox(height: 28),

                                // Intereses.
                                _TituloSeccion(
                                  icono: Icons.psychology,
                                  titulo: 'Mis intereses científicos',
                                  color: const Color(0xFF8EA5FF),
                                ),

                                const SizedBox(height: 12),

                                if (resultados.isEmpty)
                                  const _MensajeVacio(
                                    icono: Icons.quiz_outlined,
                                    titulo: 'Aún no has realizado el test',
                                    descripcion: 'Responde el test de intereses para '
                                        'descubrir qué áreas podrían gustarte.',
                                  )
                                else ...[
                                  if (fechaTest != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Text(
                                        _formatearFecha(fechaTest),
                                        style: const TextStyle(
                                          color: Color(0xFFB9C8DE),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ...resultados.map((resultado) {
                                    final area = resultado['area']?.toString() ?? 'Área sin nombre';
                                    final puntos = (resultado['puntos'] as num?)?.toInt() ?? 0;

                                    final maximo = resultados.fold<int>(
                                      0,
                                      (mayor, elemento) {
                                        final valor = (elemento['puntos'] as num?)?.toInt() ?? 0;
                                        return valor > mayor ? valor : mayor;
                                      },
                                    );

                                    final double porcentaje = maximo > 0 ? (puntos / maximo).clamp(0.0, 1.0).toDouble() : 0.0;

                                    return _TarjetaInteres(
                                      area: area,
                                      puntos: puntos,
                                      porcentaje: porcentaje,
                                    );
                                  }),
                                ],

                                const SizedBox(height: 28),

                                // Profesiones favoritas.
                                _TituloSeccion(
                                  icono: Icons.work_outline,
                                  titulo: 'Mis profesiones favoritas',
                                  color: const Color(0xFFFFB46D),
                                ),

                                const SizedBox(height: 12),

                                if (profesionesFavoritas.isEmpty)
                                  const _MensajeVacio(
                                    icono: Icons.star_border,
                                    titulo: 'Todavía no tienes favoritas',
                                    descripcion: 'Explora las profesiones y marca '
                                        'con una estrella las que más te '
                                        'interesen.',
                                  )
                                else
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: profesionesFavoritas.map((area) {
                                      return _EtiquetaDescubrimiento(
                                        texto: area,
                                        icono: Icons.star,
                                        color: const Color(0xFFFFB46D),
                                      );
                                    }).toList(),
                                  ),

                                const SizedBox(height: 28),

                                // Personas visitadas.
                                _TituloSeccion(
                                  icono: Icons.museum_outlined,
                                  titulo: 'Personas que he conocido',
                                  color: turquesa,
                                ),

                                const SizedBox(height: 12),

                                if (personasVisitadas.isEmpty)
                                  const _MensajeVacio(
                                    icono: Icons.person_search,
                                    titulo: 'El museo te está esperando',
                                    descripcion: 'Visita las historias de científicos '
                                        'e inventores para descubrir sus '
                                        'aportaciones.',
                                  )
                                else
                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: personasVisitadas.map((nombre) {
                                      return _EtiquetaDescubrimiento(
                                        texto: nombre,
                                        icono: Icons.check_circle,
                                        color: turquesa,
                                      );
                                    }).toList(),
                                  ),

                                const SizedBox(height: 28),

                                // Insignias.
                                _TituloSeccion(
                                  icono: Icons.workspace_premium,
                                  titulo: 'Mis insignias',
                                  color: dorado,
                                ),

                                const SizedBox(height: 12),

                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: computadora ? 3 : 1,
                                  childAspectRatio: computadora ? 2.2 : 3.1,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  children: [
                                    _TarjetaInsignia(
                                      titulo: 'Mente curiosa',
                                      descripcion: 'Realizaste el test',
                                      icono: Icons.psychology,
                                      desbloqueada: resultados.isNotEmpty,
                                    ),
                                    _TarjetaInsignia(
                                      titulo: 'Exploración de profesiones',
                                      descripcion: 'Guardaste una profesión favorita',
                                      icono: Icons.work,
                                      desbloqueada: profesionesFavoritas.isNotEmpty,
                                    ),
                                    _TarjetaInsignia(
                                      titulo: 'Viajero del conocimiento',
                                      descripcion: 'Visitaste el museo de ideas',
                                      icono: Icons.museum,
                                      desbloqueada: personasVisitadas.isNotEmpty,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                // Actualizar datos.
                                Center(
                                  child: OutlinedButton.icon(
                                    onPressed: _cargarDescubrimientos,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: turquesa,
                                      side: const BorderSide(
                                        color: turquesa,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 13,
                                      ),
                                    ),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text(
                                      'Actualizar mis descubrimientos',
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                const Center(
                                  child: Text(
                                    'Cada descubrimiento es el comienzo '
                                    'de una nueva aventura.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: dorado,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ]),
    );
  }
}

// --------------------------------------------------
// PANEL DE PROGRESO
// --------------------------------------------------

class _PanelProgreso extends StatelessWidget {
  final int insignias;
  final bool resultados;
  final int favoritas;
  final int visitas;

  const _PanelProgreso({
    required this.insignias,
    required this.resultados,
    required this.favoritas,
    required this.visitas,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF304A70),
            Color(0xFF213454),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF526A8B),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MI PROGRESO',
            style: TextStyle(
              color: Color(0xFFF5C96A),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _DatoProgreso(
                  numero: resultados ? '1' : '0',
                  texto: 'Test realizado',
                  icono: Icons.quiz,
                ),
              ),
              Expanded(
                child: _DatoProgreso(
                  numero: '$favoritas',
                  texto: 'Favoritas',
                  icono: Icons.star,
                ),
              ),
              Expanded(
                child: _DatoProgreso(
                  numero: '$visitas',
                  texto: 'Personas',
                  icono: Icons.people,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Icon(
                Icons.workspace_premium,
                color: Color(0xFFF5C96A),
                size: 25,
              ),
              const SizedBox(width: 9),
              Text(
                '$insignias de 3 insignias desbloqueadas',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DatoProgreso extends StatelessWidget {
  final String numero;
  final String texto;
  final IconData icono;

  const _DatoProgreso({
    required this.numero,
    required this.texto,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icono,
          color: const Color(0xFF7DD6D0),
          size: 25,
        ),
        const SizedBox(height: 7),
        Text(
          numero,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          texto,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFD5E1F5),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------
// TÍTULOS Y TARJETAS

class _TituloSeccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final Color color;

  const _TituloSeccion({
    required this.icono,
    required this.titulo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icono, color: color, size: 25),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            titulo,
            style: TextStyle(
              color: color,
              fontSize: 21,
              fontFamily: 'LilitaOne',
            ),
          ),
        ),
      ],
    );
  }
}

class _TarjetaInteres extends StatelessWidget {
  final String area;
  final int puntos;
  final double porcentaje;

  const _TarjetaInteres({
    required this.area,
    required this.puntos,
    required this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF213454),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFF8EA5FF).withOpacity(.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  area,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '$puntos puntos',
                style: const TextStyle(
                  color: Color(0xFF8EA5FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: porcentaje,
              minHeight: 9,
              backgroundColor: const Color(0xFF14213D),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF8EA5FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EtiquetaDescubrimiento extends StatelessWidget {
  final String texto;
  final IconData icono;
  final Color color;

  const _EtiquetaDescubrimiento({
    required this.texto,
    required this.icono,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF213454),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, color: color, size: 18),
          const SizedBox(width: 7),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeVacio extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;

  const _MensajeVacio({
    required this.icono,
    required this.titulo,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF213454),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF526A8B),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: const Color(0xFF7DD6D0),
            size: 35,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  descripcion,
                  style: const TextStyle(
                    color: Color(0xFFB9C8DE),
                    fontSize: 12,
                    height: 1.4,
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

class _TarjetaInsignia extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final IconData icono;
  final bool desbloqueada;

  const _TarjetaInsignia({
    required this.titulo,
    required this.descripcion,
    required this.icono,
    required this.desbloqueada,
  });

  @override
  Widget build(BuildContext context) {
    final color = desbloqueada ? const Color(0xFFF5C96A) : const Color(0xFF8290A6);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF213454),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: color.withOpacity(.6),
        ),
      ),
      child: Row(
        children: [
          Icon(
            desbloqueada ? icono : Icons.lock_outline,
            color: color,
            size: 32,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desbloqueada ? '¡Desbloqueada!' : descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFD5E1F5),
                    fontSize: 10,
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
