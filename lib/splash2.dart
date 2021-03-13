import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/auth/cautentificacao.dart';
import 'package:fluxo_caixa/login.dart';
import 'package:fluxo_caixa/modelo/beans/autentificacao.dart';
import 'package:fluxo_caixa/views/menu.dart';

class Splash2 extends StatefulWidget {
  @override
  _Splash2State createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  void initState() {
    super.initState();

    // Vai mostrar a tela construída no método Build durante "3" segundos
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Menu(opcao: 0)));
    });
  }

  @override
  // Constrói a tela do Splash2
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
}
