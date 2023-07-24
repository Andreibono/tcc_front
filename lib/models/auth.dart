import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcc_front/models/company.dart';
import 'package:tcc_front/models/project.dart';
import 'package:tcc_front/models/report.dart';
import 'package:tcc_front/models/user.dart';

import 'activity.dart';
import 'list_projects.dart';
import 'list_users.dart';

class Auth with ChangeNotifier {
  var url = 'https://apitcc.brunodev.software/api';
  Map<String, String> requestHeadears = {'Content-Type': 'application/json'};
  var user = User();

  Future<void> singup(String email, String password, String confirmPassword,
      String name) async {
    try {
      var response = await http
          .post(Uri.parse('$url/users'),
              body: jsonEncode(
                {
                  "email": email,
                  "password": password,
                  "name": name,
                  "password_confirmation": confirmPassword
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 201) {
          print('Usuário cadastrado com sucesso!');
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print('erro: $e');
    }
  }

  Future login(String email, String password) async {
    try {
      var response = await http
          .post(Uri.parse('$url/session/login'),
              body: jsonEncode(
                {"email": email, "password": password},
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          //id,email,name,working,created_at,updated_at,avatar,avatar_url,token,refresh_token

          user.id = jsonDecode(response.body)['userRes']['id'].toString();
          user.email = jsonDecode(response.body)['userRes']['email'].toString();
          user.name = jsonDecode(response.body)['userRes']['name'].toString();
          user.working =
              jsonDecode(response.body)['userRes']['working'].toString();
          user.created_at =
              jsonDecode(response.body)['userRes']['created_at'].toString();
          user.updated_at =
              jsonDecode(response.body)['userRes']['updated_at'].toString();
          user.avatar =
              jsonDecode(response.body)['userRes']['avatar'].toString();
          user.avatar_url =
              jsonDecode(response.body)['userRes']['avatar_url'].toString();
          user.token = jsonDecode(response.body)['token'].toString();
          user.refresh_token =
              jsonDecode(response.body)['refresh_token'].toString();
          user.error_message = '';
        } else {
          user.error_message = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      user.error_message = e.toString();
    }
    return user;
  }

  Future companySingup(
      String fantasyName, String cnpj, String tolkienUser) async {
    var errorMessage = '';
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tolkienUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/company'),
              body: jsonEncode(
                {
                  "fantasia": fantasyName,
                  "cnpj_cpf": cnpj,
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 201) {
        } else {
          errorMessage = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      errorMessage = e.toString();
    }
    return (errorMessage);
  }

  Future<User> fetchCompanies(String tokenUser) async {
    user.company_list.clear();
    List<CompanyInfo> companiesList;
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/user-companies'), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body) as List;

          companiesList = responseJson
              .map((tagJson) => CompanyInfo.fromJson(tagJson))
              .toList();
          for (int i = 0; i < companiesList.length; i++) {
            user.company_list.add(companiesList[i]);
          }
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print('erro: $e');
    }
    return user;
  }

  Future<String> addUserCompany(
      String tokenUser, String userEmail, String companyId) async {
    String resposta = "";
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/company-users/$companyId'),
              body: jsonEncode(
                {
                  "newUserEmail": userEmail,
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
        } else {
          resposta = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<List<UserList>> companyUsersList(
      String tokenUser, String companyId) async {
    List<UserList> usersList = [];
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/company-users/$companyId'),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body) as List;

          usersList = responseJson
              .map((tagJson) => UserList.fromJson(tagJson))
              .toList();
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print("erro: $e");
    }
    return usersList;
  }

  Future<List<ProjectList>> companyProjectsList(
      String tokenUser, String companyId) async {
    List<ProjectList> projectList = [];
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/company-projects/$companyId'),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body)['data'] as List;

          projectList = responseJson
              .map((tagJson) => ProjectList.fromJson(tagJson))
              .toList();
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print("erro: $e");
    }
    return projectList;
  }

  Future projectSingup(String projectName, String description,
      String tolkienUser, String companyId) async {
    var errorMessage = '';

    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tolkienUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/projects'),
              body: jsonEncode(
                {
                  "name": projectName,
                  "description": description,
                  "companyId": companyId,
                  "users": []
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 201) {
          print("Projeto Cadastrado com Sucesso!");
        } else {
          errorMessage = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      errorMessage = e.toString();
    }
    return (errorMessage);
  }

  Future<User> fetchProjects(String tokenUser) async {
    user.projectsList.clear();
    List<ProjectInfo> projectsList;
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/projects'), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body)['data'] as List;

          projectsList = responseJson
              .map((tagJson) => ProjectInfo.fromJson(tagJson))
              .toList();
          for (int i = 0; i < projectsList.length; i++) {
            user.projectsList.add(projectsList[i]);
          }
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print('erro: $e');
    }
    return user;
  }

  Future<String> addUserProject(String tokenUser, String userEmail,
      String projectId, String companyId) async {
    String resposta = "";
    List<String> usersEmails = [];
    usersEmails.add(userEmail);
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/user-projects/$projectId'),
              body: jsonEncode(
                {"users": usersEmails, "companyId": companyId},
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
        } else {
          resposta = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<List<User>> projectUsersList(
      String tokenUser, String projectId) async {
    List<User> usersList = [];
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/user-projects/$projectId'),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body) as List;

          usersList =
              responseJson.map((tagJson) => User.fromJson(tagJson)).toList();
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print("erro: $e");
    }
    return usersList;
  }

  Future activitySingup(String activityName, String description,
      String tokenUser, String projectId) async {
    var errorMessage = '';

    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/activities'),
              body: jsonEncode(
                {
                  "activity": activityName,
                  "description": description,
                  "projectId": projectId,
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 201) {
        } else {
          errorMessage = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      errorMessage = e.toString();
    }
    return (errorMessage);
  }

  Future<User> fetchActivities(String tokenUser) async {
    user.activitiesList.clear();
    List<Activity> activitiesList;
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/activities'), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body)['data'] as List;

          activitiesList = responseJson
              .map((tagJson) => Activity.fromJson(tagJson))
              .toList();
          for (int i = 0; i < activitiesList.length; i++) {
            user.activitiesList.add(activitiesList[i]);
          }
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print('erro: $e');
    }
    return user;
  }

  Future<String> sendReport(String iDid, String willDo, String difficulty,
      String activity, String end, String tokenUser) async {
    String resposta = '';
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .post(Uri.parse('$url/reports'),
              body: jsonEncode(
                {
                  "end": end,
                  "activity": activity,
                  "report": {
                    "iDid": iDid,
                    "willDo": willDo,
                    "difficulty": difficulty,
                  }
                },
              ),
              headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          return resposta;
        } else {
          resposta = (jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      resposta = ('erro: $e');
    }
    return resposta;
  }

  Future<String> putWorking(String tokenUser) async {
    String resposta = "";
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .put(Uri.parse('$url/working'), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          print("Usuário começou a trabalhar");
        } else {
          resposta = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future searchCompany(String fantasia, String tokenUser) async {
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };

      requestHeadears.addEntries(headerToken.entries);
      var response = await http.get(
          Uri.parse('$url/company/search?fantasia=$fantasia'),
          headers: requestHeadears);

      if (response.statusCode != 200) {
        return null;
      }

      var responseJson = json.decode(response.body)['companies'] as List;

      var companiesList =
          responseJson.map((tagJson) => CompanyInfo.fromJson(tagJson)).toList();

      return companiesList;
    } catch (e) {
      return "erro: $e";
    }
  }

  Future<String> deleteCompanyUsers(
      String userEmail, String? companyId, String? tokenUser) async {
    var resposta = '';
    List<String> usersEmails = [];
    usersEmails.add(userEmail);
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };

      requestHeadears.addEntries(headerToken.entries);
      var response =
          await http.delete(Uri.parse('$url/company-users/$companyId'),
              body: jsonEncode(
                {"usersEmail": usersEmails},
              ),
              headers: requestHeadears);

      if (response.statusCode == 200) {
      } else {
        resposta = jsonDecode(response.body).toString();
      }
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<String> deleteProjectUsers(
      String userEmail, String? projectId, String? tokenUser) async {
    var resposta = '';
    List<String> usersEmails = [];
    usersEmails.add(userEmail);
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };

      requestHeadears.addEntries(headerToken.entries);
      var response =
          await http.delete(Uri.parse('$url/user-projects/$projectId'),
              body: jsonEncode(
                {"usersEmail": usersEmails},
              ),
              headers: requestHeadears);

      if (response.statusCode == 200) {
      } else {
        resposta = jsonDecode(response.body).toString();
      }
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<String> deleteCompany(String? companyId, String? tokenUser) async {
    var resposta = '';
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };

      requestHeadears.addEntries(headerToken.entries);
      var response = await http.delete(Uri.parse('$url/company/$companyId'),
          headers: requestHeadears);

      if (response.statusCode == 200) {
      } else {
        resposta = jsonDecode(response.body).toString();
      }
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<String> deleteProject(String? projectId, String? tokenUser) async {
    var resposta = '';
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };

      requestHeadears.addEntries(headerToken.entries);
      var response = await http.delete(Uri.parse('$url/projects/$projectId'),
          headers: requestHeadears);

      if (response.statusCode == 200) {
      } else {
        resposta = jsonDecode(response.body).toString();
      }
    } catch (e) {
      resposta = "erro: $e";
    }
    return resposta;
  }

  Future<List<ReportInfo>> fetchReportsFilter(
      String tokenUser, String projectId, int filter) async {
    List<ReportInfo> activitiesList = [];
    String auxurl = "$url/reports/search?project=$projectId";
    auxurl += filter == 0 ? "" : "&month=$filter";
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse(auxurl), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body) as List;
          activitiesList = responseJson
              .map((tagJson) => ReportInfo.fromJson(tagJson))
              .toList();
        } else {
          print(jsonDecode(response.body).toString());
        }
      });
    } catch (e) {
      print('erro: $e');
    }
    return activitiesList;
  }

  Future<ReportInfo> fetchReport(String tokenUser, String activityId) async {
    ReportInfo report = ReportInfo();
    try {
      final headerToken = <String, String>{
        'Authorization': 'Bearer $tokenUser'
      };
      requestHeadears.addEntries(headerToken.entries);
      var response = await http
          .get(Uri.parse('$url/reports/$activityId'), headers: requestHeadears)
          .then((response) {
        if (response.statusCode == 200) {
          var responseJson = json.decode(response.body);
          report.id = jsonDecode(response.body)['id'].toString();
          report.report = Report.fromJson(jsonDecode(response.body)['report']);
          report.activity =
              Activity.fromJson(jsonDecode(response.body)['activity']);
        } else {
          report.error = jsonDecode(response.body).toString();
        }
      });
    } catch (e) {
      report.error = e.toString();
    }
    return report;
  }
}
