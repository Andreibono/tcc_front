import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
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
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column (
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
        ),
      )
    );
  }
}
