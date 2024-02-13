import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:proyappmovil/admin/TipoEstampado.dart';

class AddEstampadoScreen extends StatefulWidget {
  const AddEstampadoScreen({Key? key}) : super(key: key);

  @override
  _AddEstampadoScreenState createState() => _AddEstampadoScreenState();
}

class _AddEstampadoScreenState extends State<AddEstampadoScreen> {
  File? archivo_file;
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();

  Future<void> insert_estampado() async {
    try {
      String uri = "http://10.0.2.2/flutter_api/insert_estampado.php";

      if (archivo_file != null) {
        String nombreArchivo = path.basename(archivo_file!.path);

        var res = await http.post(Uri.parse(uri), body: {
          "nombre": nombre.text,
          "imagen": "$nombreArchivo",
          "precio": precio.text,
        });

        var response = jsonDecode(res.body);
        if (response["success"] == "true") {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoEstampadoView()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Estampado registrado'),
              duration: Duration(seconds: 2),
            ),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al registrar Estampado'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seleccione una imagen primero'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar nuevo estampado"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nombre,
              decoration: InputDecoration(labelText: 'Nombre del estampado'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: precio,
              decoration: InputDecoration(labelText: 'Precio'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 200,
                    child: Center(
                      child: archivo_file != null
                          ? Image.file(archivo_file!)
                          : Text('No hay imagen seleccionada'),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pickFile(context);
              },
              child: const Text("Seleccionar una imagen"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveFile(context);
                insert_estampado();
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if (result != null) {
        PlatformFile platformFile = result.files.first;
        print(platformFile.path);
        File file = File(platformFile.path!);
        setState(() {
          archivo_file = file;
        });
        print('Archivo seleccionado: ${platformFile.name}');
      } else {
        // Usuario canceló la selección
      }
    } catch (e) {
      print('Error al seleccionar archivo: $e');
    }
  }

  Future<void> _saveFile(BuildContext context) async {
    try {
      if (archivo_file != null) {
        final String fileName = archivo_file!.path.split('/').last;

        await _copyFileToExternalStorage(fileName);
      }
    } catch (e) {
      print('Error al guardar archivo: $e');
    }
  }

  Future<void> _copyFileToExternalStorage(String fileName) async {
    try {
      final Directory? directory = await getExternalStorageDirectory();
      if (directory == null) {
        print('Error: No se pudo acceder al almacenamiento externo.');
        return;
      }
      final String storagePath = directory.path;
      final String destinationPath = '$storagePath/$fileName';
      final File newFile = File(destinationPath);

      if (!newFile.existsSync()) {
        newFile.createSync(recursive: true);
      }
      await archivo_file!.copy(newFile.path);
      print('Archivo copiado a: $destinationPath');
    } catch (e) {
      print('Error al copiar archivo a almacenamiento externo: $e');
    }
  }

}
