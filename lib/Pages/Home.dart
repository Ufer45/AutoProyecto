import 'dart:convert';
import 'package:autolavado/Models/ServiciosResponse.dart';
import 'package:autolavado/Pages/Servicio.dart';
import 'package:flutter/material.dart';
import 'package:autolavado/Utils/Ambiente.dart';

import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ServiciosResponse> servicios = [];

  Widget _ListViewServicios() {
    return ListView.builder(
      itemCount: servicios.length,
      itemBuilder: (context, index) {
        var servicio = servicios[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Servicio(
                  idServicio: servicio.id,
                ),
              ),
            );
          },
          title: Text(servicio.codigo),
          subtitle: Text(servicio.descripcion),
        );
      },
    );
  }

  void fnObtenerServicio() async {
    try {
      var response = await http.get(
        Uri.parse('${Ambiente.uriServer}/api/servicios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Iterable mapServicios = jsonDecode(response.body);
        setState(() {
          servicios = List<ServiciosResponse>.from(
              mapServicios.map((model) => ServiciosResponse.fromJson(model))
          );
        });
      } else {
        print('no se puede :(');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fnObtenerServicio();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Servicios"),
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (String value) {
            fnObtenerServicio();
          }, itemBuilder: (BuildContext context) {
            return {'Actualizar lista'}.map((String item) {
              return PopupMenuItem<String>(value: item, child: Text(item));
            }).toList();
          }),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _ListViewServicios()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Servicio(idServicio: 0),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}