import 'package:flutter/material.dart';

import '../models/user.dart';
import '../util/app_routes.dart';

class DrawerCustom extends StatelessWidget {
  final User user;

  DrawerCustom({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [buildHeader(context), buildMenuItems(context)]),
        ),
      );

  Widget buildHeader(BuildContext context) => Container();

  Widget buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.HOME, (route) => false, arguments: user);
              },
            ),
            ListTile(
              leading: Icon(Icons.business, color: Colors.white),
              title: Text(
                'Empresa',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context)
                    .pushNamed(AppRoutes.COMPANYSCREEN, arguments: user);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment_outlined, color: Colors.white),
              title: Text(
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
              leading: Icon(Icons.laptop_rounded, color: Colors.white),
              title: Text(
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
              leading: Icon(Icons.logout, color: Colors.white),
              title: Text(
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
