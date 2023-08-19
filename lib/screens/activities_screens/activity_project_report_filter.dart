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
  List<ReportInfo> reportsreponse = [];

  bool firstime = true;

  bool _isLoading = true;

  List<String> dropDownBoxFilter = ['0', '3', '6', '9', '12', '24'];

  List<String> downFilter = [
    "Mês atual",
    "Últimos 3 meses",
    "Últimos 6 meses",
    'Últimos 9 meses',
    'Último ano',
    "Últimos 2 anos"
  ];

  String? filterSelectec = "Mês atual";

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      alignment: Alignment.center,
      child: Text(
        item,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ));

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;

    User user = arguments['user'];
    Project project = arguments['project'];

    Future<void> submit(String filter) async {
      firstime = false;
      reports.clear();
      reportsreponse.clear();
      List<ReportInfo> reportListresponse = [];
      Auth auth = Provider.of(context, listen: false);
      reportListresponse = await auth.fetchReportsFilter(
          user.token.toString(), project.id, int.parse(filter));

      if (reportListresponse.isNotEmpty) {
        //Relatórios do Projeto resgatados com seucesso
        setState(() {
          _isLoading = false;
          reportsreponse = reportListresponse;
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
        submit('0');
      }
    }

    firstTime();

    //final avaibleHeight = MediaQuery.of(context).size.height;
    final avaibleWidth = MediaQuery.of(context).size.width;

    reports = reportsreponse.reversed.toList();

    return Scaffold(
        appBar: AppBarCustom(
            title: '${project.name} - Relatórios',
            check: false,
            onTapFunction: () {}),
        body: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: DropdownButton<String>(
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                alignment: Alignment.center,
                value: filterSelectec,
                items: downFilter.map(buildMenuItem).toList(),
                onChanged: (value) => setState(() {
                  _isLoading = true;
                  filterSelectec = value;
                  print(filterSelectec!);
                  var index = downFilter.indexOf(filterSelectec!);
                  print(dropDownBoxFilter[index]);
                  submit(dropDownBoxFilter[index]);
                }),
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
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
                    Expanded(
                        child: ListView.builder(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('nome: ${reports[index].name}'),
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
                      ),
          ],
        ));
  }
}
