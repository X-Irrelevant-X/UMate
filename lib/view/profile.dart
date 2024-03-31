import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umate/model/user.dart';
import 'package:umate/controller/profile_c.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/sidebar.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  late TextEditingController name;
  late TextEditingController email;
  final ProfileController _profileController = ProfileController();
  File? _image;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.user.name ?? '');
    email = TextEditingController(text: widget.user.email);
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 185, 205, 205),
                    width: 10.0),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: _getImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 50),
                  passField('Username', widget.user.username, fontSize: 20.0),
                  const SizedBox(height: 20),
                  normalField('Name', name, fontSize: 20.0),
                  const SizedBox(height: 20),
                  normalField('Email', email, fontSize: 20.0),
                  const SizedBox(height: 30),
                  passField('Password', '********', fontSize: 20.0),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      _profileController.passwordReset(email.text);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _profileController.deleteAccount(widget.user.id);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LogIn()));
                      } catch (error) {
                        print('Failed to delete account: $error');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 40.0),
                      backgroundColor: Colors.red[100],
                    ),
                    child: const Text(
                      'Delete Account',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Update user information
                      final updatedUser = User(
                        id: widget.user.id,
                        //profilePicture: _image,
                        username: widget.user.username,
                        name: name.text,
                        email: email.text,
                        password: widget.user.password,
                        passwordConfirm: widget.user.passwordConfirm,
                      );
                      final success = await _profileController.updateProfile(
                          widget.user.id, updatedUser);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Profile Updated'),
                            backgroundColor: Colors.lightGreen[300],
                            margin: EdgeInsets.all(10.0),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.green, width: 2.0),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 75.0),
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

  Widget normalField(String label, TextEditingController controller,
      {double fontSize = 15.0}) {
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
