import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/utils/token_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void printUrl() {
    SharedPreferences.getInstance().then((prefs) {
      debugPrint(prefs.getString('backend_url'));
    });
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('EasyTaskify'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                TokenManager tokenManager = TokenManager();
                tokenManager.logout().then((value) {
                  Navigator.pushReplacementNamed(context, '/login');
                });
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Novos botões na parte superior
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Adicione sua lógica para criar uma task aqui
                      },
                      icon: Icon(Icons.add),
                      label: Text('Criar Task'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300, // Altura fixa do Card
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Item 1'),
                          subtitle: const Text('Descrição do Item 1'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Adicione sua lógica de edição aqui
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Adicione sua lógica de exclusão aqui
                                },
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: const Text('Item 2'),
                          subtitle: const Text('Descrição do Item 2'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  // Adicione sua lógica de edição aqui
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  // Adicione sua lógica de exclusão aqui
                                },
                              ),
                            ],
                          ),
                        ),
                        // Adicione mais ListTiles conforme necessário
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
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
      ),
    );
  }
}
