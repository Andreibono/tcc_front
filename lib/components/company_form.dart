import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import '../models/user.dart';
import '../util/DialogUtils.dart';

class CompanyForm extends StatefulWidget {
  final User user;
  const CompanyForm({required this.user, Key? key}) : super(key: key);

  @override
  State<CompanyForm> createState() => CompanyFormState();
}

class CompanyFormState extends State<CompanyForm> {
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
      var resposta = await auth.companySingup(_authData['fantasyName']!,
          _authData['CNPJ']!, widget.user.token.toString());
      if (resposta == '') {
        //empresa cadastrada com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso", content: "Empresa Cadastrada com Sucesso!");
      } else {
        //tratamento de erro ao cadastrar empresa
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    return Container(
      height: 250,
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: TextFormField(
                  decoration: const InputDecoration(
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
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
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
              child: const Text(
                'Cadastrar',
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
