import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:proyappmovil/admin/TipoEstampado.dart';
import 'package:proyappmovil/admin/TipoPolo.dart';
import 'package:proyappmovil/admin/TipoTalla.dart';
import 'package:proyappmovil/admin/lista_ventas.dart';

class HomeAdmin extends StatelessWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoTallaView()));
                }, child: const Text("Tallas")),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoPoloView()));
                }, child: const Text("Polos")),
            SizedBox(height: 20,),
            ElevatedButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> TipoEstampadoView()));
            }, child: const Text("Estampados")),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaVentasView()));
            }, child: const Text("Ventas")),
          ],
        ),
      ),
    );
  }
}
