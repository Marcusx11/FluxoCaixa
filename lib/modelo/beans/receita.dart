

class Receita {
  int id;
  int tipo_receita_id;
  String observacoes;
  String dataHora;
  double valor;

  Receita(this.id, this.tipo_receita_id, this.observacoes, this.dataHora, this.valor);

  Receita.map(dynamic obj) {
    this.id = obj["id"];
    this.tipo_receita_id = obj["tipo_receita_id"];
    this.observacoes = obj["observacoes"];
    this.dataHora = obj["dataHora"];
    this.valor = obj["valor"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    // map["id"] = this.id;
    map["tipo_receita_id"] = this.tipo_receita_id;
    map["observacoes"] = this.observacoes;
    map["dataHora"] = this.dataHora;
    map["valor"] = this.valor;

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }

  Receita.fromMap(Map<String, dynamic> mapa) {
    this.id = mapa["id"];
    this.tipo_receita_id = mapa["tipo_receita_id"];
    this.observacoes = mapa["observacoes"];
    this.dataHora = mapa["dataHora"];
    this.valor = mapa["valor"];
  }
}