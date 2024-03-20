import 'package:flutter/material.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/profile.dart';

class Registration extends StatelessWidget {
  const Registration({super.key});

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
      ),
      body: Center(
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
                        'Email:',
                        style: TextStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                      backgroundColor: const Color.fromARGB(255, 220, 238, 238),
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
                        MaterialPageRoute(builder: (context) => const LogIn()),
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
    );
  }
}
