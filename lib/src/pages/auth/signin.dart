import 'package:flutter/material.dart';
import 'package:flutter_t/src/pages/auth/widget/auth_form.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String buttonText2 = "Registrarse";
  @override
  Widget build(BuildContext context) {
    return AuthForm(animation: true, buttonText: buttonText2, action: "signin");
  }
}
