import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show textoEn, linea, relleno;
import '../biology/tema1/ui_divertida.dart' show aclarar, oscurecer;
import '../biology/temas/ilustraciones.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import 'circuito.dart';
import 'dibujos.dart';

/// Ilustraciones de Electrónica para las pantallas de explicación.
/// Todas se dibujan sobre una "mesa de trabajo" cuadriculada como la de Tinkercad.

Offset _p(Rect r, double x, double y) => Offset(r.left + x * r.width, r.top + y * r.height);
double _s(Rect r) => r.width / 256;

void _mesa(Canvas c, Rect r) {
  final rr = RRect.fromRectAndRadius(r, const Radius.circular(20));
  c.drawRRect(rr.shift(const Offset(0, 5)), relleno(const Color(0x44000000)));
  c.drawRRect(rr, relleno(const Color(0xFFF7FBFF)));
  c.save();
  c.clipRRect(rr);
  final g = linea(const Color(0xFFDCE8F5), 1);
  for (var x = r.left; x < r.right; x += 16) {
    c.drawLine(Offset(x, r.top), Offset(x, r.bottom), g);
  }
  for (var y = r.top; y < r.bottom; y += 16) {
    c.drawLine(Offset(r.left, y), Offset(r.right, y), g);
  }
  c.restore();
  c.drawRRect(rr, linea(const Color(0xFF90A4AE), 3));
}

void _resalte(Canvas c, Offset p, double radio, bool on, double t) {
  if (!on) return;
  c.drawCircle(p, radio + 3 * math.sin(t * 5), linea(const Color(0xFFFFA000), 3));
}

void _flecha(Canvas c, Offset a, Offset b, Color col, {double ancho = 4}) {
  c.drawLine(a, b, linea(col, ancho)..strokeCap = StrokeCap.round);
  final d = b - a;
  final u = d / d.distance, n = Offset(-u.dy, u.dx);
  final path = Path()
    ..moveTo(b.dx, b.dy)
    ..lineTo((b - u * 12 + n * 7).dx, (b - u * 12 + n * 7).dy)
    ..lineTo((b - u * 12 - n * 7).dx, (b - u * 12 - n * 7).dy)
    ..close();
  c.drawPath(path, relleno(col));
}

// ---------------------------------------------------------------------------
// Tema 1: componentes
// ---------------------------------------------------------------------------

void _componentes(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  void pieza(String id, TipoPieza tipo, double x, double y, {double brillo = 0, double giro = 0, bool suena = false, double luz = 0, double esc = 1.1}) {
    final p = _p(r, x, y);
    _resalte(c, p, 44 * s, sel == id, t);
    dibujarPiezaEn(c, tipo, p, esc * s, brillo: brillo, giro: giro, suena: suena, luzFoco: luz, t: t, cerrado: true);
  }

  pieza('pila', TipoPieza.pila9v, 0.27, 0.2);
  pieza('led', TipoPieza.led, 0.73, 0.16, brillo: 0.6 + 0.4 * math.sin(t * 2).abs());
  pieza('resistencia', TipoPieza.resistencia, 0.73, 0.4);
  pieza('interruptor', TipoPieza.interruptor, 0.27, 0.46);
  pieza('zumbador', TipoPieza.zumbador, 0.27, 0.7, suena: true);
  pieza('motor', TipoPieza.motor, 0.73, 0.66, giro: t * 6);
  pieza('foco', TipoPieza.foco, 0.5, 0.9, luz: 0.7, esc: 0.9);
}

const ilComponentes = Ilustracion(_componentes, {
  'pila': Offset(0.27, 0.2),
  'led': Offset(0.73, 0.14),
  'resistencia': Offset(0.73, 0.4),
  'interruptor': Offset(0.27, 0.46),
  'zumbador': Offset(0.27, 0.69),
  'motor': Offset(0.73, 0.64),
  'foco': Offset(0.5, 0.88),
});

void _ledGrande(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  final centro = _p(r, 0.5, 0.28);
  dibujarPiezaEn(c, TipoPieza.led, centro, 3.0 * s, brillo: 0.5 + 0.5 * math.sin(t * 1.5).abs(), t: t);
  textoEn(c, '+', _p(r, 0.7, 0.62), tam: 20 * s, color: const Color(0xFFD32F2F));
  textoEn(c, '−', _p(r, 0.28, 0.62), tam: 20 * s, color: const Color(0xFF212121));
  // Resistencia grande
  final rc = _p(r, 0.5, 0.84);
  dibujarPiezaEn(c, TipoPieza.resistencia, rc, 2.6 * s, ohms: 220);
  textoEn(c, '220 Ω', _p(r, 0.5, 0.75), tam: 13 * s, color: const Color(0xFF5D4037));
  for (final (id, x, y, rad) in const [
    ('domo', 0.5, 0.17, 40.0),
    ('anodo', 0.6, 0.55, 22.0),
    ('catodo', 0.4, 0.55, 22.0),
    ('bandas', 0.46, 0.84, 30.0),
  ]) {
    _resalte(c, _p(r, x, y), rad * s, sel == id, t);
  }
}

const ilLedResistencia = Ilustracion(_ledGrande, {
  'domo': Offset(0.5, 0.17),
  'anodo': Offset(0.6, 0.55),
  'catodo': Offset(0.4, 0.55),
  'bandas': Offset(0.44, 0.84),
  'resistencia': Offset(0.75, 0.84),
});

void _energiaControl(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  dibujarPiezaEn(c, TipoPieza.pila9v, _p(r, 0.28, 0.2), 1.4 * s);
  dibujarPiezaEn(c, TipoPieza.pila3v, _p(r, 0.72, 0.2), 1.2 * s);
  final cerrado = (t * 0.5) % 2 < 1;
  dibujarPiezaEn(c, TipoPieza.interruptor, _p(r, 0.28, 0.56), 1.4 * s, cerrado: cerrado);
  dibujarPiezaEn(c, TipoPieza.boton, _p(r, 0.72, 0.56), 1.5 * s);
  dibujarPiezaEn(c, TipoPieza.potenciometro, _p(r, 0.5, 0.84), 1.4 * s);
  for (final (id, x, y) in const [('pila9v', 0.28, 0.2), ('pila3v', 0.72, 0.2), ('interruptor', 0.28, 0.56), ('boton', 0.72, 0.56), ('potenciometro', 0.5, 0.84)]) {
    _resalte(c, _p(r, x, y), 48 * s, sel == id, t);
  }
}

const ilEnergiaControl = Ilustracion(_energiaControl, {
  'pila9v': Offset(0.28, 0.2),
  'pila3v': Offset(0.72, 0.18),
  'interruptor': Offset(0.28, 0.56),
  'boton': Offset(0.72, 0.56),
  'potenciometro': Offset(0.5, 0.84),
});

// ---------------------------------------------------------------------------
// Tema 2: circuitos
// ---------------------------------------------------------------------------

/// Circuito cerrado: pila → interruptor → resistencia → LED → pila.
void _circuitoSimple(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  final pila = _p(r, 0.24, 0.62), sw = _p(r, 0.5, 0.18), res = _p(r, 0.78, 0.45), led = _p(r, 0.62, 0.8);
  final camino = [
    pila + Offset(-12 * s * 1.2, -40 * s * 1.2),
    Offset(pila.dx - 14 * s, sw.dy),
    sw + Offset(-34 * s * 1.2, 0),
    sw + Offset(34 * s * 1.2, 0),
    Offset(res.dx, sw.dy),
    res + Offset(0, -36 * s * 1.2),
    res + Offset(0, 36 * s * 1.2),
    Offset(res.dx, led.dy + 50 * s),
    led + Offset(9 * s * 1.3, 30 * s * 1.3),
    led + Offset(-9 * s * 1.3, 30 * s * 1.3),
    Offset(pila.dx + 14 * s, led.dy + 50 * s),
    pila + Offset(12 * s * 1.2, -40 * s * 1.2),
  ];
  final cable = linea(const Color(0xFF2E7D32), 4 * s)..strokeJoin = StrokeJoin.round;
  for (var i = 0; i < camino.length - 1; i++) {
    if (i == 2 || i == 5 || i == 8) continue; // dentro de componentes
    c.drawLine(camino[i], camino[i + 1], i == 0 ? (linea(const Color(0xFFD32F2F), 4 * s)) : (i == 10 ? linea(const Color(0xFF212121), 4 * s) : cable));
  }
  dibujarPiezaEn(c, TipoPieza.pila9v, pila, 1.2 * s);
  dibujarPiezaEn(c, TipoPieza.interruptor, sw, 1.2 * s, cerrado: true);
  c.save();
  c.translate(res.dx, res.dy);
  c.rotate(math.pi / 2);
  dibujarPiezaEn(c, TipoPieza.resistencia, Offset.zero, 1.2 * s);
  c.restore();
  dibujarPiezaEn(c, TipoPieza.led, led, 1.3 * s, brillo: 0.9, t: t);
  // Electrones/corriente
  final tramos = <(Offset, Offset)>[];
  for (var i = 0; i < camino.length - 1; i++) {
    tramos.add((camino[i], camino[i + 1]));
  }
  final total = tramos.fold(0.0, (a, x) => a + (x.$2 - x.$1).distance);
  for (var k = 0; k < 14; k++) {
    var d = ((t * 0.18 + k / 14) % 1) * total;
    for (final (a, b) in tramos) {
      final l = (b - a).distance;
      if (d <= l) {
        c.drawCircle(Offset.lerp(a, b, d / l)!, 3.5 * s, relleno(const Color(0xFFFFEB3B)));
        c.drawCircle(Offset.lerp(a, b, d / l)!, 3.5 * s, linea(const Color(0xFFF57F17), 1));
        break;
      }
      d -= l;
    }
  }
  for (final (id, p) in [('pila', pila), ('interruptor', sw), ('resistencia', res), ('led', led), ('cable', Offset(pila.dx - 14 * s, r.top + r.height * 0.4))]) {
    _resalte(c, p, 40 * s, sel == id, t);
  }
}

const ilCircuitoSimple = Ilustracion(_circuitoSimple, {
  'pila': Offset(0.24, 0.62),
  'cable': Offset(0.19, 0.38),
  'interruptor': Offset(0.5, 0.18),
  'resistencia': Offset(0.78, 0.45),
  'led': Offset(0.62, 0.78),
});

void _seriePar(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  void lazo(Rect q, bool paralelo, String id) {
    _resalte(c, q.center, q.width * 0.55, sel == id, t);
    final cable = linea(const Color(0xFF2E7D32), 3.5 * s)..style = PaintingStyle.stroke;
    c.drawRRect(RRect.fromRectAndRadius(q, Radius.circular(10 * s)), cable);
    // Pila a la izquierda
    c.drawRect(Rect.fromCenter(center: Offset(q.left, q.center.dy), width: 18 * s, height: 34 * s), relleno(const Color(0xFF263238)));
    c.drawRect(Rect.fromCenter(center: Offset(q.left, q.center.dy - 8 * s), width: 18 * s, height: 10 * s), relleno(const Color(0xFFFF8F00)));
    textoEn(c, '+', Offset(q.left, q.center.dy - 24 * s), tam: 11 * s, color: const Color(0xFFD32F2F));
    if (!paralelo) {
      for (final fx in [0.45, 0.8]) {
        dibujarPiezaEn(c, TipoPieza.led, Offset(q.left + q.width * fx, q.top + 2 * s), 0.8 * s, brillo: 0.55, color: ColorLed.verde, t: t);
      }
    } else {
      c.drawLine(Offset(q.left + q.width * 0.45, q.top), Offset(q.left + q.width * 0.45, q.bottom), cable);
      c.drawLine(Offset(q.left + q.width * 0.78, q.top), Offset(q.left + q.width * 0.78, q.bottom), cable);
      for (final fx in [0.45, 0.78]) {
        dibujarPiezaEn(c, TipoPieza.led, Offset(q.left + q.width * fx, q.center.dy - 6 * s), 0.8 * s, brillo: 1, color: ColorLed.azul, t: t);
      }
    }
  }

  lazo(Rect.fromLTWH(r.left + r.width * 0.16, r.top + r.height * 0.14, r.width * 0.72, r.height * 0.26), false, 'serie');
  lazo(Rect.fromLTWH(r.left + r.width * 0.16, r.top + r.height * 0.6, r.width * 0.72, r.height * 0.28), true, 'paralelo');
  textoEn(c, 'SERIE: un solo camino', _p(r, 0.52, 0.46), tam: 12 * s, color: const Color(0xFF2E7D32));
  textoEn(c, 'PARALELO: varios caminos', _p(r, 0.52, 0.95), tam: 12 * s, color: const Color(0xFF1565C0));
}

const ilSerieParalelo = Ilustracion(_seriePar, {
  'serie': Offset(0.52, 0.27),
  'paralelo': Offset(0.52, 0.74),
});

void _conductores(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  c.drawRect(Rect.fromLTWH(r.left + 8, r.top + 8, r.width - 16, r.height * 0.46), relleno(const Color(0x1A43A047)));
  c.drawRect(Rect.fromLTWH(r.left + 8, r.top + r.height * 0.52, r.width - 16, r.height * 0.46), relleno(const Color(0x1AE53935)));
  textoEn(c, 'Conductores ⚡', _p(r, 0.5, 0.06), tam: 14 * s, color: const Color(0xFF2E7D32));
  textoEn(c, 'Aislantes 🚫', _p(r, 0.5, 0.57), tam: 14 * s, color: const Color(0xFFC62828));
  // Cable de cobre
  final a = _p(r, 0.15, 0.2), b = _p(r, 0.85, 0.2);
  c.drawLine(a, b, linea(const Color(0xFFB87333), 7 * s)..strokeCap = StrokeCap.round);
  for (var k = 0; k < 6; k++) {
    final u = (t * 0.4 + k / 6) % 1;
    c.drawCircle(Offset.lerp(a, b, u)!, 3 * s, relleno(const Color(0xFFFFEB3B)));
  }
  for (final (id, e, x, y) in const [
    ('cobre', '🔌', 0.5, 0.29),
    ('metal', '📎', 0.28, 0.42),
    ('agua', '💧', 0.72, 0.42),
    ('plastico', '🧴', 0.25, 0.73),
    ('madera', '🪵', 0.5, 0.86),
    ('goma', '🧤', 0.75, 0.73),
  ]) {
    _resalte(c, _p(r, x, y), 26 * s, sel == id, t);
    dibujarEmoji(c, e, _p(r, x, y), 34 * s);
  }
}

const ilConductores = Ilustracion(_conductores, {
  'cobre': Offset(0.5, 0.25),
  'metal': Offset(0.28, 0.42),
  'agua': Offset(0.72, 0.42),
  'plastico': Offset(0.25, 0.73),
  'madera': Offset(0.5, 0.86),
  'goma': Offset(0.75, 0.73),
});

// ---------------------------------------------------------------------------
// Tema 3: sensores
// ---------------------------------------------------------------------------

void dibujarSensor(Canvas c, String tipo, Offset p, double s, {double t = 0, bool activo = false}) {
  c.save();
  c.translate(p.dx, p.dy);
  c.scale(s);
  void patas(int n) {
    for (var k = 0; k < n; k++) {
      final x = (k - (n - 1) / 2) * 9.0;
      c.drawLine(Offset(x, 14), Offset(x, 34), linea(colorPata, 3));
    }
  }

  switch (tipo) {
    case 'luz':
      dibujarPieza(c, Pieza('_', TipoPieza.ldr, Offset.zero), luz: activo ? 1 : 0.3);
    case 'temperatura':
      patas(3);
      final path = Path()
        ..moveTo(-13, 14)
        ..lineTo(-13, -6)
        ..arcToPoint(const Offset(13, -6), radius: const Radius.circular(13))
        ..lineTo(13, 14)
        ..close();
      c.drawPath(path, relleno(const Color(0xFF212121)));
      textoEn(c, 'TMP', const Offset(0, 3), tam: 7, color: Colors.white);
    case 'movimiento':
      patas(3);
      c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-24, -4, 48, 18), const Radius.circular(3)), relleno(const Color(0xFF2E7D32)));
      c.drawArc(const Rect.fromLTWH(-18, -24, 36, 40), math.pi, math.pi, true, relleno(const Color(0xFFF5F5F5)));
      c.drawArc(const Rect.fromLTWH(-18, -24, 36, 40), math.pi, math.pi, true, linea(const Color(0xFFBDBDBD), 1.2));
      for (var k = 0; k < 3; k++) {
        c.drawLine(Offset(-12 + k * 12.0, -18), Offset(-12 + k * 12.0, -6), linea(const Color(0xFFE0E0E0), 1));
      }
      if (activo) c.drawCircle(const Offset(18, 6), 3, relleno(const Color(0xFFFF1744)));
    case 'distancia':
      patas(4);
      c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-34, -12, 68, 26), const Radius.circular(3)), relleno(const Color(0xFF1565C0)));
      for (final x in [-17.0, 17.0]) {
        c.drawCircle(Offset(x, 1), 12, relleno(const Color(0xFFCFD8DC)));
        c.drawCircle(Offset(x, 1), 12, linea(const Color(0xFF78909C), 1.5));
        c.drawCircle(Offset(x, 1), 6, relleno(const Color(0xFF37474F)));
      }
      if (activo) {
        for (var k = 0; k < 3; k++) {
          final f = (t * 1.2 + k / 3) % 1;
          c.drawArc(Rect.fromCircle(center: const Offset(0, -10), radius: 14 + f * 30), -math.pi * 0.8, math.pi * 0.6, false, linea(const Color(0xFF29B6F6).withValues(alpha: 1 - f), 2));
        }
      }
    case 'tacto':
      dibujarPieza(c, Pieza('_', TipoPieza.boton, Offset.zero)..presionado = activo);
  }
  c.restore();
}

void _sensores(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  for (final (id, x, y, esc) in const [
    ('luz', 0.27, 0.16, 1.7),
    ('temperatura', 0.73, 0.16, 1.6),
    ('movimiento', 0.27, 0.5, 1.5),
    ('distancia', 0.73, 0.5, 1.15),
    ('tacto', 0.5, 0.83, 1.4),
  ]) {
    _resalte(c, _p(r, x, y), 42 * s, sel == id, t);
    dibujarSensor(c, id, _p(r, x, y), esc * s, t: t, activo: true);
  }
}

const ilSensores = Ilustracion(_sensores, {
  'luz': Offset(0.27, 0.16),
  'temperatura': Offset(0.73, 0.16),
  'movimiento': Offset(0.27, 0.5),
  'distancia': Offset(0.73, 0.5),
  'tacto': Offset(0.5, 0.83),
});

/// Entrada → controlador → salida.
void _entradaSalida(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  final a = _p(r, 0.5, 0.14), b = _p(r, 0.5, 0.5), d = _p(r, 0.5, 0.86);
  _flecha(c, a + Offset(0, 34 * s), b - Offset(0, 48 * s), const Color(0xFF8E24AA));
  _flecha(c, b + Offset(0, 48 * s), d - Offset(0, 36 * s), const Color(0xFF1E88E5));
  dibujarSensor(c, 'movimiento', a, 1.4 * s, activo: true, t: t);
  dibujarArduino(c, b, 0.95 * s, t: t);
  dibujarPiezaEn(c, TipoPieza.zumbador, d, 1.3 * s, suena: true, t: t);
  // Señal viajando
  final u = (t * 0.5) % 1;
  final q = u < 0.5 ? Offset.lerp(a + Offset(0, 34 * s), b - Offset(0, 48 * s), u * 2)! : Offset.lerp(b + Offset(0, 48 * s), d - Offset(0, 36 * s), (u - 0.5) * 2)!;
  c.drawCircle(q, 6 * s, relleno(const Color(0xFFFFEB3B)));
  textoEn(c, 'ENTRADA', _p(r, 0.17, 0.14), tam: 11 * s, color: const Color(0xFF8E24AA));
  textoEn(c, 'PROCESO', _p(r, 0.15, 0.5), tam: 11 * s, color: const Color(0xFFEF6C00));
  textoEn(c, 'SALIDA', _p(r, 0.17, 0.86), tam: 11 * s, color: const Color(0xFF1E88E5));
  for (final (id, p) in [('sensor', a), ('controlador', b), ('actuador', d), ('senal', _p(r, 0.5, 0.32))]) {
    _resalte(c, p, (id == 'controlador' ? 58 : 36) * s, sel == id, t);
  }
}

const ilEntradaSalida = Ilustracion(_entradaSalida, {
  'sensor': Offset(0.5, 0.14),
  'senal': Offset(0.5, 0.32),
  'controlador': Offset(0.5, 0.5),
  'actuador': Offset(0.5, 0.86),
});

void dibujarArduino(Canvas c, Offset p, double s, {double t = 0}) {
  c.save();
  c.translate(p.dx, p.dy);
  c.scale(s);
  final r = const Rect.fromLTWH(-62, -42, 124, 84);
  c.drawRRect(RRect.fromRectAndRadius(r.shift(const Offset(0, 3)), const Radius.circular(8)), relleno(const Color(0x33000000)));
  c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), relleno(const Color(0xFF00838F)));
  c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), linea(const Color(0xFF004D40), 2));
  for (var k = 0; k < 14; k++) {
    c.drawRect(Rect.fromLTWH(-50 + k * 7.5, -40, 5, 7), relleno(const Color(0xFF212121)));
  }
  for (var k = 0; k < 10; k++) {
    c.drawRect(Rect.fromLTWH(-40 + k * 7.5, 33, 5, 7), relleno(const Color(0xFF212121)));
  }
  c.drawRect(const Rect.fromLTWH(-74, -22, 24, 18), relleno(const Color(0xFFB0BEC5)));
  c.drawRect(const Rect.fromLTWH(-70, 10, 18, 16), relleno(const Color(0xFF212121)));
  c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-10, -10, 46, 22), const Radius.circular(2)), relleno(const Color(0xFF263238)));
  textoEn(c, 'UNO', const Offset(-26, 0), tam: 13, color: Colors.white);
  c.drawCircle(const Offset(48, -24), 3, relleno((t * 2) % 1 < 0.5 ? const Color(0xFFFFEB3B) : const Color(0xFF795548)));
  c.restore();
}

// ---------------------------------------------------------------------------
// Tema 4: motores y mecanismos
// ---------------------------------------------------------------------------

void dibujarEngrane(Canvas c, Offset centro, double radio, int dientes, double angulo, Color color) {
  final path = Path();
  final n = dientes * 2;
  for (var i = 0; i <= n * 2; i++) {
    final a = angulo + i / (n * 2) * 2 * math.pi;
    final fuera = (i ~/ 2).isEven;
    final rr = fuera ? radio : radio * 0.84;
    final q = centro + Offset(math.cos(a), math.sin(a)) * rr;
    i == 0 ? path.moveTo(q.dx, q.dy) : path.lineTo(q.dx, q.dy);
  }
  path.close();
  c.drawPath(path.shift(const Offset(0, 3)), relleno(const Color(0x33000000)));
  c.drawPath(path, Paint()..shader = RadialGradient(colors: [aclarar(color, 0.35), color]).createShader(Rect.fromCircle(center: centro, radius: radio)));
  c.drawPath(path, linea(oscurecer(color, 0.4), 1.6));
  c.drawCircle(centro, radio * 0.55, linea(oscurecer(color, 0.25), 2));
  for (var k = 0; k < 4; k++) {
    final a = angulo + k * math.pi / 2;
    c.drawLine(centro, centro + Offset(math.cos(a), math.sin(a)) * radio * 0.55, linea(oscurecer(color, 0.25), 3));
  }
  c.drawCircle(centro, radio * 0.16, relleno(const Color(0xFF455A64)));
}

void _motorPartes(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  final cen = _p(r, 0.5, 0.42);
  // Carcasa
  final carc = Rect.fromCenter(center: cen, width: 200 * s, height: 170 * s);
  c.drawRRect(RRect.fromRectAndRadius(carc, Radius.circular(24 * s)), relleno(const Color(0xFFCFD8DC)));
  c.drawRRect(RRect.fromRectAndRadius(carc, Radius.circular(24 * s)), linea(const Color(0xFF78909C), 3));
  // Imanes
  c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(carc.left + 8 * s, carc.top + 20 * s, 36 * s, carc.height - 40 * s), Radius.circular(8 * s)), relleno(const Color(0xFFE53935)));
  c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(carc.right - 44 * s, carc.top + 20 * s, 36 * s, carc.height - 40 * s), Radius.circular(8 * s)), relleno(const Color(0xFF1E88E5)));
  textoEn(c, 'N', Offset(carc.left + 26 * s, cen.dy), tam: 20 * s, color: Colors.white);
  textoEn(c, 'S', Offset(carc.right - 26 * s, cen.dy), tam: 20 * s, color: Colors.white);
  // Bobina girando
  final a = t * 3;
  c.save();
  c.translate(cen.dx, cen.dy);
  c.rotate(a);
  c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: 92 * s, height: 30 * s), Radius.circular(10 * s)), relleno(const Color(0xFFB87333)));
  for (var k = -4; k <= 4; k++) {
    c.drawLine(Offset(k * 9.0 * s, -15 * s), Offset(k * 9.0 * s, 15 * s), linea(const Color(0xFF8D5524), 2 * s));
  }
  c.restore();
  c.drawCircle(cen, 9 * s, relleno(const Color(0xFF455A64)));
  // Eje y escobillas
  final eje = _p(r, 0.5, 0.84);
  c.drawRect(Rect.fromCenter(center: Offset(cen.dx, (cen.dy + eje.dy) / 2 + 30 * s), width: 10 * s, height: 70 * s), relleno(const Color(0xFF607D8B)));
  dibujarEngrane(c, eje, 30 * s, 10, a, const Color(0xFFFFB300));
  for (final x in [-34.0, 34.0]) {
    c.drawRect(Rect.fromCenter(center: Offset(cen.dx + x * s, carc.bottom + 6 * s), width: 10 * s, height: 22 * s), relleno(const Color(0xFF424242)));
  }
  c.drawLine(Offset(cen.dx - 34 * s, carc.bottom + 16 * s), Offset(r.left + 30 * s, r.bottom - 20 * s), linea(const Color(0xFFD32F2F), 4 * s));
  c.drawLine(Offset(cen.dx + 34 * s, carc.bottom + 16 * s), Offset(r.right - 30 * s, r.bottom - 20 * s), linea(const Color(0xFF212121), 4 * s));
  for (final (id, p, rad) in [
    ('iman', Offset(carc.left + 26 * s, cen.dy), 30.0),
    ('bobina', cen + Offset(0, -24 * s), 40.0),
    ('eje', eje, 36.0),
    ('escobillas', Offset(cen.dx + 34 * s, carc.bottom + 6 * s), 22.0),
  ]) {
    _resalte(c, p, rad * s, sel == id, t);
  }
}

const ilMotorPartes = Ilustracion(_motorPartes, {
  'iman': Offset(0.2, 0.42),
  'bobina': Offset(0.5, 0.36),
  'escobillas': Offset(0.63, 0.66),
  'eje': Offset(0.5, 0.84),
});

void _mecanismos(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  // Engranes
  final g1 = _p(r, 0.33, 0.17), g2 = g1 + Offset(64 * s, 0);
  dibujarEngrane(c, g1, 36 * s, 12, t * 1.5, const Color(0xFFFFB300));
  dibujarEngrane(c, g2, 30 * s, 10, -t * 1.5 * 12 / 10 + 0.15, const Color(0xFF26A69A));
  // Poleas con banda
  final p1 = _p(r, 0.3, 0.44), p2 = _p(r, 0.72, 0.44);
  c.drawLine(p1 + Offset(0, -26 * s), p2 + Offset(0, -16 * s), linea(const Color(0xFF424242), 4 * s));
  c.drawLine(p1 + Offset(0, 26 * s), p2 + Offset(0, 16 * s), linea(const Color(0xFF424242), 4 * s));
  for (final (p, rr, v) in [(p1, 26.0, 1.0), (p2, 16.0, 1.6)]) {
    c.drawCircle(p, rr * s, relleno(const Color(0xFF90A4AE)));
    c.drawCircle(p, rr * s, linea(const Color(0xFF455A64), 2));
    final a = t * 2 * v;
    c.drawLine(p, p + Offset(math.cos(a), math.sin(a)) * rr * s, linea(const Color(0xFF263238), 3));
  }
  // Rueda y eje (carrito)
  final car = _p(r, 0.5, 0.68);
  c.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: car, width: 110 * s, height: 30 * s), Radius.circular(8 * s)), relleno(const Color(0xFFEF5350)));
  for (final dx in [-34.0, 34.0]) {
    final w = car + Offset(dx * s, 18 * s);
    c.drawCircle(w, 14 * s, relleno(const Color(0xFF263238)));
    final a = t * 3;
    c.drawLine(w, w + Offset(math.cos(a), math.sin(a)) * 12 * s, linea(const Color(0xFFB0BEC5), 2.5));
  }
  // Biela-manivela
  final m = _p(r, 0.32, 0.9);
  final a = t * 2.5;
  final punta = m + Offset(math.cos(a), math.sin(a)) * 18 * s;
  final piston = Offset(m.dx + 60 * s + math.cos(a) * 18 * s, m.dy);
  c.drawCircle(m, 22 * s, relleno(const Color(0xFFB0BEC5)));
  c.drawLine(punta, piston, linea(const Color(0xFF6D4C41), 5 * s)..strokeCap = StrokeCap.round);
  c.drawRect(Rect.fromCenter(center: piston + Offset(14 * s, 0), width: 30 * s, height: 20 * s), relleno(const Color(0xFF7E57C2)));
  for (final (id, p, rad) in [('engranes', Offset((g1.dx + g2.dx) / 2, g1.dy), 60.0), ('poleas', Offset((p1.dx + p2.dx) / 2, p1.dy), 64.0), ('rueda', car, 60.0), ('biela', Offset(m.dx + 34 * s, m.dy), 54.0)]) {
    _resalte(c, p, rad * s, sel == id, t);
  }
}

const ilMecanismos = Ilustracion(_mecanismos, {
  'engranes': Offset(0.45, 0.17),
  'poleas': Offset(0.51, 0.44),
  'rueda': Offset(0.5, 0.7),
  'biela': Offset(0.45, 0.9),
});

// ---------------------------------------------------------------------------
// Tema 5: sistemas automatizados
// ---------------------------------------------------------------------------

void _casaInteligente(Canvas c, Rect r, double t, String? sel) {
  _mesa(c, r);
  final s = _s(r);
  // Casa
  final casa = Rect.fromLTWH(r.left + 28 * s, r.top + 110 * s, 200 * s, 210 * s);
  final techo = Path()
    ..moveTo(casa.left - 14 * s, casa.top)
    ..lineTo(casa.center.dx, casa.top - 80 * s)
    ..lineTo(casa.right + 14 * s, casa.top)
    ..close();
  c.drawPath(techo, relleno(const Color(0xFFE57373)));
  c.drawRect(casa, relleno(const Color(0xFFFFF3E0)));
  c.drawRect(casa, linea(const Color(0xFFBCAAA4), 2));
  final noche = (t * 0.25) % 2 > 1;
  // Ventana con foco automático
  final ven = Rect.fromLTWH(casa.left + 20 * s, casa.top + 24 * s, 64 * s, 54 * s);
  c.drawRect(ven, relleno(noche ? const Color(0xFFFFF59D) : const Color(0xFFB3E5FC)));
  c.drawRect(ven, linea(const Color(0xFF8D6E63), 3));
  dibujarEmoji(c, noche ? '🌙' : '☀️', _p(r, 0.85, 0.1), 30 * s);
  // Ventilador
  final ven2 = Offset(casa.right - 52 * s, casa.top + 50 * s);
  for (var k = 0; k < 3; k++) {
    final a = t * 8 + k * 2 * math.pi / 3;
    c.drawOval(Rect.fromCenter(center: ven2 + Offset(math.cos(a), math.sin(a)) * 13 * s, width: 22 * s, height: 10 * s), relleno(const Color(0xFF29B6F6)));
  }
  c.drawCircle(ven2, 5 * s, relleno(const Color(0xFF37474F)));
  // Puerta automática
  final puerta = Rect.fromLTWH(casa.center.dx - 26 * s, casa.bottom - 90 * s, 52 * s, 90 * s);
  final abre = (math.sin(t * 1.2) * 0.5 + 0.5);
  c.drawRect(puerta, relleno(const Color(0xFF6D4C41)));
  c.drawRect(Rect.fromLTWH(puerta.left, puerta.top, puerta.width * (1 - abre * 0.8), puerta.height), relleno(const Color(0xFFA1887F)));
  dibujarSensor(c, 'movimiento', Offset(puerta.center.dx, puerta.top - 14 * s), 0.6 * s, activo: abre > 0.5);
  // Planta con riego
  final planta = Offset(casa.left + 40 * s, casa.bottom - 30 * s);
  dibujarEmoji(c, '🪴', planta, 40 * s);
  for (var k = 0; k < 3; k++) {
    final f = (t * 1.3 + k / 3) % 1;
    c.drawCircle(planta + Offset(-6 * s + k * 6 * s, -40 * s + f * 26 * s), 2.5 * s, relleno(const Color(0xFF29B6F6)));
  }
  for (final (id, p, rad) in [('foco', ven.center, 40.0), ('ventilador', ven2, 28.0), ('puerta', puerta.center, 52.0), ('riego', planta, 30.0)]) {
    _resalte(c, p, rad * s, sel == id, t);
  }
}

const ilCasaInteligente = Ilustracion(_casaInteligente, {
  'foco': Offset(0.32, 0.37),
  'ventilador': Offset(0.71, 0.43),
  'puerta': Offset(0.55, 0.78),
  'riego': Offset(0.31, 0.86),
});
