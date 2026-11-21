import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'animaciones_tour.dart' show dibujarGloboRojo, dibujarVirus;
import 'comunes.dart';
import 'componentes.dart';
import 'dibujos_m1.dart';
import 'escenario.dart';
import 'progreso.dart';

/// Juegos de acción de las misiones 1 y 2 (como "Defensa inmune").
/// Se juegan sobre el lienzo fijo, con el dedo o el ratón.

const _area = Rect.fromLTWH(10, 60, 840, 410);

/// Base común: reloj de juego, vidas, tiempo y pantallas de inicio/fin.
abstract class _EstadoJuego<T extends StatefulWidget> extends State<T>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker = createTicker(_tick);
  double t = 0;
  double _ultimo = 0;
  bool jugando = false, terminado = false;
  int vidas = 5;

  double get duracion;
  void reiniciar();
  void paso(double dt);
  void alTerminar();

  void comenzar() {
    reiniciar();
    setState(() {
      t = 0;
      _ultimo = 0;
      vidas = 5;
      jugando = true;
      terminado = false;
    });
    _ticker
      ..stop()
      ..start();
  }

  void _tick(Duration d) {
    final ahora = d.inMicroseconds / 1e6;
    final dt = (ahora - _ultimo).clamp(0.0, 0.05);
    _ultimo = ahora;
    if (!jugando) return;
    t += dt;
    paso(dt);
    if (vidas <= 0 || t >= duracion) {
      jugando = false;
      terminado = true;
      _ticker.stop();
      alTerminar();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Widget hud({required String puntos, Widget? extra}) => Positioned(
        left: 260,
        top: 14,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              for (var v = 0; v < 5; v++)
                Icon(
                    v < vidas
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: ColoresJuego.circulatorio,
                    size: 20),
              const SizedBox(width: 12),
              Text('⏱ ${math.max(0, duracion - t).ceil()} s',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 12),
              Text(puntos,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              if (extra != null) ...[const SizedBox(width: 12), extra],
            ],
          ),
        ),
      );

  Widget capaInicio(
          {required String titulo,
          required String instrucciones,
          required Color color}) =>
      Positioned.fill(
        child: Container(
          color: Colors.black45,
          alignment: Alignment.center,
          child: Container(
            width: 560,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: color, width: 4)),
            child: Row(
              children: [
                const SizedBox(
                    width: 110, height: 150, child: ZatiMascota(tam: 150)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(terminado ? '¿Otra ronda?' : titulo,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: color)),
                      const SizedBox(height: 6),
                      Text(instrucciones,
                          style: const TextStyle(fontSize: 15, height: 1.3)),
                      const SizedBox(height: 12),
                      Tooltip(
                        message: 'Jugar',
                        child: BotonJuego(
                          texto: terminado ? 'Jugar otra vez' : '¡A jugar!',
                          icono: Icons.play_arrow_rounded,
                          color: color,
                          onTap: comenzar,
                        ),
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

// ===========================================================================
// Misión 1: Repartidor de oxígeno
// ===========================================================================

class JuegoRepartidorOxigeno extends StatefulWidget {
  const JuegoRepartidorOxigeno({super.key});
  @override
  State<JuegoRepartidorOxigeno> createState() => _JuegoRepartidorOxigenoState();
}

class _Celula {
  _Celula(this.pos);
  final Offset pos;
  double espera = -1; // -1: no necesita oxígeno
  double feliz = 0;
}

class _Coagulo {
  _Coagulo(this.x, this.y, this.vel);
  final double x;
  double y;
  double vel;
}

class _JuegoRepartidorOxigenoState
    extends _EstadoJuego<JuegoRepartidorOxigeno> {
  static const _pulmones = Rect.fromLTWH(30, 140, 170, 200);
  static const _maxCarga = 3;
  final _rnd = math.Random();
  Offset _jugador = const Offset(300, 260);
  int _carga = 0, _entregas = 0;
  double _cargando = 0, _proxima = 0, _golpe = 0;
  late List<_Celula> _celulas;
  late List<_Coagulo> _coagulos;

  @override
  double get duracion => 60;

  @override
  void reiniciar() {
    _jugador = const Offset(300, 260);
    _carga = 0;
    _entregas = 0;
    _cargando = 0;
    _proxima = 1;
    _golpe = 0;
    _celulas = [
      for (final p in const [
        Offset(610, 130),
        Offset(735, 140),
        Offset(660, 255),
        Offset(790, 270),
        Offset(620, 385),
        Offset(750, 395)
      ])
        _Celula(p),
    ];
    _coagulos = [
      _Coagulo(330, 150, 70),
      _Coagulo(440, 380, -90),
      _Coagulo(530, 230, 110)
    ];
  }

  @override
  void paso(double dt) {
    final dificultad = 1 + t / duracion;
    // Cargar oxígeno en los pulmones
    if (_pulmones.inflate(10).contains(_jugador) && _carga < _maxCarga) {
      _cargando += dt;
      if (_cargando > 0.35) {
        _cargando = 0;
        _carga++;
        HapticFeedback.selectionClick();
      }
    }
    // Células que piden oxígeno
    _proxima -= dt;
    if (_proxima <= 0) {
      final libres = _celulas.where((c) => c.espera < 0).toList();
      if (libres.isNotEmpty) libres[_rnd.nextInt(libres.length)].espera = 0;
      _proxima =
          (1.9 - 0.7 * (dificultad - 1)) * (0.7 + _rnd.nextDouble() * 0.6);
    }
    for (final c in _celulas) {
      if (c.feliz > 0) c.feliz -= dt;
      if (c.espera >= 0) {
        c.espera += dt;
        if (c.espera > 8) {
          c.espera = -1;
          vidas--;
          HapticFeedback.mediumImpact();
        } else if (_carga > 0 && (c.pos - _jugador).distance < 48) {
          _carga--;
          _entregas++;
          c.espera = -1;
          c.feliz = 1.2;
          HapticFeedback.lightImpact();
        }
      }
    }
    // Coágulos que estorban
    if (_golpe > 0) _golpe -= dt;
    for (final k in _coagulos) {
      k.y += k.vel * dt * dificultad;
      if (k.y < 90 || k.y > 450) k.vel = -k.vel;
      if (_golpe <= 0 && (Offset(k.x, k.y) - _jugador).distance < 38) {
        _golpe = 1.2;
        if (_carga > 0) _carga--;
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  void alTerminar() {
    final estrellas = vidas <= 0
        ? (_entregas >= 5 ? 1 : 0)
        : (_entregas >= 14 ? 3 : (_entregas >= 8 ? 2 : 1));
    if (estrellas == 0) return;
    terminarPaso(
      context,
      actividad: Actividades.m1Juego,
      estrellas: estrellas,
      titulo: vidas > 0 ? '¡Gran repartidor!' : '¡Buen intento!',
      mensaje:
          'Entregaste oxígeno $_entregas veces. Así trabajan tus glóbulos rojos: recogen oxígeno en los pulmones y lo llevan a las células.',
    );
  }

  void _mover(Offset p) {
    if (!jugando) return;
    _jugador = Offset(p.dx.clamp(_area.left + 20, _area.right - 20),
        p.dy.clamp(_area.top + 20, _area.bottom - 20));
  }

  @override
  Widget build(BuildContext context) {
    return Escenario(
      velo: 0.1,
      colorVelo: ColoresJuego.circulatorio,
      children: [
        Positioned.fromRect(
          rect: _area,
          child: GestureDetector(
            onPanStart: (d) => _mover(d.localPosition + _area.topLeft),
            onPanUpdate: (d) => _mover(d.localPosition + _area.topLeft),
            onTapDown: (d) => _mover(d.localPosition + _area.topLeft),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: CustomPaint(
                painter: _PintorRepartidor(
                  t: t,
                  jugador: _jugador - _area.topLeft,
                  carga: jugando || terminado ? _carga : 0,
                  celulas: jugando || terminado ? _celulas : const [],
                  coagulos: jugando || terminado ? _coagulos : const [],
                  golpe: _golpe,
                ),
                size: _area.size,
              ),
            ),
          ),
        ),
        const BotonVolverEscena(),
        const Positioned(left: 64, top: 14, child: EtiquetaSeccion('Juego')),
        hud(
          puntos: '📦 $_entregas entregas',
          extra: Row(children: [
            for (var i = 0; i < _maxCarga; i++)
              Padding(
                padding: const EdgeInsets.only(left: 2),
                child: Icon(Icons.circle,
                    size: 14,
                    color:
                        i < _carga ? const Color(0xFF1E88E5) : Colors.black12),
              ),
          ]),
        ),
        if (!jugando)
          capaInicio(
            titulo: 'Repartidor de oxígeno',
            color: ColoresJuego.circulatorio,
            instrucciones:
                '¡Eres un glóbulo rojo! Arrastra tu dedo para moverte. Pasa por los pulmones para cargar oxígeno (O₂) y llévalo a las células que se ponen azules. ¡Esquiva los coágulos amarillos!',
          ),
      ],
    );
  }
}

class _PintorRepartidor extends CustomPainter {
  _PintorRepartidor({
    required this.t,
    required this.jugador,
    required this.carga,
    required this.celulas,
    required this.coagulos,
    required this.golpe,
  });
  final double t;
  final Offset jugador;
  final int carga;
  final List<_Celula> celulas;
  final List<_Coagulo> coagulos;
  final double golpe;

  @override
  void paint(Canvas c, Size s) {
    final r = Offset.zero & s;
    c.drawRect(
        r,
        Paint()
          ..shader = const LinearGradient(
              colors: [Color(0xFFFFE4EC), Color(0xFFFFCFDD)]).createShader(r));
    // Vasos de fondo
    for (var i = 0; i < 5; i++) {
      final y = 60.0 + i * 75;
      final p = Path()..moveTo(0, y);
      for (var x = 0.0; x <= s.width; x += 20) {
        p.lineTo(x, y + math.sin(x / 90 + i) * 14);
      }
      c.drawPath(p, linea(Colors.white.withValues(alpha: 0.5), 14));
    }
    const off = Offset(-10, -60);
    final pul = _JuegoRepartidorOxigenoState._pulmones.shift(off);
    c.drawRRect(
        RRect.fromRectAndRadius(pul.inflate(10), const Radius.circular(24)),
        Paint()..color = const Color(0x332196F3));
    DibujoOrganos.pulmones(c, pul, inflado: (1 - math.cos(t * 1.6)) / 2);
    textoEn(
        c, 'Pulmones: carga O₂ aquí', pul.bottomCenter + const Offset(0, 12),
        tam: 12, color: const Color(0xFF1565C0));
    for (var k = 0; k < 4; k++) {
      final u = (t * 0.5 + k / 4) % 1;
      burbujaGas(c, pul.center + Offset(math.sin(k * 2 + t) * 50, 70 - u * 140),
          9, true);
    }
    corazonAnatomico(
        c,
        Rect.fromCenter(
            center: const Offset(390, 200), width: 110, height: 110),
        latido:
            math.exp(-math.pow((((t * 1.2) % 1) - 0.15) / 0.07, 2)).toDouble());
    for (final cel in celulas) {
      final p = cel.pos + off;
      final necesita = cel.espera >= 0;
      final urgencia = necesita ? (cel.espera / 8).clamp(0.0, 1.0) : 0.0;
      final color = necesita
          ? Color.lerp(
              const Color(0xFF90A4FF), const Color(0xFF3F51B5), urgencia)!
          : const Color(0xFFFF8FB8);
      c.drawCircle(
          p, 34 * (1 + 0.05 * math.sin(t * 4 + p.dx)), Paint()..color = color);
      c.drawCircle(p, 34, linea(oscurecer(color, 0.25), 3));
      c.drawCircle(p + const Offset(6, -4), 11,
          Paint()..color = const Color(0xFF9C4DCC));
      if (necesita) {
        c.drawArc(
            Rect.fromCircle(center: p, radius: 42),
            -math.pi / 2,
            2 * math.pi * (1 - urgencia),
            false,
            linea(const Color(0xFFFFB300), 4));
        textoEn(c, 'O₂?', p + const Offset(0, -50),
            tam: 13, color: const Color(0xFF3F51B5), fondo: Colors.white);
      }
      if (cel.feliz > 0) {
        textoEn(c, '¡Gracias!', p + Offset(0, -48 - (1.2 - cel.feliz) * 20),
            tam: 13, color: ColoresJuego.correcto);
      }
    }
    for (final k in coagulos) {
      final p = Offset(k.x, k.y) + off;
      c.drawOval(Rect.fromCenter(center: p, width: 46, height: 34),
          Paint()..color = const Color(0xFFFFD54F));
      c.drawOval(Rect.fromCenter(center: p, width: 46, height: 34),
          linea(const Color(0xFFF9A825), 3));
    }
    // Jugador
    if (golpe > 0) {
      c.drawCircle(jugador, 34,
          Paint()..color = Colors.orange.withValues(alpha: 0.35 * golpe));
    }
    dibujarGloboRojo(c, jugador, 24, oxigeno: carga / 3);
    c.drawCircle(
        jugador + const Offset(-8, -6), 4, Paint()..color = Colors.white);
    c.drawCircle(
        jugador + const Offset(8, -6), 4, Paint()..color = Colors.white);
    for (var i = 0; i < carga; i++) {
      burbujaGas(c, jugador + Offset(-22 + i * 22.0, -36), 9, true);
    }
  }

  @override
  bool shouldRepaint(_PintorRepartidor old) => true;
}

// ===========================================================================
// Misión 2: Atrapa el aire limpio
// ===========================================================================

enum _TipoCaida { oxigeno, hoja, humo, polvo, virus }

class _Caida {
  _Caida(this.tipo, this.x, this.vel);
  final _TipoCaida tipo;
  final double x;
  double y = 60;
  final double vel;
  bool atrapada = false;
  bool get buena => tipo == _TipoCaida.oxigeno || tipo == _TipoCaida.hoja;
}

class JuegoAtrapaAire extends StatefulWidget {
  const JuegoAtrapaAire({super.key});
  @override
  State<JuegoAtrapaAire> createState() => _JuegoAtrapaAireState();
}

class _JuegoAtrapaAireState extends _EstadoJuego<JuegoAtrapaAire> {
  final _rnd = math.Random();
  double _x = 430, _proxima = 0, _tos = 0;
  int _puntos = 0;
  final _caidas = <_Caida>[];
  final _mensajes = <(Offset, String, double, bool)>[];

  @override
  double get duracion => 45;

  @override
  void reiniciar() {
    _x = 430;
    _proxima = 0;
    _tos = 0;
    _puntos = 0;
    _caidas.clear();
    _mensajes.clear();
  }

  @override
  void paso(double dt) {
    final dificultad = 1 + 1.2 * t / duracion;
    _proxima -= dt;
    if (_proxima <= 0) {
      final r = _rnd.nextDouble();
      final tipo = r < 0.38
          ? _TipoCaida.oxigeno
          : r < 0.5
              ? _TipoCaida.hoja
              : r < 0.68
                  ? _TipoCaida.humo
                  : r < 0.84
                      ? _TipoCaida.polvo
                      : _TipoCaida.virus;
      _caidas.add(_Caida(tipo, 40 + _rnd.nextDouble() * 780,
          (110 + _rnd.nextDouble() * 70) * dificultad));
      _proxima = (0.85 - 0.3 * (dificultad - 1) / 1.2) *
          (0.6 + _rnd.nextDouble() * 0.7);
    }
    if (_tos > 0) _tos -= dt;
    for (final k in _caidas) {
      k.y += k.vel * dt;
      if (!k.atrapada && k.y > 380 && k.y < 440 && (k.x - _x).abs() < 70) {
        k.atrapada = true;
        if (k.buena) {
          final gana = k.tipo == _TipoCaida.hoja ? 2 : 1;
          _puntos += gana;
          _mensajes.add((Offset(k.x, 370), '+$gana', 0, true));
          HapticFeedback.selectionClick();
        } else {
          vidas--;
          _tos = 0.8;
          _mensajes.add((
            Offset(k.x, 370),
            k.tipo == _TipoCaida.virus ? '¡Achú!' : '¡Cof, cof!',
            0,
            false
          ));
          HapticFeedback.mediumImpact();
        }
      }
    }
    _caidas.removeWhere((k) => k.atrapada || k.y > 480);
    for (var i = 0; i < _mensajes.length; i++) {
      _mensajes[i] = (
        _mensajes[i].$1,
        _mensajes[i].$2,
        _mensajes[i].$3 + dt,
        _mensajes[i].$4
      );
    }
    _mensajes.removeWhere((m) => m.$3 > 0.8);
  }

  @override
  void alTerminar() {
    final estrellas = vidas <= 0
        ? (_puntos >= 10 ? 1 : 0)
        : (_puntos >= 30 ? 3 : (_puntos >= 18 ? 2 : 1));
    if (estrellas == 0) return;
    terminarPaso(
      context,
      actividad: Actividades.m2Juego,
      estrellas: estrellas,
      titulo: vidas > 0 ? '¡Pulmones felices!' : '¡Buen intento!',
      mensaje:
          'Juntaste $_puntos puntos de aire limpio. Respirar aire limpio y evitar el humo y el polvo protege tus pulmones.',
    );
  }

  void _mover(double x) {
    if (!jugando) return;
    _x = x.clamp(70.0, 790.0);
  }

  @override
  Widget build(BuildContext context) {
    return Escenario(
      velo: 0.1,
      colorVelo: ColoresJuego.respiratorio,
      children: [
        Positioned.fromRect(
          rect: _area,
          child: GestureDetector(
            onPanStart: (d) => _mover(d.localPosition.dx + _area.left),
            onPanUpdate: (d) => _mover(d.localPosition.dx + _area.left),
            onTapDown: (d) => _mover(d.localPosition.dx + _area.left),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: CustomPaint(
                size: _area.size,
                painter: _PintorAtrapa(t, _x, _caidas, _mensajes, _tos),
              ),
            ),
          ),
        ),
        const BotonVolverEscena(),
        const Positioned(left: 64, top: 14, child: EtiquetaSeccion('Juego')),
        hud(puntos: '🌿 $_puntos puntos'),
        if (!jugando)
          capaInicio(
            titulo: 'Atrapa el aire limpio',
            color: ColoresJuego.respiratorio,
            instrucciones:
                'Mueve los pulmones con tu dedo. Atrapa el oxígeno (O₂) y las hojas, que dan aire limpio. ¡Esquiva el humo, el polvo y los virus para no toser!',
          ),
      ],
    );
  }
}

class _PintorAtrapa extends CustomPainter {
  _PintorAtrapa(this.t, this.x, this.caidas, this.mensajes, this.tos);
  final double t, x, tos;
  final List<_Caida> caidas;
  final List<(Offset, String, double, bool)> mensajes;
  static const off = Offset(-10, -60);

  @override
  void paint(Canvas c, Size s) {
    final r = Offset.zero & s;
    c.drawRect(
        r,
        Paint()
          ..shader = const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFBFE9FF), Color(0xFFE8F8FF)]).createShader(r));
    for (var i = 0; i < 4; i++) {
      final cx = ((i * 230 + t * 18) % (s.width + 200)) - 100;
      for (final d in const [Offset(0, 0), Offset(30, -10), Offset(60, 0)]) {
        c.drawCircle(Offset(cx, 50.0 + i * 12) + d, 26,
            Paint()..color = Colors.white.withValues(alpha: 0.85));
      }
    }
    for (final k in caidas) {
      final p = Offset(k.x, k.y) + off;
      switch (k.tipo) {
        case _TipoCaida.oxigeno:
          burbujaGas(c, p, 16, true);
        case _TipoCaida.hoja:
          c.save();
          c.translate(p.dx, p.dy);
          c.rotate(math.sin(t * 3 + k.x) * 0.6);
          final hoja = Path()
            ..moveTo(0, -18)
            ..quadraticBezierTo(16, 0, 0, 18)
            ..quadraticBezierTo(-16, 0, 0, -18);
          c.drawPath(hoja, Paint()..color = const Color(0xFF43A047));
          c.drawLine(const Offset(0, -16), const Offset(0, 16),
              linea(const Color(0xFF1B5E20), 2));
          c.restore();
        case _TipoCaida.humo:
          for (final d in const [
            Offset(-10, 0),
            Offset(8, -6),
            Offset(10, 8),
            Offset(-4, 10)
          ]) {
            c.drawCircle(p + d, 13, Paint()..color = const Color(0xCC616161));
          }
        case _TipoCaida.polvo:
          final rnd = math.Random(k.x.toInt());
          for (var i = 0; i < 9; i++) {
            c.drawCircle(
                p +
                    Offset(
                        rnd.nextDouble() * 30 - 15, rnd.nextDouble() * 30 - 15),
                3.5,
                Paint()..color = const Color(0xFF8D6E63));
          }
        case _TipoCaida.virus:
          dibujarVirus(c, p, 12, t);
      }
    }
    // Jugador: pulmones con nariz
    final centro = Offset(x, 420) + off;
    final pul = Rect.fromCenter(center: centro, width: 120, height: 120);
    if (tos > 0) {
      c.save();
      c.translate(math.sin(t * 60) * 4 * tos, 0);
    }
    DibujoOrganos.pulmones(c, pul, inflado: (1 - math.cos(t * 2)) / 2);
    if (tos > 0) c.restore();
    for (final m in mensajes) {
      final a = (1 - m.$3 / 0.8).clamp(0.0, 1.0);
      textoEn(c, m.$2, m.$1 + off - Offset(0, 40 * m.$3),
          tam: 18,
          color: (m.$4 ? ColoresJuego.correcto : ColoresJuego.incorrecto)
              .withValues(alpha: a));
    }
  }

  @override
  bool shouldRepaint(_PintorAtrapa old) => true;
}
