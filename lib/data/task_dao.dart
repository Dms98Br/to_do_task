import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/database.dart';
import 'package:sqflite/sqflite.dart';

class TaskDao {
  static const String _tableName = "taskTable";
  static const String _name = "name";
  static const String _difficulty = "difficulty";
  static const String _image = "image";

  static const String tableSql =
      "CREATE TABLE $_tableName ($_name TEXT, $_difficulty INTEGER, $_image TEXT)";

  save(Task tarefa) async {
    print('Iniciando Save: ');

    final Database database = await getDatabse();
    var itemExists = await find(tarefa.nome);

    Map<String, dynamic> taskMap = toMap(tarefa);

    if (itemExists.isEmpty) {
      print('A tarefa não existe.');
      return await database.insert(_tableName, taskMap);
    } else {
      print('Tarefa já existe');
      return await database.update(_tableName, taskMap,
          where: "$_name=?", whereArgs: [tarefa.nome]);
    }
  }

  Map<String, dynamic> toMap(Task tarefa) {
    print('Convertendo tarefa em Map: ');
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    print('Mapa de tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  Future<List<Task>> findAll() async {
    final Database database = await getDatabse();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    return toList(result);
  }

  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }
    print("Lista de tarefas: $tarefas");
    return tarefas;
  }

  Future<List<Task>> find(String nomedaTarefa) async {
    print('Acessando find');

    final Database database = await getDatabse();
    final List<Map<String, dynamic>> result = await database
        .query(_tableName, where: "$_name = ? ", whereArgs: [nomedaTarefa]);
    print("Tarefas encontrada: ${toList(result)}");
    return toList(result);
  }

  delete(String nomeDaTarefa) async {
    print("Deletando tarefas: $nomeDaTarefa");

    final Database database = await getDatabse();

    return database
        .delete(_tableName, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
  }
}
