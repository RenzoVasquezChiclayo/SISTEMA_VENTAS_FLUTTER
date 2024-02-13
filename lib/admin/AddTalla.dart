import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/TipoPolo.dart';
import 'package:proyappmovil/admin/TipoTalla.dart';

class AddTallaScreen extends StatefulWidget {
  const AddTallaScreen({Key? key}) : super(key: key);

  @override
  _AddTallaScreenState createState() => _AddTallaScreenState();
}

class _AddTallaScreenState extends State<AddTallaScreen> {
  TextEditingController nombre = TextEditingController();
  TextEditingController precio = TextEditingController();

  Future<void> insert_Talla() async {
    try {
      String uri = "http://10.0.2.2/flutter_api/insert_talla.php";

      print(nombre.text);
      var res = await http.post(Uri.parse(uri), body: {
        "descripcion": nombre.text,
        "precio": precio.text,
      });

      var response = jsonDecode(res.body);
      if (response["success"] == "true") {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoTallaView()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Talla registrado'),
            duration: Duration(seconds: 2),
          ),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al registrar Talla'),
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
        title: const Text("Agregar nuevo Talla"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: nombre,
              decoration: InputDecoration(labelText: 'Nombre del Talla'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: precio,
              decoration: InputDecoration(labelText: 'Precio'),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                insert_Talla();
              },
              child: const Text("Guardar"),
            ),
          ],
        ),
      ),
    );
  }



}
