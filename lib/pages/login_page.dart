import 'package:carros/domain/services/firebase-service.dart';
import 'package:carros/pages/home_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import 'package:carros/domain/services/login_service.dart';
import 'package:carros/utils/alerts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _tLogin = TextEditingController(text: "marcos");
  final _tSenha = TextEditingController(text: "123654");

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _progress = false;

  @override
  void initState() {
    super.initState();

    RemoteConfig.instance.then((remoteConfig) {
      remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));

      try {
        remoteConfig.fetch(expiration: const Duration(minutes: 1));
        remoteConfig.activateFetched();
      } catch (e) {
        print("Remote Config: $e");
      }

      final mensagem = remoteConfig.getString("mensagem");
      print('Mensagem: $mensagem');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carros"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _tLogin,
            validator: _validateLogin,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.blue, fontSize: 25),
            decoration: InputDecoration(
                labelText: "Login",
                labelStyle: TextStyle(color: Colors.black, fontSize: 25),
                hintText: "Digite o seu login",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          TextFormField(
            controller: _tSenha,
            validator: _validateSenha,
            obscureText: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Colors.blue, fontSize: 25),
            decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(color: Colors.black, fontSize: 25),
                hintText: "Digite a sua senha",
                hintStyle: TextStyle(color: Colors.black, fontSize: 18)),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 20),
            child: RaisedButton(
              color: Colors.blue,
              child: _progress
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    )
                  : Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
              onPressed: () {
                _onClickLogin(context);
              },
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.only(top: 20),
            child: GoogleSignInButton(
              onPressed: () {
                _onClickLoginGoogle(context);
              },
            ),
          )
        ],
      ),
    );
  }

  String _validateLogin(String text) {
    if (text.isEmpty) {
      return "Informe o login";
    }
    return null;
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Informe a senha";
    }
    if (text.length <= 2) {
      return "Senha precisa ter mais de 2 números";
    }
    return null;
  }

  _onClickLoginGoogle(context) async {
    print("Google");

    final service = FirebaseService();
    final response = await service.loginGoogle();

    if (response.isOk()) {
      pushReplacement(context, HomePage());
    } else {
      alert(context, "Error", response.msg);
    }
  }

  _onClickLogin(BuildContext context) async {
    final login = _tLogin.text;
    final senha = _tSenha.text;

    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final response = await LoginService.login(login, senha);

    if (response.isOk()) {
      pushReplacement(context, HomePage());
    } else {
      alert(context, "Error", response.msg);
    }

    setState(() {
      _progress = false;
    });
  }
}
