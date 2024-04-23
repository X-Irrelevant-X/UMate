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

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: friendsController.fetchFriends(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final friends = snapshot.data!;
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 80, 
                  child: ListTile(
                      leading: friend['avatarurl'] != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey,
                            child: ClipOval(
                              child: Image.network(
                                friend['avatarurl'],
                                width: 50,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 50, 
                            child: Icon(Icons.person),
                          ),
                      
                      title: Text(
                        friend['username'] ?? '',
                        style: TextStyle(fontSize: 22),
                        textAlign: TextAlign.center, 
                      ),
                      subtitle: Text(
                        friend['email'] ?? '',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatPage(friend: friend),)
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
                                        setState(() {});
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
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFriendPopup(context);
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
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
