/// Laboratorios finales de los mundos de Biología, Química, Física y
/// Electrónica (Programación e IA tienen los suyos en pro_topics/ia_topics).
class LaboratorioMundo {
  const LaboratorioMundo(this.mundo, this.titulo, this.emoji, this.descripcion, this.insignia);
  final String mundo, titulo, emoji, descripcion, insignia;
  String get id => '$mundo-lab';
  String get badgeId => '$mundo-lab-badge';
}

const laboratoriosMundos = {
  'bio': LaboratorioMundo('bio', 'Laboratorio de la Vida', '🌳', 'Crea un ecosistema equilibrado y ponlo a prueba 30 días.', 'Guardián de Ecosistemas'),
  'qui': LaboratorioMundo('qui', 'Laboratorio de Experimentos', '⚗️', 'Prepárate, haz experimentos de verdad y anota lo que pasa.', 'Químico Experimentador'),
  'fis': LaboratorioMundo(
      'fis', 'Laboratorio de Lanzamientos', '🚀', 'Calcula fuerza y ángulo para dar en el blanco en la Tierra, la Luna y Marte.', 'Ingeniero de Lanzamientos'),
  'ele': LaboratorioMundo('ele', 'Laboratorio del Inventor', '💡', 'Construye los circuitos de una casa inteligente.', 'Inventor de la Casa Inteligente'),
};
