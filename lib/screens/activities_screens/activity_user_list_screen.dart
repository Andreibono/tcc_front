import 'package:flutter/material.dart';

import '../../components/app_bar_custom.dart';
import '../../models/activity.dart';
import '../../models/user.dart';
import '../../util/DialogUtils.dart';
import '../../util/app_routes.dart';

class ActivityUserList extends StatelessWidget {
  const ActivityUserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    List<Activity> activitiesList = user.activitiesList.reversed.toList();
    return Scaffold(
      appBar: AppBarCustom(title: "Listar Atividade do Usuário"),
      body: Container(
          padding: EdgeInsets.all(30),
          alignment: Alignment.topCenter,
          child: ListView.builder(
            itemCount: activitiesList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: activitiesList[index].status ? Color.fromARGB(255, 166, 235, 168): Color.fromARGB(255, 247, 223, 151),
                child: InkWell(
                  onTap: () {
                    user.open_activity = activitiesList[index].id;
                    activitiesList[index].status
                        ? DialogUtils.showCustomDialog(context,
                            title: "Erro",
                            content: "Atividade já foi encerrada!")
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
                        Text('Atividade: ${activitiesList[index].activity}'),
                        Text('Status: ${activitiesList[index].status}'),
                        Text(
                            'Horário de criação: ${activitiesList[index].start}')
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
