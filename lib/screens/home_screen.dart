import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/drawer_custom.dart';
import '../models/auth.dart';
import '../models/report.dart';
import '../models/user.dart';
import '../util/DialogUtils.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var user = ModalRoute.of(context)!.settings.arguments as User;

    Future<void> refresh() async {
      Auth auth = Provider.of(context, listen: false);
      user = await auth.login(user.email, user.password);
      if (user.error_message == '') {
        //login com sucesso
        // get das Empresas do Usuário

        user = await auth.fetchCompanies(user.token);

        //get dos projetos do Usuário
        user = await auth.fetchProjects(user.token);

        //get das atividades do Usuário
        user = await auth.fetchActivities(user.token);

      } else {
        //tratamento de erro

        DialogUtils.showCustomDialog(context,
            title: "Erro", content: user.error_message);
      }
    }

    var now = DateTime.now();
    print(now.month);
    print(now.weekday);

    return Scaffold(
      drawer: DrawerCustom(user: user),
      appBar: AppBar(),
      body: Center(
        child: RefreshIndicator(
          onRefresh: () async => await refresh(),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(20),
            children: [
              Column(children: [
                Center(
                  child: Text(
                    'Id:${user.id}, Nome:${user.name}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                for (int i = 0; i < user.company_list.length; i++)
                  Center(
                    child: Text(
                        'Nome da Empresa: ${user.company_list[i].company.fantasy}, CNPJ: ${user.company_list[i].company.cnpj}',
                        style: TextStyle(color: Colors.white)),
                  ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
