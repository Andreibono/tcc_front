import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/models/auth.dart';
import 'package:tcc_front/screens/activities_screens/activity_screen.dart';
import 'package:tcc_front/screens/activities_screens/activity_user_list_screen.dart';
import 'package:tcc_front/screens/company_screens/add_user_to_company_screen.dart';
import 'package:tcc_front/screens/company_screens/company_project_list_screen.dart';
import 'package:tcc_front/screens/company_screens/company_screen.dart';
import 'package:tcc_front/screens/company_screens/company_users_list_screen.dart';
import 'package:tcc_front/screens/project_screens/add_user_to_project_screen.dart';
import 'package:tcc_front/screens/project_screens/project_screen.dart';
import 'package:tcc_front/screens/project_screens/project_users_list_screen.dart';
import 'package:tcc_front/util/app_routes.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

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
          AppRoutes.COMPANYSCREEN: (ctx) => CompanyScreen(),
          AppRoutes.COMPANYUSERSLIST: (ctx) => CompanyUsersList(),
          AppRoutes.ADDUSERTOPROJECTSCREEN: (ctx) => AddUserToProject(),
          AppRoutes.PROJECTUSERSLIST: (ctx) => ProjectUsersList(),
          AppRoutes.ACTIVITYSCREEN: (ctx) => ActivityScreen(),
          AppRoutes.ACTIVITYUSERLIST: (ctx) => ActivityUserList(),
          AppRoutes.COMPANYPROJECTLIST: (ctx) => CompanyProjectsList()
        },
      ),
    );
  }
}
