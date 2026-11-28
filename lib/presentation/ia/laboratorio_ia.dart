import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';

/// Laboratorio de IA · “Enséñale a tu robot”: el alumno elige un problema,
/// escoge al menos 6 objetos del estante (los que quiera), les pone etiqueta
/// uno por uno, entrena a su robot y lo pone a prueba con los objetos del
/// mismo estante que NO eligió. Si etiquetó mal o eligió poco variado, el
/// robot se equivoca: así se ve que una IA aprende de sus datos.

/// Un objeto del estante: sus rasgos (números de 0 a 1) y su grupo verdadero.
class ObjetoLab {
  const ObjetoLab(this.nombre, this.emoji, this.rasgos, this.grupo, {this.color});
  final String nombre, emoji;
  final List<double> rasgos;
  final int grupo;

  /// Para los objetos que se dibujan (tomates), su color.
  final Color? color;
}

class ProblemaLab {
  const ProblemaLab(this.titulo, this.emoji, this.pregunta, this.grupos, this.objetos);
  final String titulo, emoji, pregunta;

  /// Nombre y emoji de cada grupo (etiqueta).
  final List<(String, String)> grupos;
  final List<ObjetoLab> objetos;
}

Color _tomate(double rojo) => Color.lerp(const Color(0xFF7CB342), const Color(0xFFE53935), rojo)!;

final problemasLab = [
  ProblemaLab('Tomates', '🍅', '¿El tomate está maduro o verde?', const [
    ('Maduro', '🔴'),
    ('Verde', '🟢')
  ], [
    for (final (n, r) in const [
      ('Tomate 1', 0.95),
      ('Tomate 2', 0.12),
      ('Tomate 3', 0.82),
      ('Tomate 4', 0.25),
      ('Tomate 5', 0.7),
      ('Tomate 6', 0.05),
      ('Tomate 7', 0.88),
      ('Tomate 8', 0.35),
      ('Tomate 9', 0.62),
      ('Tomate 10', 0.18),
      ('Tomate 11', 0.76),
      ('Tomate 12', 0.3),
    ])
      ObjetoLab(n, '', [r], r > 0.5 ? 0 : 1, color: _tomate(r)),
  ]),
  const ProblemaLab('Mascotas', '🐾', '¿Es un perro o un gato?', [
    ('Perro', '🐶'),
    ('Gato', '🐱')
  ], [
    ObjetoLab('Perro café', '🐕', [0.2, 0.9], 0),
    ObjetoLab('Gato naranja', '🐈', [0.9, 0.2], 1),
    ObjetoLab('Cachorro', '🐶', [0.3, 0.7], 0),
    ObjetoLab('Gato negro', '🐈‍⬛', [0.95, 0.25], 1),
    ObjetoLab('Poodle', '🐩', [0.15, 0.8], 0),
    ObjetoLab('Gatito', '🐱', [0.85, 0.15], 1),
    ObjetoLab('Perro guía', '🦮', [0.25, 0.85], 0),
    ObjetoLab('Gato feliz', '😺', [0.8, 0.1], 1),
    ObjetoLab('Perro de servicio', '🐕‍🦺', [0.2, 0.75], 0),
    ObjetoLab('Gato risueño', '😸', [0.9, 0.3], 1),
  ]),
  const ProblemaLab('Reciclaje', '♻️', '¿Se puede reciclar o no?', [
    ('Se recicla', '♻️'),
    ('No se recicla', '🗑️')
  ], [
    ObjetoLab('Lata', '🥫', [0.9, 0.05], 0),
    ObjetoLab('Cáscara de plátano', '🍌', [0.1, 0.9], 1),
    ObjetoLab('Periódico', '📰', [0.8, 0.1], 0),
    ObjetoLab('Restos de pizza', '🍕', [0.15, 0.95], 1),
    ObjetoLab('Botella de vidrio', '🍾', [0.95, 0.1], 0),
    ObjetoLab('Papel sanitario usado', '🧻', [0.2, 0.7], 1),
    ObjetoLab('Caja de cartón', '📦', [0.85, 0.15], 0),
    ObjetoLab('Curita usada', '🩹', [0.25, 0.65], 1),
    ObjetoLab('Botella de plástico', '🧴', [0.9, 0.2], 0),
    ObjetoLab('Hojas secas', '🍂', [0.1, 0.8], 1),
  ]),
];

const pasosLaboratorio = [('🎯', 'Problema'), ('🧺', 'Escoge'), ('🏷️', 'Etiqueta'), ('🏋️', 'Entrena'), ('🧪', 'Prueba')];

/// El “cerebro” del robot: compara un objeto nuevo con los ejemplos que
/// aprendió y responde el grupo del ejemplo más parecido.
int? predecir(List<(ObjetoLab, int)> ejemplos, ObjetoLab o) {
  if (ejemplos.isEmpty) return null;
  double distancia(ObjetoLab a) {
    var d = 0.0;
    for (var k = 0; k < a.rasgos.length; k++) {
      d += math.pow(a.rasgos[k] - o.rasgos[k], 2);
    }
    return d;
  }

  final ordenados = [...ejemplos]..sort((a, b) => distancia(a.$1).compareTo(distancia(b.$1)));
  return ordenados.first.$2;
}

class LaboratorioIA extends StatefulWidget {
  const LaboratorioIA({super.key, required this.onTerminar, this.color = const Color(0xFF8E24AA)});

  /// Se llama al publicar la IA, con las estrellas ganadas.
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioIA> createState() => LaboratorioIAState();
}

class LaboratorioIAState extends State<LaboratorioIA> {
  static const minimo = 6;
  int paso = 0;
  int? problemaElegido;
  final elegidos = <int>[];
  final etiquetas = <int, int>{};
  bool entrenando = false, entrenado = false;
  double progreso = 0;
  int intentos = 0;
  Timer? _timer;

  /// Resultados de la prueba: (objeto, lo que dijo el robot).
  final prueba = <(int, int)>[];

  ProblemaLab get problema => problemasLab[problemaElegido ?? 0];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Acciones ----------------------------------------------------------------

  void elegirProblema(int i) => setState(() {
        problemaElegido = i;
        elegidos.clear();
        etiquetas.clear();
        prueba.clear();
        entrenado = false;
        paso = 1;
      });

  void alternar(int i) => setState(() {
        if (!elegidos.remove(i)) elegidos.add(i);
        etiquetas.remove(i);
        entrenado = false;
      });

  /// El siguiente objeto que falta etiquetar (o null si ya están todos).
  int? get porEtiquetar => elegidos.where((i) => !etiquetas.containsKey(i)).firstOrNull;

  void etiquetar(int grupo) {
    final i = porEtiquetar;
    if (i == null) return;
    setState(() {
      etiquetas[i] = grupo;
      entrenado = false;
    });
  }

  void reetiquetar() => setState(() {
        etiquetas.clear();
        entrenado = false;
        paso = 2;
      });

  void irA(int p) => setState(() => paso = p);

  void entrenar() {
    if (entrenando) return;
    _timer?.cancel();
    setState(() {
      entrenando = true;
      progreso = 0;
      intentos++;
    });
    _timer = Timer.periodic(const Duration(milliseconds: 60), (tm) {
      if (!mounted) return tm.cancel();
      setState(() {
        progreso += 0.05;
        if (progreso >= 1) {
          tm.cancel();
          progreso = 1;
          entrenando = false;
          entrenado = true;
          _probar();
        }
      });
    });
  }

  /// El robot se prueba con los objetos del estante que el alumno NO eligió.
  void _probar() {
    prueba.clear();
    final ejemplos = [for (final i in elegidos) (problema.objetos[i], etiquetas[i]!)];
    var nuevos = [
      for (var i = 0; i < problema.objetos.length; i++)
        if (!elegidos.contains(i)) i
    ];
    if (nuevos.length < 3) nuevos = List.generate(problema.objetos.length, (i) => i);
    for (final i in nuevos.take(6)) {
      prueba.add((i, predecir(ejemplos, problema.objetos[i])!));
    }
  }

  int get aciertos => prueba.where((p) => problema.objetos[p.$1].grupo == p.$2).length;
  double get precision => prueba.isEmpty ? 0 : aciertos / prueba.length;
  int get estrellas => precision == 1 && intentos <= 1 ? 3 : (precision >= 0.8 ? 2 : 1);

  bool get puedeAvanzar => switch (paso) {
        0 => problemaElegido != null,
        1 => elegidos.length >= minimo,
        2 => porEtiquetar == null && elegidos.isNotEmpty,
        3 => entrenado,
        _ => false,
      };

  Future<void> publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡IA publicada!',
        mensaje: 'Tu robot reconoce “${problema.titulo}” y acertó $aciertos de ${prueba.length} con objetos que no conocía. ¡Ganaste la insignia de IA!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  /// Lo que Zati dice en cada momento.
  String get mensaje {
    switch (paso) {
      case 0:
        return 'Te damos la bienvenida al laboratorio. Hoy vas a enseñarle a un robot a reconocer cosas. ¿Qué problema quieres que resuelva?';
      case 1:
        final faltan = minimo - elegidos.length;
        if (faltan > 0) {
          return 'Escoge al menos $minimo objetos del estante para enseñarle al robot. Te faltan $faltan. 💡 Mientras más variados, mejor aprende.';
        }
        final grupos = {for (final i in elegidos) problema.objetos[i].grupo};
        return grupos.length < 2
            ? '¡Ya puedes seguir! Pero ojo: todos se parecen. Si el robot solo ve un tipo, puede equivocarse con los otros.'
            : '¡Muy bien! Escogiste ${elegidos.length} objetos variados. Presiona «Siguiente paso».';
      case 2:
        final i = porEtiquetar;
        return i == null
            ? '¡Etiquetaste todo! Ahora el robot puede aprender de tus ejemplos.'
            : '${problema.pregunta} Pon la etiqueta correcta: el robot aprenderá exactamente lo que tú le digas.';
      case 3:
        return entrenando
            ? 'El robot está comparando tus ejemplos y buscando lo que tienen en común…'
            : (entrenado
                ? '¡Entrenado! Ahora vamos a probarlo con objetos que nunca vio.'
                : 'Presiona «Entrenar» para que el robot aprenda de tus ${elegidos.length} ejemplos.');
      default:
        if (precision == 1) return '¡Perfecto! Acertó todo con objetos nuevos. Ya puedes publicar tu IA.';
        final malas = elegidos.where((i) => etiquetas[i] != problema.objetos[i].grupo).length;
        return malas > 0
            ? 'Se equivocó porque $malas ${malas == 1 ? 'etiqueta estaba mal' : 'etiquetas estaban mal'}. ¡Una IA aprende de sus datos! Corrige las etiquetas.'
            : 'Se equivocó porque le faltaron ejemplos variados. Regresa a «Escoge» y agrega otros.';
    }
  }

  // --- Interfaz ----------------------------------------------------------------

  @override
  Widget build(BuildContext context) => Escenario(
        velo: 0.08,
        colorVelo: widget.color,
        children: [
          encabezadoEle('Laboratorio de IA', '🤖 Enséñale a tu robot', widget.color),
          // Pasos
          Positioned(
            left: 244,
            top: 56,
            width: 608,
            child: Row(children: [
              for (var i = 0; i < pasosLaboratorio.length; i++) ...[
                if (i > 0) Expanded(child: Container(height: 3, color: i <= paso ? widget.color : Colors.white54)),
                _PasoChip(pasosLaboratorio[i].$1, pasosLaboratorio[i].$2, activo: i == paso, hecho: i < paso, color: widget.color),
              ],
            ]),
          ),
          Positioned(left: 8, top: 60, width: 230, height: 200, child: GloboZatiEle(mensaje, tam: 13)),
          Positioned(left: 8, top: 266, width: 230, height: 208, child: _robot()),
          Positioned(left: 244, top: 100, width: 608, height: 310, child: _contenido()),
          Positioned(left: 244, top: 418, width: 608, child: _botones()),
          const BotonVolverEscena(),
        ],
      );

  Widget _robot() => PanelEle(
        titulo: 'Tu robot',
        icono: Icons.smart_toy_rounded,
        color: widget.color,
        child: Column(children: [
          Expanded(child: Center(child: Text(entrenado ? '🤖💡' : '🤖', style: const TextStyle(fontSize: 52)))),
          Text(
            problemaElegido == null
                ? 'Esperando un problema…'
                : '${problema.emoji} ${problema.titulo}\n🧺 ${elegidos.length} ejemplos · 🏷️ ${etiquetas.length} etiquetas',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
          ),
        ]),
      );

  Widget _contenido() => switch (paso) {
        0 => _problemas(),
        1 => _estante(),
        2 => _etiquetar(),
        3 => _entrenar(),
        _ => _prueba(),
      };

  Widget _tarjeta(Widget hijo, {Color? borde}) => Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borde ?? widget.color, width: 3),
        ),
        child: hijo,
      );

  Widget _problemas() => Row(children: [
        for (var i = 0; i < problemasLab.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Tooltip(
                message: 'Problema ${problemasLab[i].titulo}',
                child: Rebote(
                  onTap: () => elegirProblema(i),
                  child: _tarjeta(
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(problemasLab[i].emoji, style: const TextStyle(fontSize: 54)),
                      Text(problemasLab[i].titulo, style: TextStyle(fontFamily: 'LilitaOne', fontSize: 22, color: oscurecer(widget.color, 0.2))),
                      const SizedBox(height: 4),
                      Text(problemasLab[i].pregunta, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('${problemasLab[i].grupos[0].$2} o ${problemasLab[i].grupos[1].$2}', style: const TextStyle(fontSize: 24)),
                    ]),
                    borde: problemaElegido == i ? const Color(0xFFFFB300) : null,
                  ),
                ),
              ),
            ),
          ),
      ]);

  Widget _objeto(int i, {double tam = 46}) {
    final o = problema.objetos[i];
    if (o.color != null) {
      return SizedBox(width: tam, height: tam, child: CustomPaint(painter: _PintorTomate(o.color!)));
    }
    return SizedBox(width: tam, height: tam, child: CustomPaint(painter: _PintorEmoji(o.emoji)));
  }

  Widget _estante() => _tarjeta(Column(children: [
        Text('Escoge al menos $minimo (${elegidos.length} elegidos)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: elegidos.length >= minimo ? ColoresJuego.correcto : ColoresJuego.texto)),
        const SizedBox(height: 6),
        Expanded(
          child: GridView.count(
            crossAxisCount: 6,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            children: [
              for (var i = 0; i < problema.objetos.length; i++)
                Tooltip(
                  message: 'Objeto ${problema.objetos[i].nombre}',
                  child: Rebote(
                    onTap: () => alternar(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: elegidos.contains(i) ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: elegidos.contains(i) ? ColoresJuego.correcto : Colors.black12, width: elegidos.contains(i) ? 3 : 1.5),
                      ),
                      child: Stack(children: [
                        Center(child: _objeto(i)),
                        if (elegidos.contains(i))
                          const Positioned(right: 4, top: 2, child: Icon(Icons.check_circle_rounded, color: ColoresJuego.correcto, size: 20)),
                      ]),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ]));

  Widget _etiquetar() {
    final i = porEtiquetar;
    return _tarjeta(Row(children: [
      Expanded(
        flex: 3,
        child: i == null
            ? const Center(child: Text('✅ ¡Todos etiquetados!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Objeto ${etiquetas.length + 1} de ${elegidos.length}', style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                _objeto(i, tam: 110),
                const SizedBox(height: 6),
                Text(problema.pregunta, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  for (var g = 0; g < 2; g++) ...[
                    if (g > 0) const SizedBox(width: 10),
                    Tooltip(
                      message: 'Etiqueta ${problema.grupos[g].$1}',
                      child: BotonJuego(
                          texto: '${problema.grupos[g].$2} ${problema.grupos[g].$1}',
                          color: g == 0 ? const Color(0xFF2E7D32) : const Color(0xFF6A1B9A),
                          onTap: () => etiquetar(g)),
                    ),
                  ],
                ]),
              ]),
      ),
      // Lo ya etiquetado, en dos canastas
      Expanded(
        flex: 2,
        child: Column(children: [
          for (var g = 0; g < 2; g++)
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(3),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  Text('${problema.grupos[g].$2} ${problema.grupos[g].$1}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5)),
                  Expanded(
                    child: Wrap(spacing: 2, runSpacing: 2, children: [
                      for (final e in etiquetas.entries)
                        if (e.value == g) _objeto(e.key, tam: 30),
                    ]),
                  ),
                ]),
              ),
            ),
        ]),
      ),
    ]));
  }

  Widget _entrenar() => _tarjeta(Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Wrap(spacing: 4, runSpacing: 4, alignment: WrapAlignment.center, children: [for (final i in elegidos) _objeto(i, tam: 34)]),
        const SizedBox(height: 12),
        Text(entrenando ? '🧠 Aprendiendo… ${(progreso * 100).round()}%' : (entrenado ? '✅ ¡Entrenado!' : '🤖 Listo para aprender'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(value: progreso, minHeight: 16, color: widget.color, backgroundColor: const Color(0xFFE1BEE7)),
        ),
      ]));

  Widget _prueba() => _tarjeta(Column(children: [
        Text('🧪 Prueba con objetos que el robot no conocía: $aciertos de ${prueba.length} bien',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: precision == 1 ? ColoresJuego.correcto : ColoresJuego.texto)),
        const SizedBox(height: 6),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.9,
            children: [
              for (final (i, dijo) in prueba)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: problema.objetos[i].grupo == dijo ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(children: [
                    _objeto(i, tam: 44),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text('Dijo: ${problema.grupos[dijo].$1} ${problema.objetos[i].grupo == dijo ? '✅' : '❌'}',
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                    ),
                  ]),
                ),
            ],
          ),
        ),
      ]));

  Widget _boton(String texto, IconData icono, Color color, VoidCallback? onTap) =>
      Tooltip(message: texto, child: BotonJuego(texto: texto, icono: icono, color: color, onTap: onTap));

  Widget _botones() => Wrap(spacing: 8, runSpacing: 4, children: [
        if (paso > 0 && paso < 4) _boton('Paso anterior', Icons.arrow_back_rounded, const Color(0xFF78909C), () => irA(paso - 1)),
        if (paso == 3 && !entrenado) _boton('Entrenar', Icons.fitness_center_rounded, const Color(0xFFFF8A00), entrenando ? null : entrenar),
        if (paso >= 1 && paso <= 3) _boton('Siguiente paso', Icons.arrow_forward_rounded, const Color(0xFF2DB84C), puedeAvanzar ? () => irA(paso + 1) : null),
        if (paso == 4 && precision < 1) ...[
          _boton('Corregir etiquetas', Icons.label_rounded, const Color(0xFF8E24AA), reetiquetar),
          _boton('Escoger otros', Icons.shopping_basket_rounded, const Color(0xFF00897B), () => irA(1)),
        ],
        if (paso == 4 && precision >= 0.8) _boton('Publicar IA', Icons.rocket_launch_rounded, const Color(0xFF2DB84C), publicar),
      ]);
}

class _PasoChip extends StatelessWidget {
  const _PasoChip(this.emoji, this.texto, {required this.activo, required this.hecho, required this.color});
  final String emoji, texto;
  final bool activo, hecho;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: activo ? color : (hecho ? aclarar(color, 0.6) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: 2),
        ),
        child: Text('$emoji $texto', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: activo ? Colors.white : oscurecer(color, 0.2))),
      );
}

/// Un tomate dibujado (su color va de verde a rojo).
class _PintorTomate extends CustomPainter {
  _PintorTomate(this.color);
  final Color color;
  @override
  void paint(Canvas c, Size s) {
    final centro = s.center(Offset(0, s.height * 0.06));
    final r = s.shortestSide * 0.4;
    c.drawOval(Rect.fromCenter(center: centro, width: r * 2.1, height: r * 1.85), Paint()..color = color);
    c.drawOval(Rect.fromCenter(center: centro + Offset(-r * 0.35, -r * 0.3), width: r * 0.5, height: r * 0.35), Paint()..color = Colors.white38);
    final hoja = Paint()..color = const Color(0xFF2E7D32);
    for (var k = 0; k < 5; k++) {
      final a = -math.pi / 2 + (k - 2) * 0.55;
      c.drawOval(Rect.fromCenter(center: centro + Offset(math.cos(a) * r * 0.35, -r * 0.82 + math.sin(a) * r * 0.1), width: r * 0.5, height: r * 0.2), hoja);
    }
  }

  @override
  bool shouldRepaint(_PintorTomate old) => old.color != color;
}

class _PintorEmoji extends CustomPainter {
  _PintorEmoji(this.emoji);
  final String emoji;
  @override
  void paint(Canvas c, Size s) => dibujarEmoji(c, emoji, s.center(Offset.zero), s.shortestSide * 0.8);
  @override
  bool shouldRepaint(_PintorEmoji old) => old.emoji != emoji;
}
