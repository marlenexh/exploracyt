import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../data/models.dart';
import '../data/worlds.dart';
import '../main.dart' show store;
import 'game_widgets.dart';
import 'screens.dart' show RutaMundo;
import 'package:flutter/services.dart';
import 'eventos/eventos_screen.dart';
import 'vocacion/vocacion_screen.dart';
import 'dart:async';

/// Fondo principal
Widget fondoMontanas({required Widget child}) => Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/fondo.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.expand(),
        ),
        child,
      ],
    );

const _sombra = [
  Shadow(
    color: Colors.black54,
    blurRadius: 4,
    offset: Offset(0, 2),
  ),
];

/// Título del proyecto.
Widget tituloMadera({double size = 24}) => Semantics(
      label: 'Explora Ciencia y Tecnología',
      child: Image.asset(
        'assets/titulo.png',
        height: size * 4.2,
        fit: BoxFit.contain,
      ),
    );

/// Pantalla de bienvenida.
class Bienvenida extends StatefulWidget {
  const Bienvenida({super.key});

  @override
  State<Bienvenida> createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  final _n = TextEditingController();
  int _g = 5;

  @override
  void dispose() {
    _n.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: fondoMontanas(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 1),
                FittedBox(
                  child: tituloMadera(
                    size: (MediaQuery.of(context).size.width * .04)
                        .clamp(35.0, 53.0), //tamaño de titulo en bienvenida
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Zati(
                              size: math.min(
                                (MediaQuery.of(context).size.height * .25)
                                    .clamp(90.0, 200.0),
                                MediaQuery.of(context).size.width * .45,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '¡Hola! Soy Zati. '
                                    '¿Cómo te llamas, explorador?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: C.tinta,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: _n,
                                    maxLength: 20,
                                    style: const TextStyle(
                                      color: C.tinta,
                                      fontSize: 20,
                                    ),
                                    decoration: const InputDecoration(
                                      labelText: 'Nombre de explorador',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  SegmentedButton<int>(
                                    segments: const [
                                      ButtonSegment(
                                        value: 5,
                                        label: Text('5.º grado'),
                                      ),
                                      ButtonSegment(
                                        value: 6,
                                        label: Text('6.º grado'),
                                      ),
                                    ],
                                    selected: {_g},
                                    onSelectionChanged: (s) =>
                                        setState(() => _g = s.first),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            GameButton(
                              '¡Comenzar!',
                              icon: Icons.play_arrow,
                              color: C.sol,
                              textColor: C.tinta,
                              onTap: () async {
                                if (_n.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Escribe tu nombre para continuar.',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                await store.registrar(_n.text, _g);

                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Home(),
                                    ),
                                    (_) => false,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

const _img = {
  'bio': 'assets/icons/bio.png',
  'qui': 'assets/icons/qui.png',
  'fis': 'assets/icons/fis.png',
  'ele': 'assets/icons/ele.png',
  'ia': 'assets/icons/ia.png',
  'pro': 'assets/icons/pro.png',
};

/// Tarjeta de cada materia.
class SubjectButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? imagen;
  final Color color;
  final double progress;
  final VoidCallback? onTap;
  final double iconScale;
  final double cardBorderWidth;
  final double cardRadius;
  final double titleFontSize;

  const SubjectButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.imagen,
    this.progress = 0,
    this.onTap,
    this.iconScale = 0.6,
    this.cardBorderWidth = 2,
    this.cardRadius = 22,
    this.titleFontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    final claro = Color.lerp(color, Colors.white, .3)!;
    final oscuro = Color.lerp(color, Colors.black, .25)!;

    return Semantics(
      button: onTap != null,
      label: '$title, progreso ${(progress * 100).round()} por ciento',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(cardRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [claro, color, oscuro],
          ),
          border: Border.all(
            color: Colors.white.withOpacity(.65),
            width: cardBorderWidth,
          ),
          boxShadow: [
            BoxShadow(
              color: oscuro,
              offset: const Offset(0, 5),
            ),
            const BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(cardRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Transform.scale(
                    scale: iconScale,
                    child: imagen == null
                        ? Icon(
                            icon,
                            size: 48,
                            color: Colors.white,
                          )
                        : Image.asset(
                            imagen!,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              icon,
                              size: 48,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontFamily: 'LilitaOne',
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    color: Colors.white,
                    backgroundColor: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

double _progreso(Mundo m) {
  final ids = [
    for (final t in m.temas)
      for (final x in t.misiones) x.id,
  ];
  return store.progresoMundo(ids);
}

/// Globo de diálogo tipo cómic para Zati.
/// En escritorio la punta queda arriba; en móvil apunta hacia abajo.
class ComicSpeechBubble extends StatelessWidget {
  final String text;
  final bool tailDown;

  const ComicSpeechBubble({
    super.key,
    required this.text,
    this.tailDown = false,
  });

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _ComicBubblePainter(tailDown: tailDown),
        child: Container(
          width: double.infinity,
          padding: tailDown
              ? const EdgeInsets.fromLTRB(16, 13, 16, 29)
              : const EdgeInsets.fromLTRB(18, 30, 18, 14),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: C.tinta,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
}

class _ComicBubblePainter extends CustomPainter {
  final bool tailDown;

  const _ComicBubblePainter({this.tailDown = false});

  @override
  void paint(Canvas canvas, Size size) {
    const bordeColor = Color(0xFF8CC8F0);
    const left = 2.0;
    final right = size.width - 2;
    final top = tailDown ? 2.0 : 17.0;
    final bottom = tailDown ? size.height - 18 : size.height - 2;
    final puntaX = size.width * .58;

    final Path path;

    if (tailDown) {
      path = Path()
        ..moveTo(22, top)
        ..lineTo(right - 20, top)
        ..quadraticBezierTo(right, top, right, top + 20)
        ..lineTo(right, bottom - 20)
        ..quadraticBezierTo(right, bottom, right - 20, bottom)
        ..lineTo(puntaX + 14, bottom)
        ..lineTo(puntaX, size.height - 2)
        ..lineTo(puntaX - 14, bottom)
        ..lineTo(22, bottom)
        ..quadraticBezierTo(left, bottom, left, bottom - 20)
        ..lineTo(left, top + 20)
        ..quadraticBezierTo(left, top, 22, top)
        ..close();
    } else {
      path = Path()
        ..moveTo(22, top)
        ..lineTo(28, top)
        ..quadraticBezierTo(40, top + 1, 36, 2)
        ..quadraticBezierTo(49, top, 57, top)
        ..lineTo(right - 20, top)
        ..quadraticBezierTo(right, top, right, top + 20)
        ..lineTo(right, bottom - 20)
        ..quadraticBezierTo(right, bottom, right - 20, bottom)
        ..lineTo(22, bottom)
        ..quadraticBezierTo(left, bottom, left, bottom - 20)
        ..lineTo(left, top + 20)
        ..quadraticBezierTo(left, top, 22, top)
        ..close();
    }

    canvas.drawShadow(path, Colors.black26, 5, false);

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = bordeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ComicBubblePainter oldDelegate) {
    return oldDelegate.tailDown != tailDown;
  }
}

/// Pantalla principal.
class Home extends StatelessWidget {
  const Home({super.key});

  void _ajustes(BuildContext context) {
    final n = TextEditingController(text: store.nombre);

    var g = store.grado;
    var son = store.sonido;
    var mus = store.musica;
    var grande = store.textoGrande;
    var red = store.reducirAnim;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, set) => AlertDialog(
          title: const Text(
            'Ajustes',
            style: TextStyle(
              fontFamily: 'LilitaOne',
              fontSize: 28,
            ),
          ),
          content: SizedBox(
            width: 380,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: n,
                    maxLength: 20,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de explorador',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(
                        value: 5,
                        label: Text('5.º grado'),
                      ),
                      ButtonSegment(
                        value: 6,
                        label: Text('6.º grado'),
                      ),
                    ],
                    selected: {g},
                    onSelectionChanged: (s) => set(() => g = s.first),
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up),
                    title: const Text('Efectos de sonido'),
                    value: son,
                    onChanged: (v) => set(() => son = v),
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.music_note),
                    title: const Text('Música'),
                    value: mus,
                    onChanged: (v) => set(() => mus = v),
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.text_fields),
                    title: const Text('Letra más grande'),
                    value: grande,
                    onChanged: (v) => set(() => grande = v),
                  ),
                  SwitchListTile(
                    secondary: const Icon(Icons.motion_photos_off),
                    title: const Text('Menos animaciones'),
                    subtitle: const Text('Ideal para equipos lentos'),
                    value: red,
                    onChanged: (v) => set(() => red = v),
                  ),
                  const Divider(),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                    ),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Borrar mi progreso'),
                    onPressed: () async {
                      final ok = await showDialog<bool>(
                        context: ctx,
                        builder: (c2) => AlertDialog(
                          title: const Text('¿Borrar todo?'),
                          content: const Text(
                            'Se perderán tu nombre, monedas, '
                            'insignias y misiones completadas.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c2, false),
                              child: const Text('No, conservar'),
                            ),
                            FilledButton(
                              onPressed: () => Navigator.pop(c2, true),
                              child: const Text('Sí, borrar'),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await store.reiniciar();

                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const Bienvenida(),
                            ),
                            (_) => false,
                          );
                        }
                      }
                    },
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      'Salir del juego',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () async {
                      final salir = await showDialog<bool>(
                        context: ctx,
                        builder: (c2) => AlertDialog(
                          title: const Text('¿Quieres salir?'),
                          content: const Text(
                            '¿Estás seguro de que deseas salir '
                            'de Explora Ciencia y Tecnología?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(c2, false),
                              child: const Text('Cancelar'),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () => Navigator.pop(c2, true),
                              child: const Text('Salir'),
                            ),
                          ],
                        ),
                      );

                      if (salir == true && ctx.mounted) {
                        Navigator.pop(ctx);
                        await SystemNavigator.pop();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                store.actualizarPerfil(
                  n.text,
                  g,
                  son: son,
                  mus: mus,
                  grande: grande,
                  reducir: red,
                );
                Navigator.pop(ctx);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: fondoMontanas(
          child: SafeArea(
            child: ListenableBuilder(
              listenable: store,
              builder: (context, _) => LayoutBuilder(
                builder: (context, box) {
                  final ancho = box.maxWidth > 700;

                  // Tamaño adaptable de Zati para computadora y celular.
                  final zs = ancho
                      ? math.min(
                          (box.maxHeight * .5).clamp(150.0, 360.0),
                          (box.maxWidth - 28) * .4 * .58,
                        )
                      : (box.maxWidth * .4).clamp(120.0, 260.0);

                  // Etiqueta del grado.
                  final gradoBadge = Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12, //tamaño de icono de grado
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: C.tinta,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: C.sol, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.school,
                          color: C.sol,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${store.grado}° grado',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  );

                  // Diseño de escritorio: Zati aparece sobre el globo.
                  final personaje = Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Zati(size: zs),
                      const SizedBox(height: 0),
                      Transform.translate(
                        offset: const Offset(
                            3, -18), // Subeo baja el globo de dialogo
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ancho
                                ? 320 //tamaño de globo de dialogo
                                : math.min(box.maxWidth - 28, 320),
                          ),
                          child: ComicSpeechBubble(
                            text:
                                '¡Hola, ${store.nombre}! ¿Qué quieres descubrir hoy?',
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Transform.translate(
                        offset: const Offset(0, -35), // Sube el grado
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: gradoBadge,
                          ),
                        ),
                      ),
                    ],
                  );

                  // En móvil, el globo va arriba y su punta señala hacia Zati.
                  final personajeMovil = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: math.min(box.maxWidth - 24,
                              280), //tamaño de globo de dialogo en movil
                        ),
                        child: ComicSpeechBubble(
                          text:
                              '¡Hola, ${store.nombre}! ¿Qué quieres descubrir hoy?',
                          tailDown: true,
                        ),
                      ),
                      const SizedBox(height: 0),
                      Zati(size: math.min(zs * .72, 175.0)),
                    ],
                  );

                  // Panel blanco que contiene únicamente las materias.
                  final panel = Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: ancho
                            ? 715.0 //tamaño del panel en computadora
                            : math.max(0.0, box.maxWidth - 8),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: ancho ? 12 : 5,
                          vertical: ancho ? 12 : 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.92),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              215,
                              213,
                              209,
                            ),
                            width: ancho ? 3 : 3, //ancho del panel
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: ancho ? 505 : 180, //alto del panel
                          child: GridView(
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisExtent: ancho
                                  ? 240
                                  : 83, //tamaño de tarjetas de materias
                              mainAxisSpacing: ancho
                                  ? 15
                                  : 9, //espacio entre tarjetas vertical
                              crossAxisSpacing:
                                  ancho ? 12 : 7, //espacio horizontal
                            ),
                            children: [
                              for (final m in mundos)
                                SubjectButton(
                                  title: m.nombre,
                                  icon: m.icono,
                                  imagen: _img[m.id],
                                  color: m.color,
                                  progress: _progreso(m),

                                  //Ajustes para computadora y celular
                                  iconScale: ancho
                                      ? 0.6
                                      : 0.80, //tamaño de los iconos del panel de materias
                                  cardBorderWidth:
                                      ancho ? 2 : 1.5, //medidas borde blanco
                                  cardRadius: ancho ? 22 : 15,
                                  titleFontSize: ancho
                                      ? 18
                                      : 12, //letras del panel de materias tamaño

                                  onTap: null,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );

                  // Botones fuera del panel de materias.
                  final botones = Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth:
                            ancho ? 580.0 : math.max(0.0, box.maxWidth - 8),
                      ),
                      child: Transform.scale(
                        scale: ancho ? 1.0 : 0.75,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: ancho ? 12 : 11,
                          runSpacing: ancho ? 10 : 6,
                          children: [
                            Pulse(
                              child: GameButton(
                                '¡JUGAR!',
                                icon: Icons.play_arrow,
                                color: C.sol,
                                textColor: C.tinta,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const IntroduccionHistoria(),
                                  ),
                                ),
                              ),
                            ),
                            GameButton(
                              'Eventos',
                              icon: Icons.event,
                              color: C.tinta,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const EventosScreen(),
                                ),
                              ),
                            ),
                            GameButton(
                              'Vocación',
                              icon: Icons.explore,
                              color: C.tinta,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VocacionScreen(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      ancho ? 14 : 8,
                      ancho ? 14 : 1,
                      ancho ? 14 : 8,
                      12,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (box.maxWidth > 620)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Transform.translate(
                                      offset: const Offset(100,
                                          0), //desplazar letrero de madera a la izquierda o derecha
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        alignment: Alignment.centerLeft,
                                        child: tituloMadera(
                                          size: (box.maxWidth * .045).clamp(
                                              24.0,
                                              48.0), //tamaño titulo en pag. inicio computadora
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Transform.translate(
                                      offset: const Offset(
                                          120, 0), //desplazar eslogan
                                      child: Transform.rotate(
                                        angle: -.045,
                                        child: const Text(
                                          'Aprende • Juega • Construye tu futuro',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF0B2A5B),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            shadows: _sombra,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0B2A5B),
                                  foregroundColor: Colors.white,
                                  shape: const StadiumBorder(),
                                  minimumSize: const Size(48, 48),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Insignias(),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.emoji_events,
                                  color: C.sol,
                                ),
                                label: const Text(
                                  'Mis insignias',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Tooltip(
                                message: 'Ajustes',
                                child: Material(
                                  color: const Color(0xFF0B2A5B),
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () => _ajustes(context),
                                    child: const SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Wrap(
                                  alignment: WrapAlignment.end,
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF0B2A5B),
                                        foregroundColor: Colors.white,
                                        shape: const StadiumBorder(),
                                        minimumSize: const Size(40, 36),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const Insignias(),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.emoji_events,
                                        color: C.sol,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        'Insignias',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Tooltip(
                                      message: 'Ajustes',
                                      child: Material(
                                        color: const Color(0xFF0B2A5B),
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
                                          onTap: () => _ajustes(context),
                                          child: const SizedBox(
                                            width: 34,
                                            height: 34,
                                            child: Icon(
                                              Icons.settings,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Transform.translate(
                                offset: const Offset(
                                    0, -2), // Sube el grado en celular
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Transform.scale(
                                    scale: 0.86,
                                    alignment: Alignment.centerRight,
                                    child: gradoBadge,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Transform.translate(
                                  offset: const Offset(22,
                                      -45), //titulo izquierda o derecha en celular
                                  child: tituloMadera(
                                    size: (box.maxWidth * .088).clamp(22.0,
                                        31.0), //tamaño pag. inicio celular
                                  ),
                                ),
                              ),
                              const SizedBox(height: 1),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Transform.translate(
                                  offset: const Offset(18, -45),
                                  child: Transform.rotate(
                                    angle: -.035,
                                    child: const Text(
                                      'Aprende • Juega • Construye tu futuro',
                                      style: TextStyle(
                                        color: Color(0xFF0B2A5B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        shadows: _sombra,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: ancho ? 15 : 5),
                        if (ancho)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Transform.translate(
                                  offset: const Offset(
                                      10, 30), //Zati de izquierda a derecha
                                  child: personaje,
                                ),
                              ),
                              const SizedBox(
                                  width: 20), //espacio entre Zati y el panel
                              Expanded(
                                flex: 6,
                                child: Transform.translate(
                                  offset: const Offset(
                                      0, -90), //panel de izquierda a derecha
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      panel,
                                      const SizedBox(
                                          height:
                                              12), //espacio entre panel y botones de abajo
                                      botones,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              personajeMovil,
                              const SizedBox(height: 3),
                              panel,
                              const SizedBox(height: 2),

                              // Botones centrados y un poco más arriba en móvil.
                              Transform.translate(
                                offset: const Offset(0, -9),
                                child: botones,
                              ),
                            ],
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

/// Navegación a pantallas pendientes.
void _pronto(BuildContext c, String t) {
  Navigator.push(
    c,
    MaterialPageRoute(
      builder: (_) => Proximamente(t),
    ),
  );
}

class Proximamente extends StatelessWidget {
  final String t;

  const Proximamente(this.t, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(t)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '$t\n\nPendiente: se construye en una próxima fase.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      );
}

class Insignias extends StatelessWidget {
  const Insignias({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mis insignias')),
        body: ListenableBuilder(
          listenable: store,
          builder: (_, __) => store.recompensas.isEmpty
              ? const Center(
                  child: Text(
                    'Aún no tienes insignias.\n'
                    '¡Completa una misión para ganar la primera!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final r in store.recompensas)
                      Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.military_tech,
                            color: C.sol,
                            size: 36,
                          ),
                          title: Text(
                            r,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      );
}


class IntroduccionHistoria extends StatefulWidget {
  const IntroduccionHistoria({super.key});

  @override
  State<IntroduccionHistoria> createState() =>
      _IntroduccionHistoriaState();
}

class _IntroduccionHistoriaState extends State<IntroduccionHistoria> {
  Timer? _timer;

  int _pagina = 0;
  int _caracteres = 0;

  final List<String> _dialogos = [
    '¡Hola, explorador! Soy Zati. Hace poco descubrí algo increíble... '
        'La Brújula de la Ciencia, un objeto muy especial que nos ayuda '
        'a descubrir los secretos del mundo, ¡se ha roto!',

    'Sus seis piezas salieron volando y quedaron dispersas en seis '
        'mundos de exploración. Cada mundo guarda conocimientos, '
        'retos y descubrimientos que nos ayudarán a encontrarlas.',

    '¡Necesito tu ayuda para recuperar todas las piezas y reconstruir '
        'la brújula! Podrás explorar los mundos en el orden que prefieras. '
        '¿Estás listo para comenzar esta gran aventura?'
  ];

  String get _textoActual => _dialogos[_pagina];

  bool get _textoCompleto =>
      _caracteres >= _textoActual.length;

  @override
  void initState() {
    super.initState();
    _iniciarEscritura();
  }

  void _iniciarEscritura() {
    _timer?.cancel();

    _timer = Timer.periodic(
      const Duration(milliseconds: 35),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          if (_caracteres < _textoActual.length) {
            _caracteres++;
          } else {
            timer.cancel();
          }
        });
      },
    );
  }

  void _continuar() {
    if (!_textoCompleto) {
      // Mostrar todo el texto inmediatamente.
      _timer?.cancel();

      setState(() {
        _caracteres = _textoActual.length;
      });

      return;
    }

    if (_pagina < _dialogos.length - 1) {
      setState(() {
        _pagina++;
        _caracteres = 0;
      });

      _iniciarEscritura();
    } else {
      // Al terminar la historia, abrir el mapa.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MapaMundos(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo del juego.
          Image.asset(
            'assets/fondo.png',
            fit: BoxFit.cover,
          ),

          Container(
            color: Colors.black.withValues(alpha: 0.18),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final esMovil = constraints.maxWidth < 600;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 850,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Título de la introducción.
                          Text(
                            'Una aventura por comenzar...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: esMovil ? 23 : 30,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              shadows: const [
                                Shadow(
                                  blurRadius: 6,
                                  color: Colors.black54,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Zati y su globo de diálogo.
                          Expanded(
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.end,
                              children: [
                                // Imagen de Zati.
                                Expanded(
                                  flex: esMovil ? 4 : 5,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/zati.png',
                                      fit: BoxFit.contain,
                                      height: constraints.maxHeight *
                                          (esMovil ? 0.43 : 0.62),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // Globo de diálogo.
                                Expanded(
                                  flex: esMovil ? 6 : 7,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 35,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        esMovil ? 16 : 24,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(24),
                                        border: Border.all(
                                          color: const Color(0xFF3D5AFE),
                                          width: 3,
                                        ),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 12,
                                            offset: Offset(3, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Zati',
                                            style: TextStyle(
                                              fontSize:
                                                  esMovil ? 18 : 22,
                                              fontWeight: FontWeight.w900,
                                              color: const Color(
                                                0xFF3D5AFE,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 10),

                                          Text(
                                            _textoActual.substring(
                                              0,
                                              _caracteres,
                                            ),
                                            style: TextStyle(
                                              fontSize:
                                                  esMovil ? 14 : 18,
                                              height: 1.5,
                                              fontWeight:
                                                  FontWeight.w600,
                                              color: const Color(
                                                0xFF232343,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(height: 18),

                                          Align(
                                            alignment:
                                                Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: _continuar,
                                              child: Text(
                                                !_textoCompleto
                                                    ? 'Omitir'
                                                    : _pagina <
                                                            _dialogos.length - 1
                                                        ? 'Continuar →'
                                                        : '¡Explorar mundos! →',
                                                style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.w900,
                                                  fontSize:
                                                      esMovil ? 13 : 16,
                                                  color: const Color(
                                                    0xFF3D5AFE,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 15),

                          // Indicador de las partes de la historia.
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _dialogos.length,
                              (index) => AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: _pagina == index ? 25 : 9,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: _pagina == index
                                      ? const Color(0xFFFFC933)
                                      : Colors.white70,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



/// MAPA DE LOS SEIS MUNDOS
class MapaMundos extends StatefulWidget {
  const MapaMundos({super.key});

  @override
  State<MapaMundos> createState() => _MapaState();
}

class _MapaState extends State<MapaMundos>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo generado directamente en Flutter.
          const CustomPaint(
            painter: _FondoMapaPainter(),
          ),

          SafeArea(
            child: ListenableBuilder(
              listenable: store,
              builder: (context, _) => Column(
                children: [
                  _barraMapa(context),

                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, box) {
                        final ancho = box.maxWidth;
                        final columnas = ancho > 850
                            ? 3
                            : ancho > 500
                                ? 3
                                : 2;

                        final separacion = ancho > 500 ? 20.0 : 10.0;

                        final w = ((ancho -
                                    32 -
                                    separacion * (columnas - 1)) /
                                columnas)
                            .clamp(135.0, 250.0);

                        return ListView(
                          padding: const EdgeInsets.fromLTRB(
                            12,
                            10,
                            12,
                            30,
                          ),
                          children: [
                            const Text(
                              '¡Explora los seis mundos!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'LilitaOne',
                                fontSize: 27,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 6,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 5),

                            const Text(
                              'Cada isla guarda una aventura científica.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 22),

                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: separacion,
                              runSpacing: 24,
                              children: [
                                for (var i = 0;
                                    i < mundos.length;
                                    i++)
                                  AnimatedBuilder(
                                    animation: _c,
                                    builder: (_, child) {
                                      final desplazamiento =
                                          math.sin(
                                            (_c.value * 2 * math.pi) +
                                                (i * 1.1),
                                          ) *
                                          5;

                                      return Transform.translate(
                                        offset: Offset(
                                          0,
                                          desplazamiento,
                                        ),
                                        child: child,
                                      );
                                    },
                                    child: _Isla(mundos[i], w),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _barraMapa(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      child: Row(
        children: [
          Container(
  decoration: BoxDecoration(
    color: const Color(0xFF12304A),
    shape: BoxShape.circle,
    border: Border.all(
      color: const Color(0xFF12304A),
      width: 3,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0xFF12304A),
        blurRadius: 5,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: IconButton(
    tooltip: 'Volver',
    onPressed: () => Navigator.pop(context),
    icon: const Icon(
      Icons.arrow_back_rounded,
      color: Color.fromARGB(255, 255, 255, 255),
      size: 26,
    ),
  ),
),

const SizedBox(width: 8),
Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 13,
    vertical: 7,
    ),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFE889),
          Color(0xFFFFBD35),
          Color(0xFFE99420),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF9B5B19),
          width: 2.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 5,
              offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4C4),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD18A20),
                    width: 2,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.monetization_on_rounded,
                      color: Color(0xFFDB941C),
                      size: 23,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${store.monedas}',
                    style: const TextStyle(
                      fontFamily: 'LilitaOne',
                      fontSize: 19,
                      color: Color(0xFF563719),
                      shadows: [
                        Shadow(
                          color: Colors.white54,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                          ),
                        ],
                      ),
                  ),
                ],
            ),
          ),

          const Spacer(),

          if (MediaQuery.of(context).size.width > 600)
            Wrap(
              spacing: 6,
              children: [
                _mini(
                  context,
                  Icons.face,
                  'Avatar',
                  () => _pronto(context, 'Avatar'),
                ),
                _mini(
                  context,
                  Icons.storefront,
                  'Tienda',
                  () => _pronto(
                    context,
                    'Tienda de accesorios',
                  ),
                ),
                _mini(
                  context,
                  Icons.emoji_events,
                  'Insignias',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Insignias(),
                    ),
                  ),
                ),
              ],
            )
          else
            IconButton.filled(
              tooltip: 'Insignias',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFF12304A),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const Insignias(),
                ),
              ),
              icon: const Icon(Icons.emoji_events),
            ),
        ],
      ),
    );
  }

  Widget _mini(
    BuildContext context,
    IconData icono,
    String texto,
    VoidCallback accion,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: C.tinta,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        minimumSize: const Size(48, 44),
      ),
      onPressed: accion,
      icon: Icon(icono),
      label: Text(texto),
    );
  }
}

/// ============================================================
/// ISLA DE CADA MUNDO

class _Isla extends StatelessWidget {
  final Mundo m;
  final double w;

  const _Isla(this.m, this.w);

  @override
  Widget build(BuildContext context) {
    final hechos = m.temas
        .where(
          (t) => t.misiones.every(
            (x) => store.completadas.contains(x.id),
          ),
        )
        .length;

    return Semantics(
      button: true,
      label: '${m.nombre}, $hechos de 5 temas completados',
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RutaMundo(m),
            ),
          );
        },
        child: SizedBox(
          width: w,
          child: Column(
            children: [
              SizedBox(
                width: w,
                height: w * .73,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _IslaPainter(
                          id: m.id,
                          color: m.color,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: C.sol,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 5,
                              offset: Offset(1, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          '$hechos/5',
                          style: const TextStyle(
                            color: C.tinta,
                            fontFamily: 'LilitaOne',
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5),

              Container(
                width: w * .95,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: C.tinta,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: m.color,
                    width: 2,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(1, 3),
                    ),
                  ],
                ),
                child: Text(
                  m.nombre,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'LilitaOne',
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ============================================================
/// FONDO DEL MAPA

class _FondoMapaPainter extends CustomPainter {
  const _FondoMapaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final fondo = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3978C8),
          Color(0xFF70BCEB),
          Color(0xFFB5E6F2),
        ],
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(
      Offset.zero & size,
      fondo,
    );

    // Luz del cielo.
    final luz = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: .35),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * .5, size.height * .25),
          radius: size.width * .8,
        ),
      );

    canvas.drawRect(
      Offset.zero & size,
      luz,
    );

    // Nubes.
    final nube = Paint()
      ..color = Colors.white.withValues(alpha: .65);

    for (var i = 0; i < 9; i++) {
      final x = (i * 137.0 + 35) % size.width;
      final y = 100.0 + (i % 4) * 125.0;

      _nube(canvas, Offset(x, y), nube, 0.8 + (i % 3) * .15);
    }

    // Pequeñas partículas luminosas.
    final particula = Paint()
      ..color = Colors.white.withValues(alpha: .65);

    for (var i = 0; i < 45; i++) {
      final x = (i * 73.0 + 18) % size.width;
      final y = (i * 113.0 + 30) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 2.5 : 1.4,
        particula,
      );
    }

    // Nubes de fondo en la parte inferior.
    final nubeBaja = Paint()
      ..color = const Color(0xFFD9F1F8).withValues(alpha: .55);

    for (var i = 0; i < 5; i++) {
      final x = i * size.width / 4;
      _nube(
        canvas,
        Offset(x, size.height - 35),
        nubeBaja,
        1.5,
      );
    }
  }

  void _nube(
    Canvas canvas,
    Offset centro,
    Paint paint,
    double escala,
  ) {
    canvas.drawCircle(
      centro,
      15 * escala,
      paint,
    );
    canvas.drawCircle(
      centro.translate(18 * escala, -8 * escala),
      20 * escala,
      paint,
    );
    canvas.drawCircle(
      centro.translate(38 * escala, 1 * escala),
      15 * escala,
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: centro.translate(19 * escala, 7 * escala),
        width: 55 * escala,
        height: 18 * escala,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _FondoMapaPainter oldDelegate) => false;
}

/// ============================================================
/// DIBUJO ISOMÉTRICO DE LAS ISLAS

class _IslaPainter extends CustomPainter {
  final String id;
  final Color color;

  _IslaPainter({
    required this.id,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    canvas.scale(
      size.width / 220,
      size.height / 160,
    );

    // Sombra de la isla.
    final sombra = Paint()
      ..color = Colors.black.withValues(alpha: .25)
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        8,
      );

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(110, 137),
        width: 178,
        height: 27,
      ),
      sombra,
    );

    // Cuerpo rocoso inferior.
    final roca = Path()
      ..moveTo(20, 77)
      ..lineTo(110, 32)
      ..lineTo(200, 77)
      ..lineTo(187, 112)
      ..lineTo(110, 151)
      ..lineTo(32, 112)
      ..close();

    canvas.drawPath(
      roca,
      Paint()..color = const Color(0xFF76513D),
    );

    // Caras laterales de la isla.
    final caraIzquierda = Path()
      ..moveTo(20, 77)
      ..lineTo(110, 120)
      ..lineTo(110, 151)
      ..lineTo(32, 112)
      ..close();

    canvas.drawPath(
      caraIzquierda,
      Paint()..color = const Color(0xFF583B32),
    );

    final caraDerecha = Path()
      ..moveTo(110, 120)
      ..lineTo(200, 77)
      ..lineTo(187, 112)
      ..lineTo(110, 151)
      ..close();

    canvas.drawPath(
      caraDerecha,
      Paint()..color = const Color(0xFF3F352F),
    );

    // Cara superior.
    final superficie = Path()
      ..moveTo(20, 77)
      ..lineTo(110, 32)
      ..lineTo(200, 77)
      ..lineTo(110, 123)
      ..close();

    canvas.drawShadow(
      superficie,
      Colors.black45,
      5,
      true,
    );

    canvas.drawPath(
      superficie,
      Paint()..color = color,
    );

    // Zona superior iluminada.
    final brillo = Paint()
      ..color = Colors.white.withValues(alpha: .17);

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(110, 76),
        width: 135,
        height: 48,
      ),
      brillo,
    );

    // Decoración temática.
    switch (id) {
      case 'bio':
        _biologia(canvas);
        break;
      case 'qui':
        _quimica(canvas);
        break;
      case 'fis':
        _fisica(canvas);
        break;
      case 'ele':
        _electronica(canvas);
        break;
      case 'ia':
        _inteligencia(canvas);
        break;
      case 'pro':
        _programacion(canvas);
        break;
    }

    // Pequeñas piedras en el borde.
    final piedra = Paint()
      ..color = const Color(0xFFB78C66);

    for (final p in const [
      Offset(42, 99),
      Offset(75, 112),
      Offset(147, 109),
      Offset(180, 90),
    ]) {
      canvas.drawOval(
        Rect.fromCenter(
          center: p,
          width: 9,
          height: 5,
        ),
        piedra,
      );
    }

    canvas.restore();
  }

  void _biologia(Canvas canvas) {
    final tronco = Paint()
      ..color = const Color(0xFF71452B)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Árboles.
    for (final p in const [
      Offset(62, 66),
      Offset(155, 62),
      Offset(111, 48),
    ]) {
      canvas.drawLine(
        p.translate(0, 13),
        p.translate(0, 30),
        tronco,
      );

      canvas.drawCircle(
        p,
        12,
        Paint()..color = const Color(0xFF176B36),
      );

      canvas.drawCircle(
        p.translate(-5, -5),
        7,
        Paint()..color = const Color(0xFF52B85B),
      );
    }

    // Cascada.
    final agua = Paint()
      ..color = const Color(0xFF85E8F5);

    canvas.drawPath(
      Path()
        ..moveTo(180, 84)
        ..lineTo(190, 90)
        ..lineTo(186, 123)
        ..lineTo(178, 118)
        ..close(),
      agua,
    );

    // Flores.
    for (final p in const [
      Offset(85, 86),
      Offset(135, 91),
      Offset(49, 83),
    ]) {
      canvas.drawCircle(
        p,
        3,
        Paint()..color = const Color(0xFFFFE56A),
      );
    }
  }

  void _quimica(Canvas canvas) {
    // Laboratorio.
    final edificio = Paint()
      ..color = const Color(0xFFEAF4FF);

    final edificio2 = Paint()
      ..color = const Color(0xFFB5D7EE);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(73, 47, 75, 43),
        const Radius.circular(5),
      ),
      edificio,
    );

    canvas.drawPath(
      Path()
        ..moveTo(67, 48)
        ..lineTo(110, 25)
        ..lineTo(154, 48)
        ..close(),
      Paint()..color = const Color(0xFF653D83),
    );

    canvas.drawRect(
      const Rect.fromLTWH(82, 58, 13, 15),
      edificio2,
    );

    canvas.drawRect(
      const Rect.fromLTWH(125, 58, 13, 15),
      edificio2,
    );

    // Matraces.
    _matraz(canvas, const Offset(55, 75), const Color(0xFF45D6DC));
    _matraz(canvas, const Offset(164, 78), const Color(0xFFFFCB52));

    // Burbujas.
    for (var i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(49 + i * 7.0, 48 - (i % 2) * 6),
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  void _matraz(Canvas canvas, Offset p, Color color) {
    final pintura = Paint()..color = color;

    canvas.drawRect(
      Rect.fromCenter(
        center: p.translate(0, -8),
        width: 7,
        height: 15,
      ),
      pintura,
    );

    canvas.drawPath(
      Path()
        ..moveTo(p.dx - 4, p.dy - 2)
        ..lineTo(p.dx - 12, p.dy + 13)
        ..quadraticBezierTo(
          p.dx,
          p.dy + 24,
          p.dx + 12,
          p.dy + 13,
        )
        ..lineTo(p.dx + 4, p.dy - 2)
        ..close(),
      pintura,
    );

    canvas.drawLine(
      p.translate(-5, 10),
      p.translate(5, 10),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2,
    );
  }

  void _fisica(Canvas canvas) {
    // Observatorio.
    canvas.drawCircle(
      const Offset(110, 60),
      20,
      Paint()..color = const Color(0xFF4D467B),
    );

    canvas.drawCircle(
      const Offset(110, 60),
      14,
      Paint()..color = const Color(0xFF8CB8EC),
    );

    // Anillo orbital.
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(110, 60),
        width: 75,
        height: 22,
      ),
      Paint()
        ..color = const Color(0xFFFFE47A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // Planetas.
    canvas.drawCircle(
      const Offset(145, 58),
      6,
      Paint()..color = const Color(0xFFFF8E59),
    );

    canvas.drawCircle(
      const Offset(72, 83),
      8,
      Paint()..color = const Color(0xFF7D72D9),
    );

    // Rayo de energía.
    canvas.drawPath(
      Path()
        ..moveTo(160, 79)
        ..lineTo(150, 94)
        ..lineTo(159, 94)
        ..lineTo(151, 107)
        ..lineTo(172, 88)
        ..lineTo(162, 88)
        ..close(),
      Paint()..color = const Color(0xFFFFE15A),
    );
  }

  void _electronica(Canvas canvas) {
    // Placa de circuito.
    final placa = Paint()
      ..color = const Color(0xFF174C45);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(62, 52, 96, 48),
        const Radius.circular(7),
      ),
      placa,
    );

    // Pistas.
    final pista = Paint()
      ..color = const Color(0xFF67E8B4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final ruta = Path()
      ..moveTo(72, 68)
      ..lineTo(91, 68)
      ..lineTo(99, 78)
      ..lineTo(120, 78)
      ..moveTo(145, 61)
      ..lineTo(135, 72)
      ..lineTo(135, 90)
      ..moveTo(70, 90)
      ..lineTo(85, 90)
      ..lineTo(94, 82);

    canvas.drawPath(ruta, pista);

    // Microchip.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(99, 60, 30, 28),
        const Radius.circular(4),
      ),
      Paint()..color = const Color(0xFFFFC94D),
    );

    canvas.drawRect(
      const Rect.fromLTWH(106, 67, 16, 14),
      Paint()..color = const Color(0xFF283D48),
    );

    // Luces.
    for (final p in const [
      Offset(77, 61),
      Offset(146, 89),
      Offset(84, 96),
    ]) {
      canvas.drawCircle(
        p,
        4,
        Paint()..color = const Color(0xFF6CFFF0),
      );
    }
  }

  void _inteligencia(Canvas canvas) {
    // Base de estación tecnológica.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(71, 67, 79, 25),
        const Radius.circular(8),
      ),
      Paint()..color = const Color(0xFF314A7C),
    );

    // Robot.
    final metal = Paint()
      ..color = const Color(0xFFDDEBFA);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(87, 38, 45, 39),
        const Radius.circular(11),
      ),
      metal,
    );

    // Antena.
    canvas.drawLine(
      const Offset(110, 38),
      const Offset(110, 28),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 3,
    );

    canvas.drawCircle(
      const Offset(110, 25),
      5,
      Paint()..color = const Color(0xFFFFD65B),
    );

    // Ojos.
    for (final x in [99.0, 120.0]) {
      canvas.drawCircle(
        Offset(x, 54),
        6,
        Paint()..color = const Color(0xFF32BFE7),
      );

      canvas.drawCircle(
        Offset(x - 1, 53),
        2,
        Paint()..color = Colors.white,
      );
    }

    // Boca.
    canvas.drawLine(
      const Offset(101, 67),
      const Offset(119, 67),
      Paint()
        ..color = const Color(0xFF526C8B)
        ..strokeWidth = 3,
    );

    // Brazos.
    final brazo = Paint()
      ..color = const Color(0xFFB5C8DF)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(87, 53),
      const Offset(73, 66),
      brazo,
    );

    canvas.drawLine(
      const Offset(132, 53),
      const Offset(146, 66),
      brazo,
    );

    // Circuitos luminosos.
    canvas.drawCircle(
      const Offset(62, 51),
      5,
      Paint()..color = const Color(0xFF71E7F5),
    );

    canvas.drawCircle(
      const Offset(157, 53),
      5,
      Paint()..color = const Color(0xFF71E7F5),
    );
  }

  void _programacion(Canvas canvas) {
    // Computadora.
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(68, 42, 84, 52),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFF35476E),
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(74, 48, 72, 39),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0xFF15263F),
    );

    // Código.
    final codigo = Paint()
      ..color = const Color(0xFF7CF3D0)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      const Offset(85, 60),
      const Offset(98, 60),
      codigo,
    );

    canvas.drawLine(
      const Offset(91, 69),
      const Offset(124, 69),
      codigo,
    );

    canvas.drawLine(
      const Offset(85, 78),
      const Offset(108, 78),
      codigo,
    );

    // Base de la computadora.
    canvas.drawPath(
      Path()
        ..moveTo(96, 94)
        ..lineTo(124, 94)
        ..lineTo(135, 103)
        ..lineTo(85, 103)
        ..close(),
      Paint()..color = const Color(0xFF9BAEC8),
    );

    // Bloques digitales.
    for (final p in const [
      Offset(57, 65),
      Offset(164, 67),
      Offset(155, 94),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: p,
            width: 17,
            height: 14,
          ),
          const Radius.circular(3),
        ),
        Paint()..color = const Color(0xFFFFD15A),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _IslaPainter oldDelegate) {
    return oldDelegate.id != id ||
        oldDelegate.color != color;
  }
}

