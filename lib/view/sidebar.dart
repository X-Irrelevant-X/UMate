import 'package:flutter/material.dart';
import 'package:umate/controller/sidebar_c.dart';
import 'package:umate/controller/login_c.dart';
import 'package:umate/view/advising.dart';
import 'package:umate/view/friends.dart';
import 'package:umate/view/notes.dart';
import 'package:umate/view/social_links.dart';
//import 'package:umate/view/advising.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration( color: const Color.fromARGB(255, 185, 205, 205),),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              SidebarController();
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Friends'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Friends()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Notes()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.link_rounded),
            title: Text('Social Links'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SocialLinks()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Advising Planning'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdvisingPlanning()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              LoginController().logout(context);
            },
          ),
        ],
      ),
    );
  }
}
