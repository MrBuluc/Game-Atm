import 'package:flutter/material.dart';

import 'ui/Home_Page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Atm',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
          primaryColor: Colors.green,
          textTheme: TextTheme(headline1: TextStyle(color: Colors.blue))),
      home: HomePage(),
    );
  }
}
