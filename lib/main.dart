import 'package:flutter/material.dart';
import 'package:myflutterapp/routes/inventory.dart';
import 'package:myflutterapp/routes/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // reference to our single class that manages the database

    return MaterialApp(
      title: 'Named Routes Demo', 
      initialRoute: '/', 
      routes: { 
        '/': (context) => const HomeRoute(),
        '/inventory': (context) => const InventoryRoute(),
      }
    );
  }
}