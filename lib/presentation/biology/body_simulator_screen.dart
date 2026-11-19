
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../main.dart' show store;

class BodySimulatorScreen extends StatefulWidget {
  final String missionId;

  const BodySimulatorScreen({
    super.key,
    required this.missionId,
  });

  @override
  State<BodySimulatorScreen> createState() =>
      _BodySimulatorScreenState();
}

class _BodySimulatorScreenState
    extends State<BodySimulatorScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController animation;

  int activity = 0;
  int prediction = -1;
  int answer = -1;
  bool experimented = false;
  bool comparing = false;
  bool saving = false;

  final Set<int> observed = {};

  static const names = ['Reposo', 'Caminar', 'Correr'];
  static const rates = [76, 98, 136];
  static const breaths = [16, 21, 32];

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  bool get completed =>
      store.completadas.contains(widget.missionId);

  bool get canFinish =>
      prediction >= 0 &&
      observed.length == 3 &&
      answer == 0 &&
      !saving &&
      !completed;

  Future<void> finishMission() async {
    if (!canFinish) return;

    setState(() => saving = true);

    try {
      await store.completar(widget.missionId);

      if (!mounted) return;

      setState(() => saving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '¡Investigación completada! '
            'Revisa tus descubrimientos.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo guardar el progreso. '
            'Inténtalo nuevamente.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123F73),
        foregroundColor: Colors.white,
        title: const Text('Laboratorio del cuerpo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          header(),
          const SizedBox(height: 16),
          predictionCard(),
          const SizedBox(height: 16),
          experimentCard(),
          const SizedBox(height: 16),
          if (comparing) comparisonCard(),
          const SizedBox(height: 16),
          challengeCard(),
          const SizedBox(height: 16),
          careerCard(),
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF153F79),
            Color(0xFF197E91),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'MISIÓN: ¡EL CUERPO EN ACCIÓN!',
            style: TextStyle(
              color: Color(0xFFFFD45C),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '¿Por qué cambia nuestro cuerpo '
            'cuando hacemos ejercicio?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Zati necesita investigar cómo trabajan '
            'el corazón y los pulmones. '
            '¡Ayúdalo a descubrirlo!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget predictionCard() {
    return section(
      '1. Formula tu hipótesis',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué crees que ocurrirá con los latidos '
            'del corazón al correr?',
          ),
          const SizedBox(height: 10),
          for (int i = 0; i < 3; i++)
            RadioListTile<int>(
              title: Text([
                'Disminuirán',
                'Aumentarán',
                'Se mantendrán iguales',
              ][i]),
              value: i,
              // ignore: deprecated_member_use
              groupValue: prediction,
              // ignore: deprecated_member_use
              onChanged: (value) {
                setState(() => prediction = value!);
              },
            ),
          if (prediction >= 0)
            const Text(
              '¡Buena hipótesis! Ahora vamos '
              'a investigar si coincide '
              'con los resultados.',
              style: TextStyle(
                color: Color(0xFF24775C),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget experimentCard() {
    return section(
      '2. Experimenta',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona una actividad y observa '
            'qué sucede en el modelo del cuerpo.',
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < 3; i++)
                ChoiceChip(
                  avatar: Icon(
                    [
                      Icons.airline_seat_recline_normal,
                      Icons.directions_walk,
                      Icons.directions_run,
                    ][i],
                    size: 18,
                  ),
                  label: Text(names[i]),
                  selected: activity == i,
                  onSelected: (_) {
                    setState(() {
                      activity = i;
                      observed.add(i);
                      experimented = true;
                    });
                  },
                ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF102D50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedBuilder(
              animation: animation,
              builder: (context, _) {
                return CustomPaint(
                  painter: BodyPainter(
                    time: animation.value * 5,
                    heartRate: rates[activity],
                    breathRate: breaths[activity],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: metric(
                  Icons.favorite,
                  '${rates[activity]}',
                  'Latidos/min',
                  Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: metric(
                  Icons.air,
                  '${breaths[activity]}',
                  'Respiraciones/min',
                  Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            activity == 0
                ? 'En reposo, el organismo tiene '
                    'menor demanda de oxígeno.'
                : activity == 1
                    ? 'Al caminar, los músculos '
                        'necesitan más energía y oxígeno.'
                    : 'Al correr, aumentan las '
                        'necesidades de los músculos. '
                        'El corazón y la respiración '
                        'suelen acelerarse.',
          ),

          const SizedBox(height: 10),

          const Text(
            'Los valores son ejemplos simulados. '
            'En las personas reales varían según '
            'la edad, actividad y otros factores.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: observed.length / 3,
            minHeight: 9,
            borderRadius: BorderRadius.circular(10),
          ),

          const SizedBox(height: 6),

          Text(
            'Condiciones exploradas: '
            '${observed.length} de 3',
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: observed.length == 3
                ? () => setState(() => comparing = true)
                : null,
            icon: const Icon(Icons.bar_chart),
            label: const Text('Comparar resultados'),
          ),
        ],
      ),
    );
  }

  Widget comparisonCard() {
    return section(
      '3. Analiza los resultados',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Compara los latidos del corazón '
            'en las tres actividades.',
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < 3; i++) ...[
            Text('${names[i]}: ${rates[i]} latidos/min'),
            const SizedBox(height: 5),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: rates[i] / 150,
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: [
                    Colors.green,
                    Colors.orange,
                    Colors.redAccent,
                  ][i],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Text(
            prediction == 1
                ? 'Tu hipótesis coincide con este '
                    'modelo: al aumentar la actividad, '
                    'aumenta la frecuencia cardíaca.'
                : 'Tu hipótesis fue diferente. '
                    'Eso también forma parte de '
                    'investigar: comparar lo que '
                    'pensábamos con lo observado.',
          ),
        ],
      ),
    );
  }

  Widget challengeCard() {
    return section(
      '4. Reto científico',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Zati está caminando por la montaña '
            'y comienza a correr. ¿Por qué '
            'aumenta su frecuencia cardíaca?',
          ),
          const SizedBox(height: 8),

          for (int i = 0; i < 3; i++)
            RadioListTile<int>(
              title: Text([
                'Para transportar más oxígeno '
                    'y nutrientes hacia los tejidos.',
                'Porque los pulmones dejan '
                    'de funcionar.',
                'Porque la sangre desaparece.',
              ][i]),
              value: i,
              // ignore: deprecated_member_use
              groupValue: answer,
              // ignore: deprecated_member_use
              onChanged: (value) {
                setState(() => answer = value!);
              },
            ),

          if (answer >= 0)
            Text(
              answer == 0
                  ? '¡Correcto! Relacionaste la '
                      'circulación con las necesidades '
                      'de los músculos.'
                  : 'Observa nuevamente los resultados '
                      'y piensa qué necesitan los '
                      'músculos durante el ejercicio.',
              style: TextStyle(
                color: answer == 0
                    ? Colors.green.shade800
                    : Colors.deepOrange,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: canFinish ? finishMission : null,
              icon: const Icon(Icons.emoji_events),
              label: Text(
                completed
                    ? 'Investigación completada'
                    : saving
                        ? 'Guardando...'
                        : 'Completar investigación',
              ),
            ),
          ),

          if (!completed && !canFinish)
            const Text(
              'Para completar: formula una hipótesis, '
              'explora las tres actividades '
              'y resuelve el reto.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  Widget careerCard() {
    return section(
      '5. Descubre una vocación científica',
      const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¿Sabías que hay personas que investigan '
            'cómo funciona nuestro cuerpo?',
          ),
          SizedBox(height: 8),
          Text(
            'La fisiología estudia el funcionamiento '
            'de los seres vivos. Quienes investigan '
            'esta área pueden estudiar cómo responden '
            'el corazón y los pulmones al ejercicio.',
          ),
          SizedBox(height: 8),
          Text(
            'Pregunta para explorar: '
            '¿qué otra actividad te gustaría '
            'investigar y comparar?',
          ),
        ],
      ),
    );
  }

  Widget section(String title, Widget child) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF173F69),
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget metric(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// ANIMACIÓN DEL CORAZÓN, PULMONES Y CIRCULACIÓN
// =====================================================

class BodyPainter extends CustomPainter {
  final double time;
  final int heartRate;
  final int breathRate;

  BodyPainter({
    required this.time,
    required this.heartRate,
    required this.breathRate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final heartPhase =
        time * heartRate * 2 * math.pi / 60;

    final breathPhase =
        time * breathRate * 2 * math.pi / 60;

    final heartbeat =
        math.pow(math.max(0.0, math.sin(heartPhase)), 6)
            .toDouble();

    final lungScale =
        1 + 0.09 * math.sin(breathPhase);

    final center = Offset(w / 2, h * 0.52);

    // Título del esquema
    final title = TextPainter(
      text: const TextSpan(
        text: 'MODELO DEL CUERPO',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    title.paint(
      canvas,
      Offset((w - title.width) / 2, 12),
    );

    // Silueta esquemática del torso
    final torsoPaint = Paint()
      ..color = const Color(0xFF27577B)
      ..style = PaintingStyle.fill;

    final torso = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: math.min(w * 0.72, 270),
        height: h * 0.72,
      ),
      const Radius.circular(65),
    );

    canvas.drawRRect(torso, torsoPaint);

    // Vías respiratorias
    final airwayPaint = Paint()
      ..color = const Color(0xFFB4E7FF)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w / 2, h * 0.12),
      Offset(w / 2, h * 0.38),
      airwayPaint,
    );

    // Pulmones: se expanden y contraen
    final lungPaint = Paint()
      ..color = const Color(0xFF85D9F3)
      ..style = PaintingStyle.fill;

    final lungWidth = math.min(w * 0.22, 78.0);

    for (final direction in [-1.0, 1.0]) {
      canvas.save();

      final lungCenter = Offset(
        w / 2 + direction * lungWidth * 0.66,
        h * 0.46,
      );

      canvas.translate(
        lungCenter.dx,
        lungCenter.dy,
      );

      canvas.scale(lungScale, lungScale);

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: lungWidth,
          height: h * 0.35,
        ),
        lungPaint,
      );

      canvas.restore();
    }

    // Corazón animado
    final heartCenter = Offset(
      w / 2 - 14,
      h * 0.58,
    );

    canvas.save();
    canvas.translate(
      heartCenter.dx,
      heartCenter.dy,
    );

    final scale = 1 + heartbeat * 0.17;
    canvas.scale(scale, scale);

    final heart = Path()
      ..moveTo(0, 15)
      ..cubicTo(-45, -12, -23, -43, 0, -21)
      ..cubicTo(23, -43, 45, -12, 0, 15)
      ..close();

    canvas.drawPath(
      heart,
      Paint()..color = const Color(0xFFFF566D),
    );

    canvas.restore();

    // Circuito esquemático de circulación
    final vesselPaint = Paint()
      ..color = const Color(0xFFFF7385)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final vessel = Path()
      ..moveTo(w / 2, h * 0.62)
      ..cubicTo(
        w * 0.14, h * 0.75,
        w * 0.14, h * 0.27,
        w / 2, h * 0.62,
      );

    canvas.drawPath(vessel, vesselPaint);

    final metric = vessel.computeMetrics().first;

    final flow = time * (heartRate / 76);

    for (int i = 0; i < 8; i++) {
      final fraction = (flow * 0.11 + i / 8) % 1;
      final tangent = metric.getTangentForOffset(
        metric.length * fraction,
      );

      if (tangent != null) {
        canvas.drawCircle(
          tangent.position,
          4.5,
          Paint()..color = const Color(0xFFFFD0D6),
        );
      }
    }

    // Indicador de respiración
    final breathLabel = TextPainter(
      text: const TextSpan(
        text: 'PULMONES',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    breathLabel.paint(
      canvas,
      Offset(
        w / 2 - breathLabel.width / 2,
        h * 0.79,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant BodyPainter oldDelegate) {
    return oldDelegate.time != time ||
        oldDelegate.heartRate != heartRate ||
        oldDelegate.breathRate != breathRate;
  }
}
