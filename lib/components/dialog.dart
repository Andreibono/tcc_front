import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AlertDialogCustom extends StatelessWidget {
  final String text;
  const AlertDialogCustom({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => AlertDialog
(
      content: Text(text),
      actions: [
        MaterialButton(onPressed: () {},
        child: Text('Ok')),
      ],
    );
  }
