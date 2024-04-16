import 'dart:io';
//import 'package:umate/fireDB_connect.dart';
//final fDB = FireDBInstance.instance;


class UserT {
  String email;
  String? token;
  String? uid;
  File? avatar;
  String? avatarurl;
  String? name;
  String? gender;
  String? username;
  String? password;

  UserT({
    required this.email,
    this.token,
    this.uid,
    this.avatar,
    this.avatarurl,
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
      'avatarurl': avatarurl,
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
      avatarurl: json['avatarurl'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
    );
  }
}