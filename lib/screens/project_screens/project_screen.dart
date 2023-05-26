import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';

import '/models/user.dart';
import '/util/app_routes.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBarCustom(
        title:'Projetos' ,
        onTapFunction: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.NEWPROJECTSCREEN, arguments: user);
          }
      ),
      body: Column(children: [
        ListTile(
          title: Text(
            'Cadastrar um Novo Projeto',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.NEWPROJECTSCREEN, arguments: user);
          },
        ),
        ListTile(
          title: Text(
            'Adicionar Usuários a um novo Projeto',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.ADDUSERTOPROJECTSCREEN, arguments: user);
          },
        ),
        ListTile(
          title: Text(
            'Listar Usuários de um Projeto',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.PROJECTUSERSLIST, arguments: user);
          },
        ),
      ]),
    );
  }
}
