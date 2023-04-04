import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView(children: [
        Column(children: [
          Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.fromLTRB(0, 80, 0, 200),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100), color: Colors.grey),
          ),
          Column(
            children: [
              AuthForm(),
            ],
          )
        ]),
      ]),
    ));
  }
}
