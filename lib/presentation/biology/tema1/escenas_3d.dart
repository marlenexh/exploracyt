import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'motor_3d.dart';

/// Modelos 3D procedurales de los órganos y escenas de la simulación.

const _rojo = Color(0xFFD7263D);
const _rojoOscuro = Color(0xFFB71C1C);
const _azul = Color(0xFF3F51B5);
const _rosa = Color(0xFFF48FB1);
const _cartilago = Color(0xFFE3E8F5);

/// Latido: pico rápido seguido de reposo. [bpm] latidos por minuto.
double latido(double t, {double bpm = 72}) {
  final fase = (t * bpm / 60) % 1.0;
  final a = math.exp(-math.pow((fase - 0.12) / 0.06, 2));
  final b = 0.6 * math.exp(-math.pow((fase - 0.32) / 0.07, 2));
  return a + b;
}

/// Respiración: 0 = exhalado, 1 = inhalado. Periodo en segundos.
double respiracion(double t, {double periodo = 4.5}) =>
    (1 - math.cos(2 * math.pi * t / periodo)) / 2;

bool inhalando(double t, {double periodo = 4.5}) =>
    math.sin(2 * math.pi * t / periodo) > 0;

Malla mallaCorazon() => Malla.esfera(lat: 18, lon: 24).deformar((p) {
      var x = p.x, y = p.y, z = p.z;
      if (y < 0) {
        final k = math.max(0.05, 1 - 0.78 * y * y);
        x *= k;
        z *= k;
        y *= 1.3;
      } else {
        y -= math.exp(-x * x * 10) * 0.35 * y;
        x *= 1.08;
      }
      z *= 0.8;
      return V3(x, y, z);
    }).rotarZ(0.4);

Malla mallaPulmon(bool izquierdoDelPaciente) {
  // El pulmón izquierdo del paciente se ve a la derecha del observador.
  final lado = izquierdoDelPaciente ? 1.0 : -1.0;
  return Malla.esfera(lat: 16, lon: 22).deformar((p) {
    var x = p.x * 0.6, y = p.y * 1.05, z = p.z * 0.55;
    final interior = x * lado < 0;
    if (interior) x *= izquierdoDelPaciente ? 0.25 : 0.45;
    final k = 1 - 0.38 * math.max(0, p.y);
    x *= k;
    z *= k;
    if (y < -0.65) y = -0.65 + (y + 0.65) * 0.35;
    return V3(x + lado * 0.62, y, z);
  });
}

Malla mallaGloboRojo() => Malla.esfera(lat: 14, lon: 22).deformar((p) {
      final r2 = p.x * p.x + p.z * p.z;
      return V3(p.x, p.y * (0.18 + 0.45 * r2), p.z);
    });

Malla mallaGloboBlanco() => Malla.esfera(lat: 16, lon: 22).deformar((p) {
      final r = 1 +
          0.08 * math.sin(p.x * 9) * math.sin(p.y * 8) +
          0.06 * math.cos(p.z * 11);
      return p * r;
    });

Malla mallaVirus() {
  var m = Malla.esfera(lat: 12, lon: 16);
  final n = 18;
  final dorado = math.pi * (3 - math.sqrt(5));
  for (var i = 0; i < n; i++) {
    final y = 1 - (i / (n - 1)) * 2;
    final r = math.sqrt(1 - y * y);
    final th = dorado * i;
    final dir = V3(math.cos(th) * r, y, math.sin(th) * r);
    m = m.unir(Malla.tubo([dir * 0.95, dir * 1.35], 0.06, segmentos: 6));
    m = m.unir(
      Malla.esfera(
        lat: 5,
        lon: 6,
      ).escalar(const V3(0.14, 0.14, 0.14)).mover(dir * 1.4),
    );
  }
  return m;
}

Malla mallaAnticuerpo() {
  const r = 0.07;
  return Malla.unirTodas([
    Malla.tubo([const V3(0, -0.6, 0), const V3(0, 0, 0)], r, segmentos: 6),
    Malla.tubo([const V3(0, 0, 0), const V3(-0.4, 0.45, 0)], r, segmentos: 6),
    Malla.tubo([const V3(0, 0, 0), const V3(0.4, 0.45, 0)], r, segmentos: 6),
  ]);
}

// ---------------------------------------------------------------------------
// Escena: corazón
// ---------------------------------------------------------------------------

Escena3D escenaCorazon({required double Function() bpm}) {
  final aorta = curva(const [
    V3(0.1, 0.6, 0.05),
    V3(0.05, 1.35, 0.0),
    V3(0.4, 1.7, -0.15),
    V3(0.75, 1.35, -0.35),
    V3(0.75, 0.4, -0.45),
    V3(0.7, -1.7, -0.45),
  ]);
  final cavaSup = curva(const [
    V3(-0.55, 0.55, 0.0),
    V3(-0.6, 1.2, 0.0),
    V3(-0.6, 1.85, 0.0),
  ]);
  final cavaInf = curva(const [
    V3(-0.45, -0.3, -0.1),
    V3(-0.5, -1.0, -0.15),
    V3(-0.5, -1.75, -0.15),
  ]);
  final pulmonar = curva(const [
    V3(-0.1, 0.55, 0.45),
    V3(-0.05, 1.05, 0.5),
    V3(0.3, 1.25, 0.35),
    V3(1.2, 1.25, 0.1),
  ]);
  final pulmonarIzq = curva(const [
    V3(-0.03, 1.1, 0.48),
    V3(-0.5, 1.25, 0.35),
    V3(-1.2, 1.2, 0.1),
  ]);
  double pulsoCorazon(double t) => 1 + 0.06 * latido(t, bpm: bpm());

  final cuerpoSangre = <List<V3>>[
    aorta,
    cavaSup.reversed.toList(),
    cavaInf.reversed.toList(),
  ];

  return Escena3D(
    distancia: 6.5,
    objetos: [
      Objeto3D(
        id: 'corazon',
        malla: mallaCorazon(),
        color: _rojo,
        escala: const V3(0.85, 0.85, 0.85),
        pulso: pulsoCorazon,
        brillo: 0.35,
      ),
      Objeto3D(
        id: 'aorta',
        malla: Malla.tubo(aorta, 0.17, segmentos: 12),
        color: _rojoOscuro,
      ),
      Objeto3D(
        id: 'cavas',
        malla: Malla.tubo(
          cavaSup,
          0.15,
          segmentos: 12,
        ).unir(Malla.tubo(cavaInf, 0.16, segmentos: 12)),
        color: _azul,
      ),
      Objeto3D(
        id: 'pulmonar',
        malla: Malla.tubo(
          pulmonar,
          0.14,
          segmentos: 12,
          radioFinal: 0.1,
        ).unir(Malla.tubo(pulmonarIzq, 0.11, segmentos: 10, radioFinal: 0.09)),
        color: const Color(0xFF6A5ACD),
      ),
    ],
    particulas: (t) {
      final ps = <Particula3D>[];
      final v = bpm() / 72;
      for (var c = 0; c < cuerpoSangre.length; c++) {
        final camino = cuerpoSangre[c];
        final color =
            c == 0 ? const Color(0xFFFF5252) : const Color(0xFF7986CB);
        for (var i = 0; i < 7; i++) {
          final s = (t * 0.25 * v + i / 7) % 1.0;
          ps.add(Particula3D(puntoEnCamino(camino, s), color, 0.07));
        }
      }
      for (var i = 0; i < 6; i++) {
        final s = (t * 0.3 * v + i / 6) % 1.0;
        ps.add(
          Particula3D(
            puntoEnCamino(pulmonar, s),
            const Color(0xFF9FA8DA),
            0.055,
          ),
        );
      }
      return ps;
    },
  );
}

// ---------------------------------------------------------------------------
// Escena: pulmones
// ---------------------------------------------------------------------------

Escena3D escenaPulmones({required double Function() periodo}) {
  final traquea = [const V3(0, 1.9, 0), const V3(0, 0.75, 0)];
  final bronqDer = curva(const [
    V3(0, 0.75, 0),
    V3(-0.3, 0.55, 0),
    V3(-0.55, 0.25, 0),
  ]);
  final bronqIzq = curva(const [
    V3(0, 0.75, 0),
    V3(0.3, 0.55, 0),
    V3(0.6, 0.2, 0),
  ]);

  // Ramitas internas para que se vean a través de los pulmones.
  Malla ramas(double lado) {
    var m = Malla.tubo(
      curva([
        V3(0.55 * lado, 0.25, 0),
        V3(0.7 * lado, -0.2, 0.05),
        V3(0.75 * lado, -0.55, 0.1),
      ]),
      0.05,
      segmentos: 6,
    );
    m = m.unir(
      Malla.tubo(
        [V3(0.55 * lado, 0.25, 0), V3(0.5 * lado, 0.75, 0.05)],
        0.04,
        segmentos: 6,
      ),
    );
    m = m.unir(
      Malla.tubo(
        [V3(0.7 * lado, -0.2, 0.05), V3(1.0 * lado, -0.1, 0.1)],
        0.035,
        segmentos: 6,
      ),
    );
    m = m.unir(
      Malla.tubo(
        [V3(0.65 * lado, 0.05, 0), V3(0.35 * lado, -0.35, 0.1)],
        0.035,
        segmentos: 6,
      ),
    );
    return m;
  }

  double resp(double t) => respiracion(t, periodo: periodo());

  return Escena3D(
    distancia: 6.2,
    objetos: [
      Objeto3D(
        id: 'pulmones',
        malla: mallaPulmon(true).unir(mallaPulmon(false)),
        color: _rosa,
        opacidad: 0.78,
        pulso: (t) => 0.92 + 0.12 * resp(t),
        brillo: 0.2,
      ),
      Objeto3D(
        id: 'traquea',
        malla: Malla.tubo(traquea, 0.13, segmentos: 12),
        color: _cartilago,
      ),
      Objeto3D(
        id: 'bronquios',
        malla: Malla.tubo(bronqDer, 0.09, segmentos: 10)
            .unir(Malla.tubo(bronqIzq, 0.085, segmentos: 10))
            .unir(ramas(1))
            .unir(ramas(-1)),
        color: const Color(0xFFC5CAE9),
        pulso: (t) => 0.96 + 0.05 * resp(t),
      ),
      Objeto3D(
        id: 'diafragma',
        malla: Malla.esfera(
          lat: 10,
          lon: 24,
        ).deformar((p) => p.y < 0 ? V3(p.x, p.y * 0.15, p.z) : p),
        color: const Color(0xFFC0504D),
        escala: const V3(1.55, 0.4, 0.95),
        posicion: const V3(0, -1.25, 0),
        desplazamiento: (t) => V3(0, -0.22 * resp(t), 0),
      ),
    ],
    particulas: (t) {
      final ps = <Particula3D>[];
      final entra = inhalando(t, periodo: periodo());
      final caminos = [
        [...traquea, ...bronqDer.skip(1)],
        [...traquea, ...bronqIzq.skip(1)],
      ];
      for (var c = 0; c < 2; c++) {
        for (var i = 0; i < 6; i++) {
          var s = (t * 0.35 + i / 6 + c * 0.08) % 1.0;
          if (!entra) s = 1 - s;
          ps.add(
            Particula3D(
              puntoEnCamino(caminos[c], s),
              entra ? const Color(0xFF4FC3F7) : const Color(0xFF9E9E9E),
              0.06,
            ),
          );
        }
      }
      return ps;
    },
  );
}

// ---------------------------------------------------------------------------
// Escena: cuerpo completo
// ---------------------------------------------------------------------------

Escena3D escenaCuerpo() {
  const piel = Color(0xFFFFCCBC);
  Malla esf([int lat = 10, int lon = 14]) => Malla.esfera(lat: lat, lon: lon);
  final cuerpo = Malla.unirTodas([
    esf(12, 16).escalar(const V3(0.38, 0.45, 0.4)).mover(const V3(0, 2.45, 0)),
    Malla.tubo([const V3(0, 2.1, 0), const V3(0, 1.8, 0)], 0.15, segmentos: 10),
    esf(12, 18).escalar(const V3(0.78, 1.1, 0.42)).mover(const V3(0, 0.85, 0)),
    esf(
      10,
      16,
    ).escalar(const V3(0.68, 0.42, 0.38)).mover(const V3(0, -0.25, 0)),
    Malla.tubo(
      curva(const [
        V3(-0.7, 1.6, 0),
        V3(-0.95, 0.8, 0.05),
        V3(-1.05, -0.2, 0.15),
      ]),
      0.15,
      segmentos: 8,
      radioFinal: 0.11,
    ),
    Malla.tubo(
      curva(const [V3(0.7, 1.6, 0), V3(0.95, 0.8, 0.05), V3(1.05, -0.2, 0.15)]),
      0.15,
      segmentos: 8,
      radioFinal: 0.11,
    ),
    Malla.tubo(
      curva(const [
        V3(-0.35, -0.45, 0),
        V3(-0.38, -1.5, 0.02),
        V3(-0.4, -2.6, 0.05),
      ]),
      0.22,
      segmentos: 8,
      radioFinal: 0.13,
    ),
    Malla.tubo(
      curva(const [
        V3(0.35, -0.45, 0),
        V3(0.38, -1.5, 0.02),
        V3(0.4, -2.6, 0.05),
      ]),
      0.22,
      segmentos: 8,
      radioFinal: 0.13,
    ),
  ]);

  final intestino = curva(const [
    V3(-0.25, 0.15, 0.12),
    V3(0.25, 0.12, 0.15),
    V3(0.28, -0.05, 0.15),
    V3(-0.25, -0.08, 0.15),
    V3(-0.28, -0.25, 0.15),
    V3(0.25, -0.28, 0.15),
    V3(0.2, -0.42, 0.12),
    V3(-0.15, -0.45, 0.1),
  ]);
  final colon = curva(const [
    V3(-0.45, -0.5, 0.05),
    V3(-0.48, 0.28, 0.05),
    V3(0.48, 0.28, 0.05),
    V3(0.45, -0.5, 0.05),
  ]);

  return Escena3D(
    distancia: 8,
    zoomInicial: 0.95,
    objetos: [
      Objeto3D(
        id: 'piel',
        malla: cuerpo,
        color: piel,
        opacidad: 0.22,
        seleccionable: false,
        brillo: 0.1,
      ),
      Objeto3D(
        id: 'cerebro',
        malla: esf(12, 16).deformar(
          (p) => p * (1 + 0.05 * math.sin(p.x * 14) * math.cos(p.y * 12)),
        ),
        color: const Color(0xFFF8A5C2),
        escala: const V3(0.3, 0.26, 0.34),
        posicion: const V3(0, 2.55, 0),
      ),
      Objeto3D(
        id: 'pulmones',
        malla: mallaPulmon(true).unir(mallaPulmon(false)),
        color: _rosa,
        escala: const V3(0.5, 0.48, 0.5),
        posicion: const V3(0, 1.2, 0),
        pulso: (t) => 0.95 + 0.06 * respiracion(t),
      ),
      Objeto3D(
        id: 'corazon',
        malla: mallaCorazon(),
        color: _rojo,
        escala: const V3(0.2, 0.2, 0.2),
        posicion: const V3(0.1, 0.95, 0.15),
        pulso: (t) => 1 + 0.1 * latido(t),
      ),
      Objeto3D(
        id: 'higado',
        malla: esf(
          10,
          14,
        ).deformar((p) => V3(p.x, p.y * (p.x < 0 ? 1 : 0.55 - 0.3 * p.x), p.z)),
        color: const Color(0xFF8D3B2E),
        escala: const V3(0.42, 0.2, 0.28),
        posicion: const V3(-0.22, 0.48, 0.06),
      ),
      Objeto3D(
        id: 'estomago',
        malla: esf(
          10,
          14,
        ).deformar((p) => V3(p.x + 0.25 * p.y * p.y, p.y, p.z)),
        color: const Color(0xFFFFA270),
        escala: const V3(0.22, 0.18, 0.15),
        posicion: const V3(0.3, 0.4, 0.12),
        rotacion: const V3(0, 0, -0.5),
      ),
      Objeto3D(
        id: 'intestinos',
        malla: Malla.tubo(
          intestino,
          0.07,
          segmentos: 8,
        ).unir(Malla.tubo(colon, 0.1, segmentos: 8)),
        color: const Color(0xFFFFAB91),
        posicion: const V3(0, -0.05, 0),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Escena: viaje a la sangre (sistema inmunológico)
// ---------------------------------------------------------------------------

Escena3D escenaInmune() {
  final rnd = math.Random(4);
  final globulos = <Objeto3D>[];
  final globo = mallaGloboRojo();
  for (var i = 0; i < 7; i++) {
    final base = V3(
      rnd.nextDouble() * 4 - 2,
      rnd.nextDouble() * 3 - 1.5,
      rnd.nextDouble() * 2 - 1.2,
    );
    final fase = rnd.nextDouble() * 6;
    final vel = 0.25 + rnd.nextDouble() * 0.2;
    globulos.add(
      Objeto3D(
        id: 'globulo_rojo',
        malla: globo,
        color: const Color(0xFFE53935),
        escala: const V3(0.45, 0.45, 0.45),
        posicion: base,
        rotacion: V3(rnd.nextDouble() * 3, rnd.nextDouble() * 3, 0),
        desplazamiento: (t) {
          final x = ((base.x + t * vel + 2.6) % 5.2) - 2.6 - base.x;
          return V3(x, 0.15 * math.sin(t + fase), 0);
        },
        giro: (t) => V3(t * 0.4, t * 0.3, 0),
      ),
    );
  }
  final anticuerpos = <Objeto3D>[];
  final yMalla = mallaAnticuerpo();
  for (var i = 0; i < 5; i++) {
    final ang = i * 2 * math.pi / 5;
    anticuerpos.add(
      Objeto3D(
        id: 'anticuerpo',
        malla: yMalla,
        color: const Color(0xFFFFD54F),
        posicion: const V3(1.0, 0.4, 0.2),
        desplazamiento: (t) {
          final a = ang + t * 0.5;
          final r = 0.95 + 0.1 * math.sin(t * 2 + i);
          return V3(math.cos(a) * r, math.sin(a) * r, 0.3 * math.sin(a));
        },
        giro: (t) => V3(0, 0, ang + t * 0.5 - math.pi / 2),
        escala: const V3(0.6, 0.6, 0.6),
      ),
    );
  }
  return Escena3D(
    distancia: 6.5,
    fondo: const [Color(0xFF3B0A14), Color(0xFF6D1B2B)],
    objetos: [
      ...globulos,
      Objeto3D(
        id: 'globulo_blanco',
        malla: mallaGloboBlanco(),
        color: const Color(0xFFE8E3F7),
        escala: const V3(0.85, 0.85, 0.85),
        posicion: const V3(-1.1, -0.2, 0),
        giro: (t) => V3(0, t * 0.3, 0),
        desplazamiento: (t) =>
            V3(0.25 * math.sin(t * 0.4), 0.1 * math.sin(t * 0.7), 0),
        pulso: (t) => 1 + 0.03 * math.sin(t * 2.5),
      ),
      Objeto3D(
        id: 'virus',
        malla: mallaVirus(),
        color: const Color(0xFF66BB6A),
        escala: const V3(0.42, 0.42, 0.42),
        posicion: const V3(1.0, 0.4, 0.2),
        giro: (t) => V3(t * 0.3, t * 0.5, 0),
      ),
      ...anticuerpos,
      Objeto3D(
        id: 'plaqueta',
        malla: Malla.esfera(lat: 8, lon: 12),
        color: const Color(0xFFCE93D8),
        escala: const V3(0.18, 0.08, 0.14),
        posicion: const V3(-0.4, -1.4, 0.6),
        desplazamiento: (t) =>
            V3(0.3 * math.sin(t * 0.5), 0.1 * math.cos(t * 0.8), 0),
        giro: (t) => V3(t * 0.8, 0, t * 0.4),
      ),
    ],
  );
}

// ---------------------------------------------------------------------------
// Escena: partes del corazón (cavidades, válvulas, tabique y vasos)
// ---------------------------------------------------------------------------

/// [separar] (0–1) aleja las partes para ver cómo está formado el corazón.
Escena3D escenaPartesCorazon({
  required double Function() separar,
  required double Function() bpm,
}) {
  double contrae(double t, bool auricula) {
    final fase = (t * bpm() / 60) % 1.0;
    if (auricula) return math.sin(math.pi * (fase / 0.15).clamp(0.0, 1.0));
    return math.sin(math.pi * ((fase - 0.15) / 0.3).clamp(0.0, 1.0));
  }

  V3 Function(double) mover(V3 dir) => (t) => dir * (separar() * 0.75);
  final ventriculo = Malla.esfera(lat: 16, lon: 20).deformar((p) {
    final k = p.y < 0 ? math.max(0.12, 1 + p.y * 0.55) : 1.0;
    return V3(p.x * k, p.y, p.z * k);
  });
  final auricula = Malla.esfera(
    lat: 12,
    lon: 18,
  ).deformar((p) => V3(p.x * (1 + 0.08 * math.sin(p.y * 6)), p.y, p.z));

  const dirAD = V3(-1, 0.8, 0.2),
      dirAI = V3(1, 0.8, -0.2),
      dirVD = V3(-1, -0.6, 0.4),
      dirVI = V3(1, -0.7, 0);

  final aorta = curva(const [
    V3(0.22, 0.05, -0.05),
    V3(0.15, 0.95, -0.05),
    V3(0.45, 1.4, -0.15),
    V3(0.82, 1.1, -0.3),
    V3(0.85, 0.2, -0.45),
  ]);
  final pulmonar = curva(const [
    V3(-0.15, 0.05, 0.35),
    V3(-0.08, 0.8, 0.4),
    V3(0.0, 1.05, 0.35),
  ]);
  final pulmIzq = curva(const [
    V3(0.0, 1.05, 0.35),
    V3(0.45, 1.15, 0.25),
    V3(0.95, 1.1, 0.1),
  ]);
  final pulmDer = curva(const [
    V3(0.0, 1.05, 0.35),
    V3(-0.5, 1.15, 0.3),
    V3(-1.0, 1.1, 0.15),
  ]);
  final cavaSup = [const V3(-0.6, 0.75, 0.0), const V3(-0.64, 1.65, 0.0)];
  final cavaInf = [const V3(-0.5, 0.25, -0.05), const V3(-0.58, -1.3, -0.05)];

  return Escena3D(
    distancia: 6.8,
    zoomInicial: 0.95,
    objetos: [
      Objeto3D(
        id: 'auricula_der',
        malla: auricula,
        color: const Color(0xFF6A63D9),
        escala: const V3(0.48, 0.42, 0.45),
        posicion: const V3(-0.48, 0.55, 0.05),
        desplazamiento: mover(dirAD),
        pulso: (t) => 1 - 0.08 * contrae(t, true),
      ),
      Objeto3D(
        id: 'auricula_izq',
        malla: auricula,
        color: const Color(0xFFF0607A),
        escala: const V3(0.46, 0.4, 0.45),
        posicion: const V3(0.5, 0.6, -0.15),
        desplazamiento: mover(dirAI),
        pulso: (t) => 1 - 0.08 * contrae(t, true),
      ),
      Objeto3D(
        id: 'ventriculo_der',
        malla: ventriculo,
        color: const Color(0xFF3F51B5),
        escala: const V3(0.55, 0.75, 0.5),
        posicion: const V3(-0.32, -0.38, 0.15),
        rotacion: const V3(0, 0, 0.25),
        desplazamiento: mover(dirVD),
        pulso: (t) => 1 - 0.08 * contrae(t, false),
      ),
      Objeto3D(
        id: 'ventriculo_izq',
        malla: ventriculo,
        color: const Color(0xFFD7263D),
        escala: const V3(0.62, 0.88, 0.58),
        posicion: const V3(0.32, -0.45, 0.0),
        rotacion: const V3(0, 0, -0.2),
        desplazamiento: mover(dirVI),
        pulso: (t) => 1 - 0.09 * contrae(t, false),
      ),
      Objeto3D(
        id: 'tabique',
        malla: Malla.esfera(lat: 10, lon: 14),
        color: const Color(0xFFF8BBD0),
        escala: const V3(0.07, 0.8, 0.45),
        posicion: const V3(0.0, -0.2, 0.05),
      ),
      Objeto3D(
        id: 'valvulas',
        malla: Malla.esfera(lat: 8, lon: 14)
            .escalar(const V3(0.24, 0.05, 0.24))
            .mover(const V3(-0.4, 0.12, 0.1))
            .unir(
              Malla.esfera(lat: 8, lon: 14)
                  .escalar(const V3(0.24, 0.05, 0.24))
                  .mover(const V3(0.42, 0.14, -0.05)),
            )
            .unir(
              Malla.esfera(lat: 8, lon: 12)
                  .escalar(const V3(0.14, 0.04, 0.14))
                  .mover(const V3(0.2, 0.12, -0.05)),
            )
            .unir(
              Malla.esfera(lat: 8, lon: 12)
                  .escalar(const V3(0.14, 0.04, 0.14))
                  .mover(const V3(-0.15, 0.1, 0.33)),
            ),
        color: const Color(0xFFFFD54F),
        brillo: 0.5,
        giro: (t) => V3(0, 0, 0.03 * math.sin(t * 6)),
      ),
      Objeto3D(
        id: 'aorta',
        malla: Malla.tubo(aorta, 0.16, segmentos: 12),
        color: const Color(0xFFC62828),
        desplazamiento: mover(dirVI),
      ),
      Objeto3D(
        id: 'pulmonar',
        malla: Malla.tubo(pulmonar, 0.14, segmentos: 12)
            .unir(Malla.tubo(pulmIzq, 0.1, segmentos: 10))
            .unir(Malla.tubo(pulmDer, 0.1, segmentos: 10)),
        color: const Color(0xFF7E57C2),
        desplazamiento: mover(dirVD),
      ),
      Objeto3D(
        id: 'cavas',
        malla: Malla.tubo(
          cavaSup,
          0.15,
          segmentos: 12,
        ).unir(Malla.tubo(cavaInf, 0.16, segmentos: 12)),
        color: const Color(0xFF3949AB),
        desplazamiento: mover(dirAD),
      ),
      Objeto3D(
        id: 'venas_pulmonares',
        malla: Malla.tubo(
          [const V3(0.85, 0.68, -0.15), const V3(1.4, 0.78, -0.1)],
          0.07,
          segmentos: 8,
        ).unir(
          Malla.tubo(
            [const V3(0.85, 0.5, -0.2), const V3(1.4, 0.45, -0.2)],
            0.07,
            segmentos: 8,
          ),
        ),
        color: const Color(0xFFEF5350),
        desplazamiento: mover(dirAI),
      ),
    ],
  );
}
