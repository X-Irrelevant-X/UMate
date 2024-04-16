import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/controller/notes_c.dart';
import 'package:umate/model/note_model.dart';

class Notes extends StatelessWidget {
 final NoteController noteController;

 Notes({required this.noteController});

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(fontSize: 30),
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
      body: FutureBuilder<Stream<List<NoteM>>>(
        future: noteController.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return StreamBuilder<List<NoteM>>(
              stream: snapshot.data,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                 return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                 return CircularProgressIndicator();
                }
                return ListView.builder(
                 itemCount: snapshot.data!.length,
                 itemBuilder: (context, index) {
                    final note = snapshot.data![index];
                    return ListTile(
                      title: Text(note.title!),
                      subtitle: Text(note.body!),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Choose an action'),
                              actions: <Widget>[
                                TextButton(
                                 child: Text('Edit'),
                                 onPressed: () {
                                    _showEditNotePopup(context, note.nid!, note);
                                    //Navigator.pop(context);
                                 },
                                ),
                                TextButton(
                                 child: Text('Delete'),
                                 onPressed: () {
                                    noteController.deleteNote(noteId: note.nid!);
                                    Navigator.pop(context);
                                 },
                                ),
                              ],
                            );
                          },
                        );
                      },
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
          _showAddNotePopup(context);
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
      ),
    );
 }

  void _showEditNotePopup(BuildContext context, String noteId, NoteM note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteTitle = note.title ?? '';
        String noteBody = note.body ?? '';

        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: noteTitle,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) {
                  noteTitle = value;
                },
              ),
              TextFormField(
                initialValue: noteBody,
                decoration: const InputDecoration(labelText: 'Body'),
                onChanged: (value) {
                  noteBody = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final updatedNote = NoteM(nid: note.nid,title: noteTitle, body: noteBody, date: note.date);
                noteController.updateNote(noteId, updatedNote);
                Navigator.pop(context);
              },
              child: const Text('Save'),
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

 void _showAddNotePopup(BuildContext context) {
    final formattedDate = DateFormat('hh:mm:ss a dd-MM-yyyy').format(DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String noteTitle = '';
        String noteBody = '';
        String noteDate = formattedDate;

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
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newNote = NoteM(title: noteTitle, body: noteBody, date: noteDate);
                noteController.addNote(newNote);
                Navigator.pop(context);
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
}
