import 'package:flutter/material.dart';
import 'dart:async';
import 'package:umate/controller/registration_c.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/sidebar.dart';

class Registration extends StatefulWidget {

  const Registration({super.key});

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  final TextEditingController usernameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
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

      body: SingleChildScrollView(
        child: Center(
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
                  Container(
                    color: const Color.fromARGB(255, 185, 205, 205),
                    padding: const EdgeInsets.all(11.0),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Username:',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: usernameCon,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Email:',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: emailCon,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password:',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: passwordCon,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Confirm Password:',
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: confirmPass,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  errorMessage != null
                      ? Text(
                          errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 20,),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      final user = UserT(
                        username: usernameCon.text.trim(),
                        email: emailCon.text.trim(),
                        password: passwordCon.text.trim(),
                      );

                      if (
                        usernameCon.text.trim().isEmpty ||
                        emailCon.text.trim().isEmpty ||
                        passwordCon.text.trim().isEmpty ||
                        confirmPass.text.trim().isEmpty) {
                        setState(() {
                          errorMessage = 'All fields are required.';
                          
                        });
                        Timer(const Duration(seconds: 2), () {
                          setState(() {
                            errorMessage = null;
                          });
                        });
                      } else if (passwordCon.text.trim() != confirmPass.text.trim()) {
                        setState(() {
                          errorMessage = "Passwords don't match.";
                        });
                        Timer(const Duration(seconds: 2), () {
                          setState(() {
                            errorMessage = null;
                          });
                        });
                      } else if (errorMessage == null) {
                        RegistrationController().signUp(context, user);
                      }
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 40.0),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 220, 238, 238),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Opacity(
                    opacity: 0.99,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogIn()),
                        );
                      },
                      child: const Text(
                        'Already Have An Account? Sign In',
                        style: TextStyle(fontSize: 21),
                      ),
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
}
