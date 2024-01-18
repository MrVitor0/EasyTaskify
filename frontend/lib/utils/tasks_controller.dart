import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'dio_interceptor.dart';

class Task {
  final int id;
  final String title;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.description,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
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
          );
        }).toList();

        debugPrint(taskList.toString());
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
}
