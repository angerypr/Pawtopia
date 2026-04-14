import 'package:flutter/foundation.dart';
import '../models/pet_model.dart';
import '../services/pet_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetProvider with ChangeNotifier {
  final PetService _petService = PetService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Stream<List<PetModel>> getUserPetsStream(String userId) {
    return _petService.getUserPets(userId);
  }

  Future<void> addPet(String nombre, String tipo, String raza, int edad, String ownerId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final docRef = FirebaseFirestore.instance.collection('pets').doc();
      final newPet = PetModel(
        id: docRef.id,
        nombre: nombre,
        tipo: tipo,
        raza: raza,
        edad: edad,
        ownerId: ownerId,
      );
      await _petService.addPet(newPet);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePet(PetModel pet) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _petService.updatePet(pet);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePet(String petId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _petService.deletePet(petId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
