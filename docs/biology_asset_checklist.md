# Lista de recursos del Tema 1

Los archivos nuevos de esta tabla siguen pendientes. El paquete esencial se forma con los diagramas Flutter, el código de los experimentos, los retos, la tipografía y los recursos existentes de Biología. Se almacena mediante el manifiesto offline generado para cada compilación.

| Recurso | Tipo | Misión | Prioridad | Herramienta | Nombre y carpeta | Pantalla | Estado e incorporación |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Zati y laboratorio | PNG | Todas | Indispensable | Existente | `assets/images/biology/{zati,biology_background}.png` | Tema y misiones | Integrados |
| Diagramas, experimentos, retos e insignias | Flutter | Todas | Indispensable | Flutter | `lib/presentation/biology/body_*.dart` | Tema, etapas y cierre | Integrados |
| Diagrama de vasos | PNG | Corazón | Recomendado | Krita/Clip Studio | `assets/biology_media/circulation.png` | Exploración | Pendiente · registrar `heart-diagram` |
| Diagrama de vías aéreas | PNG | Aire | Recomendado | Krita/Clip Studio | `assets/biology_media/breathing.png` | Exploración | Pendiente · registrar `lungs-diagram` |
| Diagrama de defensas | PNG | Defensas | Recomendado | Krita/Clip Studio | `assets/biology_media/defense.png` | Exploración | Pendiente · registrar `defense-diagram` |
| Latidos y circulación | Video | Corazón | Opcional | Selección editorial | `assets/biology_media/heart.mp4` | Exploración | Pendiente · registrar `heart-video` y créditos |
| Inhalación y exhalación | Video | Aire | Opcional | Selección editorial | `assets/biology_media/lungs.mp4` | Exploración | Pendiente · registrar `lungs-video` y créditos |
| Barreras y prevención | Video | Defensas | Opcional | Selección editorial | `assets/biology_media/defense.mp4` | Exploración | Pendiente · registrar `defense-video` y créditos |
| Corazón | GLB | Corazón | Opcional | Blender | `assets/biology_media/heart.glb` | Exploración | Pendiente · registrar `heart-model` |
| Circulación completa | GLB | Corazón | Opcional | Blender | `assets/biology_media/circulatory_system.glb` | Exploración | Pendiente · registrar `circulation-model` |
| Pulmones | GLB | Aire | Opcional | Blender | `assets/biology_media/lungs.glb` | Exploración | Pendiente · registrar `lungs-model` |
| Vías respiratorias | GLB | Aire | Opcional | Blender | `assets/biology_media/respiratory_system.glb` | Exploración | Pendiente · registrar `breathing-model` |
| Glóbulo blanco | GLB | Defensas | Opcional | Blender | `assets/biology_media/white_blood_cell.glb` | Exploración | Pendiente · registrar `white-cell-model` |
| Microorganismo | GLB | Defensas | Opcional | Blender | `assets/biology_media/microorganism.glb` | Exploración | Pendiente · registrar `microbe-model` |
| Visor local y licencia | JS | Misiones con GLB | Opcional | Distribución de model-viewer | `assets/biology_media/model-viewer.min.js` | Visor web | Pendiente · incorporar con el primer GLB |

Consulta [ilustración 2D](biology_2d_asset_guide.md), [videos](biology_video_guide.md) y [Blender](biology_blender_guide.md). Actualiza el registro en `lib/presentation/biology/body_resources.dart` después de incorporar cada recurso.
