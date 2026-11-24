import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../biology/tema1/comunes.dart';
import '../biology/tema1/escenario.dart';
import '../electronica/comun.dart';
import 'modelo_ia.dart';
import 'proyectos_ia.dart';
import 'sims_ia.dart' show TarjetaEjemplo;

/// Laboratorio de IA: el alumno construye su propia inteligencia artificial
/// como lo hace un equipo de ingenieros: elige un problema, reúne datos, los
/// etiqueta, elige qué rasgos observar, entrena, prueba y publica.
class LaboratorioIA extends StatefulWidget {
  const LaboratorioIA({super.key, required this.onTerminar, this.color = const Color(0xFF8E24AA)});

  /// Se llama al publicar la IA, con las estrellas ganadas.
  final ValueChanged<int> onTerminar;
  final Color color;
  @override
  State<LaboratorioIA> createState() => LaboratorioIAState();
}

const pasosLaboratorio = [('🎯', 'Problema'), ('🗂️', 'Datos'), ('🏷️', 'Etiquetas'), ('🔍', 'Rasgos'), ('🏋️', 'Entrenar'), ('🧪', 'Probar')];

class LaboratorioIAState extends State<LaboratorioIA> {
  int paso = 0;
  int? proyectoElegido;
  final usados = <int>{};
  final etiquetas = <int, int>{};
  final rasgos = <String>{};
  int? elegido;
  double progreso = 0;
  bool entrenando = false;
  ModeloIA? modelo;
  int intentos = 0;
  Timer? _timer;

  ProyectoIA get proyecto => proyectosLaboratorio[proyectoElegido ?? 0];
  List<int> get datos => usados.toList()..sort();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // --- Acciones ----------------------------------------------------------------

  void elegirProyecto(int i) => setState(() {
        proyectoElegido = i;
        usados.clear();
        etiquetas.clear();
        rasgos.clear();
        modelo = null;
        paso = 1;
      });

  void usar(int i) => setState(() {
        if (!usados.remove(i)) usados.add(i);
        etiquetas.remove(i);
        modelo = null;
      });

  void usarTodos() => setState(() {
        usados.addAll(List.generate(proyecto.banco.length, (i) => i));
        modelo = null;
      });

  void elegir(int i) => setState(() => elegido = elegido == i ? null : i);

  void etiquetar(int i, int e) => setState(() {
        etiquetas[i] = e;
        elegido = null;
        modelo = null;
      });

  void alternarRasgo(String id) => setState(() {
        if (!rasgos.remove(id)) rasgos.add(id);
        modelo = null;
      });

  void irA(int p) => setState(() {
        paso = p;
        elegido = null;
      });

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
        progreso += 0.04;
        if (progreso >= 1) {
          tm.cancel();
          progreso = 1;
          entrenando = false;
          modelo = ModeloIA([for (final i in datos) (proyecto.banco[i], etiquetas[i]!)], {...rasgos});
        }
      });
    });
  }

  double get precision => modelo?.precision(proyecto.prueba) ?? 0;
  int get estrellas => precision == 1 && intentos <= 2 ? 3 : (precision == 1 ? 2 : 1);

  Future<void> publicar() async {
    await mostrarCelebracion(context,
        titulo: '¡IA publicada!',
        mensaje:
            'Tu “${proyecto.titulo}” acierta el ${(precision * 100).round()} % con datos nuevos. Hiciste todo el trabajo de un equipo de IA. ¡Ganaste la insignia “Ingeniero de IA”!',
        estrellas: estrellas);
    widget.onTerminar(estrellas);
    if (mounted) Navigator.of(context).maybePop();
  }

  // --- Reglas de cada paso -------------------------------------------------------

  /// Cuántos ejemplos de cada grupo se eligieron (según su etiqueta verdadera).
  List<int> get porGrupo => [for (var k = 0; k < proyecto.etiquetas.length; k++) datos.where((i) => proyecto.banco[i].etiqueta == k).length];

  String? get faltaDatos {
    if (datos.length < 6) return 'Elige al menos 6 ejemplos.';
    final g = porGrupo;
    for (var k = 0; k < g.length; k++) {
      if (g[k] < 2) return 'Faltan ejemplos de “${proyecto.etiquetas[k].nombre}”: elige al menos 2.';
    }
    return null;
  }

  bool get puedeAvanzar => switch (paso) {
        0 => proyectoElegido != null,
        1 => faltaDatos == null,
        2 => datos.every(etiquetas.containsKey),
        3 => rasgos.isNotEmpty,
        4 => modelo != null,
        _ => false,
      };

  /// Pistas cuando la IA no alcanza el 80 %.
  List<String> get pistas {
    final p = <String>[];
    final malas = datos.where((i) => etiquetas[i] != proyecto.banco[i].etiqueta).length;
    if (malas > 0) p.add('🏷️ Hay $malas ${malas == 1 ? 'etiqueta equivocada' : 'etiquetas equivocadas'} en tus datos.');
    final inutiles = proyecto.rasgos.where((r) => rasgos.contains(r.id) && !r.util).map((r) => r.nombre.toLowerCase());
    final utiles = proyecto.rasgos.where((r) => r.util && rasgos.contains(r.id));
    if (utiles.isEmpty) {
      p.add('🔍 Los rasgos que elegiste no ayudan a distinguir los grupos.');
    } else if (inutiles.isNotEmpty) {
      p.add('🔍 Quizá “${inutiles.join('” y “')}” confunde a tu IA.');
    }
    if (datos.length < proyecto.banco.length * 0.75) p.add('🗂️ Con más datos variados tu IA aprende mejor.');
    return p;
  }

  // --- Interfaz ----------------------------------------------------------------

  String get mensaje => switch (paso) {
        0 => 'Bienvenido al laboratorio. Hoy serás ingeniero de IA. Primero elige el problema que tu inteligencia artificial va a resolver.',
        1 =>
          '${proyecto.descripcion} Paso 2: reúne datos. Toca los ejemplos que usará tu IA para aprender. ${faltaDatos ?? '¡Bien! Más datos y más variados = una IA más lista.'}',
        2 => 'Paso 3: etiqueta. Toca cada ejemplo y dile a la IA a qué grupo pertenece. Si te equivocas, ¡la IA aprenderá mal!',
        3 =>
          'Paso 4: elige los rasgos. ¿En qué características debe fijarse tu IA? Elige las que de verdad ayudan a distinguir: ${proyecto.etiquetas.map((e) => e.nombre).join(', ')}.',
        4 => entrenando
            ? 'Entrenando… La red compara los ejemplos y ajusta sus conexiones.'
            : modelo == null
                ? 'Paso 5: entrena. Presiona “Entrenar” para que la IA busque los patrones en tus datos.'
                : 'Entrenamiento listo. Con sus propios datos acierta el ${((modelo!.precisionEntrenamiento()) * 100).round()} %. Ahora pruébala con datos que nunca ha visto.',
        _ => precision >= 0.8
            ? '¡Tu IA acierta el ${(precision * 100).round()} % con datos nuevos! Está lista para publicarse.'
            : 'Tu IA acierta el ${(precision * 100).round()} %. Necesita al menos 80 %. ${pistas.join(' ')}',
      };

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return Escenario(
      velo: 0.06,
      colorVelo: c,
      children: [
        encabezadoEle('Laboratorio', 'Construye tu IA', c),
        Positioned(left: 8, top: 60, width: 230, height: 230, child: GloboZatiEle(mensaje, tam: 12)),
        Positioned(left: 8, top: 296, width: 230, height: 176, child: _resumen(c)),
        Positioned(
          left: 244,
          top: 56,
          width: 608,
          height: 34,
          child: Row(children: [
            for (var k = 0; k < pasosLaboratorio.length; k++) ...[
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: k == paso ? c : (k < paso ? c.withValues(alpha: 0.35) : Colors.white.withValues(alpha: 0.85)),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: c, width: 2),
                  ),
                  child: FittedBox(
                    child: Text(' ${pasosLaboratorio[k].$1} ${k + 1}. ${pasosLaboratorio[k].$2} ',
                        style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800, color: k == paso ? Colors.white : oscurecer(c, 0.2))),
                  ),
                ),
              ),
              if (k < pasosLaboratorio.length - 1) const SizedBox(width: 3),
            ],
          ]),
        ),
        Positioned(left: 244, top: 96, width: 608, height: 316, child: _contenido(c)),
        if (paso > 0)
          Positioned(
            left: 244,
            top: 420,
            child: Tooltip(
                message: 'Paso anterior',
                child: BotonJuego(texto: 'Atrás', icono: Icons.arrow_back_rounded, color: const Color(0xFF757575), onTap: () => irA(paso - 1))),
          ),
        if (paso >= 1 && paso <= 4)
          Positioned(
            left: 640,
            top: 420,
            child: Tooltip(
              message: 'Siguiente paso',
              child: BotonJuego(
                  texto: 'Siguiente paso',
                  icono: Icons.arrow_forward_rounded,
                  color: puedeAvanzar ? c : Colors.grey,
                  onTap: puedeAvanzar ? () => irA(paso + 1) : null),
            ),
          ),
        if (paso == 4)
          Positioned(
            left: 420,
            top: 420,
            child: Tooltip(
                message: 'Entrenar',
                child: BotonJuego(texto: modelo == null ? 'Entrenar' : 'Otra vez', icono: Icons.model_training_rounded, color: c, onTap: entrenar)),
          ),
        if (paso == 5 && precision >= 0.8) Positioned(left: 640, top: 420, child: BotonSiguiente(texto: 'Publicar IA', onTap: publicar)),
        if (paso == 5 && precision < 0.8)
          Positioned(
            left: 370,
            top: 420,
            child: Row(children: [
              Tooltip(message: 'Revisar datos', child: BotonJuego(texto: 'Datos', icono: Icons.dataset_rounded, color: c, onTap: () => irA(1))),
              const SizedBox(width: 6),
              Tooltip(message: 'Revisar etiquetas', child: BotonJuego(texto: 'Etiquetas', icono: Icons.sell_rounded, color: c, onTap: () => irA(2))),
              const SizedBox(width: 6),
              Tooltip(message: 'Cambiar rasgos', child: BotonJuego(texto: 'Rasgos', icono: Icons.search_rounded, color: c, onTap: () => irA(3))),
            ]),
          ),
        const BotonVolverEscena(),
      ],
    );
  }

  Widget _resumen(Color c) => PanelEle(
        titulo: 'Tu IA',
        icono: Icons.memory_rounded,
        color: c,
        child: proyectoElegido == null
            ? const Center(child: Text('Todavía no eliges un problema.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5)))
            : DefaultTextStyle(
                style: const TextStyle(fontSize: 12.5, color: ColoresJuego.texto, fontWeight: FontWeight.w600, height: 1.35),
                child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('${proyecto.emoji} ${proyecto.titulo}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text('🗂️ Datos: ${datos.length}'),
                    Text('🏷️ Etiquetados: ${datos.where(etiquetas.containsKey).length}'),
                    Text('🔍 Rasgos: ${rasgos.isEmpty ? '—' : proyecto.rasgos.where((r) => rasgos.contains(r.id)).map((r) => r.emoji).join(' ')}'),
                    Text('🎯 Aciertos: ${modelo == null ? '—' : '${(precision * 100).round()} %'}'),
                  ]),
                ),
              ),
      );

  Widget _contenido(Color c) {
    final p = proyecto;
    switch (paso) {
      case 0:
        return Row(children: [
          for (var i = 0; i < proyectosLaboratorio.length; i++)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Tooltip(
                  message: 'Proyecto ${proyectosLaboratorio[i].titulo}',
                  child: GestureDetector(
                    onTap: () => elegirProyecto(i),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: c, width: 3),
                        boxShadow: const [BoxShadow(color: Color(0x44000000), blurRadius: 6, offset: Offset(0, 3))],
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(proyectosLaboratorio[i].emoji, style: const TextStyle(fontSize: 52)),
                        const SizedBox(height: 6),
                        Text(proyectosLaboratorio[i].titulo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 6),
                        Text(proyectosLaboratorio[i].descripcion, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12.5, height: 1.2)),
                        const SizedBox(height: 8),
                        Text(proyectosLaboratorio[i].etiquetas.map((e) => e.emoji).join('  '), style: const TextStyle(fontSize: 22)),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
        ]);
      case 1:
        return PanelEle(
          titulo: 'Banco de datos · elegidos: ${datos.length} de ${p.banco.length}',
          icono: Icons.dataset_rounded,
          color: c,
          child: Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(spacing: 6, runSpacing: 6, children: [
                  for (var i = 0; i < p.banco.length; i++)
                    Tooltip(
                      message: 'Usar ${p.banco[i].nombre}',
                      child: Opacity(
                        opacity: usados.contains(i) ? 1 : 0.55,
                        child: TarjetaEjemplo(ejemplo: p.banco[i], color: usados.contains(i) ? c : Colors.grey, ancho: 90, marca: null, onTap: () => usar(i)),
                      ),
                    ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Tooltip(message: 'Usar todos', child: ChipEle(texto: '✅ Usar todos', activo: false, color: c, onTap: usarTodos)),
            ),
          ]),
        );
      case 2:
        return Column(children: [
          Expanded(
            child: PanelEle(
              titulo: 'Etiqueta tus datos',
              icono: Icons.sell_rounded,
              color: c,
              child: SingleChildScrollView(
                child: Wrap(spacing: 6, runSpacing: 6, children: [
                  for (final i in datos)
                    Tooltip(
                      message: 'Ejemplo ${p.banco[i].nombre}',
                      child: TarjetaEjemplo(
                          ejemplo: p.banco[i], etiqueta: etiquetas[i] == null ? null : p.etiquetas[etiquetas[i]!], color: c, ancho: 90, onTap: () => elegir(i)),
                    ),
                ]),
              ),
            ),
          ),
          if (elegido != null)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: c, width: 2.5)),
              child: Row(children: [
                Text('${p.banco[elegido!].emoji} ${p.banco[elegido!].nombre}:', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                const Spacer(),
                for (var k = 0; k < p.etiquetas.length; k++)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Tooltip(
                      message: '${p.banco[elegido!].nombre}: ${p.etiquetas[k].nombre}',
                      child: ChipEle(
                          texto: '${p.etiquetas[k].emoji} ${p.etiquetas[k].nombre}',
                          activo: true,
                          color: p.etiquetas[k].color,
                          onTap: () => etiquetar(elegido!, k)),
                    ),
                  ),
              ]),
            ),
        ]);
      case 3:
        return PanelEle(
          titulo: '¿En qué se fija tu IA?',
          icono: Icons.search_rounded,
          color: c,
          child: Column(children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2.4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: [
                  for (final r in p.rasgos)
                    Tooltip(
                      message: 'Rasgo ${r.nombre}',
                      child: GestureDetector(
                        onTap: () => alternarRasgo(r.id),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: rasgos.contains(r.id) ? c : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: c, width: 2.5),
                          ),
                          child: Text('${r.emoji} ${r.nombre}${rasgos.contains(r.id) ? ' ✔️' : ''}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: rasgos.contains(r.id) ? Colors.white : ColoresJuego.texto)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Text(
                'Ejemplo: ${p.banco.first.emoji} ${p.banco.first.nombre} → ${p.rasgos.map((r) => '${r.nombre.toLowerCase()}: ${p.banco.first.rasgos[r.id]}').join(' · ')}',
                style: const TextStyle(fontSize: 11.5)),
          ]),
        );
      case 4:
        return Container(
          decoration: BoxDecoration(color: const Color(0xEE0B1020), borderRadius: BorderRadius.circular(18), border: Border.all(color: c, width: 2.5)),
          child: Column(children: [
            Expanded(
                child: Reloj(
                    builder: (_, t) =>
                        CustomPaint(painter: _PintorRed(t, entrenando ? progreso : (modelo == null ? 0 : 1), rasgos.length), size: Size.infinite))),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
              child: Row(children: [
                Text(entrenando ? 'Época ${(progreso * 25).ceil()} de 25' : (modelo == null ? 'Lista para entrenar' : '✔️ Entrenada'),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                const SizedBox(width: 10),
                Expanded(
                    child: LinearProgressIndicator(value: entrenando ? progreso : (modelo == null ? 0 : 1), minHeight: 12, color: const Color(0xFF69F0AE))),
              ]),
            ),
          ]),
        );
      default:
        return PanelEle(
          titulo: 'Prueba con datos nuevos · ${(precision * 100).round()} % de aciertos',
          icono: Icons.science_rounded,
          color: c,
          child: SingleChildScrollView(
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              for (final x in p.prueba)
                () {
                  final pr = modelo!.predecir(x);
                  return Container(
                    width: 186,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (pr.etiqueta == x.etiqueta ? ColoresJuego.correcto : const Color(0xFFE53935)).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: pr.etiqueta == x.etiqueta ? ColoresJuego.correcto : const Color(0xFFE53935), width: 2),
                    ),
                    child: Row(children: [
                      Text(x.emoji, style: const TextStyle(fontSize: 30)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(x.nombre, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800)),
                          Text(pr.etiqueta < 0 ? '🤔 No sé' : 'IA: ${p.etiquetas[pr.etiqueta].emoji} ${p.etiquetas[pr.etiqueta].nombre}',
                              style: const TextStyle(fontSize: 11.5)),
                          Text('Seguridad: ${(pr.confianza * 100).round()} % ${pr.etiqueta == x.etiqueta ? '✔️' : '❌'}', style: const TextStyle(fontSize: 11)),
                        ]),
                      ),
                    ]),
                  );
                }(),
            ]),
          ),
        );
    }
  }
}

/// Red neuronal que se “enciende” al entrenar.
class _PintorRed extends CustomPainter {
  _PintorRed(this.t, this.avance, this.entradas);
  final double t, avance;
  final int entradas;
  @override
  void paint(Canvas c, Size s) {
    final capas = [math.max(1, entradas), 5, 4, 2];
    final pos = <List<Offset>>[
      for (var i = 0; i < capas.length; i++)
        [for (var j = 0; j < capas[i]; j++) Offset(s.width * (0.12 + 0.76 * i / (capas.length - 1)), s.height * (j + 1) / (capas[i] + 1))]
    ];
    final rnd = math.Random(3);
    for (var i = 0; i < capas.length - 1; i++) {
      for (final a in pos[i]) {
        for (final b in pos[i + 1]) {
          final w = rnd.nextDouble();
          final fuerza = (avance * (0.3 + w)).clamp(0.0, 1.0);
          c.drawLine(
              a,
              b,
              Paint()
                ..color = Color.lerp(const Color(0x33FFFFFF), w > 0.5 ? const Color(0xFF69F0AE) : const Color(0xFFFF80AB), fuerza)!
                ..strokeWidth = 1 + fuerza * 2.5);
        }
      }
    }
    if (avance > 0 && avance < 1) {
      for (var k = 0; k < 8; k++) {
        final f = (t * 0.8 + k / 8) % 1;
        final capa = (f * (capas.length - 1)).floor();
        final fr = f * (capas.length - 1) - capa;
        final a = pos[capa][k % capas[capa]], b = pos[capa + 1][(k * 3) % capas[capa + 1]];
        c.drawCircle(Offset.lerp(a, b, fr)!, 4, Paint()..color = const Color(0xFFFFF176));
      }
    }
    for (var i = 0; i < capas.length; i++) {
      for (final p in pos[i]) {
        c.drawCircle(p, 11, Paint()..color = Color.lerp(const Color(0xFF4A148C), const Color(0xFFCE93D8), avance)!);
        c.drawCircle(
            p,
            11,
            Paint()
              ..color = Colors.white70
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2);
      }
    }
    final tp = TextPainter(
        text: const TextSpan(
            text: 'rasgos  →  neuronas  →  neuronas  →  respuesta', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
        textDirection: TextDirection.ltr)
      ..layout();
    tp.paint(c, Offset((s.width - tp.width) / 2, s.height - tp.height - 2));
  }

  @override
  bool shouldRepaint(_PintorRed old) => true;
}
