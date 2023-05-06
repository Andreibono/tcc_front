import 'package:flutter/material.dart';

import '../../components/app_bar_custom.dart';
import '../../models/user.dart';
import '../../util/DialogUtils.dart';
import '../../util/app_routes.dart';

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
                child: InkWell(
                  onTap: () {
                    user.open_activity = user.activitiesList[index].id;
                    user.activitiesList[index].status
                        ? DialogUtils.showCustomDialog(context,
                          title: "Erro", content: "Atividade já foi encerrada!")
                        : Navigator.of(context).pushNamed(
                            AppRoutes.ACTIVITYREPORT,
                            arguments: user);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Usuário: ${user.name}"),
                        Text(
                            'Atividade: ${user.activitiesList[index].activity}'),
                        Text('Status: ${user.activitiesList[index].status}'),
                        Text(
                            'Horário de criação: ${user.activitiesList[index].start}')
                      ],
                    ),
                  ),
                ),
              );
            },
          )),
    );
  }
}
