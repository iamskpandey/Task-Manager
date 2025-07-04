import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/Pages/about.dart';
import 'package:todo_app/Pages/forgot_password.dart';
import 'package:todo_app/Pages/homepage.dart';
import 'package:todo_app/Pages/login_screen.dart';
import 'package:todo_app/Pages/register_screen.dart';
import 'package:todo_app/Pages/splash_screen.dart';
import 'package:todo_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Homepage();
          } else {
            return const SplashScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot': (context) => const ForgotPassword(),
        '/homepage': (context) => const Homepage(),
        '/splash': (context) => const SplashScreen(),
        '/about': (context) => const About(),
      },
    );
  }
}
