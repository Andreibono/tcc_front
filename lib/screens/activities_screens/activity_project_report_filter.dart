import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/components/app_bar_custom.dart';
import 'package:tcc_front/models/project.dart';
import 'package:tcc_front/util/colors.dart';

import '/models/user.dart';
import '../../models/auth.dart';
import '../../models/report.dart';

class ActivityProjectReportScreen extends StatefulWidget {
  ActivityProjectReportScreen({Key? key}) : super(key: key);

  @override
  State<ActivityProjectReportScreen> createState() =>
      _ActivityProjectReportScreenState();
}

class _ActivityProjectReportScreenState
    extends State<ActivityProjectReportScreen> {
  @override
  List<ReportInfo> reports = [];

  bool firstime = true;

  bool _isLoading = true;

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    User user = arguments['user'];
    Project project = arguments['project'];
    Future<void> submit() async {
      firstime = false;
      List<ReportInfo> reportListresponse = [];
      Auth auth = Provider.of(context, listen: false);
      reportListresponse =
          await auth.fetchReportsFilter(user.token.toString(), project.id, 0);

      if (reportListresponse.isNotEmpty) {
        //Relatórios do Projeto resgatados com seucesso
        setState(() {
          _isLoading = false;
          reports = reportListresponse;
        });
      } else {
        //tratamento de erro ao resgatar os relátrios do Projeto
        //DialogUtils.showCustomDialog(context, title: "Erro", content: resposta);
        setState(() {
          _isLoading = false;
        });
      }
    }

    void firstTime() {
      if (firstime) {
        submit();
      }
    }

    firstTime();

    final avaibleHeight = MediaQuery.of(context).size.height;
    final avaibleWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBarCustom(
          title: '${project.name} - Relatórios',
          check: false,
          onTapFunction: () {}),
      body: _isLoading
          ? Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator())
          : reports.isEmpty
              ?
              // imagem caso não haja relátorios para o projeto
              Column(
                  children: [
                    SizedBox(
                      height: avaibleWidth * 0.1,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset('assets/imagens/company.png',
                          width: avaibleWidth * 0.6),
                    ),
                    SizedBox(
                      height: avaibleWidth * 0.1,
                    ),
                    const Text(
                      "Não existem relatórios para este projeto!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    )
                  ],
                )
              :
              // Construção da lista de reports
              ListView.builder(
                  itemCount: reports.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: UtilColors.closedActivity,
                      child: InkWell(
                        onTap: () {
                          /*
                      user.open_activity = reports[index].id;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: ActivityReportScreen(
                                user: user,
                                activity: reports[index].activity,
                              ));
                        },
                      );*/
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'O que foi feito: ${reports[index].report!.iDid}'),
                              Text(
                                  'o que será feito: ${reports[index].report!.willDo}'),
                              Text(
                                  'Dificuldades encontradas: ${reports[index].report!.difficulty}')
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
