import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pet_provider.dart';
import '../../models/pet_model.dart';
import 'add_pet_screen.dart';
import 'edit_pet_screen.dart';
class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mascotas'),
      ),
      body: userId.isEmpty
          ? const Center(child: Text('Error: No has iniciado sesión.'))
          : StreamBuilder<List<PetModel>>(
              stream: context.read<PetProvider>().getUserPetsStream(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar mascotas.'));
                }
                final pets = snapshot.data ?? [];
                if (pets.isEmpty) {
                  return const Center(child: Text('No tienes mascotas registradas.'));
                }
                return ListView.builder(
                  itemCount: pets.length,
                  itemBuilder: (context, index) {
                    final pet = pets[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            pet.tipo.toLowerCase() == 'gato' ? Icons.pets : Icons.pets_outlined,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                        title: Text(pet.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${pet.tipo} - ${pet.raza} (${pet.edad} años)'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPetScreen(pet: pet),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddPetScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
