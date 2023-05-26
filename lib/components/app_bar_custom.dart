import 'package:flutter/material.dart';

class AppBarCustom extends AppBar {
  AppBarCustom({title = '', onTapFunction})
      : super(
          title: Text(title),
          actions: [
             Padding(
               padding: const EdgeInsets.only(right: 15),
               child: InkWell(
                  onTap: onTapFunction,
                  child: Container(
                    alignment: Alignment.center,
                    
                    child: Icon(Icons.add),
                  ),
                ),
             ),
          ],
          leading: Builder(builder: (context) {
            return Visibility(
                visible: Navigator.of(context).canPop(),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 15),
                        child: const Icon(Icons.arrow_back_ios_new),
                      ),
                    ),
                  ],
                ));
          }),
        );
}
