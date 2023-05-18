import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/components/app_bar_custom.dart';

import '../../models/auth.dart';
import '../../models/user.dart';
import '../../util/DialogUtils.dart';

class ActivityReportScreen extends StatelessWidget {
  const ActivityReportScreen({Key? key, int? index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var user = ModalRoute.of(context)!.settings.arguments as User;

    Map<String, String> _authData = {
      'iDid': '',
      'willDo': '',
      'difficulty': '',
    };

    String time() {
      int index = user.activitiesList.indexWhere((activitiesList) => activitiesList.id == user.open_activity );
      //user.activitiesList[index].

      var activitytime =
          DateTime.parse(user.activitiesList.elementAt(index).created_at);
      var timeatual = DateTime.now();
      var tempogasto2 = timeatual.difference(activitytime);
      print(
          "nome: ${user.activitiesList[index].activity} tempo gasto:${tempogasto2.inMinutes}");
      
      var horas = tempogasto2.inHours;
      var minute = tempogasto2.inMinutes % 60;
      var seconds = tempogasto2.inSeconds % 60;

      print(
          "hoars:${horas.floor()}  minutos:${minute.floor()}  segundos:${seconds.floor()}");

      return (horas < 10 ? '0' + horas.toString() : horas.toString()) +
          ":" +
          (minute < 10 ? '0' + minute.toString() : minute.toString()) +
          ":" +
          (seconds < 10 ? '0' + seconds.toString() : seconds.toString());
    }

    Future<void> submit() async {
      final isValid = _formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      _formKey.currentState?.save();

      var resposta = await auth.sendReport(
          _authData['iDid']!,
          _authData['willDo']!,
          _authData['difficulty']!,
          user.open_activity.toString(),
          time(),
          user.token.toString());
      if (resposta == '') {
        //empresa cadastrada com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso!", content: "Relatório enviado com sucesso!");
      } else {
        //tratamento de erro ao enviar relatório
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    return Scaffold(
        appBar: AppBarCustom(),
        body: Container(
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
                          labelText: 'O que você fez nessa atividade? ',
                          labelStyle: TextStyle(color: Colors.lightBlue),
                          contentPadding: EdgeInsets.fromLTRB(10, 20, 20, 20)),
                      onChanged: (iDid) => '',
                      onSaved: (iDid) => _authData['iDid'] = iDid ?? '',
                      validator: (_fantasyName) {
                        final fantasyName = _fantasyName;
                        if (fantasyName == '' || fantasyName!.isEmpty) {
                          return 'Descreva o que você fez nessa atividade.';
                        }
                        return null;
                      },
                    )),
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'O que você fará a seguir?',
                          labelStyle: TextStyle(color: Colors.lightBlue),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      onChanged: (willDo) => '',
                      onSaved: (willDo) => _authData['willDo'] = willDo ?? '',
                      validator: (_willDo) {
                        final willDo = _willDo ?? '';
                        if (willDo == '') {
                          return 'Descreva o que você fará em seguida.';
                        }
                        return null;
                      },
                    )),
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Descreva as dificuldades que você teve.',
                          labelStyle: TextStyle(color: Colors.lightBlue),
                          contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                      onChanged: (difficulty) => '',
                      onSaved: (difficulty) =>
                          _authData['difficulty'] = difficulty ?? '',
                      validator: (_difficulty) {
                        final difficulty = _difficulty ?? '';
                        if (difficulty == '') {
                          return 'Descreva as suas dificuldades durante a atividade realizada.';
                        }
                        return null;
                      },
                    )),
                ElevatedButton(
                  onPressed: submit,
                  child: Text(
                    'Enviar Relatório',
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 8)),
                ),
              ],
            ),
          ),
        ));
  }
}
