import 'package:fluxo_caixa/modelo/bd/bd_core.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_receita.dart';

class CTipoReceitas {
  Future<int> insertTipoReceita(TipoReceita r) async {
    int id = await BDCore.instance.insert(r.toMap(), BDCore.tableTipoReceita);
    print("Id da linha inserida: $id");
    return id;
  }

  Future<int> updateTipoReceita(TipoReceita r) async {
    final int linhasAfetadas =
    await BDCore.instance.update(r.toMap(), BDCore.tableTipoReceita);
    print("$linhasAfetadas linhas foram atualizadas.");
    return linhasAfetadas;
  }

  Future<int> deleteTipoReceita(TipoReceita r) async {
    final int linhaDeletada =
    await BDCore.instance.delete(r.id, BDCore.tableTipoReceita);
    print("Linha deletada: $linhaDeletada");
    return linhaDeletada;
  }

  Future<List<Map<String, dynamic>>> getAllTipoReceitas() async {
    final List todasLinhas =
    await BDCore.instance.queryAllRows(BDCore.tableTipoReceita);
    print("Consultando todas as ${todasLinhas.length} linhas");
    todasLinhas.forEach((row) => print(row));
    return todasLinhas; // Retorna uma lista de um mapa Hash
  }

  // Retorna todos os registros em forma de lista de objetos do respectivo bean
  Future<List<TipoReceita>> getAllTipoReceitaInList() async {
    final List todasLinhas =
    await BDCore.instance.queryAllRows(BDCore.tableTipoReceita);
    // Gerando a lista
    List<TipoReceita> lg = List.generate(
        todasLinhas.length,
            (i) => TipoReceita(
                todasLinhas[i]["id"],
                todasLinhas[i]["nome"],
                todasLinhas[i]["descricao"]));

    return lg;
  }

  Future<TipoReceita> getTipoReceita(int id) async {
    String sql = "SELECT * FROM tiporeceita WHERE id = $id;";

    final List todasLinhas = await BDCore.instance.querySQL(sql);
    List<TipoReceita> lg = List.generate(todasLinhas.length, (i) => TipoReceita(
        todasLinhas[i]["id"],
        todasLinhas[i]["nome"],
        todasLinhas[i]["descricao"]));

    if (lg.isEmpty) return null;

    return lg.elementAt(0);
  }
}
