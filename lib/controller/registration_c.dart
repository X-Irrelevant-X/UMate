import 'package:flutter/material.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/view/login.dart';
import 'package:pocketbase/pocketbase.dart';

final pb = PocketBase('http://10.0.2.2:8090/');

class RegistrationController {
  Future<String?> signUp(BuildContext context, User user) async {
    try {
      if (user.username.isEmpty ||
          user.email.isEmpty ||
          user.password.isEmpty ||
          user.passwordConfirm.isEmpty) {
        return 'All fields are required.';
      }

      if (user.password != user.passwordConfirm) {
        return "Passwords don't match.";
      }

      final record = await pb.collection('users').create(body: user.toJson());
      print(record);
      await pb.collection('users').requestVerification(user.email);

      //final fetchedUserRecord = await pb.collection('users').getOne(record.id);
      //final fetchedUserData = fetchedUserRecord.toJson();
      //final fetchedUser = User.fromJson(fetchedUserData);

      //Navigator.push(
      //  context,
      //  MaterialPageRoute(builder: (context) => ProfilePage(user: fetchedUser)),
      //);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogIn()),
      );

      return null;
    } catch (error) {
      print('Error occurred during registration: $error');
      return 'Username or Email already taken';
    }
  }

  void navigateToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }
}
