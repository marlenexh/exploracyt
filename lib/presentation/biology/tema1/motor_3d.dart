import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Motor 3D mínimo (sin dependencias): mallas de triángulos, proyección en
/// perspectiva, iluminación simple y ordenamiento por profundidad.

class V3 {
  const V3(this.x, this.y, this.z);
  final double x, y, z;
  static const cero = V3(0, 0, 0);
  static const uno = V3(1, 1, 1);

  V3 operator +(V3 o) => V3(x + o.x, y + o.y, z + o.z);
  V3 operator -(V3 o) => V3(x - o.x, y - o.y, z - o.z);
  V3 operator *(double s) => V3(x * s, y * s, z * s);
  V3 mul(V3 o) => V3(x * o.x, y * o.y, z * o.z);
  double dot(V3 o) => x * o.x + y * o.y + z * o.z;
  V3 cross(V3 o) => V3(y * o.z - z * o.y, z * o.x - x * o.z, x * o.y - y * o.x);
  double get largo => math.sqrt(x * x + y * y + z * z);
  V3 unitario() {
    final l = largo;
    return l < 1e-9 ? this : this * (1 / l);
  }

  V3 rotX(double a) {
    final c = math.cos(a), s = math.sin(a);
    return V3(x, y * c - z * s, y * s + z * c);
  }

  V3 rotY(double a) {
    final c = math.cos(a), s = math.sin(a);
    return V3(x * c + z * s, y, -x * s + z * c);
  }

  V3 rotZ(double a) {
    final c = math.cos(a), s = math.sin(a);
    return V3(x * c - y * s, x * s + y * c, z);
  }

  static V3 lerp(V3 a, V3 b, double t) => a + (b - a) * t;
}

class Malla {
  Malla(this.vertices, this.caras);
  final List<V3> vertices;

  /// Triángulos como tríos de índices.
  final List<List<int>> caras;

  Malla deformar(V3 Function(V3 p) f) => Malla(vertices.map(f).toList(), caras);
  Malla escalar(V3 s) => deformar((p) => p.mul(s));
  Malla mover(V3 d) => deformar((p) => p + d);
  Malla rotarX(double a) => deformar((p) => p.rotX(a));
  Malla rotarY(double a) => deformar((p) => p.rotY(a));
  Malla rotarZ(double a) => deformar((p) => p.rotZ(a));

  Malla unir(Malla o) {
    final n = vertices.length;
    return Malla(
      [...vertices, ...o.vertices],
      [
        ...caras,
        ...o.caras.map((c) => [c[0] + n, c[1] + n, c[2] + n]),
      ],
    );
  }

  static Malla unirTodas(List<Malla> mallas) =>
      mallas.reduce((a, b) => a.unir(b));

  /// Esfera unitaria.
  factory Malla.esfera({int lat = 12, int lon = 18}) {
    final v = <V3>[];
    for (var i = 0; i <= lat; i++) {
      final th = math.pi * i / lat;
      for (var j = 0; j < lon; j++) {
        final ph = 2 * math.pi * j / lon;
        v.add(
          V3(
            math.sin(th) * math.cos(ph),
            math.cos(th),
            math.sin(th) * math.sin(ph),
          ),
        );
      }
    }
    final c = <List<int>>[];
    for (var i = 0; i < lat; i++) {
      for (var j = 0; j < lon; j++) {
        final a = i * lon + j, b = i * lon + (j + 1) % lon;
        final d = (i + 1) * lon + j, e = (i + 1) * lon + (j + 1) % lon;
        if (i != 0) c.add([a, b, d]);
        if (i != lat - 1) c.add([b, e, d]);
      }
    }
    return Malla(v, c);
  }

  /// Tubo que sigue un camino (para vasos sanguíneos, tráquea...).
  factory Malla.tubo(
    List<V3> camino,
    double radio, {
    int segmentos = 10,
    double radioFinal = -1,
  }) {
    final v = <V3>[];
    final c = <List<int>>[];
    final n = camino.length;
    V3? normalPrevia;
    for (var i = 0; i < n; i++) {
      final a = camino[math.max(0, i - 1)];
      final b = camino[math.min(n - 1, i + 1)];
      final t = (b - a).unitario();
      // Transporte paralelo: se proyecta la normal anterior sobre el plano
      // perpendicular a la nueva tangente para que el tubo no se tuerza.
      V3 nn;
      if (normalPrevia == null) {
        nn = t.cross(const V3(0, 0, 1));
        if (nn.largo < 0.1) nn = t.cross(const V3(1, 0, 0));
      } else {
        nn = normalPrevia - t * normalPrevia.dot(t);
        if (nn.largo < 1e-6) nn = t.cross(const V3(1, 0, 0));
      }
      nn = nn.unitario();
      normalPrevia = nn;
      final bb = t.cross(nn).unitario();
      final r =
          radioFinal < 0 ? radio : radio + (radioFinal - radio) * (i / (n - 1));
      for (var j = 0; j < segmentos; j++) {
        final ang = 2 * math.pi * j / segmentos;
        v.add(camino[i] + (nn * math.cos(ang) + bb * math.sin(ang)) * r);
      }
    }
    for (var i = 0; i < n - 1; i++) {
      for (var j = 0; j < segmentos; j++) {
        final a = i * segmentos + j, b = i * segmentos + (j + 1) % segmentos;
        final d = (i + 1) * segmentos + j,
            e = (i + 1) * segmentos + (j + 1) % segmentos;
        c.add([a, b, d]);
        c.add([b, e, d]);
      }
    }
    // Tapas
    for (final extremo in [0, n - 1]) {
      final centro = v.length;
      v.add(camino[extremo]);
      final base = extremo * segmentos;
      for (var j = 0; j < segmentos; j++) {
        c.add([centro, base + j, base + (j + 1) % segmentos]);
      }
    }
    return Malla(v, c);
  }
}

/// Curva suave Catmull-Rom que pasa por los puntos de control.
List<V3> curva(List<V3> p, {int pasos = 8}) {
  if (p.length < 3) return p;
  final r = <V3>[];
  for (var i = 0; i < p.length - 1; i++) {
    final p0 = p[math.max(0, i - 1)], p1 = p[i], p2 = p[i + 1];
    final p3 = p[math.min(p.length - 1, i + 2)];
    for (var s = 0; s < pasos; s++) {
      final t = s / pasos, t2 = t * t, t3 = t2 * t;
      r.add(
        (p1 * 2 +
                (p2 - p0) * t +
                (p0 * 2 - p1 * 5 + p2 * 4 - p3) * t2 +
                (p1 * 3 - p0 - p2 * 3 + p3) * t3) *
            0.5,
      );
    }
  }
  r.add(p.last);
  return r;
}

/// Punto a una fracción [s] (0–1) de la longitud del camino.
V3 puntoEnCamino(List<V3> camino, double s) {
  s = s.clamp(0.0, 1.0);
  var total = 0.0;
  final largos = <double>[];
  for (var i = 0; i < camino.length - 1; i++) {
    final l = (camino[i + 1] - camino[i]).largo;
    largos.add(l);
    total += l;
  }
  var objetivo = s * total;
  for (var i = 0; i < largos.length; i++) {
    if (objetivo <= largos[i] || i == largos.length - 1) {
      return V3.lerp(
        camino[i],
        camino[i + 1],
        largos[i] == 0 ? 0 : (objetivo / largos[i]).clamp(0.0, 1.0),
      );
    }
    objetivo -= largos[i];
  }
  return camino.last;
}

class Objeto3D {
  Objeto3D({
    required this.id,
    required this.malla,
    required this.color,
    this.opacidad = 1,
    this.posicion = V3.cero,
    this.escala = V3.uno,
    this.rotacion = V3.cero,
    this.pulso,
    this.desplazamiento,
    this.giro,
    this.seleccionable = true,
    this.brillo = 0.25,
  });

  final String id;
  final Malla malla;
  final Color color;
  double opacidad;
  final V3 posicion;
  final V3 escala;
  final V3 rotacion;

  /// Multiplicador de escala animado (latido, respiración).
  final double Function(double t)? pulso;

  /// Desplazamiento animado.
  final V3 Function(double t)? desplazamiento;

  /// Rotación animada adicional (ángulos en radianes).
  final V3 Function(double t)? giro;
  final bool seleccionable;
  final double brillo;
}

class Particula3D {
  const Particula3D(this.pos, this.color, this.radio);
  final V3 pos;
  final Color color;
  final double radio;
}

class Escena3D {
  Escena3D({
    required this.objetos,
    this.particulas,
    this.distancia = 6,
    this.zoomInicial = 1,
    this.fondo = const [Color(0xFF0D1B3E), Color(0xFF1B2F66)],
  });
  final List<Objeto3D> objetos;
  final List<Particula3D> Function(double t)? particulas;
  final double distancia;
  final double zoomInicial;
  final List<Color> fondo;
}

class _TrianguloProyectado {
  _TrianguloProyectado(this.a, this.b, this.c, this.prof, this.id);
  final Offset a, b, c;
  final double prof;
  final String id;
}

class _Elemento {
  _Elemento.tri(this.a, this.b, this.c, this.color, this.prof)
      : radio = 0,
        esParticula = false;
  _Elemento.part(this.a, this.radio, this.color, this.prof)
      : b = Offset.zero,
        c = Offset.zero,
        esParticula = true;
  final Offset a, b, c;
  final double radio;
  final Color color;
  final double prof;
  final bool esParticula;
}

/// Guarda la última proyección para poder saber qué objeto se tocó.
class CacheSeleccion {
  List<_TrianguloProyectado> _tris = const [];

  String? objetoEn(Offset p) {
    String? mejor;
    var prof = double.infinity;
    for (final t in _tris) {
      if (t.prof < prof && _dentro(p, t.a, t.b, t.c)) {
        prof = t.prof;
        mejor = t.id;
      }
    }
    return mejor;
  }

  static bool _dentro(Offset p, Offset a, Offset b, Offset c) {
    double s(Offset p1, Offset p2, Offset p3) =>
        (p1.dx - p3.dx) * (p2.dy - p3.dy) - (p2.dx - p3.dx) * (p1.dy - p3.dy);
    final d1 = s(p, a, b), d2 = s(p, b, c), d3 = s(p, c, a);
    final neg = d1 < 0 || d2 < 0 || d3 < 0;
    final pos = d1 > 0 || d2 > 0 || d3 > 0;
    return !(neg && pos);
  }
}

class Pintor3D extends CustomPainter {
  Pintor3D({
    required this.escena,
    required this.t,
    required this.yaw,
    required this.pitch,
    required this.zoom,
    required this.cache,
    this.seleccionado,
    this.opacidadExtra = const {},
    this.etiquetas = const {},
  });

  /// Nombres que se dibujan sobre cada objeto (id → texto).
  final Map<String, String> etiquetas;

  final Escena3D escena;
  final double t, yaw, pitch, zoom;
  final CacheSeleccion cache;
  final String? seleccionado;
  final Map<String, double> opacidadExtra;

  static final _luz = const V3(-0.45, 0.65, -0.6).unitario();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(0, -0.2),
          radius: 1.1,
          colors: escena.fondo.reversed.toList(),
        ).createShader(rect),
    );

    final f = size.shortestSide * 1.6 * zoom;
    final cx = size.width / 2, cy = size.height / 2;
    final dist = escena.distancia;
    final elementos = <_Elemento>[];
    final seleccion = <_TrianguloProyectado>[];

    V3 vista(V3 w) => w.rotY(yaw).rotX(pitch);
    Offset proyectar(V3 v) {
      final z = math.max(0.2, v.z + dist);
      return Offset(cx + v.x * f / z, cy - v.y * f / z);
    }

    final rotulos = <(String, Offset, Color, bool)>[];
    for (final o in escena.objetos) {
      final op = (opacidadExtra[o.id] ?? o.opacidad).clamp(0.0, 1.0);
      if (op <= 0.01) continue;
      final k = o.pulso?.call(t) ?? 1.0;
      final s = o.escala * k;
      final pos = o.posicion + (o.desplazamiento?.call(t) ?? V3.cero);
      final rot = o.rotacion + (o.giro?.call(t) ?? V3.cero);
      final pts = <V3>[];
      for (final v in o.malla.vertices) {
        final w = v.mul(s).rotX(rot.x).rotY(rot.y).rotZ(rot.z) + pos;
        pts.add(vista(w));
      }
      final proy = pts.map(proyectar).toList();
      final texto = etiquetas[o.id];
      if (texto != null && !rotulos.any((r) => r.$1 == texto)) {
        var cx0 = 0.0, cy0 = 0.0;
        for (final q in proy) {
          cx0 += q.dx;
          cy0 += q.dy;
        }
        rotulos.add((
          texto,
          Offset(cx0 / proy.length, cy0 / proy.length),
          o.color,
          o.id == seleccionado,
        ));
      }
      final sel = o.id == seleccionado;
      for (final c in o.malla.caras) {
        final a = pts[c[0]], b = pts[c[1]], d = pts[c[2]];
        var n = (b - a).cross(d - a);
        if (n.largo < 1e-12) continue;
        n = n.unitario();
        final lam = n.dot(_luz).abs();
        final frente = n.z.abs();
        var shade = 0.32 + 0.68 * lam;
        var col = Color.lerp(Colors.black, o.color, shade.clamp(0.0, 1.0))!;
        final espec = math.pow(lam, 18).toDouble() * o.brillo;
        col = Color.lerp(col, Colors.white, espec)!;
        if (sel) {
          col = Color.lerp(
            col,
            const Color(0xFFFFF59D),
            0.25 + 0.15 * math.sin(t * 6),
          )!;
        }
        final alfa = op < 1 ? op * (0.55 + 0.45 * (1 - frente)) : 1.0;
        final prof = (a.z + b.z + d.z) / 3;
        elementos.add(
          _Elemento.tri(
            proy[c[0]],
            proy[c[1]],
            proy[c[2]],
            col.withValues(alpha: alfa),
            prof,
          ),
        );
        if (o.seleccionable && op > 0.3) {
          seleccion.add(
            _TrianguloProyectado(
              proy[c[0]],
              proy[c[1]],
              proy[c[2]],
              prof,
              o.id,
            ),
          );
        }
      }
    }

    final parts = escena.particulas?.call(t) ?? const [];
    for (final p in parts) {
      final v = vista(p.pos);
      final z = math.max(0.2, v.z + dist);
      elementos.add(
        _Elemento.part(proyectar(v), p.radio * f / z, p.color, v.z - 0.35),
      );
    }

    elementos.sort((a, b) => b.prof.compareTo(a.prof));

    final posiciones = <Offset>[];
    final colores = <Color>[];
    void vaciar() {
      if (posiciones.isEmpty) return;
      canvas.drawVertices(
        ui.Vertices(
          ui.VertexMode.triangles,
          List.of(posiciones),
          colors: List.of(colores),
        ),
        BlendMode.dst,
        Paint(),
      );
      posiciones.clear();
      colores.clear();
    }

    for (final e in elementos) {
      if (e.esParticula) {
        vaciar();
        canvas.drawCircle(
          e.a,
          e.radio,
          Paint()
            ..shader = RadialGradient(
              colors: [Color.lerp(e.color, Colors.white, 0.5)!, e.color],
            ).createShader(Rect.fromCircle(center: e.a, radius: e.radio)),
        );
      } else {
        posiciones
          ..add(e.a)
          ..add(e.b)
          ..add(e.c);
        colores
          ..add(e.color)
          ..add(e.color)
          ..add(e.color);
      }
    }
    vaciar();
    cache._tris = seleccion;
    for (final (texto, p, color, sel) in rotulos) {
      final tp = TextPainter(
        text: TextSpan(
          text: texto,
          style: TextStyle(
            fontSize: sel ? 13 : 10.5,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Fredoka',
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final caja = Rect.fromCenter(
        center: p + const Offset(0, -18),
        width: tp.width + 14,
        height: tp.height + 6,
      );
      canvas.drawLine(
        p,
        caja.bottomCenter,
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2,
      );
      canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);
      canvas.drawRRect(
        RRect.fromRectAndRadius(caja, const Radius.circular(10)),
        Paint()
          ..color = Color.lerp(
            color,
            Colors.black,
            0.35,
          )!
              .withValues(alpha: 0.85),
      );
      if (sel) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(caja.inflate(1.5), const Radius.circular(11)),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = const Color(0xFFFFF59D),
        );
      }
      tp.paint(canvas, caja.topLeft + const Offset(7, 3));
    }
  }

  @override
  bool shouldRepaint(covariant Pintor3D old) => true;
}
