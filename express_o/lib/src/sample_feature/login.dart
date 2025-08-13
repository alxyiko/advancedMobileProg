import 'package:flutter/material.dart';
import '../settings/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController;
  const LoginView({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authController.login();
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
