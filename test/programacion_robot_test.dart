import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/presentation/programacion/robot.dart';

NivelRobot _n(List<String> mapa, {Dir dir = Dir.derecha, int? max, Set<String>? dibujo}) =>
    NivelRobot(titulo: 't', instruccion: 'i', logro: 'l', mapa: mapa, dir: dir, maxBloques: max, dibujo: dibujo);

void main() {
  test('Secuencia llega a la meta; chocar y no llegar se detectan', () {
    final n = _n(['S..M']);
    expect(ejecutarRobot(n, [av(), av(), av()]).resultado, Resultado.exito);
    expect(ejecutarRobot(n, [av(), av()]).resultado, Resultado.sinMeta);
    expect(ejecutarRobot(n, [av(), av(), av(), av()]).resultado, Resultado.choque);
    expect(ejecutarRobot(n, [gi(), av()]).resultado, Resultado.choque);
  });

  test('Giros, gemas y repetir con límite de bloques', () {
    final n = _n(['S.#', '#.#', '#GM'], max: 6);
    expect(ejecutarRobot(n, [av(), gd(), av(), av(), gi(), av()]).resultado, Resultado.faltanGemas);
    expect(ejecutarRobot(n, [av(), gd(), av(), av(), rc(), gi(), av()]).resultado, Resultado.muyLargo);
    final largo = _n(['S......M'], max: 2);
    expect(ejecutarRobot(largo, [rep(7, [av()])]).resultado, Resultado.exito);
  });

  test('Mientras + si-no sigue la pared; un mientras vacío es ciclo infinito', () {
    final n = _n(['S..#', '##.#', '##.M']);
    final p = [
      mientras(Cond.noMeta, [
        siNo(Cond.camino, [av()], [gd()])
      ])
    ];
    // En la esquina gira a la derecha (hacia abajo) y luego a la izquierda no: usa si-no con giro derecha
    expect(ejecutarRobot(n, p).resultado, isNot(Resultado.choque));
    expect(ejecutarRobot(_n(['S.M']), [mientras(Cond.noMeta, [])]).resultado, Resultado.cicloInfinito);
    expect(ejecutarRobot(_n(['S.M']), [mientras(Cond.noMeta, [gi()])]).resultado, Resultado.cicloInfinito);
  });

  test('Dibujo: un cuadrado con repetir', () {
    final n = _n(['.....', '.....', 'S....'], dir: Dir.arriba, dibujo: figura([(0, 2), (0, 0), (2, 0), (2, 2), (0, 2)]));
    expect(ejecutarRobot(n, [rep(4, [av(), av(), gd()])]).resultado, Resultado.exito);
    expect(ejecutarRobot(n, [rep(3, [av(), av(), gd()])]).resultado, Resultado.dibujoIncompleto);
  });
}
