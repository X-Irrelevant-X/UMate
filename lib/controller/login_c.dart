import 'package:flutter/material.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/fireDB_connect.dart';

class LoginController {
  final fDB = FireDBInstance.instance;
  Future<void> login(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password
      );

      Navigator.push(
        context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          )
      );

    } catch (error) {
      print('Error occurred during login: $error');
    }
  }

  Future<void> resertPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      print('Error occurred during password reset: $error');
      
    }
  }

  Future<void> logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }
}
