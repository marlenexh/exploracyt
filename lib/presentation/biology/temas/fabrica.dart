import 'package:flutter/material.dart';

import '../tema1/componentes.dart';
import '../tema1/comunes.dart' show Reloj;
import '../tema1/contenido.dart' show PreguntaQuiz;
import '../tema1/mision1.dart' show PantallaVideoTema;
import '../tema1/mision2.dart' show EtiquetarPartes, Ranura, RelacionarFunciones;
import 'ilustraciones.dart';
import 'pasos.dart';

export '../tema1/componentes.dart' show Accion, GrupoTarjetas, TarjetaInfo, PanelPuntos;
export '../tema1/contenido.dart' show PreguntaQuiz;
export 'ilustraciones.dart' show Parte;
export 'pasos.dart' show GrupoClasificar, ItemClasificar, CosaQueCae, EscenaBio;

/// Funciones para crear las pantallas de un tema con poco código.

/// Rectángulo estándar de la ilustración en las explicaciones.
const rectExplicacion = Rect.fromLTWH(392, 60, 256, 370);

/// Rectángulo de la ilustración cuando hay panel a la derecha.
const rectExplicacionPanel = Rect.fromLTWH(392, 64, 250, 330);

Widget explicacion(
  String actividad, {
  required String seccion,
  required String titulo,
  required Color color,
  required Ilustracion il,
  required List<String> textos,
  List<Parte> izquierda = const [],
  List<Parte> derecha = const [],
  Map<int, Set<String>> resaltar = const {},
  required String mensajeFinal,
  Widget Function(int pestana)? panel,
}) {
  final r = panel == null ? rectExplicacion : rectExplicacionPanel;
  return PantallaExplicacion(
    actividad: actividad,
    seccion: seccion,
    titulo: titulo,
    color: color,
    textos: textos,
    resaltar: resaltar,
    pintor: (t, _, sel) => PintorIlustracion(il, r, t, resaltar: sel),
    etiquetas: etiquetasPara(il, r, izquierda, derecha, xDerecha: panel == null ? 660 : 500),
    mensajeFinal: mensajeFinal,
    panel: panel,
  );
}

Widget tarjetas(
  String actividad, {
  required String seccion,
  required String titulo,
  required Color color,
  required String textoZati,
  required List<GrupoTarjetas> grupos,
  required String mensajeFinal,
}) =>
    PantallaTarjetas(
      actividad: actividad,
      seccion: seccion,
      titulo: titulo,
      color: color,
      textoZati: textoZati,
      grupos: grupos,
      mensajeFinal: mensajeFinal,
    );

Widget video(String actividad, {required String clave, required String titulo, required String tema, required String siguiente}) =>
    PantallaVideoTema(clave: clave, titulo: titulo, actividad: actividad, tema: tema, siguiente: siguiente);

Widget clasificar(
  String actividad, {
  required String seccion,
  required String titulo,
  required Color color,
  required String instruccion,
  required List<GrupoClasificar> grupos,
  required List<ItemClasificar> items,
  required String mensajeFinal,
}) =>
    PantallaClasificar(
      actividad: actividad,
      seccion: seccion,
      titulo: titulo,
      color: color,
      instruccion: instruccion,
      grupos: grupos,
      items: items,
      mensajeFinal: mensajeFinal,
    );

Widget ordenar(
  String actividad, {
  required String seccion,
  required String titulo,
  required Color color,
  required String instruccion,
  required List<(String, String)> pasos,
  required String explicacion,
  required String mensajeFinal,
  bool ciclo = false,
}) =>
    PantallaOrdenar(
      actividad: actividad,
      seccion: seccion,
      titulo: titulo,
      color: color,
      instruccion: instruccion,
      pasos: pasos,
      explicacion: explicacion,
      mensajeFinal: mensajeFinal,
      ciclo: ciclo,
    );

Widget atrapar(
  String actividad, {
  required String titulo,
  required String instrucciones,
  required Color color,
  required String recolector,
  required List<CosaQueCae> cosas,
  required String mensajeFinal,
}) =>
    JuegoAtrapar(
      actividad: actividad,
      titulo: titulo,
      instrucciones: instrucciones,
      color: color,
      recolector: recolector,
      cosas: cosas,
      mensajeFinal: mensajeFinal,
    );

Widget memorama(
  String actividad, {
  required String titulo,
  required Color color,
  required String instruccion,
  required List<(String, String, String)> pares,
  required String mensajeFinal,
}) =>
    JuegoMemorama(actividad: actividad, titulo: titulo, color: color, instruccion: instruccion, pares: pares, mensajeFinal: mensajeFinal);

Widget situacion(String actividad, {required String titulo, required Color color, required List<EscenaBio> escenas, required String mensajeFinal}) =>
    PantallaSituacionBio(actividad: actividad, titulo: titulo, color: color, escenas: escenas, mensajeFinal: mensajeFinal);

Widget miniMision(String actividad, {required Color color, required List<FaseMini> fases, required String mensajeFinal}) =>
    PantallaMiniMisionBio(actividad: actividad, color: color, fases: fases, mensajeFinal: mensajeFinal);

// --- Fases de mini misión ---------------------------------------------------

const _rEtiquetar = Rect.fromLTWH(400, 70, 250, 380);

/// Nombrar las partes de una ilustración arrastrando tarjetas.
FaseMini faseEtiquetar(Ilustracion il, Map<String, String> nombres, {required Color color, String instruccion = 'Identifica y nombra las partes: arrastra cada nombre a su lugar.'}) {
  const r = _rEtiquetar;
  final izquierda = <String>[], derecha = <String>[];
  for (final id in nombres.keys) {
    (il.punto(r, id).dx < r.center.dx ? izquierda : derecha).add(id);
  }
  List<Ranura> columna(List<String> ids, double x) {
    final ordenados = [...ids]..sort((a, b) => il.punto(r, a).dy.compareTo(il.punto(r, b).dy));
    final res = <Ranura>[];
    var y = 64.0;
    for (final id in ordenados) {
      y = (il.punto(r, id).dy - 20).clamp(y, 430.0);
      res.add(Ranura(id, Offset(x, y), il.punto(r, id)));
      y += 48;
    }
    return res;
  }

  return FaseMini(
    instruccion,
    (fin) => EtiquetarPartes(
      fondo: Reloj(builder: (_, t) => CustomPaint(painter: PintorIlustracion(il, r, t))),
      color: color,
      nombres: nombres,
      ranuras: [...columna(izquierda, 258), ...columna(derecha, 668)],
      bandeja: const Rect.fromLTWH(8, 210, 236, 260),
      onCompleto: fin,
    ),
    mostrarZati: false,
  );
}

FaseMini faseRelacionar(List<(String, String)> parejas, {required Color color, String instruccion = 'Relaciona cada parte con su función.'}) =>
    FaseMini(instruccion, (fin) => RelacionarFunciones(parejas: parejas, onCompleto: fin, color: color));

FaseMini faseAcciones(String titulo, String instruccion, List<Accion> acciones, {required Color color}) => FaseMini(
      instruccion,
      (fin) => CapaAcciones(titulo: titulo, instruccion: instruccion, acciones: acciones, onTerminar: fin, color: color),
      mostrarGlobo: false,
    );

FaseMini fasePreguntas(List<PreguntaQuiz> preguntas, {required Color color, String instruccion = 'Responde las preguntas.'}) =>
    FaseMini(instruccion, (fin) => FasePreguntas(preguntas: preguntas, onCompleto: fin, color: color));
