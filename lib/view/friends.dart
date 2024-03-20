import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/view/chat.dart';

class Friends extends StatelessWidget {
  const Friends({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Friends",
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 185, 205, 205),
        ),
        body: Row(
          children: [
            // Left column
            const SideBar(),
            // Right column with top margin
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0), 
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1585,
                      child: GestureDetector(
                        onTap: () {
                          _showAddFriendPopup(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 5), 
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.black, width: 1),
                              bottom: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person_add),
                              SizedBox(width: 15),
                              Text(
                                'Add Friend',
                                style: TextStyle(fontSize: 35),
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
                            20,
                            (index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChatPage(friendName: 'Friend ${index + 1}')),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(vertical: 5),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Color.fromARGB(255, 92, 92, 92), width: 1)),
                                  ),
                                  child: Text(
                                    'Friend ${index + 1}',
                                    style: const TextStyle(fontSize: 25), // Increased font size
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
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String friendName = '';
        String friendEmail = '';

        return AlertDialog(
          title: const Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  friendName = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  friendEmail = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Implement add friend functionality
                // Add the friend with friendName and friendEmail
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
