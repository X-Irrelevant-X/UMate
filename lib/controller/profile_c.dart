import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/model/user.dart';
import 'package:umate/fireDB_connect.dart';

class ProfileController {
 final fDB = FireDBInstance.instance;

 Future<bool> updateProfile(String email, UserT updatedUser) async {
    try {
      await fDB.collection('users').doc(email).update({
        'username': updatedUser.username,
        'name': updatedUser.name,
        'gender': updatedUser.gender,
      });
      return true;
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
 }

 Future<void> deleteAccount(String email) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      await fDB.collection('users').doc(email).delete();
    } catch (error) {
      throw Exception('Failed to delete account: $error');
    }
 }
}
