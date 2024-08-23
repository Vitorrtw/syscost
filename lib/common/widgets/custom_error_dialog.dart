import 'package:flutter/material.dart';

void showCustomErrorDialog(BuildContext context, String errorMessage) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Erro',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(errorMessage),
              const SizedBox(height: 15),
              ElevatedButton(
                child: const Text('Fechar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
