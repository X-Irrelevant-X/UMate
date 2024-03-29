import 'package:flutter/material.dart';
import 'package:umate/view/registration.dart';
import 'package:umate/view/profile.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 185, 205, 205),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                  const SizedBox(height: 50),
                  Container(
                    color: const Color.fromARGB(255, 185, 205, 205),
                    padding: const EdgeInsets.all(11.0),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 50, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 75),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Email:',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          'Password:',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.all(10.0),
                          ),
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Opacity(
                    opacity: 0.99,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Email to Reset Password:'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                  ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Implement recover password functionality
                                  },
                                  child: const Text('Recover Password'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Registration()),
                      );
                    },
                    child: const Text(
                      'Sign Up Here!',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
