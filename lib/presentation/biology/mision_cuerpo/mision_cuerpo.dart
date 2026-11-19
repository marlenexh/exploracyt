import 'package:flutter/material.dart';

import 'contenido.dart';
import 'escena.dart';

import '../../../data/body_topic.dart';
import '../../../main.dart' show store;
import '../body_resources.dart';

class MisionCuerpo extends StatelessWidget {
  const MisionCuerpo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xff70e9d8),
        onPrimary: Color(0xff052e30),
        secondary: Color(0xffb9a5ff),
        surface: Color(0xff15243b),
        onSurface: Color(0xffeef5ff),
      ),
      scaffoldBackgroundColor: const Color(0xff091523),
    );
    return Theme(
      data: theme,
      child: _Mapa(theme: theme),
    );
  }
}

const _iconos = {
  Sistema.circulatorio: Icons.favorite_outline,
  Sistema.respiratorio: Icons.air,
  Sistema.inmunologico: Icons.shield_outlined,
};

class _Mapa extends StatefulWidget {
  const _Mapa({required this.theme});
  final ThemeData theme;

  @override
  State<_Mapa> createState() => _MapaState();
}

class _MapaState extends State<_Mapa> {
  final _insignias = <Sistema>{};
  bool _final = false;
  bool _reproduciendo = true;

  @override
  Widget build(BuildContext context) {
    return _Pantalla(
      titulo: 'Misión Cuerpo Humano',
      contenido: [
        const _Etiqueta('TEMA 1  ·  5.º Y 6.º DE PRIMARIA'),
        const _Titulo('Explora tu cuerpo'),
        const Text(
          '¿Cómo llega el oxígeno a los músculos? ¿Qué hace el cuerpo al encontrar un microbio? Gana una insignia en cada misión para resolver el reto final.',
        ),
        EscenaCuerpo(reproduciendo: _reproduciendo),
        _ControlAnimacion(
          activo: _reproduciendo,
          cambiar: () => setState(() => _reproduciendo = !_reproduciendo),
        ),
        _Tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${_insignias.length} de 3 insignias'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _insignias.length / 3,
                semanticsLabel: 'Insignias conseguidas',
              ),
            ],
          ),
        ),
        for (final sistema in Sistema.values)
          _Tarjeta(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(_iconos[sistema], color: acentos[sistema]),
              title: Text(misiones[sistema]!.nombre),
              subtitle: Text(misiones[sistema]!.resumen),
              trailing: Icon(
                _insignias.contains(sistema)
                    ? Icons.verified
                    : Icons.chevron_right,
              ),
              onTap: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => Theme(
                    data: widget.theme,
                    child: _Estacion(
                      sistema: sistema,
                      ganada: _insignias.contains(sistema),
                      alCompletar: () =>
                          setState(() => _insignias.add(sistema)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        FilledButton.icon(
          onPressed: _insignias.length == 3
              ? () => Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (_) => Theme(
                        data: widget.theme,
                        child: _Pantalla(
                          titulo: 'Reto final',
                          contenido: [
                            const _Titulo('Los sistemas trabajan juntos'),
                            _Cuestionario(
                              preguntas: const [retoFinal],
                              mensaje:
                                  '¡Misión cumplida! Ya puedes explicar cómo colaboran tus sistemas.',
                              alCompletar: () => setState(() => _final = true),
                            ),
                            const _Tarjeta(
                              child: Text(
                                'Pregunta de científico: si el cuerpo vuelve del ejercicio al reposo, ¿qué cambios esperarías en el pulso y la respiración? Explica por qué.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
              : null,
          icon: Icon(
            _final
                ? Icons.emoji_events_outlined
                : _insignias.length == 3
                    ? Icons.flag_outlined
                    : Icons.lock_outline,
          ),
          label: Text(_final ? 'Reto final completado' : 'Reto final'),
        ),
      ],
    );
  }
}

enum _Seccion { recorrido, laboratorio, retos, video }

class _Estacion extends StatefulWidget {
  const _Estacion({
    required this.sistema,
    required this.ganada,
    required this.alCompletar,
  });
  final Sistema sistema;
  final bool ganada;
  final VoidCallback alCompletar;

  @override
  State<_Estacion> createState() => _EstacionState();
}

class _EstacionState extends State<_Estacion> {
  _Seccion _seccion = _Seccion.recorrido;
  int _paso = 0;
  bool? _prediccion;
  double _nivel = 0;
  bool _comparado = false;
  bool _reproduciendo = true;
  late bool _ganada;

  @override
  void initState() {
    super.initState();
    _ganada = widget.ganada;
  }

  Mision get _mision => misiones[widget.sistema]!;

  @override
  Widget build(BuildContext context) {
    final pasos = _mision.pasos;
    return _Pantalla(
      titulo: 'Sistema ${_mision.nombre.toLowerCase()}',
      contenido: [
        _Etiqueta(
          _ganada ? 'INSIGNIA CONSEGUIDA' : 'ESTACIÓN DE INVESTIGACIÓN',
          color: acentos[widget.sistema],
        ),
        _Titulo(_mision.titulo),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            for (final (seccion, nombre) in const [
              (_Seccion.recorrido, 'Recorrido'),
              (_Seccion.laboratorio, 'Laboratorio'),
              (_Seccion.retos, 'Retos'),
              (_Seccion.video, 'Video'),
            ])
              ChoiceChip(
                label: Text(nombre),
                selected: _seccion == seccion,
                onSelected: (_) => setState(() => _seccion = seccion),
              ),
          ],
        ),
        if (_seccion == _Seccion.recorrido) ...[
          EscenaCuerpo(
            sistema: widget.sistema,
            paso: _paso,
            reproduciendo: _reproduciendo,
          ),
          _ControlAnimacion(
            activo: _reproduciendo,
            cambiar: () => setState(() => _reproduciendo = !_reproduciendo),
          ),
          _Tarjeta(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Etiqueta(
                  'PASO ${_paso + 1} DE ${pasos.length}',
                  color: acentos[widget.sistema],
                ),
                const SizedBox(height: 8),
                Text(
                  pasos[_paso].titulo,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(pasos[_paso].texto),
              ],
            ),
          ),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: _paso == 0 ? null : () => setState(() => _paso--),
                child: const Text('Anterior'),
              ),
              FilledButton(
                onPressed: () => setState(() {
                  if (_paso + 1 == pasos.length) {
                    _seccion = _Seccion.laboratorio;
                  } else {
                    _paso++;
                  }
                }),
                child: Text(
                  _paso + 1 == pasos.length ? 'Ir al laboratorio' : 'Siguiente',
                ),
              ),
            ],
          ),
        ],
        if (_seccion == _Seccion.laboratorio) ..._laboratorio(),
        if (_seccion == _Seccion.retos)
          _Cuestionario(
            preguntas: _mision.retos,
            mensaje:
                '¡Insignia del sistema ${_mision.nombre.toLowerCase()} conseguida!',
            alCompletar: () {
              setState(() => _ganada = true);
              widget.alCompletar();
            },
          ),
        if (_seccion == _Seccion.video)
          _Tarjeta(
            child: BodyResourcePanel(
              system: switch (widget.sistema) {
                Sistema.circulatorio => BodySystem.circulation,
                Sistema.respiratorio => BodySystem.breathing,
                Sistema.inmunologico => BodySystem.defense,
              },
              type: BodyResourceType.video,
            ),
          ),
      ],
    );
  }

  List<Widget> _laboratorio() {
    final inmune = widget.sistema == Sistema.inmunologico;
    final lectura = switch (widget.sistema) {
      Sistema.circulatorio =>
        '${(72 + _nivel * 72).round()} latidos/min en el modelo',
      Sistema.respiratorio =>
        '${(55 + _nivel * 45).round()} % del volumen máximo del modelo',
      Sistema.inmunologico => _nivel == 0
          ? 'Respuesta a las 6 unidades de tiempo'
          : 'Respuesta a las 3 unidades de tiempo',
    };
    return [
      _Tarjeta(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _mision.investigacion,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const Text('Primero, elige una predicción.'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final (valor, texto) in [
                  (true, _mision.prediccion),
                  (false, _mision.alternativa),
                ])
                  ChoiceChip(
                    label: Text(texto),
                    selected: _prediccion == valor,
                    onSelected: (_) => setState(() {
                      _prediccion = valor;
                      _nivel = 0;
                      _comparado = false;
                    }),
                  ),
              ],
            ),
          ],
        ),
      ),
      if (_prediccion != null) ...[
        EscenaCuerpo(
          sistema: widget.sistema,
          nivel: _nivel,
          reproduciendo: _reproduciendo,
        ),
        _ControlAnimacion(
          activo: _reproduciendo,
          cambiar: () => setState(() => _reproduciendo = !_reproduciendo),
        ),
        _Tarjeta(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _mision.variable,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Text('Compara los dos extremos del control.'),
              Slider(
                value: _nivel,
                divisions: inmune ? 1 : 4,
                semanticFormatterCallback: (valor) => valor == 0
                    ? _mision.minimo
                    : valor == 1
                        ? _mision.maximo
                        : '${(valor * 100).round()} %',
                onChanged: (valor) => setState(() {
                  _nivel = valor;
                  if (valor == 1) _comparado = true;
                }),
              ),
              Row(
                children: [
                  Expanded(child: Text(_mision.minimo)),
                  Expanded(
                    child: Text(_mision.maximo, textAlign: TextAlign.end),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(liveRegion: true, child: Text(lectura)),
            ],
          ),
        ),
        if (_comparado)
          _Tarjeta(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Etiqueta(
                  _prediccion == _mision.prediccionCorrecta
                      ? 'TU PREDICCIÓN COINCIDE'
                      : 'REVISA TU PREDICCIÓN',
                ),
                const SizedBox(height: 8),
                Text(_mision.conclusion),
                TextButton(
                  onPressed: () => setState(() => _seccion = _Seccion.retos),
                  child: const Text('Ir a los retos'),
                ),
              ],
            ),
          ),
      ],
    ];
  }
}

class _Cuestionario extends StatefulWidget {
  const _Cuestionario({
    required this.preguntas,
    required this.mensaje,
    required this.alCompletar,
  });
  final List<Pregunta> preguntas;
  final String mensaje;
  final VoidCallback alCompletar;

  @override
  State<_Cuestionario> createState() => _CuestionarioState();
}

class _CuestionarioState extends State<_Cuestionario> {
  int _indice = 0;
  int? _intento;
  bool _listo = false;

  @override
  Widget build(BuildContext context) {
    if (_listo) {
      return _Tarjeta(
        child: Text(
          widget.mensaje,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    final reto = widget.preguntas[_indice];
    final acierto = _intento == reto.respuesta;
    return _Tarjeta(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Etiqueta('RETO ${_indice + 1} DE ${widget.preguntas.length}'),
          const SizedBox(height: 8),
          Text(reto.pregunta, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (var i = 0; i < reto.opciones.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: acierto ? null : () => setState(() => _intento = i),
                child: Text(reto.opciones[i], textAlign: TextAlign.center),
              ),
            ),
          if (_intento != null)
            Semantics(
              liveRegion: true,
              child: Text(
                acierto
                    ? reto.explicacion
                    : 'Inténtalo de nuevo. ${reto.explicacion}',
              ),
            ),
          if (acierto)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FilledButton(
                onPressed: () {
                  final terminado = _indice + 1 == widget.preguntas.length;
                  setState(() {
                    if (terminado) {
                      _listo = true;
                    } else {
                      _indice++;
                      _intento = null;
                    }
                  });
                  if (terminado) widget.alCompletar();
                },
                child: Text(
                  _indice + 1 == widget.preguntas.length
                      ? 'Terminar'
                      : 'Siguiente reto',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Pantalla extends StatelessWidget {
  const _Pantalla({required this.titulo, required this.contenido});
  final String titulo;
  final List<Widget> contenido;

  @override
  Widget build(BuildContext context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations:
              store.reducirAnim || MediaQuery.disableAnimationsOf(context),
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(titulo),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 690),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final elemento in contenido)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: elemento,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _Titulo extends StatelessWidget {
  const _Titulo(this.texto);
  final String texto;

  @override
  Widget build(BuildContext context) => Text(
        texto,
        style: Theme.of(context)
            .textTheme
            .headlineLarge
            ?.copyWith(fontWeight: FontWeight.w800),
      );
}

class _Etiqueta extends StatelessWidget {
  const _Etiqueta(this.texto, {this.color});
  final String texto;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        texto,
        style: TextStyle(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      );
}

class _Tarjeta extends StatelessWidget {
  const _Tarjeta({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xff263b56)),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      );
}

class _ControlAnimacion extends StatelessWidget {
  const _ControlAnimacion({required this.activo, required this.cambiar});
  final bool activo;
  final VoidCallback cambiar;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: MediaQuery.disableAnimationsOf(context) ? null : cambiar,
          icon: Icon(activo ? Icons.pause : Icons.play_arrow),
          label: Text(activo ? 'Pausar animación' : 'Reproducir animación'),
        ),
      );
}
