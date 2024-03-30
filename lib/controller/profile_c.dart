import 'package:pocketbase/pocketbase.dart';
import 'package:umate/model/user.dart';

final pb = PocketBase('http://10.0.2.2:8090');

class ProfileController {
  Future<bool> updateProfile(recordId, User updatedUser) async {
    try {
      final body = updatedUser.toJson();
      print(updatedUser.id);
      print(updatedUser.name);
      print(body);
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
