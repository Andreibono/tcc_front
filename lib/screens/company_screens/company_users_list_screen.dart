import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/components/app_bar_custom.dart';
import '/models/auth.dart';
import '/models/list_users.dart';
import '/models/user.dart';
import '../../util/DialogUtils.dart';

class CompanyUsersList extends StatefulWidget {
  CompanyUsersList({Key? key}) : super(key: key);

  @override
  State<CompanyUsersList> createState() => _CompanyUsersListState();
}

class _CompanyUsersListState extends State<CompanyUsersList> {
  List<UserList> usersList = [];
  bool firstTime = true;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    int index = user.company_list.indexWhere(
        (company_list) => company_list.company.id == user.open_activity);

    final appBar = AppBarCustom(
      title: user.company_list[index].company.fantasy,
      check: false,
      onTapFunction: () {},
      working: user.working,
    );

    Future<void> submit() async {
      firstTime = false;
      usersList.clear();
      List<UserList> usersListresponse = [];
      usersListresponse.clear();
      Auth auth = Provider.of(context, listen: false);

      usersListresponse = await auth.companyUsersList(
          user.token.toString(), user.company_list[index].company.id);

      if (usersListresponse.isNotEmpty) {
        //Usuários listados com Sucesso
        setState(() {
          _isLoading = false;
          usersList = usersListresponse;
        });
      } else {
        //tratamento de erro ao listar usuários da empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: "");
      }
    }

    setUserList() async {
      if (firstTime) {
        await submit();
      }
      ;
    }

    if (firstTime) {
      setUserList();
    }

    return Scaffold(
      appBar: appBar,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(30),
              alignment: Alignment.topCenter,
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
            ),
    );
  }
}
