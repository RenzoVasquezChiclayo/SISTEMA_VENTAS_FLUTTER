import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/AddTalla.dart';
import 'package:proyappmovil/admin/EditarTalla.dart';
import 'package:proyappmovil/admin/Tallas.dart';


class TipoTallaView extends StatelessWidget {
  const TipoTallaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Tallas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TallaList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTallaScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TallaList extends StatefulWidget {
  @override
  _TallaListState createState() => _TallaListState();
}

class _TallaListState extends State<TallaList> {
  List<Talla> tallas = [];

  @override
  void initState() {
    super.initState();
    fetchTallas();
  }

  Future<void> fetchTallas() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/flutter_api/obtener_talla.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        tallas = responseData.map((data) => Talla.fromJson(data)).toList();
        print(tallas[0].cod_talla);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }


  void _eliminarTalla(Talla talla) async {
    print(talla.cod_talla);
    final response = await http.delete(
        Uri.parse('http://10.0.2.2/flutter_api/eliminar_talla.php/?cod_talla=${talla.cod_talla}')
    );
    if (response.statusCode == 200) {
      setState(() {
        tallas.remove(talla);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('talla eliminado correctamente'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar el talla'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tallas.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(tallas[index].cod_talla.toString()),
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
              _eliminarTalla(tallas[index]);
            } else if (direction == DismissDirection.endToStart) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditarTallaView(tallaId: tallas[index].cod_talla)));
            }
          },
          child: ListTile(
            title: Text(tallas[index].descripcion),
            subtitle: Text('S/. '+tallas[index].precio.toString()),
          ),
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: TipoTallaView(),
  ));
}
