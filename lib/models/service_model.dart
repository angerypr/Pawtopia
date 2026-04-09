class ServiceModel {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int duracion;

  ServiceModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.duracion,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'nombre': nombre,
    'descripcion': descripcion,
    'precio': precio,
    'duracion': duracion,
  };

  factory ServiceModel.fromMap(Map<String, dynamic> map) => ServiceModel(
    id: map['id'] ?? '',
    nombre: map['nombre'] ?? '',
    descripcion: map['descripcion'] ?? '',
    precio: (map['precio'] ?? 0).toDouble(),
    duracion: map['duracion'] ?? 0,
  );
}
