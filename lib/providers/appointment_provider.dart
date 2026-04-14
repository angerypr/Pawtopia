import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/appointment_service.dart';
class AppointmentProvider with ChangeNotifier {
  final AppointmentService _service = AppointmentService();
  Stream<List<AppointmentModel>> getUserAppointmentsStream(String userId) {
    return _service.getUserAppointments(userId);
  }
  Future<void> addAppointment(AppointmentModel appointment) async {
    await _service.addAppointment(appointment);
    notifyListeners();
  }
  Future<void> changeStatus(String appointmentId, String newStatus) async {
    await _service.updateAppointmentStatus(appointmentId, newStatus);
    notifyListeners();
  }
  Future<void> cancelAppointment(String appointmentId) async {
    await changeStatus(appointmentId, 'Cancelada');
  }
}
