import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/fireDB_connect.dart';
import 'package:umate/model/user.dart';

class ChatController {
  final fDB = FireDBInstance.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

}