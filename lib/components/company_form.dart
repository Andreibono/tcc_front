import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/models/company.dart';

import '../models/auth.dart';
import '../models/user.dart';
import '../util/DialogUtils.dart';

class CompanyForm extends StatefulWidget {
  const CompanyForm({Key? key}) : super(key: key);

  @override
  State<CompanyForm> createState() => CompanyFormState();
}

class CompanyFormState extends State<CompanyForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var user = ModalRoute.of(context)!.settings.arguments as User;

    Map<String, String> _authData = {
      'fantasyName': '',
      'CNPJ': '',
    };

    Future<void> submit() async {

      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();
      var resposta = await auth.companySingup(
          _authData['fantasyName']!, _authData['CNPJ']!, user.token.toString());
      print('resposta: $resposta');
      if (resposta == '') {
        //empresa cadastrada com sucesso
        DialogUtils.showCustomDialog(context, title: "Sucesso", content: "Empresa Cadastrada com Sucesso!");
        
      } else {
        //tratamento de erro ao cadastrar empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Nome Fantasia',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 20, 20, 20)),
                  onChanged: (fantasyName) => '',
                  onSaved: (fantasyName) =>
                      _authData['fantasyName'] = fantasyName ?? '',
                  validator: (_fantasyName) {
                    final fantasyName = _fantasyName;
                    if (fantasyName == '' || fantasyName!.isEmpty) {
                      return 'Informe um nome fantasia válido';
                    }
                    return null;
                  },
                )),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'CPF/CNPJ',
                      labelStyle: TextStyle(color: Colors.lightBlue),
                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                  onSaved: (cnpj) => _authData['CNPJ'] = cnpj ?? '',
                  validator: (_cnpj) {
                    final cnpj = _cnpj ?? '';
                    if (cnpj == '') {
                      return 'Informe um CNPJ ou um CPF válido';
                    }
                    return null;
                  },
                )),
            ElevatedButton(
              onPressed: submit,
              child: Text(
                'Salvar',
              ),
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8)),
            ),
          ],
        ),
      ),
    );
  }
}
