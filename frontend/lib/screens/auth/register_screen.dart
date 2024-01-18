import 'dart:convert';
import '../dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/utils/dio_interceptor.dart';
import '/utils/token_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  //get backend url from shared preferences
  Future<String?> getBackendUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('backend_url');
  }

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

  Future<Map> registerAccount(String? backendUrl) async {
    // use interceptor
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());

    try {
      // Executar o registro
      await dio.post(
        '/api/register',
        data: {
          'grant_type': 'password',
          'name': nameController.text,
          'email': mailController.text,
          'password': passwordController.text,
        },
      ).timeout(const Duration(seconds: 15));
      // Executar o login
      Response responseLogin = await dio.post(
        '/oauth/token',
        data: {
          'grant_type': 'password',
          'username': mailController.text,
          'password': passwordController.text,
        },
      ).timeout(const Duration(seconds: 15));
      // Lógica para manipular as respostas conforme necessário
      // Restante do código para manipular a resposta de login e salvar tokens, etc.
      TokenController tokenInfo = TokenController(
        accessToken: responseLogin.data['access_token'],
        timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        refreshToken: responseLogin.data['refresh_token'],
        expiresIn: responseLogin.data['expires_in'],
      );
      TokenManager tokenManager = TokenManager();
      await tokenManager.saveTokenInfo(tokenInfo);
      // Retornar os dados necessários
      return responseLogin.data;
    } on DioException catch (error) {
      // Handle DioError para registro
      debugPrint('Erro no registro: ${error.response?.data}');
      String? firstErrorMessage;
      Map<String, dynamic> responseData = error.response?.data ?? {};
      if (responseData.containsKey('messages')) {
        Map<String, dynamic> messages = responseData['messages'];
        if (messages.isNotEmpty) {
          firstErrorMessage = messages.values.first[0];
        }
      }
      if (firstErrorMessage != null) {
        // Handle the error message as needed
        throw Exception(firstErrorMessage);
      }
      // Se não houver mensagens específicas, lançar uma mensagem padrão
      throw Exception('Oops, ocorreu um erro durante o registro.');
    } on Exception catch (error) {
      // Handle other types of errors for registro
      debugPrint('Erro no registro (outra exceção): $error');
      throw Exception('Oops, ocorreu um erro durante o registro.');
    }
  }

  Future<void> saveStringAtSharedPreferences(String chave, String valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, valor);
  }

  Future<void> register(BuildContext context) async {
    getBackendUrl().then((value) {
      Alert(
        context: context,
        title: 'Tentando Conexão',
        style: const AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        content: _buildLoadingWidget(),
        buttons: [],
      ).show();

      registerAccount(value).then((value) {
        Navigator.pop(context);
        debugPrint(value['access_token']);
        if (value['access_token'] != null && value['refresh_token'] != null) {
          // Use o contexto correto, como context de um StatefulWidget
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
          );
        }
      }).catchError((error) {
        //get exception message
        String errorMessage = error.message.toString();
        Navigator.pop(context);
        Alert(
          context: context,
          title: 'Oops',
          desc: errorMessage,
          style: const AlertStyle(
            backgroundColor: Colors.white,
            titleStyle: TextStyle(color: Colors.black),
            descStyle: TextStyle(color: Colors.black, fontSize: 16.0),
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          buttons: [
            DialogButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ).show();
      });
    });
  }

  Widget _buildLoadingWidget() {
    return Container(
      padding: const EdgeInsets.all(13.0),
      child: const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16.0),
          Text(
            'Aguarde...',
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
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
                    'EasyTaskify',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Por favor, informe o seu nome, seu e-mail e sua senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Seu nome',
                      hintText: 'John Doe',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: mailController,
                    decoration: const InputDecoration(
                      labelText: 'Seu e-mail',
                      hintText: 'john@doe.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Sua Senha',
                      hintText: '******',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      register(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                    ),
                    child: const Text('Cadastrar-se'),
                  ),
                  const SizedBox(height: 20.0),
                  InkWell(
                    onTap: () {
                      // Navegue para a tela de cadastro aqui
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      'Já tem uma conta? Conecte-se',
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
