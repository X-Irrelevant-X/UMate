//@request.auth.id;
import 'dart:io';

class User {
  String? id;
  File? avatar;
  String? name;
  String username;
  String email;
  String password;
  String passwordConfirm;

  User({
    this.id,
    this.avatar,
    this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      //'avatar': avatar,
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      //avatar: json['avatar'] ?? '',
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      passwordConfirm: json['passwordConfirm'] ?? '',
    );
  }
}
