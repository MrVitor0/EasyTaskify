import 'dart:async';
import 'token_controller.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Adiciona headers padrão
    options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    options.headers['Accept'] = 'application/json';

    // Verifica se há um token no SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TokenController? tokenController = await TokenManager().getTokenInfo();

    // Adiciona o access_token ao cabeçalho Authorization se existir
    if (tokenController != null) {
      options.headers['Authorization'] =
          'Bearer ${tokenController.accessToken}';
    }

    // Adiciona client_id e client_secret ao corpo (body) da solicitação, isso precisa estar no .ENV (Facilitar Instalação)
    Map<String, dynamic> newData = {
      'client_id': '6',
      'client_secret': 'NHWv3uDgSc12CxgAIlnky1KqERla1NsrEvhm0mVo',
    };

    // Mescla os dados existentes com os novos dados
    if (options.data is Map<String, dynamic>) {
      newData.addAll(options.data);
    }

    options.data = newData;

    // Obtém a chave "backend_url" do SharedPreferences e adiciona à URL
    String? backendUrl = prefs.getString('backend_url');
    if (backendUrl != null && backendUrl.isNotEmpty) {
      options.baseUrl = backendUrl;
    }

    return super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // Lógica de tratamento de erro aqui, se necessário
    return super.onError(err, handler);
  }
}
