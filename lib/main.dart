import 'package:flutter/material.dart';
import 'package:fluxo_caixa/login.dart';
import 'package:fluxo_caixa/splash1.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "Fluxo de Caixa",
    home: Splash1(),
  ));
}
