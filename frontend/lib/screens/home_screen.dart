import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController urlController = TextEditingController();

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

  Future<String> testURL(String backendUrl) async {
    Dio dio = Dio();
    try {
      Response response = await dio
          .post(
            '$backendUrl/api/v1/handshake',
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          )
          .timeout(const Duration(seconds: 8));
      print(response.data);
    } catch (e) {
      return e.toString();
    }
    return 'Sucesso';
  }

  Future<void> salvarStringNoSharedPreferences(
      String chave, String valor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(chave, valor);
  }

  Future<void> validateBackendUrl(
      BuildContext context, String backendUrl) async {
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
        salvarStringNoSharedPreferences('nome', 'John Doe').then((value) {
          Navigator.pushNamed(context, '/login');
        });
      } else {
        Navigator.pop(context);
        Alert(
          context: context,
          title: 'Erro',
          desc:
              'Não foi possível conectar ao backend. Verifique a URL ($backendUrl) e tente novamente.',
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
                //adicione uma imagem de logo no centro
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
                    style: TextStyle(color: Colors.black, fontSize: 16.0)),
                const SizedBox(height: 20.0),
                TextField(
                  controller: urlController,
                  decoration: const InputDecoration(
                    labelText: 'URL do Backend',
                    hintText: 'http://192.168.0.3:8000',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    String backendUrl =
                        urlController.text; // Obtém o valor do campo de texto
                    validateBackendUrl(context,
                        backendUrl); // Passa o valor para a função validateBackendUrl
                  },
                  //precisa ser mais largo
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0, // Remove a sombra do BottomAppBar
        child: SizedBox(
          height: 80.0, // Ajuste conforme necessário
          child: Center(
            child: GestureDetector(
              onTap: () {
                //open browser
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
