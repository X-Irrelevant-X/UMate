import 'package:flutter/material.dart';
import 'package:umate/controller/sidebar_c.dart';
import 'package:umate/view/advising.dart';
import 'package:umate/view/friends.dart';
import 'package:umate/view/notes.dart';
import 'package:umate/view/social_links.dart';
import 'package:umate/controller/login_c.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 185, 205, 205)),
            child: Text(
              'Welcome',
              style: TextStyle(
                color: Colors.white,
                fontSize: 35,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              SidebarController().fetchUser(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Friends'),
            onTap: () {
              SidebarController().navigateToPage(context, Friends());
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notes'),
            onTap: () {
              SidebarController().navigateToPage(context, Notes());
            },
          ),
          ListTile(
            leading: Icon(Icons.link_rounded),
            title: Text('Social Links'),
            onTap: () {
              SidebarController().navigateToPage(context, SocialLinks());
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Advising Planning'),
            onTap: () {
              SidebarController().navigateToPage(context, AdvisingPlanning());
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
