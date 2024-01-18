import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class TokenController {
  late String accessToken;
  late String refreshToken;
  late int timestamp;
  late int expiresIn;

  TokenController({
    required this.accessToken,
    required this.refreshToken,
    required this.timestamp,
    required this.expiresIn,
  });

  // Método para converter as informações do token para JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'timestamp': timestamp,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }

  // Método para criar uma instância de TokenController a partir de JSON
  factory TokenController.fromJson(Map<String, dynamic> json) {
    return TokenController(
      accessToken: json['accessToken'],
      timestamp: json['timestamp'],
      refreshToken: json['refreshToken'],
      expiresIn: json['expiresIn'],
    );
  }
}

class TokenManager {
  // Método para salvar as informações do token no SharedPreferences
  Future<void> saveTokenInfo(TokenController tokenController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      int currentTimestampInSeconds =
          DateTime.now().millisecondsSinceEpoch ~/ 1000;
      tokenController.timestamp = currentTimestampInSeconds;
      // Convert token information to JSON
      String tokenControllerJson = jsonEncode(tokenController.toJson());
      // Save JSON to SharedPreferences
      await prefs.setString('TokenInfo', tokenControllerJson);
    } catch (e) {
      debugPrint('Error saving token info: $e');
    }
  }

  // Método para obter as informações do token do SharedPreferences
  Future<TokenController?> getTokenInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve token information from SharedPreferences
    String? tokenControllerJson = prefs.getString('TokenInfo');

    if (tokenControllerJson != null) {
      try {
        // Attempt to parse JSON
        Map<String, dynamic> json =
            Map<String, dynamic>.from(jsonDecode(tokenControllerJson));

        // Check if the expected fields are present
        if (json.containsKey('accessToken') &&
            json.containsKey('refreshToken') &&
            json.containsKey('expiresIn')) {
          return TokenController.fromJson(json);
        }
      } catch (e) {
        debugPrint('Error parsing JSON: $e');
      }
    }
    return null;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('TokenInfo');
  }

  Future<bool> isUserLoggedIn() async {
    // Obter informações do token
    TokenController? tokenController = await getTokenInfo();
    // Verificar se o token está presente e válido
    if (tokenController != null) {
      int currentTimestampInSeconds =
          DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // Verificar se o token ainda é válido (não expirou)
      if (currentTimestampInSeconds - tokenController.timestamp <
          tokenController.expiresIn) {
        return true;
      } else {
        //Na versão BETA os tokens NÃO terão expiração (365 Dias), então não será necessário implementar o refresh token
        //Aqui pode ser feito um request para /oauth/token com o refreshToken para obter um novo token
        debugPrint('O token expirou.');
      }
    }
    return false; // Usuário não está logado ou não há informações de token
  }
}
