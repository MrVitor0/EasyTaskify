import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {

  print_url() {
    SharedPreferences.getInstance().then((prefs) {
      print(prefs.getString('backendUrl'));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: print_url,
          child: Text('Print URL'),
        ),

      ),
    );
  }
}
