/// Temas 2 a 5 de Biología: identificadores de sus misiones para el resto de
/// la app (mapa, progreso guardado, insignias y brújula de la ciencia).
///
/// El contenido jugable vive en `lib/presentation/biology/temas/`. Los títulos
/// van en el mismo orden que las misiones de cada `TemaBio`.
class BioTopicInfo {
  const BioTopicInfo(this.numero, this.missions, this.badge);
  final int numero;

  /// 3 misiones + actividad integradora.
  final List<String> missions;

  /// Insignia que se gana al terminar la actividad integradora.
  final String badge;

  String get id => 'bio-t$numero';
  List<String> get missionIds => [
        for (var i = 0; i < missions.length; i++)
          i == missions.length - 1 ? '$id-integration' : '$id-m${i + 1}'
      ];
  String get badgeId => '$id-integration-badge';
}

const bioTopics = {
  2: BioTopicInfo(2, ['¿Qué es una célula?', 'Células animales y vegetales', 'Seres de una y muchas células', 'La feria de ciencias'],
      'Explorador de las Células'),
  3: BioTopicInfo(3, ['Los nutrientes', 'La alimentación equilibrada', 'Hábitos saludables', 'El menú de la cafetería'],
      'Experto en Alimentación Saludable'),
  4: BioTopicInfo(4, ['¿Qué es un ser vivo?', 'Las plantas', 'Los animales', 'El huerto escolar'], 'Guardián de los Seres Vivos'),
  5: BioTopicInfo(5, ['¿Qué es un ecosistema?', 'Cadenas alimenticias', 'Biodiversidad y cuidado', 'Salvemos el río'],
      'Protector de la Biodiversidad'),
};
