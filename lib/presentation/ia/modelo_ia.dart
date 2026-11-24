import 'package:flutter/material.dart';

/// Motor sencillo de aprendizaje automático supervisado para los juegos de IA.
///
/// Cada ejemplo se describe con rasgos (características). El modelo compara un
/// ejemplo nuevo con los ejemplos de entrenamiento que se parecen más (los
/// vecinos más cercanos) y vota por la etiqueta más común entre ellos.

/// Una característica que la IA puede observar.
class Rasgo {
  const Rasgo(this.id, this.nombre, this.emoji, {this.util = true});
  final String id, nombre, emoji;

  /// Si ayuda a distinguir las clases (solo para dar pistas).
  final bool util;
}

/// Una clase o categoría que la IA debe aprender.
class EtiquetaIA {
  const EtiquetaIA(this.nombre, this.emoji, this.color);
  final String nombre, emoji;
  final Color color;
}

/// Un dato de ejemplo con sus rasgos y su etiqueta correcta.
class EjemploIA {
  const EjemploIA(this.emoji, this.nombre, this.rasgos, this.etiqueta);
  final String emoji, nombre;
  final Map<String, String> rasgos;
  final int etiqueta;
}

/// Un problema que se resuelve entrenando una IA.
class ProyectoIA {
  const ProyectoIA({
    required this.titulo,
    required this.emoji,
    required this.descripcion,
    required this.etiquetas,
    required this.rasgos,
    required this.banco,
    required this.prueba,
    this.extra = const [],
  });
  final String titulo, emoji, descripcion;
  final List<EtiquetaIA> etiquetas;
  final List<Rasgo> rasgos;

  /// Ejemplos disponibles para entrenar.
  final List<EjemploIA> banco;

  /// Ejemplos nuevos para probar la IA (no se usan al entrenar).
  final List<EjemploIA> prueba;

  /// Ejemplos variados que se pueden agregar para corregir un sesgo.
  final List<EjemploIA> extra;
}

/// Resultado de una predicción.
class Prediccion {
  const Prediccion(this.etiqueta, this.confianza);

  /// -1 si la IA no sabe (sin datos o sin rasgos).
  final int etiqueta;

  /// Entre 0 y 1.
  final double confianza;
}

/// Modelo de vecinos más cercanos sobre rasgos que se comparan por igualdad.
class ModeloIA {
  ModeloIA(this.datos, this.rasgos, {this.k = 3});

  /// Ejemplos de entrenamiento con la etiqueta que les puso el alumno.
  final List<(EjemploIA, int)> datos;

  /// Rasgos que la IA observa.
  final Set<String> rasgos;
  final int k;

  int parecido(EjemploIA a, EjemploIA b) {
    var n = 0;
    for (final r in rasgos) {
      if (a.rasgos[r] != null && a.rasgos[r] == b.rasgos[r]) n++;
    }
    return n;
  }

  Prediccion predecir(EjemploIA x, {EjemploIA? sin}) {
    final base = [
      for (final d in datos)
        if (!identical(d.$1, sin)) d
    ];
    if (base.isEmpty || rasgos.isEmpty) return const Prediccion(-1, 0);
    final orden = [for (var i = 0; i < base.length; i++) (i, parecido(x, base[i].$1))]..sort((a, b) => b.$2 != a.$2 ? b.$2 - a.$2 : a.$1 - b.$1);
    // Los k más parecidos, y también los que empatan con el último.
    // Si no se parece en nada a ningún ejemplo, la IA no sabe.
    if (orden.first.$2 == 0) return const Prediccion(-1, 0);
    // Los que no se parecen en nada no votan.
    final corte = [orden[(k - 1).clamp(0, orden.length - 1)].$2, 1].reduce((a, b) => a > b ? a : b);
    final vecinos = orden.where((e) => e.$2 >= corte).toList();
    final votos = <int, double>{};
    for (final (i, p) in vecinos) {
      // Los más parecidos pesan más; uno idéntico pesa mucho.
      votos[base[i].$2] = (votos[base[i].$2] ?? 0) + 1 + p;
    }
    final total = votos.values.fold<double>(0, (a, b) => a + b);
    final mejor = votos.entries.reduce((a, b) => b.value > a.value ? b : a);
    return Prediccion(mejor.key, mejor.value / total);
  }

  /// Porcentaje de aciertos con ejemplos nuevos (etiquetas verdaderas).
  double precision(List<EjemploIA> prueba) {
    if (prueba.isEmpty) return 0;
    var bien = 0;
    for (final x in prueba) {
      if (predecir(x).etiqueta == x.etiqueta) bien++;
    }
    return bien / prueba.length;
  }

  /// Aciertos con los propios datos, dejando fuera cada ejemplo una vez.
  double precisionEntrenamiento() {
    if (datos.length < 2) return 0;
    var bien = 0;
    for (final (x, e) in datos) {
      if (predecir(x, sin: x).etiqueta == e) bien++;
    }
    return bien / datos.length;
  }
}
