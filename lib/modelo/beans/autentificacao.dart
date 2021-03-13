
class Autentificacao {
  String usuario;
  String senha;

  Autentificacao(this.usuario, this.senha);

  Autentificacao.map(dynamic obj) {
    this.usuario = obj["usuario"];
    this.senha = obj["senha"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["usuario"] = this.usuario;
    map["senha"] = this.senha;

    return map;
  }

  Autentificacao.fromMap(Map<String, dynamic> mapa) {
    this.usuario = mapa["usuario"];
    this.senha = mapa["senha"];
  }

  Autentificacao.fromJson(Map<String, dynamic> json) :
      this.usuario = json["usuario"],
      this.senha = json["senha"];

  Map<String, dynamic> toJson() => {
    "usuario": usuario,
    "senha": senha
  };
}