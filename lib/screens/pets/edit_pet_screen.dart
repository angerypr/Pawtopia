import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pet_provider.dart';
import '../../models/pet_model.dart';
class EditPetScreen extends StatefulWidget {
  final PetModel pet;
  const EditPetScreen({super.key, required this.pet});
  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}
class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _tipo;
  late String _raza;
  late int _edad;
  final List<String> _tiposMascota = ['Perro', 'Gato', 'Ave', 'Otro'];
  @override
  void initState() {
    super.initState();
    _nombre = widget.pet.nombre;
    _tipo = _tiposMascota.contains(widget.pet.tipo) ? widget.pet.tipo : 'Otro';
    _raza = widget.pet.raza;
    _edad = widget.pet.edad;
  }
  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final petProvider = context.read<PetProvider>();
      final updatedPet = PetModel(
        id: widget.pet.id,
        nombre: _nombre,
        tipo: _tipo,
        raza: _raza,
        edad: _edad,
        ownerId: widget.pet.ownerId,
      );
      try {
        await petProvider.updatePet(updatedPet);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mascota actualizada')),
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
  Future<void> _delete() async {
    final petProvider = context.read<PetProvider>();
    try {
      await petProvider.deletePet(widget.pet.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mascota eliminada')),
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
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<PetProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Mascota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmar Eliminación'),
                    content: const Text('¿Estás seguro de eliminar esta mascota?'),
                    actions: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _delete();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _nombre,
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
                initialValue: _raza,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator: (value) => value!.isEmpty ? 'Ingresa la raza' : null,
                onSaved: (value) => _raza = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _edad.toString(),
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
                      child: const Text('Actualizar Mascota'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
