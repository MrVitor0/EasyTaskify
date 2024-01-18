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
    return Scaffold(
      appBar: AppBar(
        title: const Text('HOMEPAGE'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: printUrl,
          child: const Text('Print Pindas'),
        ),
      ),
    );
  }
}
