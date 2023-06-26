import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(
    BuildContext context, {
    required String title,
    required String content,
    String okBtnText = "Ok",
    bool deleteDialog = false,
  }) {
    showDialog(
        context: context,
        builder: (_) {
          return (deleteDialog)? Center(child:Text("Ok")):AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              MaterialButton(
                child: Text(okBtnText),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
