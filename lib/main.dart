import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/models/auth.dart';
import 'package:tcc_front/screens/activity_screen.dart';
import 'package:tcc_front/screens/company_screens/add_user_to_company_screen.dart';
import 'package:tcc_front/screens/company_screens/company_screen.dart';
import 'package:tcc_front/screens/company_screens/company_users_list_screen.dart';
import 'package:tcc_front/screens/company_screens/new_company_screen.dart';
import 'package:tcc_front/screens/project_screens/add_user_to_project_screen.dart';
import 'package:tcc_front/screens/project_screens/project_screen.dart';
import 'package:tcc_front/screens/project_screens/project_users_list_screen.dart';
import 'package:tcc_front/util/app_routes.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/project_screens/new_project_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Auth())],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(color: Color.fromARGB(225, 9, 10, 13)),
          canvasColor: Color.fromARGB(225, 65, 70, 77),
        ),
        routes: {
          AppRoutes.HOME: (ctx) => HomeScreen(),
          AppRoutes.LOGINSCREEN: (ctx) => LoginScreen(),
          AppRoutes.PROJECTSCREEN: (ctx) => ProjectScreen(),
          AppRoutes.NEWPROJECTSCREEN: (ctx) => NewProjectScreen(),
          AppRoutes.COMPANYSCREEN: (ctx) => CompanyScreen(),
          AppRoutes.NEWCOMPANY: (ctx) => NewCompanyScreen(),
          AppRoutes.ADDUSERTOCOMPANY: (ctx) => AddUserToCompany(),
          AppRoutes.COMPANYUSERSLIST: (ctx) => CompanyUsersList(),
          AppRoutes.ADDUSERTOPROJECTSCREEN: (ctx) => AddUserToProject(),
          AppRoutes.PROJECTUSERSLIST: (ctx) => ProjectUsersList(),
          AppRoutes.ACTIVITYSCREEN: (ctx) => ActivityScreen()
        },
      ),
    );
  }
}
