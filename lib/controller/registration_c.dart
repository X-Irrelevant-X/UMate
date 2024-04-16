import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:umate/view/login.dart';
import 'package:umate/model/user.dart';
import 'package:umate/fireDB_connect.dart';
import 'package:umate/view/home.dart';

class RegistrationController {
  final fDB = FireDBInstance.instance;
  Future<void> signUp(BuildContext context, UserT user) async {
    try {
      final UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password!,
      );

      print('Checking Credentials.....');
      print(credential.user!.uid);
      print(credential.user!.email);

      await fDB.collection('users').doc(credential.user!.email).set({
        'uid': credential.user!.uid,
        'username': user.username,
        'email': credential.user!.email,
      });

      final userRecord = FirebaseAuth.instance.currentUser;
      print('Current User: $userRecord');

      // final record = await pb.collection('users').create(body: user.toJson());
      // print(record);
      // await pb.collection('users').requestVerification(user.email);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
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
