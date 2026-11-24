import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show linea, relleno, textoEn;
import '../biology/temas/ilustraciones.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;

/// Herramientas para crear ilustraciones de Física y Química rápidamente:
/// una tarjeta con fondo y objetos (emojis) que se pueden señalar.

enum Anim { nada, flotar, girar, latir, caer, temblar }

class ObjEscena {
  const ObjEscena(this.id, this.emoji, this.x, this.y, {this.tam = 0.16, this.anim = Anim.flotar, this.etiqueta});
  final String id, emoji;

  /// Posición y tamaño como fracción del ancho de la tarjeta.
  final double x, y, tam;
  final Anim anim;

  /// Texto pequeño debajo del objeto.
  final String? etiqueta;
}

typedef Extra = void Function(Canvas c, Rect r, double t, double s);

Offset en(Rect r, double x, double y) => Offset(r.left + x * r.width, r.top + y * r.height);

void tarjetaFondo(Canvas c, Rect r, List<Color> colores) {
  final rr = RRect.fromRectAndRadius(r, const Radius.circular(20));
  c.drawRRect(rr.shift(const Offset(0, 5)), relleno(const Color(0x44000000)));
  c.drawRRect(rr, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colores).createShader(r));
  c.drawRRect(rr, linea(const Color(0xFF90A4AE), 3));
}

/// Ilustración hecha de objetos sobre un fondo, con dibujos extra opcionales
/// ([antes] se pinta debajo de los objetos y [despues] encima).
Ilustracion escena(List<ObjEscena> objs, {List<Color> fondo = const [Color(0xFFFDFDFE), Color(0xFFF1F5F9)], Extra? antes, Extra? despues}) {
  void dibujar(Canvas c, Rect r, double t, String? sel) {
    tarjetaFondo(c, r, fondo);
    final s = r.width / 256;
    c.save();
    c.clipRRect(RRect.fromRectAndRadius(r, const Radius.circular(20)));
    antes?.call(c, r, t, s);
    for (var i = 0; i < objs.length; i++) {
      final o = objs[i];
      var p = en(r, o.x, o.y);
      final tam = o.tam * r.width;
      if (sel == o.id) {
        c.drawCircle(p, tam * 0.75 + 3 * math.sin(t * 5), linea(const Color(0xFFFFA000), 3));
        c.drawCircle(p, tam * 0.75, relleno(const Color(0x22FFA000)));
      }
      c.save();
      switch (o.anim) {
        case Anim.flotar:
          p += Offset(0, math.sin(t * 2 + i) * tam * 0.06);
        case Anim.caer:
          p += Offset(0, ((t * 0.5 + i * 0.2) % 1) * tam * 0.5 - tam * 0.25);
        case Anim.temblar:
          p += Offset(math.sin(t * 25 + i) * tam * 0.03, 0);
        case Anim.girar:
          c.translate(p.dx, p.dy);
          c.rotate(t * 0.8);
          c.translate(-p.dx, -p.dy);
        case Anim.latir:
        case Anim.nada:
          break;
      }
      final esc = o.anim == Anim.latir ? 1 + 0.06 * math.sin(t * 4 + i) : 1.0;
      dibujarEmoji(c, o.emoji, p, tam * esc);
      c.restore();
      if (o.etiqueta != null) textoEn(c, o.etiqueta!, p + Offset(0, tam * 0.72), tam: 10.5 * s, color: const Color(0xFF37474F), fondo: const Color(0xCCFFFFFF));
    }
    despues?.call(c, r, t, s);
    c.restore();
  }

  return Ilustracion(dibujar, {for (final o in objs) o.id: Offset(o.x, o.y)});
}

/// Flecha sencilla.
void flechaEn(Canvas c, Offset a, Offset b, Color col, {double ancho = 3}) {
  c.drawLine(a, b, linea(col, ancho)..strokeCap = StrokeCap.round);
  final d = b - a;
  if (d.distance == 0) return;
  final u = d / d.distance, n = Offset(-u.dy, u.dx);
  c.drawPath(
      Path()
        ..moveTo(b.dx, b.dy)
        ..lineTo((b - u * 10 + n * 6).dx, (b - u * 10 + n * 6).dy)
        ..lineTo((b - u * 10 - n * 6).dx, (b - u * 10 - n * 6).dy)
        ..close(),
      relleno(col));
}
