import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/service_provider.dart';
import '../../models/appointment_model.dart';
import 'add_appointment_screen.dart';
class MyAppointmentsScreen extends StatelessWidget {
  const MyAppointmentsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Citas'),
      ),
      body: userId.isEmpty
          ? const Center(child: Text('Error: No has iniciado sesión.'))
          : StreamBuilder<List<AppointmentModel>>(
              stream: context.read<AppointmentProvider>().getUserAppointmentsStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar citas.'));
                }
                final appointments = snapshot.data ?? [];
                if (appointments.isEmpty) {
                  return const Center(child: Text('No tienes citas registradas.'));
                }
                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return _AppointmentCard(appointment: appointment);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddAppointmentScreen()),
          );
        },
        tooltip: 'Nueva Cita',
        child: const Icon(Icons.add),
      ),
    );
  }
}
class _AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  const _AppointmentCard({required this.appointment});
  @override
  Widget build(BuildContext context) {
    final petProvider = context.read<PetProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    return StreamBuilder(
      stream: petProvider.getUserPetsStream(appointment.userId),
      builder: (context, petSnapshot) {
        return StreamBuilder(
          stream: serviceProvider.getServicesStream(),
          builder: (context, serviceSnapshot) {
            String petName = 'Cargando mascota...';
            String serviceName = 'Cargando servicio...';
            if (petSnapshot.hasData) {
              final pets = petSnapshot.data!;
              try {
                petName = pets.firstWhere((p) => p.id == appointment.petId).nombre;
              } catch (_) {
                petName = 'Mascota eliminada';
              }
            }
            if (serviceSnapshot.hasData) {
              final services = serviceSnapshot.data!;
              try {
                serviceName = services.firstWhere((s) => s.id == appointment.serviceId).nombre;
              } catch (_) {
                serviceName = 'Servicio eliminado';
              }
            }
            Color statusColor;
            switch (appointment.estado) {
              case 'Confirmada':
                statusColor = Colors.green;
                break;
              case 'Cancelada':
                statusColor = Colors.red;
                break;
              case 'Completada':
                statusColor = Colors.blueGrey;
                break;
              case 'Pendiente':
              default:
                statusColor = Colors.orange;
                break;
            }
          final dateString = '${appointment.fecha.day.toString().padLeft(2, '0')}/${appointment.fecha.month.toString().padLeft(2, '0')}/${appointment.fecha.year}';
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.2),
                  child: Icon(Icons.calendar_today, color: statusColor),
                ),
                title: Text('$serviceName - $petName', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text('Fecha: $dateString a las ${appointment.hora}'),
                    const SizedBox(height: 2),
                    Text('Estado: ${appointment.estado}', style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                trailing: appointment.estado == 'Pendiente'
                    ? IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.grey),
                        tooltip: 'Cancelar Cita',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Cancelar Cita'),
                              content: const Text('¿Estás seguro de que deseas cancelar esta cita?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Sí, Cancelar', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await context.read<AppointmentProvider>().cancelAppointment(appointment.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cita cancelada correctamente.')),
                              );
                            }
                          }
                        },
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
