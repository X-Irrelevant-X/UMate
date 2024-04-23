import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:umate/view/sidebar.dart';

class SocialLinks extends StatefulWidget {
  const SocialLinks({Key? key}) : super(key: key);

  @override
  _SocialMediaDialogState createState() => _SocialMediaDialogState();
}

class _SocialMediaDialogState extends State<SocialLinks> {
  final List<String> _links = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Media Links'),
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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Add Link Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showAddLinkPopup(context);
              },
              child: Text('Add Link'),
            ),
          ),
          // List of Links Section
          Expanded(
            child: ListView.builder(
              itemCount: _links.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_links[index]),
                  onTap: () {
                    _openLink(context, _links[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLinkPopup(BuildContext context) {
    String? linkName;
    String? linkAddress;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Link Name'),
                onChanged: (value) {
                  linkName = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: 'Link Address'),
                onChanged: (value) {
                  linkAddress = value;
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (linkName != null && linkAddress != null) {
                  setState(() {
                    _links.add(linkName!);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _openLink(BuildContext context, String linkAddress) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Link Preview'),
          ),
          // body: WebView(
          //   initialUrl: linkAddress,
          //   javascriptMode: JavascriptMode.unrestricted,
          // ),
        ),
      ),
    );
  }
}
