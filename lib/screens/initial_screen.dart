import 'package:flutter/material.dart';
import 'package:nosso_primeiro_projeto/components/task.dart';
import 'package:nosso_primeiro_projeto/data/task_dao.dart';
import 'package:nosso_primeiro_projeto/data/task_inherited.dart';
import 'package:nosso_primeiro_projeto/screens/form_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text('Tarefas'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Task>>(
          future: TaskDao().findAll(),
          builder: (context, snapshot) {
            List<Task>? items = snapshot.data;
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        'Carregando...',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        'Carregando...',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
              case ConnectionState.active:
                return Center(
                  child: Column(
                    children: const [
                      CircularProgressIndicator(),
                      Text(
                        'Carregando...',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
              case ConnectionState.done:
                if (snapshot.hasData && items != null) {
                  if (items.isNotEmpty) {
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Task tarefa = items[index];
                          return tarefa;
                        });
                  }
                  return Center(
                    child: Column(
                      children: const [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 128,
                        ),
                        Text(
                          'Não há nenhuma tarefa',
                          style: TextStyle(fontSize: 32),
                        ),
                      ],
                    ),
                  );
                }
                return Center(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 128,
                      ),
                      Text(
                        'Erro ao carregar as tarefas...',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
                break;
              default:
                return Center(
                  child: Column(
                    children: const [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 128,
                      ),
                      Text(
                        'Erro desconhecido...',
                        style: TextStyle(fontSize: 32),
                      ),
                    ],
                  ),
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) => FormScreen(
                taskContext: context,
              ),
            ),
          ).then((value) => setState(() {
                print('regarregando a tela');
              }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
