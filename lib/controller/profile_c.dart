import 'package:umate/model/user.dart';
import 'package:umate/pb_connect.dart';

class ProfileController {
  final pb = PocketBaseInstance.instance;
  Future<bool> updateProfile(recordId, User updatedUser) async {
    try {
      final body = updatedUser.toJson();
      // final body = <String, dynamic>{
      //   "id": updatedUser.id,
      //   "username": updatedUser.username,
      //   "name": updatedUser.name,
      //   "email": updatedUser.email,
      //   "password": updatedUser.password,
      //   "passwordConfirm": updatedUser.passwordConfirm,
      // };
      // print(updatedUser.id);
      // print(updatedUser.name);
      // print(body);
      await pb.collection('users').update(recordId, body: body);
      print(updatedUser.name);
      return true;
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  Future<void> passwordReset(email) {
    return pb.collection('users').requestPasswordReset(email);
  }

  Future<void> deleteAccount(userId) async {
    try {
      await pb.collection('users').delete(userId);
    } catch (error) {
      throw Exception('Failed to delete account: $error');
    }
  }
}
