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
