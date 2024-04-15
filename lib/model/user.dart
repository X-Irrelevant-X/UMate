//import 'package:umate/fireDB_connect.dart';

//final fDB = FireDBInstance.instance;

class UserT {
  String email;
  String? token;
  String? uid;
  String? avatar;
  String? name;
  String? gender;
  String? username;
  String? password;

  UserT({
    required this.email,
    this.token,
    this.uid,
    this.avatar,
    this.name,
    this.gender,
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'token': token,
      'uid': uid,
      'avatar': avatar,
      'name': name,
      'gender': gender,
      'username': username,
      'password': password,
    };
  }

  static UserT fromJson(Map<String, dynamic> json) {
    return UserT(
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      uid: json['uid'] ?? '',
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}