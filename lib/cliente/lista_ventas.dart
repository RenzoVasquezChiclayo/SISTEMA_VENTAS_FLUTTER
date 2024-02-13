import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyappmovil/admin/Venta.dart';
import 'package:http/http.dart' as http;

class ListaVentasView extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const ListaVentasView({Key? key, this.usuario = const {}}) : super(key: key);

  @override
  _ListaVentasViewState createState() => _ListaVentasViewState();
}

class _ListaVentasViewState extends State<ListaVentasView> {
  int currentIndex = 0;
  late PageController _controller;
  List<Map<String, dynamic>> ventas = [];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> lista_ventas(int cod_usuario) async {
    print("Aqui");
    final url =
        'http://10.0.2.2/flutter_api/obtener_ventas_cliente.php/?cod_usuario=${cod_usuario}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      ventas.clear();
      data.forEach((venta) {
        ventas.add(Map<String, dynamic>.from(venta));
      });
      return ventas;
    } else {
      throw Exception('Error en obtener las ventas');
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.usuario);
    return Scaffold(
      body: Column(
        children: [
          Text("Lista de Ventas"),
          Expanded(
            child: FutureBuilder(
              future: lista_ventas(
                  int.tryParse(widget.usuario['id'] ?? '') ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  ventas = snapshot.data as List<Map<String, dynamic>>;
                  return ListView.builder(
                    itemCount: ventas.length,
                    itemBuilder: (context, index) {
                      final venta = ventas[index];
                      return ListTile(
                        title: Text(
                            "Tipo de Producto: ${venta['tipo_producto']}"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cantidad: ${venta['cantidad']}"),
                            Text("Precio de Venta: ${venta['precio_venta']}"),
                            Text("Fecha: ${venta['fecha_venta']}"),
                            Container( // Envuelve el condicional en un Container
                              child: venta['estado'] == 0
                                  ? Text("Estado: Confirmado")
                                  : venta['estado'] == 1
                                  ? Text("Estado: Preparando")
                                  : Text("Estado: Enviado"),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

  void main() {
  runApp(
    MaterialApp(
      home: ListaVentasView(),
    ),
  );
}
