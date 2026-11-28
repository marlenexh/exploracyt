import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:explora_ciencia/data/enlaces_videos.dart';
import 'package:explora_ciencia/presentation/biology/tema1/misiones.dart' show ConfiguracionJuego;
import 'package:explora_ciencia/presentation/biology/temas/motor.dart';
import 'package:explora_ciencia/presentation/biology/temas/tema2.dart';
import 'package:explora_ciencia/presentation/biology/temas/tema3.dart';
import 'package:explora_ciencia/presentation/biology/temas/tema4.dart';
import 'package:explora_ciencia/presentation/biology/temas/tema5.dart';
import 'package:explora_ciencia/presentation/electronica/electronica_screen.dart';
import 'package:explora_ciencia/presentation/fisica/fisica_screen.dart';
import 'package:explora_ciencia/presentation/ia/ia_screen.dart';
import 'package:explora_ciencia/presentation/programacion/programacion_screen.dart';
import 'package:explora_ciencia/presentation/quimica/quimica_screen.dart';
import 'package:explora_ciencia/presentation/videos/video_youtube.dart';

void main() {
  test('Se reconoce el video en cualquier formato de enlace de YouTube', () {
    const id = 'dQw4w9WgXcQ';
    for (final e in [
      'https://www.youtube.com/watch?v=$id',
      'https://youtube.com/watch?v=$id&t=30s',
      'https://m.youtube.com/watch?v=$id&list=PL123',
      'https://youtu.be/$id',
      'https://youtu.be/$id?si=AbCdEf123',
      'https://www.youtube.com/shorts/$id',
      'https://www.youtube.com/embed/$id',
      'https://www.youtube-nocookie.com/embed/$id',
      '  https://www.youtube.com/watch?v=$id  ',
    ]) {
      expect(idYoutube(e), id, reason: e);
    }
  });

  test('Lo que no es un video de YouTube no se confunde', () {
    for (final e in [
      '',
      'assets/videos/ia_que_es.mp4',
      'https://mi-servidor.com/video.mp4',
      'https://www.youtube.com/',
      'https://www.youtube.com/watch?v=corto',
      'hola'
    ]) {
      expect(idYoutube(e), isNull, reason: e);
    }
  });

  test('El archivo de enlaces tiene exactamente los videos de todos los temas', () {
    final temas = <TemaBio>[
      tema2,
      tema3,
      tema4,
      tema5,
      ...temasEle.values,
      ...temasPro.values,
      ...temasQui.values,
      ...temasFis.values,
      ...temasIA.values,
    ];
    final claves = {...ConfiguracionJuego.videosPorDefecto.keys, for (final t in temas) ...t.videos.keys};
    expect(enlacesVideos.keys.toSet(), claves);
    expect(enlacesVideos.length, 90);
    // 32 videos: uno por tema (misión 3) y uno por misión en Biología tema 1
    expect(enlacesVideos.values.where((v) => v.trim().isNotEmpty).length, 32);
    for (final MapEntry(:key, :value) in enlacesVideos.entries) {
      if (value.trim().isNotEmpty) expect(idYoutube(value), isNotNull, reason: 'El enlace de “$key” no es un video de YouTube válido');
    }
  });

  testWidgets('Sin internet la carátula avisa y no muestra Reproducir', (tester) async {
    await tester
        .pumpWidget(MaterialApp(home: Scaffold(body: SizedBox(width: 576, height: 340, child: PortadaYoutube(id: 'dQw4w9WgXcQ', onReproducir: () {})))));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // En las pruebas no hay internet: la imagen falla
    expect(find.text('Sin conexión a internet'), findsOneWidget);
    expect(find.byTooltip('Reproducir video'), findsNothing);
  });
}
