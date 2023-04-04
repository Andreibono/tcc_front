import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/app_bar_custom.dart';
import '../models/auth.dart';
import '../models/list_users.dart';
import '../models/user.dart';

class CompanyUsersList extends StatefulWidget {
  CompanyUsersList({Key? key}) : super(key: key);

  @override
  State<CompanyUsersList> createState() => _CompanyUsersListState();
}

class _CompanyUsersListState extends State<CompanyUsersList> {
  bool buttomCheck = false;
  String? companySelected;
  int companySelectedIndex = -1;
  List<UserList> usersList = [];

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));

    final user = ModalRoute.of(context)!.settings.arguments as User;
    List<String> userCompanies = [];
    for (int i = 0; i < user.company_list.length; i++) {
      userCompanies.add(user.company_list[i].company.fantasy);
    }

    final _formKey = GlobalKey<FormState>();

    Future<void> submit() async {
      usersList.clear();
      List<UserList> usersListresponse = [];
      usersListresponse.clear();
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      usersListresponse = await auth.companyUsersList(user.token.toString(),
          user.company_list[companySelectedIndex].company.id);

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
                  value: companySelected,
                  items: userCompanies.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() {
                    companySelected = value;
                    buttomCheck = true;
                    companySelectedIndex =
                        userCompanies.indexOf(companySelected!);
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
                              "Nome: ${usersList[index].user.name}, Id: ${usersList[index].user.id}, Role: ${usersList[index].role}",
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
