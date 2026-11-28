/// “Piensa antes de empezar”: antes de una simulación o un experimento el
/// alumno responde qué cree que va a pasar. No se califica: es su hipótesis.
/// Después de experimentar puede comparar su idea con lo que en verdad pasa.
///
/// En [opciones] la respuesta correcta es la de [correcta]; en pantalla las
/// opciones se muestran mezcladas.
class Prediccion {
  const Prediccion(this.pregunta, this.opciones, this.porque, {this.correcta = 0});
  final String pregunta;
  final List<String> opciones;
  final int correcta;

  /// Lo que en verdad pasa, explicado para niños.
  final String porque;
}

/// Predicciones por id de paso (simulaciones y experimentos de todos los mundos).
const predicciones = <String, Prediccion>{
  // ---------------- Biología ----------------
  't2_m1_micro': Prediccion(
      'Si miras un pedacito de piel de cebolla con un microscopio, ¿qué crees que verás?',
      ['Muchas celditas pegadas, como ladrillos', 'Nada: por dentro está vacía', 'Animalitos nadando'],
      'Todos los seres vivos están hechos de células. En la cebolla se ven como ladrillitos acomodados uno junto a otro.'),
  't3_m2_plato': Prediccion(
      '¿Qué crees que debe tener un plato de comida saludable?',
      ['Verduras, frutas, cereales y un poco de proteína', 'Solo carne', 'Solo pan y dulces'],
      'Un plato saludable combina varios grupos de alimentos: así tu cuerpo recibe todo lo que necesita.'),
  't3_m3_lab': Prediccion('¿Qué bebida crees que tiene más azúcar?', ['Un refresco', 'Un vaso de agua natural', 'Un vaso de leche sin azúcar'],
      'Muchos refrescos tienen muchísimas cucharaditas de azúcar escondida. El agua natural no tiene nada.'),
  't4_m2_foto': Prediccion(
      '¿Qué crees que necesita una planta para fabricar su propio alimento?',
      ['Luz del Sol, agua y aire', 'Solo tierra', 'Comer insectos'],
      'Con la luz del Sol, el agua y un gas del aire (dióxido de carbono), la planta fabrica su alimento en sus hojas. A eso se le llama fotosíntesis.'),
  't4_m2_lab': Prediccion('Si una planta se queda sin luz varios días, ¿qué crees que le pasará?',
      ['Se debilita y se pone amarilla', 'Crece más rápido', 'No le pasa nada'], 'Sin luz la planta no puede fabricar su alimento, así que se debilita.'),
  't5_m2_sim': Prediccion(
      'Si en un bosque desaparecen los conejos, ¿qué crees que les pasará a los zorros que se los comen?',
      ['Tendrán menos comida y habrá menos zorros', 'Habrá más zorros', 'No les pasa nada'],
      'En un ecosistema todos están conectados: si falta un ser vivo, los que dependen de él también se afectan.'),

  // ---------------- Química ----------------
  'q1_m2_lab': Prediccion('Si echas agua sobre una tela, un papel y un plástico, ¿cuál crees que NO deja pasar el agua?',
      ['El plástico', 'El papel', 'La tela'], 'El plástico es impermeable: no deja pasar el agua. Por eso se usa para hacer impermeables y botellas.'),
  'q2_m2_sim': Prediccion(
      'Si tapas la punta de una jeringa llena de aire y empujas el émbolo, ¿qué crees que pasará?',
      ['El aire se aprieta y ocupa menos espacio', 'El aire desaparece', 'El émbolo no se mueve nada'],
      'Las partículas de un gas están muy separadas, por eso el gas se puede apretar (comprimir).'),
  'q3_m1_lab': Prediccion(
      'Si derrites chocolate y luego lo dejas enfriar, ¿qué crees que pasará?',
      ['Vuelve a ser chocolate sólido', 'Se convierte en otra cosa', 'Se vuelve gas'],
      'Derretirse es un cambio temporal (físico): el chocolate sigue siendo chocolate y puede volver a ser sólido.'),
  'q4_m2_sim': Prediccion('¿Dónde crees que una fruta cortada dura más tiempo sin echarse a perder?',
      ['En el refrigerador', 'Al sol', 'En una bolsa en un lugar caliente'], 'El frío hace que los microbios que descomponen la comida trabajen más despacio.'),
  'q5_m1_sim': Prediccion(
      'Si tapas una vela encendida con un vaso, ¿qué crees que pasará?',
      ['Se apaga porque se acaba el oxígeno', 'Brilla más fuerte', 'Sigue encendida para siempre'],
      'El fuego necesita combustible, calor y oxígeno. Dentro del vaso el oxígeno se acaba y la llama se apaga.'),
  'q5_m2_lab': Prediccion('¿Qué crees que necesita un clavo de hierro para oxidarse?', ['Agua y aire (oxígeno)', 'Estar en la oscuridad', 'Mucho frío'],
      'El óxido aparece cuando el hierro está en contacto con el agua y el oxígeno del aire.'),

  // ---------------- Física ----------------
  'f1_m1_sim': Prediccion('Si acercas el polo norte de un imán al polo norte de otro imán, ¿qué crees que pasará?',
      ['Se empujan (se repelen)', 'Se pegan', 'No pasa nada'], 'Polos iguales se repelen y polos distintos se atraen.'),
  'f1_m2_lab': Prediccion('¿Qué crees que atrae un imán?', ['Algunos metales, como el hierro', 'Todo lo que toca', 'La madera y el plástico'],
      'El imán atrae al hierro y a algunos otros metales, pero no a todos. La madera y el plástico no los atrae.'),
  'f2_m2_sim': Prediccion(
      'En la Luna no hay aire. Si sueltas una pluma y una piedra al mismo tiempo, ¿cuál crees que cae primero?',
      ['Caen al mismo tiempo', 'La piedra', 'La pluma'],
      'La gravedad jala igual a todos los objetos. En la Tierra el aire frena a la pluma, pero en la Luna no hay aire.'),
  'f3_m2_sim': Prediccion(
      'Si dejas una cuchara de metal dentro de una sopa caliente, ¿qué crees que le pasará al mango?',
      ['Se calienta poco a poco', 'Se enfría', 'Se queda igual'],
      'El calor viaja por el metal desde la parte caliente hasta el mango. A eso se le llama conducción.'),
  'f3_m3_lab': Prediccion('Pusimos una cuchara de metal, una de madera y una de plástico en té caliente. ¿Cuál crees que se calienta más?',
      ['La de metal', 'La de madera', 'La de plástico'], 'Los metales son buenos conductores del calor; la madera y el plástico no.'),
  'f4_m1_taller': Prediccion(
      '¿Qué crees que necesita un foco para encender?',
      ['Un camino cerrado: de la pila al foco y de regreso a la pila', 'Solo tocar el foco con la pila', 'Un solo cable suelto'],
      'La electricidad necesita un camino completo, sin interrupciones, para circular. A ese camino se le llama circuito cerrado.'),
  'f4_m2_lab': Prediccion(
      'Si pones un clip de metal en el hueco del circuito, ¿qué crees que hará el foco?',
      ['Se enciende, porque el metal deja pasar la electricidad', 'Se queda apagado', 'Se rompe'],
      'Los metales son conductores: dejan pasar la electricidad. La madera o el plástico son aislantes.'),
  'f4_m3_sim': Prediccion(
      '¿Qué crees que ahorra más energía en casa?',
      ['Apagar las luces que no usas', 'Dejar la tele encendida', 'Abrir el refrigerador muchas veces'],
      'Cada aparato encendido gasta energía. Apagar lo que no usas es la forma más fácil de ahorrar.'),
  'f5_m1_sim': Prediccion('¿Cuál crees que es el planeta más grande del Sistema Solar?', ['Júpiter', 'La Tierra', 'Marte'],
      'Júpiter es el más grande: ¡dentro de él cabrían más de mil planetas como la Tierra!'),

  // ---------------- Electrónica ----------------
  'e1_m2_bandas': Prediccion(
      'Las resistencias tienen rayitas de colores. ¿Para qué crees que sirven?',
      ['Para saber cuánto frenan la corriente', 'Para que se vean bonitas', 'Para saber si están calientes'],
      'Cada color es un número. Las rayitas dicen el valor de la resistencia: cuánto frena el paso de la corriente.'),
  'e1_m2_taller': Prediccion(
      'Si conectas un LED directo a una pila de 9 V, sin resistencia, ¿qué crees que pasará?',
      ['Se quema porque le llega demasiada corriente', 'Brilla normal para siempre', 'No pasa nada'],
      'El LED es delicado. La resistencia frena la corriente para protegerlo, como un freno de bicicleta.'),
  'e1_m3_taller': Prediccion(
      '¿Qué crees que hace el botón o interruptor de una linterna?',
      ['Abre o cierra el camino de la corriente', 'Guarda la energía', 'Hace que la pila dure para siempre'],
      'Al cerrar el interruptor el camino queda completo y la luz enciende. Al abrirlo el camino se corta y se apaga.'),
  'e2_m1_taller': Prediccion(
      'Si a un circuito le falta un cable, ¿qué crees que pasará con la luz?',
      ['No enciende, porque el camino está abierto', 'Enciende igual', 'Enciende a la mitad'],
      'La corriente necesita un camino completo. Si falta un cable, el circuito está abierto y no pasa corriente.'),
  'e2_m2_taller': Prediccion(
      'Si conectas dos LED uno detrás del otro (en serie) y uno se quema, ¿qué crees que le pasa al otro?',
      ['También se apaga, porque se corta el único camino', 'Brilla más', 'No le pasa nada'],
      'En serie hay un solo camino: si se corta en un lugar, todo se apaga. En paralelo cada uno tiene su propio camino.'),
  'e2_m3_taller': Prediccion(
      'Si unes con un cable el + y el − de una pila, sin nada en medio, ¿qué crees que pasará?',
      ['La pila se calienta: es un cortocircuito', 'La pila se recarga', 'Se enciende una luz'],
      'La corriente pasa sin freno y la pila se calienta. Es peligroso: en la vida real nunca lo hagas. Aquí es solo una simulación.'),
  'e3_m2_lab': Prediccion(
      '¿Cómo crees que una lámpara del parque sabe cuándo encenderse en la noche?',
      ['Tiene un sensor que detecta la luz', 'Alguien la enciende a mano', 'Adivina la hora'],
      'Un sensor es como un sentido para las máquinas. El sensor de luz detecta cuando oscurece y enciende la lámpara.'),
  'e3_m2_taller': Prediccion(
      'Con una fotorresistencia (sensor de luz), ¿cuándo crees que el LED brillará más?',
      ['Cuando hay mucha luz', 'Cuando está oscuro', 'Siempre brilla igual'],
      'La fotorresistencia deja pasar más corriente cuando le da la luz, así que el LED brilla más.'),
  'e4_m1_taller': Prediccion(
      'Si volteas los cables de un motor (el + donde estaba el −), ¿qué crees que pasará?',
      ['Gira hacia el otro lado', 'Se descompone', 'Gira más rápido'],
      'El sentido de giro depende de por dónde entra la corriente. Al invertir los cables, el motor gira al revés.'),
  'e4_m2_sim': Prediccion('Si un engrane grande hace girar a uno pequeño, ¿cuál crees que gira más rápido?', ['El pequeño', 'El grande', 'Giran igual'],
      'Cuando el grande da una vuelta, el pequeño tiene que dar varias para seguirle el paso.'),
  'e4_m3_taller': Prediccion(
      'Muchos ventiladores tienen una lucecita. ¿Para qué crees que sirve?',
      ['Para avisar que está encendido', 'Para enfriar el aire', 'Para que gire más rápido'],
      'Es una luz piloto: se enciende junto con el motor para avisarte que el aparato está funcionando.'),
  'e5_m1_prog': Prediccion('Si programas «SI está oscuro → enciende la luz», ¿qué crees que hará la lámpara de día?',
      ['Se queda apagada', 'Se enciende', 'Parpadea'], 'La condición «está oscuro» no se cumple de día, así que la lámpara no se enciende.'),
  'e5_m2_prog': Prediccion('Un ventilador automático tiene un sensor de temperatura. ¿Cuándo crees que debe encenderse?',
      ['Cuando hace calor', 'Cuando hace frío', 'Siempre'], 'El sensor mide la temperatura y el programa decide: si hace calor, enciende el ventilador.'),
  'e5_m3_prog': Prediccion('¿Qué crees que necesita saber la barrera de un estacionamiento para levantarse sola?',
      ['Que llegó un coche', 'La hora', 'El color del coche'], 'Un sensor detecta que llegó un coche y el programa ordena al motor que levante la barrera.'),
  'e5_m3_taller': Prediccion(
      'Al presionar el botón de una alarma deben sonar el zumbador y encenderse un LED a la vez. ¿Cómo crees que se conectan?',
      ['Cada uno con su propio camino (en paralelo)', 'Uno sin cables', 'No se pueden usar juntos'],
      'En paralelo cada componente tiene su propio camino desde la pila, así funcionan al mismo tiempo.'),
  'e5_int_prog': Prediccion(
      'En un invernadero automático, si la tierra está muy seca, ¿qué crees que debe hacer el programa?',
      ['Encender la bomba de agua', 'Encender el ventilador', 'Apagar todo'],
      'Un sensor de humedad detecta la tierra seca y el programa enciende la bomba para regar.'),

  // ---------------- Inteligencia Artificial ----------------
  'i1_m2_sim': Prediccion(
      'Si chateas con alguien sin verlo, ¿crees que podrías saber si es una persona o una computadora?',
      ['A veces es difícil saberlo', 'Siempre es muy fácil', 'Nunca se puede saber'],
      'Algunas computadoras escriben casi como personas. Hay que fijarse en pistas, como respuestas raras o demasiado perfectas.'),
  'i2_m2_sim': Prediccion('¿Qué crees que es un patrón?', ['Algo que se repite y nos ayuda a adivinar lo que sigue', 'Un error', 'Un dibujo cualquiera'],
      'Un patrón es una regla que se repite. Las máquinas inteligentes aprenden buscando patrones en los datos.'),
  'i2_m3_sim': Prediccion(
      '¿Cómo crees que una computadora «ve» una imagen?',
      ['Como muchos cuadritos de colores (pixeles) convertidos en números', 'Con ojos como los nuestros', 'No puede ver nada'],
      'Una imagen digital está hecha de pixeles. Para la computadora cada pixel es un número que dice su color.'),
  'i3_m2_sim': Prediccion(
      'Si a una máquina le enseñas solo 2 fotos de aves, ¿crees que aprenderá bien a reconocerlas?',
      ['No, necesita muchos ejemplos', 'Sí, con 2 fotos es suficiente', 'Aprende sola, sin ejemplos'],
      'Mientras más ejemplos variados le des, mejor aprende la máquina. A eso se le llama entrenar.'),
  'i3_m3_sim': Prediccion(
      '¿Cómo crees que aprende una neurona artificial?',
      ['Probando, equivocándose y ajustándose con muchos ejemplos', 'Ya nace sabiendo todo', 'Copiando la respuesta de internet'],
      'Cada vez que se equivoca, la neurona cambia un poquito sus números para acertar la próxima vez.'),
  'i4_m1_sim': Prediccion(
      'Cuando le dices «pon música» a un asistente de voz, ¿qué crees que hace primero?',
      ['Escucha y convierte tu voz en palabras', 'Pone cualquier canción', 'Llama a una persona'],
      'Primero convierte tu voz en texto, luego entiende lo que pediste y al final responde o actúa.'),
  'i4_m2_sim': Prediccion(
      '¿Por qué crees que una app de videos te recomienda videos de dinosaurios?',
      ['Porque has visto muchos videos de dinosaurios', 'Porque lee tu mente', 'Lo elige al azar'],
      'El recomendador aprende de lo que ves y te muestra cosas parecidas.'),
  'i5_m1_sim': Prediccion(
      'Si entrenas una IA solo con fotos de manzanas rojas, ¿qué crees que pasará al mostrarle una manzana verde?',
      ['Puede equivocarse y no reconocerla', 'La reconocerá perfecto', 'La manzana se vuelve roja'],
      'Si los ejemplos no son variados, la IA aprende con sesgo: solo reconoce lo que vio. Por eso los datos deben ser variados.'),

  // ---------------- Programación ----------------
  'p1_m3_robot': Prediccion(
      'Si le dices al robot «avanza 2» y después «gira a la derecha», ¿qué crees que hará?',
      ['Camina 2 casillas y después gira', 'Gira primero y luego camina', 'No hace nada'],
      'El robot sigue las instrucciones en orden, una por una, exactamente como se las diste.'),
  'p2_m2_robot': Prediccion(
      'Si cambias el orden de las instrucciones del robot, ¿qué crees que pasará?',
      ['Hará un camino diferente', 'Hará exactamente lo mismo', 'Se apagará'],
      'El orden importa: con los mismos bloques en otro orden, el robot hace otro recorrido.'),
  'p2_int_robot': Prediccion(
      'Antes de programar el camino al tesoro, ¿qué crees que conviene hacer?',
      ['Mirar el mapa y planear el camino', 'Poner bloques al azar', 'Programar sin mirar el mapa'],
      'Los programadores primero piensan y planean (un algoritmo) y después escriben el programa.'),
  'p3_m2_robot': Prediccion(
      '¿Qué crees que pasa si un bloque manda al robot contra una pared?',
      ['Choca y hay que corregir el programa', 'Atraviesa la pared', 'Salta la pared'],
      'El robot no piensa por sí mismo: hace lo que dice el programa. Si el programa está mal, hay que corregirlo.'),
  'p3_m3_dibujo': Prediccion('Para que el robot dibuje un cuadrado, ¿cuántas veces crees que debe girar?', ['4 veces', '1 vez', '10 veces'],
      'Un cuadrado tiene 4 lados iguales: avanza y gira, 4 veces.'),
  'p3_int_robot': Prediccion(
      'En una fábrica, ¿para qué crees que sirve programar un robot?',
      ['Para que haga tareas repetidas sin equivocarse', 'Para que juegue', 'Para que descanse'],
      'Los robots son muy buenos para repetir la misma tarea muchas veces, siempre igual.'),
  'p4_m1_robot': Prediccion('Si el robot tiene la instrucción «SI hay pared → gira», ¿qué crees que hará cuando NO hay pared?',
      ['Sigue avanzando', 'Gira de todos modos', 'Se detiene para siempre'], 'La condición solo se cumple cuando hay pared. Si no hay, el robot no gira.'),
  'p4_m2_robot': Prediccion(
      'Para que el robot avance 5 casillas, ¿qué crees que es mejor?',
      ['Usar «repite 5 veces: avanza»', 'Poner muchos bloques iguales', 'No se puede'],
      'Un ciclo (repite) hace lo mismo varias veces con un solo bloque: el programa queda más corto.'),
  'p4_m3_robot': Prediccion(
      '¿Qué crees que hace que un robot sea «autónomo»?',
      ['Decide solo usando sensores y condiciones', 'Alguien lo maneja con un control', 'Que no se mueve'],
      'Un robot autónomo usa sensores para saber qué hay a su alrededor y condiciones para decidir qué hacer.'),
  'p4_int_robot': Prediccion(
      'Para salir de un laberinto, ¿qué crees que ayuda más al robot?',
      ['Repetir y decidir: avanzar y girar cuando hay pared', 'Avanzar siempre derecho', 'Girar sin parar'],
      'Combinar ciclos y condiciones permite que el robot encuentre la salida.'),
  'p5_m2_caza': Prediccion(
      'Si un programa no hace lo que esperabas, ¿qué crees que conviene hacer?',
      ['Revisarlo paso a paso para encontrar el error', 'Borrarlo todo', 'Ignorarlo'],
      'Revisar con calma cada instrucción ayuda a encontrar el error. A eso se le llama depurar.'),
  'p5_m3_robot': Prediccion(
      'El robot debía llegar a la meta pero chocó. ¿Dónde crees que está el error?',
      ['En alguna instrucción del programa', 'En la pared', 'En la meta'],
      'El robot hace justo lo que dice el programa. Si chocó, alguna instrucción está mal.'),
  'p5_m3_dibujo': Prediccion('El robot debía dibujar un cuadrado y dibujó un lado de más. ¿Qué crees que hay que cambiar?',
      ['Las veces que se repite', 'El color del lápiz', 'Nada'], 'Si dibujó de más, el ciclo se repitió demasiadas veces.'),
  'p5_int_caza': Prediccion(
      '¿Qué crees que es un «bug» en programación?',
      ['Un error en el programa', 'Un insecto dentro de la computadora', 'Un tipo de robot'],
      'Bug significa «bicho» en inglés. Así se llama a los errores de los programas.'),

  // ---------------- Laboratorios finales ----------------
  'bio-lab': Prediccion(
      'Si en un ecosistema hay muchísimos conejos y casi nada de pasto, ¿qué crees que pasará en unos días?',
      ['Los conejos se quedarán sin comida y habrá menos conejos', 'Habrá todavía más conejos', 'El pasto crecerá solo muchísimo'],
      'En un ecosistema equilibrado debe haber suficiente alimento para todos. Si hay demasiados que comen y poca comida, la población baja.'),
  'fis-lab': Prediccion('Si lanzas una pelota con la misma fuerza en la Tierra y en la Luna, ¿dónde crees que llegará más lejos?',
      ['En la Luna', 'En la Tierra', 'Llega igual de lejos'], 'La gravedad de la Luna es 6 veces menor: la pelota tarda más en caer y llega mucho más lejos.'),
  'ele-lab': Prediccion(
      'En una casa, la luz de la sala y la de la cocina se prenden por separado. ¿Cómo crees que están conectadas?',
      ['Cada una con su propio camino (en paralelo) y su interruptor', 'Todas en un solo camino', 'No necesitan cables'],
      'En las casas las luces van en paralelo: cada una tiene su propio camino, así una puede estar encendida y la otra apagada.'),
  'ia-lab': Prediccion(
      'Para crear una IA que reconozca frutas, ¿qué crees que necesitas primero?',
      ['Muchas fotos de frutas con su nombre (datos etiquetados)', 'Una computadora muy grande y nada más', 'Que la IA adivine sola'],
      'Una IA aprende de ejemplos. Primero reúnes datos, luego los etiquetas y después la entrenas.'),
  'pro-lab': Prediccion(
      'En un videojuego, ¿qué crees que hace que el personaje salte cuando presionas un botón?',
      ['Un programa: «cuando presionen el botón → salta»', 'El personaje decide solo', 'Es magia'],
      'Los videojuegos están hechos de programas con eventos: cuando pasa algo (presionas un botón), se ejecuta una acción.'),

  // ---------------- Simulaciones 3D ----------------
  'e2_m1_3d': Prediccion(
      'Si el interruptor está cerrado pero un cable está cortado, ¿qué crees que hará el foco?',
      ['Se apaga, porque el camino se rompió', 'Sigue encendido', 'Brilla más fuerte'],
      'La corriente necesita dar la vuelta completa. Un cable cortado abre el circuito, igual que abrir el interruptor.'),
  'i3_m3_3d': Prediccion(
      'El murciélago vuela, tiene pelo y toma leche de su mamá. ¿Qué crees que dirá la red neuronal?',
      ['Mamífero', 'Ave', 'No puede decidir nada'],
      'Aunque vuela, el murciélago tiene pelo y toma leche: es un mamífero. La red suma todas las pistas, no solo una.'),
  'p2_m2_3d': Prediccion(
      'Si el robot mira a la derecha y le dices «girar a la derecha», ¿hacia dónde quedará mirando?',
      ['Hacia abajo', 'Hacia arriba', 'Hacia la izquierda'],
      'Girar a la derecha es dar un cuarto de vuelta como las manecillas del reloj: de mirar a la derecha pasa a mirar hacia abajo.'),
  'f5_m1_3d': Prediccion(
      '¿Qué planeta crees que da la vuelta al Sol más rápido?',
      ['Mercurio, el más cercano al Sol', 'Neptuno, el más lejano', 'Todos tardan lo mismo'],
      'Mientras más cerca está un planeta del Sol, más corto es su camino y más rápido va. ¡Un año en Mercurio dura solo 88 días!'),
  'q2_m1_3d': Prediccion(
      'Si calientas mucho el agua, ¿qué crees que les pasa a sus partículas?',
      ['Se mueven más rápido y se separan', 'Se quedan quietas', 'Se hacen más pequeñas'],
      'El calor les da energía: se mueven cada vez más rápido y se separan, hasta que el agua se vuelve vapor (gas).'),
  // ---------------- Mini-juegos ----------------
  'f2_m2_flame': Prediccion(
      'Si lanzas la pelota con la misma fuerza en la Tierra y en la Luna, ¿dónde crees que llegará más lejos?',
      ['En la Luna', 'En la Tierra', 'Llega igual de lejos'],
      'La gravedad de la Luna es 6 veces menor, así que la pelota tarda más en caer y vuela mucho más lejos.'),
  'i3_m2_flame': Prediccion(
      'Si le enseñas a una IA con datos mal etiquetados (por ejemplo, un calcetín marcado como fruta), ¿qué crees que pasará?',
      ['La IA aprenderá mal y se equivocará', 'La IA lo corregirá sola', 'No importa, la IA sabe todo'],
      'La IA aprende exactamente lo que le enseñamos. Si los datos están mal, la IA se equivoca. ¡Los datos deben ser correctos!'),
};
