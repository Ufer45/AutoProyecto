import 'dart:convert';
import 'package:autolavado/Models/ServiciosResponse.dart';
import 'package:autolavado/Models/EtapaResponse.dart';
import 'package:autolavado/Pages/Etapa.dart';
import 'package:quickalert/quickalert.dart';
import 'package:autolavado/Utils/Ambiente.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Servicio extends StatefulWidget {
  final int idServicio;
  const Servicio({super.key, required this.idServicio});

  @override
  State<Servicio> createState() => _ServicioState();
}

class _ServicioState extends State<Servicio> {
  final _formKey = GlobalKey<FormState>();
  List<EtapaResponse> etapas = [];

  TextEditingController txtCodigo = TextEditingController();
  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtDescri = TextEditingController();
  TextEditingController txtPrecio = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.idServicio != 0) {
      fnDatosServicio();
      fnObtenerEtapas();
    }
  }

  void fnDatosServicio() async {
    final response = await http.post(
      Uri.parse('${Ambiente.uriServer}/api/servicio'),
      body: jsonEncode(<String, dynamic>{'id': widget.idServicio}),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
    );
    Map<String, dynamic> responseJson = jsonDecode(response.body);
    final serviciosResponse = ServiciosResponse.fromJson(responseJson);
    txtCodigo.text = serviciosResponse.codigo;
    txtNombre.text = serviciosResponse.nombre;
    txtDescri.text = serviciosResponse.descripcion;
    txtPrecio.text = serviciosResponse.precio.toString();
  }

  void fnObtenerEtapas() async {
    try {
      var response = await http.get(
        Uri.parse('${Ambiente.uriServer}/api/etapas'),
        headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        Iterable mapEtapas = jsonDecode(response.body);
        print("Respuesta de etapas: $mapEtapas"); // Log para depuración
        setState(() {
          etapas = List<EtapaResponse>.from(
              mapEtapas.map((model) => EtapaResponse.fromJson(model))
                  .where((etapa) => etapa.idServicio == widget.idServicio)
          );
        });
      } else {
        print('No se pueden obtener las etapas, código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener etapas: $e');
    }
  }

  Widget _ListViewEtapas() {
    return ListView.builder(
      itemCount: etapas.length,
      itemBuilder: (context, index) {
        var etapa = etapas[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Servicio(
                  idServicio: widget.idServicio,
                ),
              ),
            );
          },
          title: Text(etapa.nombre),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Servicios'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Código'),
              controller: txtCodigo,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Llena el campo';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre'),
              controller: txtNombre,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Llena el campo';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción'),
              controller: txtDescri,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Llena el campo';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Precio'),
              controller: txtPrecio,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Llena el campo';
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final response = await http.post(
                    Uri.parse('${Ambiente.uriServer}/api/servicio/guardar'),
                    body: jsonEncode(<String, dynamic>{
                      'id': widget.idServicio,
                      'codigo': txtCodigo.text,
                      'nombre': txtNombre.text,
                      'descripcion': txtDescri.text,
                      'precio': txtPrecio.text,
                    }),
                    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
                  );
                  print(response.body);
                  if (response.body == 'OK') {
                    Navigator.pop(context);
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: response.body,
                    );
                  }
                }
              },
              child: Text('Guardar datos'),
            ),
            Visibility(
              visible: widget.idServicio != 0,
              child: TextButton(
                onPressed: () async {
                  final response = await http.post(
                    Uri.parse('${Ambiente.uriServer}/api/servicio/borrar'),
                    body: jsonEncode(<String, dynamic>{'id': widget.idServicio}),
                    headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
                  );
                  print(response.body);
                  if (response.body == 'OK') {
                    Navigator.pop(context);
                  } else {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      title: 'Oops...',
                      text: response.body,
                    );
                  }
                },
                child: const Text('Eliminar'),
              ),
            ),
            if (widget.idServicio != 0)
              Expanded(child: _ListViewEtapas()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Etapa(idServicio: widget.idServicio, idEtapa: 0),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
