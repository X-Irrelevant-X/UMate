import 'package:flutter/material.dart';
import 'package:umate/controller/memes_c.dart';
import 'package:umate/view/sidebar.dart';

class MemesScreen extends StatefulWidget {
 MemesScreen({Key? key}) : super(key: key);

 @override
 State<MemesScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MemesScreen> {
 Future<String>? _memeFuture;

 @override
 void initState() {
    super.initState();
    _memeFuture = FetchMeme.fetchNewMeme();
 }

 void _refreshMeme() {
    setState(() {
      _memeFuture = FetchMeme.fetchNewMeme();
    });
 }

 @override
 Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "MeMotivation",
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshMeme,
            ),
            SizedBox(width: 10),
          ],
        ),
        drawer: const SideBar(),
        body: Center(
          child: FutureBuilder<String>(
            future: _memeFuture,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text('Error fetching meme');
              } else {
                return Container(
                 margin: const EdgeInsets.all(20),
                 decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey, width: 5),
                 ),
                 child: Image.network(snapshot.data!),
                );
              }
            },
          ),
        ),
      ),
    );
 }
}