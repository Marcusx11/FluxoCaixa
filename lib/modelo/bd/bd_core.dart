import 'dart:io';

import 'package:fluxo_caixa/modelo/bd/bd_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class BDCore {
  String _databaseName = Configs.databaseName;
  int _databaseVersion = Configs.databaseVersion;

  static final tableGasto = "gasto";
  static final tableTipoGasto = "tipogasto";
  static final tableReceita = "receita";
  static final tableTipoReceita = "tiporeceita";

  // Deixa esta classe singleton
  BDCore._privateConstructor();
  static final BDCore instance = BDCore._privateConstructor();

  // Uma única referência do BD na app
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  // Abre o banco de dados e cria ele se este não existir
  _initDatabase() async {
    Directory docDirectory = await getApplicationDocumentsDirectory();
    String path = join(docDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Cria o BD da aplicação através de comandos SQL
  _onCreate(Database db, int version) async {
    // Criando tabela TipoGasto
    await db.execute('''CREATE TABLE $tableTipoGasto(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      descricao TEXT
    )''');

    // Criando tabela do Gasto
    await db.execute('''CREATE TABLE $tableGasto(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tipo_gasto_id INTEGER,
      observacoes TEXT,
      dataHora TEXT,
      valor FLOAT
    )''');

    // Criando tabela TipoReceita
    await db.execute('''CREATE TABLE $tableTipoReceita(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT,
      descricao TEXT
    )''');

    // Criando tabela Receita
    await db.execute('''CREATE TABLE $tableReceita(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tipo_receita_id INTEGER,
      observacoes TEXT,
      dataHora TEXT,
      valor FLOAT
    )''');
  }

  // Métodos Helper
  //----------------------------------------------------

  /* Insere uma linha no banco de dados onde cada chave
     no Map é um nome de coluna e o valor é o valor da coluna.
     O valor de retorno é o id da linha inserida. */
  Future<int> insert(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  /* Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
     uma lista de valores-chave de colunas. */
  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> querySQL(String sql) async {
    Database db = await instance.database;
    return await db.rawQuery(sql);
  }

  Future<void> executeSQL(String sql) async {
    Database db = await instance.database;
    return await db.execute(sql);
  }

  /* Todos os métodos : inserir, consultar, atualizar e excluir, também podem
     ser feitos usando comandos SQL brutos. Esse método usa uma consulta bruta
     para fornecer a contagem de linhas. */
  Future<int> queryRowCount(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  /* Assume-se aqui que a coluna id no mapa está definida. Os outros
     valores das colunas serão usados para atualizar a linha. */
  Future<int> update(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row["id"];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }

  /* Exclui a linha especificada pelo id. O número de linhas afetadas é
     retornada. Isso deve ser igual a 1, contanto que a linha exista. */
  Future<int> delete(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
