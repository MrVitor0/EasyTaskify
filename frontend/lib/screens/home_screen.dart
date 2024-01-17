import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:dio/dio.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController urlController = TextEditingController();

  goToLicense() async {
    const url = 'https://github.com/MrVitor0/EasyTaskify/blob/main/LICENSE';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  Future<String> testURL(String backendUrl) async {
    Dio dio = Dio();
    try {
      Response response = await dio.post('$backendUrl/api/v1/handshake',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
      );
      print(response.data);
    } catch (e) {
        return e.toString();
    }
    return 'Sucesso';
  }


  Future<void>  validateBackendUrl(BuildContext context, String backendUrl) async  {
    Alert(
      context: context,
      title: 'Tentando Conexão',
      style: AlertStyle(
        backgroundColor: Colors.white,
        titleStyle: TextStyle(color: Colors.black),
        isCloseButton: false,
      isOverlayTapDismiss: false,
      ),
      content: _buildLoadingWidget(),
      buttons: [],
        
    ).show();
    var response = await testURL(backendUrl);
    Navigator.pop(context);
    if (response == 'Sucesso') {
      Navigator.pushNamed(context, '/login');
    } else {
      Alert(
        context: context,
        title: 'Erro',
        desc: 'Não foi possível conectar ao backend. Verifique a URL ($backendUrl) e tente novamente.',
        style: AlertStyle(
          backgroundColor: Colors.white,
          titleStyle: TextStyle(color: Colors.black),
          descStyle: TextStyle(color: Colors.black, fontSize: 16.0),
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        buttons: [
          DialogButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ).show();
    }
   
  }

  Widget _buildLoadingWidget() {
      return Container(
        padding: EdgeInsets.all(13.0),
        child: Column(
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
      backgroundColor: Color(0xFFD9D9D9),
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
          margin: EdgeInsets.fromLTRB(20.0, 100.0, 20.0, 100.0), // Altera a margem do eixo X e Y
          child: Container(
            margin: EdgeInsets.all(20.0), 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

             //adicione uma imagem de logo no centro
            Text(
              'EasyTaskify',
              style: TextStyle(
                color: Colors.black,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
             'Antes de iniciar a aplicação, é necessário informar o URL do backend. 🚀',
             textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16.0) 
            ),
            SizedBox(height: 20.0), 
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                 labelText: 'URL do Backend',
                hintText: 'http://192.168.0.3:8000',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
             onPressed: () {
                String backendUrl = urlController.text; // Obtém o valor do campo de texto
                validateBackendUrl(context, backendUrl); // Passa o valor para a função validateBackendUrl
              },
              //precisa ser mais largo
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.0),
              ),
              child: Text('Avançar'),
            ),
          ],
        ),
       ),
      ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0, // Remove a sombra do BottomAppBar
        child: Container(
          height: 80.0, // Ajuste conforme necessário
          child: Center(
            child: GestureDetector(
              onTap: () {
                //open browser
                goToLicense();
              },
              child: Text(
                'Licença & Termos de Uso',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}