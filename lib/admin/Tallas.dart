class Talla {
  final int cod_talla;
  final String descripcion;
  final double precio;

  Talla({
    required this.cod_talla,
    required this.descripcion,
    required this.precio,
  });

  Talla copyWith({
    int? cod_talla,
    String? descripcion,
    double? precio,
  }) {
    return Talla(
      cod_talla: cod_talla ?? this.cod_talla,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_talla': cod_talla,
      'descripcion': descripcion,
      'precio': precio,
    };
  }

  factory Talla.fromJson(Map<String, dynamic> json) {
    return Talla(
      cod_talla: int.parse(json['cod_talla'].toString()),
      descripcion: json['descripcion'],
      precio: json['precio'] != null ? double.tryParse(json['precio'].toString()) ?? 0.0 : 0.0,
    );
  }

  @override
  String toString() {
    return 'Talla{cod_talla: $cod_talla, descripcion: $descripcion, precio: $precio}';
  }
}
