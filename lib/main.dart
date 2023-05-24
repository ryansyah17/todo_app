import 'package:flutter/material.dart';
import 'package:todo_app/screen/splash_screen.dart';
// import 'package:todo_app/screen/todo_home.dart';

void main() {
  runApp(const MyApps());
}

class MyApps extends StatelessWidget {
  const MyApps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData.dark());
  }
}
