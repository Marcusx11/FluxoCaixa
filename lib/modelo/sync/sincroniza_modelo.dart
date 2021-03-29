import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';

import 'package:fluxo_caixa/modelo/beans/receita.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_gasto.dart';

import 'package:fluxo_caixa/modelo/beans/tipo_receita.dart';


class Sincroniza {
  //TODO fazer o registro do usuário que enviou cada dado no nome das coleções no firebase, assim montamos um sistema de bkp multiusuário

  //TODO fazer o metodo de setar a data e hora da ultima atualização no servidor
  /*Future setUltimaAtualizacao() async{
    await FirebaseFirestore.instance.document("ultimaAtualizacao").setData(
        {
          "date": DateTime.now(),
        });
  }*/
  //TODO fazer a consulta da data e hora da ultima atualização no servidor
  /*Future<UltimaAtualizacao> getUltimaAtualizacao() async{
    var s = await FirebaseFirestore.instance.document("ultimaAtualizacao").get();
    UltimaAtualizacao resp = UltimaAtualizacao.fromMap(s.data);
    return resp;
  }*/

  Future addTipoGasto(List<TipoGasto> tgs) async{
    for(TipoGasto tg in tgs)
      await FirebaseFirestore.instance.collection("tipo_gasto").add(tg.toMap());
  }

  Future<List<TipoGasto>> getAllTipoGasto() async{
    var teste = await FirebaseFirestore.instance.collection("tipo_gasto").get();
    //print(teste.toString());
    List<TipoGasto> lista = new List();
    for (var ds in teste.docs){
      TipoGasto tg = TipoGasto.fromMap(ds.data());
      lista.add(tg);
    }
    return lista;
  }

  Future delAllTipoGasto() async{
    await FirebaseFirestore.instance.collection("tipo_gasto").doc().delete();
  }

  Future addTipoReceita(List<TipoReceita> tgs) async{
    for(TipoReceita tg in tgs)
      await FirebaseFirestore.instance.collection("tipo_receita").add(tg.toMap());
  }

  Future<List<TipoReceita>> getAllTipoReceita() async{
    var teste = await FirebaseFirestore.instance.collection("tipo_receita").get();
    print(teste.toString());
    List<TipoReceita> lista = new List();
    for (var ds in teste.docs){
      TipoReceita tg = TipoReceita.fromMap(ds.data());
      lista.add(tg);
    }
    return lista;
  }

  Future delAllTipoReceita() async{
    await FirebaseFirestore.instance.collection("tipo_receita").doc().delete();
  }
  Future addReceita(List<Receita> tgs) async{
    for(Receita tg in tgs)
      await FirebaseFirestore.instance.collection("receita").add(tg.toMap());
  }

  Future<List<Receita>> getAllReceita() async{
    var teste = await FirebaseFirestore.instance.collection("receita").get();
    print(teste.toString());
    List<Receita> lista = new List();
    for (var ds in teste.docs){
      Receita tg = Receita.fromMap(ds.data());
      lista.add(tg);
    }
    return lista;
  }

  Future delAllReceita() async{
    await FirebaseFirestore.instance.collection("receita").doc().delete();
  }
  Future addGasto(List<Gasto> tgs) async{
    for(Gasto tg in tgs)
      await FirebaseFirestore.instance.collection("gasto").add(tg.toMap());
  }

  Future<List<Gasto>> getAllGasto() async{
    var teste = await FirebaseFirestore.instance.collection("gasto").get();
    print(teste.toString());
    List<Gasto> lista = new List();
    for (var ds in teste.docs){
      Gasto tg = Gasto.fromMap(ds.data());
      lista.add(tg);
    }
    return lista;
  }

  Future delAllGasto() async{
    await FirebaseFirestore.instance.collection("gasto").doc().delete();
  }
}