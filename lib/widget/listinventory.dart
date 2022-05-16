import 'package:flutter/material.dart';
import '../database_helper.dart';
import './inventoryroute.dart';

class ListInventory extends StatefulWidget {
  const ListInventory({Key? key}) : super(key: key);

  @override
  ListInventoryState createState() => ListInventoryState();
}

class ListInventoryState extends State<ListInventory> {
  late List<Map<String, dynamic>> inventories;

  _fetchListItems() async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> inventoriesRaw =
        await dbHelper.queryAllInventory();
    setState(() {
      inventories = [];
      for (var element in inventoriesRaw) {
        inventories.add(element);
      }
    });
    return inventories;
  }

  @override
  void initState() {
    super.initState();

    inventories = [];
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: _fetchListItems(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Text("Aucun inventaire enregistré");
        } else {
          return Column(children: [
            const Text("Stock", style: TextStyle(fontSize: 40)),
            Expanded(
                child: ListView.builder(
                    itemCount: inventories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              //
                              context,
                              '/inventory',
                              arguments: {
                                'id': inventories[index] [DatabaseHelper.inventoryId],
                              }
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3))
                            ]),
                            child: Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 70,
                                  color: Colors.amber[600],
                                  margin: const EdgeInsets.only(right: 10.0),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10.0),
                                  child: Text('#${index + 1}',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w200)),
                                ),
                                Expanded(
                                    child: Text(
                                        '${inventories[index][DatabaseHelper.inventoryName]}',
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w200))),
                                Container(
                                  margin: const EdgeInsets.only(right: 15.0),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Color.fromARGB(255, 94, 94, 94),
                                  ),
                                ),
                              ],
                            ),
                          ));
                    }))
          ]);
        }
      },
    );
  }
}
