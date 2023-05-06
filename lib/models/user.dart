import 'package:flutter/material.dart';
import 'package:tcc_front/models/activity.dart';
import 'package:tcc_front/models/project.dart';

import 'company.dart';

class User {
  var id;
  var email;
  var name;
  var working;
  var created_at;
  var updated_at;
  var avatar;
  var avatar_url;
  var token;
  var refresh_token;
  var error_message;
  var open_activity;
  List <CompanyInfo> company_list =[];
  List<ProjectInfo> projectsList = [];
  List<Activity> activitiesList =[];

  User(
      {@required this.id,
      @required this.email,
      @required this.name,
      this.working,
      this.created_at,
      this.updated_at,
      this.avatar,
      this.avatar_url,
      @required this.token,
      this.refresh_token,
      this.error_message = '',
      this.open_activity = 0
      });
      
      factory User.fromJson(Map json) {
        return User(
          id: json['id'].toString(),
          name: json['name'].toString(),
          email: json['email'].toString(),
          working: json['working'].toString(),
          avatar: json['avatar'].toString(),
    );
  }
}
