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

      // if (isAuth) {
      //   final uId = (pb.authStore.model.id).toString();
      //   final fetchedUserRecord = await pb.collection('users').getOne(uId);
      //   final fetchedUserData = fetchedUserRecord.toJson();
      //   final fetchedUser = User.fromJson(fetchedUserData);

      //   await _saveSessionData(pb.authStore.token, uId, fetchedUser.username);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const HomePage(),
        //     )
        // );
      // }
    } catch (error) {
      print('Error occurred during login: $error');
    }
  }

  Future<void> resertPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (error) {
      print('Error occurred during password reset: $error');
      // showDialog(
      //   context: context, 
      //   builder: (context) {
      //     return AlertDialog(
      //       content: Text(error.message.toString()),
      //     );
      //   }
      // );
    }
  }

  // Future<void> _saveSessionData(
  //     String token, String uId, String username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString(PrefKeys.accessTokenPrefsKey, token);
  //   prefs.setString(PrefKeys.accessModelPrefsKey, uId);
  //   prefs.setString(PrefKeys.accessUsernamePrefsKey, username);
  // }

  Future<void> logout(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    // final prefs = await SharedPreferences.getInstance();
    // prefs.remove(PrefKeys.accessTokenPrefsKey);
    // prefs.remove(PrefKeys.accessModelPrefsKey);
    // prefs.remove(PrefKeys.accessUsernamePrefsKey);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }
}
