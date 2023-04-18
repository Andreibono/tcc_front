import 'package:flutter/material.dart';

import '../../components/app_bar_custom.dart';
import '../../models/user.dart';

class ActivityUserList extends StatelessWidget {
  const ActivityUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
          padding: EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          child: ListView.builder(
            itemCount: user.activitiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Usuário: ${user.name}"),
                      Text('Atividade: ${user.activitiesList[index].activity}'),
                      Text('Status: ${user.activitiesList[index].status}')
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
