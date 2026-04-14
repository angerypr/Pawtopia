import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pet_model.dart';
class PetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addPet(PetModel pet) async {
    await _firestore.collection('pets').doc(pet.id).set(pet.toMap());
  }
  Future<void> updatePet(PetModel pet) async {
    await _firestore.collection('pets').doc(pet.id).update(pet.toMap());
  }
  Future<void> deletePet(String petId) async {
    await _firestore.collection('pets').doc(petId).delete();
  }
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
