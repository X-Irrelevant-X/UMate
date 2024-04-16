import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:umate/model/user.dart';
import 'package:umate/fireDB_connect.dart';

class ProfileController {
  final fDB = FireDBInstance.instance;
  final _storage = FirebaseStorage.instance;

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      String fileName = basename(imageFile.path);
      Reference reference = _storage.ref().child('profile_pictures/$fileName');
      UploadTask uploadTask = reference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }

  Future<bool> updateProfile(String email, UserT updatedUser) async {
    try {
      if (updatedUser.avatar != null) {
        String? imageUrl = await uploadImageToStorage(updatedUser.avatar!);
        updatedUser.avatarurl = imageUrl;
      }
      await fDB.collection('users').doc(email).update({
        'username': updatedUser.username,
        'name': updatedUser.name,
        'gender': updatedUser.gender,
        'avatarurl': updatedUser.avatarurl,
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
