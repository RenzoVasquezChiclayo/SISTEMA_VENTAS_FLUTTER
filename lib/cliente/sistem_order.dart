import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/Estampado.dart';
import 'package:proyappmovil/admin/Polo.dart';
import 'package:proyappmovil/cliente/sistema_detail_order.dart';

class OrdenarPedido extends StatefulWidget  {
  final String categoria;
  final Map<String, dynamic> usuario;
  OrdenarPedido({required this.categoria, required this.usuario});

  @override
  _OrdenarPedidoState createState() => _OrdenarPedidoState();
}
class _OrdenarPedidoState extends State<OrdenarPedido> {
  List<Estampado> estampados = [];
  double? precioSeleccionado;
  int selectedIndex = -1;
  int cantidad = 0;
  String? nombreArchivoSeleccionado;
  Estampado EstampadoObj = Estampado(cod_estampado: 0,nombre: "",imagen: "",precio: 0.0);
  late File archivo_file;
  String imagePathEstampado = "/storage/emulated/0/Android/data/com.proyappmovil.proyappmovil/files/";
  double? precioPoloSeleccionado;
  late TextEditingController _cantidadController = TextEditingController();
  late TextEditingController _detalles_extras = TextEditingController();
  Polo? poloSeleccionado;
  List<Polo> polos = [];
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchTipoPolo();
  }
  @override
  void dispose() {
    _cantidadController.dispose();
    _detalles_extras.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/flutter_api/obtener_estampado.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        estampados = responseData.map((data) => Estampado.fromJson(data)).toList();
        print(estampados);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<void> fetchTipoPolo() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/flutter_api/obtener_polo.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        polos = responseData.map((data) => Polo.fromJson(data)).toList();
        print(polos);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Orden de ${widget.categoria}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.categoria == 'Polos')
                _buildServiceButton('Polos', 'assets/images/sistema/polo.png',context),
              if (widget.categoria == 'Poleras')
                _buildServiceButton('Poleras', 'assets/images/sistema/polera.png',context),
              if (widget.categoria == 'Tazas')
                _buildServiceButton('Tazas', 'assets/images/sistema/tazas.png',context),
              if (widget.categoria == 'Llaveros y pines')
                _buildServiceButton('Llaveros y pines', 'assets/images/sistema/llaveros.png',context),
            ],
          ),
      ),
    );
  }

  Widget _buildServiceButton(String text, String imagePath,BuildContext context,) {
    double precioTotal;
    if (widget.categoria == 'Polos') {
      double precioPolo = precioPoloSeleccionado ?? 0.0;
      int cantidadPolo = int.tryParse(_cantidadController.text) ?? 0;
      double precioTotalPolo = precioPolo * cantidadPolo;
      double precioEstampado = selectedIndex != -1 ? estampados[selectedIndex].precio * cantidad : 0.0;
      precioTotal = precioTotalPolo + precioEstampado;
    } else {
      precioTotal = selectedIndex != -1 ? estampados[selectedIndex].precio * cantidad : 0.0;
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Lógica que se ejecutará al presionar el botón
                  print('$text presionado');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(12),
                  backgroundColor: Color.fromRGBO(235, 242, 252, 1.0),
                  side: BorderSide(
                    color: Color.fromRGBO(191, 213, 246, 1.0),
                    width: 3.0,
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      imagePath,
                      height: 80,
                      width: 80,
                    ),
                    SizedBox(height: 8),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 18, // Tamaño del texto
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(100, 101, 103, 1.0),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Cantidad:'),
                        SizedBox(width: 15),
                        Expanded(
                          child: TextFormField(
                            controller: _cantidadController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Cantidad',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (widget.categoria == 'Polos')
                        Text('Material del polo'),
                      DropdownButtonFormField<Polo>(
                        value: poloSeleccionado, // Usar el polo seleccionado aquí
                        items: polos.map((Polo polo) {
                          return DropdownMenuItem<Polo>(
                            value: polo,
                            child: Text(polo.descripcion),
                          );
                        }).toList(),
                        onChanged: (Polo? newValue) {
                          setState(() {
                            poloSeleccionado = newValue;
                            precioPoloSeleccionado = poloSeleccionado?.precio;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      if (precioPoloSeleccionado != null)
                        Text(
                          'Precio: ${precioPoloSeleccionado != null ? 'S/. ${precioPoloSeleccionado!.toStringAsFixed(2)}' : 'Selecciona un polo'}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    SizedBox(height: 10),
                    Text('Diseño o referencia:'),
                    ElevatedButton(
                      onPressed: () {
                        _pickFile(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: Text('Seleccionar archivo'),
                    ),
                    SizedBox(height: 2),
                    if (nombreArchivoSeleccionado != null)
                      Text(
                        '$nombreArchivoSeleccionado',
                        style: TextStyle(
                          fontSize: 8, // Tamaño del texto
                        ),
                      ),

                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          Text('Detalles extras (Opcional)'),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: _detalles_extras,
              maxLines: 2, // Define un número ilimitado de líneas
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 10),
              Text('Contáctenos:'),
              SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  // Lógica para realizar una llamada
                },
                child: Text(
                  '951056308',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tipos de estampados',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              if (selectedIndex != -1)
              Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(235, 242, 252, 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(8),
                child: Text(
                  "x S/. $precioSeleccionado",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
          ]

          ),
          SizedBox(height: 2),
          CarouselSlider(
            options: CarouselOptions(
              aspectRatio: 3 / 2,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              viewportFraction: 0.4,
              height: MediaQuery.of(context).size.height * 0.2,
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
            items: estampados.asMap().entries.map((entry) {
              final index = entry.key;
              final estampado = entry.value;
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        precioSeleccionado = estampado.precio;
                        cantidad = int.tryParse(_cantidadController.text) ?? 0;
                        EstampadoObj = estampado;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        border: Border.all(
                          color: index == selectedIndex ? Colors.blue : Colors.transparent, // Color del borde del elemento seleccionado
                          width: 5.0, // Ancho del borde
                        ),
                        image: DecorationImage(
                          image: FileImage(File('$imagePathEstampado${estampado.imagen}')),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: Text(
                              estampado.nombre,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )

                  );
                },
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          if (precioSeleccionado != null && cantidad > 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: S/. ${precioTotal.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailOrder(
                          cantidadController: _cantidadController,
                          detalles_extras: _detalles_extras,
                          categoria: widget.categoria,
                          estampado: EstampadoObj,
                          archivo_file: archivo_file,
                          total: precioTotal.toInt()*100,
                          polo: poloSeleccionado!,
                          usuario: widget.usuario,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(235, 242, 252, 1.0), // Cambia el color de fondo del botón a negro
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    shape: RoundedRectangleBorder( // Define la forma del botón con bordes redondeados
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    side: BorderSide( // Agrega un borde alrededor del botón
                      color: Color.fromRGBO(191, 213, 246, 1.0), // Color del borde
                      width: 5.0, // Ancho del borde
                    ),
                  ),
                  child: const Text(
                      'Realizar pedido',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                    ),
                  ),
                ),
              ],
            )
        ]

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
        File file = File(platformFile.path!); // Convertir PlatformFile a File
        setState(() {
          nombreArchivoSeleccionado = platformFile.name;
          archivo_file = file;
        });
        print('Archivo seleccionado: ${platformFile.name}');
        // Aquí puedes manejar el archivo seleccionado
      } else {
        // Usuario canceló la selección
      }
    } catch (e) {
      print('Error al seleccionar archivo: $e');
    }
  }
}