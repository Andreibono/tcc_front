import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcc_front/screens/company_screens/add_user_to_company_screen.dart';
import 'package:tcc_front/util/InfoModal.dart';
import 'package:tcc_front/util/colors.dart';

import '/components/app_bar_custom.dart';
import '/models/user.dart';
import '../../models/auth.dart';
import '../../models/list_projects.dart';
import '../../models/list_users.dart';
import '../../models/project.dart';
import '../../util/app_routes.dart';
import '../../util/deleteModal.dart';
import '../../util/helpers.dart';

class CompanyProjectsList extends StatefulWidget {
  CompanyProjectsList({Key? key}) : super(key: key);

  @override
  State<CompanyProjectsList> createState() => _CompanyProjectsListState();
}

class _CompanyProjectsListState extends State<CompanyProjectsList> {
  bool firstTime = true;
  bool _isLoading = true;
  bool _isLoading2 = false;

  /*@override
  void initState() {
    super.initState();
    firstTime = true;
  }*/
  List<UserList> usersList = [];
  List<ProjectList> projectsList = [];

  final _searchTextController = TextEditingController();

  Future _submitForm(User user) async {
    setState(() {
      _isLoading2 = true;
    });

    if (_searchTextController.text.isEmpty) {
      setState(() => _isLoading2 = false);
      return;
    }

    String projectName = removeLastWhiteSpace(_searchTextController.text);
    Auth auth = Provider.of(context, listen: false);
    // var response = await auth.searchCompany(companyName, user.token);

    setState(() {
      // projectsList = response;
      _isLoading2 = false;
    });
  }

  // String companyName = removeLastWhiteSpace(_searchTextController.text);

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments as User;

    int index = user.company_list.indexWhere(
        (company_list) => company_list.company.id == user.open_activity);

    Future<void> submit() async {
      _isLoading = true;
      firstTime = false;
      List<UserList> usersListresponse = [];
      List<ProjectList> projectListresponse = [];
      Auth auth = Provider.of(context, listen: false);

      usersListresponse = await auth.companyUsersList(
          user.token.toString(), user.company_list[index].company.id);

      projectListresponse = await auth.companyProjectsList(
          user.token.toString(), user.company_list[index].company.id);

      if (usersListresponse.isNotEmpty) {
        firstTime = false;
        setState(() {
          usersList = usersListresponse;
          projectsList = projectListresponse;
          _isLoading = false;
        });
      } else {
        //tratamento de erro ao listar usuários da empresa
        firstTime = false;
        setState(() => _isLoading = false);
      }
    }

    bool manager = (user.company_list[index].role_user == '1');

    final appBar = AppBarCustom(
      title: user.company_list[index].company.fantasy,
      delete: manager,
      onTapFunction: () {
        manager == true
            ? showModalBottomSheet(
                context: context,
                builder: (_) {
                  return Wrap(
                    children: [
                      Container(
                        height: 200,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0))),
                        child: DeleteModal(
                          type: "company",
                          company: user.company_list[index].company,
                          tokenUser: user.token,
                        ),
                      )
                    ],
                  );
                })
            : {};
      },
      working: user.working,
    );

    setUserList() async {
      if (firstTime) {
        await submit();
      }
    }

    if (firstTime) {
      setUserList();
    }

    final avaibleWidth = MediaQuery.of(context).size.width;
    final avaibleHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: appBar,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: usersList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 10);
                        },
                        itemBuilder: (BuildContext context, int userIndex) {
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: InfoModal(
                                        user: user,
                                        modalUser: usersList[userIndex].user,
                                        companyRoleUser:
                                            user.company_list[index].role_user,
                                        companyId:
                                            user.company_list[index].company.id,
                                      ));
                                },
                              );
                            },
                            child: CircleAvatar(
                              backgroundColor:
                                  usersList[userIndex].user.working == 'true'
                                      ? Colors.green
                                      : Colors.red,
                              radius: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 18,
                                child: Text(
                                  usersList[userIndex]
                                      .user
                                      .name[0]
                                      .toUpperCase(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    width: avaibleWidth,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: UtilColors.buttonColor,
                      child: ListTile(
                        title: const Text(
                          'Adicionar Usuários a Empresa',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (BuildContext context) {
                              return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: AddUserToCompany(
                                      user: user,
                                      companyId:
                                          user.company_list[index].company.id));
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: UtilColors.buttonColor,
                      child: ListTile(
                        title: const Text(
                          'Listar Todos os Usuários da Empresa',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRoutes.COMPANYUSERSLIST,
                              arguments: user);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Projetos",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        labelText: 'Buscar Projeto',
                      ),
                    ),
                  ),
                  _isLoading2
                      ? const CircularProgressIndicator()
                      : Expanded(
                          flex: 7,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              itemCount: projectsList.length,
                              shrinkWrap: true,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final project = projectsList[index].id;
                                return Card(
                                  child: InkWell(
                                    child: ListTile(
                                        tileColor: index % 2 == 0
                                            ? const Color.fromRGBO(
                                                28, 32, 38, 1)
                                            : const Color.fromRGBO(
                                                65, 70, 77, 0.8),
                                        leading: CircleAvatar(
                                          backgroundColor: index % 2 == 0
                                              ? const Color.fromARGB(
                                                  255, 138, 167, 128)
                                              : const Color.fromARGB(
                                                  255, 221, 223, 201),
                                          radius: 25,
                                          child: Text(
                                            projectsList[index]
                                                .name[0]
                                                .toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        title: Text(
                                          projectsList[index].name,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                    onTap: () {
                                      //ir para a página da empresa
                                      Project project = Project(
                                          id: projectsList[index].id,
                                          name: projectsList[index].name,
                                          admin: projectsList[index].admin,
                                          created_at:
                                              projectsList[index].created_at,
                                          description:
                                              projectsList[index].description);
                                      Navigator.of(context).pushNamed(
                                          AppRoutes.PROJECTUSERSLIST,
                                          arguments: {
                                            'user': user,
                                            'project': project
                                          });
                                    },
                                  ),
                                );
                              },
                            ),
                          ))
                ],
              ));
  }
}
