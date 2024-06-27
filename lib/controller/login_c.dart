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

    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User with email not found'),
            backgroundColor: Colors.red[300],
          ),
        );
      } else if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Email and Password don't match"),
            backgroundColor: Colors.red[300],
          ),
        );
      } else {
        print('Error occurred during login: $error');
      }
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
      MaterialPageRoute(builder: (context) => const LogIn()),
    );
  }
}
