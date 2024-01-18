import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final String createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        createdAt: json['created_at']);
  }
}

class TasksManager {
  Future<List<Task>> listTasks() async {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      // Executar a requisição
      Response response = await dio
          .get(
            '/api/v1/tasks',
          )
          .timeout(const Duration(seconds: 15));

      // Verificar se a requisição foi bem-sucedida
      if (response.statusCode == 200) {
        // Converter a resposta JSON para uma lista de Map<String, dynamic>
        List<dynamic> jsonList = response.data;

        // Mapear explicitamente os tipos para Task
        List<Task> taskList = jsonList.map((taskJson) {
          return Task(
              id: taskJson['id'],
              title: taskJson['title'],
              description: taskJson['description'],
              createdAt: taskJson['created_at']);
        }).toList();

        debugPrint('here');
        return taskList;
      } else {
        debugPrint('Erro na requisição: ${response.statusCode}');
        // Em caso de erro, você pode lançar uma exceção ou retornar uma lista vazia
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro na requisição: $e');
      // Em caso de erro, você pode lançar uma exceção ou retornar uma lista vazia
      throw Exception('Erro na requisição: $e');
    }
  }

  Future<void> deleteTask(int taskId) async {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      Response response = await dio
          .delete(
            '/api/v1/tasks/$taskId',
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        debugPrint('Tarefa deletada com sucesso.');
      } else {
        debugPrint('Erro ao deletar a tarefa: ${response.statusCode}');
        throw Exception('Erro ao deletar a tarefa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao deletar a tarefa: $e');
      throw Exception('Erro ao deletar a tarefa: $e');
    }
  }

  Future<Map> createTask(String title, String description) async {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      Response response = await dio.post(
        '/api/v1/tasks',
        data: {
          'title': title,
          'description': description,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        return response.data;
      } else {
        debugPrint('Erro ao criar a tarefa: ${response.statusCode}');
        throw Exception('Erro ao criar a tarefa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao criar a tarefa: $e');
      throw Exception('Erro ao criar a tarefa: $e');
    }
  }

  Future<void> updateTask(int taskId, String title, String description) async {
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      Response response = await dio.put(
        '/api/v1/tasks/$taskId',
        data: {
          'title': title,
          'description': description,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        debugPrint('Tarefa atualizada com sucesso.');
      } else {
        debugPrint('Erro ao atualizar a tarefa: ${response.statusCode}');
        throw Exception('Erro ao atualizar a tarefa: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erro ao atualizar a tarefa: $e');
      throw Exception('Erro ao atualizar a tarefa: $e');
    }
  }
}
