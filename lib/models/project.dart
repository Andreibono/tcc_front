class ProjectInfo {
  //"per_page", "total", "current_page", "data":
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
  var companyProj;

  Project(
      {this.id,
      this.name,
      this.admin,
      this.description,
      this.created_at,
      this.updated_at,
      this.companyProj});

  factory Project.fromJson(Map json) {
    return Project(
        id: json['id'].toString(),
        name: json['name'].toString(),
        admin: json['admin'].toString(),
        description: json['description'].toString(),
        created_at: json['created_at'].toString(),
        updated_at: json['updated_at'].toString(),
        companyProj: CompanyProj.fromJson(json['company']));
  }
}

class CompanyProj {
  //"id", "fantasia", "cnpj_cpf", "logo", "codigo", "created_at","updated_at"
  var id;
  var fantasia;
  var cnpj_cpf;
  var logo;
  var codigo;
  var created_at;
  var updated_at;

  CompanyProj(
      {this.id,
      this.fantasia,
      this.cnpj_cpf,
      this.logo,
      this.codigo,
      this.created_at,
      this.updated_at});

  factory CompanyProj.fromJson(Map json) {
    return CompanyProj(
      id: json['id'].toString(),
      fantasia: json['fantasia'].toString(),
      cnpj_cpf: json['cnpj_cpf'].toString(),
      logo: json['logo'].toString(),
      codigo: json['codigo'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
    );
  }
}
