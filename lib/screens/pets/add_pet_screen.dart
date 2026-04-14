import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pet_provider.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _tipo = 'Perro';
  String _raza = '';
  int _edad = 0;

  final List<String> _tiposMascota = ['Perro', 'Gato', 'Ave', 'Otro'];

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authProvider = context.read<AuthProvider>();
      final petProvider = context.read<PetProvider>();
      final userId = authProvider.user?.id;

      if (userId == null) return;

      try {
        await petProvider.addPet(_nombre, _tipo, _raza, _edad, userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mascota agregada exitosamente')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PetProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Mascota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
               TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) => value!.isEmpty ? 'Ingresa el nombre' : null,
                onSaved: (value) => _nombre = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo de mascota'),
                items: _tiposMascota.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _tipo = value!),
                onSaved: (value) => _tipo = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) => value!.isEmpty ? 'Ingresa la raza' : null,
                onSaved: (value) => _raza = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Edad (años)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Ingresa la edad';
                  if (int.tryParse(value) == null) return 'Ingresa un número válido';
                  return null;
                },
                onSaved: (value) => _edad = int.parse(value!),
              ),
              const SizedBox(height: 24),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Guardar Mascota'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
