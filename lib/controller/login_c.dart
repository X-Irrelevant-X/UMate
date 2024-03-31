import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umate/model/user.dart';
import 'package:umate/model/pref_keys.dart';
import 'package:umate/view/profile.dart';
import 'package:umate/pb_connect.dart';

class LoginController {
  final pb = PocketBaseInstance.instance;

  bool get isAuth {
    return pb.authStore.isValid && pb.authStore.token.isNotEmpty;
  }

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final authData =
          await pb.collection('users').authWithPassword(email, password);
      print(pb.authStore.isValid);
      print(pb.authStore.token);
      print(pb.authStore.model.id);

      final uId = (pb.authStore.model.id)
          .toString(); //authData.record?.data['id'].toString() ?? "";
      final fetchedUserRecord = await pb.collection('users').getOne(uId);
      final fetchedUserData = fetchedUserRecord.toJson();
      final fetchedUser = User.fromJson(fetchedUserData);

      // Save user data to shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(PrefKeys.accessTokenPrefsKey, pb.authStore.token);
      prefs.setString(PrefKeys.accessModelPrefsKey, uId);
      prefs.setString(PrefKeys.accessUsernamePrefsKey, fetchedUser.username);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: fetchedUser)),
      );

      // // Create a User object from fetched user data
      // final user = User.fromJson(userData);

      // // Navigate to profile page with user object
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
      // );
    } catch (error) {
      print('Error occurred during login: $error');
    }
  }
}
