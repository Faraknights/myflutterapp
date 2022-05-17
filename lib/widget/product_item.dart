import 'package:flutter/material.dart';
import 'package:myflutterapp/models/product.dart';

import '../database/database_helper.dart';
import '../utils/color.dart';
import 'pop_up_delete.dart';
import 'pop_up_name.dart';

class ProductItem extends  StatefulWidget {
  final Product product;
  final Function updateGrid;
  const ProductItem({Key? key, required this.product, required this.updateGrid}) : super(key: key);

  @override
  ProductItemState createState() => ProductItemState();
}

class ProductItemState extends State<ProductItem> {
  final dbHelper = DatabaseHelper.instance;

  Future<Product> _fetchProduct(int id) async {
    Product products = await dbHelper.queryProduct(id);
    return products;
  }

  void updateItem() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper.instance;
    final UtilColor utilColor = UtilColor();

    return FutureBuilder <Product>(
      future: _fetchProduct(widget.product.id),
      builder: (BuildContext context, AsyncSnapshot<Product> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
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
                  color: utilColor.randomMaterialColor(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.centerLeft, 
                        child:  Text(
                          snapshot.data!.name,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        )
                      ),
                      Expanded( child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: Align(
                          alignment: Alignment.topLeft, 
                          child: Text(
                            'Quantité: ${snapshot.data!.quantity}',
                            style: const TextStyle(
                            fontSize: 15,
                              fontWeight: FontWeight.w300
                            ),
                          )
                        )
                      )),
                      Row(
                        children: [
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                if(snapshot.data!.quantity == 1){
                                  final bool? boolean = await showDialog<bool>(
                                    context: context,
                                    builder: (BuildContext context) => const PopUpDelete(text: "Voulez-vous vraiment retirer ce produit de l'inventaire ?"),
                                  );
                                  if (boolean != null && boolean) {
                                    await dbHelper.deleteProduct(snapshot.data!.id);
                                    widget.updateGrid();
                                  }
                                } else {
                                  await dbHelper.decrementQuantity(snapshot.data!.id);
                                  updateItem();
                                }
                              }, 
                              icon: const Icon(Icons.remove)
                            ) 
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                await dbHelper.incrementQuantity(snapshot.data!.id);
                                updateItem();
                              }, 
                              icon: const Icon(Icons.add)
                            ) 
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () async {
                                final String? name = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => PopUpName(title: "Entrez le nom du produit", initialValue: snapshot.data!.name,),
                                );
                                if (name != null && name.isNotEmpty) {
                                  await dbHelper.updateProductName(snapshot.data!.id, name);
                                  updateItem();
                                }
                              },
                              icon: const Icon(Icons.edit)
                            ) 
                          ),
                        ],
                      )
                    ]),
                  )
                )
              ],
            )
          );
        }
      },
    );
  }
}
