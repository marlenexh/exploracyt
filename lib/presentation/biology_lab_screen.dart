
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/science_compass.dart';
import '../main.dart' show store;
import 'biology/fondo_mapa_bio.dart';
import 'biology/tema1_screen.dart';
import 'biology/tema_bio_screen.dart';

// =====================================================
// BIOLOGY ASSETS
// =====================================================

class BiologyAssets {
  static const String zati =
      'assets/images/biology/zati.png';

  static const String logo =
      'assets/images/biology/biology_logo.png';

  static const List<String> pedestals = [
    'assets/images/biology/pedestal_body.png',
    'assets/images/biology/pedestal_cells.png',
    'assets/images/biology/pedestal_nutrition.png',
    'assets/images/biology/pedestal_living_things.png',
    'assets/images/biology/pedestal_biodiversity.png',
  ];
}

// =====================================================
// BIOLOGY LAB SCREEN
// =====================================================

class BiologyLabScreen extends StatefulWidget {
  final Mundo mundo;

  const BiologyLabScreen({
    super.key,
    required this.mundo,
  });

  @override
  State<BiologyLabScreen> createState() =>
      _BiologyLabScreenState();
}

class _BiologyLabScreenState extends State<BiologyLabScreen> {
  // ===================================================
  // VISUAL SETTINGS
  // ===================================================

  static const Color darkBlue = Color(0xFF193F73);

  // Original pedestal dimensions
  static const double desktopPedestalWidth = 170;
  static const double desktopPedestalHeight = 225;

  static const double mobilePedestalWidth = 135;
  static const double mobilePedestalHeight = 180;

  // ===================================================
  // INDIVIDUAL PEDESTAL SIZES
  // ===================================================
  // Order:
  // 1. Body
  // 2. Cells
  // 3. Nutrition
  // 4. Living things
  // 5. Biodiversity

  // Desktop ancho de cada pedestal
  static const List<double> desktopPedestalWidths = [
    300, // Body
    300, // Cells
    310, // Nutrition
    300, // Living things
    310, // Biodiversity
  ];

  // Desktop alto de cada pedestal
  static const List<double> desktopPedestalHeights = [
    320, // Body
    320, // Cells
    320, // Nutrition
    320, // Living things
    320, // Biodiversity
  ];

  // Mobile widths
  static const List<double> mobilePedestalWidths = [
    135, // Body
    135, // Cells
    135, // Nutrition
    135, // Living things
    135, // Biodiversity
  ];

  // Mobile heights
  static const List<double> mobilePedestalHeights = [
    180, // Body
    180, // Cells
    180, // Nutrition
    180, // Living things
    180, // Biodiversity
  ];

  static const double pedestalGap = 12;

  // ===================================================
  // INDIVIDUAL PEDESTAL POSITIONS
  // ===================================================
  //
  // X:
  // Positive = right
  // Negative = left
  //
  // Y:
  // Positive = up
  // Negative = down
  //
  // Each value controls one pedestal independently.
  // ===================================================

  // Desktop horizontal positions
  static const List<double> desktopPedestalOffsetX = [
    -10, // 1. Body
    -70, // 2. Cells
    -120, // 3. Nutrition
    -170, // 4. Living things
    -230, // 5. Biodiversity
  ];

  // Desktop vertical positions
  static const List<double> desktopPedestalOffsetY = [
    -20, // 1. Body
    10, // 2. Cells
    35, // 3. Nutrition
    10, // 4. Living things
    -20, // 5. Biodiversity
  ];

  // Mobile horizontal positions
  static const List<double> mobilePedestalOffsetX = [
    0, // 1. Body
    0, // 2. Cells
    0, // 3. Nutrition
    0, // 4. Living things
    0, // 5. Biodiversity
  ];

  // Mobile vertical positions
  static const List<double> mobilePedestalOffsetY = [
    0, // 1. Body
    0, // 2. Cells
    0, // 3. Nutrition
    0, // 4. Living things
    0, // 5. Biodiversity
  ];

  // ===================================================
  // ZATI DIMENSIONS
  // ===================================================

  static const double desktopZatiHeight = 350;
  static const double mobileZatiHeight = 130;

  // ===================================================
  // ZATI POSITION SETTINGS
  // ===================================================
  //
  // Positive X = right
  // Negative X = left
  //
  // Positive Y = up
  // Negative Y = down

  static const double desktopZatiOffsetX = 15;
  static const double desktopZatiOffsetY = 105;

  static const double mobileZatiOffsetX = 0;
  static const double mobileZatiOffsetY = 10;

  // ===================================================
  // PEDESTAL IMAGE ADJUSTMENTS
  // ===================================================

  static const List<double> pedestalImageScales = [
    1.0, // Body
    1.0, // Cells
    1.0, // Nutrition
    1.0, // Living things
    1.0, // Biodiversity
  ];

  // Hover animation
  static const double hoverScale = 1.12;

  static const Duration animationDuration =
      Duration(milliseconds: 260);

  int? hoveredPedestal;

  // ===================================================
  // TOPIC PROGRESS
  // ===================================================

  bool isTopicCompleted(Tema topic) =>
      isTopicInvestigated(topic, store.completadas);

  // ===================================================
  // TOPIC NAVIGATION
  // ===================================================

  void openTopic(BuildContext context, int index) {
    if (index < 0 || index >= widget.mundo.temas.length) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => index == 0
            ? const Tema1Screen()
            : temasBio.containsKey(index + 1)
                ? TemaBioScreen(numero: index + 1)
                : BiologyTopicScreen(tema: widget.mundo.temas[index], index: index),
      ),
    );
  }

  void updateHoveredPedestal(int? index) {
    if (hoveredPedestal == index) return;

    setState(() {
      hoveredPedestal = index;
    });
  }

  // ===================================================
  // MAIN SCREEN
  // ===================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF183E73),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final explorerName = store.nombre.trim().isEmpty
              ? 'explorador'
              : store.nombre.trim();

          return LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;

              final isMobile = screenWidth < 700;
              final safeTop = MediaQuery.paddingOf(context).top;

              // Responsive scene dimensions
              final sceneHeight = isMobile
                  ? math.min(265.0, screenHeight * 0.46)
                  : math.min(420.0, screenHeight * 0.60);

              final sceneBottom = isMobile
                  ? screenHeight * 0.08
                  : screenHeight * 0.17;

              return Stack(
                fit: StackFit.expand,
                children: [
                  // ==================================
                  // FULL SCREEN BACKGROUND
                  // ==================================
                  const FondoMapaBiologia(),

                  // ==================================
                  // FLOOR SHADOW
                  // ==================================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: screenHeight * 0.25,
                    child: const IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0x440E2455),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================
                  // PEDESTALS AND ZATI
                  // ==================================
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: sceneBottom,
                    height: sceneHeight,
                    child: buildPedestalScene(
                      context,
                      isMobile,
                    ),
                  ),

                  // ==================================
                  // ZATI SPEECH BUBBLE
                  // ==================================
                  Positioned(
                    top: safeTop + (isMobile ? 165 : 130),
                    left: isMobile ? 14 : 75,
                    width: math.min(
                      isMobile ? 285.0 : 400.0,
                      screenWidth - 28,
                    ),
                    child: buildSpeechBubble(
                      explorerName,
                      isMobile,
                    ),
                  ),

                  // ==================================
                  // BIOLOGY LOGO
                  // ==================================
                  Positioned(
                    top: safeTop + (isMobile ? 58 : 15),
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        BiologyAssets.logo,
                        width: isMobile
                            ? math.min(
                                screenWidth * 0.55,
                                220.0,
                              )
                            : math.min(
                                screenWidth * 0.32,
                                420.0,
                              ),
                        height: isMobile ? 90 : 145,
                        fit: BoxFit.contain,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // ==================================
                  // BACK BUTTON
                  // ==================================
                  Positioned(
                    top: safeTop + 12,
                    left: 16,
                    child: buildBackButton(context),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // =====================================================
  // RESPONSIVE PEDESTAL SCENE
  // =====================================================

  Widget buildPedestalScene(
    BuildContext context,
    bool isMobile,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        final availableHeight = constraints.maxHeight;

        // ==================================
        // INDIVIDUAL PEDESTAL DIMENSIONS
        // ==================================

        final widths = isMobile
            ? mobilePedestalWidths
            : desktopPedestalWidths;

        final heights = isMobile
            ? mobilePedestalHeights
            : desktopPedestalHeights;

        // ==================================
        // INDIVIDUAL PEDESTAL POSITIONS
        // ==================================

        final pedestalOffsetX = isMobile
            ? mobilePedestalOffsetX
            : desktopPedestalOffsetX;

        final pedestalOffsetY = isMobile
            ? mobilePedestalOffsetY
            : desktopPedestalOffsetY;

        final topicCount = math.min(
          widget.mundo.temas.length,
          BiologyAssets.pedestals.length,
        );

        const sidePadding = 25.0;
        const zatiGap = 10.0;
        const bottomOffset = 12.0;

        // ==================================
        // ZATI DIMENSIONS
        // ==================================

        final zatiHeight = isMobile
            ? mobileZatiHeight
            : desktopZatiHeight;

        final zatiWidth = zatiHeight * 0.65;

        // ==================================
        // FIXED PEDESTAL SLOTS
        // ==================================
        // Each pedestal has its own dimensions.
        // Changing its width does not move
        // the remaining pedestals.

        final slotWidth = widths.reduce(math.max);
        final slotHeight = heights.reduce(math.max);

        final naturalWidth =
            sidePadding * 2 +
            zatiWidth +
            zatiGap +
            topicCount * slotWidth +
            math.max(0, topicCount - 1) * pedestalGap;

        // ==================================
        // RESPONSIVE SCALE
        // ==================================

        final widthScale = isMobile
            ? 1.0
            : math.min(
                1.0,
                availableWidth / naturalWidth,
              );

        final heightScale = math.min(
          1.0,
          (availableHeight - bottomOffset - 8) /
              slotHeight,
        );

        final fitScale = math.max(
          0.1,
          math.min(widthScale, heightScale),
        );

        final scaledSlotWidth = slotWidth * fitScale;
        final scaledGap = pedestalGap * fitScale;

        final characterWidth = zatiWidth * fitScale;
        final characterHeight = zatiHeight * fitScale;

        final scaledZatiGap = zatiGap * fitScale;

        // ==================================
        // ROW DIMENSIONS
        // ==================================

        final rowWidth =
            characterWidth +
            scaledZatiGap +
            topicCount * scaledSlotWidth +
            math.max(0, topicCount - 1) * scaledGap;

        final contentWidth = math.max(
          availableWidth,
          rowWidth + sidePadding * 2,
        );

        final startX = (contentWidth - rowWidth) / 2;

        // ==================================
        // ZATI POSITION
        // ==================================

        final zatiOffsetX = isMobile
            ? mobileZatiOffsetX
            : desktopZatiOffsetX;

        final zatiOffsetY = isMobile
            ? mobileZatiOffsetY
            : desktopZatiOffsetY;

        // ==================================
        // PEDESTAL BASE POSITIONS
        // ==================================

        final pedestalPositions = List<double>.generate(
          topicCount,
          (index) =>
              startX +
              characterWidth +
              scaledZatiGap +
              index * (scaledSlotWidth + scaledGap),
        );

        // ==================================
        // HORIZONTAL SCROLLABLE SCENE
        // ==================================

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: contentWidth,
            height: availableHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // ==================================
                // ZATI
                // ==================================

                Positioned(
                  left: startX + zatiOffsetX * fitScale,
                  bottom:
                      bottomOffset + zatiOffsetY * fitScale,
                  width: characterWidth,
                  height: characterHeight,
                  child: IgnorePointer(
                    child: Image.asset(
                      BiologyAssets.zati,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return const Icon(
                          Icons.pets,
                          color: Colors.white,
                          size: 65,
                        );
                      },
                    ),
                  ),
                ),

                // ==================================
                // FIVE INDEPENDENT PEDESTALS
                // ==================================
                //
                // Each pedestal has:
                // - Individual width
                // - Individual height
                // - Horizontal offset
                // - Vertical offset
                //
                // Changing one pedestal does not
                // automatically reposition the others.

                for (int index = 0;
                    index < topicCount;
                    index++)
                  Positioned(
                    key: ValueKey('pedestal-slot-$index'),

                    // ============================
                    // HORIZONTAL POSITION
                    // ============================
                    //
                    // Positive = right
                    // Negative = left

                    left: pedestalPositions[index] +

                        // Center image in its slot
                        (scaledSlotWidth -
                                widths[index] * fitScale) /
                            2 +

                        // Individual horizontal offset
                        pedestalOffsetX[index] * fitScale,

                    // ============================
                    // VERTICAL POSITION
                    // ============================
                    //
                    // Positive = up
                    // Negative = down

                    bottom: bottomOffset +
                        pedestalOffsetY[index] * fitScale,

                    // ============================
                    // INDIVIDUAL WIDTH
                    // ============================

                    width: widths[index] * fitScale,

                    // ============================
                    // INDIVIDUAL HEIGHT
                    // ============================

                    height: heights[index] * fitScale,

                    child: buildPedestal(
                      context,
                      index,
                      isMobile,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =====================================================
  // ANIMATED PEDESTAL
  // =====================================================

  Widget buildPedestal(
    BuildContext context,
    int index,
    bool isMobile,
  ) {
    final topic = widget.mundo.temas[index];
    final completed = isTopicCompleted(topic);

    final assetPath = BiologyAssets.pedestals[index];
    final isHovered = hoveredPedestal == index;

    return MouseRegion(
      key: ValueKey('hover-area-$index'),
      cursor: SystemMouseCursors.click,
      onEnter: (_) => updateHoveredPedestal(index),
      onExit: (_) {
        if (hoveredPedestal == index) {
          updateHoveredPedestal(null);
        }
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // ==================================
          // PEDESTAL HOVER ANIMATION
          // ==================================

          Positioned.fill(
            child: AnimatedScale(
              scale: isHovered ? hoverScale : 1.0,
              alignment: Alignment.bottomCenter,
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              child: AnimatedSlide(
                offset: isHovered
                    ? const Offset(0, -0.045)
                    : Offset.zero,
                duration: animationDuration,
                curve: Curves.easeOutCubic,
                child: Transform.scale(
                  scale: pedestalImageScales[index],
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.fill,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (
                      context,
                      error,
                      stackTrace,
                    ) {
                      return buildPedestalPlaceholder(
                        topic.titulo,
                        index,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // ==================================
          // COMPLETED TOPIC BADGE
          // ==================================

          if (completed)
            const Positioned(
              top: 5,
              right: 8,
              child: Icon(
                Icons.check_circle,
                color: Color(0xFF45DB9C),
                size: 24,
              ),
            ),

          // ==================================
          // EXPLORE BUTTON
          // ==================================

          Positioned(
            bottom: isMobile ? 7 : 10,
            child: buildExploreButton(
              context,
              index,
              isMobile,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // PEDESTAL PLACEHOLDER
  // =====================================================

  Widget buildPedestalPlaceholder(
    String title,
    int index,
  ) {
    const icons = [
      Icons.favorite,
      Icons.biotech,
      Icons.restaurant,
      Icons.spa,
      Icons.forest,
    ];

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xDD6A65AE),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF79E7FF),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icons[index % icons.length],
            color: Colors.white,
            size: 45,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // EXPLORE BUTTON
  // =====================================================

  Widget buildExploreButton(
    BuildContext context,
    int index,
    bool isMobile,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => openTopic(context, index),
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: isMobile ? 88 : 105,
          height: isMobile ? 27 : 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFDC85),
                Color(0xFFFFAE48),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow_rounded,
                color: const Color(0xFF75451B),
                size: isMobile ? 14 : 16,
              ),
              const SizedBox(width: 2),
              Text(
                '¡EXPLORAR!',
                semanticsLabel: 'Explorar ${widget.mundo.temas[index].titulo}',
                style: TextStyle(
                  color: const Color(0xFF75451B),
                  fontSize: isMobile ? 9 : 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =====================================================
  // ZATI SPEECH BUBBLE
  // =====================================================

  Widget buildSpeechBubble(
    String explorerName,
    bool isMobile,
  ) {
    return CustomPaint(
      painter: _SpeechBubblePainter(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          15,
          18,
          30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, $explorerName! 🌿',
              style: TextStyle(
                color: darkBlue,
                fontSize: isMobile ? 17 : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '¿Sabías que la ciencia está llena '
              'de descubrimientos sorprendentes? '
              '¡Acompáñame a conocer los '
              'secretos de la vida!',
              style: TextStyle(
                color: const Color(0xFF294968),
                fontSize: isMobile ? 13 : 16,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // BACK BUTTON
  // =====================================================

  Widget buildBackButton(BuildContext context) {
    return Material(
      color: const Color(0xDD204D81),
      borderRadius: BorderRadius.circular(40),
      child: IconButton(
        tooltip: 'Volver al mapa',
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}

// =====================================================
// COMIC SPEECH BUBBLE PAINTER
// =====================================================

class _SpeechBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bubble = Path()
      ..moveTo(22, 0)
      ..lineTo(size.width - 22, 0)
      ..quadraticBezierTo(
        size.width,
        0,
        size.width,
        22,
      )
      ..lineTo(size.width, size.height - 45)
      ..quadraticBezierTo(
        size.width,
        size.height - 23,
        size.width - 22,
        size.height - 23,
      )
      ..lineTo(65, size.height - 23)
      ..lineTo(26, size.height)
      ..lineTo(35, size.height - 23)
      ..lineTo(22, size.height - 23)
      ..quadraticBezierTo(
        0,
        size.height - 23,
        0,
        size.height - 45,
      )
      ..lineTo(0, 22)
      ..quadraticBezierTo(0, 0, 22, 0)
      ..close();

    canvas.drawShadow(
      bubble,
      const Color(0x66000000),
      9,
      false,
    );

    canvas.drawPath(
      bubble,
      Paint()
        ..color = const Color(0xF7FFFFFF),
    );

    canvas.drawPath(
      bubble,
      Paint()
        ..color = const Color(0xFF3F95BD)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}

// =====================================================
// BIOLOGY TOPIC SCREEN
// =====================================================

class BiologyTopicScreen extends StatelessWidget {
  final Tema tema;
  final int index;

  const BiologyTopicScreen({
    super.key,
    required this.tema,
    required this.index,
  });

  static const List<String> descriptions = [
    'Descubre cómo trabajan el corazón, '
        'los pulmones y las defensas de tu cuerpo.',

    'Investiga las células y conoce las '
        'pequeñas estructuras que forman '
        'a los seres vivos.',

    'Aprende cómo los alimentos ayudan '
        'a tu cuerpo a crecer y tener energía.',

    'Explora cómo viven, crecen y se '
        'desarrollan los seres vivos.',

    'Descubre los ecosistemas y la '
        'diversidad de vida que nos rodea.',
  ];

  @override
  Widget build(BuildContext context) {
    final description = index < descriptions.length
        ? descriptions[index]
        : '¡Prepárate para descubrir '
            'algo increíble sobre la vida!';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F5FF),
      appBar: AppBar(
        title: Text(
          tema.titulo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFF294F91),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 650,
            ),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.science_rounded,
                      color: Color(0xFF479DC4),
                      size: 70,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      tema.titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF204D81),
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      '🔬 ¡Nuevas aventuras en preparación!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF3A719A),
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Aquí incorporaremos los nuevos '
                      'laboratorios, juegos y simuladores '
                      'interactivos.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    FilledButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text(
                        'VOLVER AL LABORATORIO',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
