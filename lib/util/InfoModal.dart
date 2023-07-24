import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/util/colors.dart';

import '../models/auth.dart';
import '../models/project.dart';
import '../models/user.dart';
import 'DialogUtils.dart';

class InfoModal extends StatelessWidget {
  User? user;
  User? modalUser;
  Project? project;
  String? companyId;
  String? companyRoleUser;
  InfoModal(
      {Key? key,
      this.user,
      this.modalUser,
      this.companyRoleUser,
      this.project,
      this.companyId})
      : super(key: key);

  String identifier(user) {
    String identifierType;
    project == null ? identifierType = "user" : identifierType = "project";
    return identifierType;
  }

  @override
  Widget build(BuildContext context) {
    String type = identifier(user);

    Future<void> submitDeleteUser() async {
      String response;
      Auth auth = Provider.of(context, listen: false);
      response = type == "user"
          ? await auth.deleteCompanyUsers(
              user!.email, companyId, user?.token)
          : await auth.deleteProjectUsers(
              user!.email, project?.id, user?.token);
      if (response == '') {
        DialogUtils.showCustomDialog(context,
            title: "Sucesso", content: "Usuário deletado com sucesso!");
      } else {
        DialogUtils.showCustomDialog(context, title: "Erro", content: response);
      }
    }

    bool managerCompanyCheck() {
      bool manager = false;

      if (modalUser?.id == user?.id) {
        manager = false;
        return manager;
      }

      if (type == 'user') {
        companyRoleUser == "1" ? manager = true : manager = false;
      } else {
        user?.id == project?.admin ? manager = true : manager = false;
      }

      return manager;
    }

    bool manager = managerCompanyCheck();
    final avaibleHeight = MediaQuery.of(context).size.height;
    final avaibleWidth = MediaQuery.of(context).size.width;
    return Container(
        height: avaibleHeight * 0.35,
        padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
        child: Column(children: [
          Row(children: [
            CircleAvatar(
              backgroundColor:
                  modalUser!.working == 'true' ? Colors.green : Colors.red,
              radius: 20,
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 18,
                child: Text(
                  modalUser!.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
                width: avaibleWidth / 1.42,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: UtilColors.borderColor, width: 3),
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(modalUser!.name),
                ))
          ]),
          const SizedBox(height: 15),
          Container(
              width: avaibleWidth / 1.42,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: UtilColors.borderColor, width: 3),
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: Text(modalUser!.email),
              )),
          const SizedBox(height: 15),
          Visibility(
            visible: manager,
            child: type == 'user'
                ? ElevatedButton(
                    onPressed: submitDeleteUser,
                    child: const Text(
                      'Excluir Usuário da Empresa',
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8)),
                  )
                : ElevatedButton(
                    onPressed: submitDeleteUser,
                    child: const Text(
                      'Excluir Usuário do Projeto',
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8)),
                  ),
          )
        ]));
  }
}
