/// Modelo e intérprete del "Robot programable" de Programación: un robot en
/// una cuadrícula que sigue un programa de bloques (avanzar, girar, recoger,
/// repetir, si, si-no y mientras). También sirve para dibujar con código.

enum Dir {
  arriba(0, -1, '↑'),
  derecha(1, 0, '→'),
  abajo(0, 1, '↓'),
  izquierda(-1, 0, '←');

  const Dir(this.dx, this.dy, this.flecha);
  final int dx, dy;
  final String flecha;
  Dir get derechaDe => Dir.values[(index + 1) % 4];
  Dir get izquierdaDe => Dir.values[(index + 3) % 4];
}

enum TipoBloque {
  avanzar('avanzar', '⬆️'),
  izquierda('girar a la izquierda', '↺'),
  derecha('girar a la derecha', '↻'),
  recoger('recoger gema', '💎'),
  repetir('repetir', '🔁'),
  si('si', '❓'),
  siSino('si… si no', '🔀'),
  mientras('mientras', '🔄');

  const TipoBloque(this.nombre, this.emoji);
  final String nombre, emoji;
  bool get contenedor => index >= TipoBloque.repetir.index;
}

enum Cond {
  camino('hay camino adelante'),
  pared('hay pared adelante'),
  gema('hay una gema aquí'),
  noMeta('no he llegado a la meta');

  const Cond(this.texto);
  final String texto;
}

class Bloque {
  Bloque(this.tipo, {this.veces = 3, this.cond = Cond.camino, List<Bloque>? hijos, List<Bloque>? sino})
      : hijos = hijos ?? [],
        sino = sino ?? [],
        id = _siguiente++;
  static int _siguiente = 0;

  final int id;
  final TipoBloque tipo;
  int veces;
  Cond cond;
  final List<Bloque> hijos;
  final List<Bloque> sino;

  Bloque copia() => Bloque(tipo, veces: veces, cond: cond, hijos: [for (final b in hijos) b.copia()], sino: [for (final b in sino) b.copia()]);
}

// Atajos para escribir programas en el contenido y en las pruebas.
Bloque av() => Bloque(TipoBloque.avanzar);
Bloque gi() => Bloque(TipoBloque.izquierda);
Bloque gd() => Bloque(TipoBloque.derecha);
Bloque rc() => Bloque(TipoBloque.recoger);
Bloque rep(int n, List<Bloque> h) => Bloque(TipoBloque.repetir, veces: n, hijos: h);
Bloque si(Cond c, List<Bloque> h) => Bloque(TipoBloque.si, cond: c, hijos: h);
Bloque siNo(Cond c, List<Bloque> h, List<Bloque> s) => Bloque(TipoBloque.siSino, cond: c, hijos: h, sino: s);
Bloque mientras(Cond c, List<Bloque> h) => Bloque(TipoBloque.mientras, cond: c, hijos: h);

int contarBloques(List<Bloque> p) => p.fold(0, (a, b) => a + 1 + contarBloques(b.hijos) + contarBloques(b.sino));

/// Nivel del robot.
///
/// Mapa: `#` pared, `.` camino, `S` salida, `M` meta, `G` gema.
class NivelRobot {
  const NivelRobot({
    required this.titulo,
    required this.instruccion,
    required this.mapa,
    required this.logro,
    this.dir = Dir.derecha,
    this.bloques = const {TipoBloque.avanzar, TipoBloque.izquierda, TipoBloque.derecha},
    this.condiciones = const [Cond.camino, Cond.pared],
    this.maxBloques,
    this.inicial,
    this.dibujo,
    this.pista,
  });
  final String titulo, instruccion, logro;
  final List<String> mapa;
  final Dir dir;
  final Set<TipoBloque> bloques;
  final List<Cond> condiciones;

  /// Si se indica, el programa debe usar como máximo estos bloques.
  final int? maxBloques;

  /// Programa con errores para depurar.
  final List<Bloque> Function()? inicial;

  /// Modo dibujo: segmentos que hay que trazar (ver [segmento]).
  final Set<String>? dibujo;
  final String? pista;

  /// Copia del nivel con la salida en (x, y) (útil en los dibujos).
  NivelRobot conInicio(int x, int y) => NivelRobot(
        titulo: titulo,
        instruccion: instruccion,
        logro: logro,
        mapa: [for (var f = 0; f < mapa.length; f++) f == y ? mapa[f].replaceRange(x, x + 1, 'S') : mapa[f].replaceAll('S', '.')],
        dir: dir,
        bloques: bloques,
        condiciones: condiciones,
        maxBloques: maxBloques,
        inicial: inicial,
        dibujo: dibujo,
        pista: pista,
      );

  int get columnas => mapa.first.length;
  int get filas => mapa.length;
  String celda(int x, int y) => (x < 0 || y < 0 || y >= filas || x >= columnas) ? '#' : mapa[y][x];
  (int, int) get inicio {
    for (var y = 0; y < filas; y++) {
      final x = mapa[y].indexOf('S');
      if (x >= 0) return (x, y);
    }
    return (0, 0);
  }

  Set<(int, int)> get gemas => {
        for (var y = 0; y < filas; y++)
          for (var x = 0; x < columnas; x++)
            if (mapa[y][x] == 'G') (x, y),
      };
}

/// Segmento entre dos puntos de la cuadrícula, sin importar la dirección.
String segmento(int x1, int y1, int x2, int y2) => (x1 < x2 || (x1 == x2 && y1 < y2)) ? '$x1,$y1-$x2,$y2' : '$x2,$y2-$x1,$y1';

/// Crea los segmentos de una figura a partir de los puntos de su contorno.
Set<String> figura(List<(int, int)> puntos) {
  final s = <String>{};
  for (var i = 0; i < puntos.length - 1; i++) {
    final (x1, y1) = puntos[i];
    final (x2, y2) = puntos[i + 1];
    final pasos = (x2 - x1).abs() + (y2 - y1).abs();
    final dx = (x2 - x1).sign, dy = (y2 - y1).sign;
    for (var k = 0; k < pasos; k++) {
      s.add(segmento(x1 + dx * k, y1 + dy * k, x1 + dx * (k + 1), y1 + dy * (k + 1)));
    }
  }
  return s;
}

enum Evento { inicio, mover, girar, recoger, nada, choque, ciclo }

class PasoRobot {
  const PasoRobot(this.bloque, this.x, this.y, this.dir, this.gemas, this.trazo, this.evento);
  final int? bloque;
  final int x, y;
  final Dir dir;
  final Set<(int, int)> gemas;
  final Set<String> trazo;
  final Evento evento;
}

enum Resultado { exito, choque, sinMeta, faltanGemas, cicloInfinito, dibujoIncompleto, muyLargo }

class Ejecucion {
  Ejecucion(this.pasos, this.resultado);
  final List<PasoRobot> pasos;
  final Resultado resultado;
  PasoRobot get fin => pasos.last;
}

const _maxPasos = 400;

Ejecucion ejecutarRobot(NivelRobot nivel, List<Bloque> programa) {
  var (x, y) = nivel.inicio;
  var d = nivel.dir;
  final gemas = <(int, int)>{};
  final trazo = <String>{};
  final pasos = <PasoRobot>[PasoRobot(null, x, y, d, const {}, const {}, Evento.inicio)];
  var parar = false;
  Evento? fallo;

  void paso(int id, Evento e) => pasos.add(PasoRobot(id, x, y, d, {...gemas}, {...trazo}, e));

  bool libre(int nx, int ny) => nivel.dibujo != null ? (nx >= 0 && ny >= 0 && nx < nivel.columnas && ny < nivel.filas) : nivel.celda(nx, ny) != '#';

  bool evaluar(Cond c) => switch (c) {
        Cond.camino => libre(x + d.dx, y + d.dy),
        Cond.pared => !libre(x + d.dx, y + d.dy),
        Cond.gema => nivel.celda(x, y) == 'G' && !gemas.contains((x, y)),
        Cond.noMeta => nivel.celda(x, y) != 'M',
      };

  void correr(List<Bloque> lista) {
    for (final b in lista) {
      if (parar) return;
      if (pasos.length > _maxPasos) {
        parar = true;
        fallo = Evento.ciclo;
        return;
      }
      switch (b.tipo) {
        case TipoBloque.avanzar:
          final nx = x + d.dx, ny = y + d.dy;
          if (!libre(nx, ny)) {
            paso(b.id, Evento.choque);
            parar = true;
            fallo = Evento.choque;
            return;
          }
          if (nivel.dibujo != null) trazo.add(segmento(x, y, nx, ny));
          x = nx;
          y = ny;
          paso(b.id, Evento.mover);
        case TipoBloque.izquierda:
          d = d.izquierdaDe;
          paso(b.id, Evento.girar);
        case TipoBloque.derecha:
          d = d.derechaDe;
          paso(b.id, Evento.girar);
        case TipoBloque.recoger:
          if (nivel.celda(x, y) == 'G' && gemas.add((x, y))) {
            paso(b.id, Evento.recoger);
          } else {
            paso(b.id, Evento.nada);
          }
        case TipoBloque.repetir:
          for (var k = 0; k < b.veces && !parar; k++) {
            correr(b.hijos);
          }
        case TipoBloque.si:
          if (evaluar(b.cond)) correr(b.hijos);
        case TipoBloque.siSino:
          correr(evaluar(b.cond) ? b.hijos : b.sino);
        case TipoBloque.mientras:
          var vueltas = 0;
          while (!parar && evaluar(b.cond)) {
            final antes = pasos.length;
            correr(b.hijos);
            vueltas++;
            // Un ciclo que no hace nada nunca termina.
            if (pasos.length == antes || vueltas > _maxPasos || pasos.length > _maxPasos) {
              parar = true;
              fallo = Evento.ciclo;
              paso(b.id, Evento.ciclo);
            }
          }
      }
    }
  }

  correr(programa);
  final Resultado r;
  if (fallo == Evento.choque) {
    r = Resultado.choque;
  } else if (fallo == Evento.ciclo) {
    r = Resultado.cicloInfinito;
  } else if (nivel.dibujo != null) {
    r = trazo.containsAll(nivel.dibujo!) && nivel.dibujo!.containsAll(trazo) ? Resultado.exito : Resultado.dibujoIncompleto;
  } else if (nivel.celda(x, y) != 'M') {
    r = Resultado.sinMeta;
  } else if (!gemas.containsAll(nivel.gemas)) {
    r = Resultado.faltanGemas;
  } else {
    r = Resultado.exito;
  }
  final largo = nivel.maxBloques != null && contarBloques(programa) > nivel.maxBloques!;
  return Ejecucion(pasos, r == Resultado.exito && largo ? Resultado.muyLargo : r);
}
