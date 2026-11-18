
import 'package:flutter/material.dart';

class BiologyWorldScreen extends StatelessWidget {
  final ValueChanged<String> onTopicSelected;

  const BiologyWorldScreen({
    super.key,
    required this.onTopicSelected,
  });

  static const List<_BiologyTopic> topics = [
    _BiologyTopic(
      id: 'bio-t1',
      title: 'El cuerpo humano\ny sus sistemas',
      icon: Icons.favorite,
      color: Color(0xFFE95365),
    ),
    _BiologyTopic(
      id: 'bio-t2',
      title: 'El mundo\nde las células',
      icon: Icons.bubble_chart,
      color: Color(0xFF9F65E8),
    ),
    _BiologyTopic(
      id: 'bio-t3',
      title: 'Alimentación\nsaludable',
      icon: Icons.restaurant,
      color: Color(0xFFFFA52D),
    ),
    _BiologyTopic(
      id: 'bio-t4',
      title: 'La vida a\nnuestro alrededor',
      icon: Icons.spa,
      color: Color(0xFF43B968),
    ),
    _BiologyTopic(
      id: 'bio-t5',
      title: 'Biodiversidad\ny ecosistemas',
      icon: Icons.public,
      color: Color(0xFF319DD6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/biology/biology_background.png',
                  fit: BoxFit.cover,
                ),
              ),

              Positioned.fill(
                child: Container(
                  color: Colors.indigo.withValues(alpha: 0.08),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight -
                          MediaQuery.paddingOf(context).top -
                          MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 28),

                          _buildIntroduction(isWide),
                          const SizedBox(height: 32),

                          Text(
                            '¿Qué tema quieres explorar?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: isWide ? 26 : 21,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF173E72),
                              shadows: const [
                                Shadow(
                                  color: Colors.white,
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          Wrap(
                            spacing: 14,
                            runSpacing: 18,
                            alignment: WrapAlignment.center,
                            children: [
                              for (final topic in topics)
                                _buildTopicCard(
                                  topic,
                                  isWide ? 185 : 155,
                                ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          _buildFooter(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton.filled(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFF135EAC),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF7545B8),
            borderRadius: BorderRadius.circular(25),
          ),
          child: const Text(
            'MUNDO DE BIOLOGÍA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.stars_rounded,
          color: Color(0xFFFFC327),
          size: 37,
        ),
      ],
    );
  }

  Widget _buildIntroduction(bool isWide) {
    final zati = Image.asset(
      'assets/images/biology/zati.png',
      height: isWide ? 260 : 180,
      fit: BoxFit.contain,
    );

    final dialogue = Container(
      constraints: const BoxConstraints(maxWidth: 390),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF78BEF5),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Hola, explorador!',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: Color(0xFF194480),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '¡Bienvenido al Laboratorio de la Vida! '
            'Aquí descubrirás cómo funciona tu cuerpo, '
            'cómo viven otros seres y por qué debemos '
            'cuidar la naturaleza.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF283A51),
              height: 1.4,
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          zati,
          const SizedBox(width: 14),
          Flexible(child: dialogue),
        ],
      );
    }

    return Column(
      children: [
        zati,
        const SizedBox(height: 8),
        dialogue,
      ],
    );
  }

  Widget _buildTopicCard(
    _BiologyTopic topic,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTopicSelected(topic.id),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF247CC8),
                  Color(0xFF123D8A),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF80E9FF),
                width: 3,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 105,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(
                      alpha: 0.18,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    topic.icon,
                    color: topic.color,
                    size: 70,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 52,
                  child: Center(
                    child: Text(
                      topic.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFD84D),
                        Color(0xFFFFA51D),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Explorar',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF583200),
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFF583200),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF6433A9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '¡Aprende, experimenta y descubre '
        'el increíble mundo de la vida!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
    );
  }
}

class _BiologyTopic {
  final String id;
  final String title;
  final IconData icon;
  final Color color;

  const _BiologyTopic({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
  });
}
