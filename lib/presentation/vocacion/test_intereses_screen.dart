import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../game_widgets.dart';
import 'fondo_vocacion.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class _Respuesta {
  final String texto;
  final IconData icono;
  final List<String> areas;

  const _Respuesta({
    required this.texto,
    required this.icono,
    required this.areas,
  });
}

class _Pregunta {
  final String pregunta;
  final String descripcion;
  final List<_Respuesta> respuestas;

  const _Pregunta({
    required this.pregunta,
    required this.descripcion,
    required this.respuestas,
  });
}

const List<_Pregunta> preguntasIntereses = [
  _Pregunta(
    pregunta: '¿Qué aventura te gustaría vivir?',
    descripcion: 'Imagina que puedes explorar cualquier lugar.',
    respuestas: [
      _Respuesta(
        texto: 'Investigar animales y plantas en un bosque.',
        icono: Icons.forest,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Descubrir de qué están hechas las cosas.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Explorar planetas y fenómenos del universo.',
        icono: Icons.rocket_launch,
        areas: ['Física'],
      ),
      _Respuesta(
        texto: 'Crear un robot para explorar lugares.',
        icono: Icons.smart_toy,
        areas: ['Electrónica', 'Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué invento te gustaría crear?',
    descripcion: '¡Imagina que tienes un laboratorio a tu disposición!',
    respuestas: [
      _Respuesta(
        texto: 'Un dispositivo que ayude a cuidar plantas.',
        icono: Icons.eco,
        areas: ['Biología', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Un material nuevo y resistente.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Una máquina que funcione con energía solar.',
        icono: Icons.wb_sunny,
        areas: ['Física', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Un programa que resuelva problemas.',
        icono: Icons.code,
        areas: ['Programación', 'Inteligencia Artificial'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué te gustaría investigar?',
    descripcion: 'Elige el misterio que más curiosidad te dé.',
    respuestas: [
      _Respuesta(
        texto: 'Cómo viven y se comunican los seres vivos.',
        icono: Icons.pets,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Por qué algunas sustancias cambian de color.',
        icono: Icons.color_lens,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Cómo vuelan los aviones y cohetes.',
        icono: Icons.flight,
        areas: ['Física'],
      ),
      _Respuesta(
        texto: 'Cómo una computadora puede aprender.',
        icono: Icons.psychology,
        areas: ['Inteligencia Artificial'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: 'Si participaras en un equipo, ¿qué harías?',
    descripcion: 'Cada integrante puede aportar algo diferente.',
    respuestas: [
      _Respuesta(
        texto: 'Observar, cuidar y estudiar seres vivos.',
        icono: Icons.nature,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Realizar experimentos y mezclar materiales.',
        icono: Icons.colorize,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Construir mecanismos y probar cómo funcionan.',
        icono: Icons.settings,
        areas: ['Física', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Diseñar instrucciones para una computadora.',
        icono: Icons.terminal,
        areas: ['Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué herramienta elegirías?',
    descripcion: 'Tienes que resolver un desafío científico.',
    respuestas: [
      _Respuesta(
        texto: 'Un microscopio para observar cosas diminutas.',
        icono: Icons.biotech,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Tubos de ensayo para experimentar.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Un kit para construir circuitos eléctricos.',
        icono: Icons.electrical_services,
        areas: ['Electrónica', 'Física'],
      ),
      _Respuesta(
        texto: 'Una computadora para crear un proyecto.',
        icono: Icons.computer,
        areas: ['Programación', 'Inteligencia Artificial'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué problema te gustaría ayudar a resolver?',
    descripcion: 'Piensa en algo que podría mejorar nuestro mundo.',
    respuestas: [
      _Respuesta(
        texto: 'Proteger especies y cuidar los ecosistemas.',
        icono: Icons.pets,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Encontrar formas de limpiar el agua.',
        icono: Icons.water_drop,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Aprovechar mejor la energía.',
        icono: Icons.bolt,
        areas: ['Física', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Crear tecnología que ayude a las personas.',
        icono: Icons.smart_toy,
        areas: ['Inteligencia Artificial', 'Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué actividad te parece más emocionante?',
    descripcion: '¡Elige la misión que aceptarías primero!',
    respuestas: [
      _Respuesta(
        texto: 'Explorar un jardín y descubrir nuevas especies.',
        icono: Icons.local_florist,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Hacer experimentos para descubrir reacciones.',
        icono: Icons.bubble_chart,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Construir un pequeño vehículo eléctrico.',
        icono: Icons.electric_car,
        areas: ['Física', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Enseñarle tareas a un robot virtual.',
        icono: Icons.smart_toy,
        areas: ['Inteligencia Artificial', 'Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Cómo resolverías un desafío difícil?',
    descripcion: 'No existe una única forma de encontrar soluciones.',
    respuestas: [
      _Respuesta(
        texto: 'Observaría con atención y buscaría pistas.',
        icono: Icons.search,
        areas: ['Biología', 'Física'],
      ),
      _Respuesta(
        texto: 'Haría pruebas y compararía los resultados.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Construiría un modelo para probar mi idea.',
        icono: Icons.precision_manufacturing,
        areas: ['Electrónica', 'Física'],
      ),
      _Respuesta(
        texto: 'Crearía instrucciones paso a paso.',
        icono: Icons.code,
        areas: ['Programación', 'Inteligencia Artificial'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué lugar visitarías?',
    descripcion: '¡Puedes elegir cualquier lugar de exploración!',
    respuestas: [
      _Respuesta(
        texto: 'Una reserva natural llena de vida.',
        icono: Icons.forest,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Un laboratorio de investigación.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Un centro de investigación espacial.',
        icono: Icons.public,
        areas: ['Física'],
      ),
      _Respuesta(
        texto: 'Un laboratorio donde crean robots inteligentes.',
        icono: Icons.smart_toy,
        areas: ['Electrónica', 'Inteligencia Artificial'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué te gustaría aprender a hacer?',
    descripcion: 'Piensa en una habilidad que te gustaría desarrollar.',
    respuestas: [
      _Respuesta(
        texto: 'Identificar plantas, animales y sus características.',
        icono: Icons.eco,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Preparar mezclas y estudiar sus propiedades.',
        icono: Icons.colorize,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Armar circuitos y mecanismos.',
        icono: Icons.memory,
        areas: ['Electrónica', 'Física'],
      ),
      _Respuesta(
        texto: 'Crear videojuegos o aplicaciones.',
        icono: Icons.videogame_asset,
        areas: ['Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué proyecto elegirías para una feria?',
    descripcion: '¡Tu equipo necesita una idea original!',
    respuestas: [
      _Respuesta(
        texto: 'Un pequeño huerto para estudiar el crecimiento.',
        icono: Icons.grass,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Un experimento sobre materiales y sus cambios.',
        icono: Icons.science,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Una lámpara que funcione con un circuito.',
        icono: Icons.lightbulb,
        areas: ['Electrónica', 'Física'],
      ),
      _Respuesta(
        texto: 'Un juego que utilice inteligencia artificial.',
        icono: Icons.smart_toy,
        areas: ['Inteligencia Artificial', 'Programación'],
      ),
    ],
  ),
  _Pregunta(
    pregunta: '¿Qué te gustaría descubrir en el futuro?',
    descripcion: '¡Todo gran descubrimiento comienza con curiosidad!',
    respuestas: [
      _Respuesta(
        texto: 'Nuevas formas de proteger la vida en el planeta.',
        icono: Icons.public,
        areas: ['Biología'],
      ),
      _Respuesta(
        texto: 'Materiales que ayuden a mejorar nuestra vida.',
        icono: Icons.diamond,
        areas: ['Química'],
      ),
      _Respuesta(
        texto: 'Nuevas tecnologías para explorar el espacio.',
        icono: Icons.rocket,
        areas: ['Física', 'Electrónica'],
      ),
      _Respuesta(
        texto: 'Máquinas y programas que ayuden a resolver problemas.',
        icono: Icons.memory,
        areas: ['Inteligencia Artificial', 'Programación'],
      ),
    ],
  ),
];

class TestInteresesScreen extends StatefulWidget {
  const TestInteresesScreen({super.key});

  @override
  State<TestInteresesScreen> createState() => _TestInteresesScreenState();
}

class _TestInteresesScreenState extends State<TestInteresesScreen> {
  int preguntaActual = 0;
  final List<int?> respuestasSeleccionadas = List<int?>.filled(preguntasIntereses.length, null);

  Future<void> siguiente() async {
    if (respuestasSeleccionadas[preguntaActual] == null) return;

    if (preguntaActual < preguntasIntereses.length - 1) {
      setState(() => preguntaActual++);
    } else {
      await mostrarResultado();
    }
  }

  void anterior() {
    if (preguntaActual > 0) {
      setState(() => preguntaActual--);
    }
  }

  Future<void> mostrarResultado() async {
    final Map<String, int> puntuaciones = {
      'Biología': 0,
      'Química': 0,
      'Física': 0,
      'Electrónica': 0,
      'Inteligencia Artificial': 0,
      'Programación': 0,
    };

    for (int i = 0; i < preguntasIntereses.length; i++) {
      final seleccion = respuestasSeleccionadas[i];

      if (seleccion == null) continue;

      final respuesta = preguntasIntereses[i].respuestas[seleccion];

      for (final area in respuesta.areas) {
        puntuaciones[area] = (puntuaciones[area] ?? 0) + 1;
      }
    }

    final resultados = puntuaciones.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Guardar el resultado en el dispositivo.
    final preferencias = await SharedPreferences.getInstance();

    final datosResultado = {
      'resultados': resultados.map((resultado) {
        return {
          'area': resultado.key,
          'puntos': resultado.value,
        };
      }).toList(),
      'fecha': DateTime.now().toIso8601String(),
    };

    await preferencias.setString(
      'resultado_test_intereses',
      jsonEncode(datosResultado),
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultadoInteresesScreen(
          resultados: resultados,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pregunta = preguntasIntereses[preguntaActual];
    final seleccion = respuestasSeleccionadas[preguntaActual];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FondoVocacion(velo: 0.1),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final esComputadora = constraints.maxWidth > 700;

                return SingleChildScrollView(
                  padding: EdgeInsets.all(esComputadora ? 24 : 14),
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
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              const Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'DESCUBRE TUS INTERESES',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'LilitaOne',
                                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Zati(size: 105),
                          const SizedBox(height: 10),

                          // Progreso del cuestionario
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Flexible(
                                      child: Text(
                                        'Tu aventura de descubrimiento',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: C.tinta,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${preguntaActual + 1} de ${preguntasIntereses.length}',
                                      style: const TextStyle(
                                        color: C.tinta,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: LinearProgressIndicator(
                                    value: (preguntaActual + 1) / preguntasIntereses.length,
                                    minHeight: 12,
                                    backgroundColor: const Color(0xFFE1E8F5),
                                    color: const Color(0xFF3D5AFE),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          TweenAnimationBuilder<double>(
                            key: ValueKey(preguntaActual),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeOutBack,
                            builder: (_, v, hijo) => Transform.translate(
                              offset: Offset((1 - v) * 80, 0),
                              child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo),
                            ),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
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
                                    blurRadius: 7,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    pregunta.pregunta,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: C.tinta,
                                      fontSize: 25,
                                      fontFamily: 'LilitaOne',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    pregunta.descripcion,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: C.tinta,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: pregunta.respuestas.length,
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: esComputadora ? 2 : 1,
                                      mainAxisExtent: 85,
                                      crossAxisSpacing: 18,
                                      mainAxisSpacing: 18,
                                    ),
                                    itemBuilder: (context, index) {
                                      final respuesta = pregunta.respuestas[index];
                                      final estaSeleccionada = seleccion == index;

                                      return InkWell(
                                        borderRadius: BorderRadius.circular(16),
                                        onTap: () {
                                          setState(() {
                                            respuestasSeleccionadas[preguntaActual] = index;
                                          });
                                        },
                                        child: AnimatedScale(
                                          scale: estaSeleccionada ? 1.04 : 1,
                                          duration: const Duration(milliseconds: 220),
                                          curve: Curves.easeOutBack,
                                          child: AnimatedContainer(
                                            duration: const Duration(milliseconds: 180),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color:
                                                  estaSeleccionada ? const Color(0xFFDCE5FF) : const Color(0xFFF5F7FC),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: estaSeleccionada ? const Color(0xFF3D5AFE) : Colors.black12,
                                                width: estaSeleccionada ? 3 : 1,
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  respuesta.icono,
                                                  color: const Color(0xFF3D5AFE),
                                                  size: 30,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    respuesta.texto,
                                                    style: const TextStyle(
                                                      color: C.tinta,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                if (estaSeleccionada)
                                                  const Icon(
                                                    Icons.check_circle,
                                                    color: Color(0xFF26965A),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              if (preguntaActual > 0)
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: anterior,
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Anterior'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: C.tinta,
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                    ),
                                  ),
                                ),
                              if (preguntaActual > 0) const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: seleccion == null ? null : siguiente,
                                  icon: Icon(
                                    preguntaActual == preguntasIntereses.length - 1
                                        ? Icons.workspace_premium
                                        : Icons.arrow_forward,
                                  ),
                                  label: Text(
                                    preguntaActual == preguntasIntereses.length - 1
                                        ? 'Ver mis resultados'
                                        : 'Siguiente',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF3D5AFE),
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.grey.shade400,
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            'No hay respuestas correctas o incorrectas. '
                            '¡Elige lo que más te guste!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
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

class ResultadoInteresesScreen extends StatelessWidget {
  final List<MapEntry<String, int>> resultados;

  const ResultadoInteresesScreen({
    super.key,
    required this.resultados,
  });

  static const Map<String, IconData> iconos = {
    'Biología': Icons.eco,
    'Química': Icons.science,
    'Física': Icons.rocket_launch,
    'Electrónica': Icons.memory,
    'Inteligencia Artificial': Icons.psychology,
    'Programación': Icons.code,
  };

  @override
  Widget build(BuildContext context) {
    final mayorPuntuacion = resultados.first.value;

    final principales = resultados.where((resultado) => resultado.value == mayorPuntuacion).toList();

    final otrasAreas = resultados.where((resultado) => resultado.value < mayorPuntuacion).toList();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FondoVocacion(velo: 0.1),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 750),
                  child: Column(
                    children: [
                      const Zati(size: 120),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: const Color(0xFF8CC8F0),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              '¡Descubriste tus intereses!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: C.tinta,
                                fontSize: 27,
                                fontFamily: 'LilitaOne',
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Estas son algunas áreas que podrían '
                              'llamar tu atención. ¡Sigue explorando!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: C.tinta,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              'Tus áreas destacadas',
                              style: TextStyle(
                                color: C.tinta,
                                fontSize: 21,
                                fontFamily: 'LilitaOne',
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...principales.map(
                              (resultado) => _TarjetaResultado(
                                nombre: resultado.key,
                                icono: iconos[resultado.key]!,
                                destacado: true,
                              ),
                            ),
                            if (otrasAreas.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              const Text(
                                'También puedes explorar',
                                style: TextStyle(
                                  color: C.tinta,
                                  fontSize: 19,
                                  fontFamily: 'LilitaOne',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ...otrasAreas.map(
                                (resultado) => _TarjetaResultado(
                                  nombre: resultado.key,
                                  icono: iconos[resultado.key]!,
                                  destacado: false,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            const Text(
                              'Recuerda: este resultado no decide '
                              'tu futuro. Puedes descubrir y disfrutar '
                              'todas las áreas que quieras.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: C.tinta,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.home),
                                label: const Text('Volver a vocación'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF3D5AFE),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const TestInteresesScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.refresh),
                              label: const Text('Volver a realizar'),
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
        ],
      ),
    );
  }
}

class _TarjetaResultado extends StatelessWidget {
  final String nombre;
  final IconData icono;
  final bool destacado;

  const _TarjetaResultado({
    required this.nombre,
    required this.icono,
    required this.destacado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: destacado ? const Color(0xFFDCE5FF) : const Color(0xFFF3F6FC),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: destacado ? const Color(0xFF3D5AFE) : Colors.black12,
          width: destacado ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: const Color(0xFF3D5AFE),
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nombre,
              style: const TextStyle(
                color: C.tinta,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (destacado)
            const Icon(
              Icons.star,
              color: Color(0xFFE8A317),
            ),
        ],
      ),
    );
  }
}
