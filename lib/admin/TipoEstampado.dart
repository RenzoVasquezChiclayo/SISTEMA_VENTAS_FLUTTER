import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/AddEstampado.dart';
import 'package:proyappmovil/admin/EditarEstampado.dart';
import 'package:proyappmovil/admin/Estampado.dart';

class TipoEstampadoView extends StatelessWidget {
  const TipoEstampadoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de estampados"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: EstampadoList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEstampadoScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EstampadoList extends StatefulWidget {
  @override
  _EstampadoListState createState() => _EstampadoListState();
}

class _EstampadoListState extends State<EstampadoList> {
  List<Estampado> estampados = [];

  @override
  void initState() {
    super.initState();
    fetchEstampados();
  }

  Future<void> fetchEstampados() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/flutter_api/obtener_estampado.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        estampados = responseData.map((data) => Estampado.fromJson(data)).toList();
        print(estampados[0].cod_estampado);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }


  void _eliminarEstampado(Estampado estampado) async {
    print(estampado.cod_estampado);
    final response = await http.delete(
      Uri.parse('http://10.0.2.2/flutter_api/eliminar_estampado.php/?cod_estampado=${estampado.cod_estampado}')
    );
    if (response.statusCode == 200) {
      setState(() {
        estampados.remove(estampado);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Estampado eliminado correctamente'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar el estampado'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: estampados.length,
      itemBuilder: (context, index) {
        String imagePath = "/storage/emulated/0/Android/data/com.proyappmovil.proyappmovil/files/${estampados[index].imagen}";
        return Dismissible(
          key: Key(estampados[index].cod_estampado.toString()),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
          secondaryBackground: Container(
            color: Colors.yellow,
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.edit, color: Colors.white),
            ),
          ),
          //confirmDismiss: (direction) async {
          //  if (direction == DismissDirection.startToEnd) {
          //    // Implementa aquí la lógica para confirmar la eliminación
          //    return true;
          //  } else {
          //    return false;
          //  }
          //},
          onDismissed: (direction) {
            if (direction == DismissDirection.startToEnd) {
              _eliminarEstampado(estampados[index]);
            } else if (direction == DismissDirection.endToStart) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditarEstampadoView(estampadoId: estampados[index].cod_estampado)));
            }
          },
          child: ListTile(
            title: Text(estampados[index].nombre),
            subtitle: Text('S/. '+estampados[index].precio.toString()),
            trailing: Image.file(
              File(imagePath),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: TipoEstampadoView(),
  ));
}
