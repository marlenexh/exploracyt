enum Sistema { circulatorio, respiratorio, inmunologico }

typedef Paso = ({String titulo, String texto});
typedef Pregunta = ({
  String pregunta,
  List<String> opciones,
  int respuesta,
  String explicacion,
});
typedef Mision = ({
  String nombre,
  String titulo,
  String resumen,
  List<Paso> pasos,
  String investigacion,
  String variable,
  String minimo,
  String maximo,
  String prediccion,
  String alternativa,
  bool prediccionCorrecta,
  String conclusion,
  List<Pregunta> retos,
});

const misiones = <Sistema, Mision>{
  Sistema.circulatorio: (
    nombre: 'Circulatorio',
    titulo: 'El viaje de la sangre',
    resumen:
        'Sigue un glóbulo rojo desde el corazón hasta el resto del cuerpo.',
    pasos: [
      (
        titulo: 'El corazón bombea',
        texto: 'El corazón es un músculo. Su lado derecho envía sangre con menos oxígeno a los pulmones. Busca la ruta violeta.',
      ),
      (
        titulo: 'Parada en los pulmones',
        texto: 'En los capilares pulmonares, la sangre recibe oxígeno y libera dióxido de carbono. Después regresa al lado izquierdo del corazón.',
      ),
      (
        titulo: 'Entrega al cuerpo',
        texto: 'El lado izquierdo envía sangre rica en oxígeno por las arterias. En los capilares del cuerpo, el oxígeno pasa a los tejidos. Las venas llevan la sangre de vuelta al corazón.',
      ),
    ],
    investigacion: '¿Cómo cambia el pulso cuando el cuerpo pasa del reposo a una actividad como correr?',
    variable: 'Nivel de actividad del avatar',
    minimo: 'Reposo',
    maximo: 'Corriendo',
    prediccion: 'El corazón late más rápido.',
    alternativa: 'El corazón late más despacio.',
    prediccionCorrecta: true,
    conclusion: 'Al aumentar la actividad, el corazón suele latir más rápido para ayudar a llevar más oxígeno a los músculos. El valor de la simulación es ilustrativo.',
    retos: [
      (
        pregunta: '¿Hacia dónde envía sangre el lado derecho del corazón?',
        opciones: ['Al cerebro', 'A los pulmones', 'Al estómago'],
        respuesta: 1,
        explicacion: 'El lado derecho bombea sangre hacia los pulmones para el intercambio de gases.',
      ),
      (
        pregunta: '¿En qué vasos se intercambian sustancias con los tejidos?',
        opciones: [
          'En las venas',
          'En las arterias grandes',
          'En los capilares',
        ],
        respuesta: 2,
        explicacion: 'Las paredes muy finas de los capilares permiten el intercambio con los tejidos.',
      ),
    ],
  ),
  Sistema.respiratorio: (
    nombre: 'Respiratorio',
    titulo: 'Tras la pista del oxígeno',
    resumen: 'Acompaña al aire desde la nariz hasta los alvéolos.',
    pasos: [
      (
        titulo: 'El aire entra',
        texto: 'Al inhalar, el aire entra por la nariz o la boca. Baja por la tráquea y se reparte por los bronquios hacia ambos pulmones.',
      ),
      (
        titulo: 'Un intercambio diminuto',
        texto: 'Los alvéolos son pequeños sacos de aire. El oxígeno pasa de ellos a la sangre y el dióxido de carbono pasa de la sangre a los alvéolos.',
      ),
      (
        titulo: 'El diafragma cambia el espacio',
        texto: 'Al inhalar, el diafragma se contrae y baja. Los pulmones se expanden. Al exhalar con calma, el diafragma se relaja y sube, y el aire sale.',
      ),
    ],
    investigacion: '¿Qué pasa con el volumen de los pulmones al bajar el diafragma durante la inhalación?',
    variable: 'Posición del diafragma',
    minimo: 'Arriba',
    maximo: 'Abajo',
    prediccion: 'El volumen disminuye.',
    alternativa: 'El volumen aumenta.',
    prediccionCorrecta: false,
    conclusion: 'Al bajar el diafragma, aumenta el espacio dentro del tórax y los pulmones se expanden. Al subir, el volumen disminuye.',
    retos: [
      (
        pregunta: '¿Qué ruta sigue el aire al entrar?',
        opciones: [
          'Nariz → tráquea → bronquios',
          'Nariz → corazón → bronquios',
          'Boca → estómago → pulmones',
        ],
        respuesta: 0,
        explicacion: 'El aire baja por la tráquea y los bronquios lo reparten a los pulmones.',
      ),
      (
        pregunta: '¿Hacia dónde pasa el oxígeno en los alvéolos?',
        opciones: [
          'De la sangre al aire',
          'Del aire a la sangre',
          'Del aire al estómago',
        ],
        respuesta: 1,
        explicacion:
            'El oxígeno cruza de los alvéolos a los capilares que los rodean.',
      ),
    ],
  ),
  Sistema.inmunologico: (
    nombre: 'Inmunológico',
    titulo: 'El equipo de defensa',
    resumen: 'Explora las barreras, las células de defensa y la memoria inmunitaria.',
    pasos: [
      (
        titulo: 'Primera barrera',
        texto: 'La piel y las mucosas dificultan la entrada de muchos microbios. La mucosidad de las vías respiratorias también puede atraparlos.',
      ),
      (
        titulo: 'Células en acción',
        texto: 'Algunos glóbulos blancos, como los fagocitos, pueden rodear y digerir microbios. La médula ósea produce células sanguíneas y los ganglios linfáticos ayudan a coordinar la defensa.',
      ),
      (
        titulo: 'Memoria para después',
        texto: 'Algunos linfocitos producen anticuerpos y otros ayudan de distintas maneras. Algunas células quedan como células de memoria y facilitan una respuesta más rápida al reencontrar el mismo microbio.',
      ),
    ],
    investigacion: '¿Qué respuesta aparece antes en el modelo al reencontrar el mismo microbio?',
    variable: 'Memoria inmunitaria',
    minimo: 'Primer encuentro',
    maximo: 'Reencuentro',
    prediccion: 'La del reencuentro.',
    alternativa: 'La del primer encuentro.',
    prediccionCorrecta: true,
    conclusion: 'Las células de memoria pueden acelerar la respuesta frente a un microbio conocido. El tiempo mostrado es relativo.',
    retos: [
      (
        pregunta: '¿Qué ayuda a impedir que muchos microbios entren al cuerpo?',
        opciones: ['La piel', 'El corazón', 'El diafragma'],
        respuesta: 0,
        explicacion: 'La piel funciona como una barrera física.',
      ),
      (
        pregunta: '¿Qué ayuda a responder más rápido frente al mismo microbio?',
        opciones: [
          'El oxígeno',
          'Los glóbulos rojos',
          'Las células de memoria',
        ],
        respuesta: 2,
        explicacion: 'La memoria inmunitaria facilita una respuesta más rápida en un encuentro posterior.',
      ),
    ],
  ),
};

const retoFinal = (
  pregunta: 'Al correr, ¿cómo colaboran los pulmones y el corazón para que los músculos reciban oxígeno?',
  opciones: [
    'Los pulmones lo pasan a la sangre y el corazón bombea esa sangre.',
    'El corazón toma aire y los pulmones llevan sangre a las piernas.',
    'Los músculos reciben oxígeno directamente de los bronquios.',
  ],
  respuesta: 0,
  explicacion: 'El sistema respiratorio intercambia gases y el circulatorio transporta el oxígeno hasta los músculos.',
);
