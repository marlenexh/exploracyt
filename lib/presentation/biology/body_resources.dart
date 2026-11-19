import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/body_topic.dart';
import 'media_link_stub.dart'
    if (dart.library.js_interop) 'media_link_web.dart';

enum BodyResourceType { video, illustration, model }

class BodyResource {
  const BodyResource(
    this.id,
    this.system,
    this.type,
    this.title,
    this.expectedFile, {
    this.asset,
    this.youtubeId,
    this.originalUrl,
    this.author,
    this.license,
    this.attribution,
    this.modifications,
    this.captionsAsset,
    this.transcript,
  });

  final String id, title, expectedFile;
  final BodySystem system;
  final BodyResourceType type;
  final String? asset,
      youtubeId,
      originalUrl,
      author,
      license,
      attribution,
      modifications,
      captionsAsset,
      transcript;
  String get stage => 'exploration';
  String get alternative => 'Explora el diagrama 2D y sus etiquetas con Zati.';
}

const bodyResources = [
  BodyResource(
    'heart-video',
    BodySystem.circulation,
    BodyResourceType.video,
    'Cómo circula la sangre',
    'heart.mp4',
  ),
  BodyResource(
    'heart-diagram',
    BodySystem.circulation,
    BodyResourceType.illustration,
    'El recorrido de la sangre',
    'circulation.png',
  ),
  BodyResource(
    'heart-model',
    BodySystem.circulation,
    BodyResourceType.model,
    'El corazón',
    'heart.glb',
  ),
  BodyResource(
    'circulation-model',
    BodySystem.circulation,
    BodyResourceType.model,
    'Sistema circulatorio',
    'circulatory_system.glb',
  ),
  BodyResource(
    'lungs-video',
    BodySystem.breathing,
    BodyResourceType.video,
    'Cómo respiramos',
    'lungs.mp4',
  ),
  BodyResource(
    'lungs-diagram',
    BodySystem.breathing,
    BodyResourceType.illustration,
    'El recorrido del aire',
    'breathing.png',
  ),
  BodyResource(
    'lungs-model',
    BodySystem.breathing,
    BodyResourceType.model,
    'Los pulmones',
    'lungs.glb',
  ),
  BodyResource(
    'breathing-model',
    BodySystem.breathing,
    BodyResourceType.model,
    'Sistema respiratorio',
    'respiratory_system.glb',
  ),
  BodyResource(
    'defense-video',
    BodySystem.defense,
    BodyResourceType.video,
    'Cómo nos defendemos',
    'defense.mp4',
  ),
  BodyResource(
    'defense-diagram',
    BodySystem.defense,
    BodyResourceType.illustration,
    'Las barreras y células de defensa',
    'defense.png',
  ),
  BodyResource(
    'white-cell-model',
    BodySystem.defense,
    BodyResourceType.model,
    'Glóbulo blanco',
    'white_blood_cell.glb',
  ),
  BodyResource(
    'microbe-model',
    BodySystem.defense,
    BodyResourceType.model,
    'Microorganismo',
    'microorganism.glb',
  ),
];

class BodyResourcePanel extends StatefulWidget {
  const BodyResourcePanel({super.key, required this.system, this.type});

  final BodySystem system;
  final BodyResourceType? type;

  @override
  State<BodyResourcePanel> createState() => _BodyResourcePanelState();
}

class _BodyResourcePanelState extends State<BodyResourcePanel> {
  late final Future<Set<String>> bundledAssets =
      AssetManifest.loadFromAssetBundle(
        rootBundle,
      ).then((value) => value.listAssets().toSet());

  @override
  Widget build(BuildContext context) {
    final resources = bodyResources.where(
      (resource) =>
          resource.system == widget.system &&
          (widget.type == null || resource.type == widget.type),
    );
    if (resources.isEmpty) return const SizedBox.shrink();
    return FutureBuilder<Set<String>>(
      future: bundledAssets,
      builder: (context, snapshot) {
        final entries = [
          for (final resource in resources)
            buildResource(resource, snapshot.data ?? const {}),
        ];
        return widget.type == null
            ? ExpansionTile(
                title: const Text('Recursos complementarios'),
                children: entries,
              )
            : Column(children: entries);
      },
    );
  }

  Widget buildResource(BodyResource resource, Set<String> assets) {
    final asset = resource.asset;
    final hasAsset = asset != null && assets.contains(asset);
    final credits = [
      resource.author,
      resource.license,
      resource.attribution,
      resource.modifications,
    ].whereType<String>().join(' · ');
    final youtube = resource.youtubeId;
    final hasYoutube =
        youtube != null && RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(youtube);
    final hasViewer =
        resource.type != BodyResourceType.model ||
        assets.contains('assets/biology_media/model-viewer.min.js');
    return ListTile(
      title: Text(resource.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (credits.isNotEmpty) Text(credits),
          if (resource.transcript case final String transcript)
            Text(transcript),
          if (hasAsset && resource.type == BodyResourceType.illustration)
            Image.asset(
              asset,
              semanticLabel: resource.title,
              errorBuilder: (context, error, stackTrace) =>
                  Text(resource.alternative),
            )
          else if (kIsWeb && (hasAsset && hasViewer || hasYoutube))
            Wrap(
              spacing: 8,
              children: [
                if (hasAsset && hasViewer)
                  TextButton(
                    onPressed: () => openBodyMedia(
                      Uri(
                        path: 'biology-media.html',
                        queryParameters: {
                          'type': resource.type.name,
                          'asset': asset,
                          if (assets.contains(resource.captionsAsset))
                            'captions': resource.captionsAsset!,
                        },
                      ).toString(),
                    ),
                    child: const Text('Abrir recurso local'),
                  ),
                if (hasYoutube)
                  TextButton(
                    onPressed: () => openBodyMedia(
                      Uri(
                        path: 'biology-media.html',
                        queryParameters: {'type': 'youtube', 'id': youtube},
                      ).toString(),
                    ),
                    child: const Text('Ver en YouTube · requiere Internet'),
                  ),
              ],
            )
          else
            Text('En preparación. ${resource.alternative}'),
        ],
      ),
    );
  }
}
