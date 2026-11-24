import 'package:flutter/material.dart';

import 'modelo_ia.dart';

/// Proyectos (problemas con datos) para entrenar IAs en los juegos.

EjemploIA _e(String emoji, String nombre, int etiqueta, Map<String, String> rasgos) => EjemploIA(emoji, nombre, rasgos, etiqueta);

// --- Laboratorio -------------------------------------------------------------

/// Separar la basura en orgánica y reciclable.
const _basura = [EtiquetaIA('Orgánica', '🍂', Color(0xFF43A047)), EtiquetaIA('Reciclable', '♻️', Color(0xFF1E88E5))];
final proyectoBasura = ProyectoIA(
  titulo: 'Separador de basura',
  emoji: '♻️',
  descripcion: 'Una IA para el bote inteligente de la escuela: ¿la basura es orgánica o reciclable?',
  etiquetas: _basura,
  rasgos: const [
    Rasgo('material', 'Material', '🧱'),
    Rasgo('pudre', '¿Se pudre?', '🦠'),
    Rasgo('color', 'Color', '🎨', util: false),
    Rasgo('tamano', 'Tamaño', '📏', util: false),
  ],
  banco: [
    _e('🍌', 'Cáscara de plátano', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'amarillo', 'tamano': 'chico'}),
    _e('🧴', 'Botella de plástico', 1, {'material': 'plástico', 'pudre': 'no', 'color': 'blanco', 'tamano': 'mediano'}),
    _e('🍎', 'Manzana mordida', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'rojo', 'tamano': 'chico'}),
    _e('🥫', 'Lata', 1, {'material': 'metal', 'pudre': 'no', 'color': 'rojo', 'tamano': 'chico'}),
    _e('🍂', 'Hojas secas', 0, {'material': 'planta', 'pudre': 'sí', 'color': 'café', 'tamano': 'chico'}),
    _e('📰', 'Periódico', 1, {'material': 'papel', 'pudre': 'no', 'color': 'blanco', 'tamano': 'mediano'}),
    _e('🥚', 'Cascarón de huevo', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'blanco', 'tamano': 'chico'}),
    _e('📦', 'Caja de cartón', 1, {'material': 'papel', 'pudre': 'no', 'color': 'café', 'tamano': 'grande'}),
    _e('🍞', 'Pan duro', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'café', 'tamano': 'chico'}),
    _e('🍾', 'Botella de vidrio', 1, {'material': 'vidrio', 'pudre': 'no', 'color': 'verde', 'tamano': 'mediano'}),
    _e('🌽', 'Olote de elote', 0, {'material': 'planta', 'pudre': 'sí', 'color': 'amarillo', 'tamano': 'mediano'}),
    _e('🥤', 'Vaso de plástico', 1, {'material': 'plástico', 'pudre': 'no', 'color': 'rojo', 'tamano': 'chico'}),
  ],
  prueba: [
    _e('🥭', 'Hueso de mango', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'amarillo', 'tamano': 'chico'}),
    _e('🛍️', 'Bolsa de plástico', 1, {'material': 'plástico', 'pudre': 'no', 'color': 'amarillo', 'tamano': 'chico'}),
    _e('🥕', 'Cáscaras de zanahoria', 0, {'material': 'comida', 'pudre': 'sí', 'color': 'naranja', 'tamano': 'chico'}),
    _e('🔩', 'Tapa de metal', 1, {'material': 'metal', 'pudre': 'no', 'color': 'gris', 'tamano': 'chico'}),
    _e('🌸', 'Flores marchitas', 0, {'material': 'planta', 'pudre': 'sí', 'color': 'blanco', 'tamano': 'mediano'}),
    _e('📄', 'Hojas de cuaderno', 1, {'material': 'papel', 'pudre': 'no', 'color': 'blanco', 'tamano': 'chico'}),
  ],
);

/// Reconocer animales: mamífero, ave o pez.
const _animales = [
  EtiquetaIA('Mamífero', '🐾', Color(0xFF8D6E63)),
  EtiquetaIA('Ave', '🪶', Color(0xFF039BE5)),
  EtiquetaIA('Pez', '🐟', Color(0xFF3949AB)),
];
final proyectoAnimales = ProyectoIA(
  titulo: 'Reconocedor de animales',
  emoji: '🐾',
  descripcion: 'Una IA para el zoológico: ¿el animal es mamífero, ave o pez?',
  etiquetas: _animales,
  rasgos: const [
    Rasgo('cubierta', 'Cubierta del cuerpo', '🧥'),
    Rasgo('respira', 'Cómo respira', '🫁'),
    Rasgo('patas', 'Número de patas', '🦵'),
    Rasgo('vive', 'Dónde vive', '🏞️', util: false),
    Rasgo('color', 'Color', '🎨', util: false),
  ],
  banco: [
    _e('🐶', 'Perro', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '4', 'vive': 'tierra', 'color': 'café'}),
    _e('🐔', 'Gallina', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'tierra', 'color': 'blanco'}),
    _e('🐟', 'Pez', 2, {'cubierta': 'escamas', 'respira': 'branquias', 'patas': '0', 'vive': 'agua', 'color': 'azul'}),
    _e('🐱', 'Gato', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '4', 'vive': 'tierra', 'color': 'gris'}),
    _e('🦜', 'Loro', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'aire', 'color': 'verde'}),
    _e('🐠', 'Pez payaso', 2, {'cubierta': 'escamas', 'respira': 'branquias', 'patas': '0', 'vive': 'agua', 'color': 'naranja'}),
    _e('🐮', 'Vaca', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '4', 'vive': 'tierra', 'color': 'blanco'}),
    _e('🦅', 'Águila', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'aire', 'color': 'café'}),
    _e('🦈', 'Tiburón', 2, {'cubierta': 'escamas', 'respira': 'branquias', 'patas': '0', 'vive': 'agua', 'color': 'gris'}),
    _e('🐋', 'Ballena', 0, {'cubierta': 'piel', 'respira': 'pulmones', 'patas': '0', 'vive': 'agua', 'color': 'gris'}),
    _e('🐧', 'Pingüino', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'agua', 'color': 'negro'}),
    _e('🦇', 'Murciélago', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '2', 'vive': 'aire', 'color': 'negro'}),
  ],
  prueba: [
    _e('🐴', 'Caballo', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '4', 'vive': 'tierra', 'color': 'café'}),
    _e('🦆', 'Pato', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'agua', 'color': 'café'}),
    _e('🐡', 'Pez globo', 2, {'cubierta': 'escamas', 'respira': 'branquias', 'patas': '0', 'vive': 'agua', 'color': 'amarillo'}),
    _e('🐬', 'Delfín', 0, {'cubierta': 'piel', 'respira': 'pulmones', 'patas': '0', 'vive': 'agua', 'color': 'gris'}),
    _e('🦉', 'Búho', 1, {'cubierta': 'plumas', 'respira': 'pulmones', 'patas': '2', 'vive': 'aire', 'color': 'café'}),
    _e('🦭', 'Foca', 0, {'cubierta': 'pelo', 'respira': 'pulmones', 'patas': '0', 'vive': 'agua', 'color': 'gris'}),
  ],
);

/// Predecir si hay que llevar paraguas.
const _clima = [EtiquetaIA('Llevar paraguas', '☂️', Color(0xFF5C6BC0)), EtiquetaIA('Sin paraguas', '😎', Color(0xFFFFA000))];
final proyectoClima = ProyectoIA(
  titulo: 'Pronóstico del paraguas',
  emoji: '☂️',
  descripcion: 'Una IA que mira el cielo y te avisa si debes llevar paraguas a la escuela.',
  etiquetas: _clima,
  rasgos: const [
    Rasgo('nubes', 'Nubes', '☁️'),
    Rasgo('humedad', 'Humedad', '💧'),
    Rasgo('cielo', 'Color del cielo', '🎨'),
    Rasgo('dia', 'Día de la semana', '📅', util: false),
  ],
  banco: [
    _e('🌧️', 'Lluvia', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'lunes'}),
    _e('☀️', 'Soleado', 1, {'nubes': 'pocas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'lunes'}),
    _e('⛈️', 'Tormenta', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'martes'}),
    _e('🌤️', 'Casi despejado', 1, {'nubes': 'algunas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'martes'}),
    _e('🌦️', 'Chubasco', 0, {'nubes': 'algunas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'miércoles'}),
    _e('⛅', 'Medio nublado', 1, {'nubes': 'algunas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'miércoles'}),
    _e('🌩️', 'Rayos', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'jueves'}),
    _e('🌈', 'Arcoíris', 1, {'nubes': 'pocas', 'humedad': 'media', 'cielo': 'azul', 'dia': 'jueves'}),
    _e('☁️', 'Nublado húmedo', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'viernes'}),
    _e('🌬️', 'Ventoso y seco', 1, {'nubes': 'pocas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'viernes'}),
    _e('🌨️', 'Aguanieve', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'sábado'}),
    _e('🏖️', 'Caluroso', 1, {'nubes': 'pocas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'domingo'}),
  ],
  prueba: [
    _e('🌧️', 'Llovizna', 0, {'nubes': 'algunas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'domingo'}),
    _e('☀️', 'Día de playa', 1, {'nubes': 'pocas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'sábado'}),
    _e('☁️', 'Nubes oscuras', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'sábado'}),
    _e('🌤️', 'Mañana fresca', 1, {'nubes': 'algunas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'domingo'}),
    _e('⛈️', 'Tormenta eléctrica', 0, {'nubes': 'muchas', 'humedad': 'alta', 'cielo': 'gris', 'dia': 'lunes'}),
    _e('🌅', 'Amanecer despejado', 1, {'nubes': 'pocas', 'humedad': 'baja', 'cielo': 'azul', 'dia': 'martes'}),
  ],
);

final proyectosLaboratorio = [proyectoBasura, proyectoAnimales, proyectoClima];

// --- Temas -------------------------------------------------------------------

/// Tema 3: enseñar a distinguir mamíferos y aves.
final proyectoMamiferoAve = ProyectoIA(
  titulo: '¿Mamífero o ave?',
  emoji: '🐾',
  descripcion: 'Enseña a la IA a reconocer mamíferos y aves. Se fija en su cubierta y en sus patas.',
  etiquetas: const [EtiquetaIA('Mamífero', '🐾', Color(0xFF8D6E63)), EtiquetaIA('Ave', '🪶', Color(0xFF039BE5))],
  rasgos: const [Rasgo('cubierta', 'Cubierta del cuerpo', '🧥'), Rasgo('patas', 'Número de patas', '🦵')],
  banco: [
    _e('🐶', 'Perro', 0, {'cubierta': 'pelo', 'patas': '4'}),
    _e('🐔', 'Gallina', 1, {'cubierta': 'plumas', 'patas': '2'}),
    _e('🐱', 'Gato', 0, {'cubierta': 'pelo', 'patas': '4'}),
    _e('🦜', 'Loro', 1, {'cubierta': 'plumas', 'patas': '2'}),
    _e('🐮', 'Vaca', 0, {'cubierta': 'pelo', 'patas': '4'}),
    _e('🦅', 'Águila', 1, {'cubierta': 'plumas', 'patas': '2'}),
  ],
  prueba: [
    _e('🐴', 'Caballo', 0, {'cubierta': 'pelo', 'patas': '4'}),
    _e('🦆', 'Pato', 1, {'cubierta': 'plumas', 'patas': '2'}),
    _e('🐰', 'Conejo', 0, {'cubierta': 'pelo', 'patas': '4'}),
    _e('🦉', 'Búho', 1, {'cubierta': 'plumas', 'patas': '2'}),
  ],
);

/// Tema 5: una IA con sesgo porque solo vio manzanas rojas.
final proyectoManzanas = ProyectoIA(
  titulo: 'Detector de manzanas',
  emoji: '🍎',
  descripcion: 'Esta IA solo se fija en el color y la forma. ¿Aprendió bien qué es una manzana?',
  etiquetas: const [EtiquetaIA('Manzana', '🍎', Color(0xFFE53935)), EtiquetaIA('No es manzana', '❌', Color(0xFF757575))],
  rasgos: const [Rasgo('color', 'Color', '🎨'), Rasgo('forma', 'Forma', '🔵')],
  banco: [
    _e('🍎', 'Manzana roja', 0, {'color': 'rojo', 'forma': 'redonda'}),
    _e('🍋‍🟩', 'Lima', 1, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍎', 'Manzana roja chica', 0, {'color': 'rojo', 'forma': 'redonda'}),
    _e('🫒', 'Aceituna', 1, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍎', 'Manzana roja grande', 0, {'color': 'rojo', 'forma': 'redonda'}),
    _e('🍐', 'Pera', 1, {'color': 'verde', 'forma': 'gota'}),
    _e('🍌', 'Plátano', 1, {'color': 'amarillo', 'forma': 'alargada'}),
  ],
  prueba: [
    _e('🍏', 'Manzana verde', 0, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍎', 'Manzana roja nueva', 0, {'color': 'rojo', 'forma': 'redonda'}),
    _e('🥒', 'Pepino', 1, {'color': 'verde', 'forma': 'alargada'}),
    _e('🍌', 'Plátano maduro', 1, {'color': 'amarillo', 'forma': 'alargada'}),
  ],
  extra: [
    _e('🍏', 'Manzana verde', 0, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍏', 'Manzana verde chica', 0, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍏', 'Manzana verde ácida', 0, {'color': 'verde', 'forma': 'redonda'}),
    _e('🍎', 'Manzana amarilla', 0, {'color': 'amarillo', 'forma': 'redonda'}),
  ],
);
