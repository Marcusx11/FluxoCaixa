import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/auth/cautentificacao.dart';
import 'package:fluxo_caixa/login.dart';
import 'package:fluxo_caixa/modelo/beans/autentificacao.dart';
import 'package:fluxo_caixa/splash2.dart';

class Splash1 extends StatefulWidget {
  @override
  _Splash1State createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {

  bool _login = false;

  @override
  void initState() {
    super.initState();
    _criarUsuarioTeste();

    // Vai mostrar a tela construída no método Build durante "3" segundos
    Future.delayed(Duration(seconds: 4)).then((_) {

      if (this._login) {
        // Caso em que a opção de pular a tela de login não foi habilitada
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      } else {
        // Caso em que a opção de pular a tela de login foi habilitada
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Splash2()));
      }


    });
  }

  @override
  // Constrói a tela do Splash1
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("imgs/logo.png", width: 250, color: Colors.white),
          Padding(
              padding: EdgeInsets.all(25.0),
              child: CircularProgressIndicator(backgroundColor: Colors.white))
        ],
      ),
    );
  }

  Future<void> _criarUsuarioTeste() async {
    // Se não existir o usuário, ele é criado

    if (await CAutentificacao().doesHaveUsuario()) {

      // Verifica se precisa ir pra tela de login ou se pode pulá-la
      this._login = await CAutentificacao().getIfLogado();
    } else {
      this._login = true;
    }
  }
}
