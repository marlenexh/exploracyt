
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

class AirTunnelGame extends FlameGame {
  AirTunnelGame({
    required this.onProgress,
    required this.onDustTouched,
    required this.onCompleted,
  });

  final ValueChanged<int> onProgress;
  final VoidCallback onDustTouched;
  final VoidCallback onCompleted;

  static const int targetStars = 7;

  final math.Random random = math.Random();
  final List<_TunnelObject> stars = [];
  final List<_TunnelObject> dustParticles = [];

  Offset playerPosition = Offset.zero;
  Offset? targetPosition;

  int collectedStars = 0;
  bool completed = false;
  bool initialized = false;

  double elapsedTime = 0;
  double dustCooldown = 0;

  @override
  Color backgroundColor() => const Color(0xFF263D76);

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
    final minX = 25.0;
    final maxX = math.max(minX, size.x - 25);

    final minY = size.y * 0.28;
    final maxY = size.y * 0.72;

    return Offset(
      position.dx.clamp(minX, maxX).toDouble(),
      position.dy.clamp(minY, maxY).toDouble(),
    );
  }

  Offset randomPosition() {
    return Offset(
      size.x * (0.45 + random.nextDouble() * 0.48),
      size.y * (0.32 + random.nextDouble() * 0.36),
    );
  }

  void createObjects() {
    stars.clear();
    dustParticles.clear();

    for (int i = 0; i < 5; i++) {
      stars.add(
        _TunnelObject(
          position: randomPosition(),
          speed: 55 + random.nextDouble() * 30,
          radius: 13,
        ),
      );
    }

    for (int i = 0; i < 4; i++) {
      dustParticles.add(
        _TunnelObject(
          position: randomPosition(),
          speed: 65 + random.nextDouble() * 35,
          radius: 17,
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

    // Oxi follows the explorer's finger or mouse.
    if (targetPosition != null) {
      final delta = targetPosition! - playerPosition;
      final distance = delta.distance;

      if (distance > 2) {
        final step = math.min(distance, 290 * dt);
        playerPosition += delta / distance * step;
      }
    }

    // A gentle current moves Oxi through the tunnel.
    playerPosition = clampPosition(
      Offset(
        playerPosition.dx + 12 * dt,
        playerPosition.dy,
      ),
    );

    for (final star in stars) {
      star.position = Offset(
        star.position.dx - star.speed * dt,
        star.position.dy +
            math.sin(elapsedTime * 3 + star.speed) * 7 * dt,
      );

      if (star.position.dx < -25) {
        star.position = randomPosition();
      }

      if ((playerPosition - star.position).distance <
          star.radius + 20) {
        collectedStars++;
        star.position = randomPosition();

        onProgress(collectedStars);

        if (collectedStars >= targetStars) {
          completed = true;
          targetPosition = null;
          onCompleted();
          return;
        }
      }
    }

    for (final particle in dustParticles) {
      particle.position = Offset(
        particle.position.dx - particle.speed * dt,
        particle.position.dy +
            math.sin(elapsedTime * 2 + particle.speed) * 9 * dt,
      );

      if (particle.position.dx < -25) {
        particle.position = randomPosition();
      }

      if (dustCooldown <= 0 &&
          (playerPosition - particle.position).distance <
              particle.radius + 20) {
        dustCooldown = 1.3;
        particle.position = randomPosition();
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

    for (final star in stars) {
      drawStar(canvas, star.position);
    }

    for (final particle in dustParticles) {
      drawDust(canvas, particle.position);
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
          Color(0xFF342B78),
          Color(0xFF875AA6),
          Color(0xFFE68FAF),
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
    final upper = Path()..moveTo(0, height * 0.22);
    final lower = Path()..moveTo(0, height * 0.78);

    for (double x = 0; x <= width + 10; x += 10) {
      final wave = math.sin(
        x / 55 + elapsedTime * 1.5,
      );

      upper.lineTo(
        x,
        height * 0.22 + wave * 10,
      );

      lower.lineTo(
        x,
        height * 0.78 + wave * 10,
      );
    }

    final wallPaint = Paint()
      ..color = const Color(0xFFFFB6C8)
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(upper, wallPaint);
    canvas.drawPath(lower, wallPaint);

    final currentPaint = Paint()
      ..color = const Color(0x8899F3FF)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 9; i++) {
      final x = (i * 100.0 - elapsedTime * 85) %
          (width + 100);

      final y = height * (0.32 + (i % 4) * 0.12);

      canvas.drawLine(
        Offset(x, y),
        Offset(x + 32, y),
        currentPaint,
      );
    }
  }

  void drawStar(Canvas canvas, Offset center) {
    final path = Path();

    for (int i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final radius = i.isEven ? 17.0 : 8.0;

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

    canvas.drawCircle(
      center,
      23,
      Paint()..color = const Color(0x66FFE58A),
    );

    canvas.drawPath(
      path,
      Paint()..color = const Color(0xFFFFD75C),
    );
  }

  void drawDust(Canvas canvas, Offset center) {
    final dustPaint = Paint()
      ..color = const Color(0xFF9D6586);

    canvas.drawCircle(center, 17, dustPaint);

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;

      canvas.drawCircle(
        Offset(
          center.dx + math.cos(angle) * 13,
          center.dy + math.sin(angle) * 13,
        ),
        7,
        dustPaint,
      );
    }

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

class _TunnelObject {
  Offset position;
  final double speed;
  final double radius;

  _TunnelObject({
    required this.position,
    required this.speed,
    required this.radius,
  });
}
