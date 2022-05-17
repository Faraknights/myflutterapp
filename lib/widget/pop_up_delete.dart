import 'package:flutter/material.dart';

class PopUpDelete extends StatelessWidget {
  final String text;

  const PopUpDelete({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(context) {
    return  AlertDialog(
      title: const Text("Suppression"),
      content: Text(text),
      actions: [
        TextButton(
          child: const Text("Annuler"),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(true),
        )
      ],
    );
  }
  
  void updateItem() {}
}
