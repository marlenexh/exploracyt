import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import 'creditos_retratos.dart';
import 'personajes_datos.dart';

const _claveVisitadas = 'personas_visitadas';

/// Museo “Personas que transforman el mundo”.
class PersonasTransformanScreen extends StatefulWidget {
  const PersonasTransformanScreen({super.key});
  @override
  State<PersonasTransformanScreen> createState() => PersonasTransformanScreenState();
}

class PersonasTransformanScreenState extends State<PersonasTransformanScreen> {
  Set<String> visitadas = {};

  /// Sala que se está recorriendo.
  String? sala = salasMuseo.first.$1;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => visitadas = (p.getStringList(_claveVisitadas) ?? []).toSet());
  }

  void elegirSala(String? s) => setState(() => sala = s ?? salasMuseo.first.$1);

  int get _indiceSala => salasMuseo.indexWhere((s) => s.$1 == sala).clamp(0, salasMuseo.length - 1);

  /// Caminar a la sala de al lado.
  void caminar(int dir) => setState(() => sala = salasMuseo[(_indiceSala + dir) % salasMuseo.length].$1);

  Future<void> abrir(PersonajeInfo p) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (_, __, ___) => DetallePersonajeScreen(personaje: p),
        transitionsBuilder: (_, a, __, h) => FadeTransition(opacity: a, child: h),
      ),
    );
    _cargar();
  }

  Future<void> jugar() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const QuienSoyScreen()));
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final s = salasMuseo[_indiceSala];
    final cuadros = personajes.where((p) => p.sala == s.$1).toList();
    final vistos = cuadros.where((p) => visitadas.contains(p.nombre)).length;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        // La sala: la pared toma el color del área
        AnimatedSwitcher(duration: const Duration(milliseconds: 400), child: FondoMuseo(key: ValueKey(s.$1), color: s.$3)),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(children: [
                IconButton.filled(
                  tooltip: 'Volver',
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.account_balance_rounded, color: Color(0xFFFFE082), size: 26),
                const SizedBox(width: 6),
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Museo · Personas que transforman el mundo',
                        style:
                            TextStyle(color: Color(0xFFFFE082), fontSize: 22, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 6)])),
                  ),
                ),
                _boleto(),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Juego ¿Quién soy?',
                  child: MediaQuery.sizeOf(context).width < 600
                      ? IconButton.filled(
                          style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFB300), foregroundColor: const Color(0xFF3E2723)),
                          onPressed: jugar,
                          icon: const Icon(Icons.casino_rounded),
                        )
                      : FilledButton.icon(
                          style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFB300), foregroundColor: const Color(0xFF3E2723)),
                          onPressed: jugar,
                          icon: const Icon(Icons.casino_rounded),
                          label: const Text('¿Quién soy?', style: TextStyle(fontWeight: FontWeight.w900)),
                        ),
                ),
              ]),
            ),
            // Las salas del museo
            SizedBox(
              height: 50,
              child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.fromLTRB(12, 6, 12, 0), children: [
                for (final x in salasMuseo) _chipSala(x),
              ]),
            ),
            // Letrero de la sala en la pared
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _flecha(Icons.chevron_left_rounded, 'Sala anterior', () => caminar(-1)),
                Flexible(child: _letrero(s, vistos, cuadros.length)),
                _flecha(Icons.chevron_right_rounded, 'Sala siguiente', () => caminar(1)),
              ]),
            ),
            // Cuadros colgados en la pared
            Expanded(
              child: LayoutBuilder(
                builder: (context, c) {
                  final alto = c.maxHeight.clamp(220.0, 360.0);
                  final ancho = alto * 0.62;
                  return Stack(children: [
                    // Riel de donde cuelgan los cuadros
                    Positioned(left: 0, right: 0, top: 6, child: Container(height: 6, color: const Color(0xFFC9A227))),
                    Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          for (final (i, p) in cuadros.indexed)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: _Retrato(
                                key: ValueKey(p.nombre),
                                personaje: p,
                                indice: i,
                                ancho: ancho,
                                alto: alto,
                                visitado: visitadas.contains(p.nombre),
                                onTap: () => abrir(p),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ]);
                },
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _flecha(IconData icono, String texto, VoidCallback onTap) => Tooltip(
        message: texto,
        child: IconButton.filled(
          style: IconButton.styleFrom(backgroundColor: const Color(0xCCFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
          onPressed: onTap,
          icon: Icon(icono, size: 30),
        ),
      );

  Widget _boleto() => Tooltip(
        message: 'Personas visitadas',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFB8860B), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.confirmation_number_rounded, color: Color(0xFF8D6E1E), size: 20),
            const SizedBox(width: 4),
            Text('${visitadas.length}/${personajes.length}', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF5D4037))),
          ]),
        ),
      );

  Widget _chipSala((String, String, Color) x) {
    final activo = sala == x.$1;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tooltip(
        message: 'Sala ${x.$1}',
        child: GestureDetector(
          onTap: () => elegirSala(x.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: activo ? x.$3 : const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFB8860B), width: 2),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(iconoSala(x.$1), size: 18, color: activo ? Colors.white : x.$3),
              const SizedBox(width: 4),
              Text(x.$1, style: TextStyle(fontWeight: FontWeight.w900, color: activo ? Colors.white : const Color(0xFF5D4037))),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _letrero((String, String, Color) s, int vistos, int total) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFC9A227), Color(0xFFFFE082)]),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8D6E1E), width: 2),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(iconoSala(s.$1), color: const Color(0xFF3E2723)),
            const SizedBox(width: 6),
            Text('Sala de ${s.$1}', style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 20, color: Color(0xFF3E2723))),
            const SizedBox(width: 10),
            Text('$vistos de $total visitados', style: const TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
          ]),
        ),
      );
}

/// Ícono (dibujo de Flutter) de cada sala.
IconData iconoSala(String sala) => switch (sala) {
      'Vida y salud' => Icons.biotech_rounded,
      'Química' => Icons.science_rounded,
      'Física' => Icons.blur_circular_rounded,
      'Electrónica y tecnología' => Icons.electrical_services_rounded,
      'Computación e IA' => Icons.computer_rounded,
      _ => Icons.rocket_launch_rounded,
    };

/// Ícono (dibujo de Flutter) del objeto de la vitrina de cada persona.
IconData iconoObjeto(String objeto) {
  const iconos = {
    'Tortuga': Icons.pets_rounded,
    'Chimpancé': Icons.forest_rounded,
    'ADN': Icons.biotech_rounded,
    'Leche': Icons.local_drink_rounded,
    'Moho': Icons.medication_rounded,
    'chícharo': Icons.spa_rounded,
    'radio': Icons.science_rounded,
    'ozono': Icons.public_rounded,
    'Tabla periódica': Icons.grid_on_rounded,
    'Balanza': Icons.scale_rounded,
    'manzana': Icons.south_rounded,
    'tiempo': Icons.schedule_rounded,
    'Telescopio': Icons.travel_explore_rounded,
    'Bobina': Icons.bolt_rounded,
    'Televisión': Icons.tv_rounded,
    'Señales': Icons.wifi_tethering_rounded,
    'página web': Icons.language_rounded,
    'Máquina analítica': Icons.settings_rounded,
    'Turing': Icons.smart_toy_rounded,
    'bug': Icons.bug_report_rounded,
    'Cálculos': Icons.calculate_rounded,
    'Satélite': Icons.satellite_alt_rounded,
    'flauta': Icons.music_note_rounded,
  };
  for (final e in iconos.entries) {
    if (objeto.contains(e.key)) return e.value;
  }
  return Icons.star_rounded;
}

/// País sin banderas (emojis): solo el texto.
String paisSinBandera(String pais) => pais.replaceAll(RegExp('[\u{1F1E6}-\u{1F1FF}]', unicode: true), '').replaceAll(RegExp(r'\s+'), ' ').trim();

/// Retrato colgado en la pared: alambre, marco dorado, foco y placa.
class _Retrato extends StatefulWidget {
  const _Retrato(
      {super.key, required this.personaje, required this.indice, required this.visitado, required this.onTap, required this.ancho, required this.alto});
  final PersonajeInfo personaje;
  final int indice;
  final bool visitado;
  final VoidCallback onTap;
  final double ancho, alto;
  @override
  State<_Retrato> createState() => _RetratoState();
}

class _RetratoState extends State<_Retrato> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.personaje;
    final c = colorSala(p.sala);
    final w = widget.ancho, h = widget.alto;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + widget.indice * 150),
      curve: Curves.easeOutBack,
      builder: (_, v, hijo) => Transform.translate(offset: Offset(0, (1 - v) * -40), child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
      child: Tooltip(
        message: p.nombre,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _presionado = true),
          onTapCancel: () => setState(() => _presionado = false),
          onTapUp: (_) => setState(() => _presionado = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _presionado ? 0.95 : 1,
            duration: const Duration(milliseconds: 120),
            child: SizedBox(
              width: w + 20,
              height: h,
              child: Reloj(
                builder: (_, t) => Transform.rotate(
                  // Se mece un poquito, colgado de su alambre
                  angle: math.sin(t * 0.9 + widget.indice) * 0.012,
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    CustomPaint(size: Size(w * 0.7, h * 0.08), painter: _Alambre()),
                    // Marco dorado con el retrato
                    Expanded(
                      child: Container(
                        width: w,
                        padding: EdgeInsets.all(w * 0.07),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFE082), Color(0xFFB8860B), Color(0xFFFFD54F), Color(0xFF8D6E1E)]),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            const BoxShadow(color: Colors.black87, blurRadius: 12, offset: Offset(0, 8)),
                            BoxShadow(color: Color.fromRGBO(255, 241, 180, 0.25 + 0.1 * math.sin(t * 1.5 + widget.indice)), blurRadius: 30),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(colors: [Color.lerp(c, Colors.white, 0.55)!, Color.lerp(c, Colors.black, 0.2)!]),
                            border: Border.all(color: const Color(0xFF5D4037), width: 2),
                          ),
                          child: Stack(children: [
                            Positioned.fill(child: RetratoPersonaje(personaje: p)),
                            if (widget.visitado)
                              Positioned(
                                left: 2,
                                top: 4,
                                child: Transform.rotate(
                                  angle: -0.3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: const Color(0xFFC62828), width: 2),
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white70),
                                    child: const Text('VISITADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
                                  ),
                                ),
                              ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Placa de latón
                    Container(
                      width: w,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFC9A227), Color(0xFFFFE082), Color(0xFFC9A227)]),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFF8D6E1E), width: 1.5),
                      ),
                      child: Column(children: [
                        Text(p.nombre,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF3E2723), height: 1.05)),
                        Text(p.anios, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF5D4037))),
                      ]),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Alambre en forma de triángulo del que cuelga el cuadro.
class _Alambre extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final l = Paint()
      ..color = const Color(0xFF9E9E9E)
      ..strokeWidth = 2;
    c.drawLine(Offset(s.width / 2, 0), Offset(0, s.height), l);
    c.drawLine(Offset(s.width / 2, 0), Offset(s.width, s.height), l);
    c.drawCircle(Offset(s.width / 2, 2), 4, Paint()..color = const Color(0xFFC9A227));
  }

  @override
  bool shouldRepaint(_Alambre old) => false;
}

/// Fondo del museo: pared del color de la sala con molduras, focos del techo
/// y piso de madera.
class FondoMuseo extends StatelessWidget {
  const FondoMuseo({super.key, this.color = const Color(0xFF6D1F1F)});
  final Color color;
  @override
  Widget build(BuildContext context) => RepaintBoundary(child: CustomPaint(painter: _PintorMuseo(color), child: const SizedBox.expand()));
}

class _PintorMuseo extends CustomPainter {
  const _PintorMuseo(this.color);
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final piso = s.height * 0.86;
    final pared = Color.lerp(color, Colors.black, 0.45)!;
    c.drawRect(
        Rect.fromLTWH(0, 0, s.width, piso),
        Paint()
          ..shader = LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color.lerp(pared, Colors.black, 0.35)!, pared, Color.lerp(pared, Colors.black, 0.15)!])
              .createShader(Rect.fromLTWH(0, 0, s.width, piso)));
    // Techo con moldura y focos
    c.drawRect(Rect.fromLTWH(0, 0, s.width, 18), Paint()..color = Color.lerp(pared, Colors.black, 0.6)!);
    c.drawRect(Rect.fromLTWH(0, 18, s.width, 4), Paint()..color = const Color(0xFFC9A227));
    for (var x = 60.0; x < s.width; x += 180) {
      c.drawCircle(
          Offset(x, 26),
          26,
          Paint()
            ..shader = const RadialGradient(colors: [Color(0x66FFE082), Color(0x00FFE082)]).createShader(Rect.fromCircle(center: Offset(x, 26), radius: 26)));
      final cono = Path()
        ..moveTo(x - 10, 24)
        ..lineTo(x + 10, 24)
        ..lineTo(x + 90, piso * 0.85)
        ..lineTo(x - 90, piso * 0.85)
        ..close();
      c.drawPath(
          cono,
          Paint()
            ..shader = const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x22FFF1B4), Color(0x00FFF1B4)])
                .createShader(Rect.fromLTWH(0, 0, s.width, piso)));
    }
    // Paneles de la pared
    final moldura = Paint()
      ..color = const Color(0x33FFE082)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (var x = 20.0; x < s.width - 40; x += 200) {
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, 70, 170, piso - 150), const Radius.circular(6)), moldura);
    }
    // Zoclo
    c.drawRect(Rect.fromLTWH(0, piso - 40, s.width, 40), Paint()..color = Color.lerp(pared, Colors.black, 0.4)!);
    c.drawRect(Rect.fromLTWH(0, piso - 42, s.width, 4), Paint()..color = const Color(0xFFC9A227));
    // Piso de madera
    c.drawRect(Rect.fromLTWH(0, piso, s.width, s.height - piso), Paint()..color = const Color(0xFF8D5A2B));
    final tabla = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1.5;
    for (var y = piso + 14.0; y < s.height; y += 14) {
      c.drawLine(Offset(0, y), Offset(s.width, y), tabla);
    }
    for (var x = 0.0; x < s.width; x += 90) {
      c.drawLine(Offset(x, piso), Offset(x - 30, s.height), tabla);
    }
    // Alfombra
    c.drawRect(
        Rect.fromLTWH(s.width * 0.3, piso, s.width * 0.4, s.height - piso), Paint()..color = Color.lerp(color, Colors.black, 0.3)!.withValues(alpha: 0.7));
  }

  @override
  bool shouldRepaint(_PintorMuseo old) => old.color != color;
}

// ===========================================================================
// La información de cada persona: tarjetas que se deslizan de 1 en 1
// ===========================================================================

class DetallePersonajeScreen extends StatefulWidget {
  const DetallePersonajeScreen({super.key, required this.personaje});
  final PersonajeInfo personaje;
  @override
  State<DetallePersonajeScreen> createState() => DetallePersonajeScreenState();
}

class DetallePersonajeScreenState extends State<DetallePersonajeScreen> {
  bool volteada = false;
  bool sello = false;
  int pagina = 0;
  final _paginas = PageController(viewportFraction: 0.86);
  static const totalTarjetas = 5;

  PersonajeInfo get p => widget.personaje;

  @override
  void initState() {
    super.initState();
    _visitar();
  }

  @override
  void dispose() {
    _paginas.dispose();
    super.dispose();
  }

  Future<void> _visitar() async {
    final pref = await SharedPreferences.getInstance();
    final lista = (pref.getStringList(_claveVisitadas) ?? []).toSet();
    final nueva = lista.add(p.nombre);
    await pref.setStringList(_claveVisitadas, lista.toList());
    if (nueva && mounted) {
      setState(() => sello = true);
      Timer(const Duration(milliseconds: 2200), () {
        if (mounted) setState(() => sello = false);
      });
    }
  }

  void voltear() => setState(() => volteada = !volteada);

  void irA(int i) => _paginas.animateToPage(i.clamp(0, totalTarjetas - 1), duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);

  @override
  Widget build(BuildContext context) {
    final c = colorSala(p.sala);
    final tarjetas = [
      _tarjeta(Icons.portrait_rounded, 'Retrato', c, _retrato(c)),
      _tarjeta(Icons.emoji_events_rounded, 'Su gran aporte', c, _aporte(c)),
      _tarjeta(Icons.timeline_rounded, 'Línea del tiempo', c, SingleChildScrollView(child: _lineaTiempo(c))),
      _tarjeta(Icons.lightbulb_rounded, '¿Sabías que…?', c, _sabiasQue()),
      _tarjeta(Icons.auto_awesome_rounded, 'Lo que nos enseña', c, _ensenanza(c)),
    ];
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        FondoMuseo(color: c),
        Container(color: Colors.black.withValues(alpha: 0.35)),
        SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: Row(children: [
                IconButton.filled(
                  tooltip: 'Volver al museo',
                  style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 10),
                Icon(iconoSala(p.sala), color: const Color(0xFFFFE082)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text('Sala de ${p.sala} · ${p.nombre}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFFFFE082), fontSize: 18, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
                ),
              ]),
            ),
            // Tarjetas que se deslizan de 1 en 1
            Expanded(
              child: PageView(
                controller: _paginas,
                onPageChanged: (i) => setState(() => pagina = i),
                children: [
                  for (final t in tarjetas) Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6), child: t),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Tooltip(
                  message: 'Tarjeta anterior',
                  child: IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: const Color(0xCCFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                    onPressed: pagina > 0 ? () => irA(pagina - 1) : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                ),
                const SizedBox(width: 8),
                for (var i = 0; i < totalTarjetas; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == pagina ? 22 : 10,
                    height: 10,
                    decoration: BoxDecoration(color: i == pagina ? const Color(0xFFFFE082) : Colors.white54, borderRadius: BorderRadius.circular(5)),
                  ),
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Tarjeta siguiente',
                  child: IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: const Color(0xCCFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                    onPressed: pagina < totalTarjetas - 1 ? () => irA(pagina + 1) : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              ]),
            ),
          ]),
        ),
        if (sello)
          IgnorePointer(
            child: Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 2.5, end: 1),
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutBack,
                builder: (_, v, h) => Transform.scale(scale: v, child: Transform.rotate(angle: -0.25, child: h)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.92),
                      border: Border.all(color: const Color(0xFFC62828), width: 5),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.verified_rounded, color: Color(0xFFC62828), size: 30),
                    SizedBox(width: 6),
                    Text('¡SELLO DE VISITANTE!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
                  ]),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  static const _texto = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.35, color: Color(0xFF3E2723));

  Widget _tarjeta(IconData icono, String titulo, Color c, Widget hijo) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF0),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFC9A227), width: 4),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0, 6))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(children: [
            CircleAvatar(radius: 18, backgroundColor: c, child: Icon(icono, color: Colors.white, size: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(titulo, style: TextStyle(fontSize: 22, fontFamily: 'LilitaOne', color: Color.lerp(c, Colors.black, 0.3)))),
            const Icon(Icons.swipe_rounded, color: Colors.black26),
          ]),
          const SizedBox(height: 8),
          Expanded(child: DefaultTextStyle.merge(style: const TextStyle(color: Color(0xFF3E2723), fontSize: 16), child: hijo)),
        ]),
      );

  /// Tarjeta 1: el retrato enmarcado con su placa.
  Widget _retrato(Color c) => LayoutBuilder(
        builder: (_, cons) {
          final alto = cons.maxHeight - 70;
          return Column(children: [
            Container(
              height: alto.clamp(80.0, 400.0),
              width: alto.clamp(80.0, 400.0) * 0.8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFB8860B), Color(0xFFFFD54F), Color(0xFF8D6E1E)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(colors: [Color.lerp(c, Colors.white, 0.6)!, Color.lerp(c, Colors.black, 0.25)!]),
                  border: Border.all(color: const Color(0xFF5D4037), width: 3),
                ),
                child: RetratoPersonaje(personaje: p),
              ),
            ),
            const SizedBox(height: 8),
            Text('${paisSinBandera(p.pais)} · ${p.anios}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            if (creditosRetratos[archivoRetrato(p.nombre)] != null)
              Text('Foto: ${creditosRetratos[archivoRetrato(p.nombre)]}',
                  textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 10, color: Color(0xFF5D4037), height: 1.1)),
          ]);
        },
      );

  /// Tarjeta 2: su gran aporte, con el objeto girando en una vitrina.
  Widget _aporte(Color c) => LayoutBuilder(
        builder: (_, cons) {
          final vitrina = _vitrina(c);
          final texto = Text(p.aporte, style: _texto);
          return cons.maxWidth > 420
              ? Row(children: [vitrina, const SizedBox(width: 16), Expanded(child: SingleChildScrollView(child: texto))])
              : Column(children: [vitrina, const SizedBox(height: 10), Expanded(child: SingleChildScrollView(child: texto))]);
        },
      );

  Widget _vitrina(Color c) => SizedBox(
        width: 150,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0x55B3E5FC), Color(0x22FFFFFF)]),
              border: Border.all(color: const Color(0xAA90A4AE), width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Reloj(
              builder: (_, t) => Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(t * 1.2),
                  child: Icon(iconoObjeto(p.objeto.$2), size: 72, color: c),
                ),
              ),
            ),
          ),
          Container(width: 150, height: 16, decoration: BoxDecoration(color: const Color(0xFF5D4037), borderRadius: BorderRadius.circular(3))),
          const SizedBox(height: 4),
          Text(p.objeto.$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
        ]),
      );

  Widget _lineaTiempo(Color c) => Column(children: [
        for (var i = 0; i < p.historia.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 600 + i * 450),
            curve: Curves.easeOutBack,
            builder: (_, v, h) => Opacity(opacity: v.clamp(0.0, 1.0), child: Transform.scale(scale: 0.8 + 0.2 * v, alignment: Alignment.centerLeft, child: h)),
            child: IntrinsicHeight(
              child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                SizedBox(
                  width: 30,
                  child: Column(children: [
                    Container(
                        width: 18, height: 18, decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 3))),
                    if (i < p.historia.length - 1) Expanded(child: Container(width: 3, color: c.withValues(alpha: 0.5))),
                  ]),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: '${p.historia[i].$1}  ', style: TextStyle(fontWeight: FontWeight.w900, color: c, fontSize: 17)),
                      TextSpan(text: p.historia[i].$2, style: const TextStyle(fontSize: 16)),
                    ])),
                  ),
                ),
              ]),
            ),
          ),
      ]);

  /// Tarjeta 4: el dato curioso se descubre al voltearlo.
  Widget _sabiasQue() => Tooltip(
        message: 'Voltear dato curioso',
        child: GestureDetector(
          onTap: voltear,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: volteada ? math.pi : 0),
            duration: const Duration(milliseconds: 500),
            builder: (_, a, __) {
              final frente = a < math.pi / 2;
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(a),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: frente ? const [Color(0xFFFFCA28), Color(0xFFFF8F00)] : const [Color(0xFFFFF8E1), Color(0xFFFFECB3)]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFC9A227), width: 3),
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(frente ? 0 : math.pi),
                    child: frente
                        ? const Column(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.touch_app_rounded, color: Colors.white, size: 54),
                            Text('Toca para descubrirlo',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22, fontFamily: 'LilitaOne', color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 3)])),
                          ])
                        : Text(p.dato,
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
                  ),
                ),
              );
            },
          ),
        ),
      );

  /// Tarjeta 5: lo que nos enseña, con el sello de la visita.
  Widget _ensenanza(Color c) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.format_quote_rounded, size: 46, color: c),
        Text(p.ensenanza, textAlign: TextAlign.center, style: _texto.copyWith(fontSize: 19)),
        const SizedBox(height: 14),
        Transform.rotate(
          angle: -0.12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFC62828), width: 3), borderRadius: BorderRadius.circular(8)),
            child: const Text('VISITADO', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFC62828))),
          ),
        ),
      ]);
}

// ===========================================================================
// Juego ¿Quién soy?
// ===========================================================================

class PreguntaQuienSoy {
  const PreguntaQuienSoy(this.correcta, this.opciones);
  final PersonajeInfo correcta;
  final List<PersonajeInfo> opciones;
}

/// Arma [n] preguntas con 3 opciones cada una.
List<PreguntaQuienSoy> armarQuienSoy(math.Random rnd, {int n = 5}) {
  final orden = [...personajes]..shuffle(rnd);
  return [
    for (final p in orden.take(n))
      PreguntaQuienSoy(
          p,
          ([
            p,
            ...([...personajes.where((x) => x != p)]..shuffle(rnd)).take(2)
          ])
            ..shuffle(rnd)),
  ];
}

class QuienSoyScreen extends StatefulWidget {
  const QuienSoyScreen({super.key, this.semilla});
  final int? semilla;
  @override
  State<QuienSoyScreen> createState() => QuienSoyScreenState();
}

class QuienSoyScreenState extends State<QuienSoyScreen> {
  late final preguntas = armarQuienSoy(math.Random(widget.semilla));
  int actual = 0, aciertos = 0;
  PersonajeInfo? elegido;

  bool get terminado => actual >= preguntas.length;

  void elegir(PersonajeInfo p) {
    if (elegido != null || terminado) return;
    setState(() {
      elegido = p;
      if (p == preguntas[actual].correcta) aciertos++;
    });
  }

  void siguiente() => setState(() {
        actual++;
        elegido = null;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoMuseo(),
        Container(color: Colors.black.withValues(alpha: 0.3)),
        SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Column(children: [
                  Row(children: [
                    IconButton.filled(
                      tooltip: 'Volver al museo',
                      style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF8E1), foregroundColor: const Color(0xFF5D1A1A)),
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('¿QUIÉN SOY?',
                            style: TextStyle(
                                color: Color(0xFFFFE082), fontSize: 26, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black, blurRadius: 6)])),
                      ),
                    ),
                    Text('★ $aciertos', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                  ]),
                  const SizedBox(height: 14),
                  if (terminado) _final() else ..._pregunta(),
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  List<Widget> _pregunta() {
    final q = preguntas[actual];
    return [
      Text('Pregunta ${actual + 1} de ${preguntas.length}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      const SizedBox(height: 8),
      TweenAnimationBuilder<double>(
        key: ValueKey(actual),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (_, v, h) => Transform.scale(scale: v, child: h),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFC9A227), width: 3)),
          child: Text('“${q.correcta.pista}”',
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800, color: Color(0xFF3E2723))),
        ),
      ),
      const SizedBox(height: 14),
      Wrap(alignment: WrapAlignment.center, spacing: 12, runSpacing: 12, children: [
        for (final p in q.opciones)
          Tooltip(
            message: 'Elegir ${p.nombre}',
            child: GestureDetector(
              onTap: () => elegir(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 170,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFE082), Color(0xFFB8860B)]),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: elegido == null
                          ? Colors.transparent
                          : (p == q.correcta ? const Color(0xFF43A047) : (p == elegido ? const Color(0xFFE53935) : Colors.transparent)),
                      width: 5),
                  boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Column(children: [
                  Container(
                    height: 130,
                    width: double.infinity,
                    color: Color.lerp(colorSala(p.sala), Colors.white, 0.5),
                    child: RetratoPersonaje(personaje: p, tamEmoji: 64),
                  ),
                  const SizedBox(height: 6),
                  Text(p.nombre, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF3E2723))),
                ]),
              ),
            ),
          ),
      ]),
      const SizedBox(height: 14),
      if (elegido != null) ...[
        Text(elegido == q.correcta ? '¡Correcto! Es ${q.correcta.nombre}. ${q.correcta.aporte}' : '¡Casi! Era ${q.correcta.nombre}. ${q.correcta.aporte}',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, shadows: [Shadow(color: Colors.black, blurRadius: 4)])),
        const SizedBox(height: 8),
        Tooltip(
          message: 'Siguiente pregunta',
          child: FilledButton.icon(
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFFB300), foregroundColor: const Color(0xFF3E2723)),
            onPressed: siguiente,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: const Text('Siguiente', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ),
      ],
    ];
  }

  Widget _final() => TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 700),
        curve: Curves.elasticOut,
        builder: (_, v, h) => Transform.scale(scale: v, child: h),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: const Color(0xFFFFFBF0), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFC9A227), width: 4)),
          child: Column(children: [
            Icon(aciertos == preguntas.length ? Icons.emoji_events_rounded : (aciertos >= 3 ? Icons.military_tech_rounded : Icons.menu_book_rounded),
                size: 80, color: const Color(0xFFFFB300)),
            Text('¡Acertaste $aciertos de ${preguntas.length}!', style: const TextStyle(fontSize: 26, fontFamily: 'LilitaOne', color: Color(0xFF3E2723))),
            const SizedBox(height: 6),
            Text(aciertos == preguntas.length ? '¡Eres guía experto del museo!' : 'Visita las salas del museo para conocer a más personas y vuelve a jugar.',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Volver al museo')),
          ]),
        ),
      );
}

/// Retrato de una persona: su imagen, o una silueta si todavía no hay imagen.
class RetratoPersonaje extends StatelessWidget {
  const RetratoPersonaje({super.key, required this.personaje, this.tamEmoji = 64});
  final PersonajeInfo personaje;
  final double tamEmoji;

  @override
  Widget build(BuildContext context) => Image.asset(
        personaje.imagen,
        fit: BoxFit.cover,
        alignment: const Alignment(0, -0.4),
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, __, ___) => Center(child: Icon(Icons.person_rounded, size: tamEmoji, color: Colors.white70)),
      );
}
