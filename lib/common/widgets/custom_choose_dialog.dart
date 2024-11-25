import 'package:flutter/material.dart';

Future<int> CustomChooseDialog({
  required BuildContext context,
  required String message,
  required String progressButton,
  required String cancelMessage,
}) async {
  return await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmação"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(0);
                },
                child: Text(cancelMessage),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(1);
                },
                child: Text(progressButton),
              ),
            ],
          );
        },
      ) ??
      0;
}
