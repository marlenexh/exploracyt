import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

import 'base.dart';

/// IA · “Etiqueta para entrenar”: por la banda pasan objetos. Cuando llegan al
/// escáner, etiquétalos como “Fruta” o “No es fruta”. Al final la IA aprende de
/// tus etiquetas y se pone a prueba sola: ¡si etiquetaste mal, aprende mal!
const objetosEtiqueta = [
  ('🍎', true),
  ('🧦', false),
  ('🍌', true),
  ('⚽', false),
  ('🍇', true),
  ('🔧', false),
  ('🍓', true),
  ('📱', false),
  ('🍍', true),
  ('🧸', false),
  ('🍉', true),
  ('✏️', false),
  ('🥝', true),
  ('👟', false),
  ('🍒', true),
  ('🔑', false),
  ('🍐', true),
  ('🎈', false),
  ('🍋', true),
  ('📚', false),
];

/// Objetos nuevos que la IA no ha visto (para la prueba final).
const pruebaIA = [('🥭', true), ('🧢', false), ('🍑', true), ('🎸', false), ('🫐', true)];

class ObjetoBanda {
  ObjetoBanda(this.emoji, this.esFruta, this.x);
  final String emoji;
  final bool esFruta;
  double x;
  bool? etiqueta; // lo que dijo el alumno
}

class ModeloEtiquetas extends ModeloJuego {
  static const xEscaner = 330.0, yBanda = 205.0;
  final banda = <ObjetoBanda>[];
  int siguiente = 0, buenas = 0, malas = 0, perdidas = 0;
  double velocidad = 55, tiempo = 0;

  /// Fase de prueba de la IA: resultados (emoji, es fruta, la IA dijo).
  final prueba = <(String, bool, bool)>[];
  double _tPrueba = 0;
  bool probando = false;

  int get total => objetosEtiqueta.length;

  /// Qué tan bien quedó entrenada la IA (0 a 1) según las etiquetas correctas.
  double get calidad => (buenas) / math.max(1, buenas + malas + perdidas);

  @override
  void reiniciar() {
    banda.clear();
    siguiente = buenas = malas = perdidas = 0;
    velocidad = 55;
    tiempo = 0;
    prueba.clear();
    probando = false;
    _tPrueba = 0;
  }

  ObjetoBanda? get enEscaner {
    for (final o in banda) {
      if (o.etiqueta == null && (o.x - xEscaner).abs() < 46) return o;
    }
    return null;
  }

  void etiquetar(bool fruta) {
    if (!jugando || probando) return;
    final o = enEscaner;
    if (o == null) {
      efecto(const Offset(xEscaner, yBanda - 70), const Color(0xFF9E9E9E), 'Espera a que llegue al escáner');
      return;
    }
    o.etiqueta = fruta;
    if (fruta == o.esFruta) {
      buenas++;
      puntos++;
      efecto(Offset(o.x, yBanda - 30), const Color(0xFF66BB6A), '✔ dato bueno');
    } else {
      malas++;
      errores++;
      efecto(Offset(o.x, yBanda - 30), const Color(0xFFE53935), '✘ dato mal etiquetado');
    }
    notifyListeners();
  }

  @override
  void paso(double dt) {
    tiempo += dt;
    if (probando) {
      _tPrueba += dt;
      if (_tPrueba > 0.9 && prueba.length < pruebaIA.length) {
        _tPrueba = 0;
        final (e, fruta) = pruebaIA[prueba.length];
        // La IA acierta según qué tan bien se entrenó
        final acierta = azar.nextDouble() < 0.35 + 0.65 * calidad;
        prueba.add((e, fruta, acierta ? fruta : !fruta));
        notifyListeners();
      } else if (prueba.length == pruebaIA.length && _tPrueba > 1.2) {
        terminar(calidad >= 0.7);
      }
      return;
    }
    // Llegan objetos nuevos a la banda
    if (siguiente < total && (banda.isEmpty || banda.last.x > 130)) {
      final (e, f) = objetosEtiqueta[siguiente++];
      banda.add(ObjetoBanda(e, f, -30));
    }
    for (final o in [...banda]) {
      o.x += velocidad * dt;
      if (o.x > xEscaner + 46 && o.etiqueta == null) {
        o.etiqueta = !o.esFruta; // se fue sin etiqueta: cuenta como dato perdido
        perdidas++;
        errores++;
        efecto(Offset(o.x, yBanda - 30), const Color(0xFFFFA000), '¡Se fue sin etiqueta!');
        notifyListeners();
      }
      if (o.x > anchoJuego + 30) banda.remove(o);
    }
    velocidad = 55 + siguiente * 1.8;
    if (siguiente >= total && banda.isEmpty) {
      probando = true;
      notifyListeners();
    }
  }

  @override
  int get estrellas => calidad >= 0.95 ? 3 : (calidad >= 0.8 ? 2 : 1);

  @override
  String get marcador => probando
      ? '🤖 Prueba de la IA: ${prueba.where((p) => p.$2 == p.$3).length}/${prueba.length} aciertos\n📊 Calidad de tus datos: ${(calidad * 100).round()}%'
      : '🏷️ Objetos: ${math.min(siguiente, total)}/$total\n✔ Datos buenos: $buenas\n✘ Mal etiquetados: ${malas + perdidas}';

  @override
  String get mensaje {
    if (terminado) {
      return gano
          ? '¡Tu IA aprendió bien! Con datos bien etiquetados la IA acierta. Así se entrenan las IA de verdad.'
          : 'La IA se equivocó mucho porque aprendió de datos mal etiquetados. ¡Una IA es tan buena como sus datos!';
    }
    if (probando) return '🤖 Ahora la IA intenta reconocer frutas que nunca vio, usando lo que aprendió de TUS etiquetas…';
    if (!jugando) return 'Eres quien entrena a la IA. Cuando cada objeto llegue al escáner 🔍, toca “🍎 Fruta” o “❌ No es fruta”.';
    return 'Etiqueta bien cada objeto: la IA aprenderá exactamente lo que tú le enseñes.';
  }
}

List<Component> capasEtiquetas(ModeloEtiquetas m) => [
      CapaJuego((c) {
        const y = ModeloEtiquetas.yBanda;
        // Banda transportadora
        c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-10, y + 22, anchoJuego + 20, 26), const Radius.circular(13)),
            Paint()..color = const Color(0xFF455A64));
        for (var k = 0; k < 22; k++) {
          final x = (k * 30 + m.tiempo * m.velocidad) % (anchoJuego + 30) - 15;
          c.drawLine(
              Offset(x, y + 26),
              Offset(x - 8, y + 44),
              Paint()
                ..color = const Color(0xFF90A4AE)
                ..strokeWidth = 3);
        }
        // Escáner
        const xe = ModeloEtiquetas.xEscaner;
        c.drawRect(const Rect.fromLTWH(xe - 46, y - 60, 92, 82), Paint()..color = Color.fromRGBO(0, 229, 255, 0.12 + 0.08 * math.sin(m.tiempo * 6)));
        c.drawRect(
            const Rect.fromLTWH(xe - 46, y - 60, 92, 82),
            Paint()
              ..color = const Color(0xFF00E5FF)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3);
        textoJuego(c, '🔍 Escáner', const Offset(xe, y - 74), tam: 12, fondo: const Color(0xCC006064));
        // Robot que aprende
        emojiEn(c, '🤖', const Offset(540, 80), 46);
        textoJuego(c, 'Aprendiendo…', const Offset(540, 120), tam: 11, fondo: const Color(0x99000000));
        // Prueba final
        if (m.probando) {
          c.drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(60, 40, 490, 120), const Radius.circular(16)), Paint()..color = const Color(0xDD1A237E));
          textoJuego(c, '🧪 Prueba: ¿reconoce frutas nuevas?', const Offset(305, 60), tam: 14);
          for (var i = 0; i < m.prueba.length; i++) {
            final (e, fruta, dijo) = m.prueba[i];
            final p = Offset(120 + i * 90.0, 110);
            emojiEn(c, e, p, 32);
            textoJuego(c, '${dijo ? 'Fruta' : 'No'} ${dijo == fruta ? '✅' : '❌'}', p + const Offset(0, 30), tam: 11);
          }
        }
      }),
      CapaJuego((c) {
        for (final o in m.banda) {
          final p = Offset(o.x, ModeloEtiquetas.yBanda);
          emojiEn(c, o.emoji, p, 36);
          if (o.etiqueta != null) {
            textoJuego(c, o.etiqueta! ? '🍎' : '❌', p + const Offset(18, -22), tam: 12, fondo: Colors.white);
          }
        }
      }, priority: 5),
    ];
