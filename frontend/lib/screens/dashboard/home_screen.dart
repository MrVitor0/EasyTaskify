import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  printUrl() {
    SharedPreferences.getInstance().then((prefs) {
      debugPrint(prefs.getString('backend_url'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => false,
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          automaticallyImplyLeading:
              false, // Impede a inclusão automática do botão de voltar
        ),
        body: const Center(
          child: Text('Welcome to the Home Screen!'),
        ),
      ),
    );
  }
}
