import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';

import '/models/user.dart';
import '/util/app_routes.dart';

class CompanyScreen extends StatelessWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    final companies = user.company_list;
    
    final appBar =  AppBarCustom(title: "Empresa", onTapFunction: () {
          Navigator.pop(context);
          Navigator.of(context)
              .pushNamed(AppRoutes.NEWCOMPANY, arguments: user);
        }
      );

    final avaibleHeight = 
      MediaQuery.of(context).size.height - 
      MediaQuery.of(context).padding.top - 
      appBar.preferredSize.height;
  
    final avaibleWidth = 
      MediaQuery.of(context).size.width; 
    
   

    return Scaffold(
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: avaibleHeight * 0.3,
            width: avaibleWidth,
            child: Column(
              children: [
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
                Divider(
                  color: Colors.white,
                )
            ]),
          ),
          Container(
            height: avaibleHeight * 0.7,
            width: avaibleWidth,
            child: companies.length > 0 
            ? ListView.builder(
              itemCount: companies.length,
              itemBuilder: (context, index) {
                final company = companies[index].company;
                return Card(
                  child: ListTile(
                    tileColor: index % 2 == 0 
                      ? const Color.fromRGBO(65, 70, 77, 0.8)
                      : const Color.fromRGBO(28, 32, 38, 1),
                    leading: CircleAvatar(
                      backgroundColor: index % 2 == 0 
                      ? const Color.fromARGB(255, 221, 223, 201)
                      : const Color.fromARGB(255, 138, 167, 128),
                      radius: 30,
                      child: Text(
                        company.fantasy[0].toUpperCase(),
                        style: TextStyle(
                          color: Colors.black
                        ), 
                        ),
                        ),
                    title: Text(
                      company.fantasy,
                      style: TextStyle(
                           color: Colors.white
                        ),
                      )
                  ),
                );
              },
            )
            : SizedBox(),
          )

        ],
      ),
      
    );
  }
}
