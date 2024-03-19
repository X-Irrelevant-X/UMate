import 'package:flutter/material.dart';

class Registration extends StatelessWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your registration form fields here
            Text(
              'Registration Page',
              style: TextStyle(fontSize: 20),
            ),
            // Example text fields
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                // Implement registration functionality
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
