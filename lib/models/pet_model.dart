class PetModel {
  final String id;
  final String nombre;
  final String tipo;
  final String raza;
  final int edad;
  final String ownerId;

  PetModel({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.raza,
    required this.edad,
    required this.ownerId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'tipo': tipo,
    'raza': raza,
    'edad': edad,
    'ownerId': ownerId,
  };

  factory PetModel.fromMap(Map<String, dynamic> map) => PetModel(
    id: map['id'] ?? '',
    nombre: map['nombre'] ?? '',
    tipo: map['tipo'] ?? '',
    raza: map['raza'] ?? '',
    edad: map['edad'] ?? 0,
    ownerId: map['ownerId'] ?? '',
  );
}