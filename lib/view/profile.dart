import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  TextEditingController name = TextEditingController(text: 'John Doe');
  TextEditingController email = TextEditingController(text: 'john.doe@example.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 185, 205, 205), // Medium green
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 185, 205, 205), width: 10.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  const SizedBox(height: 50),
                  passField('Username', 'Username', fontSize: 20.0),
                  const SizedBox(height: 20),
                  normalField('Name', name, fontSize: 20.0),
                  const SizedBox(height: 20),
                  normalField('Email', email, fontSize: 20.0),
                  const SizedBox(height: 30),
                  passField('Password', '********', fontSize: 20.0),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      // Implement change password functionality
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement delete account functionality
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      backgroundColor: Colors.red[100], 
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Leave save button function empty for now
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 75.0),
                      backgroundColor: Colors.lightGreen[300], 
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 23),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget normalField(String label, TextEditingController controller, {double fontSize = 15.0}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: fontSize),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: fontSize),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter $label',
                hintStyle: TextStyle(fontSize: fontSize),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget passField(String label, String value, {double fontSize = 15.0}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: fontSize),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
          ),
        ],
      ),
    );
  }
}

