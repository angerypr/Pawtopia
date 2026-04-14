class UserModel {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final DateTime createdAt;
  UserModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.createdAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      nombre: map['nombre'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
