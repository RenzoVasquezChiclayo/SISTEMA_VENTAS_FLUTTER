class Venta {
  final int cod_venta;
  final int cod_polo;
  final int cod_estampado;
  final int precio_venta;
  final int cod_usuario;
  final DateTime fecha_venta;
  final String tipo_producto;
  final int cantidad;
  final int estado;

  Venta({
    required this.cod_venta,
    required this.cod_polo,
    required this.cod_estampado,
    required this.precio_venta,
    required this.cod_usuario,
    required this.fecha_venta,
    required this.tipo_producto,
    required this.cantidad,
    required this.estado,
  });

  Venta copyWith({
    int? cod_venta,
    int? cod_polo,
    int? cod_estampado,
    int? precio_venta,
    int? cod_usuario,
    DateTime? fecha_venta,
    String? tipo_producto,
    int? cantidad,
    int? estado,
  }) {
    return Venta(
      cod_venta: cod_venta ?? this.cod_venta,
      cod_polo: cod_polo ?? this.cod_polo,
      cod_estampado: cod_estampado ?? this.cod_estampado,
      precio_venta: precio_venta ?? this.precio_venta,
      cod_usuario: cod_usuario ?? this.cod_usuario,
      fecha_venta: fecha_venta ?? this.fecha_venta,
      tipo_producto: tipo_producto ?? this.tipo_producto,
      cantidad: cantidad ?? this.cantidad,
      estado: estado ?? this.estado,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cod_venta': cod_venta,
      'cod_polo': cod_polo,
      'cod_estampado': cod_estampado,
      'precio_venta':precio_venta,
      'cod_usuario': cod_usuario,
      'fecha_venta': fecha_venta.toIso8601String(),
      'tipo_producto': tipo_producto,
      'cantidad': cantidad,
      'estado': estado,
    };
  }

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      cod_venta: int.parse(json['cod_venta'].toString()),
      cod_polo: int.parse(json['cod_estampado'].toString()),
      cod_estampado: int.parse(json['cod_estampado'].toString()),
      precio_venta: int.parse(json['precio_venta'].toString()),
      cod_usuario: int.parse(json['cod_usuario'].toString()),
      fecha_venta: DateTime.parse(json['fecha_venta']),
      tipo_producto: json['cod_estampado'],
      cantidad: int.parse(json['cantidad'].toString()),
      estado: int.parse(json['estado'].toString()),
    );
  }

  @override
  String toString() {
    return 'Estampado{cod_venta: $cod_venta, cod_estampado: $cod_estampado, cod_polo: $cod_polo, precio_venta: $precio_venta,'
        'cod_usuario: $cod_usuario,fecha_venta: $fecha_venta,tipo_producto: $tipo_producto,cantidad: $cantidad,estado: $estado}';
  }
}
