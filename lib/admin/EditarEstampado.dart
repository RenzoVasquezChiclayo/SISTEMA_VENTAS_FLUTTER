import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/Estampado.dart';
import 'package:proyappmovil/admin/TipoEstampado.dart';

class EditarEstampadoView extends StatefulWidget {
  final int estampadoId;

  const EditarEstampadoView({Key? key, required this.estampadoId})
      : super(key: key);

  @override
  _EditarEstampadoViewState createState() => _EditarEstampadoViewState();
}

class _EditarEstampadoViewState extends State<EditarEstampadoView> {
  late Future<Estampado> _futureEstampado;
  String _imagePath = "";

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _imagenController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _futureEstampado = fetchEstampado(widget.estampadoId);
    _futureEstampado.then((estampado) {
      _nombreController.text = estampado.nombre;
      _precioController.text = estampado.precio.toString();
      _imagenController.text = estampado.imagen;
    });
  }

  Future<void> actualizarEstampado(Estampado estampado) async {
    final url = 'http://10.0.2.2/flutter_api/save_editar_estampado.php/?cod_estampado=${estampado.cod_estampado}';
    print(estampado.toJson());
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(estampado.toJson()),
    );
    if (response.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoEstampadoView()));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Estampado actualizado correctamente'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      throw Exception('Error al actualizar el estampado');
    }
  }


  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _imagePath = result.files.single.path!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Estampado>(
      future: _futureEstampado,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Estampado')),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text('Editar Estampado')),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          Estampado estampado = snapshot.data!;
          if (_imagePath.isEmpty) {
            _imagePath = "/storage/emulated/0/Android/data/com.example.login_signup/files/${estampado.imagen}";
          }

          return Scaffold(
            appBar: AppBar(title: Text('Editar Estampado')),
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
                  Container(
                    height: 200,
                    child: _imagePath.isNotEmpty
                        ? Image.file(File(_imagePath), fit: BoxFit.cover)
                        : Placeholder(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickFile,
                    child: const Text("Seleccionar una imagen"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      String nuevoNombre = _nombreController.text;
                      double nuevoPrecio = double.parse(_precioController.text);
                      String nuevaImagen = _imagenController.text;
                      Estampado estampadoActualizado = Estampado(
                        cod_estampado: estampado.cod_estampado,
                        nombre: nuevoNombre,
                        imagen: nuevaImagen,
                        precio: nuevoPrecio,
                      );
                      actualizarEstampado(estampadoActualizado);
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

  Future<Estampado> fetchEstampado(int id) async {
    final response = await http.get(
        Uri.parse('http://10.0.2.2/flutter_api/editar_estampado.php/?cod_estampado=$id'));
    if (response.statusCode == 200) {
      return Estampado.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al cargar el estampado');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EditarEstampadoView(estampadoId: 1),
  ));
}