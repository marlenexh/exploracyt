import 'package:flutter/material.dart';

enum Validacion { pendiente, verificado }

/// Fuente curricular. Nada se marca "verificado" sin revisar el libro oficial.
class FuenteCurricular {
  final String grados, libro, contenido;
  final Validacion estado;
  const FuenteCurricular({this.grados = '5.º y 6.º', this.libro = 'Por identificar',
      this.contenido = 'Por identificar', this.estado = Validacion.pendiente});
}

enum TipoPaso { llamada, video, pista, laboratorio, minijuego, reto, retro, recompensa }

class PasoMision {
  final TipoPaso tipo;
  final String titulo;
  final String? laboratorio;
  const PasoMision(this.tipo, this.titulo, {this.laboratorio});
}

class Recompensa {
  final String id; // único: evita duplicados al repetir misiones
  final String nombre;
  final String? piezaRobot;
  const Recompensa(this.id, this.nombre, {this.piezaRobot});
}

class Mision {
  final String id, titulo;
  final List<PasoMision> pasos;
  final Recompensa? recompensa;
  final FuenteCurricular fuente;
  final bool implementada; // false = "pendiente", nunca simulada
  const Mision(this.id, this.titulo,
      {this.pasos = const [], this.recompensa, this.fuente = const FuenteCurricular(), this.implementada = false});
}

class Tema {
  final String id, titulo;
  final List<Mision> misiones;
  const Tema(this.id, this.titulo, this.misiones);
}

class Mundo {
  final String id, nombre, subtitulo;
  final IconData icono;
  final Color color;
  final List<Tema> temas;
  const Mundo(this.id, this.nombre, this.subtitulo, this.icono, this.color, this.temas);
}
