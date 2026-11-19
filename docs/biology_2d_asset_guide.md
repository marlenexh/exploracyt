# Guía de ilustración 2D del cuerpo humano

Los diagramas interactivos y etiquetas en español ya están en `lib/presentation/biology/body_diagram.dart`. Los controles para experimentar están en `body_experiment.dart`. Ambos se dibujan en Flutter y funcionan con teclado, toque y ratón mediante sus controles acompañados de texto. El fondo, los cinco pedestales y el PNG de Zati son recursos existentes.

| Archivo recomendado | Misión y pantalla | Qué debe explicar | Tamaño y fondo | Capas sugeridas |
| --- | --- | --- | --- | --- |
| `circulation.png` | Corazón, «Explora el modelo 2D» | Circuito pulmonar y sistémico en una silueta. Dibuja corazón, pulmones, músculos, arterias, venas y red de capilares. Usa flechas y escribe en la guía qué dirección representa cada una. | 1200 × 1200, transparente | Silueta, órganos, vasos por circuito, flechas, leyenda |
| `breathing.png` | Aire, «Explora el modelo 2D» | Nariz, tráquea, bronquios, pulmones, diafragma y un recuadro con alvéolos y capilares. Señala entrada de oxígeno a sangre y salida de dióxido de carbono. | 1200 × 1200, transparente | Silueta, vías, pulmones, diafragma, ampliación, flechas |
| `defense.png` | Defensas, «Explora el modelo 2D» | Piel intacta y raspón leve, glóbulo blanco, ganglios y corte sencillo de un hueso con médula. Distingue la escala de microorganismos de la escala del cuerpo. | 1200 × 1200, transparente | Silueta, piel, herida, detalle celular, médula, leyenda |
| Opcional, hojas separadas para escenas de cuidado | Defensas, laboratorio | Lavado, superficies, ventilación, cuidado, vacunación y descanso. Escenas cotidianas con un adulto cuando corresponde. | 900 × 600 por escena, fondo sólido pastel | Personajes, entorno, acción y señalización |

Trabaja en Krita (`.kra`) o Clip Studio Paint (`.clip`), conserva el archivo editable separado y exporta PNG sRGB. Usa contornos azul oscuro, fondo marfil o verde claro y pocos detalles. Señala la dirección con flechas y texto además del color. En circulación, los colores indican contenido relativo de oxígeno y no la definición de arteria o vena. Evita texto indispensable integrado al PNG. Comprueba a 320 px de ancho y a 125 % de escala de texto.

1. Abre un lienzo nuevo y sitúa los elementos principales cerca de los puntos normalizados de `lib/data/body_topic.dart`. Deja espacio entre las zonas pulsables.
2. Guarda la paleta, separa las capas y revisa los recorridos con una lectura de izquierda a derecha. Muestra la herida como escena educativa sin detalles gráficos.
3. Conserva en Flutter los latidos, las partículas, el cambio de tamaño pulmonar, el diafragma y sus estados estáticos. Si una animación futura agrega información que el dibujo no transmite, exporta el arte por capas y anima posición o escala; respeta Reducir animaciones.
4. Guarda el PNG como `assets/biology_media/<archivo>`. Añade la carpeta bajo `flutter.assets` en `pubspec.yaml` una vez que exista y fija `asset` para el ID correspondiente en `lib/presentation/biology/body_resources.dart`.
5. El panel complementario mostrará el PNG sin cambiar la actividad. Si deseas usarlo como fondo interactivo, sustituye la capa del dibujo de la explicación en `body_diagram.dart`, ajusta las coordenadas y conserva botones, etiquetas y dibujo de laboratorio. Prueba todos los puntos con teclado y toque.
6. Compila con `./tool/build_web.sh`, abre en un navegador con conexión, espera «Disponible sin conexión» y vuelve a abrir la misión sin red. El dibujo, las etiquetas y el laboratorio deben funcionar aunque el complemento no esté disponible.
