import 'dart:async';

import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// Obtiene el identificador de 11 caracteres de un enlace de YouTube.
///
/// Acepta enlaces como:
/// - https://www.youtube.com/watch?v=dQw4w9WgXcQ
/// - https://youtu.be/dQw4w9WgXcQ?si=abc
/// - https://www.youtube.com/shorts/dQw4w9WgXcQ
/// - https://www.youtube.com/embed/dQw4w9WgXcQ
/// - https://m.youtube.com/watch?v=dQw4w9WgXcQ&t=30s
/// Devuelve null si no es un enlace de YouTube válido.
String? idYoutube(String enlace) {
  final texto = enlace.trim();
  final uri = Uri.tryParse(texto);
  if (uri == null || !uri.hasScheme) return null;
  final host = uri.host.toLowerCase().replaceFirst('www.', '').replaceFirst('m.', '');
  String? id;
  if (host == 'youtu.be') {
    id = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
  } else if (host == 'youtube.com' || host == 'youtube-nocookie.com' || host == 'music.youtube.com') {
    final seg = uri.pathSegments;
    if (seg.isNotEmpty && seg.first == 'watch') {
      id = uri.queryParameters['v'];
    } else if (seg.length >= 2 && const ['shorts', 'embed', 'live', 'v'].contains(seg.first)) {
      id = seg[1];
    }
  }
  if (id == null || !RegExp(r'^[A-Za-z0-9_-]{11}$').hasMatch(id)) return null;
  return id;
}

/// Reproductor de YouTube dentro del juego. Avisa con [onVisto] cuando se ha
/// visto al menos el 80 % del video (o terminó) y con [onError] si YouTube no
/// permite reproducirlo aquí.
class ReproductorYoutube extends StatefulWidget {
  const ReproductorYoutube({super.key, required this.id, required this.onVisto, required this.onError, this.autoPlay = false});
  final String id;

  /// Empieza a reproducirse en cuanto carga (cuando el alumno ya tocó Reproducir).
  final bool autoPlay;
  final VoidCallback onVisto;
  final VoidCallback onError;

  @override
  State<ReproductorYoutube> createState() => _ReproductorYoutubeState();
}

class _ReproductorYoutubeState extends State<ReproductorYoutube> {
  late final YoutubePlayerController _ctrl = YoutubePlayerController.fromVideoId(
    videoId: widget.id,
    autoPlay: widget.autoPlay,
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      strictRelatedVideos: true,
      showVideoAnnotations: false,
      interfaceLanguage: 'es',
      captionLanguage: 'es',
    ),
  );
  StreamSubscription<YoutubeVideoState>? _estado;
  StreamSubscription<YoutubePlayerValue>? _valor;

  /// Por si YouTube no carga y no avisa del error (por ejemplo, sin internet):
  /// el alumno puede continuar después de un rato.
  Timer? _respaldo;
  double _duracion = 0;
  bool _avisado = false;

  void _visto() {
    if (_avisado) return;
    _avisado = true;
    widget.onVisto();
  }

  @override
  void initState() {
    super.initState();
    _respaldo = Timer(const Duration(seconds: 90), _visto);
    _valor = _ctrl.stream.listen((v) {
      if (v.playerState == PlayerState.ended) _visto();
      if (v.error != YoutubeError.none) widget.onError();
      if (v.metaData.duration > Duration.zero) _duracion = v.metaData.duration.inMilliseconds / 1000;
    });
    _estado = _ctrl.videoStateStream.listen((s) async {
      if (_duracion <= 0) {
        try {
          _duracion = await _ctrl.duration;
        } catch (_) {}
      }
      if (_duracion > 0 && s.position.inMilliseconds / 1000 >= _duracion * 0.8) _visto();
    });
  }

  @override
  void dispose() {
    _respaldo?.cancel();
    _estado?.cancel();
    _valor?.cancel();
    _ctrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: AspectRatio(aspectRatio: 16 / 9, child: YoutubePlayer(controller: _ctrl, backgroundColor: Colors.black)),
      );
}

/// Carátula del video de YouTube con el botón “Reproducir”. La imagen viene
/// de internet; si no hay conexión se avisa que el video necesita internet y
/// no se muestra el botón.
class PortadaYoutube extends StatefulWidget {
  const PortadaYoutube({super.key, required this.id, required this.onReproducir});
  final String id;
  final VoidCallback onReproducir;

  static String miniatura(String id) => 'https://img.youtube.com/vi/$id/hqdefault.jpg';

  @override
  State<PortadaYoutube> createState() => PortadaYoutubeState();
}

class PortadaYoutubeState extends State<PortadaYoutube> {
  /// No se pudo cargar la carátula: probablemente no hay internet.
  bool sinConexion = false;

  void _marcarSinConexion() {
    if (sinConexion) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => sinConexion = true);
    });
  }

  @override
  Widget build(BuildContext context) => Stack(fit: StackFit.expand, children: [
        Image.network(
          PortadaYoutube.miniatura(widget.id),
          fit: BoxFit.cover,
          webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
          loadingBuilder: (_, hijo, avance) =>
              avance == null ? hijo : const ColoredBox(color: Color(0xFF1B1446), child: Center(child: CircularProgressIndicator(color: Colors.white))),
          errorBuilder: (_, __, ___) {
            _marcarSinConexion();
            return const ColoredBox(
              color: Color(0xFF1B1446),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('📶', style: TextStyle(fontSize: 52)),
                    SizedBox(height: 6),
                    Text('Sin conexión a internet', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    SizedBox(height: 4),
                    Text('Este video solo se puede ver con internet. Presiona “Continuar con mi aventura” y míralo después.',
                        textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ]),
                ),
              ),
            );
          },
        ),
        if (!sinConexion) ...[
          const DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x00000000), Color(0x99000000)])),
          ),
          Center(
            child: Tooltip(
              message: 'Reproducir video',
              child: Material(
                color: const Color(0xFFFF0033),
                shape: const StadiumBorder(),
                elevation: 8,
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: widget.onReproducir,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                      SizedBox(width: 6),
                      Text('Reproducir', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            left: 12,
            bottom: 10,
            right: 12,
            child: Text('🌐 Necesitas internet para ver el video',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800, shadows: [Shadow(blurRadius: 4)])),
          ),
        ],
      ]);
}
