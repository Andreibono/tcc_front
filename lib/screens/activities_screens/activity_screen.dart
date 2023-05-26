import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';

import '/models/user.dart';
import '/util/app_routes.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    var check = user.activitiesList.isEmpty ? false : true;
    
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Atividades',
        onTapFunction: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.ADDACTIVITYSCREEN, arguments: user);
          }
      ),
      body: Column(children: [
        Visibility(
          visible: check,
          child: ListTile(
            title: Text(
              'Listar Atividades do Usuário',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pop(context);
        
              Navigator.of(context)
                  .pushNamed(AppRoutes.ACTIVITYUSERLIST, arguments: user);
            },
          ),
        ),
        ListTile(
          title: Text(
            'Cadastrar uma nova Atividade',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.ADDACTIVITYSCREEN, arguments: user);
          },
        ),
      ]),
    );
  }
}
