import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_t/src/helpers/helpers.dart';

class FirebaseServicesAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> createAccount(String email, String password) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    user!.sendEmailVerification();
    return user;
  }

  resetPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        Navigator.of(context).pop();
        showSnackBar(context,
            'Se ha enviado un correo electrónico para restablecer la contraseña. Si no encuentra el correo, revise su bandeja de spam');
      });
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showSnackBar(context, e.message.toString());
      return null;
    }
  }

  Future signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
