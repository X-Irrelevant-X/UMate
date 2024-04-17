import 'package:flutter/material.dart';
import 'package:umate/controller/friends_c.dart';
import 'package:umate/view/chat.dart';
import 'package:umate/view/sidebar.dart';

class Friends extends StatefulWidget {
 const Friends({Key? key}) : super(key: key);

 @override
 _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
 final FriendsController friendsController = FriendsController();

 @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddFriendPopup(context);
            },
          ),
        ],
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

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: friendsController.fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final friends = snapshot.data!;
            print(friends);
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  title: Text(friend['username'] ?? ''),
                  subtitle: Text(friend['email'] ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(friendName: friend['username'] ?? '',friendEmail: friend['email'] ?? '',)),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Delete Friend'),
                            content: Text('Are you sure you want to remove this friend?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); 
                                  friendsController.deleteFriend(friend['email'] ?? '').then((_) {
                                    setState(() {}); // Update the UI
                                  });
                                },
                                child: Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
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
          }
        },
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
                decoration: const InputDecoration(labelText: 'Username: '),
                onChanged: (value) {
                 friendName = value;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email: '),
                onChanged: (value) {
                 friendEmail = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                friendsController.addFriend(friendName, friendEmail).then((_) {
                 Navigator.pop(context); 
                 setState(() {});
                }).catchError((error) {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding friend: $error')));
                });
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
