import 'package:flutter/material.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/pb_connect.dart';
import 'package:umate/view/login.dart';

class SidebarController {
  final pb = PocketBaseInstance.instance;

  bool get isAuth {
    return pb.authStore.isValid && pb.authStore.token.isNotEmpty;
  }

  Future<void> fetchUser(BuildContext context) async {
    try {
      print(pb.authStore.isValid);
      print(pb.authStore.token);

      if (isAuth) {
        final uId = (pb.authStore.model.id).toString();
        final fetchedUserRecord = await pb.collection('users').getOne(uId);
        final fetchedUserData = fetchedUserRecord.toJson();
        final fUser = User.fromJson(fetchedUserData);

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
      if (isAuth) {
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
