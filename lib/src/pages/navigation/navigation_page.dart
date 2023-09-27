import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t/src/blocs/navigation/navigation_bloc.dart';
import 'package:flutter_t/src/helpers/helpers.dart';
import 'package:restart_app/restart_app.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NavigationBloc, NavigationState>(
        listener: (context, state) {
          if (state.route != "" && state.routeType != null) {
            switch (state.routeType) {
              case "pushNamed":
                Navigator.pushNamed(context, state.route);
                break;
              case "pushReplacementNamed":
                Navigator.pushReplacementNamed(context, state.route);
                break;
              default:
            }
          }
          if (state.message != null && state.messageType != null) {
            switch (state.messageType) {
              case "success":
                showSnackBar(context, state.message.toString());
                break;
              case "error":
                showSnackBar(context, state.message.toString());
                break;
              default:
            }
          }
        },
        child: Center(
          child: MaterialButton(
              child: const Text("Restart"),
              onPressed: () {
                Restart.restartApp();
              }),
        ),
      ),
    );
  }
}
