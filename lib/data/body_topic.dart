class BodyStructure {
  const BodyStructure(this.name, this.explanation, this.x, this.y);

  final String name;
  final String explanation;
  final double x;
  final double y;
}

class BodyQuestion {
  const BodyQuestion(this.prompt, this.options, this.answer, this.feedback);

  final String prompt;
  final List<String> options;
  final int answer;
  final String feedback;
}

enum BodySystem { circulation, breathing, defense, teamwork }

class BodyMission {
  const BodyMission({
    required this.system,
    required this.title,
    required this.badge,
    required this.question,
    required this.predictions,
    required this.expectedPrediction,
    required this.comparison,
    required this.structures,
    required this.route,
    required this.challenge,
    required this.reflection,
  });

  final BodySystem system;
  final String title;
  final String badge;
  final String question;
  final List<String> predictions;
  final int expectedPrediction;
  final String comparison;
  final List<BodyStructure> structures;
  final List<String> route;
  final List<BodyQuestion> challenge;
  final String reflection;

  bool get isFinal => system == BodySystem.teamwork;
  String get id => 'bio-t1-${isFinal ? 'integration' : 'm${system.index + 1}'}';
  String get badgeId => '$id-badge';
}

bool bodyMissionUnlocked(int index, Set<String> completed) =>
    index >= 0 &&
    index < bodyMissions.length &&
    bodyMissions.take(index).every((mission) => completed.contains(mission.id));

String bodyBadgeName(String id) {
  for (final mission in bodyMissions) {
    if (mission.badgeId == id) return mission.badge;
  }
  return id;
}

const bodyMissions = [
  BodyMission(
    system: BodySystem.circulation,
    title: '¡El corazón en acción!',
    badge: 'Explorador del Corazón',
    question:
        '¿Por qué nuestro corazón late más rápido cuando hacemos ejercicio?',
    expectedPrediction: 0,
    predictions: ['Latirá más rápido', 'Latirá igual', 'Latirá más lento'],
    comparison:
        'En el modelo, los latidos aumentan con la actividad. Los músculos usan más oxígeno y el corazón impulsa más sangre por minuto.',
    structures: [
      BodyStructure(
        'Corazón',
        'Bombea sangre hacia los pulmones y hacia el resto del cuerpo.',
        .50,
        .38,
      ),
      BodyStructure(
        'Arterias',
        'Llevan sangre desde el corazón. Las arterias pulmonares llevan sangre con poco oxígeno hacia los pulmones.',
        .64,
        .46,
      ),
      BodyStructure(
        'Venas',
        'Devuelven la sangre al corazón. Las venas pulmonares traen sangre rica en oxígeno.',
        .36,
        .53,
      ),
      BodyStructure(
        'Capilares',
        'Son vasos muy finos. En ellos se intercambian gases y otras sustancias con los tejidos.',
        .57,
        .70,
      ),
    ],
    route: [
      'Corazón hacia pulmones',
      'Pulmones',
      'Corazón hacia el cuerpo',
      'Músculos',
      'Regreso al corazón',
    ],
    challenge: [
      BodyQuestion(
        '¿Qué estructura impulsa la sangre?',
        ['Capilares', 'Corazón', 'Venas'],
        1,
        'El corazón se contrae para impulsar sangre.',
      ),
      BodyQuestion(
        '¿Qué hacen las arterias pulmonares?',
        [
          'Salen del corazón hacia los pulmones',
          'Regresan desde los músculos',
          'Producen oxígeno',
        ],
        0,
        'Una arteria lleva sangre hacia afuera del corazón.',
      ),
      BodyQuestion(
        '¿Dónde pasa oxígeno de la sangre a los músculos?',
        ['En la tráquea', 'En las venas grandes', 'En los capilares'],
        2,
        'Las paredes finas de los capilares permiten el intercambio.',
      ),
    ],
    reflection:
        '¿En qué momento de tu día podrías notar que el pulso cambia? Explica qué necesitan tus músculos y qué pasa al descansar.',
  ),
  BodyMission(
    system: BodySystem.breathing,
    title: '¡El viaje del aire!',
    badge: 'Explorador de la Respiración',
    question: '¿Por qué respiramos más rápido después de correr?',
    expectedPrediction: 2,
    predictions: [
      'Respiraré más despacio',
      'Respiraré igual',
      'Respiraré más rápido',
    ],
    comparison:
        'En el modelo, durante la actividad respiramos más veces por minuto. En los alvéolos entra oxígeno a la sangre y sale dióxido de carbono.',
    structures: [
      BodyStructure(
        'Nariz y cavidad nasal',
        'El aire se humedece y se calienta al entrar por la nariz.',
        .50,
        .15,
      ),
      BodyStructure(
        'Tráquea',
        'Conduce el aire hacia los bronquios.',
        .50,
        .30,
      ),
      BodyStructure(
        'Bronquios',
        'Son dos ramas que llevan el aire hacia los pulmones.',
        .51,
        .41,
      ),
      BodyStructure(
        'Pulmones',
        'Se expanden al inhalar y se reducen al exhalar.',
        .37,
        .48,
      ),
      BodyStructure(
        'Alvéolos',
        'Son bolsitas diminutas donde se intercambian gases con la sangre.',
        .63,
        .52,
      ),
      BodyStructure(
        'Diafragma',
        'Al inhalar se contrae y baja. Al exhalar en reposo se relaja y sube.',
        .50,
        .61,
      ),
    ],
    route: [
      'Nariz',
      'Tráquea',
      'Bronquios',
      'Conductos más pequeños',
      'Alvéolos',
    ],
    challenge: [
      BodyQuestion(
        '¿Dónde pasan los gases entre el aire y la sangre?',
        ['En la nariz', 'En la tráquea', 'En los alvéolos'],
        2,
        'Los alvéolos están rodeados de capilares.',
      ),
      BodyQuestion(
        '¿Qué hace el diafragma al inhalar?',
        ['Baja', 'Sube', 'Cierra los bronquios'],
        0,
        'Al bajar hay más espacio en el tórax.',
      ),
      BodyQuestion(
        '¿Qué hábito cuida tus pulmones?',
        [
          'Acercarte al humo',
          'Ventilar si el aire exterior es adecuado',
          'Respirar polvo de cerca',
        ],
        1,
        'La ventilación ayuda a renovar el aire. Evita el humo.',
      ),
    ],
    reflection:
        'Piensa en tu salón. ¿Cómo podrías ayudar a renovar el aire? Explica por qué sería útil.',
  ),
  BodyMission(
    system: BodySystem.defense,
    title: '¡Defensores del cuerpo!',
    badge: 'Guardián de las Defensas',
    question: 'Si te haces un raspón al jugar, ¿cómo se defiende tu cuerpo?',
    expectedPrediction: 0,
    predictions: [
      'La piel y las células de defensa ayudan',
      'Solo los pulmones lo defienden',
      'El cuerpo no puede responder',
    ],
    comparison:
        'La piel intacta dificulta la entrada de microorganismos. Cuando se rompe, entran en acción otras defensas y cuidar la herida reduce el riesgo.',
    structures: [
      BodyStructure(
        'Piel',
        'Es una barrera que dificulta la entrada de microorganismos.',
        .26,
        .48,
      ),
      BodyStructure(
        'Glóbulos blancos',
        'Distintos tipos de células detectan amenazas y ayudan a responder.',
        .54,
        .43,
      ),
      BodyStructure(
        'Ganglios linfáticos',
        'Son puntos de encuentro de células de defensa.',
        .39,
        .32,
      ),
      BodyStructure(
        'Médula ósea',
        'Tejido en el interior de algunos huesos donde se producen células de la sangre.',
        .43,
        .74,
      ),
      BodyStructure(
        'Microorganismos',
        'Muchos son inofensivos o útiles. Algunos pueden causar enfermedades.',
        .70,
        .29,
      ),
    ],
    route: [],
    challenge: [
      BodyQuestion(
        '¿Qué barrera se dañó en el raspón?',
        ['Diafragma', 'Piel', 'Ganglio'],
        1,
        'La piel intacta ayuda a detener la entrada de algunos microorganismos.',
      ),
      BodyQuestion(
        '¿Dónde se producen muchas células de la sangre?',
        ['Médula ósea', 'Bronquios', 'Nariz'],
        0,
        'La médula ósea también produce glóbulos blancos.',
      ),
      BodyQuestion(
        '¿Qué acción es adecuada ante un raspón?',
        [
          'Cubrirlo con tierra',
          'Ignorarlo siempre',
          'Avisar a un adulto y limpiar la herida',
        ],
        2,
        'Limpiar y cuidar la herida ayuda a reducir el riesgo.',
      ),
      BodyQuestion(
        '¿Cómo ayudan las vacunas?',
        [
          'Protegen al instante de todo',
          'Preparan defensas específicas con el tiempo',
          'Sustituyen el descanso',
        ],
        1,
        'La respuesta tarda en desarrollarse y la protección no es absoluta.',
      ),
    ],
    reflection:
        '¿Qué harías si te raspas durante el recreo? Explica cómo tu decisión ayuda a las defensas que ya tiene tu cuerpo.',
  ),
  BodyMission(
    system: BodySystem.teamwork,
    title: '¡Tu cuerpo trabaja en equipo!',
    badge: 'Investigador del Cuerpo Humano',
    question:
        'En una caminata por una pendiente de la Sierra de Zongolica, ¿cómo llega más oxígeno a tus piernas?',
    expectedPrediction: 0,
    predictions: [
      'Los pulmones y la circulación cooperan',
      'La piel bombea sangre',
      'Solo cambia el aire de afuera',
    ],
    comparison:
        'Los pulmones intercambian gases y la sangre transporta oxígeno a los músculos. Las defensas protegen al organismo y cumplen una función distinta.',
    structures: [
      BodyStructure(
        'Respiratorio',
        'El aire llega a los alvéolos y el oxígeno pasa a la sangre.',
        .39,
        .41,
      ),
      BodyStructure(
        'Circulatorio',
        'El corazón impulsa la sangre para llevar oxígeno a los músculos.',
        .54,
        .46,
      ),
      BodyStructure(
        'Inmunológico',
        'La piel y las células de defensa ayudan a proteger el cuerpo durante la caminata y en el descanso.',
        .66,
        .58,
      ),
    ],
    route: ['Aire inhalado', 'Alvéolos', 'Sangre', 'Músculos de las piernas'],
    challenge: [
      BodyQuestion(
        '¿Por qué pueden subir el pulso y la respiración en la pendiente?',
        [
          'Aumenta la demanda de oxígeno de los músculos',
          'La piel reemplaza a los pulmones',
          'Los ganglios bombean la sangre',
        ],
        0,
        'Respiración y circulación se ajustan durante el esfuerzo.',
      ),
      BodyQuestion(
        'Si alguien se raspa en la caminata, ¿qué sistema ayuda a proteger la zona?',
        [
          'Solo el respiratorio',
          'Solo el circulatorio',
          'El inmunológico, con el apoyo del cuidado de la herida',
        ],
        2,
        'Las defensas ayudan a proteger. Avisar y cuidar la herida reduce riesgos.',
      ),
      BodyQuestion(
        '¿Qué plan ayuda al grupo?',
        [
          'Hacer pausas y avisar si alguien se lastima',
          'Seguir sin parar aunque alguien se sienta mal',
          'Tocar heridas con manos sucias',
        ],
        0,
        'Hacer pausas y cuidar al grupo favorece la salud.',
      ),
    ],
    reflection:
        'Explica con tus palabras cómo colaboran los pulmones y el corazón durante la subida. Agrega una acción que proteja al grupo.',
  ),
];
