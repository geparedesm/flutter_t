import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_t/src/blocs/auth/auth_bloc.dart';
import 'package:flutter_t/src/pages/auth/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: MultiBlocProvider(
              providers: [
            BlocProvider(
              create: (context) => AuthBloc(),
            ),
          ],
              child: MaterialApp(
                title: 'GP Security App',
                debugShowCheckedModeBanner: false,
                home: const Login(),
                initialRoute: '/login',
                routes: {
                  // '/test': (BuildContext context) => const TestPage(),
                  '/login': (BuildContext context) => const Login(),
                },
                theme: ThemeData(
                    colorScheme: const ColorScheme(
                        primary: Color(0xff87D1E6),
                        secondary: Colors.blue,
                        surface: Colors.black,
                        background: Colors.green,
                        error: Colors.red,
                        onPrimary: Colors.black,
                        onSecondary: Colors.white,
                        onSurface: Colors.cyanAccent,
                        onBackground: Colors.red,
                        onError: Colors.red,
                        brightness: Brightness.light)),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
