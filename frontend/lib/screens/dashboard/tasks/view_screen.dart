import '../../dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/utils/tasks_controller.dart';
import '/utils/token_controller.dart';

class ViewScreen extends StatelessWidget {
  final Task taskData;
  ViewScreen({required this.taskData, Key? key}) : super(key: key) {
    // Definir valores iniciais para os campos de input
    idController.text = taskData.id.toString();
    creationDateController.text = taskData.createdAt;
    updateDateController.text = taskData.updatedAt;
    titleController.text = taskData.title;
    descriptionController.text = taskData.description;
  }

  final TextEditingController idController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController creationDateController = TextEditingController();
  final TextEditingController updateDateController = TextEditingController();

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

  String viewUID() {
    return taskData.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ),
            );
          },
        ),
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
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 100.0),
            child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Exibindo Detalhes',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Exibindo detalhes da task:  ${viewUID()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black, // Cor do texto para leitura
                    ),
                    controller: idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      labelStyle: TextStyle(
                        color: Colors.black, // Cor do hintText para leitura
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black, // Cor do texto para leitura
                    ),
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Titulo da Tarefa',
                      labelStyle: TextStyle(
                        color: Colors.black, // Cor do hintText para leitura
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black, // Cor do texto para leitura
                    ),
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição da Tarefa',
                      labelStyle: TextStyle(
                        color: Colors.black, // Cor do hintText para leitura
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black, // Cor do texto para leitura
                    ),
                    controller: creationDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Criação',
                      labelStyle: TextStyle(
                        color: Colors.black, // Cor do hintText para leitura
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black, // Cor do texto para leitura
                    ),
                    controller: updateDateController,
                    decoration: const InputDecoration(
                      labelText: 'Última Atualização',
                      labelStyle: TextStyle(
                        color: Colors.black, // Cor do hintText para leitura
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Voltar',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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
    );
  }
}
