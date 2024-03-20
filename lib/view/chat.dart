import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart'; // Import your sidebar file

class ChatPage extends StatelessWidget {
  final String friendName;

  const ChatPage({super.key, required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          friendName,
          style: const TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
      ),
      body: Row(
        children: [
          // Left column
          const SideBar(), // Assuming this is your sidebar widget

          // Right column
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      // Dummy chat messages for demonstration
                      _buildChatMessage(isMe: false, message: 'Hello!'),
                      _buildChatMessage(isMe: true, message: 'Hi! How are you?'),
                      _buildChatMessage(isMe: false, message: 'I\'m doing well. Thanks!'),
                    ],
                  ),
                ),
                _buildInputField(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatMessage({required bool isMe, required String message}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: TextStyle(fontSize: 16, color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // Handle file sharing
            },
            icon: const Icon(Icons.attach_file),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle sending message
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}

