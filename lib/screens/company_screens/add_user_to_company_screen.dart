import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/auth.dart';
import '/models/user.dart';
import '../../util/DialogUtils.dart';

class AddUserToCompany extends StatefulWidget {
  final User user;
  final String companyId;
  @override
  State<AddUserToCompany> createState() => _AddUserToCompanyState();
  AddUserToCompany({Key? key, required this.user, required this.companyId})
      : super(key: key);
}

class _AddUserToCompanyState extends State<AddUserToCompany> {
  static final _formKey = GlobalKey<FormState>();
  bool buttomCheck = false;
  String? companySelected;
  int companySelectedIndex = -1;

  @override
  Widget build(BuildContext context) {
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
      var resposta = await auth.addUserCompany(widget.user.token.toString(),
          _authData['newUserId']!, widget.companyId);
      print('resposta: $resposta');
      if (resposta == '') {
        //usuário adicionado com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso", content: "Usuário Adicionado com Sucesso");
      } else {
        //tratamento de erro ao adicionar usuário a uma empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    final avaibleHeight = MediaQuery.of(context).size.height;

    return Container(
      height: avaibleHeight * 0.30,
      //padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
      padding: EdgeInsets.all(20),
      alignment: Alignment.topCenter,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
            )
          ],
        ),
      ),
    );
  }
}
