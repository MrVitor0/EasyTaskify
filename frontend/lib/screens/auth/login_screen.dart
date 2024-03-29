import 'package:flutter/material.dart';
import 'package:frontend/components/footer_component.dart';
import '../dashboard/home_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/utils/dio_interceptor.dart';
import '/utils/token_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //get backend url from shared preferences
  Future<String?> getBackendUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('backend_url');
  }

  Future<Map> loginRequest(String? backendUrl) async {
    //use interceptor
    Dio dio = Dio();
    dio.interceptors.add(AuthInterceptor());
    Response response;
    try {
      response = await dio.post(
        '/oauth/token',
        data: {
          'grant_type': 'password',
          'username': mailController.text,
          'password': passwordController.text,
        },
      ).timeout(const Duration(seconds: 8));

      TokenController tokenInfo = TokenController(
        accessToken: response.data['access_token'],
        timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        refreshToken: response.data['refresh_token'],
        expiresIn: response.data['expires_in'],
      );
      TokenManager tokenManager = TokenManager();
      await tokenManager.saveTokenInfo(tokenInfo);
    } catch (e) {
      return {'error': e.toString()};
    }
    return response.data;
  }

  Future<void> saveStringAtSharedPreferences(String chave, String valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, valor);
  }

  Future<void> loginUser(BuildContext context) async {
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
      loginRequest(value).then((value) {
        Navigator.pop(context);
        if (value['access_token'] != null && value['refresh_token'] != null) {
          // Use o contexto correto, como context de um StatefulWidget
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(),
            ),
          );
        } else {
          Navigator.pop(context);
          Alert(
            context: context,
            title: 'Erro',
            desc:
                'Nome de usuário ou senha incorretos, por favor, tente novamente.',
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
        }
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
          actions: [
            IconButton(
              icon: const Icon(Icons.restore),
              onPressed: () {
                TokenManager tokenManager = TokenManager();
                tokenManager.refreshBackend().then((value) {
                  Navigator.pushReplacementNamed(context, '/backend');
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
                      'EasyTaskify',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Por favor, informe o seu login e sua senha.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
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
                        loginUser(context);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50.0),
                      ),
                      child: const Text('Conectar-se'),
                    ),
                    const SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        // Navegue para a tela de cadastro aqui
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Não tem uma conta? Cadastre-se',
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
