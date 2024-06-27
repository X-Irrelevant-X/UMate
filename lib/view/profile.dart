import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:umate/model/user.dart';
import 'package:umate/controller/profile_c.dart';
import 'package:umate/controller/login_c.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/sidebar.dart';
import 'package:auto_size_text/auto_size_text.dart';


class ProfilePage extends StatefulWidget {
  final UserT user;

  const ProfilePage({super.key, required this.user});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<ProfilePage> {
  late TextEditingController name;
  late TextEditingController username;
  TextEditingController resetCon = TextEditingController();
  String? gender;
  final ProfileController _profileController = ProfileController();
  File? _image;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.user.name ?? '');
    username = TextEditingController(text: widget.user.username ?? '');
    gender = widget.user.gender;
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
                      backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider<Object>?
                        : widget.user.avatarurl != null
                            ? NetworkImage(widget.user.avatarurl!) as ImageProvider<Object>?
                            : null,

                      child: ((_image == null && widget.user.avatarurl == null) || widget.user.avatarurl!.isEmpty)
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 50),
                  normalField('Username', widget.user.username!, fontSize: 20.0),
                  const SizedBox(height: 20),
                  editField('Name', name, fontSize: 20.0),
                  const SizedBox(height: 20),
                  normalField('Email', widget.user.email, fontSize: 20.0),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        const Text(
                          'Gender:',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(width: 15),
                        SizedBox(
                          width: 85, 
                          child: DropdownButton<String>(
                            value: gender, 
                            elevation: 5, 
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                gender = newValue;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                  child: Text(value),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Email to Reset Password:'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    TextFormField(
                                      controller: resetCon,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.all(10.0),
                                        labelText: 'Email',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    LoginController().resertPassword(
                                      context,
                                      resetCon.text.trim(),
                                    );
                                  },
                                  icon: const Icon(Icons.email_outlined),
                                  label: const Text('Reset Password'),
                                ),
                              ],
                            );
                          },
                        );
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
                        await _profileController.deleteAccount(widget.user.email);
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LogIn()));
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
                        final updatedUser = UserT(
                          username: widget.user.username,
                          avatar: _image,
                          avatarurl: widget.user.avatarurl,
                          name: name.text,
                          email: widget.user.email,
                          gender: gender,
                          password: widget.user.password,
                        );
                        try {
                          final success = await _profileController.updateProfile(widget.user.email, updatedUser);
                          if (success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Profile Updated'),
                                backgroundColor: Colors.lightGreen[300],
                              ),
                            );
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Failed to update profile'),
                                backgroundColor: Colors.red[300],
                              ),
                            );
                          }
                        } catch (error) {
                          print('Failed to update profile: $error');
                        }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 80.0),
                      backgroundColor: Colors.lightGreen[300],
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18),
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

  Widget editField(String label, TextEditingController controller,
      {double fontSize = 15.0}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$label:  ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
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

  Widget normalField(String label, String value, {double fontSize = 15.0}) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$label:  ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
            ),
            Expanded(
              child: AutoSizeText(
                value,
                style: TextStyle(fontSize: fontSize),
                maxLines: 1, 
                minFontSize: 12,
                textAlign: TextAlign.left, 
              ),
            ),
          ],
        ),
    );
  }
}
