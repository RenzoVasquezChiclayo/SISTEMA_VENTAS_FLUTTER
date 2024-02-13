import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/cliente/sistem_order.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> usuario;
  const Home({Key? key, required this.usuario}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _data = [];
  String imagePathEstampado = "/storage/emulated/0/Android/data/com.proyappmovil.proyappmovil/files/";
  @override
  void initState() {
    super.initState();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try{
      String uri="http://10.0.2.2/flutter_api/obtener_estampado.php";
      var res = await http.get(Uri.parse(uri));
      var response = jsonDecode(res.body);
      if (response is List) { // Verifica si la respuesta es una lista
        _data = response.map((item) => item as Map<String, dynamic>).toList();
        print(_data);
      } else {
        throw Exception('Failed to load data from API');
      }
    }catch(e){
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            Text(
              'Elige un servicio',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(height: 2),
            _buildServiceButtonRow(
              'Polos',
              'assets/images/sistema/polo.png',
              'Poleras',
              'assets/images/sistema/polera.png',
            ),
            SizedBox(height: 2), // Ajusta la separación vertical entre filas
            _buildServiceButtonRow(
              'Tazas',
              'assets/images/sistema/tazas.png',
              'Llaveros y pines',
              'assets/images/sistema/llaveros.png',
            ),
            SizedBox(height: 2),
            Text(
              'Tipos de estampados',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                viewportFraction: 0.6,
                height: MediaQuery.of(context).size.height * 0.3,
                clipBehavior: Clip.antiAliasWithSaveLayer,
              ),
              items: _data.map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: FileImage(File('$imagePathEstampado${item['imagen']}')),
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
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                              color: Colors.black.withOpacity(0.5), // Color de fondo del texto con opacidad
                            ),
                            child: Text(
                              item['nombre'] ?? 'Descripción no disponible',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButtonRow(
      String text1,
      String imagePath1,
      String text2,
      String imagePath2,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildServiceButton(text1, imagePath1),
        SizedBox(width: 7), // Ajusta la separación horizontal entre botones
        _buildServiceButton(text2, imagePath2),
      ],
    );
  }

  Widget _buildServiceButton(String text, String imagePath) {
    print(widget.usuario);
    return Container(
      width: 150, // Ancho fijo para el contenedor del botón
      margin: EdgeInsets.symmetric(vertical: 5), // Ajusta el margen vertical
      child: ElevatedButton(
        onPressed: () {
          // Lógica que se ejecutará al presionar el botón
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrdenarPedido(categoria: text, usuario: widget.usuario),
            ),
          );
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
    );
  }

  Widget _buildImageSlider() {
    return Slider(
      value: 0,
      min: 0,
      max: 10,
      onChanged: (value) {
        // Lógica que se ejecutará al cambiar el valor del slider

        print('Slider cambió a: $value');
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Home(usuario: {}),
    ),
  );
}
