import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';
import 'package:tcc_front/screens/activities_screens/activity_report_screen.dart';
import 'package:tcc_front/util/colors.dart';

import '/models/user.dart';
import '../../models/activity.dart';
import '../../util/DialogUtils.dart';
import 'add_activity_screen.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    var check = user.activitiesList.isEmpty ? false : true;
    List<Activity> activitiesList = user.activitiesList.reversed.toList();

    return Scaffold(
      appBar: AppBarCustom(
          title: 'Atividades',
          check: true,
          onTapFunction: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: NewActivityScreen(
                      user: user,
                    ));
              },
            );
          }),
      body: ListView.builder(
        itemCount: activitiesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: activitiesList[index].status
                ? UtilColors.closedActivity
                : UtilColors.openActivity,
            child: InkWell(
              onTap: () {
                user.open_activity = activitiesList[index].id;
                 showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: ActivityReportScreen(
                                user: user,
                                activity: activitiesList[index],
                              ));
                        },
                      );
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Usuário: ${user.name}"),
                    Text('Atividade: ${activitiesList[index].activity}'),
                    Text('Status: ${activitiesList[index].status}'),
                    Text('Horário de criação: ${activitiesList[index].start}')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
