import 'package:flutter/material.dart';
import 'package:umate/view/home.dart';
import 'package:umate/view/sidebar.dart';

class AdvisingPlanning extends StatelessWidget {
  const AdvisingPlanning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Advising Planning",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 185, 205, 205),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Row(
          children: [
            // Left column
            const SideBar(),
            // Right column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.153,
                    child: GestureDetector(
                      onTap: () {
                        _showAddCoursePopup(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.black, width: 1),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_circle),
                            SizedBox(width: 10),
                            Text(
                              'Add Course',
                              style: TextStyle(fontSize: 21),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          7,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                _showDayPlan(context, index + 1);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(25),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey, width: 2)),
                                ),
                                child: Text(
                                  '${_getWeekdayName(index + 1)} - ',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCoursePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String course = '';

        return AlertDialog(
          title: const Text('Add Course'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Course'),
                onChanged: (value) {
                  course = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addCourse(context, course);
              },
              child: const Text('Add'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addCourse(BuildContext context, String course) {
    // Implement adding the course
    Navigator.pop(context); // Close the Add Course popup
  }

  void _showDayPlan(BuildContext context, int day) {
    // Implement showing day plan
  }

  String _getWeekdayName(int day) {
    switch (day) {
      case 1:
        return 'Saturday';
      case 2:
        return 'Sunday';
      case 3:
        return 'Monday';
      case 4:
        return 'Tuesday';
      case 5:
        return 'Wednesday';
      case 6:
        return 'Thursday';
      case 7:
        return 'Friday';
      default:
        return '';
    }
  }
}

void main() {
  runApp(const AdvisingPlanning());
}

