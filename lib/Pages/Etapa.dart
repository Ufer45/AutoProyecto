import 'dart:convert';
import 'package:autolavado/Models/EtapaResponse.dart';
import 'package:quickalert/quickalert.dart';
import 'package:autolavado/Utils/Ambiente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Etapa extends StatefulWidget {
  final int idServicio;
  final int idEtapa;
  const Etapa({Key? key, required this.idServicio, required this.idEtapa})
      : super(key: key);

  @override
  State<Etapa> createState() => _EtapaState();
}

class _EtapaState extends State<Etapa> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtDuracion = TextEditingController();
  List<EtapaResponse> etapas = [];

  /*Widget _ListViewEtapas() {
    return ListView.builder(
      itemCount: etapas.length,
      itemBuilder: (context, index) {
        var etapa = etapas[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Etapa(
                  idServicio: widget.idServicio,
                  idEtapa: widget.idEtapa,
                ),
              ),
            );
          },
          title: Text(etapa.nombre),
        );
      },
    );
  }

  void fnObtenerEtapa() async {
    try {
      var response = await http.get(
        Uri.parse('${Ambiente.uriServer}/api/etapas'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Iterable mapServicios = jsonDecode(response.body);
        setState(() {
          etapas = List<EtapaResponse>.from(
              mapServicios.map((model) => EtapaResponse.fromJson(model))
          );
        });
      } else {
        print('Error al obtener las etapas: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }*/

  @override
  void initState() {
    super.initState();
    //fnObtenerEtapa();
    if (widget.idEtapa != 0) {
      fnDatosEtapa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Etapas"),
        actions: <Widget>[
          PopupMenuButton<String>(onSelected: (String value) {
            //fnObtenerEtapa();
          }, itemBuilder: (BuildContext context) {
            return {'Actualizar lista'}.map((String item) {
              return PopupMenuItem<String>(value: item, child: Text(item));
            }).toList();
          }),
        ],
      ),
      body: Column(
        children: [
          //Expanded(child: _ListViewEtapas()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Etapa(idEtapa: 0, idServicio: widget.idServicio),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void fnDatosEtapa() async {
    try {
      final response = await http.post(
        Uri.parse('${Ambiente.uriServer}/api/etapas'),
        body: jsonEncode(<String, dynamic>{
          'id': widget.idEtapa,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        final etapaResponse = EtapaResponse.fromJson(responseJson);
        setState(() {
          txtNombre.text = etapaResponse.nombre;
          txtDuracion.text = etapaResponse.duracion.toString();
        });
      } else {
        print('Error al obtener los datos de la etapa: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
