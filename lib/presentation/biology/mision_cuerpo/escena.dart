import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'contenido.dart';

const acentos = {
  Sistema.circulatorio: Color(0xffff8597),
  Sistema.respiratorio: Color(0xff64e0d4),
  Sistema.inmunologico: Color(0xffdec0ff),
};

class EscenaCuerpo extends StatefulWidget {
  const EscenaCuerpo({
    super.key,
    this.sistema,
    this.paso = 0,
    this.nivel,
    this.reproduciendo = true,
  });

  final Sistema? sistema;
  final int paso;
  final double? nivel;
  final bool reproduciendo;

  @override
  State<EscenaCuerpo> createState() => _EscenaCuerpoState();
}

class _EscenaCuerpoState extends State<EscenaCuerpo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _tiempo;
  double _giro = -.22;
  double _inclinacion = .08;

  @override
  void initState() {
    super.initState();
    _tiempo = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
  }

  void _actualizarAnimacion() {
    if (widget.reproduciendo && !MediaQuery.disableAnimationsOf(context)) {
      if (!_tiempo.isAnimating) _tiempo.repeat();
    } else {
      _tiempo.stop();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _actualizarAnimacion();
  }

  @override
  void didUpdateWidget(covariant EscenaCuerpo oldWidget) {
    super.didUpdateWidget(oldWidget);
    _actualizarAnimacion();
  }

  @override
  void dispose() {
    _tiempo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: ColoredBox(
        color: const Color(0xff101f35),
        child: SizedBox(
          height: 280,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Semantics(
                  label: 'Modelo tridimensional esquemático. Arrastra para girarlo.',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanUpdate: (event) => setState(() {
                      _giro += event.delta.dx * .014;
                      _inclinacion = (_inclinacion + event.delta.dy * .012)
                          .clamp(-1.2, 1.2)
                          .toDouble();
                    }),
                    child: CustomPaint(
                      painter: _Modelo(
                        widget.sistema,
                        widget.paso,
                        widget.nivel,
                        _giro,
                        _inclinacion,
                        _tiempo,
                      ),
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: 16,
                left: 16,
                child: Text(
                  'MODELO 3D',
                  style: TextStyle(
                    color: Color(0xffb7cce8),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Girar modelo',
                      onPressed: () => setState(() => _giro += math.pi / 6),
                      icon: const Icon(Icons.rotate_right),
                    ),
                    IconButton(
                      tooltip: 'Restablecer vista',
                      onPressed: () => setState(() {
                        _giro = -.22;
                        _inclinacion = .08;
                      }),
                      icon: const Icon(Icons.center_focus_strong_outlined),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _Punto = ({double x, double y, double z});
_Punto _p(double x, double y, [double z = 0]) => (x: x, y: y, z: z);
typedef _Cara = ({List<_Punto> vertices, Color color});

class _Modelo extends CustomPainter {
  _Modelo(
    this.sistema,
    this.paso,
    this.nivel,
    this.giro,
    this.inclinacion,
    this.tiempo,
  ) : super(repaint: tiempo);
  final Sistema? sistema;
  final int paso;
  final double? nivel;
  final double giro;
  final double inclinacion;
  final Animation<double> tiempo;

  static const rosa = Color(0xffef5979);
  static const coral = Color(0xffff947e);
  static const violeta = Color(0xffaa8aff);
  static const turquesa = Color(0xff4fe2cf);
  static const azul = Color(0xff45678c);

  _Punto _rotar(_Punto p) {
    final x = p.x * math.cos(giro) + p.z * math.sin(giro);
    final z = -p.x * math.sin(giro) + p.z * math.cos(giro);
    return _p(
      x,
      p.y * math.cos(inclinacion) - z * math.sin(inclinacion),
      p.y * math.sin(inclinacion) + z * math.cos(inclinacion),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final escala = math.min(size.width / 6.4, size.height / 6.0);
    final centro = Offset(size.width / 2, size.height / 2 + 4);
    final pincel = Paint();
    final caras = <_Cara>[];
    final t = tiempo.value;

    Offset proyectar(_Punto p) {
      final perspectiva = 8 / (8 - p.z);
      return centro + Offset(p.x, p.y) * (escala * perspectiva);
    }

    void elipsoide(
      _Punto centro,
      double rx,
      double ry,
      double rz,
      Color color,
    ) {
      final bandas = rx < .1 ? 3 : 8;
      final sectores = rx < .1 ? 6 : 12;
      final centroRotado = _rotar(centro);
      final malla = List.generate(bandas + 1, (i) {
        final lat = math.pi * i / bandas;
        return List.generate(sectores, (j) {
          final lon = 2 * math.pi * j / sectores;
          return _rotar(
            _p(
              centro.x + rx * math.sin(lat) * math.cos(lon),
              centro.y + ry * math.cos(lat),
              centro.z + rz * math.sin(lat) * math.sin(lon),
            ),
          );
        });
      });
      for (var i = 0; i < bandas; i++) {
        for (var j = 0; j < sectores; j++) {
          final k = (j + 1) % sectores;
          final a = malla[i][j], b = malla[i + 1][j];
          final c = malla[i + 1][k], d = malla[i][k];
          final luz =
              (((a.z + b.z + c.z + d.z) / 4 - centroRotado.z) /
                      math.max(rx, math.max(ry, rz)))
                  .clamp(-1.0, 1.0);
          final sombra = luz >= 0
              ? Color.lerp(color, Colors.white, luz * .31)!
              : Color.lerp(color, const Color(0xff101f35), -luz * .58)!;
          caras.add((vertices: [a, b, c, d], color: sombra));
        }
      }
    }

    void ruta(
      List<_Punto> puntos,
      Color color, {
      int vueltas = 4,
      bool activa = true,
      bool particula = true,
    }) {
      if (!activa) color = Color.lerp(color, const Color(0xff18263e), .72)!;
      final segmentos = puntos.length - 1;
      for (var i = 0; i < segmentos; i++) {
        final a = puntos[i], b = puntos[i + 1];
        final distancia = math.sqrt(
          math.pow(b.x - a.x, 2) +
              math.pow(b.y - a.y, 2) +
              math.pow(b.z - a.z, 2),
        );
        final muestras = math.max(2, (distancia / .14).ceil());
        for (var j = 0; j <= muestras; j++) {
          final f = j / muestras;
          elipsoide(
            _p(
              a.x + (b.x - a.x) * f,
              a.y + (b.y - a.y) * f,
              a.z + (b.z - a.z) * f,
            ),
            .09,
            .09,
            .09,
            color,
          );
        }
      }
      if (activa && particula) {
        final avance = (t * vueltas % 1) * segmentos;
        final i = avance.floor();
        final f = avance - i;
        final a = puntos[i], b = puntos[i + 1];
        elipsoide(
          _p(
            a.x + (b.x - a.x) * f,
            a.y + (b.y - a.y) * f,
            a.z + (b.z - a.z) * f,
          ),
          .19,
          .14,
          .15,
          const Color(0xfffff1b1),
        );
      }
    }

    for (var x = 16.0; x < size.width; x += 20) {
      for (var y = 12.0; y < size.height; y += 20) {
        canvas.drawCircle(
          Offset(x, y),
          .85,
          pincel..color = const Color(0xff2a3b54),
        );
      }
    }

    switch (sistema) {
      case null:
        elipsoide(_p(0, -1.85), .43, .49, .36, azul);
        elipsoide(_p(0, -.55), .77, 1.01, .40, azul);
        for (final lado in [-1.0, 1.0]) {
          elipsoide(_p(lado * .91, -.35), .19, .83, .19, azul);
          elipsoide(_p(lado * .36, 1.31), .26, .98, .26, azul);
          elipsoide(_p(lado * .32, -.71, .35), .23, .39, .15, turquesa);
          elipsoide(_p(lado * .55, .05, .42), .10, .10, .10, violeta);
        }
        final latido = 1 + .13 * math.sin(t * 24 * math.pi);
        elipsoide(
          _p(.09, -.43, .56),
          .22 * latido,
          .26 * latido,
          .17 * latido,
          rosa,
        );
        break;
      case Sistema.circulatorio:
        final vueltas = 4 + ((nivel ?? 0) * 7).round();
        final bpm = 72 + (nivel ?? 0) * 72;
        final pulso = 1 + .11 * math.sin(t * 12 * bpm / 60 * 2 * math.pi);
        final derecho = _p(-.28, .23, .55), izquierdo = _p(.3, .24, .62);
        final pulmon = _p(0, -1.7, .15), tejidos = _p(0, 1.88, .05);
        ruta(
          [derecho, _p(-1.45, -.3, .1), _p(-1.45, -1.35), pulmon],
          violeta,
          vueltas: vueltas,
          activa: nivel != null || paso == 0,
        );
        ruta(
          [pulmon, _p(1.45, -1.35), _p(1.45, -.3, .1), izquierdo],
          coral,
          vueltas: vueltas,
          activa: nivel != null || paso == 1,
        );
        ruta(
          [izquierdo, _p(1.48, .73, .1), _p(1.32, 1.62), tejidos],
          coral,
          vueltas: vueltas,
          activa: nivel != null || paso == 2,
        );
        ruta(
          [tejidos, _p(-1.32, 1.62), _p(-1.48, .73, .1), derecho],
          violeta,
          vueltas: vueltas,
          activa: nivel != null || paso == 2,
        );
        elipsoide(pulmon, .49, .27, .24, turquesa);
        elipsoide(tejidos, .46, .25, .25, azul);
        elipsoide(derecho, .51 * pulso, .66 * pulso, .46 * pulso, rosa);
        elipsoide(izquierdo, .53 * pulso, .72 * pulso, .50 * pulso, coral);
        break;
      case Sistema.respiratorio:
        final aire = nivel ?? (.5 - .5 * math.cos(t * 6 * math.pi));
        final expansion = .82 + aire * .31;
        for (final lado in [-1.0, 1.0]) {
          elipsoide(
            _p(lado * .8, .08),
            .63 * expansion,
            1.04 * expansion,
            .55 * expansion,
            paso == 1 && nivel == null ? azul : turquesa,
          );
          ruta(
            [
              _p(0, -1.64, .38),
              _p(0, -.57, .51),
              _p(lado * .56, -.2, .60),
              _p(lado * .9, .18, .63),
            ],
            azul,
            activa: paso == 0 && nivel == null,
          );
          if (paso == 1 && nivel == null) {
            for (var i = 0; i < 5; i++) {
              final angulo = i * 2 * math.pi / 5;
              elipsoide(
                _p(
                  lado * .88 + .21 * math.cos(angulo),
                  .36 + .22 * math.sin(angulo),
                  .66,
                ),
                .20,
                .20,
                .23,
                coral,
              );
            }
            ruta(
              [
                _p(lado * .83, .38, .92),
                _p(lado * 1.23, .60, 1.03),
                _p(lado * 1.52, .94, 1.1),
              ],
              violeta,
              vueltas: 4,
            );
          }
        }
        final base = 1.24 + aire * .52;
        ruta(
          [
            for (var i = 0; i <= 14; i++)
              _p(
                -1.52 + i * .217,
                base - (.54 - .44 * aire) * math.sin(i * math.pi / 14),
                .40,
              ),
          ],
          coral,
          activa: paso == 2 || nivel != null,
          particula: false,
        );
        break;
      case Sistema.inmunologico:
        if (paso == 0 && nivel == null) {
          for (var x = -2; x <= 2; x++) {
            for (var z = -1; z <= 1; z++) {
              elipsoide(_p(x * .66, .47, z * .55), .37, .20, .32, rosa);
            }
          }
          final rebote = math.sin(t * 8 * math.pi).abs();
          elipsoide(_p(-.72, -.03 - rebote * .92, .43), .29, .29, .29, violeta);
          elipsoide(_p(.78, -.04 - rebote * .60, -.41), .24, .24, .24, violeta);
        } else {
          final memoria = nivel != null ? nivel! >= .5 : paso == 2;
          final ciclo = (t * 2) % 1;
          final llegada = (ciclo / (memoria ? .31 : .68)).clamp(0.0, 1.0);
          final x = -1.65 + llegada * 2.03;
          elipsoide(_p(x, .03), .79, .68, .73, turquesa);
          elipsoide(_p(x - .12, .08, .59), .32, .30, .22, azul);
          if (llegada < .93) {
            elipsoide(_p(1.08, .04, .12), .31, .31, .31, violeta);
            for (var i = 0; i < 6; i++) {
              final a = i * math.pi / 3;
              elipsoide(
                _p(1.08 + math.cos(a) * .31, .04 + math.sin(a) * .31, .22),
                .11,
                .11,
                .11,
                violeta,
              );
            }
          }
          if (memoria) {
            elipsoide(_p(-1.31, -1.10, -.23), .31, .31, .31, coral);
          }
        }
        break;
    }

    double profundidad(_Cara cara) =>
        cara.vertices.fold(0.0, (suma, p) => suma + p.z);
    caras.sort((a, b) => profundidad(a).compareTo(profundidad(b)));
    for (final cara in caras) {
      final path = Path()
        ..addPolygon(cara.vertices.map(proyectar).toList(), true);
      canvas.drawPath(path, pincel..color = cara.color);
    }
  }

  @override
  bool shouldRepaint(covariant _Modelo oldDelegate) =>
      oldDelegate.sistema != sistema ||
      oldDelegate.paso != paso ||
      oldDelegate.nivel != nivel ||
      oldDelegate.giro != giro ||
      oldDelegate.inclinacion != inclinacion ||
      oldDelegate.tiempo != tiempo;
}
