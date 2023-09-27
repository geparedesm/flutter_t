import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_t/src/services/firebase/firebase_auth.dart';
import 'package:flutter_t/src/widgets/custom_appbar_widget.dart';

final firebaseServices = FirebaseServicesAuth();

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBarWidget(),
        body: Stack(
          children: [
            _formResetPassword(context),
          ],
        ));
  }

  Widget _formResetPassword(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 380,
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _createEmail(),
                  const SizedBox(
                    height: 20,
                  ),
                  _createButton(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _createButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool activator = false;
        if (context.read<AuthBloc>().state.email.length > 1 &&
            context.read<AuthBloc>().state.emailState) {
          activator = true;
        }
        return MaterialButton(
            color: (activator) ? Theme.of(context).primaryColor : Colors.grey,
            shape: const StadiumBorder(),
            elevation: 0.0,
            onPressed: (activator) ? _resetPassword : () {},
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 270,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: const Center(
                  child: Text(
                    'Recuperar Contraseña',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ));
      },
    );
  }

  _resetPassword() async {
    await firebaseServices.resetPassword(
        context, context.read<AuthBloc>().state.email);
  }

  Widget _createEmail() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.alternate_email,
                ),
                hintText: 'ejemplo@correo.com',
                labelText: 'Correos electrónico',
                errorText: (context.read<AuthBloc>().state.emailState)
                    ? null
                    : 'Correo electrónico invalido'),
            onChanged: (value) {
              context.read<AuthBloc>().add(OnEmailChange(value));
            },
          ),
        );
      },
    );
  }
}
