import 'package:cloud_firestore/cloud_firestore.dart';

class FireDBInstance {
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;

  static FirebaseFirestore get instance => _instance;
}
