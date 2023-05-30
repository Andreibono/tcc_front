import 'package:flutter/material.dart';
import 'package:tcc_front/components/app_bar_custom.dart';
import 'package:tcc_front/models/company.dart';

import '/models/user.dart';
import '../../components/company_form.dart';
import '../../util/helpers.dart';
import '../../models/auth.dart';
import 'package:provider/provider.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final _searchTextController = TextEditingController();
  bool isFistTime = true;
  List<CompanyInfo> companies = [];
  bool isLoading = false;

  void setList(User user) {
    if (isFistTime) {
      companies = user.company_list;
    }
  }

  Future _submitForm(User user) async {
    isFistTime = false;

    setState(() {
      isLoading = true;
    });

    if (_searchTextController.text.isEmpty) {
      print("vazio");
      setState(() {
        companies = user.company_list;
      });
      return;
    }   

    String companyName = removeLastWhiteSpace(_searchTextController.text);
    Auth auth = Provider.of(context, listen: false);
    var response = await auth.searchCompany(companyName, user.token);

    setState(() {
      companies = response;
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;
    setList(user);
    final appBar = AppBarCustom(
      title: user.name,
      check: true,
      onTapFunction: () {
        showModalBottomSheet(
          context: context,
          builder: (_) {
            return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: CompanyForm(
                  user: user,
                ));
          },
        );
      },
      working: user.working,
    );

    final avaibleHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        appBar.preferredSize.height;

    final avaibleWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Column(
        children: [
          Container(
            height: avaibleHeight * 0.20,
            width: avaibleWidth,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 20,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: TextFormField(
                    controller: _searchTextController,
                    onFieldSubmitted: (_) => _submitForm(user),
                    decoration: const InputDecoration(
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      focusColor: Colors.black,
                      labelText: 'Buscar Empresa',
                    ),
                  ),
                ),
              ),
              // ListTile(
              //   title: Text(
              //     'Adicionar Usuários a Empresa',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);

              //     Navigator.of(context)
              //         .pushNamed(AppRoutes.ADDUSERTOCOMPANY, arguments: user);
              //   },
              // ),
              // ListTile(
              //   title: Text(
              //     'Listar Usuários da Empresa',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);

              //     Navigator.of(context)
              //         .pushNamed(AppRoutes.COMPANYUSERSLIST, arguments: user);
              //   },
              // ),
              SizedBox(
                height: avaibleHeight * 0.05,
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: const Text(
                  "Minhas Empresas",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ]),
          ),
          isLoading ? const Padding(
            padding:  EdgeInsets.all(50.0),
            child:  CircularProgressIndicator(),
          ) 
          : Container(
              height: avaibleHeight * 0.80,
              width: avaibleWidth,
              alignment: Alignment.topCenter,
              child: companies.isNotEmpty
                  ? ListView.builder(
                      itemCount: companies.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final company = companies[index].company;
                        return Card(
                          child: InkWell(
                            child: ListTile(
                                tileColor: index % 2 == 0
                                    ? const Color.fromRGBO(28, 32, 38, 1)
                                    : const Color.fromRGBO(65, 70, 77, 0.8),
                                leading: CircleAvatar(
                                  backgroundColor: index % 2 == 0
                                      ? const Color.fromARGB(255, 138, 167, 128)
                                      : const Color.fromARGB(255, 221, 223, 201),
                                  radius: 25,
                                  child: Text(
                                    company.fantasy[0].toUpperCase(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                                title: Text(
                                  company.fantasy,
                                  style: const TextStyle(color: Colors.white),
                                )),
                            onTap: () {
                              //ir para a página da empresa
                            },
                          ),
                        );
                      },
                    )
                  : const SizedBox()),
        ],
      ),
    );
  }
}
