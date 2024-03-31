import 'package:pocketbase/pocketbase.dart';

class PocketBaseInstance {
  static final PocketBase _instance = PocketBase('http://10.0.2.2:8090');

  static PocketBase get instance => _instance;
}
