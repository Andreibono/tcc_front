import 'package:flutter/material.dart';
import 'package:tcc_front/models/project.dart';

class CompanyInfo {
  var id;
  var role_user;
  var created_at;
  var updated_at;
  var company;

  CompanyInfo(
      {this.id,
      this.role_user,
      this.created_at,
      this.updated_at,
      this.company});

  factory CompanyInfo.fromJson(Map json) {
    return CompanyInfo(
      id: json['id'].toString(),
      role_user: json['role_user'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
      company: Company.fromJson(json['company']),
    );
  }
}

class Company {
  var id;
  var cnpj;
  var fantasy;
  var logo;
  var codigo;
  var created_at;
  var updated_at;
  

  Company(
      {@required this.id,
      @required this.cnpj,
      @required this.fantasy,
      @required this.logo,
      @required this.codigo,
      @required this.created_at,
      @required this.updated_at});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'].toString(),
      cnpj: json['cnpj_cpf'].toString(),
      fantasy: json['fantasia'].toString(),
      logo: json['logo'].toString(),
      codigo: json['codigo'].toString(),
      created_at: json['created_at'].toString(),
      updated_at: json['updated_at'].toString(),
    );
  }
}
