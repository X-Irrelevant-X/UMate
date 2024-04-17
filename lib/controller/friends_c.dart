import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/fireDB_connect.dart';
import 'package:umate/model/user.dart';

class FriendsController {
  final fDB = FireDBInstance.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addFriend(String friendUsername, String friendEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userSnapshot = await fDB.collection('users').doc(user.email).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final currentUser = UserT.fromJson(userData);
        final friendSnapshot = await fDB.collection('users').doc(friendEmail).get();
        if (friendSnapshot.exists) {
          await fDB.collection('users').doc(friendEmail).collection('friends').doc(user.email).set({
            'username': friendUsername,
            'email': friendEmail,
          });
          await fDB.collection('users').doc(user.email).collection('friends').doc(friendEmail).set({
            'username': currentUser.username ?? '',
            'email': user.email ?? '',
          });
        } else {
          throw Exception('Friend not found');
        }
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchFriends() async {
    final user = _auth.currentUser;
    List<Map<String, dynamic>> friendsData = [];

    if (user != null) {
      final snapshot = await fDB.collection('users').doc(user.email).collection('friends').get();

      for (final doc in snapshot.docs) {
        final friendEmail = doc.id;
        final friendSnapshot = await fDB.collection('users').doc(friendEmail).get();
        final friendData = friendSnapshot.data();
        if (friendData != null) {
          friendsData.add({
            'username': friendData['username'],
            'email': friendData['email'],
          });
        }
      }

      return friendsData;
    }
    return [];
  }

  Future<void> deleteFriend(String friendEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('users').doc(user.email).collection('friends').doc(friendEmail).delete();
      await fDB.collection('users').doc(friendEmail).collection('friends').doc(user.email).delete();
    }
  }

}
