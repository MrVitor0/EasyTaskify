import 'package:flutter/material.dart';
import 'package:frontend/screens/dashboard/home_screen.dart';
import 'package:frontend/utils/token_controller.dart';

class TaskifyNavbar extends StatelessWidget implements PreferredSizeWidget {
  const TaskifyNavbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(30),
      child: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 30,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen(),
              ),
            );
          },
        ),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(30);
}
