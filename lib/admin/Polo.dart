class Polo {
  final int cod_polo;
  final String descripcion;
  final double precio;

  Polo({
    required this.cod_polo,
    required this.descripcion,
    required this.precio,
  });

  Polo copyWith({
    int? cod_polo,
    String? descripcion,
    double? precio,
  }) {
    return Polo(
      cod_polo: cod_polo ?? this.cod_polo,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_polo': cod_polo,
      'descripcion': descripcion,
      'precio': precio,
    };
  }

  factory Polo.fromJson(Map<String, dynamic> json) {
    return Polo(
      cod_polo: int.parse(json['cod_polo'].toString()),
      descripcion: json['descripcion'],
      precio: json['precio'] != null ? double.tryParse(json['precio'].toString()) ?? 0.0 : 0.0,
    );
  }

  @override
  String toString() {
    return 'Polo{cod_polo: $cod_polo, descripcion: $descripcion, precio: $precio}';
  }
}
