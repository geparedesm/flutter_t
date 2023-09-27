import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginAnimation extends StatefulWidget {
  final void Function()? onAnimationStart;
  final void Function()? onAnimationEnd;

  const LoginAnimation({this.onAnimationStart, this.onAnimationEnd, Key? key})
      : super(key: key);

  @override
  LoginAnimationState createState() => LoginAnimationState();
}

class LoginAnimationState extends State<LoginAnimation> {
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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

  void setFail() {
    trigFail?.change(true);
  }

  Future<void> playAnimation() async {
    widget.onAnimationStart?.call();
    widget.onAnimationEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: RiveAnimation.asset(
        'assets/rive/login-teddy.riv',
        fit: BoxFit.fitHeight,
        stateMachines: const ["Login Machine"],
        onInit: (artboard) {
          controller =
              StateMachineController.fromArtboard(artboard, "Login Machine");
          if (controller == null) return;

          artboard.addController(controller!);
          isChecking = controller?.findInput("isChecking");
          numLook = controller?.findInput("numLook");
          isHandsUp = controller?.findInput("isHandsUp");
          trigSuccess = controller?.findInput("trigSuccess");
          trigFail = controller?.findInput("trigFail");
        },
      ),
    );
  }
}
