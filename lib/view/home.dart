import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/model/note_model.dart';
import 'package:umate/model/schedule_model.dart';
import 'package:umate/controller/home_c.dart';
import 'package:umate/controller/schedule_c.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HomeController homeController = HomeController();
  final ScheduleController scheduleCon = ScheduleController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UMate',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const SideBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 5,),
            const Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Marked Notes',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 5,),
            FutureBuilder(
              future: homeController.getStarredNotes(),
              builder: (BuildContext context, AsyncSnapshot<List<NoteM>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final starredNotes = snapshot.data!;
                  if (starredNotes.isEmpty) {
                    return Text('No Marked Notes found.');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: starredNotes.length,
                      itemBuilder: (context, index) {
                        final note = starredNotes[index];
                        return GestureDetector(
                          onLongPress: () {
                            showUnstarDialog(context, note);
                          },
                          child: NoteTile(note: note),
                        );
                      },
                    );
                  }
                }
              },
            ),
            const SizedBox(height: 50),
            const Divider(thickness: 5,),
            const Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Today\'s Schedule:',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 5,),
            FutureBuilder<Stream<List<ScheduleM>>>(
              future: scheduleCon.getSchedules(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final currentWeekday = DateFormat('EEEE').format(DateTime.now());

                  return StreamBuilder<List<ScheduleM>>(
                    stream: snapshot.data,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      final schedules = snapshot.data!.where((schedule) => schedule.day == currentWeekday).toList();

                      if (schedules.isEmpty) {
                        return Text('No schedules for today.');
                      }

                      final sortedSchedules = schedules..sort((a, b) {
                        final timeA = DateTime.parse("1970-01-01T${a.from!.replaceAll('.', ':')}:00");
                        final timeB = DateTime.parse("1970-01-01T${b.from!.replaceAll('.', ':')}:00");

                        return timeA.compareTo(timeB);
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: sortedSchedules.length,
                        itemBuilder: (context, index) {
                          final schedule = sortedSchedules[index];
                          return SizedBox(
                            height: 120,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(schedule.day!, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 20),
                                      ],
                                    ),

                                    SizedBox(width: 10),

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Task: ${schedule.title!}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                            SizedBox(width: 20),
                                            Text('Place: ${schedule.room!}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Time: ${schedule.from!} - ${schedule.to!}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void showUnstarDialog(BuildContext context, NoteM note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Unstar Note'),
          content: const Text('Are you sure you want to unstar this note?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await homeController.unStarNote(note);
                Navigator.pop(context);
                refreshNotes();
              },
              child: const Text('Unstar'),
            ),
          ],
        );
      },
    );
  }

  void refreshNotes() {
    setState(() {});
  }
}

class NoteTile extends StatelessWidget {
  final NoteM note;

  const NoteTile({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('hh:mm:ss a dd-MM-yyyy').parseStrict(note.date!);
    final time = DateFormat('hh:mm a dd/MM/yyyy').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(note.title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(time, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                note.body!,
                style: TextStyle(fontSize: 15),
                maxLines: 5, 
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
