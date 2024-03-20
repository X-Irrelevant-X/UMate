import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/view/home.dart';

class Notes extends StatelessWidget {
  final List<Map<String, String>> notes = [
    {'title': 'Note 1', 'body': 'This is the body of note 1', 'date': '2024-03-20'},
    {'title': 'Note 2', 'body': 'This is the body of note 2', 'date': '2024-03-21'},
    {'title': 'Note 3', 'body': 'This is the body of note 3', 'date': '2024-03-22'},
  ];

  Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Notes",
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
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.153,
                    child: GestureDetector(
                      onTap: () {
                        _showAddNotePopup(context);
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
                            Icon(Icons.note_add),
                            SizedBox(width: 10),
                            Text(
                              'Add Note',
                              style: TextStyle(fontSize: 25),
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
                          notes.length,
                          (index) {
                            return GestureDetector(
                              onTap: () {
                                _showNotePopup(context, notes[index]);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey, width: 3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          notes[index]['title']!,
                                          style: const TextStyle(fontSize: 25),
                                        ),
                                        if (notes[index]['expanded'] == 'true') ...[
                                          Text(
                                            notes[index]['body']!,
                                            style: const TextStyle(fontSize: 30),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      notes[index]['date']!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
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

  void _showAddNotePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteTitle = '';
        String noteBody = '';
        String noteDate = '';

        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  noteTitle = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Body'),
                onChanged: (value) {
                  noteBody = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                onChanged: (value) {
                  noteDate = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addNote(context, noteTitle, noteBody, noteDate);
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

  void _addNote(BuildContext context, String title, String body, String date) {
    notes.insert(0, {'title': title, 'body': body, 'date': date});
    Navigator.pop(context); // Close the Add Note popup
  }

  void _showNotePopup(BuildContext context, Map<String, String> note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(note['title']!),
          content: Text(note['body']!),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
