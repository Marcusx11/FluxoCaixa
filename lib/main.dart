import 'package:flutter/material.dart';
import 'package:fluxo_caixa/login.dart';
import 'package:fluxo_caixa/splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "Fluxo de Caixa",
    home: Login(),
  ));
}
