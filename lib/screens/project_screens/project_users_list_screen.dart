import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/app_bar_custom.dart';
import '/models/auth.dart';
import '/models/user.dart';

class ProjectUsersList extends StatefulWidget {
  ProjectUsersList({Key? key}) : super(key: key);

  @override
  State<ProjectUsersList> createState() => _ProjectUsersListState();
}

class _ProjectUsersListState extends State<ProjectUsersList> {
  bool buttomCheck = false;
  String? projectSelected;
  int projectSelectedIndex = -1;
  List<User> usersList = [];

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));

    final user = ModalRoute.of(context)!.settings.arguments as User;
    List<String> userProjects = [];
    for (int i = 0; i < user.projectsList.length; i++) {
      userProjects.add(user.projectsList[i].project.name);
    }

    final _formKey = GlobalKey<FormState>();

    Future<void> submit() async {
      usersList.clear();
      List<User> usersListresponse = [];
      usersListresponse.clear();
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      usersListresponse = await auth.projectUsersList(user.token.toString(),
          user.projectsList[projectSelectedIndex].project.id);

      if (usersListresponse.isNotEmpty) {
        print('Usuários listados com Sucesso!');
        setState(() {
          usersList = usersListresponse;
        });
      } else {
        //tratamento de erro ao listar usuários da empresa
      }
    }

    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        padding: EdgeInsets.all(30),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButton<String>(
                  value: projectSelected,
                  items: userProjects.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() {
                    projectSelected = value;
                    buttomCheck = true;
                    projectSelectedIndex =
                        userProjects.indexOf(projectSelected!);
                  }),
                ),
              ),
              Visibility(
                  visible: buttomCheck,
                  child: ElevatedButton(
                    onPressed: submit,
                    child: const Text(
                      'Listar',
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8)),
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              "Nome: ${usersList[index].name}, Id: ${usersList[index].id}, email: ${usersList[index].email}",
                              //style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
