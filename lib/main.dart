import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluxo_caixa/login.dart';
import 'package:fluxo_caixa/splash1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Fluxo de Caixa",
    home: Splash1(),
  ));
}
