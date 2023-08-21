import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/models/auth.dart';

import '../models/user.dart';
import 'DialogUtils.dart';

class DeleteModal extends StatelessWidget {
  User user;
  final String type;
  var project;
  var company;
  String tokenUser;
  DeleteModal(
      {Key? key,
      required this.type,
      required this.user,
      this.project,
      this.company,
      required this.tokenUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    void submit() async {
      
      Auth auth = Provider.of(context, listen: false);
      user = type == "project"
          ? await auth.deleteProject(project.id, tokenUser)
          : await auth.deleteCompany(company.id, tokenUser);
      if (user.error_message == '') {
        type == "project"
            ? DialogUtils.showCustomDialog(context,
                title: "Sucesso", content: "Projeto deletado com sucesso!")
            : DialogUtils.showCustomDialog(context,
                title: "Sucesso", content: "Empresa deletada com sucesso!");
      } else {
        DialogUtils.showCustomDialog(context, title: "Erro", content: user.error_message);
      }
    }

    ;
    void close() {
      Navigator.of(context).pop();
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 10, 0),
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          type == "project"
              ? Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    "Tem Certeza que deseja deletar o Projeto?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(
                  alignment: Alignment.bottomCenter,
                  child: const Text(
                    "Tem Certeza que Deseja Deletar a Empresa?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: submit,
                child: const Text(
                  'Sim',
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 8)),
              ),
              ElevatedButton(
                onPressed: close,
                child: const Text(
                  'Não',
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 8)),
              )
            ],
          )
        ],
      ),
    );
  }
}
