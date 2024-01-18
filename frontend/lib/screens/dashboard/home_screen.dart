import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard/tasks/update_screen.dart';
import 'package:frontend/screens/dashboard/tasks/view_screen.dart';
import 'package:frontend/utils/tasks_controller.dart';
import '/utils/token_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];

  goToLicense() async {
    Uri url = Uri(
      scheme: 'https',
      host: 'github.com',
      path: 'MrVitor0/EasyTaskify/blob/main/LICENSE',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<List<Task>> listTasks() async {
    TasksManager taskManager = TasksManager();
    List<Task> tasks = await taskManager.listTasks();
    return tasks;
  }

  FutureBuilder<List<Task>> _buildTaskList() {
    return FutureBuilder<List<Task>>(
      future: listTasks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Carregando tarefas..'),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text('Erro ao carregar as tarefas: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text('Nenhuma tarefa encontrada.'),
            ),
          );
        } else {
          _tasks = snapshot.data!;
          return Column(
            children: [
              for (var task in _tasks)
                ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewScreen(taskData: task),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UpdateScreen(taskData: task),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        //color redf
                        onPressed: () async {
                          try {
                            TasksManager taskManager = TasksManager();
                            await taskManager.deleteTask(task.id);
                            setState(() {
                              _tasks.remove(task);
                            });
                          } catch (e) {
                            debugPrint('Erro ao deletar a tarefa: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('EasyTaskify'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                TokenManager tokenManager = TokenManager();
                tokenManager.logout().then((value) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/tasks/create");
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Cadastarar Nova Task'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300,
                width: 600,
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: _buildTaskList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: SizedBox(
            height: 80.0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  goToLicense();
                },
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Licença de Uso',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      'TODOS os Direitos Reservados',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
