import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluxo_caixa/splash.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers dos text fields
  TextEditingController _userController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  // Botões para controle de login, registro e sair do app
  List<Widget> _loginButtons = [null, null, null];

  @override
  void initState() {
    _apareceBotoes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: this._loginButtons[2],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tela de título e ícone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, size: 40.0, color: Colors.green),
              Text("Fluxo de Caixa",
                  style: TextStyle(fontSize: 40.0, color: Colors.green))
            ],
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Campo para digitar o nome de usuário
          TextField(
            style: TextStyle(color: Colors.green),
            decoration: InputDecoration(
                labelText: "Usuário",
                hintText: "Insira o nome do usuário",
                border: OutlineInputBorder()),
            controller: _userController,
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Campo para digitar o nome de usuário
          TextField(
            style: TextStyle(color: Colors.green),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: "Senha",
                hintText: "Insira sua senha",
                border: OutlineInputBorder()),
            controller: _senhaController,
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Botões da aplicação
          Padding(
            padding: EdgeInsets.all(12.5),
            child: this._loginButtons[0],
          ),

          // Botão para sair do app
          Padding(
            padding: EdgeInsets.all(12.5),
            child: this._loginButtons[1],
          ),
        ],
      ),
    );
  }

  // Faz os botões aparecerem
  void _apareceBotoes() {
    setState(() {
      // Botão de login
      this._loginButtons[0] = ButtonTheme(
        height: 60.0,
        child: RaisedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Splash()));
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: Colors.green),
      );

      // Botão para registrar um novo usuário
      this._loginButtons[1] = ButtonTheme(
        height: 60.0,
        child: RaisedButton(
            onPressed: () {},
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            child: Text(
              "Registrar",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: Colors.green),
      );

      // Botão de sair do aplicativo
      this._loginButtons[2] = ButtonTheme(
        height: 60.0,
        child: RaisedButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15.0)),
            child: Text(
              "Sair",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: Colors.green),
      );
    });
  }
}
