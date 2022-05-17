import 'package:flutter/material.dart';

class PopUpName extends StatefulWidget {
  final String title;
  final String initialValue;

  const PopUpName({Key? key, required this.title, required this.initialValue}) : super(key: key);

  @override
  PopUpNameState createState() => PopUpNameState();
}

class PopUpNameState extends State<PopUpName> {
  late TextEditingController controller;
  late bool error;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialValue);
    error = false;
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: controller,
            decoration: InputDecoration(
                labelText: 'Nom',
                errorText: error ? "Le nom ne doit pas être vide" : null),
            onChanged: (string) {
              if (string == "") {
                setState(() {
                  error = true;
                });
              } else {
                setState(() {
                  error = false;
                });
              }
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => {
            if (controller.text != "")
              {
                {Navigator.of(context).pop(controller.text)}
              }
            else
              {
                setState(() {
                  error = true;
                }),
              }
          },
          child: const Text(
            'Ok',
          ),
        ),
      ],
    );
  }
}
