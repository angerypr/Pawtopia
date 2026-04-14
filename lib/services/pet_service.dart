import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';

class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear mascota
  Future<void> addPet(PetModel pet) async {
    await _firestore.collection('pets').doc(pet.id).set(pet.toMap());
  }

  // Editar mascota
  Future<void> updatePet(PetModel pet) async {
    await _firestore.collection('pets').doc(pet.id).update(pet.toMap());
  }

  // Eliminar mascota
  Future<void> deletePet(String petId) async {
    await _firestore.collection('pets').doc(petId).delete();
  }

  // Listar mascotas del usuario
  Stream<List<PetModel>> getUserPets(String userId) {
    return _firestore
        .collection('pets')
        .where('ownerId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PetModel.fromMap(doc.data()))
            .toList());
  }
}
