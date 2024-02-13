import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proyappmovil/admin/Venta.dart';
import 'package:http/http.dart' as http;

class ListaVentasView extends StatefulWidget {
  const ListaVentasView({Key? key}) : super(key: key);

  @override
  _ListaVentasViewState createState() => _ListaVentasViewState();
}

class _ListaVentasViewState extends State<ListaVentasView> {
  int currentIndex = 0;
  late PageController _controller;
  List<Venta> ventas = [];

  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
    lista_ventas();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> lista_ventas() async {
    print("Aqui");
    final url =
        'http://10.0.2.2/flutter_api/obtener_ventas.php';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        ventas = responseData.map((data) => Venta.fromJson(data)).toList();
        print(ventas);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Ventas'),
      ),
      body: ventas != null
          ? ListView.builder(
        itemCount: ventas.length,
        itemBuilder: (context, index) {
          final venta = ventas[index];
          return ListTile(
            title: Text("Tipo de Producto: ${venta.tipo_producto}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cantidad: ${venta.cantidad}"),
                Text("Precio de Venta: ${venta.precio_venta}"),
                Text("Fecha: ${venta.fecha_venta}"),
                Text(venta.estado == 0
                    ? "Estado: Confirmado"
                    : venta.estado == 1
                    ? "Estado: Preparando"
                    : "Estado: Enviado"),
              ],
            ),
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
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
