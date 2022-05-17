import 'package:flutter/material.dart';
import 'package:myflutterapp/models/inventory.dart';
import '../database/database_helper.dart';
import 'pop_up_delete.dart';
import 'pop_up_name.dart';

class HeaderInventory extends StatefulWidget {
  final int id;
  final Color color;
  final Function updateList;

  const HeaderInventory({
    Key? key, 
    required this.id, 
    required this.color,
    required this.updateList,
  }) : super(key: key);

  @override
  HeaderInventoryState createState() => HeaderInventoryState();
}

class HeaderInventoryState extends State<HeaderInventory> {
  final dbHelper = DatabaseHelper.instance;

  Future<Inventory> _fetchInventory(int id) async {
    Inventory inventory = await dbHelper.queryInventory(id);
    return inventory;
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(context) {
    return FutureBuilder <Inventory>(
      future: _fetchInventory(widget.id),
      builder: (BuildContext context, AsyncSnapshot<Inventory> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else { 
          return Column(
            children: [
              Text(
                snapshot.data!.name,
                style: const TextStyle(fontSize: 40)
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ink(
                    decoration: ShapeDecoration(
                      color: widget.color,
                      shape: const CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () async {
                        final String? name = await showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => PopUpName(title: "Entrez le nom du produit", initialValue: snapshot.data!.name),
                        );
                        if (name != null && name.isNotEmpty) {
                          await dbHelper.updateInventoryName(widget.id, name);
                          update();
                        }
                      },
                    ),
                  ),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Color.fromARGB(255, 255, 57, 54),
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      onPressed: () async {
                        final bool? boolean = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) => const PopUpDelete(text: "Entrez le nom du produit"),
                        );
                        if (boolean != null && boolean) {
                          await dbHelper.deleteInventory(widget.id);
                          widget.updateList();
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          );
        }
      }
    );
  }
}