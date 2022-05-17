import 'package:flutter/material.dart';
import 'package:myflutterapp/utils/color.dart';
import '../widget/inventory_header.dart';
import '../widget/grid_product.dart';
import '../database/database_helper.dart';
import '../widget/pop_up_name.dart';

class InventoryRoute extends StatelessWidget {
  const InventoryRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final GlobalKey<GridProductState> key = GlobalKey();
    final dbHelper = DatabaseHelper.instance;
    final UtilColor utilColor = UtilColor();
    final Color mainColor = utilColor.randomMaterialColor();

    return WillPopScope(
      onWillPop: () async {
        await arguments['update']();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 250, 250),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 92, 92, 92)
          ),
        ),
        body: Column(
          children: [
            HeaderInventory(
              updateList: arguments['update'] as Function,
              color: mainColor,
              id: arguments['id'] as int,
            ),
            GridProduct(
              key: key,
              id: arguments['id'] as int,
            )
          ],
        ) ,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String? name = await showDialog<String>(
              context: context,
              builder: (BuildContext context) => const PopUpName(title: "Entrez le nom du produit", initialValue: "",),
            );
            if (name != null && name.isNotEmpty) {
              Map<String, dynamic> row = <String, dynamic> {
                DatabaseHelper.productName: name,
                DatabaseHelper.productQuantity: 1,
                DatabaseHelper.productInventoryExtKey: arguments['id']
              };
              await dbHelper.insert(DatabaseHelper.tableProduct, row);
              key.currentState!.update();
            }
          },
          tooltip: 'Ajouter un inventaire',
          backgroundColor: mainColor,
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.zero),
          child: const Icon(Icons.add)
        )
      ),
    );
     
  }
}
