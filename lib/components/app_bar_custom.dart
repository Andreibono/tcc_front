import 'package:flutter/material.dart';

class AppBarCustom extends AppBar {
  AppBarCustom({title = '', onTapFunction, working = 'true', check = false})
      : super(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: working == 'true' ? Colors.green : Colors.red,
                radius: 20,
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 18,
                  child: Text(
                    title[0].toUpperCase(),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Visibility(
                visible: check,
                child: InkWell(
                  onTap: onTapFunction,
                  child: Container(
                    alignment: Alignment.center,
                    child: Icon(Icons.add),
                  ),
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
