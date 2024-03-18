import 'package:flutter/material.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 75.0;
    double availableHeight = MediaQuery.of(context).size.height * 0.85;

    double profileButtonHeight = MediaQuery.of(context).size.height * 0.2 * 0.75;
    double bottomButtonsHeight = (availableHeight - profileButtonHeight);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'UMate',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.green[500], // Medium green
        ),
        body: Row(
          children: [
            // Left column
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  // Top row
                  SizedBox(
                    height: profileButtonHeight,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to profile page
                        },
                        child: const Text(
                          'Profile',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  // Divider between top and bottom rows
                  Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  // Bottom row
                  Expanded(
                    child: ListView(
                      children: [
                        buildBottomButton('Chat', buttonWidth, bottomButtonsHeight, () {
                          // Navigate to Chat page
                        }),
                        buildBottomButton('Social Medias', buttonWidth, bottomButtonsHeight, () {
                          // Navigate to Social Medias page
                        }),
                        buildBottomButton('Notes', buttonWidth, bottomButtonsHeight, () {
                          // Navigate to Notes page
                        }),
                        buildBottomButton('Advising Planning', buttonWidth, bottomButtonsHeight, () {
                          // Navigate to Advising Planning page
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider between columns
            Container(
              width: 1,
              color: Colors.black,
              margin: const EdgeInsets.symmetric(vertical: 1),
            ),
            // Right column
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  color: Colors.white, // Change to any color you prefer
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Right Column',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottomButton(String text, double width, double height, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        width: width,
        height: height / 4,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[700]!, width: 2),
          shape: BoxShape.circle,
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}


