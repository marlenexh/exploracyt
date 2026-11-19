import 'package:flutter/material.dart';

import '../../data/body_topic.dart';

class BodyDiagram extends StatelessWidget {
  const BodyDiagram({
    super.key,
    required this.system,
    this.structures = const [],
    this.onSelect,
    this.selected,
    this.motion = 0,
    this.flow = 0,
    this.inhaling = true,
  });

  final BodySystem system;
  final List<BodyStructure> structures;
  final ValueChanged<int>? onSelect;
  final int? selected;
  final double motion, flow;
  final bool inhaling;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 300,
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(
                painter: _DiagramPainter(system, motion, flow, inhaling),
              ),
              for (final (index, structure) in structures.indexed)
                Positioned(
                  left: constraints.maxWidth * structure.x - 24,
                  top: constraints.maxHeight * structure.y - 24,
                  child: IconButton.filledTonal(
                    tooltip: structure.name,
                    isSelected: selected == index,
                    onPressed: onSelect == null ? null : () => onSelect!(index),
                    icon: Text('${index + 1}'),
                    selectedIcon: const Icon(Icons.check),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _DiagramPainter extends CustomPainter {
  const _DiagramPainter(this.system, this.motion, this.flow, this.inhaling);

  final BodySystem system;
  final double motion, flow;
  final bool inhaling;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 300, size.height / 300);
    final paint = Paint();
    void circle(double x, double y, double radius, Color color) {
      canvas.drawCircle(Offset(x, y), radius, paint..color = color);
    }

    void line(List<Offset> points, Color color, double width) {
      final path = Path()..addPolygon(points, false);
      canvas.drawPath(
        path,
        paint
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = width,
      );
      paint.style = PaintingStyle.fill;
    }

    void oval(double x, double y, double w, double h, Color color) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        paint..color = color,
      );
    }

    const silhouette = Color(0xFFCBE0D8);
    const outline = Color(0xFF497768);
    const red = Color(0xFFB43956);
    const blue = Color(0xFF32649C);
    circle(150, 44, 26, silhouette);
    line(const [Offset(150, 66), Offset(150, 155)], silhouette, 28);
    line(
      const [
        Offset(76, 146),
        Offset(102, 113),
        Offset(126, 94),
        Offset(174, 94),
        Offset(198, 113),
        Offset(224, 146),
      ],
      silhouette,
      27,
    );
    oval(150, 129, 91, 109, silhouette);
    line(
      const [Offset(132, 164), Offset(125, 204), Offset(117, 262)],
      silhouette,
      32,
    );
    line(
      const [Offset(168, 164), Offset(175, 204), Offset(183, 262)],
      silhouette,
      32,
    );

    if (system == BodySystem.breathing || system == BodySystem.teamwork) {
      final expansion = motion * 13;
      oval(126, 136, 36 + expansion, 63 + expansion, const Color(0xFFC46577));
      oval(174, 136, 36 + expansion, 63 + expansion, const Color(0xFFC46577));
      const airway = [
        Offset(150, 47),
        Offset(150, 104),
        Offset(172, 126),
        Offset(184, 150),
      ];
      line(airway, blue, 6);
      line(
        const [Offset(150, 104), Offset(127, 126), Offset(116, 151)],
        blue,
        6,
      );
      for (var i = 0; i < 3; i++) {
        circle(
          182 + i * 5,
          151 + (i.isEven ? 3 : -3),
          5,
          const Color(0xFFFFD0C2),
        );
      }
      final diaphragm = 180 + motion * 10;
      line(
        [
          Offset(111, diaphragm + 4),
          Offset(150, diaphragm - 8 + motion * 7),
          Offset(189, diaphragm + 4),
        ],
        outline,
        5,
      );
      if (system == BodySystem.breathing) {
        final progress = (inhaling ? flow : 1 - flow) * (airway.length - 1);
        final segment = progress.floor().clamp(0, airway.length - 2).toInt();
        final at = Offset.lerp(
          airway[segment],
          airway[segment + 1],
          progress - segment,
        )!;
        circle(at.dx, at.dy, 6, const Color(0xFFF9DF66));
      }
    }
    if (system == BodySystem.circulation || system == BodySystem.teamwork) {
      const outgoing = [
        Offset(152, 113),
        Offset(169, 145),
        Offset(170, 202),
        Offset(181, 248),
      ];
      const returning = [
        Offset(181, 248),
        Offset(130, 208),
        Offset(130, 151),
        Offset(152, 113),
      ];
      line(outgoing, red, 5);
      line(returning, blue, 5);
      if (system == BodySystem.circulation) {
        oval(121, 106, 22, 34, const Color(0xFFEAB9C4));
        oval(179, 106, 22, 34, const Color(0xFFEAB9C4));
        line(
          const [Offset(151, 112), Offset(135, 98), Offset(121, 106)],
          blue,
          5,
        );
        line(
          const [Offset(179, 106), Offset(168, 97), Offset(151, 112)],
          red,
          5,
        );
      }
      for (final (index, route) in [outgoing, returning].indexed) {
        final progress = ((flow + index * .45) % 1) * (route.length - 1);
        final segment = progress.floor();
        final at = Offset.lerp(
          route[segment],
          route[segment + 1],
          progress - segment,
        )!;
        circle(at.dx, at.dy, 5, const Color(0xFFFFDF69));
      }
      final heart = Path()
        ..moveTo(151, 132 + motion * 5)
        ..cubicTo(118 - motion * 6, 108, 139, 94 - motion * 4, 151, 106)
        ..cubicTo(
          163,
          94 - motion * 4,
          183 + motion * 6,
          108,
          151,
          132 + motion * 5,
        );
      canvas.drawPath(heart, paint..color = red);
    }
    if (system == BodySystem.defense) {
      line(
        const [Offset(70, 150), Offset(97, 119), Offset(118, 104)],
        outline,
        6,
      );
      line(
        const [Offset(123, 182), Offset(116, 233)],
        const Color(0xFFD77A7B),
        9,
      );
      for (final point in const [
        Offset(120, 107),
        Offset(119, 122),
        Offset(128, 141),
        Offset(121, 160),
      ]) {
        circle(point.dx, point.dy, 6, outline);
      }
      circle(161, 133, 17, const Color(0xFFFBFAE9));
      circle(164, 132, 8, blue);
      for (final point in const [
        Offset(202, 82),
        Offset(222, 91),
        Offset(220, 74),
      ]) {
        circle(point.dx, point.dy, 6, red);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_DiagramPainter old) =>
      old.system != system ||
      old.motion != motion ||
      old.flow != flow ||
      old.inhaling != inhaling;
}
