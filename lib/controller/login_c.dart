import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umate/model/user.dart';
import 'package:umate/model/pref_keys.dart';
import 'package:umate/view/home.dart';
import 'package:umate/view/login.dart';
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

      if (isAuth) {
        final uId = (pb.authStore.model.id).toString();
        final fetchedUserRecord = await pb.collection('users').getOne(uId);
        final fetchedUserData = fetchedUserRecord.toJson();
        final fetchedUser = User.fromJson(fetchedUserData);

        await _saveSessionData(pb.authStore.token, uId, fetchedUser.username);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      }
    } catch (error) {
      print('Error occurred during login: $error');
    }
  }

  Future<void> _saveSessionData(
      String token, String uId, String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(PrefKeys.accessTokenPrefsKey, token);
    prefs.setString(PrefKeys.accessModelPrefsKey, uId);
    prefs.setString(PrefKeys.accessUsernamePrefsKey, username);
  }

  Future<void> logout(BuildContext context) async {
    pb.authStore.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }
}
