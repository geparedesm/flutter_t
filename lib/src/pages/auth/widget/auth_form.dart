import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_t/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_t/src/helpers/helpers.dart';
import 'package:flutter_t/src/pages/auth/reset_password.dart';
import 'package:flutter_t/src/pages/auth/signin.dart';

import 'package:rive/rive.dart';

class AuthForm extends StatefulWidget {
  final bool animation;
  final String buttonText;
  final String action;
  const AuthForm({
    Key? key,
    required this.buttonText,
    required this.action,
    this.animation = true,
  }) : super(key: key);

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final preferences = Preferences();
  bool _obscureText = true;
  String buttonText = "";
  bool _obscureTextConfirmPassword = true;
  //input rive

  bool isLoading = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  //rive controller and input
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;

  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  @override
  void initState() {
    emailFocusNode.addListener(emailFocus);
    passwordFocusNode.addListener(passwordFocus);
    buttonText = widget.buttonText;

    super.initState();
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(emailFocus);
    passwordFocusNode.removeListener(passwordFocus);
    super.dispose();
  }

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _backgroundWidget(size),
            _backNavigation(context),
            _loginFormWidget(size, context),
          ],
        ));
  }

  Widget _backNavigation(BuildContext context) {
    return widget.action != "login"
        ? Positioned(
            top: 50,
            left: 25,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                )),
          )
        : Container();
  }

  Widget _loginFormWidget(Size size, BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 380,
              ),
              child: Column(
                children: <Widget>[
                  widget.animation ? _animation() : const SizedBox(),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          _emailWidget(),
                          _passwordWidget(),
                          widget.action == "signin"
                              ? _passwordConfirmWidget()
                              : Container(),
                          _emailButtonWidget(),
                        ],
                      ),
                    ),
                  ),
                  widget.action == "signin"
                      ? Container()
                      : _resetPasswordWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.action == "signin" ? Container() : _separation(),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.action == "signin"
                      ? Container()
                      : _registerButtonWidget(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _separation() {
    return const Text('-------- Regístrate --------');
  }

  Widget _registerButtonWidget(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) => MaterialButton(
            onPressed: (!(context.read<AuthBloc>().state.isLoading))
                ? () {
                    Navigator.push(
                        context, navigationFadeIn(context, const SignInPage()));
                  }
                : null,
            shape: const CircleBorder(),
            disabledColor: Colors.grey,
            color: context.read<AuthBloc>().state.isLoading
                ? Colors.grey
                : const Color.fromRGBO(240, 184, 43, 1),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Image(
                image: AssetImage('assets/icons/correo.png'),
                height: 30.0,
              ),
            )));
  }

  Widget _passwordConfirmWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding:
              const EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 15),
          child: TextField(
              obscureText: _obscureTextConfirmPassword,
              decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock_outline,
                  ),
                  labelText: 'Confirmar contraseña',
                  errorText:
                      (context.read<AuthBloc>().state.confirmPasswordState
                          ? null
                          : 'Las contraseñas no coinciden'),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureTextConfirmPassword =
                            !_obscureTextConfirmPassword;
                      });
                    },
                    icon: Icon(_obscureTextConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility),
                  )),
              onChanged: (value) {
                context.read<AuthBloc>().add(OnConfirmPasswordChange(value));
              }),
        );
      },
    );
  }

  Widget _emailButtonWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return MaterialButton(
            color: (context.read<AuthBloc>().state.password.length > 1 &&
                    context.read<AuthBloc>().state.loginButtonState &&
                    !(context.read<AuthBloc>().state.isLoading))
                ? Theme.of(context).primaryColor
                : Colors.grey,
            disabledColor: Colors.grey,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 0.0,
            onPressed: (context.read<AuthBloc>().state.password.length > 1 &&
                    context.read<AuthBloc>().state.loginButtonState &&
                    !(context.read<AuthBloc>().state.isLoading))
                ? widget.action == "login"
                    ? () async {
                        emailFocusNode.unfocus();
                        passwordFocusNode.unfocus();
                        context.read<AuthBloc>().add(OnLoginRequestWithEmail());
                      }
                    : widget.action == "signin" &&
                            context
                                .read<AuthBloc>()
                                .state
                                .confirmPasswordState &&
                            context.read<AuthBloc>().state.emailState &&
                            context.read<AuthBloc>().state.passwordState &&
                            context
                                    .read<AuthBloc>()
                                    .state
                                    .confirmPassword
                                    .length >
                                1
                        ? () async {
                            context
                                .read<AuthBloc>()
                                .add(OnSignInRequestWithEmail());
                          }
                        : null
                : null,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 270,
              ),
              child: Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15.0),
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ));
      },
    );
  }

  Widget _resetPasswordWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextButton(
          onPressed: () {
            Navigator.push(
                context, navigationFadeIn(context, const ResetPasswordPage()));
          },
          child: const Text(
            '¿Olvido la contraseña?',
            style: TextStyle(color: Colors.black54),
          )),
    );
  }

  Widget _animation() {
    return SizedBox(
      height: 250,
      width: 250,
      child: BlocListener<AuthBloc, AuthState>(
        listener: (BuildContext context, state) {
          if (state.error != null) {
            trigFail?.change(true);
          }
        },
        child: RiveAnimation.asset(
          'assets/rive/login-teddy.riv',
          fit: BoxFit.fitHeight,
          stateMachines: const ["Login Machine"],
          onInit: (artBoard) {
            controller =
                StateMachineController.fromArtboard(artBoard, "Login Machine");
            if (controller == null) return;

            artBoard.addController(controller!);
            isChecking = controller?.findInput("isChecking");
            numLook = controller?.findInput("numLook");
            isHandsUp = controller?.findInput("isHandsUp");
            trigSuccess = controller?.findInput("trigSuccess");
            trigFail = controller?.findInput("trigFail");
          },
        ),
      ),
    );
  }

  Widget _emailWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
          child: TextField(
            focusNode: emailFocusNode,
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
              numLook?.change(value.length.toDouble());
              context.read<AuthBloc>().add(OnEmailChange(value));
            },
          ),
        );
      },
    );
  }

  Widget _passwordWidget() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Container(
          padding:
              const EdgeInsets.only(top: 10, right: 40, left: 40, bottom: 15),
          child: TextField(
              focusNode: passwordFocusNode,
              obscureText: _obscureText,
              decoration: InputDecoration(
                  icon: const Icon(
                    Icons.lock_outline,
                  ),
                  labelText: 'Contraseña',
                  errorText: (context.read<AuthBloc>().state.passwordState)
                      ? null
                      : 'Más de 6 caracteres por favor',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                  )),
              onChanged: (value) {
                context.read<AuthBloc>().add(OnPasswordChange(value));
              }),
        );
      },
    );
  }

  Widget _backgroundWidget(Size size) {
    const background = SizedBox(
      height: double.infinity,
      width: double.infinity,
    );

    return const Stack(
      children: <Widget>[
        background,
      ],
    );
  }
}
