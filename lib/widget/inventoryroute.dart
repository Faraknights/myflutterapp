import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../database_helper.dart';
import './popup.dart';

class InventoryRoute extends StatefulWidget {
  const InventoryRoute({Key? key}) : super(key: key);

  @override
  InventoryRouteState createState() => InventoryRouteState();
}

class InventoryRouteState extends State<InventoryRoute> {
  late List<Map<String, dynamic>> products;
  late String name;

  _fetchData(id) async {
    final dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> productsRaw = await dbHelper.queryAllProducts(id);
    List<Map<String, dynamic>> tmpName = await dbHelper.queryInventory(id);
    setState(() {
      name = tmpName[0][DatabaseHelper.inventoryName];
      products = [];
      for (var element in productsRaw) {
        products.add(element);
      }
    });
    return products;
  }

  @override
  void initState() {
    super.initState();
    name = "";
    products = [];
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final dbHelper = DatabaseHelper.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 250, 250, 250),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 92, 92, 92)
        ),
      ),
      body: FutureBuilder(
        future: _fetchData(arguments['id']),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(children: [
            Text(name, style: const TextStyle(fontSize: 40)),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 20
                ),
                itemCount: products.length,
                itemBuilder: (BuildContext context, index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration:
                      BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3)
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 3,
                          color: Colors.amber,
                        ), 
                        Align(
                          alignment: Alignment.centerLeft, 
                          child: Text(products[index][DatabaseHelper.productName])
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topLeft, 
                            child: Text('Quantité: ${products[index][DatabaseHelper.productQuantity]}')
                          )
                        ),
                        Row(
                          children: const [
                            Expanded(child: Icon(Icons.remove)),
                            Expanded(child: Icon(Icons.add)),
                            Expanded(child: Icon(Icons.edit)),
                          ],
                        )
                      ],
                    )
                  );
                }
              )
            )
          ]);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final name = await showDialog(
            context: context,
            builder: (BuildContext context) => const PopUp(title: "Entrez le nom du produit"),
          );
          if (name != null && name != "") {
            Map<String, dynamic> row = {
              DatabaseHelper.productName: name,
              DatabaseHelper.productQuantity: 0,
              DatabaseHelper.productInventoryExtKey: arguments['id']
            };
            await dbHelper.insert(DatabaseHelper.tableProduct, row);
          }
        },
        tooltip: 'Ajouter un inventaire',
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
        child: const Icon(Icons.add)
      )
    );
  }
}
