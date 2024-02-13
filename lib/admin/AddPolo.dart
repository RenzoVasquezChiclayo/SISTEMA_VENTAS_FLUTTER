import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/TipoPolo.dart';

class AddPoloScreen extends StatefulWidget {
  const AddPoloScreen({Key? key}) : super(key: key);

  @override
  _AddPoloScreenState createState() => _AddPoloScreenState();
}

class _AddPoloScreenState extends State<AddPoloScreen> {
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();

  Future<void> insert_Polo() async {
    try {
      String uri = "http://10.0.2.2/flutter_api/insert_polo.php";


        var res = await http.post(Uri.parse(uri), body: {
          "descripcion": nombre.text,
          "precio": precio.text,
        });

        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoPoloView()));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Polo registrado'),
              duration: Duration(seconds: 2),
            ),
          );

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al registrar Polo'),
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
        title: const Text("Agregar nuevo Polo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nombre,
              decoration: InputDecoration(labelText: 'Nombre del Polo'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: precio,
              decoration: InputDecoration(labelText: 'Precio'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                insert_Polo();
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }



}
