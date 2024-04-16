import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/model/note_model.dart';
import 'package:umate/fireDB_connect.dart';

class HomeController {
  final fDB = FireDBInstance.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<NoteM>> getStarredNotes() async {
    final user = _auth.currentUser;
    if (user != null) {
        final snapshot = await fDB.collection('notes').doc(user.email).collection('starredNotes').get();
        final noted = snapshot.docs.map((doc) {
          return NoteM(
            nid: doc.id,
            title: doc['title'],
            body: doc['body'],
            date: doc['date'],
          );
        }).toList();
        return noted; 
    } else {
        return []; 
    }
  }


  Future<void> unStarNote(NoteM note) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('notes').doc(user.email).collection('starredNotes').doc(note.nid).delete();
    }
  }
}