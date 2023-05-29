import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/auth.dart';
import '../../models/user.dart';
import '../../util/DialogUtils.dart';

class NewActivityScreen extends StatefulWidget {
  final User user;
  const NewActivityScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<NewActivityScreen> createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends State<NewActivityScreen> {
  bool buttomCheck = false;
  String? projectSelected;
  int projectSelectedIndex = -1;
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));
    List<String> userProjects = [];
    for (int i = 0; i < widget.user.projectsList.length; i++) {
      userProjects.add(widget.user.projectsList[i].project.name);
    }

    Map<String, String> _authData = {
      'activityName': '',
      'description': '',
    };

    Future<void> submit() async {
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      var resposta = await auth.activitySingup(
          _authData['activityName']!,
          _authData['description']!,
          widget.user.token.toString(),
          widget.user.projectsList[projectSelectedIndex].project.id);
      print('resposta: $resposta');
      if (resposta == '') {
        //Atividade cadastrada com sucesso
        await auth.putWorking(widget.user.token);
        DialogUtils.showCustomDialog(context,
            title: "Sucesso", content: "Atividade Iniciada, Bom Trabalho!");
      } else {
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
        //tratamento de erro ao cadastrar uma nova atividade
      }
    }

    return Container(
      height: 300,
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                //for (int i = 0; i < user.company_list.length; i++)
                value: projectSelected,
                items: userProjects.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() {
                  projectSelected = value;
                  buttomCheck = true;
                  projectSelectedIndex = userProjects.indexOf(projectSelected!);
                }),
              ),
            ),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nome da Atividade',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (activityName) =>
                      _authData['activityName'] = activityName ?? '',
                  validator: (_activityName) {
                    final activityName = _activityName ?? '';
                    if (activityName == '') {
                      return 'Informe um nome para o projeto Válido';
                    }
                    return null;
                  },
                )),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Descrição da Atividade',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (description) =>
                      _authData['description'] = description ?? '',
                  validator: (_description) {
                    final description = _description ?? '';
                    if (description == '') {
                      return 'Informe uma descrição para a sua atividade';
                    }
                    return null;
                  },
                )),
            Visibility(
                visible: buttomCheck,
                child: ElevatedButton(
                  onPressed: submit,
                  child: Text(
                    'Salvar',
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8)),
                ))
          ],
        ),
      ),
    );
  }
}
