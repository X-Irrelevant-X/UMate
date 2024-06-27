// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/model/schedule_model.dart';
import 'package:umate/controller/schedule_c.dart';

class SchedulePlanning extends StatefulWidget {
  const SchedulePlanning({super.key});

  @override
  SchedulePlanningState createState() => SchedulePlanningState();
}

class SchedulePlanningState extends State<SchedulePlanning> {
  ScheduleController scheduleControl = ScheduleController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Schedule Planning",
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
      
      body: FutureBuilder<Stream<List<ScheduleM>>>(
        future: scheduleControl.getSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            const List<String> dayOrder = ["Saturday", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"];
            return StreamBuilder<List<ScheduleM>>(
              stream: snapshot.data,
              builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  
                  final sortedSchedules = List<ScheduleM>.from(snapshot.data!);
                  sortedSchedules.sort((a, b) {
                    final indexA = dayOrder.indexOf(a.day!);
                    final indexB = dayOrder.indexOf(b.day!);
                    if (indexA != indexB) {
                      return indexA.compareTo(indexB);
                    }
                    
                    final timeA = DateTime.parse("1970-01-01T${a.from!.replaceAll('.', ':')}:00");
                    final timeB = DateTime.parse("1970-01-01T${b.from!.replaceAll('.', ':')}:00");

                    return timeA.compareTo(timeB);
                  });

                  return ListView.builder(
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
                                  Text(schedule.day!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 20),
                                ],
                              ),

                              SizedBox(width: 10),
                              
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Task: ${schedule.title!}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Place: ${schedule.room!}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10),
                                      Text('Time: ${schedule.from!} - ${schedule.to!}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ],
                          ),

                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10.0), 
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                tooltip: 'Delete',
                                                onPressed: () {
                                                  scheduleControl.deleteSchedule(scheduleId: schedule.sid!);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddSchedulePopup(context);
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
      ),
    );
  }

  void showAddSchedulePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String room = '';
        String from = '';
        String to = '';
        String day = '';

        return AlertDialog(
          title: const Text('Add Schedule'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Task: '),
                onChanged: (value) {
                 title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Place: '),
                onChanged: (value) {
                 room = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'From: ',
                  hintText: '12.00',
                ),
                onChanged: (value) {
                 from = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'To: ',
                  hintText: '2.00',
                ),
                onChanged: (value) {
                 to = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Day: ',
                  hintText: 'Friday',
                ),
                onChanged: (value) {
                 day = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                List<String> validDays = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

                double? fromValue = double.tryParse(from);
                double? toValue = double.tryParse(to);

                if (title.isEmpty) {
                  showErrorPopup(context, 'Title is missing');
                } else if (room.isEmpty) {
                  showErrorPopup(context, 'Room is missing');
                } else if (fromValue == null || fromValue < 1.0 || fromValue > 12.0) {
                  showErrorPopup(context, 'From time should be between 1.00 and 12.00');
                } else if (toValue == null || toValue < 1.0 || toValue > 12.0) {
                  showErrorPopup(context, 'To time should be between 1.00 and 12.00');
                } else if (!validDays.contains(day.toLowerCase())) {
                  showErrorPopup(context, 'Day is incorrect');
                } else {
                  final newSchedule = ScheduleM(
                    title: title,
                    room: room,
                    from: from,
                    to: to,
                    day: day
                  );
                  scheduleControl.addSchdule(newSchedule);
                  Navigator.pop(context);
                }

              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}


void showErrorPopup(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK', style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}
