import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/util/colors.dart';

import '../../models/activity.dart';
import '../../models/auth.dart';
import '../../models/report.dart';
import '../../models/user.dart';
import '../../util/DialogUtils.dart';

class ActivityReportScreen extends StatefulWidget {
  final User user;
  static final _formKey = GlobalKey<FormState>();
  final Activity? activity;
  const ActivityReportScreen(
      {Key? key, int? index, required this.user, required this.activity})
      : super(key: key);

  @override
  State<ActivityReportScreen> createState() => _ActivityReportScreenState();
}

class _ActivityReportScreenState extends State<ActivityReportScreen> {
  bool firstTime = true;
  bool _isLoading = true;
  ReportInfo report = ReportInfo();

  @override
  Widget build(BuildContext context) {
    Map<String, String> _authData = {
      'iDid': '',
      'willDo': '',
      'difficulty': '',
    };

    String time() {
      int index = widget.user.activitiesList.indexWhere(
          (activitiesList) => activitiesList.id == widget.user.open_activity);

      var activitytime = DateTime.parse(
          widget.user.activitiesList.elementAt(index).created_at);
      var timeatual = DateTime.now();
      var tempogasto2 = timeatual.difference(activitytime);

      var horas = tempogasto2.inHours;
      var minute = tempogasto2.inMinutes % 60;
      var seconds = tempogasto2.inSeconds % 60;

      if (horas >= 24) {
        return ('23:59:59');
      } else {
        return (horas < 10 ? '0' + horas.toString() : horas.toString()) +
            ":" +
            (minute < 10 ? '0' + minute.toString() : minute.toString()) +
            ":" +
            (seconds < 10 ? '0' + seconds.toString() : seconds.toString());
      }
    }

    Future<void> submitReport() async {
      final isValid =
          ActivityReportScreen._formKey.currentState?.validate() ?? false;
      Auth auth = Provider.of(context, listen: false);

      if (!isValid) {
        return;
      }
      ActivityReportScreen._formKey.currentState?.save();

      var resposta = await auth.sendReport(
          _authData['iDid']!,
          _authData['willDo']!,
          _authData['difficulty']!,
          widget.user.open_activity.toString(),
          time(),
          widget.user.token.toString());
      if (resposta == '') {
        //Relatório enviado com sucesso
        DialogUtils.showCustomDialog(context,
            title: "Sucesso!", content: "Relatório enviado com sucesso!");
      } else {
        //tratamento de erro ao enviar relatório
        DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
      }
    }

    Future<void> submitFetchReport() async {
      firstTime = false;
      Auth auth = Provider.of(context, listen: false);
      var reportResponse = ReportInfo();
      reportResponse = await auth.fetchReport(
          widget.user.token.toString(), widget.activity?.id);
      if (report.error == '') {
        //Relatório resgatado com sucesso
        setState(() {
          report = reportResponse;
          _isLoading = false;
        });
      } else {
        //tratamento de erro ao resgatar relatório
        DialogUtils.showCustomDialog(context, title: "Erro", content: "");
        setState(() => _isLoading = false);
      }
    }

    Future<void> isFirstTime() async {
      (firstTime && widget.activity!.status)
          ? await submitFetchReport()
          : firstTime = false;
    }

    isFirstTime();

    final avaibleHeight = MediaQuery.of(context).size.height;
    final avaibleWidth = MediaQuery.of(context).size.width;

    return widget.activity!.status
        ?
        // Relatório ja foi fechado, modal para mostrar apenas inforamção
        _isLoading
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator())
            : FittedBox(
                child: Container(
                    //height: avaibleHeight * 0.35,
                    padding: const EdgeInsets.fromLTRB(30, 10, 0, 0),
                    child: Column(children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Nome da Atividade",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.activity!.activity),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Descrição da Atividade",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.activity!.description),
                          )),
                      const SizedBox(height: 15),
                      const Text(
                        "O que foi feito",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.report!.iDid),
                          )),
                      const SizedBox(height: 15),
                      const Text(
                        "O que será feito a seguir",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.report!.willDo),
                          )),
                      const SizedBox(height: 15),
                      const Text(
                        "Dificuldades encontradas",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.report!.difficulty),
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Data de começo da Atividade",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.activity!.start),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Data de encerramento da Atividade",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                          width: avaibleWidth - 50,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: UtilColors.borderColor, width: 3),
                              borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            title: Text(report.activity!.end),
                          )),
                      const SizedBox(height: 5)
                    ])),
              )
        :
        // Relátio ainda em aberto, modal para envio
        Expanded(
            child: Container(
              height: 350,
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Form(
                key: ActivityReportScreen._formKey,
                child: Column(
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'O que você fez nessa atividade? ',
                              labelStyle: TextStyle(color: Colors.lightBlue),
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 20, 20, 20)),
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
                          decoration: const InputDecoration(
                              labelText: 'O que você fará a seguir?',
                              labelStyle: TextStyle(color: Colors.lightBlue),
                              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0)),
                          onChanged: (willDo) => '',
                          onSaved: (willDo) =>
                              _authData['willDo'] = willDo ?? '',
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
                          decoration: const InputDecoration(
                              labelText:
                                  'Descreva as dificuldades que você teve.',
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
                      onPressed: submitReport,
                      child: const Text(
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
            ),
          );
  }
}
