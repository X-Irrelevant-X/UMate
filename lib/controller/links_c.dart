import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/model/link_model.dart';
import 'package:umate/fireDB_connect.dart';

class LinkController {
  final fDB = FireDBInstance.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addLink(LinkM link) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('links').doc(user.email).collection('userLinks').add(link.toJson());
      upLinkId();
    }
  }

  Future<void> upLinkId() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await fDB.collection('links')
      .doc(user.email).collection('userLinks').get();

      final linked =  snapshot.docs.map((doc) {
        return LinkM(
          lid: doc.id,
          linkName: doc['linkName'],
          linkUrl: doc['linkUrl'],
        );
      }).toList();
      final ulid = linked[0].lid;
      final alinked = LinkM(
        lid: linked[0].lid,
        linkName: linked[0].linkName,
        linkUrl: linked[0].linkUrl,
      );
      updateLink(ulid!, alinked);
    }
  }

  Future<void> updateLink(String linkId, LinkM updatedLink) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('links')
      .doc(user.email).collection('userLinks')
      .doc(linkId).update(updatedLink.toJson());
    }
  }

  Future<Stream<List<LinkM>>> getLinks() async {
    final user = _auth.currentUser;
    if (user != null) {
      final link = fDB
          .collection('links')
          .doc(user.email)
          .collection('userLinks')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => LinkM.fromJson(doc.data(), doc.id)).toList());
      
      return link;
    } else {
      return Stream.value([]);
    }
  }

  Future<void> deleteLink({required String linkId}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('links').doc(user.email).collection('userLinks').doc(linkId).delete();
    }
  }

}