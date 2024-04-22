// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/controller/chat_c.dart';
import 'package:umate/model/message.dart';

class ChatPage extends StatefulWidget {
  final String friendName;
  final String friendEmail;

  const ChatPage({super.key, required this.friendName, required this.friendEmail});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  List<Message> _messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
        super.initState();
        _fetchMessages();
  }

  Future<void> _fetchMessages() async {
      final messages = await _chatController.getMessages(widget.friendEmail);
      setState(() {
        _messages = messages;
      });
  }

  Future<void> _sendMessage() async {
      final message = _messageController.text;
      if (message.isNotEmpty) {
        await _chatController.addMessage(widget.friendEmail, message);
        _messageController.clear();
      }
  }

  Future<void> _deleteMessage(String message) async {
    await _chatController.deleteMessages(widget.friendEmail, message);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.friendName,
            style: const TextStyle(fontSize: 30),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {

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

        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Message>>(
                stream: _chatController.getMessagesStream(widget.friendEmail),
                builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final messages = snapshot.data ?? [];
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return _buildChatMessage(message: message);
                      },
                    );
                },
              ),
            ),
            _buildInputField(),
          ],
        ),
      );
  }

  Widget _buildChatMessage({required Message message}) {
    final isMe = message.senderEmail == _chatController.currentUserEmail;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isMe)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Message'),
                        content: Text('Are you sure you want to delete this message?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteMessage(message.message!);
                              Navigator.of(context).pop();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? Colors.blue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(message.message!),
            ),
          ],
        ),
    );
    }

 Widget _buildInputField() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                 hintText: "Type a message",
                 border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      );
 }
}