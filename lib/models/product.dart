import 'package:flutter/material.dart';
import '../database/database_helper.dart';

@immutable
class Product {
  const Product ({
    required this.id,
    required this.name,
    required this.quantity,
    required this.idInventory
  });

  final int id;
  final String name;
  final int quantity;
  final int idInventory;

  factory Product.fromJson(Map<String, Object?> json){
    return Product(
      id: json[DatabaseHelper.productId] as int,
      name: json[DatabaseHelper.productName] as String,
      quantity: json[DatabaseHelper.productQuantity] as int,
      idInventory: json[DatabaseHelper.productInventoryExtKey] as int,
    );
  }

  Map<String, Object?> toJson(){
    return {
      DatabaseHelper.productId: id,
      DatabaseHelper.productName: name,
      DatabaseHelper.productQuantity: quantity,
      DatabaseHelper.productInventoryExtKey: idInventory,
    };
  }
}