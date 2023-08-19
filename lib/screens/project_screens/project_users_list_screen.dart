import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/util/deleteModal.dart';

import '/components/app_bar_custom.dart';
import '/models/auth.dart';
import '/models/user.dart';
import '../../models/project.dart';
import '../../util/DialogUtils.dart';
import '../../util/InfoModal.dart';
import '../../util/app_routes.dart';
import '../../util/colors.dart';
import '../activities_screens/add_activity_screen.dart';
import 'add_user_to_project_screen.dart';

class ProjectUsersList extends StatefulWidget {
  ProjectUsersList({Key? key}) : super(key: key);

  @override
  State<ProjectUsersList> createState() => _ProjectUsersListState();
}

class _ProjectUsersListState extends State<ProjectUsersList> {
  bool loading = true;
  List<User> usersList = [];
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    User user = arguments['user'];
    Project project = arguments['project'];

    bool manager = (project.admin == user.id);

    final appBar = AppBarCustom(
      title: project.name,
      onTapFunction: () {
        manager == true
            ? showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Wrap(
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0))),
                        child: DeleteModal(
                          type: "project",
                          project: project,
                          tokenUser: user.token,
                        ),
                      )
                    ],
                  );
                })
            : {};
      },
      delete: manager,
      working: user.working,
    );

    List<String> userProjects = [];
    for (int i = 0; i < user.projectsList.length; i++) {
      userProjects.add(user.projectsList[i].project.name);
    }

    Future<void> submit() async {
      this.firstTime = false;
      List<User> usersListresponse = [];
      Auth auth = Provider.of(context, listen: false);
      usersListresponse =
          await auth.projectUsersList(user.token.toString(), project.id);

      if (usersListresponse.isNotEmpty) {
        setState(() {
          loading = false;
          usersList = usersListresponse;
        });
      } else {
        //tratamento de erro ao listar usuários do projeto
        setState(() {
          loading = false;
          Navigator.pop(context);
          DialogUtils.showCustomDialog(context,
              title: "Erro",
              content: 'Você não pertence a este projeto',
              nullpop: false);
        });
      }
    }

    void firstTime() {
      if (this.firstTime == true) {
        submit();
      }
    }

    firstTime();
    final avaibleWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBar,
      body: Container(
        padding: const EdgeInsets.fromLTRB(05, 10, 05, 05),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: UtilColors.buttonColor,
              child: ListTile(
                title: const Text(
                  'Adicionar Usuário ao Projeto',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddUserToProject(
                              user: user, projectId: project.id));
                    },
                  );
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: UtilColors.buttonColor,
              child: ListTile(
                title: const Text(
                  'Iniciar Uma Atividade ao Projeto',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: NewActivityScreen(
                            user: user,
                            projectId: project.id,
                          ));
                    },
                  );
                },
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              color: UtilColors.buttonColor,
              child: ListTile(
                title: const Text(
                  'Listar Atividades Relacionadas e este Projeto',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      AppRoutes.ACTIVITYPROJECTREPORTSCREEN,
                      arguments: {'user': user, 'project': project});
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            loading == true
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    width: avaibleWidth / 1.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border.all(color: UtilColors.borderColor, width: 3),
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(project.description),
                    )),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10);
                },
                itemCount: usersList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: InfoModal(
                                user: user,
                                modalUser: usersList[index],
                                project: project,
                              ));
                        },
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Nome: ${usersList[index].name}\n\n"
                              "email: ${usersList[index].email}",
                              //style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
