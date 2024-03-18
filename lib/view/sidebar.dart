import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 75.0;
    double availableHeight = MediaQuery.of(context).size.height * 0.85;

    double profileButtonHeight = MediaQuery.of(context).size.height * 0.2 * 0.75;
    double bottomButtonsHeight = (availableHeight - profileButtonHeight);

    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 1.5),
        color: Colors.white,
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
            height: 1.5,
            color: const Color.fromARGB(255, 66, 66, 66),
          ),
          // Bottom row
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
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
    );
  }

  Widget buildBottomButton(String text, double width, double height, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 9.0),
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
              style: const TextStyle(fontSize: 13.5),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
