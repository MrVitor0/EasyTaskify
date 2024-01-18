import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/backend_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/token_controller.dart';

void clearSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

String getMainRoute(String? backendUrl, bool isLoggedIn) {
  if (backendUrl != null && backendUrl.startsWith("http") && isLoggedIn) {
    return '/home';
  } else if (!(backendUrl != null && backendUrl.startsWith("http"))) {
    return '/backend';
  } else {
    return '/login';
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // clearSharedPreferences();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  TokenManager tokenManager = TokenManager();
  bool isLoggedIn = await tokenManager.isUserLoggedIn();
  String? backendUrl = prefs.getString('backend_url');

  runApp(MyApp(initialRoute: getMainRoute(backendUrl, isLoggedIn)));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({Key? key, required this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/backend': (context) => BackendScreen(),
      },
    );
  }
}
