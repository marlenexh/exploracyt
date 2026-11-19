# Guía para seleccionar e integrar videos educativos

Todos están pendientes de selección. Aparecerán en «Recursos complementarios» de la explicación, después de explorar estructuras y antes del experimento.

| ID y archivo propuesto | Misión | Objetivo y contenidos | Duración orientativa |
| --- | --- | --- | --- |
| `heart-video`, `heart.mp4` | ¡El corazón en acción! | Mostrar el corazón como bomba, los dos circuitos y la relación corazón-pulmones. Debe distinguir dirección del flujo y contenido de oxígeno. | 2–4 min |
| `lungs-video`, `lungs.mp4` | ¡El viaje del aire! | Mostrar inhalación, exhalación, movimiento del diafragma y el intercambio en alvéolos. | 2–4 min |
| `defense-video`, `defense.mp4` | ¡Defensores del cuerpo! | Distinguir barreras y células de defensa. Incluir cuidados cotidianos y explicar que una vacuna prepara defensas específicas con el tiempo. | 3–5 min |

Elige voz en español, ritmo pausado, esquemas claros, subtítulos y lenguaje adecuado para 5.º y 6.º. Comprueba que el video favorezca observar y explicar, y que evite afirmaciones médicas absolutas, imágenes gráficas y llamadas a comprar o registrarse.

1. Revisa el canal, la fuente original, la licencia visible y las condiciones aplicables. Para distribuir un MP4 solicita autorización expresa o confirma una licencia compatible con descarga, alojamiento y los cambios previstos. Atribuir la autoría por sí solo no concede permiso de distribución.
2. En `lib/presentation/biology/body_resources.dart`, actualiza el registro del ID con título, autor, licencia, atribución, cambios y transcripción. Registra el enlace original en `originalUrl` y en la ficha documental. Para YouTube extrae solo el ID de 11 caracteres de la URL oficial y configúralo en `youtubeId`. La aplicación abre el reproductor integrado oficial bajo una acción explícita en línea.
3. Para un archivo autorizado, obtén el original por el medio permitido por su titular. Exporta MP4 H.264/AAC, preferiblemente 720p, y un WebVTT en español (`WEBVTT` en la primera línea, marcas de tiempo y textos). Guárdalos como `assets/biology_media/heart.mp4` y `assets/biology_media/heart.vtt` o los nombres de la misión. Declara la carpeta en `pubspec.yaml` y registra `asset` y `captionsAsset`.
4. Ejemplo de campos con **valores ficticios** para un recurso que aún no debe habilitarse: `author: 'AUTOR POR CONFIRMAR'`, `license: 'LICENCIA POR CONFIRMAR'`, `attribution: 'CRÉDITO POR CONFIRMAR'`, `modifications: 'CAMBIOS POR CONFIRMAR'`. Deja `youtubeId` y `asset` sin valor hasta verificar la fuente.
5. Prueba créditos y subtítulos en línea. Compila con `./tool/build_web.sh`, espera el estado offline, apaga la red y prueba reproducir y avanzar en un MP4 autorizado. Un video de YouTube necesita Internet. La explicación 2D y el resto de la misión deben seguir disponibles.
