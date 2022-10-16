import 'package:flutter/material.dart';
import 'package:local_db/screens/profile/profiles_screen.dart';
import 'package:local_db/screens/saved_price_lists/price_lists_screen.dart';

import 'home_page.dart';

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/profiles': (context) => const ProfilesScreen(),
        '/priceLists': (context) => const PriceListsSreen(),
      },
    );
  }
}
