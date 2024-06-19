import 'dart:convert';
import 'package:autolavado/Models/LoginResponse.dart';
import 'package:autolavado/Pages/Home.dart';
import 'package:autolavado/Utils/Ambiente.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController txtUser = TextEditingController();
  final TextEditingController txtPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
              'https://w7.pngwing.com/pngs/178/595/png-transparent-user-profile-computer-icons-login-user-avatars-thumbnail.png'),
          TextField(
            decoration: InputDecoration(labelText: 'Usuario'),
            controller: txtUser,
          ),
          TextField(
            decoration: InputDecoration(labelText: 'Contraseña'),
            controller: txtPass,
            obscureText: true,
          ),
          TextButton(
              onPressed: () async {
                final response = await http.post(
                  Uri.parse('${Ambiente.uriServer}/api/login'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'email': txtUser.text,
                    'password': txtPass.text,
                  }),
                );

                Map<String, dynamic> responseJson = jsonDecode(response.body);
                final loginResponse = LoginResponse.fromJson(responseJson);

                if (loginResponse.acceso == "OK") {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                } else {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    title: 'Oops...',
                    text: loginResponse.error,
                  );
                }
              },
              child: Text('Ingresar'))
        ],
      )),
    );
  }
}