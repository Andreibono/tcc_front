import 'package:tcc_front/models/user.dart';

class UserList {
  var role;
  var user;

  UserList({
this.role,this.user
  });

  factory UserList.fromJson(Map json) {
    return UserList(
      role: json['role_user'].toString(),
      user: User.fromJson(json['user']),
    );
  }
}