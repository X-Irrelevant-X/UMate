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

        print(fUser.email);
        print(fUser.uid);
        print(fUser.avatarurl);

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
  Future<UserT> getUserSide(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
        try {
          final fetchedUserRecord = await fDB.collection('users').doc(user.email).get();
          final fetchedUserData = fetchedUserRecord.data();
          final sUser = UserT.fromJson(fetchedUserData!);

          final String email = sUser.email;
          final String avatarUrl = sUser.avatarurl!;
          final String username = sUser.username!;

          final UserT userDetails = UserT(email: email, avatarurl: avatarUrl, username: username);

          return userDetails;
        } catch (error) {
          print('Error fetching user details: $error');
          throw Exception('Failed to fetch user details');
        }
    } else {
        throw Exception('User not logged in');
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
