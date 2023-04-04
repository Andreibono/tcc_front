import 'package:flutter/material.dart';

import '../components/drawer_custom.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
      drawer: DrawerCustom(user: user),
      appBar: AppBar(),
      body: Center(
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
    );
  }
}
