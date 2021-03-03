

class Gasto {
  int id;
  int tipo_gasto_id;
  String observacoes;
  String dataHora;
  double valor;

  Gasto(this.id, this.tipo_gasto_id, this.observacoes, this.dataHora, this.valor);

  Gasto.map(dynamic obj) {
    this.id = obj["id"];
    this.tipo_gasto_id = obj["tipo_gasto_id"];
    this.observacoes = obj["observacoes"];
    this.dataHora = obj["dataHora"];
    this.valor = obj["valor"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    // map["id"] = this.id;
    map["tipo_gasto_id"] = this.tipo_gasto_id;
    map["observacoes"] = this.observacoes;
    map["dataHora"] = this.dataHora;
    map["valor"] = this.valor;

    if (this.id != null) {
      map["id"] = this.id;
    }

    return map;
  }

  Gasto.fromMap(Map<String, dynamic> mapa) {
    this.id = mapa["id"];
    this.tipo_gasto_id = mapa["tipo_gasto_id"];
    this.observacoes = mapa["observacoes"];
    this.dataHora = mapa["dataHora"];
    this.valor = mapa["valor"];
  }
}