import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? senderEmail;
  String? senderUsername;
  String? receiverEmail;
  String? receiverUsername;
  String? message;
  Timestamp? timestamp;

  Message({
    this.senderEmail,
    this.senderUsername,
    this.receiverEmail,
    this.receiverUsername,
    this.message,
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'senderUsername': senderUsername,
      'receiverEmail': receiverEmail,
      'receiverUsername': receiverUsername,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderEmail: map['senderEmail'],
      senderUsername: map['senderUsername'],
      receiverEmail: map['receiverEmail'],
      receiverUsername: map['receiverUsername'],
      message: map['message'],
      timestamp: map['timestamp'],
    );
  }

}