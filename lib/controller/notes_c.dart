import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/model/note_model.dart';
import 'package:umate/fireDB_connect.dart';

class NoteController {
 final fDB = FireDBInstance.instance;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addNote(NoteM note) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('notes').doc(user.email).collection('userNotes').add(note.toJson());
      upNoteId();
    }
  }  

  Future<void> upNoteId() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await fDB.collection('notes').doc(user.email).collection('userNotes').get();
      final noted =  snapshot.docs.map((doc) {
        return NoteM(
          nid: doc.id,
          title: doc['title'],
          body: doc['body'],
          date: doc['date'],
        );
      }).toList();
      final unid = noted[0].nid;
      final anoted = NoteM(
        nid: noted[0].nid,
        title: noted[0].title,
        body: noted[0].body,
        date: noted[0].date,
      );
      updateNote(unid!, anoted);
    }
  }

  Future<Stream<List<NoteM>>> getNotes() async {
    final user = _auth.currentUser;
    if (user != null) {
      final note = fDB
          .collection('notes')
          .doc(user.email)
          .collection('userNotes')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => NoteM.fromJson(doc.data(), doc.id)).toList());
      
      return note;
    } else {
      return Stream.value([]);
    }
  }

  // Future<void> starStatus({required String noteId, required bool isStarred}) async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     await fDB.collection('notes').doc(user.email).collection('userNotes').doc(note.nid).update({
  //       'star': note.star == 'yes' ? 'no' : 'yes',
  //     });
  //   }
  // }

  Future<void> updateNote(String noteId, NoteM updatedNote) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('notes').doc(user.email).collection('userNotes').doc(noteId).update(updatedNote.toJson());
    }
  }

  Future<void> deleteNote({required String noteId}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('notes').doc(user.email).collection('userNotes').doc(noteId).delete();
    }
  }

}
