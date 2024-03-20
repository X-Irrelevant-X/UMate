import 'package:flutter/material.dart';
import 'package:umate/view/sidebar.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'UMate',
            style: TextStyle(fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor:  const Color.fromARGB(255, 185, 205, 205),
        ),
        body: Row(
          children: [
            // Left column
            const SideBar(),
            
            // Right column
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Colors.white, // Change to any color you prefer
                  ),
                  child: Column(
                    children: [
                      // Top Right Row
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
                        ),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Sticky Notes',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Divider between top right row and top bottom row
                      Container(
                        height: 1,
                        color: const Color.fromARGB(255, 66, 66, 66),
                      ),
                      // Top Bottom Row
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  'Class Routine',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
