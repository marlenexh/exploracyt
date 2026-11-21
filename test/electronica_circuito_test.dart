import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/electronica/circuito.dart';

EstadoCircuito _sim(List<Pieza> ps, List<(String, String)> cs, {double luz = 1}) {
  final cables = [for (final (a, b) in cs) Cable(a, b)];
  return EstadoCircuito({for (final p in ps) p.id: p}, cables, resolverCircuito(ps, cables, luz: luz), luz: luz);
}

void main() {
  Pieza pila() => Pieza('p', TipoPieza.pila9v, Offset.zero);
  Pieza led([String id = 'l']) => Pieza(id, TipoPieza.led, Offset.zero);
  Pieza res([String id = 'r', double o = 220]) => Pieza(id, TipoPieza.resistencia, Offset.zero, ohms: o);

  test('LED con resistencia de 220 Ω enciende sin quemarse', () {
    final e = _sim([pila(), res(), led()], [('p.0', 'r.0'), ('r.1', 'l.0'), ('l.1', 'p.1')]);
    expect(e.corriente('l'), closeTo((9 - 1.8) / 231, 0.002));
    expect(e.encendido('l'), isTrue);
    expect(e.quemado('l'), isFalse);
  });

  test('LED sin resistencia se quema', () {
    final e = _sim([pila(), led()], [('p.0', 'l.0'), ('l.1', 'p.1')]);
    expect(e.quemado('l'), isTrue);
    expect(e.encendido('l'), isFalse);
  });

  test('LED al revés no enciende', () {
    final e = _sim([pila(), res(), led()], [('p.0', 'r.0'), ('r.1', 'l.1'), ('l.0', 'p.1')]);
    expect(e.encendido('l'), isFalse);
    expect(e.invertido('l'), isTrue);
  });

  test('Interruptor abierto apaga el LED', () {
    final s = Pieza('s', TipoPieza.interruptor, Offset.zero);
    final ps = [pila(), res(), led(), s];
    final cs = [('p.0', 's.0'), ('s.1', 'r.0'), ('r.1', 'l.0'), ('l.1', 'p.1')];
    expect(_sim(ps, cs).encendido('l'), isFalse);
    s.cerrado = true;
    expect(_sim(ps, cs).encendido('l'), isTrue);
  });

  test('Dos LED en serie y en paralelo', () {
    final serie = _sim([pila(), res(), led('a'), led('b')], [('p.0', 'r.0'), ('r.1', 'a.0'), ('a.1', 'b.0'), ('b.1', 'p.1')]);
    expect(serie.encendido('a') && serie.encendido('b'), isTrue);
    expect(serie.corriente('a'), closeTo(serie.corriente('b'), 1e-4));
    final par = _sim([pila(), res('r1'), res('r2'), led('a'), led('b')],
        [('p.0', 'r1.0'), ('p.0', 'r2.0'), ('r1.1', 'a.0'), ('r2.1', 'b.0'), ('a.1', 'p.1'), ('b.1', 'p.1')]);
    expect(par.encendido('a') && par.encendido('b'), isTrue);
  });

  test('Cortocircuito y LED desconectado', () {
    expect(_sim([pila()], [('p.0', 'p.1')]).cortocircuito, isTrue);
    expect(_sim([pila(), res(), led()], [('p.0', 'r.0'), ('r.1', 'l.0')]).encendido('l'), isFalse);
  });

  test('El motor cambia de sentido al invertir la pila', () {
    final m = Pieza('m', TipoPieza.motor, Offset.zero);
    final a = _sim([pila(), m], [('p.0', 'm.0'), ('m.1', 'p.1')]);
    final b = _sim([pila(), m], [('p.0', 'm.1'), ('m.0', 'p.1')]);
    expect(a.gira('m') && b.gira('m'), isTrue);
    expect(a.velocidad('m').sign, -b.velocidad('m').sign);
  });

  test('La fotorresistencia deja pasar menos corriente a oscuras', () {
    final ps = [pila(), Pieza('f', TipoPieza.ldr, Offset.zero), res(), led()];
    final cs = [('p.0', 'f.0'), ('f.1', 'r.0'), ('r.1', 'l.0'), ('l.1', 'p.1')];
    expect(_sim(ps, cs, luz: 1).encendido('l'), isTrue);
    expect(_sim(ps, cs, luz: 0).encendido('l'), isFalse);
  });
}
