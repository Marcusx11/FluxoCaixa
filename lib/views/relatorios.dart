import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/crud/cgastos.dart';
import 'package:fluxo_caixa/controle/crud/creceitas.dart';
import 'package:fluxo_caixa/controle/dolarapi/c_hgfinance_api.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';
import 'package:fluxo_caixa/modelo/beans/receita.dart';

class Relatorios extends StatefulWidget {
  @override
  _RelatoriosState createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  List<Widget> _valoresInDolar = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Relatórios"), backgroundColor: Colors.blueGrey),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Botão Gasto
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: ButtonTheme(
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () async {
                      await _getAllGastoInDolar();
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0)),
                    child: Text("Gasto em Dólar"),
                    color: Colors.blue,
                  ),
                ),
              ),

              // Botão Receita
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0),
                child: ButtonTheme(
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () async {
                      await _getAllReceitasInDolar();
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0)),
                    child: Text("Receita em Dólar"),
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
          this._valoresInDolar.isEmpty ? Padding(padding: EdgeInsets.all(5.0), child: null) : Expanded(
            child: ListView(children: this._valoresInDolar),
          )
        ],
      ),
    );
  }

  // Método para pegar todos os valores dos gastos e converte-os para dólar
  Future _getAllGastoInDolar() async {
    this._valoresInDolar.clear();

    List<Widget> newValoresDolar = [];
    List<Gasto> gastos = await CGastos().getAllGastoInList();

    for (Gasto g in gastos) {
      double valor = await CHGFinanceAPI().getValorInDolar(g.valor);

      newValoresDolar.add(Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text("${valor}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25)),
          )));
    }

    setState(() {
      this._valoresInDolar = newValoresDolar;
    });
  }

  // Método para pegar todos os valores das receitas e converte-os para dólar
  Future _getAllReceitasInDolar() async {
    this._valoresInDolar.clear();

    List<Widget> newValoresDolar = [];
    List<Receita> receitas = await CReceitas().getAllReceitaInList();

    for (Receita r in receitas) {
      double valor = await CHGFinanceAPI().getValorInDolar(r.valor);

      newValoresDolar.add(Card(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text("${valor}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 25)),
          )));
    }

    setState(() {
      this._valoresInDolar = newValoresDolar;
    });
  }
}
