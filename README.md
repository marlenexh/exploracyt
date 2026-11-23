# explora_ciencia

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Desarrollo web

Usa Flutter 3.47.5, la versión asociada con la revisión de `.metadata` y las dependencias de `pubspec.lock`. En VS Code, instala la extensión Flutter, abre la carpeta raíz, selecciona Chrome como dispositivo y usa **Ejecutar → Iniciar depuración**. Desde una terminal:

```sh
flutter --version
flutter pub get --enforce-lockfile
flutter analyze
flutter test
flutter run -d chrome
```

## Compilar e instalar la PWA

Usa Flutter y Python 3. El script genera el manifiesto de archivos para el service worker a partir de la compilación, incluyendo el motor web local, los diagramas y los recursos de las misiones.

```sh
./tool/build_web.sh --no-pub
python3 -m http.server 8080 --bind 127.0.0.1 --directory build/web
```

1. Abre la aplicación servida en el navegador. Usa HTTPS en un servidor real o localhost para pruebas. Conserva todos los archivos de `build/web` al desplegar.
2. Espera el estado **Disponible sin conexión**. El menú del estado permite volver a preparar la caché. La primera preparación requiere Internet o acceso al servidor local.
3. En un navegador compatible, elige **Instalar Explora Ciencia** desde su menú. También puedes seguir usando la pestaña web.
4. Desconecta la red, recarga y abre **Biología → El cuerpo humano**. Prueba un experimento, completa una investigación y recarga otra vez para verificar la insignia y el desbloqueo.
5. Para actualizar, despliega la carpeta como una unidad. Una versión nueva se prepara en segundo plano. Cierra las pestañas de la versión anterior y vuelve a abrir la aplicación para activarla.

El progreso, las preferencias y los recursos quedan en el almacenamiento local del navegador para ese origen. Borrar los datos del sitio o usar otro dispositivo u origen puede perder o aislar el progreso. El modo privado y el espacio insuficiente pueden limitar la persistencia. Los videos externos requieren Internet y las misiones incluyen todas las explicaciones necesarias en 2D.

## Recursos del Tema 1

Desde **Biología → El cuerpo humano → Jugar Misión Cuerpo Humano** puedes abrir los recorridos 3D, los laboratorios y el reto final. Las insignias del videojuego duran lo que dura la partida. Para añadir videos y créditos, actualiza las entradas de tipo `video` de `bodyResources` siguiendo la guía de video. Esas entradas se muestran tanto en las investigaciones como en el juego.

- [Lista y estado de recursos](docs/biology_asset_checklist.md)
- [Ilustración y animación 2D](docs/biology_2d_asset_guide.md)
- [Selección, licencias y subtítulos de video](docs/biology_video_guide.md)
- [Producción e integración de modelos GLB](docs/biology_blender_guide.md)

## Biología · Tema 1: El cuerpo humano y sus sistemas

Al elegir el Tema 1 en el Laboratorio de Biología se abre el juego de `lib/presentation/biology/tema1/` a través de `lib/presentation/biology/tema1_screen.dart`.

### Celular y computadora

Todas las pantallas se dibujan sobre un lienzo horizontal que se escala para llenar cualquier pantalla. En una pantalla vertical (por ejemplo, un celular sin girar) el juego se gira automáticamente, así que siempre se ve completo y se puede tocar. Zati aparece quieto en todas las pantallas.

### Misiones

Las misiones se desbloquean en orden y sus pasos se juegan uno tras otro.

**Misión 1 · ¡El corazón en acción!**
1. ¿Qué es el cuerpo humano?
2. El cuerpo humano y sus sistemas
3. Sistema circulatorio
4. El corazón y los vasos sanguíneos
5. El viaje de la sangre
6. Video del tema
7. Simulación 3D: las partes del corazón
8. Laboratorio: tu frecuencia cardiaca (hipótesis, medir en reposo, moverse, medir después, analizar y concluir)
9. Juego: Repartidor de oxígeno
10. Mini misión: unir las partes, ¿para qué sirve cada una? y elegir acciones que cuidan el corazón

**Misión 2 · ¡El viaje del aire!**
1. El sistema respiratorio
2. El viaje del aire
3. El intercambio de gases
4. ¿Cómo cambia tu respiración?
5. El ambiente también influye
6. Video del tema
7. Los pulmones en 3D
8. Laboratorio: arma el recorrido del aire, simula la respiración (inhalar y exhalar) y compara y analiza
9. Juego: Atrapa el aire limpio
10. Mini misión: nombrar las partes del modelo, relacionar cada parte con su función y elegir acciones que cuidan el sistema respiratorio

**Misión 3 · ¡Defensores del cuerpo!**
1. ¿Qué es, para qué sirve y cómo funciona el sistema inmunológico?
2. Sus partes: amígdalas, timo, ganglios, vasos linfáticos, bazo, médula ósea y glóbulos blancos
3. Así te defiende
4. Hábitos que fortalecen tus defensas y los que ponen en riesgo tu salud
5. Video del tema
6. Dentro de la sangre en 3D
7. Microscopio
8. Vacunas
9. Juego: Defensa inmune
10. Mini misión: rompecabezas para unir cada nombre con su función

**Actividad integradora · ¡Tu cuerpo trabaja en equipo!**
1. El cuerpo completo en 3D
2. La excursión al cerro: una situación en 5 escenas que se resuelve con lo aprendido de los 3 sistemas
3. Arma el cuerpo
4. Supercerebro

Al terminar todo el Tema 1 se muestra la pantalla de la insignia **Explorador del Cuerpo Humano**.

### Progreso e insignia

- Las estrellas del juego se guardan en `shared_preferences` con la clave `v1.tema1.juego`.
- Al completar cada misión se marca su id en `ProgressStore` (`bio-t1-m1`, `bio-t1-m2`, `bio-t1-m3`, `bio-t1-integration`), con los mismos ids de antes.
- **Solo hay una insignia**, "Explorador del Cuerpo Humano", y se entrega al completar la actividad integradora. Las insignias por misión de versiones anteriores se retiran al cargar el progreso.

### Videos

Cada misión tiene su paso de video. Coloca los archivos en `assets/videos/`:

- `sistema_circulatorio.mp4`
- `sistema_respiratorio.mp4`
- `sistema_inmunologico.mp4`

También puedes usar direcciones de internet con `CuerpoHumanoJuego(videos: {'circulatorio': 'https://…', 'respiratorio': '…', 'inmune': '…'})`. Si no hay video, se muestra un espacio reservado y el alumno puede continuar. Usa el paquete oficial `video_player`.

### Imágenes

- Zati: `assets/images/biology/zati.png`
- Fondo: `assets/images/biology/fondo_biologia_tema1.jpg`

## Biología · Temas 2 a 5

Los temas 2 a 5 usan un motor común (`lib/presentation/biology/temas/`) que reutiliza las piezas del Tema 1: Zati, el fondo, el lienzo que se adapta a celular y computadora (y se gira en vertical), los videos y las mini misiones. Cada tema solo define su contenido en `temaN.dart`.

| Tema | Misiones | Insignia (al terminar la integradora) |
| --- | --- | --- |
| 2. El mundo de las células | ¿Qué es una célula? · Células animales y vegetales · Seres de una y muchas células · Integradora: La feria de ciencias | Explorador de las Células |
| 3. Alimentación saludable | Los nutrientes · La alimentación equilibrada · Hábitos saludables · Integradora: El menú de la cafetería | Experto en Alimentación Saludable |
| 4. La vida a nuestro alrededor | ¿Qué es un ser vivo? · Las plantas · Los animales · Integradora: El huerto escolar | Guardián de los Seres Vivos |
| 5. Biodiversidad y ecosistemas | ¿Qué es un ecosistema? · Cadenas alimenticias · Biodiversidad y cuidado · Integradora: Salvemos el río | Protector de la Biodiversidad |

Cada misión tiene explicación con pestañas (¿Qué es? / ¿Para qué sirve? / ¿Cómo funciona? / En la vida diaria), video, simulación o laboratorio, un juego y termina con **"Pon a prueba lo que aprendiste"** (nombrar partes, relacionar, elegir acciones y preguntas). Las misiones se desbloquean en orden.

Simulaciones y laboratorios (`temas/simulaciones.dart`): microscopio con enfoque y aumento (T2), arma tu Plato del Bien Comer y laboratorio del azúcar en bebidas (T3), fotosíntesis con controles y experimento de las 4 macetas (T4), equilibrio del ecosistema pasto–conejos–zorros (T5).

Actividades reutilizables (`temas/pasos.dart`): clasificar, ordenar (con ciclos de vida), atrapar lo correcto, memorama, situación por escenas y mini misión por fases.

- Puente con la app: `lib/presentation/biology/tema_bio_screen.dart`. Las estrellas se guardan con la clave `v1.temaN.juego`.
- Ids de misiones: `bio-tN-m1`, `bio-tN-m2`, `bio-tN-m3`, `bio-tN-integration`; la insignia `bio-tN-integration-badge` (ver `lib/data/bio_topics.dart`).
- Videos en `assets/videos/` (ver `assets/videos/LEEME.txt`). Si falta un archivo se muestra un espacio reservado y el alumno puede continuar.
- Las ilustraciones usan emojis. En la web sin conexión puede faltar la fuente de emojis del navegador; en Android e iOS se usan los del sistema.
- Pruebas: `test/temas_bio_test.dart`.

## Electrónica · La ciudad de los circuitos

Propósito: conocer el funcionamiento básico de los dispositivos electrónicos y comprender cómo sus componentes trabajan juntos. Al entrar al mundo de Electrónica se abre `lib/presentation/electronica/electronica_screen.dart` (mapa sobre una placa de circuito animada) y cada tema usa el mismo motor de los temas de Biología, con **fondos propios** pintados en código (`electronica/fondos.dart`): taller, ciudad de noche, laboratorio de detectives, fábrica y planos de inventor.

| Tema | Misiones | Simulaciones principales | Insignia |
| --- | --- | --- | --- |
| 1. Conoce los componentes | La caja de componentes · El LED y la resistencia · Pilas, interruptores y más · Integradora: La linterna de emergencia | Código de colores de resistencias; primer LED, LED al revés, elegir resistencia; linterna y timbre | Conocedor de Componentes |
| 2. Conecta y enciende | ¿Qué es un circuito? · Serie y paralelo · Conductores y seguridad · Integradora: La ciudad a oscuras | Circuito con interruptor, encontrar la falla, LED en serie y en paralelo, cortocircuito | Maestro de los Circuitos |
| 3. Detectives electrónicos | ¿Qué es un sensor? · ¿Cómo funcionan? · Sensores a nuestro alrededor · Integradora: El misterio del museo | Laboratorio de 4 sensores (luz, temperatura, PIR, ultrasónico); fotorresistencia en un circuito | Detective Electrónico |
| 4. Máquinas en movimiento | El motor eléctrico · Mecanismos · Máquinas de todos los días · Integradora: El carrito de la feria | Encender, invertir y regular un motor; engranes (velocidad, fuerza, rueda loca); ventilador con luz piloto | Ingeniero en Movimiento |
| 5. Crea tu invento | Sistemas automáticos · Programa con bloques · Diseña tu invento · Integradora: El invernadero automático | Programación por bloques (lámpara automática, ventilador, alarma, barrera, invernadero con 2 reglas); prototipo de alarma | Inventor Electrónico |

Basado en los conceptos de Tinkercad Circuits:

- **Taller de circuitos** (`electronica/taller.dart`): se toca una terminal y luego otra para poner un cable, se presiona “Iniciar simulación”, se tocan interruptores y botones durante la simulación, hay inspector de componentes y multímetro. Los LED tienen ánodo (pata doblada) y cátodo, se queman sin resistencia (💥) y hay aviso de cortocircuito.
- **Simulador** (`electronica/circuito.dart`): análisis nodal real con pilas de 9 V y 3 V, LED (rojo, verde, amarillo, azul), resistencias, interruptor, botón, zumbador, motor CD, foco, fotorresistencia y potenciómetro. Pruebas en `test/electronica_circuito_test.dart`.
- **Bloques de código** (`electronica/bloques.dart`): entradas moradas, control naranja (si… entonces… si no…) y salidas azules, como en la pestaña Código de Tinkercad.
- Progreso: clave `v1.ele.temaN.juego`; misiones `ele-tN-m1..m3` y `ele-tN-integration`; insignia `ele-tN-integration-badge` (`lib/data/ele_topics.dart`).
- Videos en `assets/videos/` (ver `assets/videos/LEEME.txt`).
- Pruebas: `test/electronica_test.dart` resuelve todos los retos de circuitos, los programas y los laboratorios.

## Programación · El reino de los algoritmos

Al entrar al mundo de Programación se abre `lib/presentation/programacion/programacion_screen.dart`: el mapa con los 5 temas y el **Laboratorio del programador**. Usa el mismo motor de temas, con fondos propios pintados en código (`programacion/fondos_pro.dart`): reino pixelado, tablero de instrucciones, bloques flotantes, ciclos y decisiones, y pantalla de código con bichos. El contenido se basa en *Fundamentos de programación* (Jiménez, Jiménez y Alvarado): algoritmo como pasos finitos, precisos y ordenados; entrada, proceso y salida; diagramas de flujo y pseudocódigo; estructuras selectivas y repetitivas; errores y depuración.

| Tema | Misiones | Actividades principales | Insignia |
| --- | --- | --- | --- |
| 1. Piensa como programador | ¿Qué es programar? · Pensamiento computacional · Resuelve paso a paso · Integradora: El robot cocinero | Pilares del pensamiento computacional, pasos del programador, primer robot | Pensador Computacional |
| 2. Sigue las instrucciones | ¿Qué es un algoritmo? · Secuencias · Diagramas y pseudocódigo · Integradora: El mapa del tesoro | Algoritmo para ir a la escuela, secuencias con el robot, símbolos del diagrama de flujo | Maestro de los Algoritmos |
| 3. Programa con bloques | ¿Qué son los bloques? · Mueve al robot · Dibuja con código · Integradora: La gran fábrica | Categorías de bloques, programa al robot, dibujar figuras | Programador de Bloques |
| 4. Repite y decide | Decisiones: si… si no · Ciclos: repetir · Combina ciclos y decisiones · Integradora: El laberinto giratorio | si / si-no / repetir / mientras con límite de bloques, laberinto autónomo | Experto en Ciclos y Decisiones |
| 5. Encuentra el error | ¿Qué es un bug? · Depura algoritmos · Depura programas · Integradora: El videojuego con bichos | Tipos de error, caza de bichos en pseudocódigo, programas del robot con errores | Cazador de Errores |

- **Robot programable** (`robot.dart`, `robot_ui.dart`): editor de bloques tipo Scratch (eventos amarillos, movimiento azul, acción verde, control naranja), ejecución paso a paso con el bloque resaltado, choques, ciclos infinitos y límite de bloques. También dibuja figuras y trae niveles con errores para depurar.
- **Caza de bichos** (`cazaerrores.dart`): tocar la línea con error y elegir la corrección.
- **Laboratorio del programador** (`estudio.dart`): el alumno programa los eventos de su videojuego, lo prueba, ve la revisión de bugs y lo publica. Da la insignia “Desarrollador de Videojuegos” (`pro-lab-badge`).
- Progreso: clave `v1.pro.temaN.juego`; misiones `pro-tN-m1..m3` y `pro-tN-integration` (`lib/data/pro_topics.dart`).
- Pruebas: `test/programacion_robot_test.dart` y `test/programacion_test.dart` (resuelven todos los niveles, los bichos y el laboratorio).

## Química · El laboratorio de los materiales misteriosos

Mapa en `lib/presentation/quimica/quimica_screen.dart`. Cada tema tiene su propio fondo animado (`ciencia/fondos_ciencia.dart`): muro de materiales, cielo con globos, cristales que cambian, cocina y fogata nocturna. El contenido sigue los temas de Ciencias Naturales de la SEP (Nuestros saberes / Proyectos de aula) e incluye tarjetas de **“¿Sabías que…?”** con datos interesantes.

| Tema | Misiones | Actividades principales | Insignia |
| --- | --- | --- | --- |
| 1. El mundo de los materiales | ¿De qué están hechas las cosas? · Dureza, flexibilidad y permeabilidad · El material correcto · Integradora: La mochila para la lluvia | Naturales y artificiales, tabla de pruebas (rayar, doblar, echar agua) | Detective de Materiales |
| 2. Los gases y sus propiedades | Sólidos, líquidos y gases · Las propiedades de los gases · Gases en la vida diaria · Integradora: El globo de la feria | Jeringa de gas: compresibilidad, expansión, volumen y masa | Explorador de los Gases |
| 3. Todo se transforma | Cambios temporales · Cambios permanentes · Los cambios de estado · Integradora: La fiesta de cumpleaños | Tabla calentar/enfriar, ciclo del agua | Maestro de las Transformaciones |
| 4. Cocción y descomposición de los alimentos | La cocción · La descomposición · La conservación · Integradora: El refrigerador descompuesto | Simulador de conservación (aire, refri, congelador, deshidratar) | Chef Científico |
| 5. Combustión y oxidación | La combustión · La oxidación · Fuego y ambiente · Integradora: Campamento seguro | Vela con frascos y triángulo del fuego, clavos que se oxidan | Guardián del Fuego |

## Física · El valle de las fuerzas y la energía

Mapa en `lib/presentation/fisica/fisica_screen.dart`, con fondos propios por tema: campo magnético, colinas con manzanas, atardecer caluroso, ciudad con energía y espacio con planetas.

| Tema | Misiones | Actividades principales | Insignia |
| --- | --- | --- | --- |
| 1. El magnetismo y sus misterios | Imanes y polos · ¿Qué atrae un imán? · La Tierra es un imán · Integradora: El explorador perdido | Imanes que se atraen/repelen y brújula, tabla de objetos, imán atrapa-todo | Maestro de los Imanes |
| 2. La gravedad en acción | ¿Qué es la gravedad? · La caída de los objetos · Efectos de la gravedad · Integradora: Misión a la Luna | Caída en la Tierra y en la Luna (experimento de Galileo) | Explorador de la Gravedad |
| 3. Calor y energía térmica | Temperatura y calor · ¿Cómo viaja el calor? · Conductores y aislantes · Integradora: El pozole de la abuela | Bloques de metal/vidrio/madera, cucharas en el té, seguridad en la cocina | Experto en Calor |
| 4. La energía que nos rodea | La electricidad · Conductores y aislantes · Uso responsable de la energía · Integradora: El recibo de luz | Circuito con el simulador de Electrónica, probador de materiales, casa que ahorra | Guardián de la Energía |
| 5. Explorando el Sistema Solar | El Sol y los planetas · Características de los planetas · Los movimientos de la Tierra · Integradora: Viaje espacial | Viaje por los 8 planetas, rocosos/gaseosos, fases de la Luna | Astronauta Explorador |

- Piezas comunes (`lib/presentation/ciencia/`): ilustraciones con emojis animados (`escena.dart`), tabla de experimentos (`lab_matriz.dart`) y fondos.
- Progreso: claves `v1.qui.temaN.juego` y `v1.fis.temaN.juego`; misiones `qui-tN-…` / `fis-tN-…` (`lib/data/qui_topics.dart`, `lib/data/fis_topics.dart`).
- Pruebas: `test/ciencias_test.dart` (datos, mapas en 3 tamaños, todas las pantallas, tablas y simulaciones resueltas).
