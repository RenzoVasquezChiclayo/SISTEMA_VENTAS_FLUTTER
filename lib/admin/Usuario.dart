class Usuario {
  final int id;
  final String nombres;
  final String correo;
  final String contrasena;
  final String rol;

  Usuario({
    required this.id,
    required this.nombres,
    required this.correo,
    required this.contrasena,
    required this.rol,
  });

  Usuario copyWith({
    int? id,
    String? nombres,
    String? correo,
    String? contrasena,
    String? rol,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombres: nombres ?? this.nombres,
      correo: correo ?? this.correo,
      contrasena: contrasena ?? this.contrasena,
      rol: rol ?? this.rol,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombres': nombres,
      'correo': correo,
      'contrasena': contrasena,
      'rol': rol,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: int.parse(json['id'].toString()),
      nombres: json['nombres'],
      correo: json['correo'],
      contrasena: json['contrasena'],
      rol: json['rol'],
    );
  }

  @override
  String toString() {
    return 'Usuario{id: $id, nombres: $nombres, correo: $correo, contrasena: $contrasena, rol: $rol}';
  }
}
