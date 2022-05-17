import 'package:flutter/material.dart';
import 'package:myflutterapp/models/product.dart';
import 'package:myflutterapp/widget/product_item.dart';
import '../database/database_helper.dart';

class GridProduct extends StatefulWidget {
  final int id;

  const GridProduct({
    Key? key, 
    required this.id,
  }) : super(key: key);

  @override
  GridProductState createState() => GridProductState();
}

class GridProductState extends State<GridProduct> {
  final dbHelper = DatabaseHelper.instance;

  Future<List<Product>> _fetchProducts(int id) async {
    List<Product> products = await dbHelper.queryAllProducts(id);
    return products;
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(context) {
    return FutureBuilder <List<Product>>(
      future: _fetchProducts(widget.id),
      builder: (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, index) {
                return ProductItem(
                  product: snapshot.data![index],
                  updateGrid: update,
                );
              }
            )
          );
        }
      }
    );
  }
}