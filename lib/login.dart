import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluxo_caixa/cadastro_usuario.dart';
import 'package:fluxo_caixa/controle/auth/cautentificacao.dart';
import 'package:fluxo_caixa/modelo/beans/autentificacao.dart';
import 'package:fluxo_caixa/splash1.dart';
import 'package:fluxo_caixa/splash2.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Controllers dos text fields
  TextEditingController _userController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  bool _checkSeNaoLogin = false;

  // Botões para controle de login, registro e sair do app
  List<Widget> _loginButtons = [null, null];

  @override
  void initState() {
    _apareceBotoes();
    super.initState();
  }

  // bloqueia a rotação, para somente portrait
  void _portraitModeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 15.5, 0.0, 10.1),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 180,
                height: 130,
                child: Image.asset(
                  "imgs/logo.png",
                  width: 150,
                ),
              ),
            ),
          ),
          // Tela de título e ícone
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monetization_on, size: 40.0, color: Colors.blueGrey),
              Text("Fluxo de Caixa",
                  style: TextStyle(fontSize: 40.0, color: Colors.blueGrey))
            ],
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Campo para digitar o nome de usuário
          TextField(
            style: TextStyle(color: Colors.green),
            decoration: InputDecoration(
                labelText: "Usuário",
                hintText: "Insira o nome do usuário",
                border: OutlineInputBorder()),
            controller: _userController,
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Campo para digitar o nome de usuário
          TextField(
            style: TextStyle(color: Colors.green),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: "Senha",
                hintText: "Insira sua senha",
                border: OutlineInputBorder()),
            controller: _senhaController,
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Checkbox(
                  value: _checkSeNaoLogin,
                  activeColor: Colors.green,
                  onChanged: (bool newValue) {
                    setState(() {
                      _checkSeNaoLogin = newValue;
                    });
                    Text('Não solicitar mais login');
                  }),
              Text('Não solicitar mais login')
            ],
          ),

          Opacity(
            child: Divider(),
            opacity: 0.0,
          ),

          // Botões da aplicação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [this._loginButtons[0], this._loginButtons[1]],
            ),
          ),
        ],
      ),
    );
  }

  // Faz os botões aparecerem
  void _apareceBotoes() {
    setState(() {
      // Botão de login
      this._loginButtons[0] = FractionallySizedBox(
        widthFactor: 1,
        child: ButtonTheme(
          height: 50.0,
          child: RaisedButton(
              onPressed: () {
                login();
              },
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0)),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              color: Colors.blueGrey),
        ),
      );

      // Botão para registrar um novo usuário
      this._loginButtons[1] = ButtonTheme(
        height: 60.0,
        child: FlatButton(
          onPressed: () {
            _onCadUser();
          },
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)),
          child: Text(
            "Registrar",
            style: TextStyle(color: Colors.blueGrey, fontSize: 18),
          ),
        ),
      );
    });
  }

  // Chama interface de cadastro de usuário
  void _onCadUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CadastroUsuario()));
  }

  void _onClickLogin() {
    setState(() {
      login();
    });
  }

  Future<void> login() async {
    //currentLocationThis = await currentLocationThis;

    try {
      //CAutenticacao c = new CAutenticacao();
      Autentificacao a = new Autentificacao(
          this._userController.text, this._senhaController.text);

      if (await new CAutentificacao().logar(a, _checkSeNaoLogin)) {
        print('logado');
        //usuarioLogado = c;
        try {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Splash2()));
        } catch (_) {
          print(_);
        }
      } else {
        print('não logado');
        _msg("Falha ao logar, verifique seu usuário e senha.");
      }
    } catch (_) {
      _msg("Falha ao logar, Verifique sua conexão, usuário e senha.");
    }
  }

  _msg(String msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
