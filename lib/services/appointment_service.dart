import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';
import 'package:flutter/foundation.dart';
class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> addAppointment(AppointmentModel appointment) async {
    final snapshot = await _firestore
        .collection('appointments')
        .where('serviceId', isEqualTo: appointment.serviceId)
        .get();
    final sameTimeAppointments = snapshot.docs.where((doc) {
      final data = doc.data();
      if (data['estado'] == 'Cancelada') return false;
      final existingDate = DateTime.parse(data['fecha']).toLocal();
      final newDate = appointment.fecha.toLocal();
      bool isSameDay = existingDate.year == newDate.year && 
                       existingDate.month == newDate.month && 
                       existingDate.day == newDate.day;
      bool isSameTime = data['hora'] == appointment.hora;
      return isSameDay && isSameTime;
    }).toList();
    if (sameTimeAppointments.isNotEmpty) {
      throw Exception('El servicio ya cuenta con una cita reservada para esta fecha y hora.');
    }
    await _firestore.collection('appointments').doc(appointment.id).set(appointment.toMap());
  }
  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    await _firestore.collection('appointments').doc(appointmentId).update({
      'estado': newStatus,
    });
  }
  Stream<List<AppointmentModel>> getUserAppointments(String userId) {
    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
            .map((doc) => AppointmentModel.fromMap(doc.data()))
            .toList();
          list.sort((a, b) {
            int dateCompare = a.fecha.compareTo(b.fecha);
            if (dateCompare != 0) return dateCompare;
            return a.hora.compareTo(b.hora);
          });
          return list;
        });
  }
}
