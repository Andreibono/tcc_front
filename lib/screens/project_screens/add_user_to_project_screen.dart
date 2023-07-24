import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/auth.dart';
import '/models/user.dart';
import '../../util/DialogUtils.dart';

class AddUserToProject extends StatefulWidget {
  final User user;
  final String projectId;

  const AddUserToProject(
      {Key? key, required this.user, required this.projectId})
      : super(key: key);

  @override
  State<AddUserToProject> createState() => _AddUserToProjectState();
}

class _AddUserToProjectState extends State<AddUserToProject> {
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Map<String, String> _authData = {
      'newUserEmail': '',
    };

    int index = widget.user.projectsList.indexWhere(
        (projectsList) => projectsList.project.id == widget.projectId);

    Future<void> submit() async {
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      var resposta = await auth.addUserProject(
          widget.user.token.toString(),
          _authData['newUserEmail']!,
          widget.projectId,
          widget.user.projectsList[index].project.companyProj.id);
      if (resposta == '') {
        //usuário adicionado com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso", content: "Usuário adicionado com Sucesso!");
      } else {
        //tratamento de erro ao adicionar usuário a uma empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    final avaibleHeight = MediaQuery.of(context).size.height;

    return Container(
      height: avaibleHeight * 0.30,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email do Usuário',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (newUserId) =>
                      _authData['newUserEmail'] = newUserId ?? '',
                  validator: (_newUserId) {
                    final newUserId = _newUserId ?? '';
                    if (newUserId == '') {
                      return 'Informe um Email válido!';
                    }
                    return null;
                  },
                )),
            ElevatedButton(
              onPressed: submit,
              child: const Text(
                'Adicionar',
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
            )
          ],
        ),
      ),
    );
  }
}
