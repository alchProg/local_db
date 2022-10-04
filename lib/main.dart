import 'package:flutter/material.dart';
import 'package:local_db/screens/profiles_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark(
        //scaffoldBackgroundColor: Colors.blueGrey,
        //primarySwatch: Color(),
      ),
      home: const ProfilesScreen(),
    );
  }
}

