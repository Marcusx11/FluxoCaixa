import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluxo_caixa/controle/crud/cgastos.dart';
import 'package:fluxo_caixa/controle/crud/ctipo_gastos.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_gasto.dart';
import 'package:intl/intl.dart';

class CadastroGasto extends StatefulWidget {
  @override
  _CadastroGastoState createState() => _CadastroGastoState();
}

class _CadastroGastoState extends State<CadastroGasto> {
  // Variáveis do DropDownButton
  List<DropdownMenuItem<TipoGasto>> _dropTgs = List();
  List<TipoGasto> _tgs = []; // Lista extraída do BD
  TipoGasto _tgSelecionado = TipoGasto(-1, "Sem cadastro", "");
  DropdownButton _ddb = null;

  // Text Controllers
  TextEditingController _tecObservacoes = TextEditingController();
  TextEditingController _tecValor = TextEditingController();
  TextEditingController _tecData = TextEditingController();
  TextEditingController _tecHora = TextEditingController();

  // Controle responsável por criar uma máscara de dineiro para um TF
  MoneyMaskedTextController _tecValorMascara =
      MoneyMaskedTextController(decimalSeparator: '.');

  // Date Picker = Pegar uma data através de um popup de calendário
  DateTime _finalDate = DateTime.now();

  // Time Picker = Pegar um horário através de um popup de horários
  TimeOfDay _finalTime = TimeOfDay.now();

  // List View
  ListView _listaGastos;
  List<Gasto> _lg = [];

  @override
  void initState() {
    _iniciaDropDownButton();

    super.initState();

    _criaListaGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Cadastro de Gastos"),
          backgroundColor: Colors.blueGrey,
        ),
        backgroundColor: Colors.black12,
        body: Column(
          children: <Widget>[
            //card para inserção
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Tipo de Gasto: ",
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      //adiciona o DDB, se ele ainda for null, mostra um
                                      //texto, senão, mostra o próprio DDB
                                      this._dropTgs.isEmpty
                                          ? Text(
                                              "Sem Cadastro de Tipos de Gastos",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : DropdownButton<TipoGasto>(
                                              value: this._tgSelecionado,
                                              icon: Icon(Icons.arrow_downward),
                                              isExpanded: true,
                                              iconSize: 21,
                                              elevation: 12,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              underline: Container(
                                                height: 1,
                                                color: Colors.black54,
                                              ),
                                              onChanged: (TipoGasto
                                                  novoItemSelecionado) {
                                                setState(() {
                                                  this._tgSelecionado =
                                                      novoItemSelecionado;
                                                  _dropDownSelected(
                                                      this._tgSelecionado);
                                                });
                                              },
                                              items: this._dropTgs,
                                            ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Valor: ",
                                          style: TextStyle(fontSize: 10)),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: TextField(
                                              controller: this
                                                  ._tecValorMascara, //_tecValor,
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    12),
                                                WhitelistingTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Data: ",
                                                style: TextStyle(fontSize: 10)),
                                            TextField(
                                              controller: this._tecData,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    10),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 55,
                                        child: ButtonTheme(
                                          height: 40.0,
                                          child: RaisedButton(
                                            onPressed: _callDatePicker, //() {},
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0)),
                                            child: Icon(
                                              Icons.date_range,
                                              color: Colors.white,
                                            ),
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Hora: ",
                                                style: TextStyle(fontSize: 10)),
                                            TextField(
                                              controller: this._tecHora,
                                              keyboardType:
                                                  TextInputType.datetime,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                LengthLimitingTextInputFormatter(
                                                    5),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 55,
                                        child: ButtonTheme(
                                          height: 40.0,
                                          child: RaisedButton(
                                            onPressed: _callTimePicker, //() {},
                                            shape: new RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        12.0)),
                                            child: Icon(
                                              Icons.access_time,
                                              color: Colors.white,
                                            ),
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: <Widget>[
                                Text("Observações: ",
                                    style: TextStyle(fontSize: 10)),
                                TextField(
                                  controller: this._tecObservacoes,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: ButtonTheme(
                  height: 60.0,
                  child: RaisedButton(
                    onPressed: () {
                      _inserirGasto();
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
              ),
            ),
            Divider(),
            Text(":--Dados--:"),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: this._listaGastos,
              ),
            )
          ],
        ));
  }

  // Cria o DropDownButton
  Future<void> _criaDropDownButton() async {
    this._tgs = await CTipoGastos().getAllTipoGastoInList();
    if (this._tgs.isNotEmpty) this._tgSelecionado = this._tgs.elementAt(0);

    setState(() {
      this._dropTgs = this._tgs.map((TipoGasto dropDownStringItem) {
        return DropdownMenuItem<TipoGasto>(
          value: dropDownStringItem,
          child: Text(dropDownStringItem.nome),
        );
      }).toList();
    });
  }

  void _iniciaDropDownButton() async {
    await _criaDropDownButton();
  }

  void _dropDownSelected(TipoGasto tg) {
    setState(() {
      this._tgSelecionado = tg;
    });
  }

  // Cria a lista de gastos
  Future<void> _criaListaGastos() async {
    this._lg = await CGastos().getAllGastoInList();

    setState(() {
      // Gerando o listView
      this._listaGastos = ListView.builder(
        itemCount: _lg.length,
        itemBuilder: (context, index) {
          final Gasto item = _lg[index];
          return Card(
            child: Dismissible(
              direction: DismissDirection.startToEnd,

              /* Cada Dismissible deve conter uma Key.
            * As keys permitem ao Flutter identificar
            * o Widget de forma única */
              key: Key(item.id.toString()),

              /* Fornecemos uma função que diz ao app
               o que fazer depois que o item for
               arrastado */
              onDismissed: (direction) {
                // Remove o item da fonte de dados
                setState(() {
                  _deletaGasto(item);
                });

                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("${item.valor} foi removido"),
                ));
              },
              background: Container(
                alignment: Alignment.centerLeft,
                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              child: ListTile(
                title: Text(
                  "${item.valor}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Text(
                  "${item.dataHora}",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
                ),
                onTap: () {
                  setState(() {
                    _showAlert(item);
                  });
                },
                onLongPress: () {
                  setState(() {
                    _showAlert(item);
                  });
                },
              ),
            ),
          );
        },
      );
    });
  }

  Future<void> _deletaGasto(Gasto g) async {
    // Deleta o gasto
    await CGastos().deleteGasto(g);

    _criaListaGastos();
  }

  void _inserirGasto() async {
    try {
      double valor = double.parse(this._tecValorMascara.text);

      Gasto g = Gasto(
          null,
          this._tgSelecionado.id,
          this._tecObservacoes.text,
          DateFormat('yyyy-MM-dd').format(this._finalDate) +
              " " +
              this._tecHora.text,
          valor);

      int id = await CGastos().insertGasto(g);

      g.id = id;

      // Inserindo gastos no Firebase
      FirebaseFirestore.instance.collection("gasto").add(g.toMap());

      _criaListaGastos();
    } catch (e) {
      print(e);
    }
  }

  // Método para chamar o DatePicker
  void _callDatePicker() async {
    var order = await _getDate();

    setState(() {
      this._finalDate = order;
      this._tecData.text = DateFormat("dd/MM/yyyy").format(order);
    });
  }

  Future<DateTime> _getDate() {
    // Só retorna o Date Picker após selecioná-lo
    return showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light(),
            child: child,
          );
        });
  }

  // Método para chamar o TimePicker
  void _callTimePicker() async {
    var order = await _getTime();

    setState(() {
      this._finalTime = order;
      this._tecHora.text = order.format(context);
    });
  }

  Future<TimeOfDay> _getTime() async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  // Alert para mostrar os dados de cada gasto cadastrado
  void _showAlert(Gasto g) async {
    // Pega-se o tipo de gasto para exibição de seu nome
    TipoGasto tg = await CTipoGastos().getTipoGasto(g.tipo_gasto_id);

    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // Configura o AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Informações do Gasto"),
      content: tg == null
          ? CircularProgressIndicator()
          : Text("TIPO GASTO: ${g.tipo_gasto_id.toString()} - ${tg.nome};\n\n"
              "VALOR: ${g.valor};\n\n"
              "DATA: ${DateFormat("hh:mm dd/MM/yyyy").format(DateTime.parse(g.dataHora))};\n\n"
              "OBSERVAÇÕES: ${g.observacoes};"),
      actions: [okButton],
    );

    // Mostrando o Alert
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }
}
