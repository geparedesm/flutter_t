import 'package:flutter/material.dart';
import 'package:flutter_t/src/pages/auth/widget/auth_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String buttonText2 = "Iniciar Sesión";
  @override
  Widget build(BuildContext context) {
    return AuthForm(
      animation: true,
      buttonText: buttonText2,
      action:"login"
    );
  }
}
