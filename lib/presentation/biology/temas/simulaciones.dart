import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema1/aventura.dart' show BannerTitulo, moradoBanner;
import '../tema1/componentes.dart' show terminarPaso;
import '../tema1/comunes.dart';
import '../tema1/contenido.dart' show PreguntaQuiz;
import '../tema1/escenario.dart';
import '../tema1/pantalla_recorrido.dart' show BotonOpcion, EstadoOpcion;
import 'ilustraciones.dart';
import 'motor.dart';

/// Simulaciones y laboratorios propios de cada tema.

Widget _encabezado(String seccion, String titulo, Color color) => Positioned(
      left: 64,
      top: 10,
      right: 8,
      child: Row(
        children: [
          EtiquetaSeccion(seccion),
          const SizedBox(width: 10),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: BannerTitulo(titulo, tam: 22, color: oscurecer(color, 0.05)),
            ),
          ),
        ],
      ),
    );

Widget _zati(String texto, {double alto = 170}) => Positioned(
      left: 0,
      top: 62,
      child: ZatiConGlobo(texto: texto, tamZati: 160, anchoGlobo: 228, altoGlobo: alto, tamLetra: 14, globoArriba: true),
    );

Widget _texto(String t, {double tam = 14}) =>
    Text(t, style: TextStyle(fontSize: tam, fontWeight: FontWeight.w700, color: Colors.white, shadows: const [Shadow(blurRadius: 4)]));

/// Pregunta de una sola opción correcta, dentro de un panel.
class PreguntaPanel extends StatefulWidget {
  const PreguntaPanel({super.key, required this.pregunta, required this.onAcierto, this.columnas = 1});
  final PreguntaQuiz pregunta;
  final ValueChanged<bool> onAcierto; // true si fue a la primera
  final int columnas;
  @override
  State<PreguntaPanel> createState() => _PreguntaPanelState();
}

class _PreguntaPanelState extends State<PreguntaPanel> {
  int? _e;
  bool _intento = false;
  @override
  Widget build(BuildContext context) {
    final q = widget.pregunta;
    final acerto = _e == q.correcta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(q.pregunta, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        for (var k = 0; k < q.opciones.length; k++)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: BotonOpcion(
              letra: 'ABCD'[k],
              texto: q.opciones[k],
              estado: _e == k ? (k == q.correcta ? EstadoOpcion.correcta : EstadoOpcion.incorrecta) : EstadoOpcion.normal,
              onTap: acerto
                  ? null
                  : () {
                      final primera = !_intento && k == q.correcta;
                      setState(() {
                        _intento = true;
                        _e = k;
                      });
                      if (k == q.correcta) widget.onAcierto(primera);
                    },
            ),
          ),
        if (_e != null)
          Text(acerto ? '✅ ${q.explicacion}' : '🤔 ¡Inténtalo otra vez!',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: acerto ? ColoresJuego.correcto : ColoresJuego.incorrecto)),
      ],
    );
  }
}

// ===========================================================================
// Tema 2 · Microscopio de células
// ===========================================================================

class _Muestra {
  const _Muestra(this.nombre, this.emoji, this.tipo, this.descripcion, this.enfoque);
  final String nombre, emoji, tipo, descripcion;
  final double enfoque;
}

const _muestras = [
  _Muestra('Mejilla', '👄', 'Células animales',
      'Raspando suavemente el interior de la mejilla se ven células planas y redondeadas, cada una con su núcleo. No tienen pared celular.', 0.62),
  _Muestra('Piel de cebolla', '🧅', 'Células vegetales',
      'Se ven células rectangulares, una junto a otra como ladrillos. Tienen pared celular y un núcleo.', 0.35),
  _Muestra('Hoja de elodea', '🌿', 'Células vegetales con cloroplastos',
      'Las células tienen muchos puntitos verdes: son los cloroplastos, donde la planta fabrica su alimento con la luz del sol.', 0.78),
  _Muestra('Agua de charco', '💧', 'Seres unicelulares',
      'En una gota de agua de charco viven seres de una sola célula, como amebas y paramecios. ¡Se mueven solos!', 0.5),
];

class SimMicroscopioCelulas extends StatefulWidget {
  const SimMicroscopioCelulas({super.key, required this.actividad});
  final String actividad;
  @override
  State<SimMicroscopioCelulas> createState() => _SimMicroscopioCelulasState();
}

class _SimMicroscopioCelulasState extends State<SimMicroscopioCelulas> {
  int _m = 0;
  double _enfoque = 0.1;
  int _aumento = 0;
  final _observadas = <int>{};

  bool get _nitido => (_enfoque - _muestras[_m].enfoque).abs() < 0.07;

  void _revisar() {
    if (_nitido && _aumento >= 1 && _observadas.add(_m)) HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final m = _muestras[_m];
    final borroso = (_enfoque - m.enfoque).abs() * 16;
    final zoom = [1.0, 1.8, 3.0][_aumento];
    final listo = _observadas.length == _muestras.length;
    const color = Color(0xFF00897B);
    return Escenario(
      velo: 0.15,
      colorVelo: color,
      children: [
        _encabezado('Simulación', 'El microscopio', color),
        _zati(
          _observadas.contains(_m)
              ? '¡Lo lograste! ${m.tipo}: ${m.descripcion}'
              : 'Elige una muestra. Mueve el enfoque hasta que se vea nítida y usa un aumento de 400× o más.',
          alto: 220,
        ),
        Positioned(
          left: 244,
          top: 62,
          width: 300,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF37474F), width: 10),
              boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 16)],
            ),
            child: ClipOval(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: borroso, sigmaY: borroso),
                child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorMuestra(_m, t, zoom), size: Size.infinite)),
              ),
            ),
          ),
        ),
        Positioned(
          left: 244,
          top: 372,
          width: 300,
          child: Column(
            children: [
              Row(children: [
                _texto('🔍 Enfoque', tam: 13),
                Expanded(
                  child: Slider(
                    value: _enfoque,
                    activeColor: color,
                    onChanged: (v) => setState(() {
                      _enfoque = v;
                      _revisar();
                    }),
                  ),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < 3; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: ChoiceChip(
                        label: Text(['100×', '400×', '1000×'][i]),
                        selected: _aumento == i,
                        onSelected: (_) => setState(() {
                          _aumento = i;
                          _revisar();
                        }),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 556,
          top: 62,
          width: 296,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _muestras.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Rebote(
                    onTap: () => setState(() {
                      _m = i;
                      _enfoque = 0.1;
                      _aumento = 0;
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: i == _m ? aclarar(color, 0.75) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: i == _m ? color : Colors.black12, width: 2.5),
                      ),
                      child: Row(
                        children: [
                          Emoji(_muestras[i].emoji, tam: 26),
                          const SizedBox(width: 8),
                          Expanded(child: Text(_muestras[i].nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15))),
                          if (_observadas.contains(i)) const Icon(Icons.check_circle_rounded, color: ColoresJuego.correcto),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              _texto('Muestras observadas: ${_observadas.length}/${_muestras.length}'),
            ],
          ),
        ),
        if (listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: 3,
                titulo: '¡Gran observador!',
                mensaje: 'Observaste células animales, vegetales y seres unicelulares. ¡Todos los seres vivos están hechos de células!',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorMuestra extends CustomPainter {
  _PintorMuestra(this.m, this.t, this.zoom);
  final int m;
  final double t, zoom;
  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFFFF8E1));
    c.save();
    c.translate(s.width / 2, s.height / 2);
    c.scale(zoom);
    c.translate(-s.width / 2, -s.height / 2);
    final rnd = math.Random(m * 7 + 1);
    switch (m) {
      case 0:
        for (var i = 0; i < 14; i++) {
          final p = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height);
          final path = Path();
          for (var k = 0; k <= 7; k++) {
            final a = k / 7 * 2 * math.pi + rnd.nextDouble() * 0.3;
            final q = p + Offset(math.cos(a), math.sin(a)) * (22 + rnd.nextDouble() * 6);
            k == 0 ? path.moveTo(q.dx, q.dy) : path.lineTo(q.dx, q.dy);
          }
          path.close();
          c.drawPath(path, Paint()..color = const Color(0xFFFFCCBC).withValues(alpha: 0.8));
          c.drawPath(path, linea(const Color(0xFFE57373), 1.2));
          c.drawCircle(p, 5, Paint()..color = const Color(0xFF7E57C2));
        }
      case 1:
      case 2:
        const w = 56.0, h = 26.0;
        for (var y = -1; y < s.height / h + 1; y++) {
          for (var x = -1; x < s.width / w + 1; x++) {
            final r = Rect.fromLTWH(x * w + (y.isOdd ? w / 2 : 0), y * h, w, h);
            c.drawRect(r, Paint()..color = m == 1 ? const Color(0xFFF1F8E9) : const Color(0xFFDCEDC8));
            c.drawRect(r, linea(const Color(0xFF7CB342), 2));
            c.drawCircle(r.center + Offset(rnd.nextDouble() * 14 - 7, 0), 3.5, Paint()..color = const Color(0xFF8D6E63));
            if (m == 2) {
              for (var k = 0; k < 6; k++) {
                final q = r.topLeft + Offset(6 + rnd.nextDouble() * (w - 12) + math.sin(t + k) * 1.5, 5 + rnd.nextDouble() * (h - 10));
                c.drawOval(Rect.fromCenter(center: q, width: 6, height: 4), Paint()..color = const Color(0xFF2E7D32));
              }
            }
          }
        }
      default:
        for (var i = 0; i < 5; i++) {
          final p = Offset((rnd.nextDouble() * s.width + t * (12 + i * 5)) % s.width, rnd.nextDouble() * s.height);
          c.save();
          c.translate(p.dx, p.dy);
          c.rotate(rnd.nextDouble() * 3 + t * 0.2);
          c.drawOval(const Rect.fromLTWH(-20, -8, 40, 16), Paint()..color = const Color(0xFFA5D6A7));
          for (var k = 0; k < 14; k++) {
            final a = k / 14 * 2 * math.pi;
            c.drawLine(Offset(math.cos(a) * 20, math.sin(a) * 8), Offset(math.cos(a) * 24, math.sin(a) * 11 + math.sin(t * 10 + k) * 1.5), linea(const Color(0xFF43A047), 0.8));
          }
          c.drawCircle(const Offset(4, 0), 3, Paint()..color = const Color(0xFF2E7D32));
          c.restore();
        }
        for (var i = 0; i < 3; i++) {
          final p = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height);
          final path = Path();
          for (var k = 0; k <= 40; k++) {
            final a = k / 40 * 2 * math.pi;
            final rr = 18 * (1 + 0.25 * math.sin(a * 4 + t * 1.2 + i));
            final q = p + Offset(math.cos(a), math.sin(a)) * rr;
            k == 0 ? path.moveTo(q.dx, q.dy) : path.lineTo(q.dx, q.dy);
          }
          c.drawPath(path..close(), Paint()..color = const Color(0xFFCE93D8).withValues(alpha: 0.85));
          c.drawCircle(p, 4, Paint()..color = const Color(0xFF7B1FA2));
        }
    }
    c.restore();
  }

  @override
  bool shouldRepaint(_PintorMuestra old) => true;
}

// ===========================================================================
// Tema 3 · Arma tu plato
// ===========================================================================

class AlimentoPlato {
  const AlimentoPlato(this.emoji, this.nombre, this.grupo);
  final String emoji, nombre;

  /// 0 verduras y frutas, 1 cereales, 2 leguminosas, 3 origen animal, -1 evitar.
  final int grupo;
}

const alimentosPlato = [
  AlimentoPlato('🥦', 'Brócoli', 0),
  AlimentoPlato('🥕', 'Zanahoria', 0),
  AlimentoPlato('🍎', 'Manzana', 0),
  AlimentoPlato('🍌', 'Plátano', 0),
  AlimentoPlato('🌽', 'Elote', 1),
  AlimentoPlato('🍚', 'Arroz', 1),
  AlimentoPlato('🫓', 'Tortilla', 1),
  AlimentoPlato('🫘', 'Frijoles', 2),
  AlimentoPlato('🥜', 'Cacahuates', 2),
  AlimentoPlato('🥚', 'Huevo', 3),
  AlimentoPlato('🐟', 'Pescado', 3),
  AlimentoPlato('🍩', 'Dona', -1),
  AlimentoPlato('🍟', 'Papas fritas', -1),
  AlimentoPlato('🍬', 'Dulces', -1),
];

class SimArmaPlato extends StatefulWidget {
  const SimArmaPlato({super.key, required this.actividad});
  final String actividad;
  @override
  State<SimArmaPlato> createState() => _SimArmaPlatoState();
}

class _SimArmaPlatoState extends State<SimArmaPlato> {
  final _enPlato = <int>[];
  int _vasos = 0, _errores = 0;
  String _mensaje = 'Arrastra alimentos al plato para armar una comida equilibrada. ¡No olvides los vasos de agua simple!';
  static const _r = Rect.fromLTWH(420, 70, 300, 300);

  List<int> get _conteo {
    final c = [0, 0, 0, 0];
    for (final i in _enPlato) {
      c[alimentosPlato[i].grupo]++;
    }
    return c;
  }

  bool get _equilibrado {
    final c = _conteo;
    return c[0] >= 2 && c[1] >= 1 && c[2] + c[3] >= 1 && _vasos >= 4;
  }

  void _soltar(int i) {
    final a = alimentosPlato[i];
    if (a.grupo < 0) {
      HapticFeedback.mediumImpact();
      setState(() {
        _errores++;
        _mensaje = '${a.emoji} ${a.nombre} tiene mucha azúcar, sal o grasa. No forma parte del Plato del Bien Comer: es solo para muy de vez en cuando.';
      });
      return;
    }
    setState(() {
      _enPlato.add(i);
      final c = _conteo;
      _mensaje = c[0] < 2
          ? '¡Bien! Agrega más verduras y frutas: deben ser la parte más grande.'
          : c[1] < 1
              ? 'Ahora un cereal para darte energía.'
              : c[2] + c[3] < 1
                  ? 'Falta una leguminosa o un alimento de origen animal.'
                  : _vasos < 4
                      ? '¡Tu plato se ve muy bien! Sirve vasos de agua simple.'
                      : '¡Plato equilibrado! 🎉';
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = _conteo;
    const color = Color(0xFF43A047);
    final libres = [for (var i = 0; i < alimentosPlato.length; i++) if (!_enPlato.contains(i)) i];
    return Escenario(
      velo: 0.12,
      colorVelo: color,
      children: [
        _encabezado('Simulación', 'Arma tu plato', color),
        _zati(_mensaje, alto: 200),
        Positioned(
          left: 244,
          top: 62,
          width: 168,
          height: 404,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.93), borderRadius: BorderRadius.circular(20), border: Border.all(color: color, width: 2.5)),
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  for (final i in libres)
                    Draggable<int>(
                      data: i,
                      dragAnchorStrategy: pointerDragAnchorStrategy,
                      feedback: Material(color: Colors.transparent, child: Transform.translate(offset: const Offset(-26, -26), child: Emoji(alimentosPlato[i].emoji, tam: 44))),
                      childWhenDragging: const SizedBox(width: 72, height: 64),
                      child: Tooltip(
                        message: alimentosPlato[i].nombre,
                        child: Container(
                          width: 72,
                          height: 64,
                          decoration: BoxDecoration(color: const Color(0xFFFFF8E6), borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.black12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Emoji(alimentosPlato[i].emoji, tam: 26),
                              Text(alimentosPlato[i].nombre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Positioned.fromRect(
          rect: _r,
          child: DragTarget<int>(
            onAcceptWithDetails: (d) => _soltar(d.data),
            builder: (context, cand, _) => CustomPaint(painter: _PintorMiPlato(_enPlato, cand.isNotEmpty)),
          ),
        ),
        Positioned(
          left: 420,
          top: 378,
          width: 300,
          child: Wrap(
            spacing: 6,
            alignment: WrapAlignment.center,
            children: [
              for (var g = 0; g < 4; g++)
                Chip(
                  backgroundColor: aclarar(sectoresPlato[g].$3, 0.6),
                  visualDensity: VisualDensity.compact,
                  label: Text('${sectoresPlato[g].$2}: ${c[g]}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ),
        Positioned(
          left: 730,
          top: 70,
          width: 122,
          child: Column(
            children: [
              _texto('Jarra del Buen Beber', tam: 12.5),
              const SizedBox(height: 4),
              Rebote(
                onTap: _vasos >= 8
                    ? null
                    : () => setState(() {
                          _vasos++;
                          if (_equilibrado) _mensaje = '¡Plato equilibrado! 🎉';
                        }),
                child: Tooltip(
                  message: 'Servir agua',
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF29B6F6), width: 3)),
                    child: Column(children: [
                      const Emoji('🫗', tam: 40),
                      const Text('Toca para servir agua', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Wrap(spacing: 2, runSpacing: 2, children: [
                        for (var v = 0; v < 8; v++) Icon(Icons.local_drink_rounded, size: 22, color: v < _vasos ? const Color(0xFF29B6F6) : Colors.black12),
                      ]),
                      Text('$_vasos vasos', style: const TextStyle(fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFFFF8E1), borderRadius: BorderRadius.circular(12)),
                child: const Text('💡 Un niño necesita de 6 a 8 vasos de agua al día.', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ),
        if (_equilibrado)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: _errores == 0 ? 3 : (_errores <= 2 ? 2 : 1),
                titulo: '¡Plato equilibrado!',
                mensaje: 'Combinaste los tres grupos del Plato del Bien Comer y agua simple. ¡Así es una alimentación correcta!',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorMiPlato extends CustomPainter {
  _PintorMiPlato(this.items, this.activo);
  final List<int> items;
  final bool activo;
  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset.zero);
    final radio = s.shortestSide * 0.46;
    c.drawCircle(centro + const Offset(0, 5), radio + 8, Paint()..color = const Color(0x33000000));
    c.drawCircle(centro, radio + 8, Paint()..color = activo ? const Color(0xFFFFF59D) : Colors.white);
    for (final (_, nombre, col, ini, ang, _) in sectoresPlato) {
      final rect = Rect.fromCircle(center: centro, radius: radio);
      c.drawArc(rect, ini, ang, true, Paint()..color = aclarar(col, 0.55));
      c.drawArc(rect, ini, ang, true, linea(Colors.white, 4));
      final a = ini + ang / 2;
      textoEn(c, nombre, centro + Offset(math.cos(a), math.sin(a)) * radio * 0.78, tam: 10.5, color: oscurecer(col, 0.35));
    }
    final porGrupo = <int, int>{};
    for (final i in items) {
      final g = alimentosPlato[i].grupo;
      final k = porGrupo[g] = (porGrupo[g] ?? 0) + 1;
      final (_, _, _, ini, ang, _) = sectoresPlato[g];
      final a = ini + ang * (0.2 + ((k - 1) % 4) * 0.2);
      final d = radio * (0.28 + ((k - 1) ~/ 4) * 0.22 + (k.isEven ? 0.1 : 0));
      dibujarEmoji(c, alimentosPlato[i].emoji, centro + Offset(math.cos(a), math.sin(a)) * d, radio * 0.2);
    }
  }

  @override
  bool shouldRepaint(_PintorMiPlato old) => true;
}

// ===========================================================================
// Tema 3 · Laboratorio: ¿cuánta azúcar tiene?
// ===========================================================================

const _bebidas = [
  ('🥤', 'Refresco (600 ml)', 16),
  ('🧃', 'Jugo envasado (250 ml)', 6),
  ('🧋', 'Bebida de chocolate (250 ml)', 5),
  ('🍹', 'Agua de fruta con poca azúcar (250 ml)', 2),
  ('💧', 'Agua simple (250 ml)', 0),
];

class LabAzucar extends StatefulWidget {
  const LabAzucar({super.key, required this.actividad});
  final String actividad;
  @override
  State<LabAzucar> createState() => _LabAzucarState();
}

class _LabAzucarState extends State<LabAzucar> with SingleTickerProviderStateMixin {
  int _etapa = 0; // 0 hipótesis, 1 medir, 2 conclusión
  int? _hipotesis;
  int _sel = 0;
  final _medidas = <int>{};
  bool _primer = false, _listo = false;
  late final AnimationController _vertir = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..addListener(() => setState(() {}));

  @override
  void dispose() {
    _vertir.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFFF8A00);
    final b = _bebidas[_sel];
    final cubos = (b.$3 * _vertir.value).floor();
    final hijos = <Widget>[];
    if (_etapa == 0) {
      hijos.add(Positioned(
        left: 244,
        top: 62,
        width: 606,
        height: 360,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color, width: 4)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Pregunta de investigación:', style: TextStyle(fontWeight: FontWeight.w700, color: moradoBanner)),
                const Text('¿Cuál de estas bebidas tiene más azúcar?', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                const Text('Mi hipótesis:', style: TextStyle(fontWeight: FontWeight.w700, color: moradoBanner)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (var i = 0; i < _bebidas.length; i++)
                      ChoiceChip(
                        avatar: Text(_bebidas[i].$1),
                        label: Text(_bebidas[i].$2),
                        selected: _hipotesis == i,
                        onSelected: (_) => setState(() => _hipotesis = i),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_hipotesis != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: BotonJuego(texto: '¡A medir!', icono: Icons.science_rounded, color: const Color(0xFF2DB84C), onTap: () => setState(() => _etapa = 1)),
                  ),
              ],
            ),
          ),
        ),
      ));
    } else if (_etapa == 1) {
      hijos.addAll([
        Positioned(
          left: 244,
          top: 62,
          width: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _bebidas.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Rebote(
                    onTap: _vertir.isAnimating
                        ? null
                        : () {
                            setState(() => _sel = i);
                            _vertir.forward(from: 0).then((_) {
                              if (mounted) setState(() => _medidas.add(i));
                            });
                          },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: i == _sel ? aclarar(color, 0.75) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: i == _sel ? color : Colors.black12, width: 2),
                      ),
                      child: Row(children: [
                        Emoji(_bebidas[i].$1, tam: 24),
                        const SizedBox(width: 6),
                        Expanded(child: Text(_bebidas[i].$2, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
                        if (_medidas.contains(i)) Text('${_bebidas[i].$3}', style: const TextStyle(fontWeight: FontWeight.w700, color: color)),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          left: 504,
          top: 62,
          width: 348,
          height: 300,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color, width: 4)),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Text('${b.$1} ${b.$2}', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: [
                        for (var k = 0; k < cubos; k++)
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: const Color(0xFFBDBDBD), width: 2)),
                            child: const Center(child: Text('🧂', style: TextStyle(fontSize: 14))),
                          ),
                        if (_vertir.value == 1 && b.$3 == 0) const Text('¡Sin azúcar! 💧', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF29B6F6))),
                      ],
                    ),
                  ),
                ),
                Text('≈ $cubos cucharaditas de azúcar', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: color)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        Positioned(left: 504, top: 368, width: 348, child: _texto('Mide todas las bebidas: ${_medidas.length}/${_bebidas.length}')),
        if (_medidas.length == _bebidas.length)
          Positioned(
            left: 680,
            top: 420,
            child: BotonJuego(texto: 'Ver conclusión', icono: Icons.arrow_forward_rounded, color: const Color(0xFF2DB84C), onTap: () => setState(() => _etapa = 2)),
          ),
      ]);
    } else {
      hijos.add(Positioned(
        left: 244,
        top: 62,
        width: 606,
        height: 356,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color, width: 4)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 240, height: 320, child: CustomPaint(painter: _PintorBarrasAzucar())),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _hipotesis == 0 ? '✅ ¡Tu hipótesis era correcta! El refresco tiene más azúcar.' : '🔎 Tu hipótesis era otra, pero los datos muestran que el refresco tiene más azúcar.',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      PreguntaPanel(
                        pregunta: const PreguntaQuiz(
                          pregunta: '¿Cuál es la mejor bebida para quitarte la sed todos los días?',
                          opciones: ['El refresco', 'El agua simple', 'El jugo envasado'],
                          correcta: 1,
                          explicacion: 'El agua simple hidrata sin azúcar. Los expertos recomiendan que un niño consuma menos de 6 cucharaditas de azúcar añadida al día.',
                        ),
                        onAcierto: (p) => setState(() {
                          _primer = p;
                          _listo = true;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
      if (_listo) {
        hijos.add(Positioned(
          left: 680,
          top: 424,
          child: BotonSiguiente(
            texto: 'Terminar',
            onTap: () => terminarPaso(
              context,
              actividad: widget.actividad,
              estrellas: 1 + (_hipotesis == 0 ? 1 : 0) + (_primer ? 1 : 0),
              titulo: '¡Experimento completado!',
              mensaje: 'Descubriste cuánta azúcar tienen algunas bebidas. ¡El agua simple es la mejor opción!',
            ),
          ),
        ));
      }
    }
    const textos = [
      'Algunas bebidas tienen azúcar escondida. Antes de medir, escribe tu hipótesis: ¿cuál crees que tiene más?',
      'Toca cada bebida para “vaciar” su azúcar en cucharaditas. Los datos son aproximados.',
      'Compara los resultados en la gráfica y responde la pregunta final.',
    ];
    return Escenario(
      velo: 0.12,
      colorVelo: color,
      children: [
        ...hijos,
        _encabezado('Laboratorio', '¿Cuánta azúcar tiene?', color),
        _zati(textos[_etapa]),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorBarrasAzucar extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final n = _bebidas.length;
    final paso = (s.height - 20) / n;
    for (var i = 0; i < n; i++) {
      final (e, _, v) = _bebidas[i];
      final y = 10 + i * paso;
      dibujarEmoji(c, e, Offset(18, y + paso / 2), 24);
      final w = (s.width - 70) * v / 16;
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(40, y + 8, math.max(4, w), paso - 16), const Radius.circular(8)),
          Paint()..color = Color.lerp(const Color(0xFF81D4FA), const Color(0xFFE53935), v / 16)!);
      textoEn(c, '$v', Offset(40 + math.max(4, w) + 14, y + paso / 2), tam: 14);
    }
  }

  @override
  bool shouldRepaint(_PintorBarrasAzucar old) => false;
}

// ===========================================================================
// Tema 4 · Laboratorio: ¿qué necesita una planta?
// ===========================================================================

const _macetas = [
  ('A', 'Con luz, agua y aire', true, true, true),
  ('B', 'Sin luz (en un clóset)', false, true, true),
  ('C', 'Sin agua', true, false, true),
  ('D', 'Sin aire (en un frasco cerrado)', true, true, false),
];

class LabPlantas extends StatefulWidget {
  const LabPlantas({super.key, required this.actividad});
  final String actividad;
  @override
  State<LabPlantas> createState() => _LabPlantasState();
}

class _LabPlantasState extends State<LabPlantas> with SingleTickerProviderStateMixin {
  int _etapa = 0;
  int? _hipotesis;
  bool _listo = false, _primer = false;
  late final AnimationController _dias = AnimationController(vsync: this, duration: const Duration(seconds: 7))
    ..addListener(() => setState(() {}))
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _etapa = 2);
    });

  @override
  void dispose() {
    _dias.dispose();
    super.dispose();
  }

  (double, double) _estado(int i, double d) {
    final (_, _, luz, agua, aire) = _macetas[i];
    final ok = luz && agua && aire;
    final crece = ok ? 0.15 + 0.85 * d : 0.15 + 0.35 * math.min(d, 0.4);
    final salud = ok ? 1.0 : (1 - d * (agua ? 0.8 : 1.0)).clamp(0.0, 1.0);
    return (crece, salud);
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF43A047);
    final d = _dias.value;
    return Escenario(
      velo: 0.1,
      colorVelo: color,
      children: [
        _encabezado('Laboratorio', '¿Qué necesita una planta para vivir?', color),
        _zati(
          [
            'Sembramos 4 plantas iguales y las pusimos en lugares distintos. ¿Cuál crees que crecerá mejor? Elige tu hipótesis.',
            'Observa qué pasa con cada planta durante 2 semanas.',
            'Compara las plantas y responde la pregunta para concluir.',
          ][_etapa],
          alto: 190,
        ),
        for (var i = 0; i < 4; i++)
          Positioned(
            left: 244 + i * 152.0,
            top: 62,
            width: 144,
            height: 260,
            child: Rebote(
              onTap: _etapa == 0 ? () => setState(() => _hipotesis = i) : null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _hipotesis == i ? const Color(0xFFFFB300) : color, width: _hipotesis == i ? 5 : 3),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
                      child: Text('${_macetas[i].$1}. ${_macetas[i].$2}',
                          textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.1)),
                    ),
                    Expanded(
                      child: Reloj(builder: (_, t) {
                        final (crece, salud) = _estado(i, d);
                        return CustomPaint(painter: _PintorMaceta(t, crece, salud, _macetas[i]), size: Size.infinite);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_etapa == 0 && _hipotesis != null)
          Positioned(
            left: 600,
            top: 340,
            child: BotonJuego(
              texto: 'Iniciar experimento',
              icono: Icons.play_arrow_rounded,
              color: const Color(0xFF2DB84C),
              onTap: () {
                setState(() => _etapa = 1);
                _dias.forward(from: 0);
              },
            ),
          ),
        if (_etapa >= 1)
          Positioned(left: 244, top: 330, child: _texto('Día ${(d * 14).round()} de 14  ${'🌞' * ((d * 6).round())}')),
        if (_etapa == 2)
          Positioned(
            left: 244,
            top: 352,
            width: 420,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: color, width: 3)),
              child: PreguntaPanel(
                columnas: 1,
                pregunta: const PreguntaQuiz(
                  pregunta: '¿Qué necesita una planta para vivir y crecer?',
                  opciones: ['Solo agua', 'Luz, agua y aire', 'Nada, crece sola'],
                  correcta: 1,
                  explicacion: 'Con luz, agua, aire (dióxido de carbono) y los minerales del suelo, la planta fabrica su alimento: la fotosíntesis.',
                ),
                onAcierto: (p) => setState(() {
                  _primer = p;
                  _listo = true;
                }),
              ),
            ),
          ),
        if (_listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              texto: 'Terminar',
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: 1 + (_hipotesis == 0 ? 1 : 0) + (_primer ? 1 : 0),
                titulo: '¡Experimento completado!',
                mensaje: 'Solo la planta con luz, agua y aire creció sana. Las plantas fabrican su alimento con la fotosíntesis.',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorMaceta extends CustomPainter {
  _PintorMaceta(this.t, this.crece, this.salud, this.maceta);
  final double t, crece, salud;
  final (String, String, bool, bool, bool) maceta;
  @override
  void paint(Canvas c, Size s) {
    final (_, _, luz, agua, aire) = maceta;
    if (!luz) c.drawRect(Offset.zero & s, Paint()..color = const Color(0x55263238));
    if (luz) dibujarEmoji(c, '☀️', Offset(s.width * 0.82, 16), 22);
    final maceta2 = Path()
      ..moveTo(s.width * 0.25, s.height * 0.72)
      ..lineTo(s.width * 0.75, s.height * 0.72)
      ..lineTo(s.width * 0.68, s.height * 0.96)
      ..lineTo(s.width * 0.32, s.height * 0.96)
      ..close();
    c.drawPath(maceta2, Paint()..color = const Color(0xFFD7865A));
    c.drawRect(Rect.fromLTWH(s.width * 0.24, s.height * 0.7, s.width * 0.52, 8), Paint()..color = agua ? const Color(0xFF6D4C41) : const Color(0xFFBCAAA4));
    final r = Rect.fromLTWH(s.width * 0.1, s.height * 0.1, s.width * 0.8, s.height * 0.86);
    dibujarPlanta(c, r, t, crecimiento: crece, salud: salud, raices: false, fruto: false);
    if (!aire) {
      final frasco = RRect.fromRectAndRadius(Rect.fromLTWH(s.width * 0.12, s.height * 0.05, s.width * 0.76, s.height * 0.92), const Radius.circular(16));
      c.drawRRect(frasco, Paint()..color = const Color(0x2290CAF9));
      c.drawRRect(frasco, linea(const Color(0xFF90CAF9), 3));
    }
    if (agua) {
      dibujarEmoji(c, '💧', Offset(s.width * 0.18, s.height * 0.62), 14);
    }
  }

  @override
  bool shouldRepaint(_PintorMaceta old) => true;
}

// ===========================================================================
// Tema 4 · Simulación: la fotosíntesis
// ===========================================================================

class SimFotosintesis extends StatefulWidget {
  const SimFotosintesis({super.key, required this.actividad});
  final String actividad;
  @override
  State<SimFotosintesis> createState() => _SimFotosintesisState();
}

class _SimFotosintesisState extends State<SimFotosintesis> {
  double _luz = 0.2, _agua = 0.2, _co2 = 0.2;
  final _vistos = <String>{};

  double get _produccion => math.min(_luz, math.min(_agua, _co2));

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF43A047);
    final prod = _produccion;
    if (prod > 0.75) _vistos.add('max');
    if (_luz < 0.15) _vistos.add('sinluz');
    final listo = _vistos.containsAll(['max', 'sinluz']);
    Widget control(String nombre, String emoji, double v, ValueChanged<double> f) => Row(
          children: [
            Emoji(emoji, tam: 22),
            const SizedBox(width: 4),
            SizedBox(width: 70, child: Text(nombre, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
            Expanded(child: Slider(value: v, activeColor: color, onChanged: (x) => setState(() => f(x)))),
          ],
        );
    return Escenario(
      velo: 0.12,
      colorVelo: color,
      children: [
        _encabezado('Simulación', 'La fotosíntesis', color),
        _zati(
          prod > 0.75
              ? '¡Así! Con mucha luz, agua y dióxido de carbono la planta produce mucho alimento (azúcar) y libera oxígeno.'
              : 'Las plantas fabrican su propio alimento. Mueve los controles: sube todo al máximo y luego prueba quitar la luz.',
          alto: 190,
        ),
        Positioned(
          left: 244,
          top: 62,
          width: 330,
          height: 400,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: color, width: 4)),
            clipBehavior: Clip.antiAlias,
            child: Reloj(builder: (_, t) => CustomPaint(painter: _PintorFotosintesis(t, _luz, _agua, _co2, prod), size: Size.infinite)),
          ),
        ),
        Positioned(
          left: 586,
          top: 62,
          width: 266,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: color, width: 3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                control('Luz', '☀️', _luz, (x) => _luz = x),
                control('Agua', '💧', _agua, (x) => _agua = x),
                control('CO₂', '💨', _co2, (x) => _co2 = x),
                const Divider(),
                Text('Alimento producido: ${(prod * 100).round()} %', style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: prod, minHeight: 14, color: const Color(0xFFFFB300))),
                const SizedBox(height: 8),
                const Text('Luz + agua + dióxido de carbono → alimento (azúcar) + oxígeno',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 586,
          top: 348,
          width: 266,
          child: _texto('Retos: ${_vistos.contains('max') ? '✅' : '⬜'} todo al máximo  ${_vistos.contains('sinluz') ? '✅' : '⬜'} sin luz', tam: 12.5),
        ),
        if (listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: 3,
                titulo: '¡Entiendes la fotosíntesis!',
                mensaje: 'Sin luz la planta no puede fabricar su alimento. ¡Por eso las plantas buscan el sol!',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _PintorFotosintesis extends CustomPainter {
  _PintorFotosintesis(this.t, this.luz, this.agua, this.co2, this.prod);
  final double t, luz, agua, co2, prod;
  @override
  void paint(Canvas c, Size s) {
    final r = Offset.zero & s;
    c.drawRect(r, Paint()..color = Color.lerp(const Color(0xFF455A64), const Color(0xFFE1F5FE), luz)!);
    c.drawRect(Rect.fromLTWH(0, s.height * 0.72, s.width, s.height * 0.28), Paint()..color = const Color(0xFF8D6E63));
    final sol = Offset(s.width * 0.15, s.height * 0.1);
    c.drawCircle(sol, 26 * (0.5 + luz * 0.6), Paint()..color = const Color(0xFFFFD54F).withValues(alpha: 0.3 + luz * 0.7));
    final hoja = Offset(s.width * 0.45, s.height * 0.4);
    for (var i = 0; i < (luz * 6).round(); i++) {
      final u = (t * 0.5 + i / 6) % 1;
      c.drawCircle(Offset.lerp(sol, hoja, u)!, 4, Paint()..color = const Color(0xFFFFC107));
    }
    for (var i = 0; i < (agua * 5).round(); i++) {
      final u = (t * 0.4 + i / 5) % 1;
      dibujarEmoji(c, '💧', Offset.lerp(Offset(s.width * 0.5, s.height * 0.9), Offset(s.width * 0.5, s.height * 0.5), u)!, 12);
    }
    for (var i = 0; i < (co2 * 5).round(); i++) {
      final u = (t * 0.35 + i / 5) % 1;
      final p = Offset.lerp(Offset(s.width * 0.95, s.height * 0.3 + i * 8), hoja, u)!;
      c.drawCircle(p, 10, Paint()..color = Colors.white);
      textoEn(c, 'CO₂', p, tam: 8, color: Colors.blueGrey);
    }
    for (var i = 0; i < (prod * 6).round(); i++) {
      final u = (t * 0.45 + i / 6) % 1;
      final p = Offset.lerp(hoja, Offset(s.width * 0.1 + i * 20, -10), u)!;
      c.drawCircle(p, 10, Paint()..color = Colors.white);
      textoEn(c, 'O₂', p, tam: 9, color: const Color(0xFF1E88E5));
    }
    dibujarPlanta(c, Rect.fromLTWH(s.width * 0.15, s.height * 0.15, s.width * 0.7, s.height * 0.78), t, crecimiento: 0.6 + 0.4 * prod, salud: 0.4 + 0.6 * prod, fruto: false);
    textoEn(c, '🍬 alimento', Offset(s.width * 0.5, s.height * 0.62), tam: 12 + prod * 6, color: const Color(0xFFE65100), fondo: Colors.white.withValues(alpha: 0.8));
  }

  @override
  bool shouldRepaint(_PintorFotosintesis old) => true;
}

// ===========================================================================
// Tema 5 · Simulación: el equilibrio del ecosistema
// ===========================================================================

const _escenarios = [
  ('Normal', '🌦️', 1.0, 0.0, false),
  ('Sequía', '🏜️', 0.3, 0.0, false),
  ('Sin zorros', '🚫🦊', 1.0, 0.0, true),
  ('Contaminación', '🏭', 1.0, 1.0, false),
];

List<List<double>> simularEcosistema(double lluvia, double contaminacion, bool sinZorros, {int meses = 24}) {
  var p = 70.0, c = 20.0, z = 5.0;
  final out = <List<double>>[
    [p, c, z]
  ];
  for (var m = 0; m < meses; m++) {
    final p2 = p + 30 * lluvia * (1 - p / 100) - 0.6 * c - 20 * contaminacion;
    final c2 = c + 0.012 * c * p - 0.25 * c - 0.06 * c * z - 6 * contaminacion * c / 20;
    final z2 = sinZorros ? 0.0 : z + 0.01 * z * c - 0.15 * z - 2 * contaminacion * z / 10;
    p = p2.clamp(0, 100).toDouble();
    c = math.max(0, c2);
    z = math.max(0, z2);
    out.add([p, c, z]);
  }
  return out;
}

class SimEcosistema extends StatefulWidget {
  const SimEcosistema({super.key, required this.actividad});
  final String actividad;
  @override
  State<SimEcosistema> createState() => _SimEcosistemaState();
}

class _SimEcosistemaState extends State<SimEcosistema> with SingleTickerProviderStateMixin {
  int _e = 0;
  final _vistos = <int>{};
  bool _listo = false, _primer = false;
  late final AnimationController _anim = AnimationController(vsync: this, duration: const Duration(seconds: 6))
    ..addListener(() => setState(() {}))
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) setState(() => _vistos.add(_e));
    });

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFF2E7D32);
    final (nombre, _, ll, co, sz) = _escenarios[_e];
    final datos = simularEcosistema(ll, co, sz);
    final mes = (_anim.value * (datos.length - 1)).floor();
    final actual = datos[mes];
    final textos = {
      0: 'En equilibrio, el pasto, los conejos y los zorros suben y bajan, pero ninguno desaparece.',
      1: 'Con la sequía hay poco pasto. Los conejos no tienen qué comer y bajan, y luego los zorros también.',
      2: 'Sin zorros, los conejos aumentan muchísimo… ¡y se comen todo el pasto! Cada ser vivo es importante.',
      3: 'La contaminación daña a todos: el pasto casi desaparece y los animales no sobreviven.',
    };
    return Escenario(
      velo: 0.12,
      colorVelo: color,
      children: [
        _encabezado('Simulación', 'El equilibrio del ecosistema', color),
        _zati(_vistos.contains(_e) ? textos[_e]! : 'Elige una situación y presiona “Simular” para ver qué pasa en 2 años con el pasto, los conejos y los zorros.', alto: 200),
        Positioned(
          left: 244,
          top: 62,
          width: 400,
          height: 258,
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: color, width: 4)),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  height: 92,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _poblacion('🌿', 'Pasto', actual[0], 100),
                      _poblacion('🐇', 'Conejos', actual[1], 80),
                      _poblacion('🦊', 'Zorros', actual[2], 20),
                    ],
                  ),
                ),
                Expanded(child: CustomPaint(painter: _PintorPoblaciones(datos, _anim.value), size: Size.infinite)),
              ],
            ),
          ),
        ),
        Positioned(
          left: 244,
          top: 326,
          child: _texto('Mes $mes de 24 · $nombre'),
        ),
        Positioned(
          left: 656,
          top: 62,
          width: 196,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < _escenarios.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Rebote(
                    onTap: _anim.isAnimating ? null : () => setState(() => _e = i),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: i == _e ? aclarar(color, 0.7) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: i == _e ? color : Colors.black12, width: 2.5),
                      ),
                      child: Row(children: [
                        Text(_escenarios[i].$2, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 6),
                        Expanded(child: Text(_escenarios[i].$1, style: const TextStyle(fontWeight: FontWeight.w700))),
                        if (_vistos.contains(i)) const Icon(Icons.check_circle_rounded, color: ColoresJuego.correcto, size: 18),
                      ]),
                    ),
                  ),
                ),
              Tooltip(
                message: 'Simular',
                child: BotonJuego(
                  texto: _anim.isAnimating ? 'Simulando…' : 'Simular',
                  icono: Icons.play_arrow_rounded,
                  color: color,
                  onTap: _anim.isAnimating ? null : () => _anim.forward(from: 0),
                ),
              ),
            ],
          ),
        ),
        if (_vistos.length == _escenarios.length)
          Positioned(
            left: 244,
            top: 350,
            width: 400,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: color, width: 3)),
              child: PreguntaPanel(
                pregunta: const PreguntaQuiz(
                  pregunta: '¿Qué pasa si desaparece una especie del ecosistema?',
                  opciones: ['No pasa nada', 'Se rompe el equilibrio y se afectan las demás especies'],
                  correcta: 1,
                  explicacion: 'Todos los seres vivos de un ecosistema están relacionados, por eso hay que cuidar a cada especie.',
                ),
                onAcierto: (p) => setState(() {
                  _primer = p;
                  _listo = true;
                }),
              ),
            ),
          ),
        if (_listo)
          Positioned(
            left: 680,
            top: 424,
            child: BotonSiguiente(
              onTap: () => terminarPaso(
                context,
                actividad: widget.actividad,
                estrellas: _primer ? 3 : 2,
                titulo: '¡Experto en ecosistemas!',
                mensaje: 'Viste que en un ecosistema todos dependen de todos. Si uno cambia, cambian los demás.',
              ),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _poblacion(String e, String nombre, double v, double max) {
    final n = (v / max * 6).round().clamp(0, 6);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(n == 0 ? '—' : e * n, style: const TextStyle(fontSize: 16)),
        Text('$nombre: ${v.round()}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
      ],
    );
  }
}

class _PintorPoblaciones extends CustomPainter {
  _PintorPoblaciones(this.datos, this.progreso);
  final List<List<double>> datos;
  final double progreso;
  @override
  void paint(Canvas c, Size s) {
    final area = Rect.fromLTRB(10, 6, s.width - 10, s.height - 10);
    c.drawLine(area.bottomLeft, area.bottomRight, linea(Colors.black26, 1.5));
    const series = [(0, 100.0, Color(0xFF66BB6A)), (1, 80.0, Color(0xFF8D6E63)), (2, 20.0, Color(0xFFFF7043))];
    final n = (progreso * (datos.length - 1)).floor();
    for (final (k, max, col) in series) {
      final p = Path();
      for (var i = 0; i <= n; i++) {
        final q = Offset(area.left + i / (datos.length - 1) * area.width, area.bottom - (datos[i][k] / max).clamp(0.0, 1.0) * area.height);
        i == 0 ? p.moveTo(q.dx, q.dy) : p.lineTo(q.dx, q.dy);
      }
      c.drawPath(p, linea(col, 3));
    }
  }

  @override
  bool shouldRepaint(_PintorPoblaciones old) => true;
}
