import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:umate/fireDB_connect.dart';
import 'package:umate/model/user.dart';
import 'package:umate/model/message.dart';
import 'dart:async';

class ChatController {
  final fDB = FireDBInstance.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMessage(String friendEmail, String message) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userSnapshot = await fDB.collection('users').doc(user.email).get();
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final currentUser = UserT.fromJson(userData);
        final friendSnapshot = await fDB.collection('users').doc(friendEmail).get();
        if (friendSnapshot.exists) {
          final friendData = friendSnapshot.data() as Map<String, dynamic>;
          final friendUser = UserT.fromJson(friendData);
          final newMessage = Message(
            senderEmail: currentUser.email,
            senderUsername: currentUser.username,
            receiverEmail: friendUser.email,
            receiverUsername: friendUser.username,
            message: message,
            timestamp: Timestamp.now(),
          );
          await fDB
              .collection('users')
              .doc(user.email)
              .collection('chats')
              .doc(friendEmail)
              .collection('messages')
              .add(newMessage.toMap());
          await fDB
              .collection('users')
              .doc(friendEmail).
              collection('chats')
              .doc(user.email)
              .collection('messages')
              .add(newMessage.toMap());
        } else {
          throw Exception('Friend not found');
        }
      }
    }
  }

  Future <List<Message>> getMessages(String friendEmail) async {
    final user = _auth.currentUser;
    if (user != null) {
      final messages = await fDB
          .collection('users')
          .doc(user.email)
          .collection('chats')
          .doc(friendEmail)
          .collection('messages')
          .orderBy('timestamp')
          .get();
      return messages.docs.map((doc) => Message.fromMap(doc.data())).toList();
    } else {
      throw Exception('User not found');
    }
  }

  String? get currentUserEmail {
    final user = _auth.currentUser;
    return user?.email;
  }

  Stream<List<Message>> getMessagesStream(String friendEmail) {
    final user = _auth.currentUser;
    if (user != null) {
      return fDB
          .collection('users')
          .doc(user.email)
          .collection('chats')
          .doc(friendEmail)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data())).toList());
    } else {
      throw Exception('User not found');
    }
  }

  Future<void> deleteMessages(String friendEmail, String message) async {
    final user = _auth.currentUser;
    if (user != null) {
        final userRef = fDB.collection('users').doc(user.email).collection('chats').doc(friendEmail).collection('messages');
        final friendRef = fDB.collection('users').doc(friendEmail).collection('chats').doc(user.email).collection('messages');

        await fDB.runTransaction((transaction) async {
          final userSnapshot = await userRef.where('message', isEqualTo: message).get();
          final friendSnapshot = await friendRef.where('message', isEqualTo: message).get();

          for (var doc in userSnapshot.docs) {
            transaction.delete(doc.reference);
          }
          
          for (var doc in friendSnapshot.docs) {
            transaction.delete(doc.reference);
          }
        });
    } else {
        throw Exception('User not found');
    }
  }

}
