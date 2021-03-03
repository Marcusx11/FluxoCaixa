import 'package:fluxo_caixa/modelo/bd/bd_core.dart';
import 'package:fluxo_caixa/modelo/beans/receita.dart';

class CReceitas {
  Future<int> insertReceita(Receita r) async {
    int id = await BDCore.instance.insert(r.toMap(), BDCore.tableReceita);
    print("Id da linha inserida: $id");
    return id;
  }

  Future<int> updateReceita(Receita r) async {
    final int linhasAfetadas =
    await BDCore.instance.update(r.toMap(), BDCore.tableReceita);
    print("$linhasAfetadas linhas foram atualizadas.");
    return linhasAfetadas;
  }

  Future<int> deleteReceita(Receita r) async {
    final int linhaDeletada =
    await BDCore.instance.delete(r.id, BDCore.tableReceita);
    print("Linha deletada: $linhaDeletada");
    return linhaDeletada;
  }

  Future<List<Map<String, dynamic>>> getAllReceitas() async {
    final List todasLinhas =
    await BDCore.instance.queryAllRows(BDCore.tableReceita);
    print("Consultando todas as ${todasLinhas.length} linhas");
    todasLinhas.forEach((row) => print(row));
    return todasLinhas; // Retorna uma lista de um mapa Hash
  }

  // Retorna todos os registros em forma de lista de objetos do respectivo bean
  Future<List<Receita>> getAllReceitaInList() async {
    final List todasLinhas =
    await BDCore.instance.queryAllRows(BDCore.tableReceita);
    // Gerando a lista
    List<Receita> lg = List.generate(
        todasLinhas.length,
            (i) => Receita(
            todasLinhas[i]["id"],
            todasLinhas[i]["tipo_receita_id"],
            todasLinhas[i]["observacoes"],
            todasLinhas[i]["dataHora"],
            todasLinhas[i]["valor"]));

    return lg;
  }

  Future<Receita> getReceita(int id) async {
    String sql = "SELECT * FROM receita WHERE id = $id;";

    final List todasLinhas = await BDCore.instance.querySQL(sql);
    List<Receita> lg = List.generate(todasLinhas.length, (i) => Receita(
        todasLinhas[i]["id"],
        todasLinhas[i]["tipo_receita_id"],
        todasLinhas[i]["observacoes"],
        todasLinhas[i]["dataHora"],
        todasLinhas[i]["valor"]));

    if (lg.isEmpty) return null;

    return lg.elementAt(0);
  }
}
