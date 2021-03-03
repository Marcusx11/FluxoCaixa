import 'package:fluxo_caixa/modelo/bd/bd_core.dart';
import 'package:fluxo_caixa/modelo/beans/gasto.dart';

class CGastos {
  Future<int> insertGasto(Gasto g) async {
    int id = await BDCore.instance.insert(g.toMap(), BDCore.tableGasto);
    print("Id da linha inserida: $id");
    return id;
  }

  Future<int> updateGasto(Gasto g) async {
    final int linhasAfetadas =
        await BDCore.instance.update(g.toMap(), BDCore.tableGasto);
    print("$linhasAfetadas linhas foram atualizadas.");
    return linhasAfetadas;
  }

  Future<int> deleteGasto(Gasto g) async {
    final int linhaDeletada =
        await BDCore.instance.delete(g.id, BDCore.tableGasto);
    print("Linha deletada: $linhaDeletada");
    return linhaDeletada;
  }

  Future<List<Map<String, dynamic>>> getAllGastos() async {
    final List todasLinhas =
        await BDCore.instance.queryAllRows(BDCore.tableGasto);
    print("Consultando todas as ${todasLinhas.length} linhas");
    todasLinhas.forEach((row) => print(row));
    return todasLinhas; // Retorna uma lista de um mapa Hash
  }

  // Retorna todos os registros em forma de lista de objetos do respectivo bean
  Future<List<Gasto>> getAllGastoInList() async {
    final List todasLinhas =
        await BDCore.instance.queryAllRows(BDCore.tableGasto);
    // Gerando a lista
    List<Gasto> lg = List.generate(
        todasLinhas.length,
        (i) => Gasto(
            todasLinhas[i]["id"],
            todasLinhas[i]["tipo_gasto_id"],
            todasLinhas[i]["observacoes"],
            todasLinhas[i]["dataHora"],
            todasLinhas[i]["valor"]));

    return lg;
  }

  Future<Gasto> getGasto(int id) async {
    String sql = "SELECT * FROM gasto WHERE id = $id;";

    final List todasLinhas = await BDCore.instance.querySQL(sql);
    List<Gasto> lg = List.generate(todasLinhas.length, (i) => Gasto(
        todasLinhas[i]["id"],
        todasLinhas[i]["tipo_gasto_id"],
        todasLinhas[i]["observacoes"],
        todasLinhas[i]["dataHora"],
        todasLinhas[i]["valor"]));

    if (lg.isEmpty) return null;

    return lg.elementAt(0);
  }
}
