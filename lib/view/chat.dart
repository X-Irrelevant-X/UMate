// ignore_for_file: unused_field
import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/controller/chat_c.dart';
import 'package:umate/model/message.dart';
import 'package:umate/model/schedule_model.dart';
import 'package:intl/intl.dart';


class ChatPage extends StatefulWidget {
  final Map friend;

  const ChatPage({super.key, required this.friend});

  @override
  ChatPageState createState() => ChatPageState();

}

class ChatPageState extends State<ChatPage> {
  final ChatController _chatController = ChatController();
  final TextEditingController _messageController = TextEditingController();

  List<Message> _messages = [];
  String? selectedMessageId;

  @override
  void initState() {
        super.initState();
        _fetchMessages();
  }

  Future<void> _fetchMessages() async {
      final messages = await _chatController.getMessages(widget.friend['email']);
      setState(() {
        _messages = messages;
      });
  }

  Future<void> _sendMessage() async {
      final message = _messageController.text;
      if (message.isNotEmpty) {
        await _chatController.addMessage(widget.friend['email'], message);
        _messageController.clear();
      }
  }

  Future<void> _deleteMessage(String message) async {
    await _chatController.deleteMessages(widget.friend['email'], message);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.friend['username'],
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showFriendProfile(context);
              },
            ),
            SizedBox(width: 10),
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
                stream: _chatController.getMessagesStream(widget.friend['email']),
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
    return ChatMessageWidget(
        message: message,
        isMe: isMe,
        deleteMessage: (String message) {
          _deleteMessage(message);
        },
    );
  }

  Widget _buildInputField() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
            SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      );
  }

  void _showFriendProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(' '),
          content: _buildFriendProfile(context),
        );
      },
    );
  }

  void _showSchedulePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.9,
            ),
            child: ScheduleTile(friendEmail: widget.friend['email']),
          ),
        );
      },
    );
  }

  Widget _buildFriendProfile(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: CircleAvatar(
            radius: 70,
            backgroundColor: Colors.grey,
            child: ClipOval(
              child: Image.network(
                widget.friend['avatarurl'] ?? '',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
        ),
        SizedBox(height: 30),
        
        buildProfileRow("Username:", '${widget.friend['username'] ?? ''}'),
        buildProfileRow("Email:", '${widget.friend['email'] ?? ''}'),
        buildProfileRow("Name:", '${widget.friend['name'] ?? ''}'),
        buildProfileRow("Gender:", '${widget.friend['gender'] ?? ''}'),
        
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _showSchedulePopup,
            child: Text('Schedule'),
          ),
        ),

        SizedBox(height: 50),
      ],
    );
  }

  Widget buildProfileRow(String label, String value) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

}



class ChatMessageWidget extends StatefulWidget {
  final Message message;
  final bool isMe;
  final Function deleteMessage;

  const ChatMessageWidget({
      Key? key,
      required this.message,
      required this.isMe,
      required this.deleteMessage,
  }) : super(key: key);

  @override
  _ChatMessageWidgetState createState() => _ChatMessageWidgetState();

}

class _ChatMessageWidgetState extends State<ChatMessageWidget> {
  bool _showTimestamp = false;

  @override
  Widget build(BuildContext context) {
      final DateFormat formatter = DateFormat('hh:mm:ss a dd-MM-yyyy');
      final String formattedTimestamp = formatter.format(widget.message.timestamp!.toDate());

      return GestureDetector(
        onTap: () {
          setState(() {
            _showTimestamp = !_showTimestamp;
          });
        },
        child: Column(
          crossAxisAlignment: widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (widget.isMe)
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
                                  widget.deleteMessage(widget.message.message!);
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
                      color: widget.isMe ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(widget.message.message!),
                  ),
                ],
              ),
            ),
            if (_showTimestamp)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Text(
                  formattedTimestamp,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      );
  }
}

class ScheduleTile extends StatelessWidget {
  final ChatController chatCon = ChatController();
  final friendEmail;

  ScheduleTile({super.key, this.friendEmail});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Stream<List<ScheduleM>>>(
      future: chatCon.getFriendSchedules(friendEmail),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final currentWeekday = DateFormat('EEEE').format(DateTime.now());

          return StreamBuilder<List<ScheduleM>>(
            stream: snapshot.data,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final schedules = snapshot.data!.where((schedule) => schedule.day == currentWeekday).toList();

              if (schedules.isEmpty) {
                return Text('No schedules for today.');
              }

              final sortedSchedules = schedules..sort((a, b) {
                final timeA = DateTime.parse("1970-01-01T${a.from!.replaceAll('.', ':')}:00");
                final timeB = DateTime.parse("1970-01-01T${b.from!.replaceAll('.', ':')}:00");

                return timeA.compareTo(timeB);
              });

              return ListView.builder(
                shrinkWrap: true,
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
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
