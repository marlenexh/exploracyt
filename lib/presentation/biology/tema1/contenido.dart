import 'package:flutter/material.dart';

import 'progreso.dart';

// ---------------------------------------------------------------------------
// Tipos de contenido
// ---------------------------------------------------------------------------

/// Animación que acompaña a cada escena del recorrido.
enum AnimTour {
  queEsCuerpo,
  estacion,
  niveles,
  organos,
  sistemasEquipo,
  corazon,
  circuito,
  sangre,
  viaAire,
  diafragma,
  alveolo,
  barreras,
  fagocito,
  anticuerpos,
  vacuna,
  habitos,
}

/// Sistema de coordenadas de un punto de interés: relativo al área de la
/// animación, o relativo a la silueta del cuerpo dibujada en ella.
enum Marco { area, silueta }

class PuntoInteres {
  const PuntoInteres(
    this.titulo,
    this.texto,
    this.pos, {
    this.marco = Marco.area,
  });
  final String titulo;
  final String texto;
  final Offset pos;
  final Marco marco;
}

class PreguntaQuiz {
  const PreguntaQuiz({
    required this.pregunta,
    required this.opciones,
    required this.correcta,
    required this.explicacion,
    this.tema = 'general',
  });
  final String pregunta;
  final List<String> opciones;
  final int correcta;
  final String explicacion;
  final String tema;
}

class EscenaTour {
  const EscenaTour({
    required this.titulo,
    required this.narracion,
    required this.anim,
    this.instruccion,
    this.puntos = const [],
    this.pregunta,
    this.sabiasQue,
  });
  final String titulo;
  final String narracion;
  final AnimTour anim;
  final String? instruccion;
  final List<PuntoInteres> puntos;
  final PreguntaQuiz? pregunta;
  final String? sabiasQue;
}

class CapituloTour {
  const CapituloTour({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.icono,
    required this.escenas,
  });
  final String id;
  final String titulo;
  final String subtitulo;
  final Color color;
  final IconData icono;
  final List<EscenaTour> escenas;
}

class Insignia {
  const Insignia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.icono,
    required this.color,
    this.requisitos = const [],
    this.estrellasMinimas = 0,
  });
  final String id;
  final String nombre;
  final String descripcion;
  final IconData icono;
  final Color color;
  final List<String> requisitos;
  final int estrellasMinimas;
}

class InfoOrgano {
  const InfoOrgano(this.nombre, this.sistema, this.descripcion, this.dato);
  final String nombre;
  final String sistema;
  final String descripcion;
  final String dato;
}

/// Posición (relativa a la silueta) de los órganos principales.
/// La usan el recorrido y el reto "Arma el cuerpo".
class PosicionOrgano {
  const PosicionOrgano(this.id, this.nombre, this.centro, this.tamano);
  final String id;
  final String nombre;
  final Offset centro;
  final Size tamano;
}

const posicionesOrganos = <PosicionOrgano>[
  PosicionOrgano('cerebro', 'Cerebro', Offset(0.5, 0.075), Size(0.22, 0.08)),
  PosicionOrgano('pulmones', 'Pulmones', Offset(0.5, 0.235), Size(0.44, 0.11)),
  PosicionOrgano('corazon', 'Corazón', Offset(0.55, 0.325), Size(0.17, 0.06)),
  PosicionOrgano('higado', 'Hígado', Offset(0.39, 0.395), Size(0.21, 0.06)),
  PosicionOrgano('estomago', 'Estómago', Offset(0.61, 0.395), Size(0.18, 0.06)),
  PosicionOrgano(
    'intestinos',
    'Intestinos',
    Offset(0.5, 0.48),
    Size(0.32, 0.09),
  ),
];

const infoOrganos = <String, InfoOrgano>{
  'auricula_der': InfoOrgano(
    'Aurícula derecha',
    'Corazón',
    'Cuarto de arriba a la derecha (del dueño del corazón). Recibe la sangre con poco oxígeno que regresa del cuerpo por las venas cavas.',
    'Las aurículas son más pequeñas y de paredes delgadas.',
  ),
  'auricula_izq': InfoOrgano(
    'Aurícula izquierda',
    'Corazón',
    'Cuarto de arriba a la izquierda. Recibe la sangre llena de oxígeno que llega de los pulmones.',
    'Le llega la sangre por las venas pulmonares.',
  ),
  'ventriculo_der': InfoOrgano(
    'Ventrículo derecho',
    'Corazón',
    'Cuarto de abajo a la derecha. Empuja la sangre hacia los pulmones por la arteria pulmonar.',
    'Solo necesita empujar la sangre hasta los pulmones, que están muy cerca.',
  ),
  'ventriculo_izq': InfoOrgano(
    'Ventrículo izquierdo',
    'Corazón',
    'El cuarto más fuerte. Empuja la sangre con oxígeno por la aorta hacia todo el cuerpo.',
    'Su pared es la más gruesa del corazón: ¡es su músculo más poderoso!',
  ),
  'valvulas': InfoOrgano(
    'Válvulas',
    'Corazón',
    'Puertitas que se abren para dejar pasar la sangre y se cierran para que no regrese.',
    'El “pum-pum” del corazón es el sonido de las válvulas al cerrarse.',
  ),
  'tabique': InfoOrgano(
    'Tabique',
    'Corazón',
    'Pared que separa el lado derecho del izquierdo para que la sangre con oxígeno y sin oxígeno no se mezclen.',
    'Gracias al tabique el corazón funciona como dos bombas al mismo tiempo.',
  ),
  'venas_pulmonares': InfoOrgano(
    'Venas pulmonares',
    'Sistema circulatorio',
    'Traen la sangre con oxígeno desde los pulmones hasta la aurícula izquierda.',
    'Son las únicas venas que llevan sangre rica en oxígeno.',
  ),
  'cerebro': InfoOrgano(
    'Cerebro',
    'Sistema nervioso',
    'Es el centro de control: ordena a los demás órganos qué hacer, incluso cuánto respirar y qué tan rápido late el corazón.',
    'Usa cerca del 20 % del oxígeno que respiras.',
  ),
  'pulmones': InfoOrgano(
    'Pulmones',
    'Sistema respiratorio',
    'Dos órganos esponjosos que se llenan de aire. Ahí el oxígeno pasa a la sangre y el dióxido de carbono sale.',
    'El pulmón izquierdo es un poco más pequeño para dejar espacio al corazón.',
  ),
  'corazon': InfoOrgano(
    'Corazón',
    'Sistema circulatorio',
    'Músculo del tamaño de tu puño que bombea la sangre por todo el cuerpo sin descansar.',
    'Late unas 100,000 veces al día.',
  ),
  'higado': InfoOrgano(
    'Hígado',
    'Sistema digestivo',
    'Limpia la sangre de sustancias dañinas, guarda energía y ayuda a digerir las grasas.',
    'Es el órgano interno más grande y puede regenerarse.',
  ),
  'estomago': InfoOrgano(
    'Estómago',
    'Sistema digestivo',
    'Bolsa muscular que mezcla la comida con jugos ácidos. ¡Ese ácido también destruye muchos microbios!',
    'Puede estirarse para guardar más de un litro de comida.',
  ),
  'intestinos': InfoOrgano(
    'Intestinos',
    'Sistema digestivo',
    'Tubos largos donde los nutrientes de la comida pasan a la sangre para viajar a todo el cuerpo.',
    'El intestino delgado mide unos 6 metros.',
  ),
  // Modelos 3D
  'aorta': InfoOrgano(
    'Arteria aorta',
    'Sistema circulatorio',
    'La arteria más grande. Lleva la sangre rica en oxígeno desde el ventrículo izquierdo hacia todo el cuerpo.',
    'Es casi tan ancha como una manguera de jardín.',
  ),
  'cavas': InfoOrgano(
    'Venas cavas',
    'Sistema circulatorio',
    'Dos venas grandes que regresan al corazón la sangre con poco oxígeno que viene del cuerpo.',
    'La vena cava inferior trae la sangre de las piernas y el abdomen.',
  ),
  'pulmonar': InfoOrgano(
    'Arteria pulmonar',
    'Sistema circulatorio',
    'Lleva la sangre con poco oxígeno del corazón a los pulmones para que se “recargue”.',
    'Es la única arteria que transporta sangre pobre en oxígeno.',
  ),
  'traquea': InfoOrgano(
    'Tráquea',
    'Sistema respiratorio',
    'Tubo reforzado con anillos de cartílago que lleva el aire de la garganta a los bronquios.',
    'Sus anillos tienen forma de “C” y evitan que se aplaste.',
  ),
  'bronquios': InfoOrgano(
    'Bronquios',
    'Sistema respiratorio',
    'La tráquea se divide en dos bronquios, uno para cada pulmón; luego se ramifican como un árbol.',
    'Las ramitas más pequeñas se llaman bronquiolos.',
  ),
  'diafragma': InfoOrgano(
    'Diafragma',
    'Sistema respiratorio',
    'Músculo con forma de cúpula debajo de los pulmones. Al bajar, el aire entra; al subir, el aire sale.',
    'El hipo ocurre cuando el diafragma se contrae de golpe.',
  ),
  'globulo_blanco': InfoOrgano(
    'Glóbulo blanco',
    'Sistema inmunológico',
    'Célula defensora que patrulla la sangre buscando microbios para destruirlos.',
    'Algunos pueden salir de los vasos sanguíneos para perseguir microbios.',
  ),
  'globulo_rojo': InfoOrgano(
    'Glóbulo rojo',
    'Sistema circulatorio',
    'Célula con forma de dona aplastada que transporta oxígeno gracias a la hemoglobina.',
    'Tienes unos 25 billones de glóbulos rojos.',
  ),
  'virus': InfoOrgano(
    'Virus',
    'Invasor',
    'Microbio diminuto que entra en tus células para multiplicarse. Puede causar gripe o resfriado.',
    'Es tan pequeño que solo se ve con microscopios electrónicos.',
  ),
  'anticuerpo': InfoOrgano(
    'Anticuerpo',
    'Sistema inmunológico',
    'Proteína con forma de “Y” que fabrican los linfocitos. Se pega a los microbios y los marca para destruirlos.',
    'Cada anticuerpo reconoce a un solo tipo de microbio, como una llave a su cerradura.',
  ),
  'plaqueta': InfoOrgano(
    'Plaqueta',
    'Sistema circulatorio',
    'Fragmento de célula que tapa las heridas formando una costra (coágulo).',
    'Viven solo de 7 a 10 días.',
  ),
};

// ---------------------------------------------------------------------------
// Recorrido interactivo
// ---------------------------------------------------------------------------

const _cIntro = Color(0xFFFF8A00);
const _cCirc = Color(0xFFFF3D68);
const _cResp = Color(0xFF00A6FB);
const _cInm = Color(0xFF8B5CF6);

const capitulosTour = <CapituloTour>[
  CapituloTour(
    id: Actividades.tourIntro,
    titulo: 'El cuerpo humano',
    subtitulo: 'Un gran equipo',
    color: _cIntro,
    icono: Icons.accessibility_new_rounded,
    escenas: [
      EscenaTour(
        titulo: '¿Qué es el cuerpo humano?',
        narracion:
            'Nuestro cuerpo está formado por muchos órganos que trabajan juntos en sistemas.\n\nHoy conoceremos tres de ellos: el circulatorio, el respiratorio y el inmunológico.',
        anim: AnimTour.queEsCuerpo,
        instruccion: 'Toca cada sistema para conocerlo.',
        puntos: [
          PuntoInteres(
            'Sistema circulatorio',
            'El corazón bombea la sangre por arterias y venas para llevar oxígeno y nutrientes a todo el cuerpo.',
            Offset(0.955, 0.12),
          ),
          PuntoInteres(
            'Sistema respiratorio',
            'La nariz, la tráquea y los pulmones toman el oxígeno del aire y sacan el dióxido de carbono.',
            Offset(0.955, 0.42),
          ),
          PuntoInteres(
            'Sistema inmunológico',
            'Los glóbulos blancos, los ganglios y los anticuerpos defienden al cuerpo de los microbios.',
            Offset(0.955, 0.72),
          ),
        ],
      ),
      EscenaTour(
        titulo: 'De la célula al organismo',
        narracion:
            'Tu cuerpo está hecho de billones de células. Muchas células iguales forman un tejido; varios tejidos forman un órgano; los órganos que trabajan juntos forman un sistema, y todos los sistemas forman tu organismo.',
        anim: AnimTour.niveles,
        instruccion: 'Toca la animación para avanzar de nivel.',
        sabiasQue: 'Tu cuerpo tiene alrededor de 30 billones de células.',
      ),
      EscenaTour(
        titulo: 'Los órganos principales',
        narracion:
            'Un órgano es una parte del cuerpo con una forma y un trabajo especial. Toca cada órgano para descubrir qué hace.',
        anim: AnimTour.organos,
        instruccion: 'Toca los puntos brillantes.',
        puntos: [
          PuntoInteres(
            'Cerebro',
            'Controla todo tu cuerpo: tus movimientos, tus pensamientos y hasta tu respiración.',
            Offset(0.5, 0.075),
            marco: Marco.silueta,
          ),
          PuntoInteres(
            'Pulmones',
            'Toman el oxígeno del aire y sacan el dióxido de carbono.',
            Offset(0.36, 0.235),
            marco: Marco.silueta,
          ),
          PuntoInteres(
            'Corazón',
            'Bombea la sangre para que llegue a cada rincón del cuerpo.',
            Offset(0.56, 0.32),
            marco: Marco.silueta,
          ),
          PuntoInteres(
            'Hígado',
            'Limpia la sangre y guarda energía.',
            Offset(0.39, 0.395),
            marco: Marco.silueta,
          ),
          PuntoInteres(
            'Estómago',
            'Deshace la comida con jugos ácidos.',
            Offset(0.62, 0.395),
            marco: Marco.silueta,
          ),
          PuntoInteres(
            'Intestinos',
            'Absorben los nutrientes de la comida.',
            Offset(0.5, 0.48),
            marco: Marco.silueta,
          ),
        ],
      ),
      EscenaTour(
        titulo: 'Sistemas que trabajan en equipo',
        narracion:
            'El sistema respiratorio toma el oxígeno, el circulatorio lo reparte en la sangre y el inmunológico protege a todos de los microbios. ¡Ninguno trabaja solo!',
        anim: AnimTour.sistemasEquipo,
        instruccion: 'Activa cada sistema con los botones.',
        pregunta: PreguntaQuiz(
          pregunta: '¿Qué es un sistema del cuerpo?',
          opciones: [
            'Un grupo de órganos que trabajan juntos',
            'Una sola célula muy grande',
            'Un hueso del esqueleto',
          ],
          correcta: 0,
          explicacion:
              'Un sistema es un equipo de órganos que cumplen juntos una función, como respirar o repartir la sangre.',
        ),
      ),
      EscenaTour(
        titulo: '¡A restaurar la Estación!',
        narracion:
            'En la Estación del Cuerpo Humano se apagaron tres sistemas. ¡Cada misión que completes encenderá uno!\n\nEmpezaremos por el sistema circulatorio: ¡el corazón en acción!',
        anim: AnimTour.estacion,
        sabiasQue:
            'Los científicos también investigan paso a paso: observan, preguntan y experimentan.',
      ),
    ],
  ),
  CapituloTour(
    id: Actividades.tourCirculatorio,
    titulo: 'Sistema circulatorio',
    subtitulo: 'El corazón y la sangre',
    color: _cCirc,
    icono: Icons.favorite_rounded,
    escenas: [
      EscenaTour(
        titulo: 'El corazón: una bomba con 4 cuartos',
        narracion:
            'El corazón es un músculo hueco dividido en cuatro cavidades: dos aurículas arriba, que reciben la sangre, y dos ventrículos abajo, que la empujan hacia fuera. Las válvulas funcionan como puertas que solo abren en un sentido.',
        anim: AnimTour.corazon,
        instruccion: 'Mueve el control para cambiar la velocidad del latido.',
        puntos: [
          PuntoInteres(
            'Aurícula derecha',
            'Recibe la sangre con poco oxígeno que regresa del cuerpo por las venas cavas.',
            Offset(0.39, 0.37),
          ),
          PuntoInteres(
            'Ventrículo derecho',
            'Empuja la sangre hacia los pulmones para que tome oxígeno.',
            Offset(0.41, 0.68),
          ),
          PuntoInteres(
            'Aurícula izquierda',
            'Recibe la sangre llena de oxígeno que viene de los pulmones.',
            Offset(0.61, 0.37),
          ),
          PuntoInteres(
            'Ventrículo izquierdo',
            'Es la cavidad más fuerte: empuja la sangre por la aorta hacia todo el cuerpo.',
            Offset(0.59, 0.68),
          ),
          PuntoInteres(
            'Válvulas',
            'Son como puertas de un solo sentido. El “pum-pum” que escuchas es el sonido de las válvulas al cerrarse.',
            Offset(0.5, 0.52),
          ),
        ],
        sabiasQue:
            'En un niño en reposo el corazón late entre 70 y 110 veces por minuto.',
      ),
      EscenaTour(
        titulo: 'El gran viaje de la sangre',
        narracion:
            'La sangre hace dos viajes. En el circuito pequeño va del corazón a los pulmones y regresa con oxígeno. En el circuito grande sale del corazón por las arterias, llega a todo el cuerpo por los capilares y regresa por las venas.',
        anim: AnimTour.circuito,
        instruccion:
            'Observa cómo cambia el color de la sangre y toca los puntos.',
        puntos: [
          PuntoInteres(
            'Pulmones',
            'Aquí la sangre suelta el dióxido de carbono y se carga de oxígeno: cambia de rojo oscuro a rojo brillante.',
            Offset(0.5, 0.13),
          ),
          PuntoInteres(
            'Corazón',
            'Bombea los dos circuitos al mismo tiempo: el lado derecho hacia los pulmones y el izquierdo hacia el cuerpo.',
            Offset(0.5, 0.5),
          ),
          PuntoInteres(
            'Arterias',
            'Vasos de paredes gruesas que llevan la sangre DESDE el corazón.',
            Offset(0.8, 0.66),
          ),
          PuntoInteres(
            'Venas',
            'Vasos que REGRESAN la sangre al corazón. Tienen válvulas para que la sangre no vaya hacia atrás.',
            Offset(0.2, 0.66),
          ),
          PuntoInteres(
            'Capilares',
            'Vasos finísimos, más delgados que un cabello. Ahí la sangre entrega oxígeno y nutrientes a las células.',
            Offset(0.5, 0.88),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta:
              '¿Qué vasos sanguíneos llevan la sangre desde el corazón hacia el cuerpo?',
          opciones: ['Las venas', 'Las arterias', 'Los bronquios'],
          correcta: 1,
          explicacion:
              'Las arterias salen del corazón; las venas regresan a él.',
        ),
      ),
      EscenaTour(
        titulo: '¿De qué está hecha la sangre?',
        narracion:
            'Si dejamos reposar sangre en un tubo, se separa en capas: el plasma (líquido amarillento), los glóbulos blancos y plaquetas (una capa delgada) y los glóbulos rojos (abajo).',
        anim: AnimTour.sangre,
        instruccion: 'Toca cada componente.',
        puntos: [
          PuntoInteres(
            'Plasma',
            'Es más de la mitad de la sangre. Está hecho casi todo de agua y transporta nutrientes, sales y desechos.',
            Offset(0.2, 0.3),
          ),
          PuntoInteres(
            'Glóbulo rojo',
            'Transporta el oxígeno. Es rojo por una proteína llamada hemoglobina.',
            Offset(0.58, 0.3),
          ),
          PuntoInteres(
            'Glóbulo blanco',
            'Es un soldado del sistema inmunológico: ataca a los microbios.',
            Offset(0.83, 0.32),
          ),
          PuntoInteres(
            'Plaquetas',
            'Pedacitos de célula que se juntan para tapar heridas y formar costras.',
            Offset(0.62, 0.74),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta: '¿Qué parte de la sangre transporta el oxígeno?',
          opciones: ['Las plaquetas', 'El plasma', 'Los glóbulos rojos'],
          correcta: 2,
          explicacion:
              'Los glóbulos rojos llevan el oxígeno pegado a la hemoglobina.',
        ),
        sabiasQue: 'Un adulto tiene alrededor de 5 litros de sangre.',
      ),
    ],
  ),
  CapituloTour(
    id: Actividades.tourRespiratorio,
    titulo: 'Sistema respiratorio',
    subtitulo: 'El viaje del aire',
    color: _cResp,
    icono: Icons.air_rounded,
    escenas: [
      EscenaTour(
        titulo: 'El camino del aire',
        narracion:
            'El aire entra por la nariz, donde se limpia, se calienta y se humedece. Pasa por la faringe y la laringe (donde están tus cuerdas vocales), baja por la tráquea, se divide en los bronquios y llega a los pulmones.',
        anim: AnimTour.viaAire,
        instruccion: 'Sigue a la burbuja de aire y toca cada parte.',
        puntos: [
          PuntoInteres(
            'Nariz',
            'Sus vellos y su moco atrapan polvo y microbios. También calienta el aire.',
            Offset(0.5, 0.13),
          ),
          PuntoInteres(
            'Laringe',
            'Aquí están las cuerdas vocales: vibran con el aire y producen tu voz.',
            Offset(0.5, 0.29),
          ),
          PuntoInteres(
            'Tráquea',
            'Tubo con anillos de cartílago que lleva el aire hacia el pecho.',
            Offset(0.5, 0.45),
          ),
          PuntoInteres(
            'Bronquios',
            'Dos ramas, una para cada pulmón, que se dividen en tubitos cada vez más finos.',
            Offset(0.6, 0.62),
          ),
          PuntoInteres(
            'Pulmones',
            'Órganos esponjosos llenos de millones de bolsitas de aire llamadas alvéolos.',
            Offset(0.34, 0.8),
          ),
        ],
      ),
      EscenaTour(
        titulo: 'Inhalar y exhalar',
        narracion:
            'Al inhalar, el diafragma baja y las costillas se abren: los pulmones se inflan y el aire entra. Al exhalar, el diafragma sube y el aire sale con dióxido de carbono.',
        anim: AnimTour.diafragma,
        instruccion: 'Mantén presionado “Inhalar” y luego suelta para exhalar.',
        puntos: [
          PuntoInteres(
            'Diafragma',
            'Músculo en forma de cúpula. Es el principal músculo de la respiración.',
            Offset(0.5, 0.91),
          ),
          PuntoInteres(
            'Costillas',
            'Protegen a los pulmones y al corazón como una jaula, y se mueven al respirar.',
            Offset(0.23, 0.42),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta: '¿Qué hace el diafragma cuando inhalamos?',
          opciones: ['Sube', 'Baja', 'Se queda quieto'],
          correcta: 1,
          explicacion:
              'Al bajar, deja más espacio en el pecho y el aire entra a los pulmones.',
        ),
      ),
      EscenaTour(
        titulo: 'Los alvéolos: donde todo se conecta',
        narracion:
            'Al final de los bronquiolos hay alvéolos, bolsitas rodeadas de capilares. El oxígeno pasa del aire a la sangre y el dióxido de carbono pasa de la sangre al aire. ¡Aquí se unen el sistema respiratorio y el circulatorio!',
        anim: AnimTour.alveolo,
        puntos: [
          PuntoInteres(
            'Alvéolo',
            'Bolsita de aire de paredes delgadísimas. Tienes cientos de millones.',
            Offset(0.36, 0.5),
          ),
          PuntoInteres(
            'Capilar',
            'Vaso finito por donde pasan los glóbulos rojos en fila.',
            Offset(0.79, 0.25),
          ),
          PuntoInteres(
            'Oxígeno (O₂)',
            'Entra a la sangre y los glóbulos rojos lo llevan a todas tus células.',
            Offset(0.6, 0.38),
          ),
          PuntoInteres(
            'Dióxido de carbono (CO₂)',
            'Desecho de las células. Sale de la sangre al alvéolo y lo exhalas.',
            Offset(0.6, 0.66),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta:
              '¿Qué gas pasa de la sangre a los alvéolos para ser exhalado?',
          opciones: ['Oxígeno', 'Dióxido de carbono', 'Nitrógeno'],
          correcta: 1,
          explicacion:
              'Las células producen dióxido de carbono como desecho y lo eliminamos al exhalar.',
        ),
        sabiasQue:
            'Si extendieras todos tus alvéolos, cubrirían casi media cancha de tenis.',
      ),
    ],
  ),
  CapituloTour(
    id: Actividades.tourInmune,
    titulo: 'Sistema inmunológico',
    subtitulo: 'Tu ejército de defensa',
    color: _cInm,
    icono: Icons.shield_rounded,
    escenas: [
      EscenaTour(
        titulo: 'Las primeras barreras',
        narracion:
            'Antes de entrar, los microbios deben pasar barreras: la piel, las lágrimas, el moco y los vellos de la nariz, la saliva y el ácido del estómago.',
        anim: AnimTour.barreras,
        instruccion: 'Toca cada barrera.',
        puntos: [
          PuntoInteres(
            'Lágrimas',
            'Limpian los ojos y tienen sustancias que destruyen bacterias.',
            Offset(0.19, 0.37),
          ),
          PuntoInteres(
            'Nariz',
            'Los vellos y el moco atrapan polvo y microbios. ¡Por eso estornudas!',
            Offset(0.28, 0.47),
          ),
          PuntoInteres(
            'Saliva',
            'Arrastra microbios y contiene sustancias que los atacan.',
            Offset(0.28, 0.62),
          ),
          PuntoInteres(
            'Piel',
            'Es como una muralla: si no tiene heridas, casi ningún microbio puede atravesarla.',
            Offset(0.76, 0.28),
          ),
          PuntoInteres(
            'Ácido del estómago',
            'Destruye muchos microbios que tragamos con la comida.',
            Offset(0.76, 0.76),
          ),
        ],
      ),
      EscenaTour(
        titulo: 'Los glóbulos blancos atacan',
        narracion:
            'Si un microbio logra entrar, los glóbulos blancos llegan a atacar. Los fagocitos persiguen a los microbios y se los “comen”. A veces la zona se inflama o sube la temperatura (fiebre): son señales de que tu cuerpo está luchando.',
        anim: AnimTour.fagocito,
        instruccion: 'Toca la pantalla para guiar al fagocito.',
        sabiasQue:
            'Tu médula ósea fabrica millones de glóbulos blancos cada día.',
      ),
      EscenaTour(
        titulo: 'Anticuerpos: etiquetas para microbios',
        narracion:
            'Los linfocitos fabrican anticuerpos, proteínas con forma de “Y” que se pegan a un microbio específico. Así lo marcan para que los fagocitos lo encuentren y lo destruyan.',
        anim: AnimTour.anticuerpos,
        puntos: [
          PuntoInteres(
            'Linfocito',
            'Glóbulo blanco que fabrica anticuerpos y “recuerda” a los microbios.',
            Offset(0.16, 0.5),
          ),
          PuntoInteres(
            'Virus marcado',
            'Los anticuerpos se pegan a él como etiquetas.',
            Offset(0.66, 0.5),
          ),
          PuntoInteres(
            'Fagocito',
            'Encuentra a los microbios marcados y se los come.',
            Offset(0.88, 0.78),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta: '¿Qué forma tienen los anticuerpos?',
          opciones: ['De estrella', 'De “Y”', 'De espiral'],
          correcta: 1,
          explicacion:
              'Los anticuerpos tienen forma de “Y”; sus puntas se pegan al microbio.',
        ),
      ),
      EscenaTour(
        titulo: 'Las vacunas entrenan a tu cuerpo',
        narracion:
            'Una vacuna tiene microbios debilitados, muertos o solo una parte de ellos. Tu cuerpo aprende a reconocerlos sin enfermarte y guarda “células de memoria”. Si el microbio real llega, ¡tus defensas ya están listas!',
        anim: AnimTour.vacuna,
        puntos: [
          PuntoInteres(
            '1. La vacuna',
            'Contiene una versión inofensiva del microbio.',
            Offset(0.18, 0.45),
          ),
          PuntoInteres(
            '2. Entrenamiento',
            'Los linfocitos aprenden a fabricar los anticuerpos correctos y guardan memoria.',
            Offset(0.5, 0.45),
          ),
          PuntoInteres(
            '3. Protección',
            'Si el microbio verdadero llega, el cuerpo lo vence rápido.',
            Offset(0.82, 0.45),
          ),
        ],
        pregunta: PreguntaQuiz(
          pregunta: '¿Para qué sirven las vacunas?',
          opciones: [
            'Para enseñar al cuerpo a reconocer un microbio',
            'Para que el corazón lata más rápido',
            'Para hacer crecer los huesos',
          ],
          correcta: 0,
          explicacion:
              'Las vacunas entrenan al sistema inmunológico sin que tengas que enfermarte.',
        ),
      ),
      EscenaTour(
        titulo: 'Cuida tus sistemas',
        narracion:
            'Tus sistemas trabajan mejor si los cuidas: haz ejercicio, come frutas y verduras, toma agua, duerme bien, lávate las manos y no te acerques al humo del cigarro.',
        anim: AnimTour.habitos,
        instruccion: 'Toca cada tarjeta para descubrir a qué sistema ayuda.',
        pregunta: PreguntaQuiz(
          pregunta: '¿Qué hábito protege mejor a tus pulmones?',
          opciones: [
            'Respirar humo de cigarro',
            'Evitar el humo y hacer ejercicio',
            'No dormir',
          ],
          correcta: 1,
          explicacion:
              'El humo daña los alvéolos; el ejercicio fortalece pulmones y corazón.',
        ),
      ),
    ],
  ),
];

// ---------------------------------------------------------------------------
// Banco de preguntas del reto "Supercerebro"
// ---------------------------------------------------------------------------

const bancoPreguntas = <PreguntaQuiz>[
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Cuántas cavidades tiene el corazón?',
    opciones: ['2', '4', '6', '8'],
    correcta: 1,
    explicacion: 'Dos aurículas y dos ventrículos.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Qué vasos regresan la sangre al corazón?',
    opciones: ['Arterias', 'Venas', 'Bronquios', 'Alvéolos'],
    correcta: 1,
    explicacion: 'Las venas regresan la sangre al corazón.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Cuál es la arteria más grande del cuerpo?',
    opciones: ['La aorta', 'La tráquea', 'La vena cava', 'El capilar'],
    correcta: 0,
    explicacion:
        'La aorta sale del ventrículo izquierdo y reparte la sangre a todo el cuerpo.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Qué componente de la sangre ayuda a cerrar las heridas?',
    opciones: ['Plasma', 'Glóbulos rojos', 'Plaquetas', 'Oxígeno'],
    correcta: 2,
    explicacion: 'Las plaquetas forman un tapón llamado coágulo.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Por qué late más rápido tu corazón cuando corres?',
    opciones: [
      'Porque los músculos necesitan más oxígeno',
      'Porque tiene frío',
      'Porque se cansa',
      'Porque tienes hambre',
    ],
    correcta: 0,
    explicacion:
        'Los músculos trabajan más y necesitan más oxígeno y nutrientes.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Cuáles son los vasos sanguíneos más delgados?',
    opciones: ['Arterias', 'Venas', 'Capilares', 'Aorta'],
    correcta: 2,
    explicacion:
        'Los capilares son más delgados que un cabello y llegan a todas las células.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Qué lado del corazón envía la sangre a los pulmones?',
    opciones: ['El derecho', 'El izquierdo', 'Ninguno', 'Ambos a la vez'],
    correcta: 0,
    explicacion: 'El ventrículo derecho bombea la sangre hacia los pulmones.',
  ),
  PreguntaQuiz(
    tema: 'circulatorio',
    pregunta: '¿Dónde está el corazón?',
    opciones: [
      'En el abdomen',
      'En el pecho, entre los pulmones',
      'En la cabeza',
      'En la espalda baja',
    ],
    correcta: 1,
    explicacion:
        'Está en el centro del pecho, un poco inclinado a la izquierda.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Qué gas necesitan nuestras células para obtener energía?',
    opciones: ['Dióxido de carbono', 'Oxígeno', 'Helio', 'Humo'],
    correcta: 1,
    explicacion:
        'Las células usan oxígeno para “quemar” los nutrientes y obtener energía.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Cómo se llaman las bolsitas de aire de los pulmones?',
    opciones: ['Bronquios', 'Alvéolos', 'Capilares', 'Ventrículos'],
    correcta: 1,
    explicacion: 'Los alvéolos son donde ocurre el intercambio de gases.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿En qué órgano están las cuerdas vocales?',
    opciones: ['Tráquea', 'Laringe', 'Pulmón', 'Nariz'],
    correcta: 1,
    explicacion: 'La laringe contiene las cuerdas vocales.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Qué músculo es el principal responsable de la respiración?',
    opciones: ['Bíceps', 'Corazón', 'Diafragma', 'Estómago'],
    correcta: 2,
    explicacion: 'El diafragma baja al inhalar y sube al exhalar.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Por qué es mejor respirar por la nariz que por la boca?',
    opciones: [
      'Porque la nariz filtra, calienta y humedece el aire',
      'Porque es más rápido',
      'Porque la boca no tiene aire',
      'No hay diferencia',
    ],
    correcta: 0,
    explicacion: 'La nariz prepara el aire antes de que llegue a los pulmones.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Qué tubo lleva el aire de la garganta a los bronquios?',
    opciones: ['Esófago', 'Tráquea', 'Aorta', 'Intestino'],
    correcta: 1,
    explicacion:
        'La tráquea tiene anillos de cartílago que la mantienen abierta.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Qué daña más a los pulmones?',
    opciones: [
      'Hacer ejercicio',
      'El humo del cigarro',
      'Cantar',
      'Tomar agua',
    ],
    correcta: 1,
    explicacion: 'El humo destruye los alvéolos y ensucia los bronquios.',
  ),
  PreguntaQuiz(
    tema: 'respiratorio',
    pregunta: '¿Qué sistema recibe el oxígeno de los pulmones para repartirlo?',
    opciones: ['Digestivo', 'Circulatorio', 'Óseo', 'Nervioso'],
    correcta: 1,
    explicacion:
        'La sangre del sistema circulatorio lleva el oxígeno a todo el cuerpo.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Cuál es la primera barrera contra los microbios?',
    opciones: ['La piel', 'El corazón', 'Los huesos', 'El cabello largo'],
    correcta: 0,
    explicacion:
        'La piel sana funciona como una muralla que impide la entrada de microbios.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Qué células defienden al cuerpo de los microbios?',
    opciones: ['Glóbulos rojos', 'Glóbulos blancos', 'Plaquetas', 'Neuronas'],
    correcta: 1,
    explicacion: 'Los glóbulos blancos son el ejército del cuerpo.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Qué hacen los fagocitos?',
    opciones: [
      'Transportan oxígeno',
      'Se “comen” a los microbios',
      'Producen saliva',
      'Mueven los huesos',
    ],
    correcta: 1,
    explicacion: 'Fagocito significa “célula que come”.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Qué contiene una vacuna?',
    opciones: [
      'Microbios debilitados, muertos o partes de ellos',
      'Vitaminas solamente',
      'Azúcar',
      'Glóbulos rojos',
    ],
    correcta: 0,
    explicacion:
        'Así el cuerpo aprende a reconocer al microbio sin enfermarse.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Por qué la fiebre puede ser útil?',
    opciones: [
      'Ayuda al cuerpo a combatir microbios',
      'Hace crecer el cabello',
      'Enfría el cuerpo',
      'No sirve para nada',
    ],
    correcta: 0,
    explicacion:
        'La temperatura alta dificulta que muchos microbios se multipliquen. Aun así, avisa a un adulto si tienes fiebre.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Cuál es el mejor hábito para evitar infecciones?',
    opciones: [
      'Lavarse las manos con agua y jabón',
      'Compartir cubiertos',
      'Tocarse los ojos',
      'Dormir poco',
    ],
    correcta: 0,
    explicacion: 'El jabón elimina muchos microbios de las manos.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Qué fabrican los linfocitos?',
    opciones: ['Anticuerpos', 'Oxígeno', 'Saliva', 'Hormonas del sueño'],
    correcta: 0,
    explicacion: 'Los anticuerpos marcan a los microbios para destruirlos.',
  ),
  PreguntaQuiz(
    tema: 'inmune',
    pregunta: '¿Dónde se fabrican las células de la sangre?',
    opciones: [
      'En la médula ósea',
      'En el estómago',
      'En los pulmones',
      'En la piel',
    ],
    correcta: 0,
    explicacion:
        'La médula ósea, dentro de los huesos, fabrica glóbulos rojos, blancos y plaquetas.',
  ),
  PreguntaQuiz(
    tema: 'general',
    pregunta: '¿Qué forman varios órganos que trabajan juntos?',
    opciones: ['Una célula', 'Un tejido', 'Un sistema', 'Un átomo'],
    correcta: 2,
    explicacion: 'Célula → tejido → órgano → sistema → organismo.',
  ),
];

// ---------------------------------------------------------------------------
// Insignias
// ---------------------------------------------------------------------------

const insigniasJuego = <Insignia>[
  Insignia(
    id: 'guardian_corazon',
    nombre: 'Guardián del corazón',
    descripcion: 'Vasos sanguíneos + laboratorio del corazón + mini misión.',
    icono: Icons.favorite_rounded,
    color: _cCirc,
    requisitos: [Actividades.m1Vasos, Actividades.m1Lab, Actividades.m1Mini],
  ),
  Insignia(
    id: 'super_pulmones',
    nombre: 'Súper pulmones',
    descripcion: 'Recorrido respiratorio + modelo de pulmón + pulmones 3D.',
    icono: Icons.air_rounded,
    color: _cResp,
    requisitos: [
      Actividades.tourRespiratorio,
      Actividades.labPulmon,
      Actividades.simPulmones,
    ],
  ),
  Insignia(
    id: 'defensor',
    nombre: 'Defensor inmune',
    descripcion: 'Recorrido inmune + laboratorio de vacunas + defensa inmune.',
    icono: Icons.shield_rounded,
    color: _cInm,
    requisitos: [
      Actividades.tourInmune,
      Actividades.labVacunas,
      Actividades.retoDefensa,
    ],
  ),
  Insignia(
    id: 'cientifico',
    nombre: 'Científico de laboratorio',
    descripcion: 'Completa los 4 experimentos.',
    icono: Icons.science_rounded,
    color: Color(0xFF00897B),
    requisitos: [
      Actividades.labPulso,
      Actividades.labPulmon,
      Actividades.labMicroscopio,
      Actividades.labVacunas,
    ],
  ),
  Insignia(
    id: 'explorador_3d',
    nombre: 'Explorador 3D',
    descripcion: 'Explora las 4 simulaciones 3D.',
    icono: Icons.view_in_ar_rounded,
    color: Color(0xFF3D5AFE),
    requisitos: [
      Actividades.simCorazon,
      Actividades.simPulmones,
      Actividades.simCuerpo,
      Actividades.simInmune,
    ],
  ),
  Insignia(
    id: 'maestro',
    nombre: 'Maestro del cuerpo humano',
    descripcion: 'Reúne 40 estrellas.',
    icono: Icons.emoji_events_rounded,
    color: Color(0xFFFFB300),
    estrellasMinimas: 40,
  ),
];
