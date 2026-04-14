import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/service_provider.dart';
import '../../models/service_model.dart';
import 'service_detail_screen.dart';

class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Optionally create dummy services if empty (Just for testing/admins)
    // context.read<ServiceProvider>().createDummyServices();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Cargar Servicios de Prueba',
            onPressed: () {
              context.read<ServiceProvider>().createDummyServices().then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Servicios de prueba cargados')),
                );
              });
            },
          )
        ],
      ),
      body: StreamBuilder<List<ServiceModel>>(
        stream: context.read<ServiceProvider>().getServicesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar servicios.'));
          }

          final services = snapshot.data ?? [];
          if (services.isEmpty) {
            return const Center(
              child: Text(
                'No hay servicios disponibles.\n(Usa el ícono en la barra para cargar de prueba)',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.local_hospital, color: Colors.teal),
                  title: Text(service.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('\$${service.precio.toStringAsFixed(2)} - ${service.duracion} min.'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ServiceDetailScreen(service: service),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
