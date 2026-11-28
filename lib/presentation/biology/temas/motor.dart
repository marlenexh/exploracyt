import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/enlaces_videos.dart';
import '../tema1/aventura.dart' show BannerTitulo, BotonRedondo, GloboTexto, LetreroMadera, moradoBanner;
import '../tema1/comunes.dart';
import '../tema1/escenario.dart';
import '../tema1/estilo_mundo.dart';
import '../tema1/juego.dart' show PantallaGirable;
import '../tema1/misiones.dart' show ConfiguracionJuego;
import '../tema1/progreso.dart';
import '../../ciencia/piensa_antes.dart';

/// Motor genérico para los temas 2 a 5 de Biología. Usa las mismas piezas del
/// Tema 1 (Zati, lienzo adaptable, videos, mini misiones) y cada tema solo
/// define su contenido en `temaN.dart`.

enum TipoPasoBio {
  explicacion('Explicación', Icons.menu_book_rounded, Color(0xFFFF8A00)),
  simulacion('Simulación', Icons.touch_app_rounded, Color(0xFF4361EE)),
  laboratorio('Laboratorio', Icons.science_rounded, Color(0xFF06B6A4)),
  video('Video', Icons.ondemand_video_rounded, Color(0xFFFF3D68)),
  juego('Juego', Icons.sports_esports_rounded, Color(0xFF8B5CF6)),
  reto('Reto', Icons.emoji_events_rounded, Color(0xFFFFAA00));

  const TipoPasoBio(this.nombre, this.icono, this.color);
  final String nombre;
  final IconData icono;
  final Color color;
}

class PasoBio {
  const PasoBio(this.titulo, this.tipo, this.id, this.pantalla);
  final String titulo;
  final TipoPasoBio tipo;

  /// Identificador de la actividad (único dentro del tema).
  final String id;
  final Widget Function(String actividad) pantalla;
}

class MisionBio {
  const MisionBio({
    required this.titulo,
    required this.subtitulo,
    required this.emoji,
    required this.color,
    required this.intro,
    required this.mensajeFinal,
    required this.pasos,
  });
  final String titulo;
  final String subtitulo;
  final String emoji;
  final Color color;
  final String intro;
  final String mensajeFinal;
  final List<PasoBio> pasos;

  bool completa(ProgresoJuego p) => pasos.every((x) => p.estrellasDe(x.id) > 0);
  double avance(ProgresoJuego p) => pasos.where((x) => p.estrellasDe(x.id) > 0).length / pasos.length;
  int estrellas(ProgresoJuego p) => pasos.fold(0, (a, x) => a + p.estrellasDe(x.id));
}

class TemaBio {
  TemaBio({
    required this.numero,
    required this.titulo,
    required this.saludo,
    required this.misionDelTema,
    required this.color,
    required this.insignia,
    required this.emojiInsignia,
    required this.emojisPanel,
    required this.misiones,
    this.videos = const {},
    this.mundo = 'bio',
    this.estilo,
  }) {
    // Los videos son complementarios: si una misión no tiene enlace en
    // lib/data/enlaces_videos.dart, su paso de video no se muestra.
    for (var k = 0; k < misiones.length && k < videos.length; k++) {
      final clave = videos.keys.elementAt(k);
      if ((enlacesVideos[clave] ?? '').trim().isEmpty) {
        misiones[k].pasos.removeWhere((p) => p.tipo == TipoPasoBio.video);
      }
    }
  }
  final int numero;

  /// Id del mundo en la app ('bio', 'ele', …).
  final String mundo;

  /// Fondo y letrero propios del mundo; si es null se usa el bosque.
  final EstiloMundo? estilo;
  final String titulo;

  /// Texto de Zati en la intro (después de "¡Hola, …!").
  final String saludo;
  final String misionDelTema;
  final Color color;
  final String insignia;
  final String emojiInsignia;

  /// Emojis que aparecen en el panel "Misión del tema".
  final List<String> emojisPanel;

  /// 3 misiones + actividad integradora (en ese orden).
  final List<MisionBio> misiones;

  /// clave → archivo o URL del video (para PantallaVideoTema).
  final Map<String, String> videos;

  String get id => '$mundo-t$numero';
  List<String> get idsMisiones => [for (var i = 0; i < misiones.length; i++) i == misiones.length - 1 ? '$id-integration' : '$id-m${i + 1}'];
  int get estrellasPosibles => misiones.fold(0, (a, m) => a + m.pasos.length * 3);
  bool completo(ProgresoJuego p) => misiones.every((m) => m.completa(p));
}

/// Hace disponible el tema actual a todas las pantallas.
class TemaScope extends InheritedWidget {
  const TemaScope({super.key, required this.tema, required super.child});
  final TemaBio tema;
  static TemaBio of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<TemaScope>()!.tema;
  static TemaBio read(BuildContext context) => context.getInheritedWidgetOfExactType<TemaScope>()!.tema;
  @override
  bool updateShouldNotify(TemaScope old) => old.tema != tema;
}

/// Abre una pantalla del tema conservando el tema, el progreso y la configuración.
Future<T?> abrirPantallaTema<T>(BuildContext context, Widget pantalla) {
  final tema = TemaScope.read(context);
  return abrirPantalla<T>(context, TemaScope(tema: tema, child: pantalla), conFondo: false);
}

/// Dibuja un emoji grande (usado en casi todas las ilustraciones).
void dibujarEmoji(Canvas c, String e, Offset centro, double tam) {
  final tp = TextPainter(text: TextSpan(text: e, style: TextStyle(fontSize: tam)), textDirection: TextDirection.ltr)..layout();
  tp.paint(c, centro - Offset(tp.width / 2, tp.height / 2));
}

class Emoji extends StatelessWidget {
  const Emoji(this.e, {super.key, this.tam = 30});
  final String e;
  final double tam;
  @override
  Widget build(BuildContext context) => Text(e, style: TextStyle(fontSize: tam, height: 1.1), textAlign: TextAlign.center);
}

// ===========================================================================
// Punto de entrada de un tema
// ===========================================================================

class TemaBioJuego extends StatefulWidget {
  const TemaBioJuego({
    super.key,
    required this.tema,
    this.progreso,
    this.nombreAlumno,
    this.horizontal = true,
    this.desbloquearTodo = false,
  });
  final TemaBio tema;
  final ProgresoJuego? progreso;
  final String? nombreAlumno;
  final bool horizontal;
  final bool desbloquearTodo;
  @override
  State<TemaBioJuego> createState() => _TemaBioJuegoState();
}

class _TemaBioJuegoState extends State<TemaBioJuego> {
  late final ProgresoJuego _progreso = widget.progreso ?? ProgresoJuego();
  final _navegador = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    if (widget.horizontal) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  @override
  void dispose() {
    if (widget.horizontal) {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    if (widget.progreso == null) _progreso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ConfiguracionJuego(
        desbloquearTodo: widget.desbloquearTodo,
        videos: widget.tema.videos,
        nombreAlumno: widget.nombreAlumno,
        child: ProgresoScope(
          progreso: _progreso,
          child: TemaScope(
            tema: widget.tema,
            child: Theme(
              data: temaJuego(),
              child: _conEstilo(PantallaGirable(
                child: NavigatorPopHandler(
                  onPopWithResult: (_) => _navegador.currentState?.maybePop(),
                  child: ScaffoldMessenger(
                    child: Navigator(
                      key: _navegador,
                      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => const PantallaIntroBio()),
                    ),
                  ),
                ),
              )),
            ),
          ),
        ),
      );

  Widget _conEstilo(Widget hijo) {
    final e = widget.tema.estilo;
    return e == null ? hijo : FondoJuego(estilo: e, child: hijo);
  }
}

/// Botón para regresar: dentro del juego o, en la primera pantalla, a la app.
class _BotonSalirTema extends StatelessWidget {
  const _BotonSalirTema();
  @override
  Widget build(BuildContext context) {
    final propio = Navigator.of(context);
    final raiz = Navigator.of(context, rootNavigator: true);
    return Positioned(
      left: 8,
      top: 8,
      child: BotonRedondo(
        icono: Icons.arrow_back_rounded,
        tam: 50,
        etiqueta: 'Regresar',
        onTap: () => propio.canPop() ? propio.maybePop() : raiz.maybePop(),
      ),
    );
  }
}

// ===========================================================================
// Intro del tema
// ===========================================================================

class PantallaIntroBio extends StatelessWidget {
  const PantallaIntroBio({super.key});
  @override
  Widget build(BuildContext context) {
    final tema = TemaScope.of(context);
    final p = ProgresoScope.of(context);
    final nombre = ConfiguracionJuego.of(context).nombreAlumno;
    final texto = '${nombre == null || nombre.isEmpty ? '¡Hola!' : '¡Hola, $nombre!'}\n\n${tema.saludo}\n\n¿Comenzamos?';
    return Escenario(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 6,
          child: Center(child: Entrada(desde: const Offset(0, -40), child: BannerTitulo('Tema ${tema.numero}\n${tema.titulo}', tam: 24))),
        ),
        const Positioned(left: 4, top: 150, child: SizedBox(width: 230, height: 320, child: ZatiMascota(tam: 320))),
        Positioned(
          left: 236,
          top: 130,
          width: 330,
          child: Entrada(
            indice: 1,
            child: GloboTexto(child: TextoMaquina(texto, estilo: const TextStyle(fontSize: 17, height: 1.3, color: ColoresJuego.texto))),
          ),
        ),
        Positioned(
          left: 590,
          top: 92,
          width: 258,
          height: 370,
          child: Entrada(indice: 2, desde: const Offset(60, 0), child: _PanelMisionDelTema(tema: tema, progreso: p)),
        ),
        Positioned(
          left: 300,
          top: 400,
          child: Entrada(
            indice: 3,
            desde: const Offset(0, 50),
            child: Tooltip(
              message: 'Comenzar',
              child: BotonJuego(
                texto: tema.completo(p) ? 'Ver misiones' : 'Comenzar',
                icono: Icons.play_arrow_rounded,
                color: const Color(0xFF2DB84C),
                grande: true,
                onTap: () => abrirPantallaTema(context, const PantallaMisionesBio()),
              ),
            ),
          ),
        ),
        const _BotonSalirTema(),
      ],
    );
  }
}

class _PanelMisionDelTema extends StatelessWidget {
  const _PanelMisionDelTema({required this.tema, required this.progreso});
  final TemaBio tema;
  final ProgresoJuego progreso;
  @override
  Widget build(BuildContext context) {
    final hechas = tema.misiones.where((m) => m.completa(progreso)).length;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFFFF4D6), Color(0xFFF3DDA8)]),
        border: Border.all(color: const Color(0xFFB98A45), width: 3),
        boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 12, offset: Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Misión del tema', textAlign: TextAlign.center, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Color(0xFF5B2CA8))),
          Container(height: 2.5, margin: const EdgeInsets.symmetric(vertical: 6), color: const Color(0xFFD9B36E)),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Text(tema.misionDelTema, style: const TextStyle(fontSize: 14, height: 1.25, color: Color(0xFF3B2A12))),
            ),
          ),
          Expanded(
            flex: 3,
            child: Reloj(
              builder: (_, t) => Stack(
                alignment: Alignment.center,
                children: [
                  for (var i = 0; i < tema.emojisPanel.length; i++)
                    Align(
                      alignment: Alignment(
                        math.cos(i / tema.emojisPanel.length * 2 * math.pi + t * 0.3) * 0.75,
                        math.sin(i / tema.emojisPanel.length * 2 * math.pi + t * 0.3) * 0.7,
                      ),
                      child: Emoji(tema.emojisPanel[i], tam: 30),
                    ),
                  Emoji(tema.emojiInsignia, tam: 46),
                ],
              ),
            ),
          ),
          Text('Misiones completadas: $hechas/${tema.misiones.length}',
              textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5B2CA8))),
        ],
      ),
    );
  }
}

// ===========================================================================
// Menú de misiones
// ===========================================================================

bool misionBioDesbloqueada(BuildContext context, TemaBio tema, ProgresoJuego p, int i) =>
    ConfiguracionJuego.of(context).desbloquearTodo || i == 0 || tema.misiones[i - 1].completa(p);

class PantallaMisionesBio extends StatelessWidget {
  const PantallaMisionesBio({super.key});
  @override
  Widget build(BuildContext context) {
    final tema = TemaScope.of(context);
    final p = ProgresoScope.of(context);
    return Escenario(
      children: [
        Positioned(left: 0, right: 0, top: 8, child: Center(child: LetreroMadera(tema.titulo, tam: 24))),
        for (var i = 0; i < tema.misiones.length; i++)
          Positioned(
            left: 18 + i * 208.0,
            top: 76,
            width: 196,
            height: 390,
            child: Entrada(
              indice: i + 1,
              desde: const Offset(0, 70),
              child: _TarjetaMisionBio(tema: tema, indice: i, progreso: p),
            ),
          ),
        const _BotonSalirTema(),
      ],
    );
  }
}

class _TarjetaMisionBio extends StatefulWidget {
  const _TarjetaMisionBio({required this.tema, required this.indice, required this.progreso});
  final TemaBio tema;
  final int indice;
  final ProgresoJuego progreso;
  @override
  State<_TarjetaMisionBio> createState() => _TarjetaMisionBioState();
}

class _TarjetaMisionBioState extends State<_TarjetaMisionBio> with SingleTickerProviderStateMixin {
  late final AnimationController _temblor = AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
  String? _aviso;

  @override
  void dispose() {
    _temblor.dispose();
    super.dispose();
  }

  void _tocar() {
    final abierta = misionBioDesbloqueada(context, widget.tema, widget.progreso, widget.indice);
    if (!abierta) {
      _temblor.forward(from: 0);
      setState(() => _aviso = '🔒 Primero completa “${widget.tema.misiones[widget.indice - 1].titulo}”.');
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _aviso = null);
      });
      return;
    }
    abrirMisionBio(context, widget.indice);
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.tema.misiones[widget.indice];
    final abierta = misionBioDesbloqueada(context, widget.tema, widget.progreso, widget.indice);
    final completa = m.completa(widget.progreso);
    final avance = m.avance(widget.progreso);
    return AnimatedBuilder(
      animation: _temblor,
      builder: (_, child) => Transform.translate(
        offset: Offset(math.sin(_temblor.value * math.pi * 6) * 8 * (1 - _temblor.value), 0),
        child: child,
      ),
      child: Rebote(
        onTap: _tocar,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white, aclarar(m.color, 0.7)]),
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: oscurecer(m.color, 0.3), offset: const Offset(0, 6)),
              const BoxShadow(color: Color(0x44000000), blurRadius: 14, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Center(
                  child: Opacity(
                    opacity: abierta ? 1 : 0.6,
                    child: Movimiento(
                      tipo: TipoMovimiento.flotar,
                      fase: widget.indice.toDouble(),
                      intensidad: abierta ? 1 : 0,
                      child: Emoji(m.emoji, tam: 82),
                    ),
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(m.titulo, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700, color: ColoresJuego.texto)),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    _aviso ?? m.subtitulo,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _aviso == null ? 15.5 : 13,
                      fontWeight: FontWeight.w600,
                      color: _aviso == null ? oscurecer(m.color, 0.3) : moradoBanner,
                      height: 1.1,
                    ),
                  ),
                ),
              ),
              if (!abierta)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF3B2A6B), width: 3)),
                  child: const Icon(Icons.lock_rounded, color: Color(0xFF3B2A6B), size: 28),
                )
              else if (completa)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: ColoresJuego.correcto, borderRadius: BorderRadius.circular(20)),
                  child: const Text('✓ ¡Lograda!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BotonRedondo(icono: Icons.play_arrow_rounded, tam: 48, onTap: _tocar, etiqueta: 'Jugar ${m.titulo}'),
                    if (avance > 0) ...[
                      const SizedBox(width: 6),
                      Text('${(avance * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700, color: moradoBanner, fontSize: 15)),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// Flujo de una misión
// ===========================================================================

/// Juega los pasos pendientes uno tras otro. Si el alumno sale a la mitad
/// se muestra el mapa de pasos. Al completar la misión pasa a la siguiente;
/// al completar el tema muestra la insignia.
Future<void> abrirMisionBio(BuildContext context, int indice) async {
  final tema = TemaScope.read(context);
  final p = ProgresoScope.read(context);
  final m = tema.misiones[indice];
  bool hecho(PasoBio x) => p.estrellasDe(x.id) > 0;
  if (m.completa(p)) {
    await abrirPantallaTema(context, PantallaPasosBio(indice: indice));
    return;
  }
  var i = m.pasos.indexWhere((x) => !hecho(x));
  while (i != -1) {
    final paso = m.pasos[i];
    await abrirPantallaTema(context, conPrediccion(paso.id, paso.pantalla(paso.id)));
    if (!context.mounted) return;
    if (!hecho(paso)) {
      await abrirPantallaTema(context, PantallaPasosBio(indice: indice));
      return;
    }
    i = m.pasos.indexWhere((x) => !hecho(x));
  }
  await _alCompletarMision(context, indice);
}

Future<void> _alCompletarMision(BuildContext context, int indice) async {
  final tema = TemaScope.read(context);
  final m = tema.misiones[indice];
  final siguiente = indice + 1 < tema.misiones.length ? tema.misiones[indice + 1] : null;
  await mostrarCelebracion(
    context,
    titulo: '¡${m.titulo} cumplida!',
    mensaje: '${m.mensajeFinal}${siguiente == null ? '' : '\n¡Ahora sigue “${siguiente.titulo}: ${siguiente.subtitulo}”!'}',
    estrellas: 3,
  );
  if (!context.mounted) return;
  if (siguiente != null) {
    await abrirMisionBio(context, indice + 1);
  } else {
    await abrirPantallaTema(context, const PantallaInsigniaBio());
  }
}

class PantallaPasosBio extends StatefulWidget {
  const PantallaPasosBio({super.key, required this.indice});
  final int indice;
  @override
  State<PantallaPasosBio> createState() => _PantallaPasosBioState();
}

class _PantallaPasosBioState extends State<PantallaPasosBio> {
  ProgresoJuego? _p;
  late bool _estabaCompleta;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_p == null) {
      _p = ProgresoScope.read(context);
      _estabaCompleta = TemaScope.read(context).misiones[widget.indice].completa(_p!);
      _p!.addListener(_revisar);
    }
  }

  @override
  void dispose() {
    _p?.removeListener(_revisar);
    super.dispose();
  }

  void _revisar() {
    final completa = TemaScope.read(context).misiones[widget.indice].completa(_p!);
    if (completa && !_estabaCompleta) {
      _estabaCompleta = true;
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) _alCompletarMision(context, widget.indice);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = TemaScope.of(context);
    final p = ProgresoScope.of(context);
    final m = tema.misiones[widget.indice];
    final libre = ConfiguracionJuego.of(context).desbloquearTodo;
    final siguiente = m.pasos.indexWhere((x) => p.estrellasDe(x.id) == 0);
    final hechos = m.pasos.where((x) => p.estrellasDe(x.id) > 0).length;
    final texto = siguiente == -1
        ? '¡Completaste todos los pasos! Puedes repetirlos para ganar más estrellas.'
        : siguiente == 0
            ? m.intro
            : '¡Muy bien! Sigue con el paso ${siguiente + 1}: “${m.pasos[siguiente].titulo}”.';
    final columnas = m.pasos.length > 8 ? 5 : 4;
    final filas = (m.pasos.length / columnas).ceil();
    final ancho = (600 - (columnas - 1) * 8) / columnas;
    final alto = math.min(150.0, (322 - (filas - 1) * 8) / filas);
    return Escenario(
      children: [
        Positioned(left: 0, right: 0, top: 6, child: Center(child: BannerTitulo('${m.titulo}: ${m.subtitulo}', tam: 22, color: oscurecer(m.color, 0.05)))),
        Positioned(
          left: 0,
          top: 66,
          child: ZatiConGlobo(texto: texto, tamZati: 170, anchoGlobo: 228, altoGlobo: 200, tamLetra: 14.5, globoArriba: true),
        ),
        Positioned(
          left: 244,
          top: 70,
          width: 600,
          child: Row(
            children: [
              Text('Pasos: $hechos/${m.pasos.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 15, shadows: [Shadow(blurRadius: 4)])),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(value: hechos / m.pasos.length, minHeight: 12, color: m.color, backgroundColor: Colors.white),
                ),
              ),
            ],
          ),
        ),
        for (var i = 0; i < m.pasos.length; i++)
          Positioned(
            left: 244 + (i % columnas) * (ancho + 8),
            top: 100 + (i ~/ columnas) * (alto + 8),
            width: ancho,
            height: alto,
            child: _TarjetaPasoBio(
              paso: m.pasos[i],
              numero: i + 1,
              abierto: libre || i == 0 || p.estrellasDe(m.pasos[i - 1].id) > 0,
              actual: i == siguiente,
              estrellas: p.estrellasDe(m.pasos[i].id),
              onTap: () => abrirPantallaTema(context, conPrediccion(m.pasos[i].id, m.pasos[i].pantalla(m.pasos[i].id))),
            ),
          ),
        const BotonVolverEscena(),
      ],
    );
  }
}

class _TarjetaPasoBio extends StatelessWidget {
  const _TarjetaPasoBio({
    required this.paso,
    required this.numero,
    required this.abierto,
    required this.actual,
    required this.estrellas,
    required this.onTap,
  });
  final PasoBio paso;
  final int numero;
  final bool abierto, actual;
  final int estrellas;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final base = abierto ? paso.tipo.color : Colors.grey.shade500;
    final tarjeta = Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: abierto ? 1 : 0.8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: actual ? const Color(0xFFFFC107) : Colors.white, width: actual ? 4 : 3),
        boxShadow: [
          BoxShadow(color: oscurecer(base, 0.35), offset: const Offset(0, 4)),
          if (actual) BoxShadow(color: const Color(0xFFFFC107).withValues(alpha: 0.6), blurRadius: 14),
        ],
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: SizedBox(
          width: 140,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 22, backgroundColor: base, child: Icon(abierto ? paso.tipo.icono : Icons.lock_rounded, color: Colors.white, size: 24)),
              const SizedBox(height: 4),
              Text('Paso $numero · ${paso.tipo.nombre}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: base)),
              Text(paso.titulo,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, height: 1.1)),
              const SizedBox(height: 2),
              estrellas > 0
                  ? FilaEstrellas(estrellas, tam: 20)
                  : Text(abierto ? (actual ? '¡Juega ahora!' : 'Disponible') : 'Bloqueado',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: abierto ? moradoBanner : Colors.grey)),
            ],
          ),
        ),
      ),
    );
    return Rebote(
      onTap: abierto ? onTap : null,
      child: actual ? Movimiento(tipo: TipoMovimiento.flotar, intensidad: 0.5, child: tarjeta) : tarjeta,
    );
  }
}

// ===========================================================================
// Insignia final del tema
// ===========================================================================

class PantallaInsigniaBio extends StatelessWidget {
  const PantallaInsigniaBio({super.key});
  @override
  Widget build(BuildContext context) {
    final tema = TemaScope.of(context);
    final p = ProgresoScope.of(context);
    final nombre = ConfiguracionJuego.of(context).nombreAlumno;
    return Escenario(
      velo: 0.25,
      colorVelo: const Color(0xFF3B2A6B),
      children: [
        const Positioned.fill(child: LluviaConfeti(cantidad: 80)),
        Positioned(left: 0, right: 0, top: 6, child: Center(child: BannerTitulo('¡Completaste el Tema ${tema.numero}!', tam: 26, color: const Color(0xFFFF8A00)))),
        const Positioned(left: 20, top: 150, child: SizedBox(width: 200, height: 300, child: ZatiMascota(tam: 300))),
        Positioned(
          left: 240,
          top: 76,
          width: 380,
          child: Column(
            children: [
              SizedBox(
                width: 230,
                height: 230,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Movimiento(
                      tipo: TipoMovimiento.girar,
                      intensidad: 0.3,
                      child: Container(
                        width: 220,
                        height: 220,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(colors: [Color(0xFFFFE082), Color(0xFFFFF3C4), Color(0xFFFFE082), Color(0xFFFFF3C4), Color(0xFFFFE082)]),
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.elasticOut,
                      builder: (_, v, child) => Transform.scale(scale: v, child: child),
                      child: Container(
                        width: 150,
                        height: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const RadialGradient(colors: [Color(0xFFFFF59D), Color(0xFFFFC107), Color(0xFFF57F17)]),
                          border: Border.all(color: Colors.white, width: 5),
                          boxShadow: const [BoxShadow(color: Color(0xFFB8860B), offset: Offset(0, 5))],
                        ),
                        child: Emoji(tema.emojiInsignia, tam: 72),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFFC107), width: 4)),
                child: Column(
                  children: [
                    Text('${nombre == null || nombre.isEmpty ? 'Ganaste' : '$nombre, ganaste'} la insignia',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(tema.insignia, textAlign: TextAlign.center, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w700, color: Color(0xFFE67E00))),
                    Text('⭐ ${tema.misiones.fold(0, (a, m) => a + m.estrellas(p))} de ${tema.estrellasPosibles} estrellas',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 636,
          top: 90,
          width: 214,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final m in tema.misiones)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: m.color, width: 3)),
                  child: Row(
                    children: [
                      Emoji(m.emoji, tam: 24),
                      const SizedBox(width: 6),
                      Expanded(child: Text(m.subtitulo, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13))),
                      const Icon(Icons.check_circle_rounded, color: ColoresJuego.correcto),
                    ],
                  ),
                ),
              const SizedBox(height: 6),
              Tooltip(
                message: 'Volver a las misiones',
                child: BotonJuego(
                  texto: '¡Terminar!',
                  icono: Icons.emoji_events_rounded,
                  color: const Color(0xFFFF8A00),
                  grande: true,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
