import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../biology/temas/motor.dart' show dibujarEmoji;
import '../electronica/comun.dart';

/// Un material del estante: (emoji, nombre).
typedef MaterialLab = (String, String);

/// Una cantidad que se mide: (emoji, nombre, unidad, máximo, mínimo correcto, máximo correcto).
typedef Medida = (String, String, String, double, double, double);

/// Un experimento del laboratorio de Química.
class ExperimentoQui {
  const ExperimentoQui({
    required this.titulo,
    required this.emoji,
    required this.pregunta,
    required this.hipotesis,
    required this.estante,
    required this.correctos,
    required this.medidas,
    required this.observaciones,
    required this.observacionCorrecta,
    required this.permanente,
    required this.explicacion,
  });
  final String titulo, emoji, pregunta, explicacion;
  final List<String> hipotesis;
  final List<MaterialLab> estante;

  /// Índices del estante que se necesitan.
  final Set<int> correctos;
  final List<Medida> medidas;
  final List<String> observaciones;
  final int observacionCorrecta;
  final bool permanente;
}

const experimentosQui = [
  ExperimentoQui(
    titulo: 'El volcán de espuma',
    emoji: '🌋',
    pregunta: '¿Qué pasará si mezclamos bicarbonato con vinagre?',
    hipotesis: ['Saldrán burbujas y espuma', 'No pasará nada', 'Se volverá hielo'],
    estante: [('🧂', 'Bicarbonato'), ('🍶', 'Vinagre'), ('🧊', 'Hielo'), ('🍬', 'Azúcar'), ('🫙', 'Frasco'), ('🎨', 'Colorante rojo')],
    correctos: {0, 1, 4, 5},
    medidas: [('🥄', 'Bicarbonato', 'cucharadas', 5, 2, 3), ('🍶', 'Vinagre', 'ml', 200, 80, 120)],
    observaciones: ['Burbujas y espuma que se desbordan', 'El líquido se congeló', 'No cambió nada'],
    observacionCorrecta: 0,
    permanente: true,
    explicacion:
        'El bicarbonato y el vinagre reaccionan y forman un gas nuevo, el dióxido de carbono: por eso salen burbujas. Se formaron sustancias nuevas: es un cambio permanente (químico).',
  ),
  ExperimentoQui(
    titulo: 'La tinta invisible',
    emoji: '🍋',
    pregunta: '¿Qué pasará si calentamos un mensaje escrito con jugo de limón?',
    hipotesis: ['El mensaje aparecerá en color café', 'El papel se pondrá azul', 'El mensaje desaparecerá para siempre'],
    estante: [('🍋', 'Jugo de limón'), ('🖌️', 'Pincel'), ('📄', 'Papel'), ('💡', 'Foco caliente'), ('🧊', 'Hielo'), ('🥤', 'Refresco')],
    correctos: {0, 1, 2, 3},
    medidas: [('⏱️', 'Calor', 'segundos', 60, 20, 40)],
    observaciones: ['Aparecieron letras cafés', 'El papel se volvió transparente', 'Nada, el papel quedó igual'],
    observacionCorrecta: 0,
    permanente: true,
    explicacion:
        'Con el calor, el jugo de limón se oxida y se oscurece más rápido que el papel: las letras aparecen en café y ya no regresan a ser invisibles. Es un cambio permanente. ¡Si calientas de más, el papel se quema!',
  ),
  ExperimentoQui(
    titulo: 'El detector de col morada',
    emoji: '🥬',
    pregunta: '¿De qué color se pondrá el jugo de col morada con limón y con jabón?',
    hipotesis: ['Cambiará de color: rosa con limón y verde con jabón', 'Siempre seguirá morado', 'Se volverá transparente'],
    estante: [('🥬', 'Jugo de col morada'), ('🍋', 'Limón'), ('🧼', 'Agua con jabón'), ('🥛', 'Vasos'), ('🍫', 'Chocolate'), ('🧂', 'Sal de mesa')],
    correctos: {0, 1, 2, 3},
    medidas: [('🥬', 'Jugo de col', 'ml', 100, 40, 60)],
    observaciones: ['Rosa con limón, verde con jabón', 'Todo se volvió negro', 'Todo siguió morado'],
    observacionCorrecta: 0,
    permanente: true,
    explicacion:
        'El jugo de col morada es un indicador: cambia de color según la sustancia. Con ácidos (limón) se pone rosa y con bases (jabón) verde o azul. El color cambia porque reaccionan: es un cambio químico.',
  ),
];

const equipoSeguridad = [
  ('🥽', 'Lentes de seguridad', true),
  ('🥼', 'Bata', true),
  ('🧤', 'Guantes', true),
  ('🧑‍🏫', 'Un adulto que te acompañe', true),
  ('🩴', 'Sandalias', false),
  ('🍔', 'Comer en el laboratorio', false),
];

const pasosQui = ['Hipótesis', 'Materiales', 'Medir', 'Experimentar', 'Conclusión'];

/// Laboratorio de Experimentos de Química.
class LaboratorioQui extends StatefulWidget {
  const LaboratorioQui({super.key, required this.onTerminar, this.color = const Color(0xFF8E24AA)});
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioQui> createState() => LaboratorioQuiState();
}

class LaboratorioQuiState extends State<LaboratorioQui> {
  bool equipado = false;
  final equipo = <int>{};
  String? avisoEquipo;
  int? experimento;

  /// Paso del experimento actual (0 a 4).
  int paso = 0;
  int? hipotesis;
  final materiales = <int>{};
  String? aviso;
  List<double> medidas = [];
  double reaccion = 0;
  Timer? _timer;
  int? observacion;
  bool? permanente;
  int errores = 0;

  /// Experimentos terminados con la hipótesis que se eligió.
  final bitacora = <int, int>{};

  ExperimentoQui get e => experimentosQui[experimento!];
  bool get terminado => bitacora.length == experimentosQui.length;
  int get estrellas => errores <= 2 ? 3 : (errores <= 5 ? 2 : 1);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void alternarEquipo(int i) => setState(() {
        if (!equipo.remove(i)) equipo.add(i);
        avisoEquipo = null;
      });

  void comprobarEquipo() => setState(() {
        final correcto = {
          for (var i = 0; i < equipoSeguridad.length; i++)
            if (equipoSeguridad[i].$3) i
        };
        if (equipo.length == correcto.length && equipo.containsAll(correcto)) {
          equipado = true;
        } else {
          errores++;
          final malo = equipo.where((i) => !equipoSeguridad[i].$3);
          avisoEquipo = malo.isNotEmpty
              ? '¡Cuidado! “${equipoSeguridad[malo.first].$2}” no es seguro en el laboratorio.'
              : 'Te falta protección. Un científico siempre se protege los ojos, la ropa y las manos, y trabaja con un adulto.';
        }
      });

  void elegirExperimento(int i) => setState(() {
        experimento = i;
        paso = 0;
        hipotesis = null;
        materiales.clear();
        aviso = null;
        medidas = [for (final _ in experimentosQui[i].medidas) 0.0];
        reaccion = 0;
        observacion = null;
        permanente = null;
      });

  void elegirHipotesis(int i) => setState(() {
        hipotesis = i;
        paso = 1;
      });

  void alternarMaterial(int i) => setState(() {
        if (!materiales.remove(i)) materiales.add(i);
        aviso = null;
      });

  void confirmarMateriales() => setState(() {
        if (materiales.length == e.correctos.length && materiales.containsAll(e.correctos)) {
          paso = 2;
          aviso = null;
        } else {
          errores++;
          final sobra = materiales.difference(e.correctos);
          aviso = sobra.isNotEmpty ? '“${e.estante[sobra.first].$2}” no se necesita para este experimento.' : 'Te falta algún material. Revisa el estante.';
        }
      });

  void medir(int k, double v) => setState(() {
        medidas[k] = v;
        aviso = null;
      });

  bool get medidasCorrectas => [for (var k = 0; k < e.medidas.length; k++) medidas[k] >= e.medidas[k].$5 && medidas[k] <= e.medidas[k].$6].every((x) => x);

  void confirmarMedidas() => setState(() {
        if (medidasCorrectas) {
          paso = 3;
          aviso = null;
        } else {
          errores++;
          final m = [
            for (var k = 0; k < e.medidas.length; k++)
              if (!(medidas[k] >= e.medidas[k].$5 && medidas[k] <= e.medidas[k].$6)) e.medidas[k]
          ].first;
          aviso = '${m.$2}: debe estar entre ${_num(m.$5)} y ${_num(m.$6)} ${m.$3}. ¡Medir con cuidado es parte de la ciencia!';
        }
      });

  void experimentar() {
    if (reaccion > 0) return;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) return t.cancel();
      setState(() {
        reaccion = math.min(1, reaccion + 0.025);
        if (reaccion >= 1) {
          t.cancel();
          paso = 4;
        }
      });
    });
    setState(() => reaccion = 0.001);
  }

  void observar(int i) => setState(() {
        observacion = i;
        if (i != e.observacionCorrecta) {
          errores++;
          aviso = 'Mira otra vez la animación del experimento. ¿Qué cambió?';
        } else {
          aviso = null;
        }
      });

  void elegirTipo(bool p) => setState(() {
        permanente = p;
        if (p != e.permanente) {
          errores++;
          aviso = 'Piensa: ¿se puede regresar a como estaba al principio?';
        } else {
          aviso = null;
        }
      });

  bool get conclusionLista => observacion == e.observacionCorrecta && permanente == e.permanente;

  void guardarEnBitacora() => setState(() {
        bitacora[experimento!] = hipotesis!;
        experimento = null;
      });

  Future<void> publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡Bitácora completa!',
        mensaje:
            'Hiciste tres experimentos siguiendo el método científico: hipótesis, materiales, medición, experimento y conclusión. ¡Ganaste la insignia “Químico Experimentador”!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  static String _num(double v) => v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(1);

  String get mensaje {
    if (!equipado) {
      return avisoEquipo ??
          '¡Te damos la bienvenida al Laboratorio de Experimentos! Antes de empezar, ponte el equipo de seguridad. Toca lo que necesitas y presiona “Comprobar”.';
    }
    if (experimento == null) {
      return terminado
          ? '¡Completaste tu bitácora de científico! Presiona “Publicar bitácora”.'
          : 'Elige un experimento. Cada uno sigue los pasos del método científico.';
    }
    if (aviso != null) return aviso!;
    return switch (paso) {
      0 => 'Paso 1 · Hipótesis: un científico primero imagina qué va a pasar. ${e.pregunta}',
      1 => 'Paso 2 · Materiales: toma del estante solo lo que necesitas y presiona “Listo”.',
      2 => 'Paso 3 · Medir: mueve los controles para medir la cantidad correcta.',
      3 => reaccion == 0 ? 'Paso 4 · ¡A experimentar! Presiona el botón y observa con atención.' : 'Observa con atención…',
      _ => conclusionLista
          ? '${e.explicacion} ${hipotesis == 0 ? '¡Tu hipótesis era correcta!' : 'Tu hipótesis no se cumplió… ¡y eso también es aprender!'}'
          : 'Paso 5 · Conclusión: ¿qué observaste y qué tipo de cambio fue?',
    };
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Escenario(
      velo: 0.06,
      colorVelo: c,
      children: [
        encabezadoEle('Laboratorio', experimento == null ? 'Laboratorio de Experimentos' : e.titulo, c),
        Positioned(left: 8, top: 60, width: 230, height: 230, child: GloboZatiEle(mensaje, tam: 12)),
        Positioned(left: 8, top: 296, width: 230, height: 176, child: _panelBitacora(c)),
        Positioned(left: 244, top: 60, width: 608, height: 352, child: _contenido(c)),
        if (equipado && experimento != null)
          Positioned(
              left: 244,
              top: 420,
              child: Tooltip(
                  message: 'Volver a los experimentos',
                  child: BotonJuego(
                      texto: 'Experimentos', icono: Icons.science_rounded, color: const Color(0xFF757575), onTap: () => setState(() => experimento = null)))),
        if (terminado && experimento == null) Positioned(left: 640, top: 420, child: BotonSiguiente(texto: 'Publicar bitácora', onTap: publicar)),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _panelBitacora(Color c) => PanelEle(
        titulo: 'Bitácora (${bitacora.length} de ${experimentosQui.length})',
        icono: Icons.menu_book_rounded,
        color: c,
        child: ListView(padding: EdgeInsets.zero, children: [
          for (var i = 0; i < experimentosQui.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${bitacora.containsKey(i) ? '✅' : '⬜'} ${experimentosQui[i].emoji} ${experimentosQui[i].titulo}${bitacora.containsKey(i) ? '\n   Hipótesis: ${bitacora[i] == 0 ? 'se cumplió' : 'no se cumplió'}' : ''}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, height: 1.15),
              ),
            ),
        ]),
      );

  Widget _caja(Color c, Widget hijo) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.96), borderRadius: BorderRadius.circular(20), border: Border.all(color: c, width: 3)),
        child: hijo,
      );

  Widget _ficha(String emoji, String texto, bool activo, Color c, VoidCallback onTap, {String? tooltip, Color? marca}) => Tooltip(
        message: tooltip ?? texto,
        child: Rebote(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: activo ? aclarar(marca ?? c, 0.75) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: activo ? (marca ?? c) : Colors.black12, width: 3),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(emoji, style: const TextStyle(fontSize: 34)),
              const SizedBox(height: 2),
              Text(texto, textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, height: 1.05)),
            ]),
          ),
        ),
      );

  Widget _contenido(Color c) {
    if (!equipado) {
      return _caja(
          c,
          Column(children: [
            const Text('🧑‍🔬 Equipo de seguridad', style: TextStyle(fontFamily: 'LilitaOne', fontSize: 22)),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.count(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 1.9, children: [
                for (var i = 0; i < equipoSeguridad.length; i++)
                  _ficha(equipoSeguridad[i].$1, equipoSeguridad[i].$2, equipo.contains(i), c, () => alternarEquipo(i)),
              ]),
            ),
            Tooltip(message: 'Comprobar equipo', child: BotonJuego(texto: 'Comprobar', icono: Icons.check_rounded, color: c, onTap: comprobarEquipo)),
          ]));
    }
    if (experimento == null) {
      return Row(children: [
        for (var i = 0; i < experimentosQui.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Tooltip(
                message: 'Experimento ${experimentosQui[i].titulo}',
                child: Rebote(
                  onTap: () => elegirExperimento(i),
                  child: _caja(
                    bitacora.containsKey(i) ? ColoresJuego.correcto : c,
                    Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(experimentosQui[i].emoji, style: const TextStyle(fontSize: 56)),
                      const SizedBox(height: 6),
                      Text(experimentosQui[i].titulo, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'LilitaOne', fontSize: 19)),
                      const SizedBox(height: 6),
                      Text(experimentosQui[i].pregunta, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5)),
                      const SizedBox(height: 8),
                      Text(bitacora.containsKey(i) ? '✅ En tu bitácora' : '▶ Empezar', style: TextStyle(fontWeight: FontWeight.w900, color: oscurecer(c, 0.2))),
                    ]),
                  ),
                ),
              ),
            ),
          ),
      ]);
    }
    final pasos = Row(children: [
      for (var k = 0; k < pasosQui.length; k++) ...[
        Expanded(
          child: Container(
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: k == paso ? c : (k < paso ? aclarar(c, 0.6) : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: c, width: 2),
            ),
            child: FittedBox(
                child: Text(' ${k + 1}. ${pasosQui[k]} ',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: k == paso ? Colors.white : oscurecer(c, 0.3)))),
          ),
        ),
        if (k < pasosQui.length - 1) const SizedBox(width: 3),
      ],
    ]);
    final cuerpo = switch (paso) {
      0 => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('🤔 ${e.pregunta}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          for (var i = 0; i < e.hipotesis.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Tooltip(
                  message: 'Hipótesis ${i + 1}',
                  child: SizedBox(
                      width: 440, child: BotonJuego(texto: e.hipotesis[i], icono: Icons.lightbulb_rounded, color: c, onTap: () => elegirHipotesis(i)))),
            ),
        ]),
      1 => Column(children: [
          const Text('🧪 Estante de materiales', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Expanded(
            child: GridView.count(crossAxisCount: 6, mainAxisSpacing: 6, crossAxisSpacing: 6, childAspectRatio: 0.82, children: [
              for (var i = 0; i < e.estante.length; i++)
                _ficha(e.estante[i].$1, e.estante[i].$2, materiales.contains(i), c, () => alternarMaterial(i), tooltip: 'Material ${e.estante[i].$2}'),
            ]),
          ),
          Tooltip(message: 'Materiales listos', child: BotonJuego(texto: 'Listo', icono: Icons.check_rounded, color: c, onTap: confirmarMateriales)),
        ]),
      2 => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var k = 0; k < e.medidas.length; k++) ...[
            Row(children: [
              Text(e.medidas[k].$1, style: const TextStyle(fontSize: 30)),
              const SizedBox(width: 8),
              SizedBox(width: 120, child: Text(e.medidas[k].$2, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800))),
              Expanded(
                child: Tooltip(
                  message: 'Medir ${e.medidas[k].$2}',
                  child: Slider(
                    value: medidas[k],
                    max: e.medidas[k].$4,
                    divisions: e.medidas[k].$4 <= 10 ? e.medidas[k].$4.toInt() : (e.medidas[k].$4 ~/ 10),
                    activeColor: c,
                    onChanged: (v) => medir(k, v),
                  ),
                ),
              ),
              SizedBox(width: 110, child: Text('${_num(medidas[k])} ${e.medidas[k].$3}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900))),
            ]),
            const SizedBox(height: 10),
          ],
          Tooltip(message: 'Medidas listas', child: BotonJuego(texto: 'Listo', icono: Icons.check_rounded, color: c, onTap: confirmarMedidas)),
        ]),
      3 => Column(children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Reloj(builder: (_, t) => CustomPaint(painter: _Reaccion(experimento!, reaccion, t), child: const SizedBox.expand())),
            ),
          ),
          const SizedBox(height: 6),
          Tooltip(message: 'Experimentar', child: BotonJuego(texto: '¡Experimentar!', icono: Icons.play_arrow_rounded, color: c, onTap: experimentar)),
        ]),
      _ => Row(children: [
          SizedBox(
            width: 210,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Reloj(builder: (_, t) => CustomPaint(painter: _Reaccion(experimento!, 1, t), child: const SizedBox.expand())),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('👀 ¿Qué observaste?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              for (var i = 0; i < e.observaciones.length; i++)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Tooltip(
                    message: 'Observación ${i + 1}',
                    child: ChipEle(
                        texto: e.observaciones[i],
                        activo: observacion == i,
                        color: observacion == i && i != e.observacionCorrecta ? const Color(0xFFE53935) : c,
                        onTap: () => observar(i)),
                  ),
                ),
              const SizedBox(height: 10),
              const Text('🔄 ¿Qué tipo de cambio fue?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Row(children: [
                Tooltip(
                    message: 'Cambio temporal', child: ChipEle(texto: '↩️ Temporal', activo: permanente == false, color: c, onTap: () => elegirTipo(false))),
                const SizedBox(width: 6),
                Tooltip(
                    message: 'Cambio permanente', child: ChipEle(texto: '🚫 Permanente', activo: permanente == true, color: c, onTap: () => elegirTipo(true))),
              ]),
              const Spacer(),
              if (conclusionLista)
                Align(
                  alignment: Alignment.centerRight,
                  child: Tooltip(
                      message: 'Guardar en la bitácora',
                      child:
                          BotonJuego(texto: 'Guardar en la bitácora', icono: Icons.menu_book_rounded, color: ColoresJuego.correcto, onTap: guardarEnBitacora)),
                ),
            ]),
          ),
        ]),
    };
    return _caja(c, Column(children: [pasos, const SizedBox(height: 10), Expanded(child: cuerpo)]));
  }
}

/// Animación de cada experimento.
class _Reaccion extends CustomPainter {
  _Reaccion(this.exp, this.f, this.t);
  final int exp;
  final double f, t;

  @override
  void paint(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, relleno(const Color(0xFFF3E5F5)));
    c.drawRect(Rect.fromLTWH(0, s.height * 0.82, s.width, s.height * 0.18), relleno(const Color(0xFFBCAAA4)));
    final cx = s.width / 2, base = s.height * 0.82;
    switch (exp) {
      case 0:
        // Frasco con líquido rojo que hace espuma y se desborda
        final frasco = Rect.fromCenter(center: Offset(cx, base - 55), width: 80, height: 110);
        c.drawRRect(RRect.fromRectAndRadius(frasco, const Radius.circular(10)), relleno(const Color(0x33FFFFFF)));
        c.drawRect(Rect.fromLTRB(frasco.left + 4, frasco.bottom - 40, frasco.right - 4, frasco.bottom - 4), relleno(const Color(0xCCE53935)));
        if (f > 0) {
          final alto = 40 + f * 90;
          for (var k = 0; k < 40; k++) {
            final a = k * 2.39;
            final r = 4 + (k % 4) * 3.0;
            final y = frasco.bottom - 10 - ((k * 13) % alto) - math.sin(t * 6 + k) * 3;
            final x = cx + math.cos(a) * (y < frasco.top ? 20 + f * 40 * ((k % 5) / 5) : 26);
            c.drawCircle(Offset(x, y), r, relleno(Color.fromARGB(200, 255, 205 + (k % 3) * 15, 210)));
          }
          if (f > 0.5) {
            for (var k = 0; k < 8; k++) {
              final y = frasco.top + (t * 40 + k * 15) % (base - frasco.top);
              c.drawCircle(Offset(frasco.left - 6 - (k % 3) * 6, y), 6, relleno(const Color(0xCCFF8A80)));
              c.drawCircle(Offset(frasco.right + 6 + (k % 3) * 6, y), 6, relleno(const Color(0xCCFF8A80)));
            }
          }
        }
        c.drawRRect(RRect.fromRectAndRadius(frasco, const Radius.circular(10)), linea(const Color(0xFF90A4AE), 3));
        dibujarEmoji(c, '🧂', Offset(cx - 90, base - 20), 30);
        dibujarEmoji(c, '🍶', Offset(cx + 90, base - 22), 32);
      case 1:
        // Papel con letras que aparecen con el calor del foco
        final papel = Rect.fromCenter(center: Offset(cx, s.height * 0.5), width: math.min(s.width * 0.7, 300), height: s.height * 0.5);
        c.drawRect(papel, relleno(Color.lerp(Colors.white, const Color(0xFFFFF3E0), f)!));
        c.drawRect(papel, linea(const Color(0xFFBCAAA4), 2));
        final tp = TextPainter(
            text: TextSpan(
                text: '¡CIENCIA!',
                style: TextStyle(fontSize: papel.width / 6, fontWeight: FontWeight.w900, color: Color.fromARGB((230 * f).round(), 121, 85, 72))),
            textDirection: TextDirection.ltr)
          ..layout();
        tp.paint(c, papel.center - Offset(tp.width / 2, tp.height / 2));
        final foco = Offset(cx, papel.top - 28);
        if (f > 0) {
          c.drawCircle(foco, 40,
              Paint()..shader = RadialGradient(colors: const [Color(0x99FFEB3B), Color(0x00FFEB3B)]).createShader(Rect.fromCircle(center: foco, radius: 40)));
        }
        dibujarEmoji(c, '💡', foco, 34);
        for (var k = 0; k < 5 && f > 0; k++) {
          final y = foco.dy + 20 + ((t * 30 + k * 8) % 30);
          c.drawLine(Offset(cx - 40 + k * 20, y), Offset(cx - 36 + k * 20, y + 6), linea(const Color(0x88FF7043), 2));
        }
      default:
        // Tres vasos que cambian de color: ácido, neutro y base
        const finales = [Color(0xFFF06292), Color(0xFF7E57C2), Color(0xFF26A69A)];
        const etiquetas = ['🍋 Limón', '💧 Agua', '🧼 Jabón'];
        for (var k = 0; k < 3; k++) {
          final x = s.width * (0.2 + k * 0.3);
          final vaso = Rect.fromCenter(center: Offset(x, base - 50), width: 64, height: 90);
          final col = Color.lerp(const Color(0xFF7E57C2), finales[k], (f * 1.4 - k * 0.15).clamp(0, 1))!;
          c.drawRect(Rect.fromLTRB(vaso.left + 4, vaso.top + 25, vaso.right - 4, vaso.bottom - 3), relleno(col));
          c.drawRRect(RRect.fromRectAndRadius(vaso, const Radius.circular(6)), linea(const Color(0xFF90A4AE), 3));
          final tp = TextPainter(
              text: TextSpan(text: etiquetas[k], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF4A148C))),
              textDirection: TextDirection.ltr)
            ..layout();
          tp.paint(c, Offset(x - tp.width / 2, base + 6));
          if (f > 0 && f < 1) {
            for (var g = 0; g < 3; g++) {
              final y = vaso.top - 10 + ((t * 60 + g * 12) % 30);
              c.drawCircle(Offset(x + (g - 1) * 6, y), 3, relleno(const Color(0xAA7E57C2)));
            }
          }
        }
    }
  }

  @override
  bool shouldRepaint(_Reaccion old) => true;
}
