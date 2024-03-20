import 'package:flutter/material.dart';
import 'package:umate/view/advising.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/registration.dart';
import 'package:umate/view/friends.dart';
import 'package:umate/view/notes.dart';
//import 'package:umate/view/advising.dart';


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
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LogIn()),
                      );
                    },
                    child: const Text('Log In'),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Registration()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
              ];
            },
            child: SizedBox(
              height: profileButtonHeight,
              child: const Center(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          // Divider between profile button and bottom buttons
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Friends()),
                  );
                }),
                buildBottomButton('Social Medias', buttonWidth, bottomButtonsHeight, () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: SizedBox(
                          width: 400,
                          height: 400,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                socialRow(['CSE489', 'CSE470', 'CSE422']),
                                socialRow(['470 FB', '489 FB', '422 FB']),
                                socialRow(['422Drive', '489Drive', '470Drive']),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                buildBottomButton('Notes', buttonWidth, bottomButtonsHeight, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notes()),
                  );
                }),
                buildBottomButton('Advising Planning', buttonWidth, bottomButtonsHeight, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdvisingPlanning()),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget socialRow(List<String> buttonNames) {
     return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buttonNames.map((buttonName) {
          return socialButton(buttonName);
        }).toList(),
      ),
    );
  }

  Widget socialButton(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: SizedBox(
          width: 33,
          height: 90,
          child: Center(
            child: Text(text),
          ),
        ),
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
