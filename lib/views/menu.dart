
import 'package:flutter/material.dart';
import 'package:fluxo_caixa/views/cad_gasto.dart';
import 'package:fluxo_caixa/views/cad_receita.dart';
import 'package:fluxo_caixa/views/cad_tipo_gasto.dart';
import 'package:fluxo_caixa/views/cad_tipo_receita.dart';
import 'package:fluxo_caixa/views/home_page.dart';
import 'package:fluxo_caixa/views/relatorios.dart';


class Menu extends StatefulWidget {

  final int opcao;

  Menu({@required this.opcao});

  @override
  _MenuState createState() => _MenuState(this.opcao);
}




// Índice da seleção de tela
int _selectedIndex = 0;

// Lista das telas do app
List<Widget> _menuOptions = <Widget>[
  HomePage(),
  CadastroGasto(),
  CadastroReceita(),
  CadastroTipoGasto(),
  CadastroTipoReceita(),
  Relatorios()
];

// Lista das telas do Drawer
List<Widget> _drawerOptions = <Widget>[
  CadastroTipoGasto(),
  CadastroTipoReceita(),
  Relatorios()
];




// Lista de itens do BottomNavigationBar
const _bottomNavigationBarItems = <BottomNavigationBarItem>[
  BottomNavigationBarItem(
    icon: Icon(Icons.home),
    title: Text("Principal")
  ),

  BottomNavigationBarItem(
      icon: Icon(Icons.remove_circle),
      title: Text("Gastos")
  ),

  BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on),
      title: Text("Receitas")
  ),
];




// Corpo da tela
class _MenuState extends State<Menu> {

  _MenuState(this._opcao);
  int _opcao;


  @override
  void initState() {
    _selectedIndex = _opcao;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: _menuOptions.elementAt(_selectedIndex),

      drawer: Drawer(
        child: ListView(
          children: [
            // Cabeçalho do Drawer. Drawer estilo o de um app com conta logada
            UserAccountsDrawerHeader(
              accountName: Text("Fluxo App"),
              accountEmail: Text("Aplicativo de apoio financeiro"),
              decoration: BoxDecoration(
                color: Color(0xFF00ad9e),
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.blueGrey]
                )
              ),
              currentAccountPicture: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage( // Carrega uma imagem em tempo de execução
                  "https://www.ifmg.edu.br/portal/imagens/logovertical.jpg"
                ),
                backgroundColor: Colors.transparent,
              ),
              arrowColor: Colors.teal,
            ),

            // Lista de opções do Drawer
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Tipos de Gastos"),
              subtitle: Text("Tela dos Tipos de Gastos"),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => Menu(opcao: 3)
                ));
              },
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Tipos de Receitas"),
              subtitle: Text("Tela dos Tipos de Receitas"),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Menu(opcao: 4)
                ));
              },
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Relatórios"),
              subtitle: Text("Tela dos Relatórios"),
              trailing: Icon(Icons.navigate_next),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Menu(opcao: 5)
                ));
              },
            ),
          ],
        ),
      ),

      bottomNavigationBar: _selectedIndex > 2 ? null : BottomNavigationBar(
        items: _bottomNavigationBarItems,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepOrange,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }


  // Método para se trocar de tela pelo BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
