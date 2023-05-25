import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Column (
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: 
                      BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.grey),
                    )
                  ],
                ),
              ),
              const Expanded(
                flex: 2,
                child:  Padding(
                  padding:  EdgeInsets.only(bottom: 10),
                  child:  Column (
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AuthForm()
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}
