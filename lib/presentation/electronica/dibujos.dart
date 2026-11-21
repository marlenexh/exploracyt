import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show textoEn, linea, relleno;
import '../biology/tema1/ui_divertida.dart' show aclarar, oscurecer;
import 'circuito.dart';

/// Dibujos de los componentes, con el aspecto de Tinkercad Circuits.

const colorPata = Color(0xFF9E9E9E);

const _coloresBanda = [
  Color(0xFF212121), // negro 0
  Color(0xFF795548), // marrón 1
  Color(0xFFE53935), // rojo 2
  Color(0xFFFF8F00), // naranja 3
  Color(0xFFFDD835), // amarillo 4
  Color(0xFF43A047), // verde 5
  Color(0xFF1E88E5), // azul 6
  Color(0xFF8E24AA), // violeta 7
  Color(0xFF9E9E9E), // gris 8
  Color(0xFFFAFAFA), // blanco 9
];
const nombresColorBanda = ['negro', 'marrón', 'rojo', 'naranja', 'amarillo', 'verde', 'azul', 'violeta', 'gris', 'blanco'];
const colorOro = Color(0xFFD4AF37);

Color colorBanda(int i) => _coloresBanda[i];

/// Las 3 franjas (dígito, dígito, multiplicador) de un valor de resistencia.
List<int> bandasDe(double ohms) {
  var e = 0;
  var v = ohms.round();
  while (v >= 100) {
    v = (v / 10).round();
    e++;
  }
  if (v < 10) {
    v *= 10;
    e--;
  }
  return [v ~/ 10, v % 10, e.clamp(0, 9)];
}

double ohmsDeBandas(List<int> b) => (b[0] * 10 + b[1]) * math.pow(10, b[2]).toDouble();

String textoOhms(double o) {
  if (o >= 1000000) return '${_corto(o / 1000000)} MΩ';
  if (o >= 1000) return '${_corto(o / 1000)} kΩ';
  return '${_corto(o)} Ω';
}

String _corto(double x) => x == x.roundToDouble() ? x.toStringAsFixed(0) : x.toStringAsFixed(1);

void _pata(Canvas c, List<Offset> pts) {
  final path = Path()..moveTo(pts.first.dx, pts.first.dy);
  for (final p in pts.skip(1)) {
    path.lineTo(p.dx, p.dy);
  }
  c.drawPath(path, linea(oscurecer(colorPata, 0.25), 4.2)..strokeJoin = StrokeJoin.round);
  c.drawPath(path, linea(aclarar(colorPata, 0.3), 2.2)..strokeJoin = StrokeJoin.round);
}

void _caja(Canvas c, Rect r, Color col, {double radio = 6, Color? borde}) {
  final rr = RRect.fromRectAndRadius(r, Radius.circular(radio));
  c.drawRRect(rr.shift(const Offset(0, 2.5)), relleno(const Color(0x33000000)));
  c.drawRRect(
      rr,
      Paint()
        ..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [aclarar(col, 0.18), oscurecer(col, 0.12)])
            .createShader(r));
  c.drawRRect(rr, linea(borde ?? oscurecer(col, 0.4), 1.6));
}

/// Dibuja una pieza en su posición.
void dibujarPieza(
  Canvas c,
  Pieza p, {
  double t = 0,
  double brillo = 0,
  double giro = 0,
  bool suena = false,
  double luzFoco = 0,
  double luz = 1,
  bool seleccionada = false,
}) {
  c.save();
  c.translate(p.pos.dx, p.pos.dy);
  c.scale(p.escala);
  if (seleccionada) {
    final cu = p.cuerpo;
    final r = Rect.fromCenter(center: (cu.center - p.pos) / p.escala, width: cu.width / p.escala, height: cu.height / p.escala).inflate(7);
    c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)), linea(const Color(0xFFFFA000), 2.5));
  }
  switch (p.tipo) {
    case TipoPieza.pila9v:
      _pila9v(c);
    case TipoPieza.pila3v:
      _pila3v(c);
    case TipoPieza.led:
      _led(c, p.colorLed.color, brillo, p.quemado, t);
    case TipoPieza.resistencia:
      _resistencia(c, p.ohms);
    case TipoPieza.interruptor:
      _interruptor(c, p.cerrado);
    case TipoPieza.boton:
      _boton(c, p.presionado);
    case TipoPieza.zumbador:
      _zumbador(c, suena, t);
    case TipoPieza.motor:
      _motor(c, giro);
    case TipoPieza.foco:
      _foco(c, luzFoco);
    case TipoPieza.ldr:
      _ldr(c, luz);
    case TipoPieza.potenciometro:
      _pot(c, p.posicion);
  }
  c.restore();
}

void _pila9v(Canvas c) {
  _pata(c, const [Offset(-12, -32), Offset(-12, -40)]);
  _pata(c, const [Offset(12, -32), Offset(12, -40)]);
  // Broches
  c.drawRect(const Rect.fromLTWH(-19, -36, 14, 8), relleno(const Color(0xFFB0BEC5)));
  c.drawCircle(const Offset(12, -32), 6, relleno(const Color(0xFFB0BEC5)));
  c.drawCircle(const Offset(12, -32), 6, linea(const Color(0xFF607D8B), 1.2));
  _caja(c, const Rect.fromLTWH(-25, -28, 50, 74), const Color(0xFF263238), radio: 5);
  c.drawRect(const Rect.fromLTWH(-25, -4, 50, 30), relleno(const Color(0xFFFF8F00)));
  textoEn(c, '9V', const Offset(0, 11), tam: 17, color: Colors.white);
  textoEn(c, '+', const Offset(-12, -20), tam: 13, color: Colors.white);
  textoEn(c, '−', const Offset(12, -20), tam: 13, color: Colors.white);
}

void _pila3v(Canvas c) {
  // Cables rojo y negro
  c.drawPath(Path()..moveTo(-30, -14)..quadraticBezierTo(-30, -32, -14, -36), linea(const Color(0xFFE53935), 3.5));
  c.drawPath(Path()..moveTo(30, -14)..quadraticBezierTo(30, -32, 14, -36), linea(const Color(0xFF212121), 3.5));
  _caja(c, const Rect.fromLTWH(-40, -16, 80, 42), const Color(0xFF37474F), radio: 6);
  for (final y in [-8.0, 9.0]) {
    final r = Rect.fromLTWH(-32, y - 6, 64, 13);
    c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(5)), relleno(const Color(0xFFCFD8DC)));
    c.drawRect(Rect.fromLTWH(-32, y - 6, 20, 13), relleno(const Color(0xFFB87333)));
    textoEn(c, 'AA', Offset(10, y + 0.5), tam: 8, color: const Color(0xFF37474F));
  }
  textoEn(c, '+', const Offset(-14, -26), tam: 12, color: const Color(0xFFE53935));
  textoEn(c, '−', const Offset(14, -26), tam: 12, color: const Color(0xFF212121));
}

void _led(Canvas c, Color col, double brillo, bool quemado, double t) {
  // Cátodo recto (izquierda) y ánodo doblado (derecha), como en Tinkercad.
  _pata(c, const [Offset(-9, 0), Offset(-9, 30)]);
  _pata(c, const [Offset(9, 0), Offset(9, 8), Offset(14, 14), Offset(9, 20), Offset(9, 30)]);
  if (brillo > 0.02 && !quemado) {
    final r = 26 + 14 * brillo + 2 * math.sin(t * 6);
    c.drawCircle(const Offset(0, -12), r, Paint()..shader = RadialGradient(colors: [col.withValues(alpha: 0.65 * brillo), col.withValues(alpha: 0)]).createShader(Rect.fromCircle(center: const Offset(0, -12), radius: r)));
  }
  final cuerpo = quemado ? const Color(0xFF5D4037) : Color.lerp(col.withValues(alpha: 0.75), aclarar(col, 0.6), brillo)!;
  final domo = Path()
    ..moveTo(-12, 2)
    ..lineTo(-12, -12)
    ..arcToPoint(const Offset(12, -12), radius: const Radius.circular(12))
    ..lineTo(12, 2)
    ..close();
  c.drawPath(domo, relleno(cuerpo));
  c.drawPath(domo, linea(oscurecer(quemado ? cuerpo : col, 0.35), 1.6));
  c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-14, 0, 28, 5), const Radius.circular(2)), relleno(quemado ? const Color(0xFF3E2723) : oscurecer(col, 0.1)));
  c.drawOval(const Rect.fromLTWH(-7, -19, 5, 10), relleno(Colors.white.withValues(alpha: quemado ? 0.1 : 0.55)));
  if (quemado) {
    // Estallido
    final p = Path();
    for (var i = 0; i < 16; i++) {
      final a = i / 16 * 2 * math.pi;
      final rr = i.isEven ? 20.0 : 9.0;
      final q = Offset(math.cos(a) * rr, -12 + math.sin(a) * rr);
      i == 0 ? p.moveTo(q.dx, q.dy) : p.lineTo(q.dx, q.dy);
    }
    p.close();
    c.drawPath(p, relleno(const Color(0xCCFFC107)));
    c.drawPath(p, linea(const Color(0xFFE65100), 1.5));
    textoEn(c, '!', const Offset(0, -12), tam: 13, color: const Color(0xFFB71C1C));
  }
}

void _resistencia(Canvas c, double ohms) {
  _pata(c, const [Offset(-36, 0), Offset(-20, 0)]);
  _pata(c, const [Offset(20, 0), Offset(36, 0)]);
  final r = const Rect.fromLTWH(-22, -7, 44, 14);
  c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(7)), relleno(const Color(0xFFE6C9A0)));
  final b = bandasDe(ohms);
  final xs = [-13.0, -6.0, 1.0];
  for (var i = 0; i < 3; i++) {
    c.drawRect(Rect.fromLTWH(xs[i], -7, 4, 14), relleno(colorBanda(b[i])));
  }
  c.drawRect(const Rect.fromLTWH(11, -7, 4, 14), relleno(colorOro));
  c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(7)), linea(const Color(0xFFA1887F), 1.4));
}

void _interruptor(Canvas c, bool cerrado) {
  _pata(c, const [Offset(-34, 0), Offset(-22, 0)]);
  _pata(c, const [Offset(22, 0), Offset(34, 0)]);
  _caja(c, const Rect.fromLTWH(-26, -12, 52, 24), const Color(0xFF455A64), radio: 5);
  c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-18, -5, 36, 10), const Radius.circular(5)), relleno(const Color(0xFF263238)));
  final x = cerrado ? 6.0 : -18.0;
  _caja(c, Rect.fromLTWH(x, -8, 12, 16), cerrado ? const Color(0xFF66BB6A) : const Color(0xFFBDBDBD), radio: 3);
  textoEn(c, cerrado ? 'ON' : 'OFF', const Offset(0, -19), tam: 9, color: cerrado ? const Color(0xFF2E7D32) : const Color(0xFF616161));
}

void _boton(Canvas c, bool presionado) {
  _pata(c, const [Offset(-30, 0), Offset(-17, 0)]);
  _pata(c, const [Offset(17, 0), Offset(30, 0)]);
  _caja(c, const Rect.fromLTWH(-18, -18, 36, 36), const Color(0xFF424242), radio: 4);
  for (final o in const [Offset(-13, -13), Offset(13, -13), Offset(-13, 13), Offset(13, 13)]) {
    c.drawCircle(o, 2, relleno(const Color(0xFF9E9E9E)));
  }
  c.drawCircle(Offset(0, presionado ? 1.5 : 0), presionado ? 9 : 11, relleno(presionado ? const Color(0xFFC62828) : const Color(0xFFEF5350)));
  c.drawCircle(Offset(0, presionado ? 1.5 : 0), presionado ? 9 : 11, linea(const Color(0xFF8E0000), 1.4));
}

void _zumbador(Canvas c, bool suena, double t) {
  _pata(c, const [Offset(-10, 14), Offset(-10, 32)]);
  _pata(c, const [Offset(10, 14), Offset(10, 32)]);
  if (suena) {
    for (var k = 0; k < 3; k++) {
      final f = (t * 1.6 + k / 3) % 1;
      final r = 22 + f * 22;
      c.drawArc(Rect.fromCircle(center: const Offset(0, -2), radius: r), -math.pi * 0.85, math.pi * 0.7, false, linea(const Color(0xFF7E57C2).withValues(alpha: 1 - f), 2.5));
    }
  }
  c.drawCircle(const Offset(0, -2), 20, relleno(const Color(0xFF212121)));
  c.drawCircle(const Offset(0, -2), 20, linea(const Color(0xFF000000), 1.5));
  c.drawCircle(const Offset(0, -2), 13, linea(const Color(0xFF424242), 1.2));
  c.drawCircle(const Offset(0, -2), 3.5, relleno(const Color(0xFF616161)));
  textoEn(c, '+', const Offset(-10, 8), tam: 10, color: Colors.white);
}

void _motor(Canvas c, double giro) {
  _pata(c, const [Offset(-12, 18), Offset(-12, 34)]);
  _pata(c, const [Offset(12, 18), Offset(12, 34)]);
  final r = const Rect.fromLTWH(-22, -16, 44, 36);
  c.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(8)),
      Paint()
        ..shader = const LinearGradient(colors: [Color(0xFF90A4AE), Color(0xFFECEFF1), Color(0xFF78909C)]).createShader(r));
  c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(8)), linea(const Color(0xFF546E7A), 1.5));
  c.drawRect(const Rect.fromLTWH(-22, 12, 44, 6), relleno(const Color(0xFFE65100)));
  // Eje y hélice
  c.drawRect(const Rect.fromLTWH(-2, -26, 4, 10), relleno(const Color(0xFF616161)));
  c.save();
  c.translate(0, -28);
  c.scale(1, 0.45);
  for (var k = 0; k < 3; k++) {
    final a = giro + k * 2 * math.pi / 3;
    c.save();
    c.rotate(a);
    c.drawOval(const Rect.fromLTWH(2, -5, 22, 10), relleno(const Color(0xFF29B6F6)));
    c.drawOval(const Rect.fromLTWH(2, -5, 22, 10), linea(const Color(0xFF0277BD), 1.2));
    c.restore();
  }
  c.restore();
  c.drawCircle(const Offset(0, -28), 3, relleno(const Color(0xFF37474F)));
  textoEn(c, 'M', const Offset(0, 1), tam: 13, color: const Color(0xFF37474F));
}

void _foco(Canvas c, double luz) {
  _pata(c, const [Offset(-10, 18), Offset(-10, 32)]);
  _pata(c, const [Offset(10, 18), Offset(10, 32)]);
  if (luz > 0.02) {
    final r = 30 + 18 * luz;
    c.drawCircle(const Offset(0, -12), r, Paint()..shader = RadialGradient(colors: [const Color(0xFFFFF59D).withValues(alpha: 0.85 * luz), const Color(0x00FFF59D)]).createShader(Rect.fromCircle(center: const Offset(0, -12), radius: r)));
  }
  c.drawCircle(const Offset(0, -12), 17, relleno(Color.lerp(const Color(0xCCE3F2FD), const Color(0xFFFFF176), luz)!));
  c.drawCircle(const Offset(0, -12), 17, linea(const Color(0xFF90A4AE), 1.5));
  c.drawPath(Path()..moveTo(-5, 2)..lineTo(-5, -10)..quadraticBezierTo(0, -20, 5, -10)..lineTo(5, 2), linea(Color.lerp(const Color(0xFF795548), const Color(0xFFFF6F00), luz)!, 1.6));
  _caja(c, const Rect.fromLTWH(-9, 3, 18, 15), const Color(0xFFB0BEC5), radio: 3);
  c.drawLine(const Offset(-9, 8), const Offset(9, 8), linea(const Color(0xFF78909C), 1));
  c.drawLine(const Offset(-9, 13), const Offset(9, 13), linea(const Color(0xFF78909C), 1));
}

void _ldr(Canvas c, double luz) {
  _pata(c, const [Offset(-9, 6), Offset(-9, 28)]);
  _pata(c, const [Offset(9, 6), Offset(9, 28)]);
  c.drawCircle(const Offset(0, -4), 14, relleno(const Color(0xFFFFE0B2)));
  c.drawCircle(const Offset(0, -4), 14, linea(const Color(0xFFBF8B4B), 1.6));
  final p = Path()..moveTo(-8, -10);
  for (var k = 0; k < 4; k++) {
    final y = -10 + k * 4.0;
    p.lineTo(8, y);
    p.lineTo(8, y + 2);
    p.lineTo(-8, y + 2);
    p.lineTo(-8, y + 4);
  }
  c.drawPath(p, linea(const Color(0xFFC62828), 1.4));
  // Rayos de luz
  final a = (luz * 255).round();
  for (var k = 0; k < 3; k++) {
    final o = Offset(-26 + k * 6.0, -26 + k * 2.0);
    c.drawLine(o, o + const Offset(8, 8), linea(Color.fromARGB(a, 255, 179, 0), 2));
  }
}

void _pot(Canvas c, double pos) {
  for (final x in const [-18.0, 0.0, 18.0]) {
    _pata(c, [Offset(x, 12), Offset(x, 32)]);
  }
  _caja(c, const Rect.fromLTWH(-22, -16, 44, 30), const Color(0xFF1565C0), radio: 5);
  c.drawCircle(const Offset(0, -1), 12, relleno(const Color(0xFFECEFF1)));
  c.drawCircle(const Offset(0, -1), 12, linea(const Color(0xFF607D8B), 1.5));
  final a = -math.pi * 0.75 + pos * math.pi * 1.5 - math.pi / 2;
  c.drawLine(const Offset(0, -1), Offset(math.cos(a) * 10, -1 + math.sin(a) * 10), linea(const Color(0xFF37474F), 3));
}

/// Dibuja una pieza suelta en un rectángulo (para ilustraciones y tarjetas).
void dibujarPiezaEn(Canvas c, TipoPieza tipo, Offset centro, double escala,
    {double brillo = 0, ColorLed color = ColorLed.rojo, double ohms = 220, bool cerrado = false, double giro = 0, double luzFoco = 0, bool suena = false, double t = 0}) {
  c.save();
  c.translate(centro.dx, centro.dy);
  c.scale(escala);
  dibujarPieza(c, Pieza('_', tipo, Offset.zero, ohms: ohms, colorLed: color, cerrado: cerrado), brillo: brillo, giro: giro, luzFoco: luzFoco, suena: suena, t: t);
  c.restore();
}
