import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pet_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/appointment_provider.dart';
import '../../models/appointment_model.dart';
import '../../models/pet_model.dart';
import '../../models/service_model.dart';
class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({super.key});
  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}
class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPetId;
  String? _selectedServiceId;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() => _selectedTime = picked);
    }
  }
  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedPetId == null || _selectedServiceId == null || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona mascota, servicio, fecha y hora.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    final hourString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    final appointment = AppointmentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fecha: _selectedDate!,
      hora: hourString,
      petId: _selectedPetId!,
      serviceId: _selectedServiceId!,
      userId: userId,
      estado: 'Pendiente',
    );
    try {
      await context.read<AppointmentProvider>().addAppointment(appointment);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita creada exitosamente')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    final petProvider = context.read<PetProvider>();
    final serviceProvider = context.read<ServiceProvider>();
    final userId = context.read<AuthProvider>().user?.id ?? '';
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Cita')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StreamBuilder<List<PetModel>>(
                      stream: petProvider.getUserPetsStream(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        final pets = snapshot.data ?? [];
                        if (pets.isEmpty) {
                          return const Text('Debes registrar una mascota primero.', style: TextStyle(color: Colors.red));
                        }
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Selecciona tu Mascota',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.pets),
                          ),
                          value: _selectedPetId,
                          items: pets.map((pet) {
                            return DropdownMenuItem(
                              value: pet.id,
                              child: Text(pet.nombre),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedPetId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<List<ServiceModel>>(
                      stream: serviceProvider.getServicesStream(),
                      builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                          return const LinearProgressIndicator();
                        }
                        final services = snapshot.data ?? [];
                        if (services.isEmpty) {
                           return const Text('No hay servicios disponibles.', style: TextStyle(color: Colors.red));
                        }
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Selecciona un Servicio',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.local_hospital),
                          ),
                          value: _selectedServiceId,
                          items: services.map((service) {
                            return DropdownMenuItem(
                              value: service.id,
                              child: Text('${service.nombre} (\$${service.precio})'),
                            );
                          }).toList(),
                          onChanged: (val) => setState(() => _selectedServiceId = val),
                          validator: (val) => val == null ? 'Requerido' : null,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.calendar_month),
                            label: Text(_selectedDate == null
                                ? 'Elegir Fecha'
                                : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'),
                            onPressed: _selectDate,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.access_time),
                            label: Text(_selectedTime == null
                                ? 'Elegir Hora'
                                : _selectedTime!.format(context)),
                            onPressed: _selectTime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      onPressed: _submit,
                      child: const Text('Confirmar Cita'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
