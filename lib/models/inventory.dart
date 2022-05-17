import 'package:flutter/material.dart';
import '../database/database_helper.dart';

@immutable
class Inventory {
  const Inventory ({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Inventory.fromJson(Map<String, Object?> json){
    return Inventory(
      id: json[DatabaseHelper.inventoryId] as int,
      name: json[DatabaseHelper.inventoryName] as String,
    );
  }

  Map<String, Object?> toJson(){
    return {
      DatabaseHelper.inventoryId: id,
      DatabaseHelper.inventoryName: name,
    };
  }
}