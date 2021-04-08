import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluxo_caixa/controle/crud/cgastos.dart';
import 'package:fluxo_caixa/controle/crud/creceitas.dart';
import 'package:fluxo_caixa/controle/dolarapi/c_hgfinance_api.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';
import 'package:fluxo_caixa/modelo/beans/lucro.dart';
import 'package:fluxo_caixa/modelo/beans/receita.dart';

class Relatorios extends StatefulWidget {
  @override
  _RelatoriosState createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  List<double> _receitasInDolar = [];
  List<double> _gastosInDolar = [];

  List<double> _receitrasInReal = [];
  List<double> _gastosInReal = [];

  List<Lucro> _valoresLucro = [];

  List<charts.Series> seriesList = [];

  bool _isReal = true;

  List<double> _gastosAtuais = [];
  List<double> _receitasAtuais = [];

  Color _realButtonColor = Colors.blueGrey;
  Color _dolarButtonColor = Colors.grey;

  Widget gastoSparkline = CircularProgressIndicator();
  Widget receitaSparkline = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 4)).then((_) async {
      _gastosAtuais.clear();
      _receitasAtuais.clear();

      if (_isReal) {
        await _getAllGastoInReais();
        await _getAllReceitasInReais();

        _gastosAtuais = _gastosInReal;
        _receitasAtuais = _receitrasInReal;

        gastoSparkline = Sparkline(
          data: _gastosAtuais,
          lineColor: Colors.blueGrey,
          pointsMode: PointsMode.all,
          pointSize: 8.0,
          fillMode: FillMode.below,
          fillGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blueGrey[800], Colors.blueGrey[200]]),
        );

        this.seriesList = await _getAllLucroInReal();
      } else {
        await _getAllGastoInDolar();
        await _getAllReceitasInDolar();

        _gastosAtuais = _gastosInDolar;
        _receitasAtuais = _receitasInDolar;

        receitaSparkline = Sparkline(
          data: _receitasAtuais,
          lineColor: Colors.blueGrey,
          pointsMode: PointsMode.all,
          pointSize: 8.0,
          fillMode: FillMode.below,
          fillGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.amber[800], Colors.amber[200]]),
        );

        this.seriesList = await _getAllLucroInDolar();
      }
    });
  }

  Color _changeSelectedColor() {
    setState(() {
      if (_isReal) {
        _realButtonColor = Colors.blueGrey;
        _dolarButtonColor = Colors.grey;
      } else {
        _realButtonColor = Colors.grey;
        _dolarButtonColor = Colors.blueGrey;
      }
    });
  }

  void _mudarRealParaGastos() async {
    setState(() {
      gastoSparkline = Center(
        child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );

      receitaSparkline = Center(
        child: Container(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(),
        ),
      );
    });

    if (_isReal) {
      await _getAllGastoInReais();
      await _getAllReceitasInReais();

      _gastosAtuais = _gastosInReal;
    } else {
      await _getAllGastoInDolar();
      await _getAllReceitasInDolar();

      _gastosAtuais = _gastosInDolar;
    }

    setState(() {
      gastoSparkline = Sparkline(
        data: _gastosAtuais,
        lineColor: Colors.blueGrey,
        pointsMode: PointsMode.all,
        pointSize: 8.0,
        fillMode: FillMode.below,
        fillGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blueGrey[800], Colors.blueGrey[200]]),
      );

      receitaSparkline = Sparkline(
        data: _receitasAtuais,
        lineColor: Colors.blueGrey,
        pointsMode: PointsMode.all,
        pointSize: 8.0,
        fillMode: FillMode.below,
        fillGradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.amber[800], Colors.amber[200]]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text("Relatórios"), backgroundColor: Colors.blueGrey),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: [
            // Botão para visualização dos dados em Reais
            RaisedButton(
                onPressed: () {
                  _isReal = true;
                  _changeSelectedColor();

                  _mudarRealParaGastos();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                child: Text(
                  "Dados em Reais",
                  style: TextStyle(color: Colors.white, fontSize: 16.5),
                ),
                color: _realButtonColor),

            // Botão para visualização dos dados em Dólares
            RaisedButton(
                onPressed: () {
                  _isReal = false;
                  _changeSelectedColor();

                  _mudarRealParaGastos();
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0)),
                child: Text(
                  "Dados em Dólares",
                  style: TextStyle(color: Colors.white, fontSize: 16.5),
                ),
                color: _dolarButtonColor),

            // Gastos
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Text("Gastos durante os meses",
                      style: TextStyle(fontSize: 20.0, color: Colors.blueGrey)),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 400,
                      height: 190,
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Padding(
                          padding: EdgeInsets.all(11.0),
                          child: _gastosAtuais.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: Center(
                                    child: Text(
                                      "Sem registro de gastos",
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.blueGrey),
                                    ),
                                  ))
                              : gastoSparkline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Receitas
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Column(
                children: [
                  Text("Receitas durante os meses",
                      style: TextStyle(fontSize: 20.0, color: Colors.amber)),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      width: 400,
                      height: 190,
                      child: Material(
                        elevation: 14.0,
                        borderRadius: BorderRadius.circular(5.0),
                        child: Padding(
                          padding: EdgeInsets.all(11.0),
                          child: _receitasAtuais.isEmpty
                              ? Padding(
                              padding: EdgeInsets.all(1.0),
                              child: Center(
                                child: Text(
                                  "Sem registro de receitas",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.amber),
                                ),
                              ))
                              : receitaSparkline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 80.0),
            StaggeredTile.extent(1, 80.0),
            StaggeredTile.extent(4, 240.0),
            StaggeredTile.extent(4, 240.0),
          ],
        ));
  }

  _getAllLucroInReal() async {
    this._valoresLucro.clear();

    await _getAllGastoInReais();
    await _getAllReceitasInReais();

    List<Receita> receitas = await CReceitas().getAllReceitaInList();
    List<Gasto> gastos = await CGastos().getAllGastoInList();

    if (this._gastosInReal.length == this._receitrasInReal.length) {
      for (int i = 0; i < this._gastosInReal.length; i++) {
        this._valoresLucro.add(new Lucro(
            "" + gastos[i].dataHora, receitas[i].valor - gastos[i].valor));
      }
    }

    return [
      charts.Series<Lucro, String>(
          id: "Lucro",
          domainFn: (Lucro lucro, _) => lucro.data,
          measureFn: (Lucro lucro, _) => lucro.lucro,
          data: _valoresLucro,
          fillColorFn: (Lucro lucro, _) {
            return charts.MaterialPalette.blue.shadeDefault;
          })
    ];
  }

  _getAllLucroInDolar() async {
    this._valoresLucro.clear();

    await _getAllGastoInDolar();
    await _getAllReceitasInDolar();

    List<Receita> receitas = await CReceitas().getAllReceitaInList();
    List<Gasto> gastos = await CGastos().getAllGastoInList();

    if (this._gastosInReal.length == this._receitrasInReal.length) {
      for (int i = 0; i < this._gastosInReal.length; i++) {
        this._valoresLucro.add(new Lucro(
            "" + gastos[i].dataHora, receitas[i].valor - gastos[i].valor));
      }
    }

    return [
      charts.Series<Lucro, String>(
          id: "Lucro",
          domainFn: (Lucro lucro, _) => lucro.data,
          measureFn: (Lucro lucro, _) => lucro.lucro,
          data: _valoresLucro,
          fillColorFn: (Lucro lucro, _) {
            return charts.MaterialPalette.blue.shadeDefault;
          })
    ];
  }

  // Método para pegar todos os valores dos gastos e converte-os para dólar
  Future _getAllGastoInDolar() async {
    this._gastosInDolar.clear();

    List<Gasto> gastos = await CGastos().getAllGastoInList();

    for (Gasto g in gastos) {
      double valor = await CHGFinanceAPI().getValorInDolar(g.valor);

      this._gastosInDolar.add(valor);
    }
  }

  // Método para pegar todos os valores das receitas e converte-os para dólar
  Future _getAllReceitasInDolar() async {
    this._receitasInDolar.clear();

    List<Receita> receitas = await CReceitas().getAllReceitaInList();

    for (Receita r in receitas) {
      double valor = await CHGFinanceAPI().getValorInDolar(r.valor);

      this._receitasInDolar.add(valor);
    }
  }

  // Método para pegar todos os valores dos gastos em reais
  Future _getAllGastoInReais() async {
    this._gastosInReal.clear();

    List<Gasto> gastos = await CGastos().getAllGastoInList();

    for (Gasto g in gastos) {
      this._gastosInReal.add(g.valor);
    }
  }

  // Método para pegar todos os valores das receitas em reais
  Future _getAllReceitasInReais() async {
    this._receitrasInReal.clear();

    List<Receita> receitas = await CReceitas().getAllReceitaInList();

    for (Receita r in receitas) {
      this._receitrasInReal.add(r.valor);
    }
  }
}
