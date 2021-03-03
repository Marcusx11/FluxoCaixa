import 'package:fluxo_caixa/modelo/bd/bd_core.dart';
import 'package:fluxo_caixa/modelo/beans/tipo_gasto.dart';

class CTipoGastos {
  Future<int> insertTipoGasto(TipoGasto g) async {
    int id = await BDCore.instance.insert(g.toMap(), BDCore.tableTipoGasto);
    print("Id da linha inserida: $id");
    return id;
  }

  Future<int> updateTipoGasto(TipoGasto g) async {
    final int linhasAfetadas =
        await BDCore.instance.update(g.toMap(), BDCore.tableTipoGasto);
    print("$linhasAfetadas linhas foram atualizadas.");
    return linhasAfetadas;
  }

  Future<int> deleteTipoGasto(TipoGasto g) async {
    final int linhaDeletada =
        await BDCore.instance.delete(g.id, BDCore.tableTipoGasto);
    print("Linha deletada: $linhaDeletada");
    return linhaDeletada;
  }

  Future<List<Map<String, dynamic>>> getAllTipoGastos() async {
    final List todasLinhas =
        await BDCore.instance.queryAllRows(BDCore.tableTipoGasto);
    print("Consultando todas as ${todasLinhas.length} linhas");
    todasLinhas.forEach((row) => print(row));
    return todasLinhas; // Retorna uma lista de um mapa Hash
  }

  // Retorna todos os registros em forma de lista de objetos do respectivo bean
  Future<List<TipoGasto>> getAllTipoGastoInList() async {
    final List todasLinhas =
        await BDCore.instance.queryAllRows(BDCore.tableTipoGasto);
    // Gerando a lista
    List<TipoGasto> lg = List.generate(
        todasLinhas.length,
        (i) => TipoGasto(
            todasLinhas[i]["id"],
            todasLinhas[i]["nome"],
            todasLinhas[i]["descricao"]));

    return lg;
  }

  Future<TipoGasto> getTipoGasto(int id) async {
    String sql = "SELECT * FROM tipogasto WHERE id = $id;";

    final List todasLinhas = await BDCore.instance.querySQL(sql);
    List<TipoGasto> lg = List.generate(
        todasLinhas.length,
        (i) => TipoGasto(
            todasLinhas[i]["id"],
            todasLinhas[i]["nome"],
            todasLinhas[i]["descricao"]));

    if (lg.isEmpty) return null;

    return lg.elementAt(0);
  }
}
