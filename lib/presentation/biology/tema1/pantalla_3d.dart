import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'comunes.dart';
import 'contenido.dart';
import 'escenas_3d.dart';
import 'motor_3d.dart';
import 'progreso.dart';

class _Modelo {
  const _Modelo(
    this.actividad,
    this.nombre,
    this.icono,
    this.objetivos,
    this.ayuda,
  );
  final String actividad;
  final String nombre;
  final IconData icono;
  final Set<String> objetivos;
  final String ayuda;
}

const _modelos = [
  _Modelo(
    Actividades.simCorazon,
    'Corazón',
    Icons.favorite_rounded,
    {'corazon', 'aorta', 'cavas', 'pulmonar'},
    'Las bolitas rojas viajan con oxígeno; las azules regresan sin él. Cambia los latidos por minuto.',
  ),
  _Modelo(
    Actividades.simPulmones,
    'Pulmones',
    Icons.air_rounded,
    {'pulmones', 'traquea', 'bronquios', 'diafragma'},
    'Mira cómo baja el diafragma cuando entra el aire (azul) y sube cuando sale (gris).',
  ),
  _Modelo(
      Actividades.simCuerpo,
      'Cuerpo',
      Icons.accessibility_new_rounded,
      {
        'cerebro',
        'pulmones',
        'corazon',
        'higado',
        'estomago',
        'intestinos',
      },
      'Usa la “visión de rayos X” para ver los órganos dentro del cuerpo.'),
  _Modelo(
    Actividades.simInmune,
    'Dentro de la sangre',
    Icons.coronavirus_rounded,
    {'globulo_rojo', 'globulo_blanco', 'virus', 'anticuerpo', 'plaqueta'},
    '¡Estás dentro de un vaso sanguíneo! Los anticuerpos amarillos rodean al virus.',
  ),
];

class PantallaSimulacion3D extends StatefulWidget {
  const PantallaSimulacion3D({
    super.key,
    this.inicial = 0,
    this.soloModelo = false,
  });
  final int inicial;

  /// Si es true, muestra solo el modelo [inicial] (sin los botones para cambiar).
  final bool soloModelo;
  @override
  State<PantallaSimulacion3D> createState() => _PantallaSimulacion3DState();
}

class _PantallaSimulacion3DState extends State<PantallaSimulacion3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reloj = AnimationController(
    vsync: this,
    duration: const Duration(days: 1),
  );
  final _cache = CacheSeleccion();
  late int _indice = widget.inicial;
  late Escena3D _escena;
  double _t = 0, _ultimo = 0;
  bool _pausa = false;
  double _yaw = 0.4, _pitch = 0.1, _zoom = 1, _zoomBase = 1;
  bool _autoGiro = true;
  String? _sel;
  double _bpm = 72;
  double _periodo = 4.5;
  double _rayosX = 0.22;
  final Map<int, Set<String>> _descubiertos = {};

  @override
  void initState() {
    super.initState();
    _crearEscena();
    _reloj.addListener(_tick);
    _reloj.forward();
  }

  void _tick() {
    final ahora = (_reloj.lastElapsedDuration?.inMicroseconds ?? 0) / 1e6;
    final dt = (ahora - _ultimo).clamp(0.0, 0.1);
    _ultimo = ahora;
    if (!_pausa) _t += dt;
    if (_autoGiro) _yaw += dt * 0.35;
    setState(() {});
  }

  void _crearEscena() {
    _escena = switch (_indice) {
      0 => escenaCorazon(bpm: () => _bpm),
      1 => escenaPulmones(periodo: () => _periodo),
      2 => escenaCuerpo(),
      _ => escenaInmune(),
    };
    _zoom = _escena.zoomInicial;
    _sel = null;
  }

  @override
  void dispose() {
    _reloj.dispose();
    super.dispose();
  }

  void _tocar(Offset p) {
    final id = _cache.objetoEn(p);
    setState(() {
      _sel = id;
      _autoGiro = false;
    });
    if (id == null) return;
    final m = _modelos[_indice];
    final set = _descubiertos.putIfAbsent(_indice, () => {});
    if (m.objetivos.contains(id) &&
        set.add(id) &&
        set.length == m.objetivos.length) {
      otorgarEstrellas(
        context,
        actividad: m.actividad,
        estrellas: 3,
        titulo: '¡Explorador 3D!',
        mensaje: 'Descubriste todas las partes del modelo “${m.nombre}”.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = _modelos[_indice];
    final descubiertos = _descubiertos[_indice]?.length ?? 0;
    final info = _sel == null ? null : infoOrganos[_sel];
    final chips = widget.soloModelo
        ? null
        : SizedBox(
            height: 58,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              children: [
                for (var i = 0; i < _modelos.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      avatar: Icon(_modelos[i].icono, size: 18),
                      label: Text(_modelos[i].nombre),
                      selected: i == _indice,
                      onSelected: (_) => setState(() {
                        _indice = i;
                        _crearEscena();
                      }),
                    ),
                  ),
              ],
            ),
          );
    final visor = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTapUp: (d) => _tocar(d.localPosition),
                onScaleStart: (_) {
                  _zoomBase = _zoom;
                  _autoGiro = false;
                },
                onScaleUpdate: (d) => setState(() {
                  _yaw += d.focalPointDelta.dx * 0.012;
                  _pitch = (_pitch + d.focalPointDelta.dy * 0.012).clamp(
                    -1.2,
                    1.2,
                  );
                  if (d.pointerCount > 1) {
                    _zoom = (_zoomBase * d.scale).clamp(0.5, 2.6);
                  }
                }),
                child: CustomPaint(
                  painter: Pintor3D(
                    escena: _escena,
                    t: _t,
                    yaw: _yaw,
                    pitch: _pitch,
                    zoom: _zoom,
                    cache: _cache,
                    seleccionado: _sel,
                    opacidadExtra: {'piel': _rayosX},
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: _Etiqueta(
                'Descubiertos: $descubiertos/${m.objetivos.length}',
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Column(
                children: [
                  _BotonRedondo(
                    icono: _pausa ? Icons.play_arrow : Icons.pause,
                    onTap: () => setState(() => _pausa = !_pausa),
                  ),
                  _BotonRedondo(
                    icono: Icons.threesixty,
                    activo: _autoGiro,
                    onTap: () => setState(() => _autoGiro = !_autoGiro),
                  ),
                  _BotonRedondo(
                    icono: Icons.zoom_in,
                    onTap: () =>
                        setState(() => _zoom = math.min(2.6, _zoom * 1.2)),
                  ),
                  _BotonRedondo(
                    icono: Icons.zoom_out,
                    onTap: () =>
                        setState(() => _zoom = math.max(0.5, _zoom / 1.2)),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 6,
              child: Center(
                child: _Etiqueta(
                  'Arrastra para girar · pellizca para acercar · toca una parte',
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final info0 = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Padding(
        key: ValueKey(_sel ?? m.nombre),
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: info == null
            ? BurbujaCora(texto: m.ayuda, tamCora: 52)
            : _TarjetaInfo(info),
      ),
    );
    return Scaffold(
      appBar: barraJuego(
        widget.soloModelo ? m.nombre : 'Simulaciones 3D',
        ColoresJuego.sim3d,
      ),
      body: LayoutBuilder(
        builder: (context, cons) {
          if (cons.maxWidth > cons.maxHeight * 1.2) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: visor,
                  ),
                ),
                SizedBox(
                  width: math.min(360, cons.maxWidth * 0.38),
                  child: ListView(
                    padding: const EdgeInsets.only(right: 6, bottom: 12),
                    children: [if (chips != null) chips, _controles(), info0],
                  ),
                ),
              ],
            );
          }
          return Column(
            children: [
              if (chips != null) chips,
              Expanded(child: visor),
              _controles(),
              info0,
            ],
          );
        },
      ),
    );
  }

  Widget _controles() {
    Widget fila(String etiqueta, Widget control) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(
                width: 132,
                child: Text(
                  etiqueta,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: control),
            ],
          ),
        );
    switch (_indice) {
      case 0:
        return fila(
          '❤️ ${_bpm.round()} latidos/min',
          Slider(
            min: 40,
            max: 180,
            value: _bpm,
            activeColor: ColoresJuego.circulatorio,
            onChanged: (v) => setState(() => _bpm = v),
          ),
        );
      case 1:
        return fila(
          '🌬️ ${(60 / _periodo).round()} respiraciones/min',
          Slider(
            min: 2,
            max: 8,
            value: 10 - _periodo,
            activeColor: ColoresJuego.respiratorio,
            onChanged: (v) => setState(() => _periodo = 10 - v),
          ),
        );
      case 2:
        return fila(
          '🩻 Rayos X',
          Slider(
            min: 0,
            max: 0.8,
            value: 0.8 - _rayosX,
            onChanged: (v) => setState(() => _rayosX = 0.8 - v),
          ),
        );
      default:
        return const SizedBox(height: 8);
    }
  }
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto);
  final String texto;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 12.5),
        ),
      );
}

class _BotonRedondo extends StatelessWidget {
  const _BotonRedondo({
    required this.icono,
    required this.onTap,
    this.activo = false,
  });
  final IconData icono;
  final VoidCallback onTap;
  final bool activo;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Material(
          color: activo ? Colors.white : Colors.white24,
          shape: const CircleBorder(),
          child: IconButton(
            icon:
                Icon(icono, color: activo ? ColoresJuego.sim3d : Colors.white),
            onPressed: onTap,
          ),
        ),
      );
}

class _TarjetaInfo extends StatelessWidget {
  const _TarjetaInfo(this.info);
  final InfoOrgano info;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColoresJuego.sim3d.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    info.nombre,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Flexible(
                  child: Chip(
                    label: Text(
                      info.sistema,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
            Text(
              info.descripcion,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),
            const SizedBox(height: 6),
            Text(
              '💡 ${info.dato}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
}
