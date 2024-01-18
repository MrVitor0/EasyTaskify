import 'package:flutter/material.dart';
import 'package:frontend/utils/tasks_controller.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/backend_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//taks
import 'screens/dashboard/tasks/update_screen.dart';
import 'screens/dashboard/tasks/create_screen.dart';
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

class AuthObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Intercepta a navegação e verifica a autenticação
    super.didPush(route, previousRoute);
    _checkAuthentication(route.settings.name);
  }

  void _checkAuthentication(String? routeName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? backendUrl = prefs.getString('backend_url');

    TokenManager tokenManager = TokenManager();
    bool isLoggedIn = await tokenManager.isUserLoggedIn();

    // Rotas protegidas que requerem autenticação
    List<String> protectedRoutes = ['/home', '/backend'];

    if (protectedRoutes.contains(routeName) && !isLoggedIn) {
      // Se o usuário não estiver autenticado, redireciona para a tela de login
      Navigator.pushReplacementNamed(
          navigatorKey.currentContext!, getMainRoute(backendUrl, isLoggedIn));
    }
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //clearSharedPreferences();
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
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      navigatorObservers: [AuthObserver()],
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/backend': (context) => BackendScreen(),
        //tasks
        '/tasks/create': (context) => CreateScreen(),
        '/tasks/update': (context) => UpdateScreen(
            taskData: ModalRoute.of(context)!.settings.arguments as Task),
      },
    );
  }
}
