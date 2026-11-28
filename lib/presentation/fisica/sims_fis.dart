import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/componentes.dart' show terminarPaso;
import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';
import '../ciencia/sim_comun.dart';

Widget _siguiente(BuildContext context, String actividad, String titulo, String mensaje) => Positioned(
      left: 690,
      top: 420,
      child: BotonSiguiente(onTap: () => terminarPaso(context, actividad: actividad, estrellas: 3, titulo: titulo, mensaje: mensaje)),
    );

void _imanBarra(Canvas c, Offset centro, double w, double h, bool norteIzq) {
  final iz = Rect.fromLTWH(centro.dx - w / 2, centro.dy - h / 2, w / 2, h);
  final de = Rect.fromLTWH(centro.dx, centro.dy - h / 2, w / 2, h);
  c.drawRRect(RRect.fromRectAndCorners(iz, topLeft: const Radius.circular(8), bottomLeft: const Radius.circular(8)),
      relleno(norteIzq ? const Color(0xFFE53935) : const Color(0xFF1E88E5)));
  c.drawRRect(RRect.fromRectAndCorners(de, topRight: const Radius.circular(8), bottomRight: const Radius.circular(8)),
      relleno(norteIzq ? const Color(0xFF1E88E5) : const Color(0xFFE53935)));
  textoEn(c, norteIzq ? 'N' : 'S', iz.center, tam: h * 0.45, color: Colors.white);
  textoEn(c, norteIzq ? 'S' : 'N', de.center, tam: h * 0.45, color: Colors.white);
}

// ===========================================================================
// Imanes: atracción, repulsión y brújula
// ===========================================================================

class SimImanes extends StatefulWidget {
  const SimImanes({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimImanes> createState() => SimImanesState();
}

class SimImanesState extends State<SimImanes> with ObjetivosSim {
  double distancia = 1;
  bool volteado = false;
  bool brujula = false;
  static const metas = ['Acerca polos diferentes (N y S): se atraen', 'Voltea el imán y acerca polos iguales: se repelen', 'Acerca la brújula al imán'];

  /// El imán de la izquierda tiene su S a la derecha. El de la derecha muestra N a la izquierda si no está volteado.
  bool get atraen => !volteado;

  void cambiar({double? d, bool? v, bool? b}) => setState(() {
        distancia = d ?? distancia;
        volteado = v ?? volteado;
        brujula = b ?? brujula;
        if (distancia < 0.3) lograr(atraen ? 0 : 1);
        if (brujula) lograr(2);
      });

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final cerca = distancia < 0.3;
    final msg = listo
        ? '¡Lo comprobaste! Polos diferentes se atraen y polos iguales se repelen. La aguja de la brújula es un pequeño imán.'
        : cerca
            ? (atraen
                ? '¡Se atraen! El polo sur de un imán y el polo norte del otro se jalan.'
                : '¡Se repelen! Dos polos iguales se empujan. Siente cómo “se escapa” el imán.')
            : 'Todo imán tiene dos polos: norte (N) y sur (S). Mueve el imán de la derecha para acercarlo. ¿Qué pasa?';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'Polos magnéticos', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 270,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18), child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorImanes(distancia, volteado, brujula, t)))),
        ),
        Positioned(
          left: 244,
          top: 336,
          width: 608,
          height: 76,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95), borderRadius: BorderRadius.circular(14), border: Border.all(color: widget.color, width: 2)),
            child: Row(children: [
              Expanded(child: deslizador(context, '↔️', 'Distancia', distancia, (d) => cambiar(d: d), widget.color)),
              Tooltip(
                  message: 'Voltear imán',
                  child: ChipEle(texto: '🔄 Voltear imán', activo: volteado, color: const Color(0xFF7E57C2), onTap: () => cambiar(v: !volteado))),
              const SizedBox(width: 6),
              Tooltip(
                  message: 'Brújula', child: ChipEle(texto: '🧭 Brújula', activo: brujula, color: const Color(0xFF00897B), onTap: () => cambiar(b: !brujula))),
            ]),
          ),
        ),
        if (listo) _siguiente(context, widget.actividad, '¡Polos magnéticos!', 'Descubriste cómo se comportan los polos de los imanes.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorImanes extends CustomPainter {
  _PintorImanes(this.d, this.volteado, this.brujula, this.t);
  final double d, t;
  final bool volteado, brujula;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFFF3E5F5)));
    final y = 120.0;
    final a = Offset(150, y);
    var gap = 20 + d * 170;
    final cerca = d < 0.3;
    if (cerca && !volteado) gap = 0;
    if (cerca && volteado) gap = 40 + math.sin(t * 20).abs() * 10;
    final b = Offset(a.dx + 160 + gap, y);
    // Líneas de campo
    for (var k = 1; k <= 4; k++) {
      c.drawOval(Rect.fromCenter(center: a, width: 160 + k * 40, height: k * 40.0), linea(const Color(0x33B39DDB), 1.5));
    }
    _imanBarra(c, a, 160, 56, true);
    _imanBarra(c, b, 160, 56, !volteado);
    if (cerca) {
      final m = Offset((a.dx + b.dx) / 2, y - 60);
      textoEn(c, volteado ? '⬅️ ¡Se repelen! ➡️' : '➡️ ¡Se atraen! ⬅️', m,
          tam: 18, color: Colors.white, fondo: volteado ? const Color(0xFFE53935) : const Color(0xFF43A047));
    }
    // Brújula
    final br = Offset(s.width - 90, 210);
    c.drawCircle(br, 44, relleno(Colors.white));
    c.drawCircle(br, 44, linea(const Color(0xFF8D6E63), 5));
    textoEn(c, 'N', br + const Offset(0, -32), tam: 12, color: const Color(0xFFE53935));
    // Sin imán apunta al norte (arriba); cerca del imán apunta hacia él.
    final ang = brujula ? math.atan2(y - br.dy, b.dx + 80 - br.dx) + math.sin(t * 3) * 0.05 : -math.pi / 2 + math.sin(t * 2) * 0.08;
    final punta = br + Offset(math.cos(ang), math.sin(ang)) * 34;
    final cola = br - Offset(math.cos(ang), math.sin(ang)) * 34;
    c.drawLine(br, punta, linea(const Color(0xFFE53935), 6)..strokeCap = StrokeCap.round);
    c.drawLine(br, cola, linea(const Color(0xFF90A4AE), 6)..strokeCap = StrokeCap.round);
    c.drawCircle(br, 5, relleno(const Color(0xFF37474F)));
    textoEn(c, brujula ? 'Brújula junto al imán' : 'Brújula sola: apunta al norte', br + const Offset(0, 58), tam: 11, color: const Color(0xFF4A148C));
  }

  @override
  bool shouldRepaint(_PintorImanes old) => true;
}

// ===========================================================================
// Caída de los objetos: con aire (Tierra) y sin aire (Luna)
// ===========================================================================

const objetosCaida = [('Piedra', '🪨', 0.0), ('Pluma', '🪶', 3.0), ('Hoja lisa', '📄', 1.6), ('Hoja arrugada', '🧻', 0.15), ('Pelota', '⚽', 0.05)];

class SimCaida extends StatefulWidget {
  const SimCaida({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimCaida> createState() => SimCaidaState();
}

class SimCaidaState extends State<SimCaida> with ObjetivosSim {
  int izq = 0, der = 1;
  bool luna = false;
  double _t = -1;
  Timer? _timer;
  static const metas = [
    'En la Tierra, suelta la piedra y la pluma',
    'En la Luna (sin aire), suelta la piedra y la pluma',
    'En la Tierra, compara la hoja lisa con la hoja arrugada',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Segundos que tarda en caer 2 metros.
  double tiempo(int obj) {
    final g = luna ? 1.62 : 9.8;
    final base = math.sqrt(2 * 2 / g);
    return luna ? base : base * (1 + objetosCaida[obj].$3);
  }

  void soltar() {
    _timer?.cancel();
    setState(() => _t = 0);
    final fin = math.max(tiempo(izq), tiempo(der)) + 0.3;
    _timer = Timer.periodic(const Duration(milliseconds: 40), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        _t += 0.04;
        if (_t >= fin) {
          tm.cancel();
          final par = {izq, der};
          if (par.containsAll({0, 1})) lograr(luna ? 1 : 0);
          if (!luna && par.containsAll({2, 3})) lograr(2);
        }
      });
    });
  }

  void elegir({int? i, int? d, bool? l}) {
    _timer?.cancel();
    setState(() {
      izq = i ?? izq;
      der = d ?? der;
      luna = l ?? luna;
      _t = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Excelente! La gravedad jala igual a todos los objetos. En la Tierra el aire frena a los objetos ligeros y extendidos, como la pluma. En la Luna no hay aire: ¡caen al mismo tiempo!'
        : 'La gravedad hace que los objetos caigan hacia el suelo. Elige dos objetos y el lugar, y presiona “Soltar”. ¿Cuál llega primero?';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', '¿Cuál cae primero?', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 280,
          child: ClipRRect(borderRadius: BorderRadius.circular(18), child: CustomPaint(painter: _PintorCaida(this))),
        ),
        Positioned(
          left: 244,
          top: 344,
          width: 608,
          child: Wrap(spacing: 4, runSpacing: 4, children: [
            Tooltip(
                message: 'Tierra', child: ChipEle(texto: '🌍 Tierra (con aire)', activo: !luna, color: const Color(0xFF43A047), onTap: () => elegir(l: false))),
            Tooltip(message: 'Luna', child: ChipEle(texto: '🌕 Luna (sin aire)', activo: luna, color: const Color(0xFF607D8B), onTap: () => elegir(l: true))),
            const SizedBox(width: 10),
            for (var k = 0; k < objetosCaida.length; k++)
              Tooltip(
                message: 'Izquierda ${objetosCaida[k].$1}',
                child: ChipEle(texto: objetosCaida[k].$2, activo: izq == k, color: const Color(0xFF1E88E5), onTap: () => elegir(i: k)),
              ),
            const Text('  vs  ', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
            for (var k = 0; k < objetosCaida.length; k++)
              Tooltip(
                message: 'Derecha ${objetosCaida[k].$1}',
                child: ChipEle(texto: objetosCaida[k].$2, activo: der == k, color: const Color(0xFFE53935), onTap: () => elegir(d: k)),
              ),
          ]),
        ),
        Positioned(
          left: 470,
          top: 418,
          child: Tooltip(
              message: 'Soltar', child: BotonJuego(texto: 'Soltar', icono: Icons.arrow_downward_rounded, color: const Color(0xFFF5B400), onTap: soltar)),
        ),
        if (listo) _siguiente(context, widget.actividad, '¡Caída libre!', 'Comprobaste cómo caen los objetos con y sin aire.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorCaida extends CustomPainter {
  _PintorCaida(this.s);
  final SimCaidaState s;
  @override
  void paint(Canvas c, Size z) {
    c.drawRect(Offset.zero & z, relleno(s.luna ? const Color(0xFF1A1A2E) : const Color(0xFFB3E5FC)));
    c.drawRect(Rect.fromLTWH(0, z.height - 30, z.width, 30), relleno(s.luna ? const Color(0xFF9E9E9E) : const Color(0xFF8BC34A)));
    if (s.luna) {
      for (var k = 0; k < 25; k++) {
        c.drawCircle(Offset((k * 97 % 600).toDouble(), (k * 53 % 180).toDouble()), 1.2, relleno(Colors.white70));
      }
    }
    const alto = 40.0;
    final suelo = z.height - 52;
    for (final (lado, obj, x) in [(0, s.izq, z.width * 0.33), (1, s.der, z.width * 0.67)]) {
      final tt = s.tiempo(obj);
      final f = s._t < 0 ? 0.0 : (s._t / tt).clamp(0.0, 1.0);
      final y = alto + (suelo - alto) * f * f;
      final bambolea = (!s.luna && objetosCaida[obj].$3 > 1 && f < 1) ? math.sin(s._t * 6) * 14 : 0.0;
      dibujarEmoji(c, objetosCaida[obj].$2, Offset(x + bambolea, y), 44);
      textoEn(c, objetosCaida[obj].$1, Offset(x, z.height - 14),
          tam: 13, color: Colors.white, fondo: lado == 0 ? const Color(0xFF1E88E5) : const Color(0xFFE53935));
      if (s._t >= tt) textoEn(c, '${tt.toStringAsFixed(1)} s', Offset(x + 50, suelo), tam: 13, color: Colors.white, fondo: const Color(0xAA000000));
    }
    textoEn(c, s.luna ? '🌕 Gravedad de la Luna: 6 veces menor' : '🌍 Gravedad de la Tierra', Offset(z.width / 2, 18),
        tam: 13, color: Colors.white, fondo: const Color(0x88000000));
  }

  @override
  bool shouldRepaint(_PintorCaida old) => true;
}

// ===========================================================================
// Calor: conducción entre dos bloques
// ===========================================================================

const materialesCalor = [('Metal', '🔩', 1.0), ('Vidrio', '🫙', 0.3), ('Madera', '🪵', 0.08)];

class SimCalor extends StatefulWidget {
  const SimCalor({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimCalor> createState() => SimCalorState();
}

class SimCalorState extends State<SimCalor> with ObjetivosSim {
  int material = 0;
  double caliente = 80, frio = 10, _seg = 0;
  bool juntos = false;
  Timer? _timer;
  static const metas = [
    'Junta los bloques: el calor pasa del caliente al frío',
    'Con metal, las temperaturas se igualan rápido',
    'Con madera, el calor pasa muy lento'
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void juntar() {
    _timer?.cancel();
    setState(() {
      caliente = 80;
      frio = 10;
      _seg = 0;
      juntos = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        _seg += 0.1;
        final k = materialesCalor[material].$3 * 0.08;
        final flujo = (caliente - frio) * k;
        caliente -= flujo;
        frio += flujo;
        if (_seg > 1) lograr(0);
        if (material == 0 && (caliente - frio) < 3) lograr(1);
        if (material == 2 && _seg > 4 && (caliente - frio) > 40) lograr(2);
        if ((caliente - frio) < 1 || _seg > 8) tm.cancel();
      });
    });
  }

  void elegir(int m) {
    _timer?.cancel();
    setState(() {
      material = m;
      juntos = false;
      caliente = 80;
      frio = 10;
      _seg = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Muy bien! El calor siempre pasa del cuerpo más caliente al más frío hasta que tienen la misma temperatura. Los metales son buenos conductores; la madera es aislante.'
        : 'Un bloque está a 80 °C y el otro a 10 °C. Elige un material y presiona “Juntar”. Observa las temperaturas.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'El viaje del calor', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 290,
          child: ClipRRect(borderRadius: BorderRadius.circular(18), child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorCalor(this, t)))),
        ),
        Positioned(
          left: 244,
          top: 358,
          width: 608,
          child: Wrap(spacing: 6, children: [
            for (var k = 0; k < materialesCalor.length; k++)
              Tooltip(
                  message: materialesCalor[k].$1,
                  child:
                      ChipEle(texto: '${materialesCalor[k].$2} ${materialesCalor[k].$1}', activo: material == k, color: widget.color, onTap: () => elegir(k))),
          ]),
        ),
        Positioned(
            left: 470,
            top: 418,
            child: Tooltip(
                message: 'Juntar', child: BotonJuego(texto: 'Juntar', icono: Icons.compare_arrows_rounded, color: const Color(0xFFF5B400), onTap: juntar))),
        if (listo) _siguiente(context, widget.actividad, '¡El viaje del calor!', 'Comprobaste cómo se transfiere el calor.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorCalor extends CustomPainter {
  _PintorCalor(this.s, this.t);
  final SimCalorState s;
  final double t;
  Color _col(double temp) => Color.lerp(const Color(0xFF42A5F5), const Color(0xFFE53935), ((temp - 10) / 70).clamp(0, 1))!;
  @override
  void paint(Canvas c, Size z) {
    c.drawRect(Offset.zero & z, relleno(const Color(0xFFFFF8E1)));
    final sep = s.juntos ? 0.0 : 60.0;
    final a = Rect.fromLTWH(z.width / 2 - 170 - sep / 2, 60, 170, 130);
    final b = Rect.fromLTWH(z.width / 2 + sep / 2, 60, 170, 130);
    for (final (r, temp) in [(a, s.caliente), (b, s.frio)]) {
      c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)), relleno(_col(temp)));
      c.drawRRect(RRect.fromRectAndRadius(r, const Radius.circular(10)), linea(const Color(0x55000000), 2));
      textoEn(c, '${temp.toStringAsFixed(0)} °C', r.center, tam: 26, color: Colors.white);
      dibujarEmoji(c, materialesCalor[s.material].$2, r.topLeft + const Offset(22, 22), 26);
    }
    if (s.juntos && s.caliente - s.frio > 1) {
      for (var k = 0; k < 4; k++) {
        final f = (t * 0.8 + k / 4) % 1;
        final x = a.center.dx + (b.center.dx - a.center.dx) * f;
        c.drawCircle(Offset(x, a.center.dy + 50), 6, relleno(Color.fromARGB((255 * (1 - f)).round(), 255, 112, 67)));
      }
      textoEn(c, 'calor ➡️', Offset(z.width / 2, 40), tam: 16, color: Colors.white, fondo: const Color(0xFFFF7043));
    }
    textoEn(c, 'Material: ${materialesCalor[s.material].$1}   ·   tiempo: ${s._seg.toStringAsFixed(1)} min', Offset(z.width / 2, z.height - 70),
        tam: 14, color: const Color(0xFF5D4037));
    final dif = s.caliente - s.frio;
    textoEn(c, dif < 3 ? '¡Misma temperatura: equilibrio térmico!' : 'Diferencia: ${dif.toStringAsFixed(0)} °C', Offset(z.width / 2, z.height - 36),
        tam: 15, color: Colors.white, fondo: dif < 3 ? const Color(0xFF43A047) : const Color(0xFF8D6E63));
  }

  @override
  bool shouldRepaint(_PintorCalor old) => true;
}

// ===========================================================================
// Ahorro de energía en casa
// ===========================================================================

class Aparato {
  const Aparato(this.nombre, this.emoji, this.watts, {this.necesario = false, this.x = 0, this.y = 0});
  final String nombre, emoji;
  final int watts;
  final bool necesario;
  final double x, y;
}

const aparatosCasa = [
  Aparato('Refrigerador', '🧊', 150, necesario: true, x: 0.12, y: 0.68),
  Aparato('Foco de la cocina', '💡', 100, x: 0.2, y: 0.22),
  Aparato('Foco de la sala', '💡', 100, x: 0.5, y: 0.22),
  Aparato('Foco del cuarto', '💡', 100, x: 0.8, y: 0.22),
  Aparato('Televisión sola', '📺', 120, x: 0.45, y: 0.62),
  Aparato('Computadora sin usar', '💻', 80, x: 0.62, y: 0.66),
  Aparato('Cargador conectado', '🔌', 10, x: 0.75, y: 0.72),
  Aparato('Plancha', '🧺', 1000, x: 0.88, y: 0.62),
];

class SimAhorro extends StatefulWidget {
  const SimAhorro({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimAhorro> createState() => SimAhorroState();
}

class SimAhorroState extends State<SimAhorro> with ObjetivosSim {
  final encendidos = List<bool>.filled(aparatosCasa.length, true);
  bool led = false;
  static const metas = ['Apaga lo que nadie está usando', 'Cambia los focos por focos LED', 'Deja encendido el refrigerador', 'Gasta menos de 300 watts'];

  int get consumo {
    var w = 0;
    for (var i = 0; i < aparatosCasa.length; i++) {
      if (!encendidos[i]) continue;
      final a = aparatosCasa[i];
      w += a.emoji == '💡' && led ? 15 : a.watts;
    }
    return w;
  }

  void _revisar() {
    final innecesarios = [
      for (var i = 0; i < aparatosCasa.length; i++)
        if (!aparatosCasa[i].necesario && aparatosCasa[i].emoji != '💡') i
    ];
    if (innecesarios.every((i) => !encendidos[i])) lograr(0);
    if (led) lograr(1);
    if (encendidos[0] && hechas.contains(0)) lograr(2);
    if (encendidos[0] && consumo < 300) lograr(3);
  }

  void alternar(int i) => setState(() {
        encendidos[i] = !encendidos[i];
        _revisar();
      });

  void cambiarLed() => setState(() {
        led = true;
        _revisar();
      });

  @override
  Widget build(BuildContext context) {
    final listo = hechas.length == metas.length;
    final msg = listo
        ? '¡Tu casa ahorra energía! Apagar lo que no usas y usar focos LED reduce el gasto y la contaminación de las centrales eléctricas.'
        : !encendidos[0]
            ? '¡Cuidado! El refrigerador debe seguir encendido o la comida se echa a perder.'
            : 'Es de día y en casa solo está tu hermana en la cocina. Toca los aparatos para apagar los que no se usan. ¿Puedes gastar menos de 300 watts?';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'La casa que ahorra energía', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 190, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(left: 8, top: 256, width: 230, height: 216, child: objetivosPanel(metas, hechas, widget.color)),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 300,
          child: LayoutBuilder(builder: (_, c) {
            return Stack(children: [
              Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(18), child: CustomPaint(painter: _PintorCasa(this)))),
              for (var i = 0; i < aparatosCasa.length; i++)
                Positioned(
                  left: aparatosCasa[i].x * c.maxWidth - 32,
                  top: aparatosCasa[i].y * c.maxHeight - 32,
                  width: 64,
                  height: 64,
                  child: Tooltip(
                    message: aparatosCasa[i].nombre,
                    child: GestureDetector(
                      onTap: () => alternar(i),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: encendidos[i] ? 1 : 0.35,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: encendidos[i] ? const Color(0x66FFEB3B) : Colors.transparent,
                            border: Border.all(color: encendidos[i] ? const Color(0xFFFFB300) : Colors.black26, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(aparatosCasa[i].emoji, style: const TextStyle(fontSize: 30)),
                        ),
                      ),
                    ),
                  ),
                ),
            ]);
          }),
        ),
        Positioned(
          left: 244,
          top: 366,
          width: 608,
          child: Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: consumo < 300 ? ColoresJuego.correcto : const Color(0xFFE53935), borderRadius: BorderRadius.circular(12)),
              child: Text('⚡ Consumo: $consumo watts', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
            const SizedBox(width: 10),
            Tooltip(
                message: 'Cambiar a focos LED',
                child: ChipEle(texto: led ? '✅ Focos LED' : '💡 Cambiar a focos LED', activo: led, color: const Color(0xFF43A047), onTap: cambiarLed)),
          ]),
        ),
        if (listo) _siguiente(context, widget.actividad, '¡Casa ahorradora!', 'Usas la energía de forma responsable.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorCasa extends CustomPainter {
  _PintorCasa(this.s);
  final SimAhorroState s;
  @override
  void paint(Canvas c, Size z) {
    c.drawRect(Offset.zero & z, relleno(const Color(0xFFFFF3E0)));
    for (final x in [z.width / 3, z.width * 2 / 3]) {
      c.drawLine(Offset(x, 0), Offset(x, z.height), linea(const Color(0xFFBCAAA4), 4));
    }
    c.drawRect(Rect.fromLTWH(0, z.height * 0.82, z.width, z.height * 0.18), relleno(const Color(0xFFD7CCC8)));
    for (final (x, t) in [(z.width / 6, 'Cocina 👧'), (z.width / 2, 'Sala'), (z.width * 5 / 6, 'Cuarto')]) {
      textoEn(c, t, Offset(x, z.height * 0.92), tam: 14, color: const Color(0xFF5D4037));
    }
    dibujarEmoji(c, '☀️', Offset(z.width * 0.5, z.height * 0.42), 26);
    textoEn(c, 'Es de día', Offset(z.width * 0.5, z.height * 0.5), tam: 11, color: const Color(0xFFE65100));
  }

  @override
  bool shouldRepaint(_PintorCasa old) => true;
}

// ===========================================================================
// El Sistema Solar
// ===========================================================================

class Planeta {
  const Planeta(this.nombre, this.emoji, this.color, this.radio, this.orbita, this.periodo, this.tipo, this.dato);
  final String nombre, emoji, tipo, dato;
  final Color color;
  final double radio, orbita, periodo;
}

const planetas = [
  Planeta('Mercurio', '⚫', Color(0xFF9E9E9E), 5, 0.13, 0.24, 'Rocoso', 'Es el más cercano al Sol y el más pequeño. Su año dura solo 88 días.'),
  Planeta('Venus', '🟡', Color(0xFFFFCC80), 7, 0.2, 0.62, 'Rocoso', 'Es el más caliente (unos 460 °C) por sus nubes que atrapan el calor. Gira al revés.'),
  Planeta('Tierra', '🌍', Color(0xFF42A5F5), 8.5, 0.28, 1, 'Rocoso', 'Nuestro hogar: el único planeta conocido con vida y agua líquida en la superficie.'),
  Planeta('Marte', '🔴', Color(0xFFE53935), 6, 0.36, 1.88, 'Rocoso',
      'El planeta rojo: su suelo tiene óxido de hierro. Tiene el volcán más grande del Sistema Solar.'),
  Planeta('Júpiter', '🟠', Color(0xFFFFB74D), 16, 0.5, 11.9, 'Gaseoso',
      'El más grande: ¡cabrían más de 1 300 Tierras! Tiene una tormenta gigante llamada la Gran Mancha Roja.'),
  Planeta('Saturno', '🪐', Color(0xFFFFE082), 14, 0.64, 29.5, 'Gaseoso',
      'Famoso por sus anillos de hielo y roca. Es tan ligero que flotaría en una alberca gigante.'),
  Planeta('Urano', '🔵', Color(0xFF80DEEA), 10, 0.78, 84, 'Gaseoso', 'Gira “acostado”, de lado. Es un gigante de hielo muy frío.'),
  Planeta('Neptuno', '🔷', Color(0xFF3949AB), 10, 0.92, 165, 'Gaseoso', 'El más lejano. Tiene los vientos más rápidos del Sistema Solar.'),
];

class SimSistemaSolar extends StatefulWidget {
  const SimSistemaSolar({super.key, required this.actividad, required this.color});
  final String actividad;
  final Color color;
  @override
  State<SimSistemaSolar> createState() => SimSistemaSolarState();
}

class SimSistemaSolarState extends State<SimSistemaSolar> {
  int? sel;
  final visitados = <int>{};
  double velocidad = 0.5;

  void visitar(int i) => setState(() {
        sel = i;
        visitados.add(i);
      });

  @override
  Widget build(BuildContext context) {
    final listo = visitados.length == planetas.length;
    final p = sel == null ? null : planetas[sel!];
    final msg = p == null
        ? 'El Sol es una estrella y a su alrededor giran 8 planetas. Toca cada planeta en la lista para visitarlo. ¡Visita los 8!'
        : '${p.emoji} ${p.nombre} · planeta ${p.tipo.toLowerCase()}. ${p.dato} Su año dura ${p.periodo < 1 ? '${(p.periodo * 365).round()} días' : '${p.periodo.toStringAsFixed(p.periodo < 10 ? 1 : 0)} años terrestres'}.';
    return Escenario(
      velo: 0.08,
      colorVelo: widget.color,
      children: [
        encabezadoEle('Simulación', 'Viaje por el Sistema Solar', widget.color),
        Positioned(left: 8, top: 60, width: 230, height: 250, child: GloboZatiEle(msg, tam: 12.5)),
        Positioned(
          left: 8,
          top: 316,
          width: 230,
          height: 156,
          child: PanelEle(
            titulo: 'Visitados: ${visitados.length} de 8',
            icono: Icons.rocket_launch_rounded,
            color: widget.color,
            child: deslizador(context, '⏩', 'Velocidad', velocidad, (v) => setState(() => velocidad = v), widget.color),
          ),
        ),
        Positioned(
          left: 244,
          top: 60,
          width: 608,
          height: 300,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(18), child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorSistema(t * (0.2 + velocidad * 2), sel)))),
        ),
        Positioned(
          left: 244,
          top: 366,
          width: 608,
          child: Wrap(spacing: 4, runSpacing: 4, children: [
            for (var i = 0; i < planetas.length; i++)
              Tooltip(
                message: planetas[i].nombre,
                child: ChipEle(
                  texto: '${visitados.contains(i) ? '✔ ' : ''}${planetas[i].nombre}',
                  activo: sel == i,
                  color: planetas[i].color == const Color(0xFFFFE082) ? const Color(0xFFFFA000) : planetas[i].color,
                  onTap: () => visitar(i),
                ),
              ),
          ]),
        ),
        if (listo) _siguiente(context, widget.actividad, '¡Viaje por el Sistema Solar!', 'Visitaste los 8 planetas del Sistema Solar.'),
        const BotonVolverEscena(),
      ],
    );
  }
}

/// Dibuja un planeta con su aspecto real: luz del lado del Sol, bandas en los
/// gigantes gaseosos, anillos de Saturno y la Tierra con océanos, continentes,
/// hielo en los polos y nubes.
void dibujarPlaneta(Canvas c, Planeta p, Offset pos, double r, Offset sol, double t, {bool grande = false}) {
  final circulo = Rect.fromCircle(center: pos, radius: r);
  final anillo = Rect.fromCenter(center: pos, width: r * 3.6, height: r * 1.1);
  if (p.nombre == 'Saturno') {
    // Mitad trasera del anillo
    c.drawArc(anillo, math.pi, math.pi, false, linea(const Color(0xFFD7C08A), r * 0.28));
  }
  if (p.nombre == 'Tierra') {
    // Atmósfera
    c.drawCircle(pos, r * 1.18, relleno(const Color(0x5581D4FA)));
  }
  c.save();
  c.clipPath(Path()..addOval(circulo));
  switch (p.nombre) {
    case 'Tierra':
      c.drawRect(circulo,
          Paint()..shader = const RadialGradient(colors: [Color(0xFF4FC3F7), Color(0xFF1E88E5), Color(0xFF0D47A1)], stops: [0, 0.55, 1]).createShader(circulo));
      // Continentes que giran con la Tierra
      final giro = (t * 0.15) % 2;
      for (final dx in [-2.0, 0.0]) {
        final o = pos + Offset((giro + dx) * r, 0);
        void tierra(List<Offset> pts, Color col) {
          final path = Path()..moveTo(o.dx + pts[0].dx * r, o.dy + pts[0].dy * r);
          for (var k = 1; k < pts.length; k++) {
            final a = pts[k - 1], b = pts[k];
            path.quadraticBezierTo(o.dx + a.dx * r, o.dy + a.dy * r, o.dx + (a.dx + b.dx) / 2 * r, o.dy + (a.dy + b.dy) / 2 * r);
          }
          path.close();
          c.drawPath(path, relleno(col));
        }

        // América
        tierra(const [
          Offset(-0.75, -0.7),
          Offset(-0.3, -0.75),
          Offset(-0.25, -0.35),
          Offset(-0.5, -0.1),
          Offset(-0.3, 0.15),
          Offset(-0.15, 0.45),
          Offset(-0.35, 0.8),
          Offset(-0.5, 0.35),
          Offset(-0.7, 0.05),
          Offset(-0.85, -0.35)
        ], const Color(0xFF43A047));
        // África y Europa
        tierra(const [
          Offset(0.2, -0.75),
          Offset(0.6, -0.65),
          Offset(0.65, -0.2),
          Offset(0.75, 0.1),
          Offset(0.55, 0.55),
          Offset(0.4, 0.7),
          Offset(0.3, 0.3),
          Offset(0.15, 0.0),
          Offset(0.12, -0.4)
        ], const Color(0xFF7CB342));
        // Desierto
        tierra(const [Offset(0.3, -0.3), Offset(0.6, -0.3), Offset(0.6, -0.05), Offset(0.35, -0.05)], const Color(0xFFD7B56D));
        // Australia
        tierra(const [Offset(0.85, 0.35), Offset(1.05, 0.3), Offset(1.1, 0.55), Offset(0.9, 0.6)], const Color(0xFF8D6E63));
      }
      // Hielo de los polos
      c.drawOval(Rect.fromCenter(center: pos + Offset(0, -r * 0.98), width: r * 1.3, height: r * 0.45), relleno(Colors.white));
      c.drawOval(Rect.fromCenter(center: pos + Offset(0, r * 0.98), width: r * 1.5, height: r * 0.5), relleno(Colors.white));
      // Nubes
      final nubes = Paint()
        ..color = const Color(0xCCFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = math.max(1.2, r * 0.12);
      final g = (t * 0.22) % 2;
      for (final (x, y, w) in const [(-0.6, -0.45, 0.5), (0.1, 0.15, 0.6), (-0.4, 0.55, 0.45), (0.5, -0.5, 0.35)]) {
        final cx = pos.dx + (((x + g + 1) % 2) - 1) * r;
        c.drawArc(Rect.fromCenter(center: Offset(cx, pos.dy + y * r), width: w * r * 2, height: r * 0.35), 0.3, 2.5, false, nubes);
      }
    case 'Júpiter' || 'Saturno':
      final colores = p.nombre == 'Júpiter'
          ? const [Color(0xFFF3E0C7), Color(0xFFC58B5A), Color(0xFFEBD3B0), Color(0xFFA86A3E), Color(0xFFF1DDBE), Color(0xFFC9935F), Color(0xFFEAD6B8)]
          : const [Color(0xFFF6E7B8), Color(0xFFE2C98C), Color(0xFFF3E2AE), Color(0xFFD9BC7B), Color(0xFFF4E4B2)];
      final h = r * 2 / colores.length;
      for (var k = 0; k < colores.length; k++) {
        c.drawRect(Rect.fromLTWH(pos.dx - r, pos.dy - r + k * h, r * 2, h + 0.5), relleno(colores[k]));
      }
      if (p.nombre == 'Júpiter') {
        // Gran Mancha Roja
        c.drawOval(Rect.fromCenter(center: pos + Offset(r * 0.3, r * 0.35), width: r * 0.5, height: r * 0.28), relleno(const Color(0xFFB5452B)));
      }
    case 'Marte':
      c.drawRect(circulo, relleno(const Color(0xFFC1440E)));
      c.drawCircle(pos + Offset(-r * 0.3, r * 0.1), r * 0.35, relleno(const Color(0xFF8E2F0A)));
      c.drawCircle(pos + Offset(r * 0.35, -r * 0.3), r * 0.2, relleno(const Color(0xFF9E3810)));
      c.drawOval(Rect.fromCenter(center: pos + Offset(0, -r * 0.95), width: r * 0.8, height: r * 0.3), relleno(Colors.white));
    case 'Mercurio':
      c.drawRect(circulo, relleno(const Color(0xFF9E9E9E)));
      for (final (x, y, q) in const [(-0.3, -0.2, 0.22), (0.35, 0.25, 0.18), (0.1, -0.5, 0.12), (-0.2, 0.5, 0.15)]) {
        c.drawCircle(pos + Offset(x * r, y * r), q * r, relleno(const Color(0xFF757575)));
      }
    case 'Venus':
      c.drawRect(
          circulo,
          Paint()
            ..shader =
                const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFFFE0A3), Color(0xFFE8B86A), Color(0xFFF5D08A)])
                    .createShader(circulo));
    case 'Urano':
      c.drawRect(circulo, relleno(const Color(0xFF9FE3EA)));
    case 'Neptuno':
      c.drawRect(
          circulo,
          Paint()
            ..shader =
                const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF5C7CFA), Color(0xFF3F51B5), Color(0xFF283593)])
                    .createShader(circulo));
      c.drawOval(Rect.fromCenter(center: pos + Offset(-r * 0.2, r * 0.2), width: r * 0.45, height: r * 0.25), relleno(const Color(0xFF1A237E)));
    default:
      c.drawRect(circulo, relleno(p.color));
  }
  // Sombra: el lado contrario al Sol queda de noche.
  final haciaSol = (sol - pos).direction;
  final luz = pos + Offset.fromDirection(haciaSol, r * 0.6);
  c.drawRect(
      circulo,
      Paint()
        ..shader = RadialGradient(
            center: Alignment((luz.dx - pos.dx) / r, (luz.dy - pos.dy) / r),
            radius: 0.85,
            colors: const [Color(0x00000000), Color(0x00000000), Color(0x99000000)],
            stops: const [0, 0.55, 1]).createShader(circulo));
  c.restore();
  if (p.nombre == 'Saturno') {
    // Mitad delantera del anillo
    c.drawArc(anillo, 0, math.pi, false, linea(const Color(0xFFE8D49A), r * 0.28));
  }
}

class _PintorSistema extends CustomPainter {
  _PintorSistema(this.t, this.sel);
  final double t;
  final int? sel;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFF0B0D2A)));
    for (var k = 0; k < 60; k++) {
      c.drawCircle(Offset((k * 137 % 600).toDouble(), (k * 71 % 300).toDouble()), 0.9, relleno(Colors.white54));
    }
    final sol = Offset(40, s.height / 2);
    c.drawCircle(
        sol,
        70,
        Paint()
          ..shader = RadialGradient(colors: const [Color(0xFFFFF59D), Color(0xFFFF8F00), Color(0x00FF6F00)], stops: const [0.3, 0.55, 1])
              .createShader(Rect.fromCircle(center: sol, radius: 70)));
    textoEn(c, 'Sol', sol + const Offset(20, 0), tam: 13, color: const Color(0xFF5D4037));
    for (var i = 0; i < planetas.length; i++) {
      final p = planetas[i];
      final r = 50 + p.orbita * (s.width - 80);
      c.drawArc(
          Rect.fromCircle(center: sol, radius: r), -0.6, 1.2, false, linea(i == sel ? const Color(0xAAFFD54F) : const Color(0x33FFFFFF), i == sel ? 2 : 1));
      final a = (t / p.periodo) % 1 * 1.2 - 0.6;
      final pos = sol + Offset(math.cos(a), math.sin(a)) * r;
      dibujarPlaneta(c, p, pos, p.radio, sol, t);
      if (i == sel) c.drawCircle(pos, p.radio + 6, linea(const Color(0xFFFFD54F), 2.5));
    }
    // Lupa: el planeta elegido se ve grande en la esquina.
    if (sel != null) {
      final p = planetas[sel!];
      final centro = Offset(s.width - 70, 72);
      c.drawCircle(centro, 60, relleno(const Color(0x66000000)));
      c.drawCircle(centro, 60, linea(const Color(0xFFFFD54F), 2));
      dibujarPlaneta(c, p, centro, p.nombre == 'Saturno' ? 30 : 42, sol, t, grande: true);
      textoEn(c, p.nombre, centro + const Offset(0, 74), tam: 13, color: Colors.white, fondo: const Color(0x99000000));
    }
  }

  @override
  bool shouldRepaint(_PintorSistema old) => true;
}
