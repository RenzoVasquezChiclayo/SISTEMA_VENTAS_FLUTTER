class Estampado {
  final int cod_estampado;
  final String nombre;
  final String imagen;
  final double precio;

  Estampado({
    required this.cod_estampado,
    required this.nombre,
    required this.imagen,
    required this.precio,
  });

  Estampado copyWith({
    int? cod_estampado,
    String? nombre,
    String? imagen,
    double? precio,
  }) {
    return Estampado(
      cod_estampado: cod_estampado ?? this.cod_estampado,
      nombre: nombre ?? this.nombre,
      imagen: imagen ?? this.imagen,
      precio: precio ?? this.precio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_estampado': cod_estampado,
      'nombre': nombre,
      'imagen': imagen,
      'precio': precio,
    };
  }

  factory Estampado.fromJson(Map<String, dynamic> json) {
    return Estampado(
      cod_estampado: int.parse(json['cod_estampado'].toString()),
      nombre: json['nombre'],
      imagen: json['imagen'],
      precio: json['precio'] != null ? double.tryParse(json['precio'].toString()) ?? 0.0 : 0.0,
    );
  }

  @override
  String toString() {
    return 'Estampado{cod_estampado: $cod_estampado, nombre: $nombre, imagen: $imagen, precio: $precio}';
  }
}
