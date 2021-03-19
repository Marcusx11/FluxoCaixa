import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluxo_caixa/controle/crud/ctipo_receitas.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_receita.dart';

class CadastroTipoReceita extends StatefulWidget {
  @override
  _CadastroTipoReceitaState createState() => _CadastroTipoReceitaState();
}

class _CadastroTipoReceitaState extends State<CadastroTipoReceita> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _descController = TextEditingController();

  List<Widget> _listViewTiposReceita = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tipo de Receita"),
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
                      _insereTipoReceita();
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
            child: ListView(children: this._listViewTiposReceita),
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

  // Método para inserção de tipos de Receita
  void _insereTipoReceita() async {
    TipoReceita g =
        TipoReceita(null, _nomeController.text, _descController.text);
    int id = await CTipoReceitas().insertTipoReceita(g);

    g.id = id;

    // Inserindo gastos no Firebase
    FirebaseFirestore.instance.collection("tipo_receita").add(g.toMap());

    setState(() {
      _setListView();
    });
  }

  void _deleteTipoReceita(TipoReceita g) {
    CTipoReceitas().deleteTipoReceita(g);

    setState(() {
      _setListView();
    });
  }

  void _setListView() async {
    // Busca a lista de objetos no BD
    List<TipoReceita> _tiposReceita =
        await CTipoReceitas().getAllTipoReceitaInList();

    setState(() {
      try {
        this._listViewTiposReceita = _tiposReceita
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
                                _deleteTipoReceita(_data);
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
