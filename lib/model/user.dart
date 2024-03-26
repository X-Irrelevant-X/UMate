import 'dart:io';

class User {
  File? profilePicture;
  String? name;
  String username;
  String email;
  String password;
  String passwordConfirm;

  User({
    this.profilePicture,
    this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      passwordConfirm: json['passwordConfirm'],
    );
  }
}
