import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show linea, relleno;
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Pinceles comunes para pintar fondos animados de los mundos de ciencia.
/// [u] es una unidad relativa (1 % del lado corto) y [t] el tiempo en segundos.

void gradiente(Canvas c, Size s, List<Color> cols) => c.drawRect(
    Offset.zero & s, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: cols).createShader(Offset.zero & s));

void repisa(Canvas c, Size s, double u, double y, List<String> cosas, {Color color = const Color(0x66311B92)}) {
  c.drawRect(Rect.fromLTWH(0, s.height * y, s.width, 1.6 * u), relleno(color));
  for (var k = 0; k < cosas.length; k++) {
    dibujarEmoji(c, cosas[k], Offset(s.width * (0.1 + k * 0.2), s.height * y - 4 * u), 7 * u);
  }
}

void burbujas(Canvas c, Size s, double u, double t, Color col) {
  for (var k = 0; k < 14; k++) {
    final f = (t * 0.07 + k / 14) % 1;
    final x = s.width * ((k * 0.37) % 1) + math.sin(t * 1.5 + k) * 2 * u;
    c.drawCircle(Offset(x, s.height * (1 - f)), (1 + k % 3) * u, linea(col, 0.4 * u));
  }
}

void vapor(Canvas c, double u, double t, double x, double y) {
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.4 + k / 3) % 1;
    c.drawCircle(Offset(x + math.sin(t * 2 + k) * 2 * u, y - f * 18 * u), (2 + f * 4) * u, relleno(Color.fromARGB((90 * (1 - f)).round(), 255, 255, 255)));
  }
}

/// Emojis semitransparentes que flotan suavemente.
void flotan(Canvas c, Size s, double u, double t, List<String> cosas, double alfa) {
  c.saveLayer(null, Paint()..color = Color.fromRGBO(255, 255, 255, 0.2 + alfa * 4));
  for (var k = 0; k < cosas.length; k++) {
    final p = Offset(s.width * (0.05 + (k * 0.23) % 0.9), s.height * (0.15 + (k * 0.31) % 0.5) + math.sin(t + k) * 2 * u);
    dibujarEmoji(c, cosas[k], p, 7 * u);
  }
  c.restore();
}

void montes(Canvas c, Size s, double u, Color col, double base, double alt) {
  final p = Path()..moveTo(0, s.height);
  for (var x = 0.0; x <= s.width; x += 4 * u) {
    p.lineTo(x, s.height * base - (math.sin(x / s.width * 6 + base * 9) * 0.5 + 0.5) * alt * s.height);
  }
  p.lineTo(s.width, s.height);
  p.close();
  c.drawPath(p, relleno(col));
}

void molino(Canvas c, double t, Offset base, double u, {double fase = 0}) {
  c.drawLine(base, base - Offset(0, 22 * u), linea(Colors.white, 1.2 * u));
  final cen = base - Offset(0, 22 * u);
  for (var k = 0; k < 3; k++) {
    final a = t * 1.5 + fase + k * 2 * math.pi / 3;
    c.drawLine(cen, cen + Offset(math.cos(a), math.sin(a)) * 10 * u, linea(Colors.white, 1 * u)..strokeCap = StrokeCap.round);
  }
  c.drawCircle(cen, 1 * u, relleno(const Color(0xFFB0BEC5)));
}

/// Estrellas que titilan.
void estrellas(Canvas c, Size s, double u, double t, {int n = 90, double alto = 1}) {
  for (var k = 0; k < n; k++) {
    c.drawCircle(Offset((k * 211 % 1000) / 1000 * s.width, (k * 97 % 1000) / 1000 * s.height * alto), (k % 3 + 1) * 0.15 * u,
        relleno(Colors.white.withValues(alpha: 0.3 + 0.5 * (math.sin(t * 2 + k) * 0.5 + 0.5))));
  }
}

/// Engrane con [dientes] que gira con el tiempo.
void engrane(Canvas c, Offset cen, double r, double ang, Color col, {int dientes = 10}) {
  final p = Path();
  for (var k = 0; k < dientes * 2; k++) {
    final a = ang + k * math.pi / dientes;
    final rr = k.isEven ? r : r * 0.8;
    final a2 = a + math.pi / dientes;
    final p1 = cen + Offset(math.cos(a), math.sin(a)) * rr;
    final p2 = cen + Offset(math.cos(a2), math.sin(a2)) * rr;
    if (k == 0) p.moveTo(p1.dx, p1.dy);
    p.lineTo(p1.dx, p1.dy);
    p.lineTo(p2.dx, p2.dy);
  }
  p.close();
  c.drawPath(p, relleno(col));
  c.drawCircle(cen, r * 0.3, relleno(Color.lerp(col, Colors.black, 0.35)!));
}

/// Estilo del letrero a partir de dos colores y un borde.
(List<Color>, Color, Color) letreroDe(Color a, Color b, Color borde) => ([a, b], borde, Color.lerp(borde, Colors.black, 0.4)!);
