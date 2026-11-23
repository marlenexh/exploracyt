import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart' show linea, relleno, textoEn;
import '../ciencia/escena.dart';

/// Ilustraciones de Química.

void _particulas(Canvas c, Rect caja, double t, int n, double vel, Color col, {bool juntas = false, bool vibrar = false}) {
  c.drawRRect(RRect.fromRectAndRadius(caja, const Radius.circular(8)), relleno(const Color(0x22FFFFFF)));
  c.drawRRect(RRect.fromRectAndRadius(caja, const Radius.circular(8)), linea(const Color(0xFF90A4AE), 2));
  final rnd = math.Random(n);
  final r = caja.width / 20;
  for (var k = 0; k < n; k++) {
    Offset p;
    if (juntas) {
      final cols = 5;
      p = Offset(caja.left + (k % cols + 0.7) * caja.width / (cols + 0.4), caja.bottom - (k ~/ cols + 0.7) * r * 2.2);
      if (vibrar) p += Offset(math.sin(t * 20 + k) * r * 0.15, 0);
    } else {
      double reb(double x, double l) {
        final m = x % (2 * l);
        return m < l ? m : 2 * l - m;
      }

      p = Offset(caja.left + r + reb(rnd.nextDouble() * 99 + t * vel * (0.5 + rnd.nextDouble()), caja.width - 2 * r),
          caja.top + r + reb(rnd.nextDouble() * 99 + t * vel * (0.5 + rnd.nextDouble()), caja.height - 2 * r));
    }
    c.drawCircle(p, r, relleno(col));
  }
}

// Tema 1 ----------------------------------------------------------------------

final ilPropiedades = escena(const [
  ObjEscena('dureza', '💎', 0.27, 0.15, etiqueta: 'duro'),
  ObjEscena('fragil', '🍷', 0.73, 0.15, etiqueta: 'frágil'),
  ObjEscena('flexibilidad', '🪢', 0.27, 0.45, etiqueta: 'flexible'),
  ObjEscena('elasticidad', '🎈', 0.73, 0.45, etiqueta: 'elástico'),
  ObjEscena('permeable', '🧽', 0.27, 0.78, etiqueta: 'permeable'),
  ObjEscena('impermeable', '☂️', 0.73, 0.78, etiqueta: 'impermeable'),
], despues: (c, r, t, s) {
  // Gotas sobre la esponja (se absorben) y sobre el paraguas (resbalan)
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.8 + k / 3) % 1;
    c.drawCircle(en(r, 0.22 + k * 0.05, 0.62 + f * 0.1), 3 * s, relleno(Color.fromARGB((255 * (1 - f)).round(), 41, 182, 246)));
    c.drawCircle(en(r, 0.66 + k * 0.06 + f * 0.1, 0.63 + f * 0.12), 3 * s, relleno(const Color(0xFF29B6F6)));
  }
});

final ilNaturalArtificial = escena(const [
  ObjEscena('madera', '🪵', 0.25, 0.2, etiqueta: 'madera'),
  ObjEscena('algodon', '🌿', 0.25, 0.47, etiqueta: 'algodón'),
  ObjEscena('piedra', '🪨', 0.25, 0.74, etiqueta: 'piedra'),
  ObjEscena('plastico', '🧴', 0.75, 0.2, etiqueta: 'plástico'),
  ObjEscena('vidrio', '🫙', 0.75, 0.47, etiqueta: 'vidrio'),
  ObjEscena('papel', '📄', 0.75, 0.74, etiqueta: 'papel'),
], despues: (c, r, t, s) {
  c.drawLine(en(r, 0.5, 0.08), en(r, 0.5, 0.92), linea(const Color(0x5590A4AE), 2));
  textoEn(c, 'Naturales', en(r, 0.25, 0.05), tam: 12 * s, color: const Color(0xFF2E7D32));
  textoEn(c, 'Artificiales', en(r, 0.75, 0.05), tam: 12 * s, color: const Color(0xFF1565C0));
  flechaEn(c, en(r, 0.33, 0.47), en(r, 0.67, 0.47), const Color(0xFFFFA000));
  textoEn(c, 'se transforman', en(r, 0.5, 0.42), tam: 9 * s, color: const Color(0xFFE65100));
});

// Tema 2 ----------------------------------------------------------------------

final ilEstados = escena(const [
  ObjEscena('solido', '🧊', 0.2, 0.86, tam: 0.12, anim: Anim.nada),
  ObjEscena('liquido', '💧', 0.5, 0.86, tam: 0.12, anim: Anim.nada),
  ObjEscena('gas', '💨', 0.8, 0.86, tam: 0.12, anim: Anim.nada),
], despues: (c, r, t, s) {
  _particulas(c, Rect.fromLTWH(r.left + 12 * s, r.top + 60 * s, 70 * s, 180 * s), t, 20, 0, const Color(0xFF64B5F6), juntas: true, vibrar: true);
  final liq = Rect.fromLTWH(r.left + 93 * s, r.top + 60 * s, 70 * s, 180 * s);
  c.drawRRect(RRect.fromRectAndRadius(liq, const Radius.circular(8)), linea(const Color(0xFF90A4AE), 2));
  final rnd = math.Random(2);
  for (var k = 0; k < 20; k++) {
    final p = Offset(liq.left + 8 * s + ((rnd.nextDouble() * 50 * s + t * 12 * s) % (liq.width - 16 * s)), liq.bottom - 8 * s - rnd.nextDouble() * 70 * s);
    c.drawCircle(p, 3.5 * s, relleno(const Color(0xFF29B6F6)));
  }
  _particulas(c, Rect.fromLTWH(r.left + 174 * s, r.top + 60 * s, 70 * s, 180 * s), t, 10, 70 * s, const Color(0xFFB0BEC5));
  for (final (x, txt) in [(0.18, 'Sólido'), (0.5, 'Líquido'), (0.82, 'Gas')]) {
    textoEn(c, txt, en(r, x, 0.1), tam: 13 * s, color: const Color(0xFF37474F));
  }
});

final ilGases = escena(const [
  ObjEscena('masa', '🎈', 0.25, 0.18, etiqueta: 'tiene masa'),
  ObjEscena('compresible', '🛞', 0.75, 0.18, etiqueta: 'se comprime'),
  ObjEscena('fluidez', '🌸', 0.25, 0.52, etiqueta: 'fluye'),
  ObjEscena('expansion', '🎈', 0.75, 0.52, anim: Anim.latir, etiqueta: 'se expande'),
  ObjEscena('volumen', '🫙', 0.5, 0.82, etiqueta: 'ocupa todo el espacio'),
], despues: (c, r, t, s) {
  // Aroma que se esparce
  for (var k = 0; k < 6; k++) {
    final f = (t * 0.3 + k / 6) % 1;
    c.drawCircle(
        en(r, 0.25, 0.52) + Offset(math.cos(k * 1.1) * f * 60 * s, -f * 50 * s), 3 * s, relleno(Color.fromARGB((200 * (1 - f)).round(), 236, 64, 122)));
  }
  _particulas(c, Rect.fromCenter(center: en(r, 0.5, 0.82), width: 60 * s, height: 50 * s), t, 8, 50 * s, const Color(0x8890A4AE));
});

// Tema 3 ----------------------------------------------------------------------

final ilCambios = escena(const [
  ObjEscena('hielo', '🧊', 0.2, 0.18, tam: 0.13),
  ObjEscena('agua', '💧', 0.8, 0.18, tam: 0.13),
  ObjEscena('chocolate', '🍫', 0.2, 0.4, tam: 0.13),
  ObjEscena('huevo', '🥚', 0.2, 0.66, tam: 0.13),
  ObjEscena('estrellado', '🍳', 0.8, 0.66, tam: 0.13),
  ObjEscena('papel', '📄', 0.2, 0.88, tam: 0.13),
  ObjEscena('ceniza', '🔥', 0.8, 0.88, tam: 0.13),
], despues: (c, r, t, s) {
  textoEn(c, 'TEMPORALES: pueden regresar', en(r, 0.5, 0.05), tam: 11 * s, color: Colors.white, fondo: const Color(0xFF00897B));
  for (final y in [0.18, 0.4]) {
    flechaEn(c, en(r, 0.33, y - 0.02), en(r, 0.67, y - 0.02), const Color(0xFF00897B));
    flechaEn(c, en(r, 0.67, y + 0.03), en(r, 0.33, y + 0.03), const Color(0xFF80CBC4));
  }
  c.save();
  c.translate(en(r, 0.8, 0.4).dx, en(r, 0.8, 0.4).dy);
  c.drawOval(Rect.fromCenter(center: Offset.zero, width: 40 * s, height: 14 * s), relleno(const Color(0xFF6D4C41)));
  c.restore();
  textoEn(c, 'PERMANENTES: no regresan', en(r, 0.5, 0.53), tam: 11 * s, color: Colors.white, fondo: const Color(0xFFE53935));
  for (final y in [0.66, 0.88]) {
    flechaEn(c, en(r, 0.33, y), en(r, 0.67, y), const Color(0xFFE53935));
  }
});

final ilCicloAgua = escena(const [
  ObjEscena('sol', '☀️', 0.2, 0.12),
  ObjEscena('nube', '☁️', 0.72, 0.15, tam: 0.2),
  ObjEscena('lluvia', '🌧️', 0.82, 0.45),
  ObjEscena('mar', '🌊', 0.35, 0.82, tam: 0.2),
  ObjEscena('montana', '🏔️', 0.82, 0.8, tam: 0.18),
], fondo: const [
  Color(0xFFB3E5FC),
  Color(0xFFE1F5FE)
], despues: (c, r, t, s) {
  flechaEn(c, en(r, 0.35, 0.72), en(r, 0.55, 0.25), const Color(0xFFFF7043));
  textoEn(c, 'evaporación', en(r, 0.34, 0.45), tam: 10 * s, color: const Color(0xFFE64A19), fondo: const Color(0xCCFFFFFF));
  textoEn(c, 'condensación', en(r, 0.72, 0.29), tam: 10 * s, color: const Color(0xFF1565C0), fondo: const Color(0xCCFFFFFF));
  flechaEn(c, en(r, 0.82, 0.55), en(r, 0.82, 0.68), const Color(0xFF1E88E5));
  flechaEn(c, en(r, 0.7, 0.86), en(r, 0.5, 0.86), const Color(0xFF1E88E5));
  textoEn(c, 'escurrimiento', en(r, 0.6, 0.94), tam: 10 * s, color: const Color(0xFF1565C0));
});

// Tema 4 ----------------------------------------------------------------------

final ilCoccion = escena(const [
  ObjEscena('calor', '🔥', 0.5, 0.82, tam: 0.18, anim: Anim.latir),
  ObjEscena('olla', '🍲', 0.5, 0.58, tam: 0.26),
  ObjEscena('tiempo', '⏲️', 0.18, 0.2),
  ObjEscena('crudo', '🥩', 0.2, 0.55, etiqueta: 'crudo'),
  ObjEscena('cocido', '🍖', 0.82, 0.55, etiqueta: 'cocido'),
  ObjEscena('microbios', '🦠', 0.82, 0.2, anim: Anim.temblar),
], despues: (c, r, t, s) {
  for (var k = 0; k < 3; k++) {
    final f = (t * 0.4 + k / 3) % 1;
    c.drawCircle(en(r, 0.47 + k * 0.03, 0.45 - f * 0.2), (5 + f * 8) * s, relleno(Color.fromARGB((120 * (1 - f)).round(), 255, 255, 255)));
  }
  c.drawLine(en(r, 0.74, 0.14), en(r, 0.9, 0.26), linea(const Color(0xFFE53935), 4 * s));
});

final ilDescomposicion = escena(const [
  ObjEscena('bacterias', '🦠', 0.22, 0.2, anim: Anim.temblar, etiqueta: 'bacterias'),
  ObjEscena('hongos', '🍄', 0.78, 0.2, etiqueta: 'hongos (moho)'),
  ObjEscena('calor', '🌡️', 0.2, 0.55, etiqueta: 'calor'),
  ObjEscena('humedad', '💧', 0.8, 0.55, etiqueta: 'humedad'),
  ObjEscena('alimento', '🍞', 0.5, 0.82, tam: 0.22, anim: Anim.nada),
], despues: (c, r, t, s) {
  final rnd = math.Random(4);
  final p = en(r, 0.5, 0.82);
  final n = ((t * 0.5) % 4 * 4).floor();
  for (var k = 0; k < n; k++) {
    c.drawCircle(
        p + Offset(rnd.nextDouble() * 40 * s - 20 * s, rnd.nextDouble() * 30 * s - 15 * s), (2 + rnd.nextDouble() * 4) * s, relleno(const Color(0xAA7CB342)));
  }
});

// Tema 5 ----------------------------------------------------------------------

final ilCombustion = escena(const [
  ObjEscena('combustible', '🪵', 0.2, 0.8, tam: 0.15, etiqueta: 'combustible'),
  ObjEscena('oxigeno', '💨', 0.8, 0.8, tam: 0.15, etiqueta: 'oxígeno'),
  ObjEscena('calor', '🌡️', 0.5, 0.14, tam: 0.15, etiqueta: 'calor'),
  ObjEscena('fuego', '🔥', 0.5, 0.56, tam: 0.24, anim: Anim.latir),
  ObjEscena('humo', '☁️', 0.82, 0.32, tam: 0.14, etiqueta: 'humo y CO₂'),
], fondo: const [
  Color(0xFF263238),
  Color(0xFF37474F)
], antes: (c, r, t, s) {
  final a = en(r, 0.5, 0.24), b = en(r, 0.24, 0.72), d = en(r, 0.76, 0.72);
  c.drawPath(
      Path()
        ..moveTo(a.dx, a.dy)
        ..lineTo(b.dx, b.dy)
        ..lineTo(d.dx, d.dy)
        ..close(),
      linea(const Color(0xFFFFB300), 4 * s));
});

final ilOxidacion = escena(const [
  ObjEscena('clavo', '🔩', 0.25, 0.2, etiqueta: 'clavo oxidado'),
  ObjEscena('bici', '🚲', 0.75, 0.2, etiqueta: 'bici con óxido'),
  ObjEscena('manzana', '🍎', 0.25, 0.55, etiqueta: 'manzana partida'),
  ObjEscena('oxigeno', '💨', 0.75, 0.55, etiqueta: 'oxígeno del aire'),
  ObjEscena('agua', '💧', 0.5, 0.84, etiqueta: 'humedad'),
], despues: (c, r, t, s) {
  final p = en(r, 0.25, 0.2);
  final f = (t * 0.3) % 1;
  c.drawCircle(p + Offset(8 * s, 4 * s), 9 * s * f, relleno(const Color(0x88BF360C)));
  c.drawCircle(en(r, 0.29, 0.55), 10 * s * f, relleno(const Color(0x888D6E63)));
});
