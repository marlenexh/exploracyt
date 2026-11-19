# Guía de modelos GLB en Blender

Los seis modelos están pendientes. Todos se ofrecen como complemento en «Explora el modelo 2D» de su misión, en el panel de recursos. El 2D cubre el contenido obligatorio. Prioriza el corazón y el par de pulmones si el presupuesto es reducido. Para flujos, superficies simultáneas y escala microscópica, conserva el esquema 2D como explicación principal.

| Archivo / misión | Objetivo y contenido | Nodos exactos y partes para etiquetar | Animación recomendada |
| --- | --- | --- | --- |
| `heart.glb` / Corazón | Mostrar bombeo y rutas principales. Separa cámaras sin exceso de detalle. | `Heart`, `RightAtrium`, `RightVentricle`, `LeftAtrium`, `LeftVentricle`, `Aorta`, `PulmonaryArtery`, `PulmonaryVeins` | `Heartbeat`, contracción suave de cámaras |
| `circulatory_system.glb` / Corazón | Mostrar dos circuitos mediante una silueta. | `Body`, `Heart`, `PulmonaryLoop`, `SystemicLoop`, `Capillaries`, `Lungs` | `BloodFlow`, flechas de dirección |
| `lungs.glb` / Aire | Mostrar expansión pulmonar y movimiento del diafragma. | `LeftLung`, `RightLung`, `Diaphragm`, `Trachea`, `Bronchi` | `Breathing`, inhalar y exhalar en secuencia |
| `respiratory_system.glb` / Aire | Seguir el aire y mostrar un alvéolo ampliado. | `NasalCavity`, `Trachea`, `Bronchi`, `Lungs`, `Diaphragm`, `Alveoli`, `Capillary` | `Airflow`, recorrido de aire |
| `white_blood_cell.glb` / Defensas | Mostrar célula de defensa de forma esquemática. | `WhiteBloodCell`, `Membrane`, `Nucleus`, `Microbe` | `CellResponse`, interacción simplificada |
| `microorganism.glb` / Defensas | Mostrar un ejemplo de microorganismo sin generalizar a todos. | `Microorganism`, `OuterLayer`, `Interior` | Opcional, `RotateForInspection` |

1. En Blender crea un archivo por modelo en unidades métricas, con centro en el origen, Z arriba y frente hacia el observador. Trabaja a escala coherente dentro del modelo. Para detalles ampliados usa el borde o pie de figura para indicar que la escala cambia. La exportación glTF convierte Z de Blender a Y vertical.
2. Bloquea formas con mallas sencillas y nombra objetos según la tabla. Separa cada parte seleccionable. Crea flechas o nodos vacíos de referencia para posiciones de etiquetas. Usa una paleta pastel con contornos contrastantes y diferencia los vasos además con dirección y etiquetas.
3. Aplica rotación y escala antes de animar. Crea acciones con los nombres de la tabla, prueba el inicio y el fin del bucle y evita movimientos bruscos. Conserva una postura estática que permita identificar las partes.
4. Mantén como presupuesto inicial 10–25 mil triángulos y un archivo cercano a 2 MB. Usa materiales glTF Principled BSDF, texturas de 512–1024 px incrustadas y evita compresión que requiera decodificadores externos. Guarda el `.blend` editable fuera de los archivos de distribución.
5. Exporta con **Archivo → Exportar → glTF 2.0**, formato **GLB**, solo objetos elegidos, UV, materiales y animaciones. Vuelve a importar el archivo exportado y revisa nombres, materiales y ejes.
6. Guarda el GLB en `assets/biology_media/`. Añade una distribución local compatible de `model-viewer.min.js` y conserva su licencia. Declara la carpeta en `pubspec.yaml` cuando exista. Registra la ruta en `lib/presentation/biology/body_resources.dart`; el visor de `web/biology-media.js` habilita rotación, zoom y control de animación.
7. Para etiquetas 3D, añade en el visor botones de tipo hotspot con posición y normal capturadas del modelo y texto accesible de `lib/data/body_topic.dart`. Conserva nombres estables al cambiar versiones. Para elegir entre varias acciones, usa `model.availableAnimations` y fija `model.animationName` antes de reproducir. El visor actual reproduce la acción predeterminada, con pausa.
8. Compila y sirve con el script web, verifica el control con teclado y toque, y recarga sin red después de preparar la caché. Confirma que GLB, biblioteca y texturas provienen del mismo sitio. Prueba el 2D con el GLB temporalmente ausente.
