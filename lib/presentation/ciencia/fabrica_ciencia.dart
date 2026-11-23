import 'package:flutter/material.dart';

import '../biology/tema1/contenido.dart' show PreguntaQuiz;
import 'lab_matriz.dart';

export 'lab_matriz.dart' show Prueba, Muestra;

/// Atajo para crear un laboratorio de pruebas.
Widget lab(String a,
        {required String titulo,
        required Color color,
        required String instruccion,
        required List<Prueba> pruebas,
        required List<Muestra> muestras,
        required PreguntaQuiz pregunta,
        required String mensajeFinal}) =>
    LabMatriz(
        actividad: a,
        titulo: titulo,
        color: color,
        instruccion: instruccion,
        pruebas: pruebas,
        muestras: muestras,
        pregunta: pregunta,
        mensajeFinal: mensajeFinal);
