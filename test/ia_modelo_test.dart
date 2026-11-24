import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/ia/modelo_ia.dart';
import 'package:explora_ciencia/presentation/ia/proyectos_ia.dart';

ModeloIA _bien(ProyectoIA p, Set<String> rasgos) => ModeloIA([for (final e in p.banco) (e, e.etiqueta)], rasgos);

void main() {
  test('Con rasgos útiles y etiquetas correctas, cada proyecto del laboratorio acierta 100 %', () {
    for (final p in proyectosLaboratorio) {
      final utiles = {
        for (final r in p.rasgos)
          if (r.util) r.id
      };
      expect(_bien(p, utiles).precision(p.prueba), 1.0, reason: p.titulo);
      expect(_bien(p, utiles).precisionEntrenamiento(), greaterThanOrEqualTo(0.8), reason: p.titulo);
    }
  });

  test('Con solo rasgos inútiles la IA falla más', () {
    for (final p in proyectosLaboratorio) {
      final inutiles = {
        for (final r in p.rasgos)
          if (!r.util) r.id
      };
      expect(_bien(p, inutiles).precision(p.prueba), lessThan(0.8), reason: p.titulo);
    }
  });

  test('Etiquetas equivocadas empeoran la IA', () {
    final p = proyectoBasura;
    final mal = ModeloIA([for (final e in p.banco) (e, 1 - e.etiqueta)], {'pudre'});
    expect(mal.precision(p.prueba), lessThan(0.5));
  });

  test('“Dónde vive” confunde al delfín y a la foca', () {
    final m = _bien(proyectoAnimales, {'vive'});
    final delfin = proyectoAnimales.prueba.firstWhere((e) => e.nombre == 'Delfín');
    expect(m.predecir(delfin).etiqueta, isNot(0));
  });

  test('El detector de manzanas tiene sesgo y se corrige con datos variados', () {
    final p = proyectoManzanas;
    final r = {for (final x in p.rasgos) x.id};
    final antes = _bien(p, r);
    final verde = p.prueba.first;
    expect(antes.predecir(verde).etiqueta, 1);
    expect(antes.precision(p.prueba), lessThan(0.8));
    final despues = ModeloIA([
      for (final e in [...p.banco, ...p.extra]) (e, e.etiqueta)
    ], r);
    expect(despues.predecir(verde).etiqueta, 0);
    expect(despues.precision(p.prueba), 1.0);
  });

  test('Mamífero o ave se aprende con pocos ejemplos', () {
    final p = proyectoMamiferoAve;
    expect(_bien(p, {for (final r in p.rasgos) r.id}).precision(p.prueba), 1.0);
  });

  test('Sin datos o sin rasgos la IA no sabe', () {
    expect(ModeloIA([], {'a'}).predecir(proyectoBasura.prueba.first).etiqueta, -1);
    expect(_bien(proyectoBasura, {}).predecir(proyectoBasura.prueba.first).etiqueta, -1);
  });
}
