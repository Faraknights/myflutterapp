import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/color.dart';
import '../widget/pop_up_name.dart';
import '../widget/list_inventory.dart';

class HomeRoute extends StatelessWidget {

  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ListInventoryState> key = GlobalKey();
    final dbHelper = DatabaseHelper.instance;
    final UtilColor utilColor = UtilColor();
    // reference to our single class that manages the database

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0,
      ),
      body: ListInventory(key: key),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? name = await showDialog<String>(
            context: context,
            builder: (BuildContext context) => const PopUpName(title: "Entrez le nom de l'inventaire", initialValue: "",),
          );
          if (name != null && name.isNotEmpty) {
            Map<String, dynamic> row = <String, dynamic> {
              DatabaseHelper.inventoryName: name
            };
            await dbHelper.insert(DatabaseHelper.tableInventory, row);
            key.currentState!.updateList();
          }
        },
        tooltip: 'Ajouter un inventaire',
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: utilColor.randomMaterialColor(),
        child: const Icon(Icons.add)
      ),
    );
  }
}