import 'package:flutter/material.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/pb_connect.dart';

class SidebarController {
  final pb = PocketBaseInstance.instance;

  bool get isAuth {
    return pb.authStore.isValid && pb.authStore.token.isNotEmpty;
  }

  Future<void> fetchUser(BuildContext context) async {
    try {
      print(pb.authStore.isValid);
      print(pb.authStore.token);

      final uId = (pb.authStore.model.id).toString();
      final fetchedUserRecord = await pb.collection('users').getOne(uId);
      final fetchedUserData = fetchedUserRecord.toJson();
      final fUser = User.fromJson(fetchedUserData);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: fUser)),
      );
    } catch (error) {
      print('Error Fetching User: $error');
    }
  }
}