import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../biology/tema1/comunes.dart' show Reloj;
import 'fondo_vocacion.dart';
import 'profesiones_datos.dart';
import '../ciencia/barajar.dart';

/// Explora profesiones de ciencia y tecnología.
class ExploraProfesionesScreen extends StatefulWidget {
  const ExploraProfesionesScreen({super.key});

  /// Profesiones favoritas guardadas (por nombre).
  static const String claveFavoritas = 'profesiones_favoritas';

  @override
  State<ExploraProfesionesScreen> createState() => ExploraProfesionesScreenState();
}

class ExploraProfesionesScreenState extends State<ExploraProfesionesScreen> {
  Set<String> favoritas = {};
  String? area;
  bool soloFavoritas = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => favoritas = (p.getStringList(ExploraProfesionesScreen.claveFavoritas) ?? []).toSet());
  }

  Future<void> alternarFavorita(String nombre) async {
    setState(() {
      if (!favoritas.remove(nombre)) favoritas.add(nombre);
    });
    final p = await SharedPreferences.getInstance();
    await p.setStringList(ExploraProfesionesScreen.claveFavoritas, favoritas.toList());
  }

  void filtrar(String? a) => setState(() {
        area = a;
        soloFavoritas = false;
      });

  List<ProfesionInfo> get visibles => [
        for (final p in profesiones)
          if ((area == null || p.area == area) && (!soloFavoritas || favoritas.contains(p.nombre))) p
      ];

  Future<void> abrir(ProfesionInfo p) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) => DetalleProfesionScreen(profesion: p, favorita: favoritas.contains(p.nombre), onFavorita: () => alternarFavorita(p.nombre)),
        transitionsBuilder: (_, a, __, hijo) => FadeTransition(opacity: a, child: ScaleTransition(scale: Tween(begin: 0.92, end: 1.0).animate(a), child: hijo)),
      ),
    );
    _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final lista = visibles;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoVocacion(velo: 0.15),
        SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final columnas = c.maxWidth > 1000 ? 4 : (c.maxWidth > 640 ? 3 : 2);
            return CustomScrollView(slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                sliver: SliverToBoxAdapter(
                  child: Column(children: [
                    Row(children: [
                      IconButton.filled(
                        tooltip: 'Volver',
                        style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF3B1F6E)),
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text('EXPLORA PROFESIONES',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 24, fontFamily: 'LilitaOne', shadows: [Shadow(color: Colors.black54, blurRadius: 6)])),
                        ),
                      ),
                      Tooltip(
                        message: 'Mis favoritas',
                        child: ChoiceChip(
                          label: Text('❤️ ${favoritas.length}', style: const TextStyle(fontWeight: FontWeight.w900)),
                          selected: soloFavoritas,
                          onSelected: (v) => setState(() => soloFavoritas = v),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 8),
                    Text('${profesiones.length} profesiones de ciencia y tecnología te esperan. ¡Toca una para descubrir su mundo!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, shadows: [Shadow(color: Colors.black54, blurRadius: 4)])),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 44,
                      child: ListView(scrollDirection: Axis.horizontal, children: [
                        _filtro(null, '✨', 'Todas', const Color(0xFF7C4DFF)),
                        for (final a in areasProfesiones) _filtro(a.$1, a.$2, a.$1, a.$3),
                      ]),
                    ),
                  ]),
                ),
              ),
              if (lista.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Text('Todavía no tienes favoritas. Toca el ❤️ de una profesión para guardarla.',
                        textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 6, 14, 20),
                sliver: SliverGrid(
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: columnas, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.82),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => _TarjetaProfesion(
                      key: ValueKey('${lista[i].nombre}-$area-$soloFavoritas'),
                      profesion: lista[i],
                      indice: i,
                      favorita: favoritas.contains(lista[i].nombre),
                      onTap: () => abrir(lista[i]),
                      onFavorita: () => alternarFavorita(lista[i].nombre),
                    ),
                    childCount: lista.length,
                  ),
                ),
              ),
            ]);
          }),
        ),
      ]),
    );
  }

  Widget _filtro(String? valor, String emoji, String texto, Color color) {
    final activo = area == valor && !soloFavoritas;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Tooltip(
        message: 'Filtro $texto',
        child: GestureDetector(
          onTap: () => filtrar(valor),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: activo ? color : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: color, width: 2.5),
              boxShadow: activo ? [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 8)] : null,
            ),
            child: Text('$emoji $texto', style: TextStyle(fontWeight: FontWeight.w900, color: activo ? Colors.white : color)),
          ),
        ),
      ),
    );
  }
}

class _TarjetaProfesion extends StatefulWidget {
  const _TarjetaProfesion({super.key, required this.profesion, required this.indice, required this.favorita, required this.onTap, required this.onFavorita});
  final ProfesionInfo profesion;
  final int indice;
  final bool favorita;
  final VoidCallback onTap, onFavorita;
  @override
  State<_TarjetaProfesion> createState() => _TarjetaProfesionState();
}

class _TarjetaProfesionState extends State<_TarjetaProfesion> {
  bool _presionado = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.profesion;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (widget.indice % 8) * 90),
      curve: Curves.easeOutBack,
      builder: (_, v, hijo) => Transform.scale(scale: 0.6 + 0.4 * v, child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
      child: Tooltip(
        message: p.nombre,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _presionado = true),
          onTapCancel: () => setState(() => _presionado = false),
          onTapUp: (_) => setState(() => _presionado = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _presionado ? 0.94 : 1,
            duration: const Duration(milliseconds: 120),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.lerp(p.color, Colors.white, 0.2)!, Color.lerp(p.color, Colors.black, 0.25)!]),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 10, 10),
                  child: Column(children: [
                    Expanded(
                      child: Reloj(
                        builder: (_, t) => Stack(alignment: Alignment.center, children: [
                          Container(
                            width: 96 + 6 * math.sin(t * 2 + widget.indice),
                            height: 96 + 6 * math.sin(t * 2 + widget.indice),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          Container(width: 78, height: 78, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white)),
                          Transform.translate(
                            offset: Offset(0, math.sin(t * 2.2 + widget.indice) * 4),
                            child: Hero(tag: 'prof-${p.nombre}', child: Text(p.emoji, style: const TextStyle(fontSize: 44))),
                          ),
                        ]),
                      ),
                    ),
                    Text(p.nombre,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontFamily: 'LilitaOne',
                            height: 1.05,
                            shadows: [Shadow(color: Colors.black38, blurRadius: 3)])),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: Text('${emojiArea(p.area)} ${p.area}',
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: p.color)),
                    ),
                  ]),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: IconButton(
                    tooltip: 'Favorita ${p.nombre}',
                    onPressed: widget.onFavorita,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (h, a) => ScaleTransition(scale: a, child: h),
                      child: Icon(widget.favorita ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          key: ValueKey(widget.favorita), color: widget.favorita ? const Color(0xFFFF4081) : Colors.white, size: 28),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Detalle de una profesión
// ===========================================================================

class DetalleProfesionScreen extends StatefulWidget {
  const DetalleProfesionScreen({super.key, required this.profesion, required this.favorita, required this.onFavorita});
  final ProfesionInfo profesion;
  final bool favorita;
  final VoidCallback onFavorita;
  @override
  State<DetalleProfesionScreen> createState() => DetalleProfesionScreenState();
}

class DetalleProfesionScreenState extends State<DetalleProfesionScreen> {
  late bool favorita = widget.favorita;
  int? herramienta;

  /// Momento del día que se está viendo (null: ninguno).
  int? momento;
  bool viviendoDia = false;
  int? respuesta;
  bool volteada = false;
  Timer? _timer;

  ProfesionInfo get p => widget.profesion;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void alternarFavorita() {
    widget.onFavorita();
    setState(() => favorita = !favorita);
  }

  void vivirDia() {
    _timer?.cancel();
    setState(() {
      momento = 0;
      viviendoDia = true;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 1400), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        if (momento! < p.dia.length - 1) {
          momento = momento! + 1;
        } else {
          t.cancel();
          viviendoDia = false;
        }
      });
    });
  }

  void elegirMomento(int i) {
    _timer?.cancel();
    setState(() {
      momento = i;
      viviendoDia = false;
    });
  }

  void responder(int i) => setState(() => respuesta = i);
  void voltear() => setState(() => volteada = !volteada);
  void elegirHerramienta(int i) => setState(() => herramienta = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        const FondoVocacion(velo: 0.35),
        SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            final ancho = c.maxWidth > 760;
            final izquierda = [_queHace(), _herramientas(), _dondeTrabaja()];
            final derecha = [_unDia(), _reto(), _sabiasQue(), _mundos()];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(children: [
                    _encabezado(ancho),
                    const SizedBox(height: 12),
                    if (ancho)
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: Column(children: _escalonar(izquierda, 0))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(children: _escalonar(derecha, 3))),
                      ])
                    else
                      Column(children: _escalonar([...izquierda, ...derecha], 0)),
                  ]),
                ),
              ),
            );
          }),
        ),
      ]),
    );
  }

  List<Widget> _escalonar(List<Widget> ws, int desde) => [
        for (var i = 0; i < ws.length; i++)
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + (i + desde) * 140),
            curve: Curves.easeOutCubic,
            builder: (_, v, hijo) => Transform.translate(offset: Offset(0, (1 - v) * 40), child: Opacity(opacity: v.clamp(0.0, 1.0), child: hijo)),
            child: Padding(padding: const EdgeInsets.only(bottom: 12), child: ws[i]),
          ),
      ];

  Widget _encabezado(bool ancho) {
    final icono = SizedBox(
      width: 190,
      height: 190,
      child: Reloj(
        builder: (_, t) => Stack(alignment: Alignment.center, children: [
          for (var k = 0; k < p.herramientas.length; k++)
            Transform.translate(
              offset: Offset(math.cos(t * 0.7 + k * math.pi / 2) * 78, math.sin(t * 0.7 + k * math.pi / 2) * 78),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), shape: BoxShape.circle),
                child: Text(p.herramientas[k].$1, style: const TextStyle(fontSize: 22)),
              ),
            ),
          Container(
            width: 112,
            height: 112,
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 12)]),
          ),
          Transform.translate(
            offset: Offset(0, math.sin(t * 2) * 5),
            child: Hero(tag: 'prof-${p.nombre}', child: Text(p.emoji, style: const TextStyle(fontSize: 64))),
          ),
        ]),
      ),
    );
    final textos = Column(crossAxisAlignment: ancho ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
        child: Text('${emojiArea(p.area)} ${p.area}', style: TextStyle(fontWeight: FontWeight.w900, color: p.color)),
      ),
      const SizedBox(height: 6),
      Text(p.nombre,
          textAlign: ancho ? TextAlign.start : TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontSize: 30, fontFamily: 'LilitaOne', height: 1.05, shadows: [Shadow(color: Colors.black45, blurRadius: 5)])),
      const SizedBox(height: 6),
      Text(p.descripcion,
          textAlign: ancho ? TextAlign.start : TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, height: 1.25)),
    ]);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color.lerp(p.color, Colors.white, 0.15)!, Color.lerp(p.color, Colors.black, 0.35)!]),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [BoxShadow(color: p.color.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 6))],
      ),
      child: Stack(children: [
        ancho ? Row(children: [icono, const SizedBox(width: 16), Expanded(child: textos)]) : Column(children: [icono, textos]),
        Positioned(
          left: 0,
          top: 0,
          child: IconButton.filled(
            tooltip: 'Volver',
            style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: p.color),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton.filled(
            tooltip: favorita ? 'Quitar de favoritas' : 'Agregar a favoritas',
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            onPressed: alternarFavorita,
            icon: TweenAnimationBuilder<double>(
              key: ValueKey(favorita),
              tween: Tween(begin: 0.5, end: 1),
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              builder: (_, v, h) => Transform.scale(scale: v, child: h),
              child: Icon(favorita ? Icons.favorite_rounded : Icons.favorite_border_rounded, color: const Color(0xFFFF4081)),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _seccion(String emoji, String titulo, Widget hijo) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: p.color, width: 3),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('$emoji $titulo', style: TextStyle(fontSize: 20, fontFamily: 'LilitaOne', color: Color.lerp(p.color, Colors.black, 0.3))),
          const SizedBox(height: 8),
          DefaultTextStyle.merge(style: const TextStyle(color: Color(0xFF26215C)), child: hijo),
        ]),
      );

  Widget _queHace() => _seccion(
        '🛠️',
        '¿Qué hace?',
        Column(children: [
          for (var i = 0; i < p.queHace.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(children: [
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                  child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                ),
                const SizedBox(width: 8),
                Expanded(child: Text(p.queHace[i], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
              ]),
            ),
        ]),
      );

  Widget _herramientas() => _seccion(
        '🧰',
        'Sus herramientas · toca una',
        Column(children: [
          Row(children: [
            for (var i = 0; i < p.herramientas.length; i++)
              Expanded(
                child: Tooltip(
                  message: 'Herramienta ${p.herramientas[i].$2}',
                  child: GestureDetector(
                    onTap: () => elegirHerramienta(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: herramienta == i ? 86 : 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: herramienta == i ? Color.lerp(p.color, Colors.white, 0.75) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: herramienta == i ? p.color : Colors.black12, width: 2.5),
                      ),
                      child: Text(p.herramientas[i].$1, style: TextStyle(fontSize: herramienta == i ? 42 : 32)),
                    ),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              herramienta == null ? 'Toca una herramienta para conocerla.' : '¡${p.herramientas[herramienta!].$2}! ${p.herramientas[herramienta!].$1}',
              key: ValueKey(herramienta),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color.lerp(p.color, Colors.black, 0.3)),
            ),
          ),
        ]),
      );

  Widget _dondeTrabaja() => _seccion(
        '📍',
        '¿Dónde trabaja?',
        Row(children: [
          for (final (e, lugar) in p.dondeTrabaja)
            Expanded(
              child: Column(children: [
                Reloj(builder: (_, t) => Transform.rotate(angle: math.sin(t * 2 + lugar.length) * 0.08, child: Text(e, style: const TextStyle(fontSize: 34)))),
                Text(lugar, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
              ]),
            ),
        ]),
      );

  Widget _unDia() => _seccion(
        '⏰',
        'Un día de trabajo',
        Column(children: [
          for (var i = 0; i < p.dia.length; i++)
            GestureDetector(
              onTap: () => elegirMomento(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: momento == i ? Color.lerp(p.color, Colors.white, 0.75) : const Color(0xFFF7F7FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: momento == i ? p.color : Colors.transparent, width: 2.5),
                ),
                child: Row(children: [
                  SizedBox(width: 54, child: Text(p.dia[i].$1, style: TextStyle(fontWeight: FontWeight.w900, color: p.color))),
                  AnimatedScale(
                      scale: momento == i ? 1.35 : 1,
                      duration: const Duration(milliseconds: 300),
                      child: Text(p.dia[i].$2, style: const TextStyle(fontSize: 24))),
                  const SizedBox(width: 8),
                  Expanded(child: Text(p.dia[i].$3, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                ]),
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: Tooltip(
              message: 'Vive un día',
              child: FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: p.color),
                onPressed: viviendoDia ? null : vivirDia,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(viviendoDia ? 'Viviendo el día…' : '▶ Vive un día'),
              ),
            ),
          ),
        ]),
      );

  Widget _reto() {
    final (pregunta, opciones, correcta, explicacion) = p.reto;
    return _seccion(
      '🎯',
      'Mini reto',
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(pregunta, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        for (final (pos, i) in ordenOpciones(pregunta, opciones.length).indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Tooltip(
              message: 'Respuesta ${pos + 1}',
              child: GestureDetector(
                onTap: respuesta == correcta ? null : () => responder(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: respuesta == i ? (i == correcta ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE)) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border:
                        Border.all(color: respuesta == i ? (i == correcta ? const Color(0xFF43A047) : const Color(0xFFE53935)) : Colors.black12, width: 2.5),
                  ),
                  child: Text('${respuesta == i ? (i == correcta ? '✅ ' : '❌ ') : ''}${opciones[i]}',
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ),
        if (respuesta != null)
          TweenAnimationBuilder<double>(
            key: ValueKey(respuesta),
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 450),
            curve: Curves.elasticOut,
            builder: (_, v, h) => Transform.scale(scale: v, alignment: Alignment.centerLeft, child: h),
            child: Text(respuesta == correcta ? '⭐ ¡Reto superado! $explicacion' : '¡Casi! Inténtalo otra vez.',
                style:
                    TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900, color: respuesta == correcta ? const Color(0xFF2E7D32) : const Color(0xFFC62828))),
          ),
      ]),
    );
  }

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
                  height: 130,
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: frente ? const [Color(0xFFFFCA28), Color(0xFFFF8F00)] : const [Color(0xFFFFF8E1), Color(0xFFFFECB3)]),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(frente ? 0 : math.pi),
                    child: frente
                        ? const Text('💡 ¿Sabías que…?\nToca para descubrirlo',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 20, fontFamily: 'LilitaOne', color: Colors.white, shadows: [Shadow(color: Colors.black38, blurRadius: 3)]))
                        : Text(p.dato,
                            textAlign: TextAlign.center, style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: Color(0xFF5D4037))),
                  ),
                ),
              );
            },
          ),
        ),
      );

  Widget _mundos() => _seccion(
        '🗺️',
        'Practícala en el juego',
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final m in p.mundos)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Color.lerp(colorArea(m), Colors.white, 0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorArea(m), width: 2)),
              child: Text('${emojiArea(m)} Mundo de $m', style: TextStyle(fontWeight: FontWeight.w900, color: Color.lerp(colorArea(m), Colors.black, 0.3))),
            ),
        ]),
      );
}
