class AppointmentModel {
  final String id;
  final DateTime fecha;
  final String hora;
  final String petId;
  final String serviceId;
  final String userId;
  final String estado;

  AppointmentModel({
    required this.id,
    required this.fecha,
    required this.hora,
    required this.petId,
    required this.serviceId,
    required this.userId,
    required this.estado,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'fecha': fecha.toIso8601String(),
    'hora': hora,
    'petId': petId,
    'serviceId': serviceId,
    'userId': userId,
    'estado': estado,
  };

  factory AppointmentModel.fromMap(Map<String, dynamic> map) => AppointmentModel(
    id: map['id'] ?? '',
    fecha: DateTime.parse(map['fecha']),
    hora: map['hora'] ?? '',
    petId: map['petId'] ?? '',
    serviceId: map['serviceId'] ?? '',
    userId: map['userId'] ?? '',
    estado: map['estado'] ?? 'Pendiente',
  );
}
