import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/auth.dart';
import '/models/user.dart';
import '../../util/DialogUtils.dart';

class NewProjectScreen extends StatefulWidget {
  User user;
  NewProjectScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  bool buttomCheck = false;
  String? companySelected;
  int companySelectedIndex = -1;
  static final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ));

    List<String> userCompanies = [];
    for (int i = 0; i < widget.user.company_list.length; i++) {
      userCompanies.add(widget.user.company_list[i].company.fantasy);
    }

    Map<String, String> _authData = {
      'projectName': '',
      'description': '',
    };

    Future<void> submit() async {
      setState(() {
        isLoading = true;
      });
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        setState(() {
          isLoading = false;
        });
        return;
      }
      _formKey.currentState?.save();
      widget.user = await auth.projectSingup(
          _authData['projectName']!,
          _authData['description']!,
          widget.user.token.toString(),
          widget.user.company_list[companySelectedIndex].company.id);
      if (widget.user.error_message == '') {
        //projeto cadastrado com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso!", content: 'Projeto Cadastrado com Sucesso!');
      } else {
        //tratamento de erro ao cadastrar projeto
        DialogUtils.showCustomDialog(context,
            title: "Erro", content: widget.user.error_message);
      }
      setState(() {
        isLoading = false;
      });
    }

    final avaibleWidth = MediaQuery.of(context).size.width;
    final avaibleHeight = MediaQuery.of(context).size.height;

    return Container(
      //padding: EdgeInsets.all(20),
      height: avaibleHeight * 0.35,
      padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nome do Projeto',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (projectName) =>
                      _authData['projectName'] = projectName ?? '',
                  validator: (_projectName) {
                    final projectName = _projectName ?? '';
                    if (projectName == '') {
                      return 'Informe um nome para o projeto Válido';
                    }
                    return null;
                  },
                )),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Descrição do Projeto',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (description) =>
                      _authData['description'] = description ?? '',
                  validator: (_description) {
                    final description = _description ?? '';
                    if (description == '') {
                      return 'Informe uma descrição para o seu Projeto';
                    }
                    return null;
                  },
                )),
            Visibility(
                visible: buttomCheck,
                child: isLoading == true
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: submit,
                        child: const Text(
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
