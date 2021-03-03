import 'package:flutter/material.dart';
import 'package:fluxo_caixa/views/menu.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
  // Constrói a tela do Splash
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
