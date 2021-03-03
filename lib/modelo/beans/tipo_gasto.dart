

class TipoGasto {
  int id;
  String nome;
  String descricao;

  TipoGasto(this.id, this.nome, this.descricao);

  TipoGasto.map(dynamic obj) {
    this.id = obj["id"];
    this.nome = obj["nome"];
    this.descricao = obj["descricao"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["nome"] = this.nome;
    map["descricao"] = this.descricao;

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }

  TipoGasto.fromMap(Map<String, dynamic> mapa) {
    this.id = mapa["id"];
    this.nome = mapa["nome"];
    this.descricao = mapa["descricao"];
  }
}