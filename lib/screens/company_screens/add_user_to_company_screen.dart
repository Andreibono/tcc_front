import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../util/DialogUtils.dart';
import '/components/app_bar_custom.dart';
import '/models/auth.dart';
import '/models/user.dart';

class AddUserToCompany extends StatefulWidget {
  @override
  State<AddUserToCompany> createState() => _AddUserToCompanyState();
}

class _AddUserToCompanyState extends State<AddUserToCompany> {
  bool buttomCheck = false;
  String? companySelected;
  int companySelectedIndex = -1;

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
      var resposta = await auth.addUserCompany(
          user.token.toString(),
          _authData['newUserId']!,
          user.company_list[companySelectedIndex].company.id);
      print('resposta: $resposta');
      if (resposta == '') {
        //usuário adicionado com sucesso
        DialogUtils.showCustomDialog(context, title: "Sucesso", content: "Usuário Adicionado com Sucesso");
      } else {
        //tratamento de erro ao adicionar usuário a uma empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
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
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'Id do Usuário',
                        labelStyle: TextStyle(color: Colors.lightBlue),
                        contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                    onSaved: (newUserId) => _authData['newUserId'] = newUserId ?? '',
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
