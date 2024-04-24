import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/model/schedule_model.dart';
import 'package:umate/fireDB_connect.dart';

class ScheduleController {
 final fDB = FireDBInstance.instance;
 final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addSchdeule(ScheduleM schedule) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('schedules').doc(user.email).collection('userSchedules').add(schedule.toJson());
      upScheduleId();
    }
  }  

  Future<void> upScheduleId() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot = await fDB.collection('schedules').doc(user.email).collection('userSchedules').get();
      final sched =  snapshot.docs.map((doc) {
        return ScheduleM(
          sid: doc.id,
          title: doc['title'],
          room: doc['room'],
          from: doc['from'],
          to: doc['to'],
          day: doc['day'],
        );
      }).toList();
      final usid = sched[0].sid;
      final scheduled = ScheduleM(
        sid: sched[0].sid,
        title: sched[0].title,
        room: sched[0].room,
        from: sched[0].from,
        to: sched[0].to,
        day: sched[0].day,
      );
      updateSchedule(usid!, scheduled);
    }
  }

  Future<Stream<List<ScheduleM>>> getSchedules() async {
    final user = _auth.currentUser;
    if (user != null) {
      final schedule = fDB
          .collection('schedules')
          .doc(user.email)
          .collection('userSchedules')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => ScheduleM.fromJson(doc.data(), doc.id)).toList());
      
      return schedule;
    } else {
      return Stream.value([]);
    }
  }

  Future<void> updateSchedule(String scheduleId, ScheduleM updatedSchedule) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('schedules').doc(user.email).collection('userSchedules').doc(scheduleId).update(updatedSchedule.toJson());
    }
  }

  Future<void> deleteSchedule({required String scheduleId}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await fDB.collection('schedules').doc(user.email).collection('userSchedules').doc(scheduleId).delete();
    }
  }

}