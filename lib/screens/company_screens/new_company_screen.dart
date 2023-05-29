import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';
import 'package:tcc_front/models/user.dart';

import '/components/company_form.dart';

class NewCompanyScreen extends StatelessWidget {
  //const NewCompany({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    return Scaffold(
        appBar: AppBarCustom(
          title: user.name,
          onTapFunction: () {},
          working: user.working,
        ), body: Column(children: [CompanyForm(user:user)]));
  }
}
