import 'package:tcc_front/models/project.dart';

class ProjectList {
  //"id", "name","admin","description","created_at",
  var id;
  var name;
  var admin;
  var description;
  var created_at;

  ProjectList({this.id, this.name, this.admin, this.description, this.created_at});

  factory ProjectList.fromJson(Map json) {
    return ProjectList(
      id: json['id'].toString(),
      name: json['name'].toString(),
      admin: json['admin'].toString(),
      description: json['description'].toString(),
      created_at: json['created_at'].toString(),
    );
  }
}
