import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventoCientifico {
  final String id;
  final String nombre;
  final String descripcion;
  final String categoria;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String horario;
  final String lugar;
  final String modalidad;
  final String organizador;
  final String costo;
  final String publico;
  final String enlaceOficial;

  const EventoCientifico({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.fechaInicio,
    this.fechaFin,
    required this.horario,
    required this.lugar,
    required this.modalidad,
    required this.organizador,
    required this.costo,
    required this.publico,
    required this.enlaceOficial,
  });
}

// Aquí agregaremos únicamente eventos reales y verificados.
const List<EventoCientifico> eventosCientificos = [];

const List<String> categoriasEventos = [
  'Todos',
  'Ferias',
  'Talleres',
  'Concursos',
  'Conferencias',
  'Campamentos',
];

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  String categoriaSeleccionada = 'Todos';
  String filtroFecha = 'Próximos';
  String busqueda = '';

  bool _esProximo(EventoCientifico e) {
    final hoy = DateTime.now();
    final fin = e.fechaFin ?? e.fechaInicio;
    return fin.isAfter(DateTime(hoy.year, hoy.month, hoy.day)
        .subtract(const Duration(days: 1)));
  }

  List<EventoCientifico> get eventosFiltrados {
    return eventosCientificos.where((e) {
      final coincideCategoria = categoriaSeleccionada == 'Todos' ||
          e.categoria == categoriaSeleccionada;

      final coincideBusqueda =
          e.nombre.toLowerCase().contains(busqueda.toLowerCase()) ||
          e.organizador.toLowerCase().contains(busqueda.toLowerCase()) ||
          e.lugar.toLowerCase().contains(busqueda.toLowerCase());

      final coincideFecha = filtroFecha == 'Todos'
          ? true
          : filtroFecha == 'Próximos'
              ? _esProximo(e)
              : !_esProximo(e);

      return coincideCategoria && coincideBusqueda && coincideFecha;
    }).toList()
      ..sort((a, b) => a.fechaInicio.compareTo(b.fechaInicio));
  }

  @override
  Widget build(BuildContext context) {
    final eventos = eventosFiltrados;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2A5B),
        foregroundColor: Colors.white,
        title: const Text(
          'Eventos científicos y tecnológicos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
              decoration: const BoxDecoration(
                color: Color(0xFF0B2A5B),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¡Descubre lo que sucede en la ciencia y tecnología!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    'Encuentra ferias, talleres, concursos y '
                    'actividades de ciencia y tecnología.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => busqueda = v),
                decoration: InputDecoration(
                  hintText: 'Buscar eventos...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            SizedBox(
              height: 48,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                children: categoriasEventos.map((categoria) {
                  final seleccionada =
                      categoriaSeleccionada == categoria;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(categoria),
                      selected: seleccionada,
                      selectedColor: const Color(0xFFFFC933),
                      onSelected: (_) {
                        setState(() {
                          categoriaSeleccionada = categoria;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  const Text(
                    'Actividades',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF232343),
                    ),
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: filtroFecha,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'Próximos',
                        child: Text('Próximos'),
                      ),
                      DropdownMenuItem(
                        value: 'Finalizados',
                        child: Text('Finalizados'),
                      ),
                      DropdownMenuItem(
                        value: 'Todos',
                        child: Text('Todos'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => filtroFecha = v);
                      }
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: eventos.isEmpty
                  ? _estadoVacio()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                      itemCount: eventos.length,
                      itemBuilder: (context, index) {
                        return _tarjetaEvento(eventos[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _estadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.science_outlined,
              size: 75,
              color: Color(0xFF3D5AFE),
            ),
            const SizedBox(height: 16),
            const Text(
              '¡Estamos preparando la exploración!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF232343),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              busqueda.isNotEmpty ||
                      categoriaSeleccionada != 'Todos'
                  ? 'No encontramos eventos con esos filtros.'
                  : 'Pronto encontrarás aquí eventos reales '
                      'de ciencia y tecnología.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tarjetaEvento(EventoCientifico evento) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventoDetalleScreen(evento: evento),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.event,
                    color: Color(0xFF3D5AFE),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    evento.categoria,
                    style: const TextStyle(
                      color: Color(0xFF3D5AFE),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                evento.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF232343),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                evento.descripcion,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(width: 6),
                  Text(_fecha(evento.fechaInicio)),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(evento.lugar)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventoDetalleScreen extends StatelessWidget {
  final EventoCientifico evento;

  const EventoDetalleScreen({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FF),
      appBar: AppBar(
        title: const Text('Detalle del evento'),
        backgroundColor: const Color(0xFF0B2A5B),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Icon(
            Icons.science,
            size: 65,
            color: Color(0xFF3D5AFE),
          ),
          const SizedBox(height: 15),
          Text(
            evento.nombre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF232343),
            ),
          ),
          const SizedBox(height: 12),
          Text(evento.descripcion),
          const SizedBox(height: 22),
          _dato(Icons.category, 'Categoría', evento.categoria),
          _dato(Icons.calendar_month, 'Fecha',
              _fecha(evento.fechaInicio)),
          _dato(Icons.access_time, 'Horario', evento.horario),
          _dato(Icons.location_on, 'Lugar', evento.lugar),
          _dato(Icons.computer, 'Modalidad', evento.modalidad),
          _dato(Icons.account_balance, 'Organiza', evento.organizador),
          _dato(Icons.payments, 'Costo', evento.costo),
          _dato(Icons.groups, 'Dirigido a', evento.publico),
          const SizedBox(height: 20),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0B2A5B),
              padding: const EdgeInsets.all(15),
            ),
            icon: const Icon(Icons.copy),
            label: const Text('Copiar enlace oficial'),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: evento.enlaceOficial),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Enlace copiado'),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _dato(IconData icono, String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: const Color(0xFF3D5AFE)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _fecha(DateTime fecha) {
  const meses = [
    'enero', 'febrero', 'marzo', 'abril',
    'mayo', 'junio', 'julio', 'agosto',
    'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
}