import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';

import '/models/user.dart';
import '/util/app_routes.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      appBar: AppBarCustom(),
      body: Column(children: [
        ListTile(
          title: Text(
            'Cadastrar uma Nova Empresa',
            style: TextStyle(color: Colors.white),
          ),
          tileColor: 
          Colors.blue,
          onTap: () {
            Navigator.pop(context);
        
            Navigator.of(context)
                .pushNamed(AppRoutes.NEWCOMPANY, arguments: user);
          },
        ),
        ListTile(
          title: Text(
            'Adicionar Usuários a Empresa',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.ADDUSERTOCOMPANY, arguments: user);
          },
        ),
        ListTile(
          title: Text(
            'Listar Usuários da Empresa',
            style: TextStyle(color: Colors.white),
          ),
          onTap: () {
            Navigator.pop(context);

            Navigator.of(context)
                .pushNamed(AppRoutes.COMPANYUSERSLIST, arguments: user);
          },
        ),
      ]),
    );
  }
}
