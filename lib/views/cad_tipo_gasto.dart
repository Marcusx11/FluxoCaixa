import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/crud/ctipo_gastos.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_gasto.dart';

class CadastroTipoGasto extends StatefulWidget {
  @override
  _CadastroTipoGastoState createState() => _CadastroTipoGastoState();
}

class _CadastroTipoGastoState extends State<CadastroTipoGasto> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  List<Widget> _listViewTiposGasto = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipo de Gasto"),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.black12,
      body: Column(
        children: <Widget>[
          //card para inserção
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Nome:",
                              style: TextStyle(fontSize: 10),
                            ),
                            TextField(
                              controller: this._nomeController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Descrição:", style: TextStyle(fontSize: 10)),
                            TextField(
                              maxLines: 2,
                              controller: this._descController,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 165,
                child: ButtonTheme(
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      _insereTipoGasto();
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(12.0)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
          Divider(
            height: 10,
          ),
          Text("--Dados--"),
          Expanded(
            child: ListView(children: this._listViewTiposGasto),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _setListView();

    super.initState();
  }

  // Método para inserção de tipos de gasto
  void _insereTipoGasto() {
    TipoGasto g = TipoGasto(null, _nomeController.text, _descController.text);
    CTipoGastos().insertTipoGasto(g);

    setState(() {
      _setListView();
    });
  }

  void _deleteTipoGasto(TipoGasto g) {
    CTipoGastos().deleteTipoGasto(g);

    setState(() {
      _setListView();
    });
  }

  void _setListView() async {
    // Busca a lista de objetos no BD
    List<TipoGasto> _tiposGasto = await CTipoGastos().getAllTipoGastoInList();

    setState(() {
      try {
        this._listViewTiposGasto = _tiposGasto
            .map(
              (_data) => Card(
                  elevation: 3,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  _data.nome.toString(),
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                Text(
                                  _data.descricao.toString(),
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 55,
                          child: ButtonTheme(
                            height: 60.0,
                            child: RaisedButton(
                              onPressed: () {
                                _deleteTipoGasto(_data);
                              },
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(12.0)),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                              color: Colors.blueGrey,
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
            )
            .toList();
      } catch (e) {
        print(e);
      }
    });
  }
}
