import 'package:flutter/material.dart';
import 'package:frontend/components/footer_component.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackendScreen extends StatelessWidget {
  BackendScreen({Key? key}) : super(key: key);

  final TextEditingController urlController = TextEditingController();
  final TextEditingController clientIDController = TextEditingController();
  final TextEditingController clientSecretController = TextEditingController();

  Future<String> testURL(String backendUrl) async {
    Dio dio = Dio();
    try {
      await dio
          .post(
            '$backendUrl/api/v1/handshake',
            data: {
              'client_id': clientIDController.text,
              'client_secret': clientSecretController.text,
            },
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 8));
    } on DioException catch (error) {
      Map<String, dynamic> responseData = error.response?.data ?? {};
      return responseData['data'] ??
          'Não foi possível conectar ao backend. Verifique a URL ($backendUrl) e tente novamente.';
    }
    return 'Sucesso';
  }

  Future<void> saveKeysAtSharedPreferences(
      String backendUrl, String clientId, String clientSecret) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('backend_url', backendUrl);
    await prefs.setString('client_id', clientId);
    await prefs.setString('client_secret', clientSecret);
  }

  Future<void> validateBackendUrl(
      BuildContext context, String backendUrl) async {
    //verifque se clientIDController e clientSecretController estão vazios
    if (clientIDController.text.isEmpty ||
        clientSecretController.text.isEmpty) {
      Alert(
        context: context,
        title: 'Erro',
        desc:
            'Client ID e Client Secret são obrigatórios, certifique-se de preencher os campos corretamente, ou a aplicação não funcionará.',
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
      return;
    }

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
    testURL(backendUrl).then((value) {
      if (value == 'Sucesso') {
        saveKeysAtSharedPreferences(backendUrl, clientIDController.text,
                clientSecretController.text)
            .then((value) {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/login');
        });
      } else {
        //se value vier vazio, exibe a mensagem padrão
        String defaultmsg = value.isEmpty
            ? 'Não foi possível conectar ao backend. Verifique a URL ($backendUrl) e tente novamente.'
            : value;

        Navigator.pop(context);
        Alert(
          context: context,
          title: 'Erro',
          desc: defaultmsg,
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
        body: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.fromLTRB(
                20.0, 100.0, 20.0, 100.0), // Altera a margem do eixo X e Y
            child: Container(
              margin: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // adicione uma imagem de logo no centro
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
                    'Antes de iniciar a aplicação, é necessário informar o URL do backend. 🚀',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: urlController,
                    decoration: const InputDecoration(
                      labelText: 'URL do Backend',
                      hintText: 'http://192.168.0.3:8000',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                      height: 10.0), // Adiciona um espaço entre os campos
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: clientIDController,
                          decoration: const InputDecoration(
                            labelText: 'Client ID',
                            hintText: 'Ex: 1',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                          width: 10.0), // Adiciona um espaço entre os campos
                      Expanded(
                        child: TextField(
                          controller: clientSecretController,
                          decoration: const InputDecoration(
                            labelText: 'Client Secret',
                            hintText:
                                'Ex: NHWv3uDgSc12CxgAIlnky1KqERla1NsrEvhm0mVo',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      String backendUrl = urlController.text;
                      validateBackendUrl(context, backendUrl);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50.0),
                    ),
                    child: const Text('Avançar'),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const TaskifyFooter());
  }
}
