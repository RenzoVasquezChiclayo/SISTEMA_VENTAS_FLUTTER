import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:proyappmovil/admin/Estampado.dart';
import 'package:http/http.dart' as http;
import 'package:proyappmovil/admin/Polo.dart';
import 'package:proyappmovil/cliente/lista_ventas.dart';


class DetailOrder extends StatelessWidget {
  final TextEditingController cantidadController;
  final TextEditingController detalles_extras;
  final String categoria;
  final Estampado estampado;
  final File archivo_file;
  final int total;
  final Polo polo;
  final Map<String, dynamic> usuario;


  DetailOrder({
    Key? key,
    required this.cantidadController,
    required this.detalles_extras,
    required this.categoria,
    required this.estampado,
    required this.archivo_file,
    required this.total,
    required this.polo,
    required this.usuario,
  }) : super(key: key);

  Map<String, dynamic>? paymentIntent;

  void makePayment(BuildContext context) async {

    try {
      paymentIntent = await createPaymentIntent();
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.light,
          merchantDisplayName: "Sabir",
        ),
      );

      displayPaymentSheet(context);
    } catch (e) {
      // Manejar errores específicos aquí
      if (e is StripeException) {
        // Manejar excepciones específicas de Stripe
        print("Error de Stripe: ${e.error.localizedMessage}");
      } else {
        // Otros errores
        print("Error al realizar el pago: $e");
      }
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Compra exitosa'),
            content: Text('Su compra ha sido procesada con éxito.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  insert_venta(context);

                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("FAILED");
    }
  }


  createPaymentIntent() async {
    try {
      //String totalAmount = total.toString();
      Map<String, dynamic> body = {
        "amount": total.toString(),
        "currency": "PEN",
      };
      http.Response response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization":
          "Bearer sk_test_51OdJ4mF6DrYzDGRKOYaBLNKxaTHxEJSlY5CnX47fZGR35346otKWGAjQzQGCRmTx2Qfj0NgoVgqzD3RGEYjialm200nApXYEzb",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> insert_venta(BuildContext context) async {
    print("AQUI");
    try {
        String uri = "http://10.0.2.2/flutter_api/insert_venta.php";

        var res = await http.post(Uri.parse(uri), body: {
          "cod_polo": polo.cod_polo.toString(),
          "cod_estampado": estampado.cod_estampado.toString(),
          "precio_venta": total.toString(),
          "cod_usuario": usuario["id"].toString(),
          "fecha_venta": DateTime.now().toString(),
          "tipo_producto": categoria.toString(),
          "cantidad": cantidadController.text,
        });
        var response = jsonDecode(res.body);
        if (response["success"] == true) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ListaVentasView(usuario: usuario)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al registrar Venta'),
              duration: Duration(seconds: 4),
            ),
          );
        }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(estampado);
    print(polo);
    print(usuario);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Pedido"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  '$categoria',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // Espacio entre filas
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100, // Altura de la primera columna
                    child: Center(
                      child: Image.file(archivo_file),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200, // Altura de la segunda columna
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Material del polo:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              polo.descripcion,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Tipo de estampado:',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              estampado.nombre,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              'Cantidad: ' + cantidadController.text,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'Total: S/. ' + (total/100).toString(),
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Detalles extras:',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    detalles_extras.text,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {makePayment(context);},
              child: Text('Realizar Pago'),
            ),
          ],
        ),
      ),
    );
  }
}
