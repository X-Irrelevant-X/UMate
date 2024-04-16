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
                                              icon: Icon(Icons.star),
                                              tooltip: 'Star',
                                              onPressed: () {
                                                NoteController().starNote(note);
                                              },
                                            ),
                                            Text('Star'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0), 
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit),
                                              tooltip: 'Edit',
                                              onPressed: () {
                                                _showEditNotePopup(context, note.nid!, note);
                                              },
                                            ),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0), 
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.delete),
                                              tooltip: 'Delete',
                                              onPressed: () {
                                                noteController.deleteNote(noteId: note.nid!);
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
                decoration: const InputDecoration(labelText: 'Title: '),
                onChanged: (value) {
                  noteTitle = value;
                },
              ),
              TextFormField(
                initialValue: noteBody,
                decoration: const InputDecoration(labelText: 'Note: '),
                maxLines: 5,
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
                decoration: const InputDecoration(labelText: 'Title: '),
                onChanged: (value) {
                 noteTitle = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Body: '),
                maxLines: 5,
                onChanged: (value) {
                 noteBody = value;
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
                final newNote = NoteM(title: noteTitle, body: noteBody, date: noteDate);
                noteController.addNote(newNote);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
