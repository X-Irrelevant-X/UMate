import 'package:flutter/material.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/view/login.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://10.0.2.2:8090/');

class RegistrationController {
  Future<void> signUp(BuildContext context, User user) async {
    try {
      if (user.username.isEmpty || user.email.isEmpty || user.password.isEmpty || user.passwordConfirm.isEmpty) {
        throw Exception('All fields are required.');
      }

      if (user.password != user.passwordConfirm) {
        throw Exception("Passwords don't match.");
      }

      final record = await pb.collection('users').create(body: user.toJson());
      print(record);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );  
    } catch (error) {
      print('Error occurred during registration: $error');
    }
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }
}
