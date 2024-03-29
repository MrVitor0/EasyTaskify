import 'package:frontend/components/footer_component.dart';
import 'package:frontend/components/navbar_component.dart';
import '../../dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import '/utils/tasks_controller.dart';

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

  String viewUID() {
    return taskData.id.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFD9D9D9),
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: const TaskifyNavbar(),
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
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16.0),
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
                            builder: (BuildContext context) =>
                                const HomeScreen(),
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
        bottomNavigationBar: const TaskifyFooter());
  }
}
