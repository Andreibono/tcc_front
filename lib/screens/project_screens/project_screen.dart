import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';
import 'package:tcc_front/models/project.dart';
import 'package:tcc_front/screens/project_screens/new_project_screen.dart';

import '/models/user.dart';
import '/util/app_routes.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    bool isFistTime = true;

    List<ProjectInfo> projects = user.projectsList;

    void setList(User user) {
      if (isFistTime) {
        projects = user.projectsList;
      }
    }

    final appBar = AppBarCustom(
      title: "Projetos",
      check: true,
      onTapFunction: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: NewProjectScreen(
                  user: user,
                ));
          },
        );
      },
      working: user.working,
    );

    final avaibleHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;

    final avaibleWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      body: Column(children: [
        /* ListTile(
          title: Text(
            'Cadastrar um Novo Projeto',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.NEWPROJECTSCREEN, arguments: user);
          },
        ),*/
        Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          width: avaibleWidth,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.blueAccent.shade100,
            child: ListTile(
              title: Text(
                'Adicionar Usuários a um novo Projeto',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushNamed(
                    AppRoutes.ADDUSERTOPROJECTSCREEN,
                    arguments: user);
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: Colors.blueAccent.shade100,
            child: ListTile(
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
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: const Text(
            "Meus Projetos",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        Container(
            height: avaibleHeight * 0.70,
            width: avaibleWidth,
            child: projects.isNotEmpty
                ? ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index].project;
                      return Card(
                        child: InkWell(
                          child: ListTile(
                              tileColor: index % 2 == 0
                                  ? const Color.fromRGBO(65, 70, 77, 0.8)
                                  : const Color.fromRGBO(28, 32, 38, 1),
                              leading: CircleAvatar(
                                backgroundColor: index % 2 == 0
                                    ? const Color.fromARGB(255, 221, 223, 201)
                                    : const Color.fromARGB(255, 138, 167, 128),
                                radius: 30,
                                child: Text(
                                  project.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(
                                project.name,
                                style: const TextStyle(color: Colors.white),
                              )),
                          onTap: () {
                            //ir para a página dos projetos
                          },
                        ),
                      );
                    },
                  )
                : const SizedBox()),
      ]),
    );
  }
}
