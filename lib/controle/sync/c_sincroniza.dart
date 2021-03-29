


import 'package:fluxo_caixa/controle/crud/cgastos.dart';
import 'package:fluxo_caixa/controle/crud/creceitas.dart';
import 'package:fluxo_caixa/controle/crud/ctipo_gastos.dart';
import 'package:fluxo_caixa/controle/crud/ctipo_receitas.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';
import 'package:fluxo_caixa/modelo/beans/receita.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_gasto.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_receita.dart';
import 'package:fluxo_caixa/modelo/sync/sincroniza_modelo.dart';

class CSincronia {
  Future sincronizaDados() async {
    //TODO fazer aqui o controle de data e hora da ultima atualização
    //TODO fazer em todos os controles de alteração do BD atualizar a data local da Ultima Atualização
    bool tipogasto = await _uploadTipoGasto();
    bool tiporeceita = await _uploadTipoReceita();
    bool gasto = await _uploadGasto();
    bool receita = await _uploadReceita();

    print(tipogasto);
    print(tiporeceita);
    print(gasto);
    print(receita);
  }

  Future<bool> _uploadTipoGasto() async {
    try {
      List<TipoGasto> tgs = await CTipoGastos().getAllTipoGastoInList();
      Sincroniza().delAllTipoGasto();
      Sincroniza().addTipoGasto(tgs);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> _uploadGasto() async {
    try {
      List<Gasto> tgs = await CGastos().getAllGastoInList();
      Sincroniza().delAllGasto();
      Sincroniza().addGasto(tgs);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> _uploadTipoReceita() async {
    try {
      List<TipoReceita> tgs = await CTipoReceitas().getAllTipoReceitaInList();
      Sincroniza().delAllTipoReceita();
      Sincroniza().addTipoReceita(tgs);
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> _uploadReceita() async {
    try {
      List<Receita> tgs = await CReceitas().getAllReceitaInList();
      Sincroniza().delAllReceita();
      Sincroniza().addReceita(tgs);
    } catch (e) {
      return false;
    }
    return true;
  }
}