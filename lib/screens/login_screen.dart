import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avaibleHeight = 
      MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    
    final avaibleWidth = 
      MediaQuery.of(context).size.width;

    return Scaffold(
      body: ListView(
        children: [
        Column(
          children: [
          Container(
            width: avaibleWidth,
            height: avaibleHeight * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container (
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: avaibleWidth,
            height: avaibleHeight * 0.7,
            child: Column (
              mainAxisAlignment: MainAxisAlignment.end, 
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: AuthForm(),
                )
            ]),
          ),
        ]),
      ]));
  }
}
