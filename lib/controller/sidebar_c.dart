import 'package:flutter/material.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/fireDB_connect.dart';

class SidebarController {
 final fDB = FireDBInstance.instance;

 Future<void> fetchUser(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final fetchedUserRecord = await fDB.collection('users').doc(user.email).get();
        final fetchedUserData = fetchedUserRecord.data();
        final fUser = UserT.fromJson(fetchedUserData!);

        print(fUser);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(user: fUser)),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      }
    } catch (error) {
      print('Error Fetching User: $error');
    }
 }

 Future<void> navigateToPage(BuildContext context, Widget page) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LogIn()),
        );
      }
    } catch (error) {
      print('Navigation Error: $error');
    }
 }
}
