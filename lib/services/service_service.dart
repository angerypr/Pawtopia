import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/service_model.dart';
class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<List<ServiceModel>> getServices() {
    return _firestore.collection('services').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => ServiceModel.fromMap(doc.data())).toList());
  }
  Future<void> populateTestServices() async {
    final QuerySnapshot query = await _firestore.collection('services').limit(1).get();
    if(query.docs.isNotEmpty) return;
    final services = [
      ServiceModel(id: _firestore.collection('services').doc().id, nombre: 'Consulta General', descripcion: 'Revisión médica completa para tu mascota.', precio: 30.0, duracion: 30),
      ServiceModel(id: _firestore.collection('services').doc().id, nombre: 'Vacunación', descripcion: 'Aplicación de vacunas necesarias según especie y edad.', precio: 20.0, duracion: 15),
      ServiceModel(id: _firestore.collection('services').doc().id, nombre: 'Peluquería Canina/Felina', descripcion: 'Baño, corte de pelo y limpieza de oídos.', precio: 40.0, duracion: 60),
      ServiceModel(id: _firestore.collection('services').doc().id, nombre: 'Estudios de Laboratorio', descripcion: 'Análisis de sangre y otros estudios clínicos.', precio: 60.0, duracion: 45),
    ];
    for (var s in services) {
      await _firestore.collection('services').doc(s.id).set(s.toMap());
    }
  }
}
