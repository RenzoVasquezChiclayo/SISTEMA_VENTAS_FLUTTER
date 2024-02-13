import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/Polo.dart';
import 'package:proyappmovil/admin/TipoPolo.dart';

class EditarPoloView extends StatefulWidget {
  final int poloId;

  const EditarPoloView({Key? key, required this.poloId})
      : super(key: key);

  @override
  _EditarPoloViewState createState() => _EditarPoloViewState();
}

class _EditarPoloViewState extends State<EditarPoloView> {
  late Future<Polo> _futurePolo;
  String _imagePath = "";

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _futurePolo = fetchPolo(widget.poloId);
    _futurePolo.then((polo) {
      _nombreController.text = polo.descripcion;
      _precioController.text = polo.precio.toString();
    });
  }

  Future<void> actualizarPolo(Polo polo) async {
    final url = 'http://10.0.2.2/flutter_api/save_editar_polo.php/?cod_polo=${polo.cod_polo}';
    print(polo.toJson());
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(polo.toJson()),
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoPoloView()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Polo actualizado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      throw Exception('Error al actualizar el polo');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Polo>(
      future: _futurePolo,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Polo')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Polo')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          Polo polo = snapshot.data!;

          return Scaffold(
            appBar: AppBar(title: Text('Editar Polo')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    //initialValue: estampado.nombre,
                    onChanged: (value) {
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _precioController,
                    //initialValue: estampado.precio.toString(),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String nuevoNombre = _nombreController.text;
                      double nuevoPrecio = double.parse(_precioController.text);
                      Polo poloActualizado = Polo(
                        cod_polo: polo.cod_polo,
                        descripcion: nuevoNombre,
                        precio: nuevoPrecio,
                      );
                      actualizarPolo(poloActualizado);
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

  Future<Polo> fetchPolo(int id) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2/flutter_api/editar_polo.php/?cod_polo=$id'));
    if (response.statusCode == 200) {
      return Polo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el polo');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EditarPoloView(poloId: 1),
  ));
}