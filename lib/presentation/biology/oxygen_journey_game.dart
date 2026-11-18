
import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show VoidCallback, ValueChanged;
import 'package:flutter/material.dart' show
    Alignment,
    FontWeight,
    LinearGradient,
    TextDirection,
    TextPainter,
    TextSpan,
    TextStyle;

class OxygenJourneyGame extends FlameGame {
  OxygenJourneyGame({
    required this.onProgress,
    required this.onCompleted,
    required this.onDustTouched,
  });

  final ValueChanged<int> onProgress;
  final VoidCallback onCompleted;
  final VoidCallback onDustTouched;

  static const int targetBubbles = 5;

  final math.Random random = math.Random();
  final List<_GameObject> bubbles = [];
  final List<_GameObject> dustParticles = [];

  Offset playerPosition = Offset.zero;
  Offset? targetPosition;

  int collectedBubbles = 0;
  bool completed = false;
  bool initialized = false;

  double elapsedTime = 0;
  double dustCooldown = 0;

  @override
  Color backgroundColor() => const Color(0xFF102E59);

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);

    if (canvasSize.x <= 0 || canvasSize.y <= 0) return;

    if (!initialized) {
      initialized = true;
      playerPosition = Offset(
        canvasSize.x * 0.18,
        canvasSize.y * 0.50,
      );
      createObjects();
    } else {
      playerPosition = clampPosition(playerPosition);
      if (targetPosition != null) {
        targetPosition = clampPosition(targetPosition!);
      }
    }
  }

  Offset clampPosition(Offset position) {
    return Offset(
      position.dx.clamp(
        25.0,
        math.max(25.0, size.x - 25),
      ).toDouble(),
      position.dy.clamp(
        45.0,
        math.max(45.0, size.y - 25),
      ).toDouble(),
    );
  }

  Offset randomPosition() {
    return Offset(
      size.x * (0.35 + random.nextDouble() * 0.50),
      size.y * (0.22 + random.nextDouble() * 0.56),
    );
  }

  void createObjects() {
    bubbles.clear();
    dustParticles.clear();

    for (int i = 0; i < 5; i++) {
      bubbles.add(
        _GameObject(
          position: randomPosition(),
          radius: 14,
          speed: 12 + random.nextDouble() * 12,
        ),
      );
    }

    for (int i = 0; i < 4; i++) {
      dustParticles.add(
        _GameObject(
          position: randomPosition(),
          radius: 15,
          speed: 16 + random.nextDouble() * 12,
        ),
      );
    }
  }

  void movePlayerTo(Offset position) {
    if (!initialized || completed) return;
    targetPosition = clampPosition(position);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (!initialized || completed) return;

    elapsedTime += dt;
    dustCooldown = math.max(0, dustCooldown - dt);

    if (targetPosition != null) {
      final delta = targetPosition! - playerPosition;
      final distance = delta.distance;

      if (distance > 2) {
        final step = math.min(distance, 250 * dt);
        playerPosition += delta / distance * step;
      }
    }

    for (final bubble in bubbles) {
      bubble.position = Offset(
        bubble.position.dx - bubble.speed * dt,
        bubble.position.dy +
            math.sin(elapsedTime * 2 + bubble.speed) * dt * 5,
      );

      if (bubble.position.dx < -20) {
        bubble.position = randomPosition();
      }

      if ((playerPosition - bubble.position).distance <
          bubble.radius + 19) {
        collectedBubbles++;
        bubble.position = randomPosition();
        onProgress(collectedBubbles);

        if (collectedBubbles >= targetBubbles) {
          completed = true;
          targetPosition = null;
          onCompleted();
          return;
        }
      }
    }

    for (final dust in dustParticles) {
      dust.position = Offset(
        dust.position.dx - dust.speed * dt,
        dust.position.dy +
            math.sin(elapsedTime * 3 + dust.speed) * dt * 8,
      );

      if (dust.position.dx < -20) {
        dust.position = randomPosition();
      }

      if (dustCooldown <= 0 &&
          (playerPosition - dust.position).distance <
              dust.radius + 18) {
        dustCooldown = 1.5;
        dust.position = randomPosition();
        onDustTouched();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final width = size.x;
    final height = size.y;

    if (width <= 0 || height <= 0) return;

    drawBackground(canvas, width, height);
    drawTunnel(canvas, width, height);

    for (final bubble in bubbles) {
      drawBubble(canvas, bubble.position);
    }

    for (final dust in dustParticles) {
      drawDust(canvas, dust.position);
    }

    drawPlayer(canvas);
  }

  void drawBackground(
    Canvas canvas,
    double width,
    double height,
  ) {
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF17365D),
          Color(0xFF286C93),
          Color(0xFF6C4D91),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, width, height),
      );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      paint,
    );
  }

  void drawTunnel(
    Canvas canvas,
    double width,
    double height,
  ) {
    final upper = Path()..moveTo(0, height * 0.17);
    final lower = Path()..moveTo(0, height * 0.83);

    for (double x = 0; x <= width + 10; x += 10) {
      final wave = math.sin(
        x / 65 + elapsedTime * 0.8,
      );

      upper.lineTo(
        x,
        height * 0.17 + wave * 12,
      );

      lower.lineTo(
        x,
        height * 0.83 + wave * 12,
      );
    }

    final wallPaint = Paint()
      ..color = const Color(0xFFFFA8BD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(upper, wallPaint);
    canvas.drawPath(lower, wallPaint);

    for (int i = 0; i < 15; i++) {
      final x = (i * 73.0 + elapsedTime * 15) % width;
      final y = height * (0.25 + (i % 6) * 0.09);

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = const Color(0x5578E7FF),
      );
    }
  }

  void drawBubble(Canvas canvas, Offset center) {
    canvas.drawCircle(
      center,
      21,
      Paint()..color = const Color(0x6679F7FF),
    );

    canvas.drawCircle(
      center,
      14,
      Paint()..color = const Color(0xFF83EEFF),
    );

    canvas.drawCircle(
      Offset(center.dx - 4, center.dy - 4),
      4,
      Paint()..color = const Color(0xFFFFFFFF),
    );
  }

  void drawDust(Canvas canvas, Offset center) {
    final path = Path();

    for (int i = 0; i < 12; i++) {
      final angle = i * math.pi / 6;
      final radius = i.isEven ? 17.0 : 11.0;

      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }

    path.close();

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFF8B5A65),
    );

    for (final dx in [-5.0, 5.0]) {
      canvas.drawCircle(
        Offset(center.dx + dx, center.dy - 2),
        2,
        Paint()..color = const Color(0xFFFFFFFF),
      );
    }
  }

  void drawPlayer(Canvas canvas) {
    final center = playerPosition;
    final bounce = math.sin(elapsedTime * 5) * 2;

    canvas.drawCircle(
      center,
      29 + bounce,
      Paint()..color = const Color(0x6672EFFF),
    );

    canvas.drawCircle(
      center,
      22,
      Paint()..color = const Color(0xFF66DEFF),
    );

    for (final dx in [-7.0, 7.0]) {
      canvas.drawCircle(
        Offset(center.dx + dx, center.dy - 4),
        3,
        Paint()..color = const Color(0xFF17365D),
      );
    }

    final smile = Path()
      ..moveTo(center.dx - 7, center.dy + 5)
      ..quadraticBezierTo(
        center.dx,
        center.dy + 13,
        center.dx + 7,
        center.dy + 5,
      );

    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF17365D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    final painter = TextPainter(
      text: const TextSpan(
        text: 'Oxi',
        style: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(
      canvas,
      Offset(
        center.dx - painter.width / 2,
        center.dy - 40,
      ),
    );
  }
}

class _GameObject {
  Offset position;
  final double radius;
  final double speed;

  _GameObject({
    required this.position,
    required this.radius,
    required this.speed,
  });
}
