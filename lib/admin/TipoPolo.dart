import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/AddPolo.dart';
import 'package:proyappmovil/admin/EditarPolo.dart';
import 'package:proyappmovil/admin/Polo.dart';


class TipoPoloView extends StatelessWidget {
  const TipoPoloView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de polos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PoloList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> AddPoloScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class PoloList extends StatefulWidget {
  @override
  _PoloListState createState() => _PoloListState();
}

class _PoloListState extends State<PoloList> {
  List<Polo> polos = [];

  @override
  void initState() {
    super.initState();
    fetchPolos();
  }

  Future<void> fetchPolos() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/flutter_api/obtener_polo.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        polos = responseData.map((data) => Polo.fromJson(data)).toList();
        print(polos[0].cod_polo);
      });
    } else {
      throw Exception('Error al cargar los datos');
    }
  }


  void _eliminarPolo(Polo polo) async {
    print(polo.cod_polo);
    final response = await http.delete(
        Uri.parse('http://10.0.2.2/flutter_api/eliminar_polo.php/?cod_polo=${polo.cod_polo}')
    );
    if (response.statusCode == 200) {
      setState(() {
        polos.remove(polo);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Polo eliminado correctamente'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al eliminar el polo'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: polos.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: Key(polos[index].cod_polo.toString()),
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
              _eliminarPolo(polos[index]);
            } else if (direction == DismissDirection.endToStart) {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> EditarPoloView(poloId: polos[index].cod_polo)));
            }
          },
          child: ListTile(
            title: Text(polos[index].descripcion),
            subtitle: Text('S/. '+polos[index].precio.toString()),
          ),
        );
      },
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: TipoPoloView(),
  ));
}
