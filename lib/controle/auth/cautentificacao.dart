import "dart:convert";

import 'package:fluxo_caixa/modelo/bd/bd_core.dart';
import 'package:fluxo_caixa/modelo/beans/autentificacao.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String OP_USUARIOSENHA = "usuariosenha";
const String OP_SEMLOGIN = "semlogin";

class CAutentificacao {
  // Método que testa se existe um usuário já cadastrado
  Future<bool> doesHaveUsuario() async {
    // Busca uma string Json persistida
    String jsonString = null;

    try {
      jsonString = await _getVariavelSharedPreferences(OP_USUARIOSENHA);
    } catch (e) {
      print(e);
    }

    // Testa se já tem um usuário cadastrado
    if (jsonString == null) {
      return false;
    }

    return true;
  }

  /* Método que recebe o Usuário e Senha e opção por não aparecer a tela de
  * login no próximo acesso. Responsável por fazer a autentificação. */
  Future<bool> logar(Autentificacao autRequisicao, bool _semLogin) async {
    // Busca string json persistida
    String jsonString = await _getVariavelSharedPreferences(OP_USUARIOSENHA);

    // Transforma String em objeto
    Autentificacao autPersistido =
        Autentificacao.fromJson(json.decode(jsonString));

    // Testando o "match" do usuário e senha
    if (autRequisicao.usuario == autPersistido.usuario &&
        autRequisicao.senha == autPersistido.senha) {
      // Verificação se vai pular a tela de login ou não no próximo acesso
      if (_semLogin)
        _setSemLogin();
      else
        _setComLogin();

      return true;
    }

    return false;
  }

  // Método que criar o usuário, zerando todos os dados anteriores
  Future<bool> criarUsuario(Autentificacao autRequisicao) async {
    try {
      // Deleta todos os registros dos bancos
      await BDCore.instance.executeSQL("DELETE FROM ${BDCore.tableGasto}");
      await BDCore.instance.executeSQL("DELETE FROM ${BDCore.tableReceita}");
      await BDCore.instance.executeSQL("DELETE FROM ${BDCore.tableTipoGasto}");
      await BDCore.instance
          .executeSQL("DELETE FROM ${BDCore.tableTipoReceita}");
    } catch (e) {
      print(e);
      return false;
    }

    // Converte o objeto de requisição em Json
    String jsonString = json.encode(autRequisicao);
    print(jsonString);

    // Substitui o valor da chave "usuariosenha"
    _setVariavelSharedPreferences(OP_USUARIOSENHA, jsonString);

    // Exige que a tela de login apareça
    _setComLogin();

    return true;
  }

  // Métodos que testam se é para aparecer a tela de login ou não
  Future<bool> _setSemLogin() async {
    _setVariavelSharedPreferences(OP_SEMLOGIN, "no_login");
    return true;
  }

  Future<bool> _setComLogin() async {
    _setVariavelSharedPreferences(OP_SEMLOGIN, "ok_login");
    return true;
  }

  Future<bool> getIfLogado() async {
    String string = "ok_login";

    try {
      // Busca string json persistida
      string = await _getVariavelSharedPreferences(OP_SEMLOGIN);
    } catch (e) {
      print(e);
      return false;
    }

    // Testa se está setado para haver login ou não
    if (string == "ok_login") return true;

    return false;
  }

  /* String SharedPreferences
  * Método para recuperar o valor(string) da chave em questão */
  Future<String> _getVariavelSharedPreferences(String OPCAO) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return (prefs.getString(OPCAO) ?? false);
  }

  /* String SharedPreferences
  * Método para setar persistentemente o valor(string) da chave em questão */
  Future<void> _setVariavelSharedPreferences(String OPCAO, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(OPCAO, value);
  }
}
