class ProjectInfo {
  //id": 1,created_at,updated_at, project

  var id;
  var created_at;
  var updated_at;
  var project;

  ProjectInfo({this.id, this.created_at, this.updated_at, this.project});

  factory ProjectInfo.fromJson(Map json) {
    return ProjectInfo(
        id: json['id'].toString(),
        created_at: json['created_at'].toString(),
        updated_at: json['updated_at'].toString(),
        project: Project.fromJson(json['project']));
  }
}

class Project {
  //id, name, admin, description, company_id, created_at, updated_at

  var id;
  var name;
  var admin;
  var description;
  var created_at;
  var updated_at;

  Project(
      {this.id,
      this.name,
      this.admin,
      this.description,
      this.created_at,
      this.updated_at});

  factory Project.fromJson(Map json) {
    return Project(
      id: json['id'].toString(),
      name: json['name'].toString(),
      admin: json['admin'].toString(),
      description: json['description'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString()

    );
  }
}
