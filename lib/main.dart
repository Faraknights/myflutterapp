import 'package:flutter/material.dart';
import 'package:myflutterapp/widget/inventoryroute.dart';
import 'database_helper.dart';
import 'widget/listinventory.dart';
import 'widget/popup.dart';

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
        '/': (context) => const Home(),
        '/inventory': (context) => const InventoryRoute(),
      }
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    // reference to our single class that manages the database

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0,
      ),
      body: const ListInventory(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog<String>(
            context: context,
            builder: (BuildContext context) => const PopUp(title: "Entrez le nom de l'inventaire"),
          );
          if (name != null && name.isNotEmpty) {
            Map<String, dynamic> row = {DatabaseHelper.inventoryName: name};
            await dbHelper.insert(DatabaseHelper.tableInventory, row);
          }
        },
        tooltip: 'Ajouter un inventaire',
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add)
      ),
    );
  }
}