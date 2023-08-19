

import 'package:flutter/material.dart';

class DialogUtils {
  static DialogUtils _instance = new DialogUtils.internal();

  DialogUtils.internal();

  factory DialogUtils() => _instance;

  static void showCustomDialog(BuildContext context,
      {required String title,
      required String content,
      String okBtnText = "Ok",
      bool deleteDialog = false,
      bool nullpop = true}) {
    showDialog(
        context: context,
        builder: (_) {
          return (deleteDialog)
              ? const Center(child: Text("Ok"))
              : AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: <Widget>[
                    MaterialButton(
                      child: Text(okBtnText),
                      onPressed: nullpop
                          ? () {
                              Navigator.of(context).pop();
                            }
                          : () {
                            
                          },
                    ),
                  ],
                );
        });
  }
}
