import 'package:flutter/material.dart';

class AppBarCustom extends AppBar {
  AppBarCustom()
      : super(
          //leadingWidth: 200,
          leading: Builder(builder: (context) {
            return Visibility(
                visible: Navigator.of(context).canPop(),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                    child: Row(
                      children: const [Icon(Icons.arrow_back_ios_new)],
                    ),
                  ),
                ));
          }),
        );
}
