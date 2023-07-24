import 'package:flutter/material.dart';

import '../models/user.dart';
import '../util/app_routes.dart';

class DrawerCustom extends StatelessWidget {
  final User user;

 const DrawerCustom({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [buildHeader(context), buildMenuItems(context)]),
        ),
      );

  Widget buildHeader(BuildContext context) => Material(
      color: Colors.blue.shade700,
      child: InkWell(onTap: (){
        //navegação para a tela do usuário
      },
      child: Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 52,
            backgroundColor: Colors.grey,
          ),
          Text(user.name, style: const TextStyle(fontSize: 28, color: Colors.white)),
          Text(user.email, style: const TextStyle(fontSize: 16, color: Colors.white))
        ],
      ))));

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.HOME, (route) => false,
                    arguments: user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text(
                'Empresa',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.COMPANYSCREEN, arguments: user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_outlined, color: Colors.white),
              title: const Text(
                'Meus Projetos',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context)
                    .pushNamed(AppRoutes.PROJECTSCREEN, arguments: user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.laptop_rounded, color: Colors.white),
              title: const Text(
                'Minhas Atividades',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context)
                    .pushNamed(AppRoutes.ACTIVITYSCREEN, arguments: user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.LOGINSCREEN, (route) => false);
              },
            )
          ],
        ),
      );
}
