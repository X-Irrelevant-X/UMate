import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:umate/view/sidebar.dart';
import 'package:umate/controller/links_c.dart';
import 'package:umate/model/link_model.dart';

class SocialLinks extends StatelessWidget {
  final LinkController _linkController = LinkController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quick Links', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
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
      body: FutureBuilder<Stream<List<LinkM>>>(
        future: _linkController.getLinks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return StreamBuilder<List<LinkM>>(
              stream: snapshot.data,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final links = snapshot.data!;
                return ExternalResourceList(resources: links);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLinkPopup(context),
        child: Icon(Icons.add),
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
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (linkName != null && linkAddress != null) {
                  final newLink = LinkM(linkName: linkName!, linkUrl: linkAddress!);
                  _addLink(newLink);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addLink(LinkM link) async {
    try {
      await _linkController.addLink(link);
    } catch (e) {
      print('Error adding link: $e');
    }
  }
}

class ExternalResourceList extends StatelessWidget {
  final List<LinkM> resources;

  const ExternalResourceList({
    required this.resources,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final link = resources[index];
        return ExternalResourceCard(
          resourceId: link.lid ?? '',
          resourceName: link.linkName ?? '',
          resourceUrl: link.linkUrl ?? '',
        );
      },
    );
  }
}

class ExternalResourceCard extends StatelessWidget {
  final LinkController linkCon = LinkController();
  final String resourceId;
  final String resourceName;
  final String resourceUrl;

  ExternalResourceCard({super.key, 
    required this.resourceId,
    required this.resourceName,
    required this.resourceUrl,
  });

  @override
  Widget build(BuildContext context) {
    final partsUri = Uri.parse(resourceUrl);
    final hostParts = partsUri.host?.split('.');

    String host = '';
    if (hostParts != null) {
      if (hostParts.length == 2) {
        host = hostParts.first[0].toUpperCase() + hostParts.first.substring(1).toLowerCase();
      } else if (hostParts.length == 3) {
        host = hostParts[1][0].toUpperCase() + hostParts[1].substring(1).toLowerCase();
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ListTile(
        leading: Text(host, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
          
            Text(resourceName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          
          ],
        ),
        onTap: () => _openResource(context, resourceUrl),
        trailing: IconButton(
          icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Delete Link'),
                  content: Text('Are you sure you want to Delete this Link?'),
                  actions: [    
                    TextButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: Text('No'),
                    ),
                    TextButton(
                    onPressed: () {
                        linkCon.deleteLink(linkId: resourceId);
                        Navigator.of(context).pop(); 
                    },
                    child: Text('Yes'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _openResource(BuildContext context, String resourceUrl) async {
    final uriParts = Uri.parse(resourceUrl);
    final scheme = uriParts.scheme;
    final host = uriParts.host;
    final path = uriParts.path;
    
    final urlL = Uri(
      scheme: scheme.isNotEmpty ? scheme : 'https',
      host: host,
      path: path.isNotEmpty ? path : '/',
    );

    if (await launchUrl(urlL)) {
      await launchUrl(urlL, mode: LaunchMode.externalApplication,);
    } 
  }
}