import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/app_bar_custom.dart';
import '/models/auth.dart';
import '/models/user.dart';

class AddUserToProject extends StatefulWidget {
  @override
  State<AddUserToProject> createState() => _AddUserToProjectState();
}

class _AddUserToProjectState extends State<AddUserToProject> {
  bool buttomCheck = false;
  String? projectSelected;
  int projectSelectedIndex = -1;

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

    List<String> userCompanies = [];
    for (int i = 0; i < user.company_list.length; i++) {
      userCompanies.add(user.company_list[i].company.fantasy);
    }

    final _formKey = GlobalKey<FormState>();

    Map<String, String> _authData = {
      'newUserId': '',
    };

    Future<void> submit() async {
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      var resposta = await auth.addUserProject(
          user.token.toString(),
          int.parse(_authData['newUserId']!),
          user.projectsList[projectSelectedIndex].project.id,
          user.projectsList[projectSelectedIndex].project.companyProj.id);
      print('resposta: $resposta');
      if (resposta == '') {
        //usuário adicionado com sucesso
        print('Usuário adicionado com Sucesso!');
      } else {
        //tratamento de erro ao adicionar usuário a uma empresa
        print(resposta);
      }
    }

    return Scaffold(
      appBar: AppBarCustom(),
      body: Container(
        padding: EdgeInsets.all(20),
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
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Id do Usuário',
                        labelStyle: TextStyle(color: Colors.lightBlue),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                    onSaved: (newUserId) =>
                        _authData['newUserId'] = newUserId ?? '',
                    validator: (_newUserId) {
                      final newUserId = _newUserId ?? '';
                      if (newUserId == '') {
                        return 'Informe um Id válido';
                      }
                      return null;
                    },
                  )),
              ElevatedButton(
                onPressed: submit,
                child: Text(
                  'Adicionar',
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 8)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
