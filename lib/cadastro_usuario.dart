import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/auth/cautentificacao.dart';
import 'package:fluxo_caixa/modelo/beans/autentificacao.dart';
import 'package:toast/toast.dart';


class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {

  // Controllers dos text fields
  TextEditingController _userController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  // Botões para controle de login, registro e sair do app
  List<Widget> _registerButtons = [null, null];


  @override
  void initState() {
    _apareceBotoes();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 300),
            child: TextField(
              style: TextStyle(color: Colors.green),
              decoration: InputDecoration(
                  labelText: "Usuário",
                  hintText: "Insira o nome do usuário",
                  border: OutlineInputBorder()),
              controller: _userController,
            ),
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

          Padding(
            padding: EdgeInsets.all(10.0),
            child: this._registerButtons[0],
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: this._registerButtons[1],
          )
        ],


      ),
    );
  }

  // Faz os botões aparecerem
  void _apareceBotoes() {
    setState(() {
      // Botão de login
      this._registerButtons[0] = FractionallySizedBox(
        widthFactor: 1,
        child: ButtonTheme(
          height: 50.0,
          child: RaisedButton(
              onPressed: () {
                _cadastrarUsuario();

                setState(() {
                  this._registerButtons[0] = CircularProgressIndicator();
                  this._registerButtons[1] = null;
                });
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
              child: Text(
                "Cadastrar",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Colors.blueGrey),
        ),
      );

      // Botão para registrar um novo usuário
      this._registerButtons[1] = ButtonTheme(
        height: 60.0,
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)),
          child: Text(
            "Cancelar",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          color: Colors.blueGrey,
        ),
      );
    });
  }

  Future _cadastrarUsuario() async {
    Autentificacao a = Autentificacao(this._userController.text, this._senhaController.text);

    await CAutentificacao().criarUsuario(a);

    _msg("Usuário cadastrado com sucesso!");

    Navigator.pop(context);
  }

  _msg(String msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
