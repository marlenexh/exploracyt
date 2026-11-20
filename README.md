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

### Flujo

1. **Intro del tema**: Zati, la misión de la Estación del Cuerpo Humano y el botón "Comenzar".
2. **Menú de misiones**: las misiones se desbloquean en orden.
   - Misión 1: ¡El corazón en acción!
   - Misión 2: ¡El viaje del aire!
   - Misión 3: ¡Defensores del cuerpo!
   - Actividad Integradora
3. **Misión 1**: se juega paso a paso.
   1. ¿Qué es el cuerpo humano?
   2. El cuerpo humano y sus sistemas
   3. Sistema circulatorio
   4. El corazón y los vasos sanguíneos
   5. El viaje de la sangre
   6. Video del tema
   7. Laboratorio del corazón: 3D de sus partes, mide tu pulso, registra y compara, y frecuencia ideal
   8. Mini misión
4. Al terminar una misión se pasa a la siguiente.

### Progreso

- Las estrellas del juego se guardan en `shared_preferences` con la clave `v1.tema1.juego`.
- Al completar cada misión se marca su id en `ProgressStore` (`bio-t1-m1`, `bio-t1-m2`, `bio-t1-m3`, `bio-t1-integration`) y se entrega su insignia.
- Los ids son los mismos que antes, así que se conserva el avance que ya tenían los alumnos.

### Video del tema

- Coloca el video en `assets/videos/sistema_circulatorio.mp4`, o pasa una dirección de internet con `CuerpoHumanoJuego(videos: {'circulatorio': 'https://…'})`.
- Si no hay video, se muestra un espacio reservado y el alumno puede continuar.
- Usa el paquete oficial `video_player`.

### Imágenes

- Zati: `assets/images/biology/zati.png`
- Fondo: `assets/images/biology/fondo_biologia_tema1.jpg`

La pantalla gira a horizontal mientras se juega el tema y regresa a su orientación al salir.
