import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/Tallas.dart';
import 'package:proyappmovil/admin/TipoTalla.dart';

class EditarTallaView extends StatefulWidget {
  final int tallaId;

  const EditarTallaView({Key? key, required this.tallaId})
      : super(key: key);

  @override
  _EditarTallaViewState createState() => _EditarTallaViewState();
}

class _EditarTallaViewState extends State<EditarTallaView> {
  late Future<Talla> _futureTalla;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _futureTalla = fetchTalla(widget.tallaId);
    _futureTalla.then((talla) {
      _nombreController.text = talla.descripcion;
      _precioController.text = talla.precio.toString();
    });
  }

  Future<void> actualizarTalla(Talla talla) async {
    final url = 'http://10.0.2.2/flutter_api/save_editar_talla.php/?cod_talla=${talla.cod_talla}';
    print(talla.toJson());
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(talla.toJson()),
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoTallaView()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Talla actualizado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      throw Exception('Error al actualizar el Talla');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Talla>(
      future: _futureTalla,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Talla')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Talla')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          Talla talla = snapshot.data!;

          return Scaffold(
            appBar: AppBar(title: Text('Editar Talla')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    onChanged: (value) {
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _precioController,
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String nuevoNombre = _nombreController.text;
                      double nuevoPrecio = double.parse(_precioController.text);
                      Talla tallaActualizado = Talla(
                        cod_talla: talla.cod_talla,
                        descripcion: nuevoNombre,
                        precio: nuevoPrecio,
                      );
                      actualizarTalla(tallaActualizado);
                    },
                    child: Text('Guardar Cambios'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Talla> fetchTalla(int id) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2/flutter_api/editar_talla.php/?cod_talla=$id'));
    if (response.statusCode == 200) {
      return Talla.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el talla');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EditarTallaView(tallaId: 1),
  ));
}