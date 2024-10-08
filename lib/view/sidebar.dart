import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umate/controller/sidebar_c.dart';
import 'package:umate/model/user.dart';
import 'package:umate/view/schedule.dart';
import 'package:umate/view/friends.dart';
import 'package:umate/view/memes.dart';
import 'package:umate/view/notes.dart';
import 'package:umate/view/home.dart';
import 'package:umate/view/social_links.dart';
import 'package:umate/controller/login_c.dart';
import 'package:umate/controller/notes_c.dart';
import 'package:umate/model/theme.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          FutureBuilder<UserT>(
            future: SidebarController().getUserSide(context), 
            builder: (BuildContext context, AsyncSnapshot<UserT> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const DrawerHeader(
                 decoration: BoxDecoration(color: Color.fromARGB(255, 185, 205, 205)),
                 child: Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                ),
                );
              } else if (snapshot.hasError) {
                return const DrawerHeader(
                 decoration: BoxDecoration(color: Color.fromARGB(255, 185, 205, 205)),
                 child: Text(
                    'Log In First',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                    ),
                 ),
                );
              } else {
                UserT user = snapshot.data!;
                return DrawerHeader(
                 decoration: BoxDecoration(color: Color.fromARGB(255, 185, 205, 205)),
                 child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user.avatarurl != null
                                  ? NetworkImage(user.avatarurl!)
                                  : null,
                              child: user.avatarurl == null ? Icon(Icons.person) : null,
                            ),
                            SizedBox(width: 10),
                            Text(
                              user.username ?? 'Username',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              SidebarController().navigateToPage(context, HomePage());
            },
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
            title: Text('Chats'),
            onTap: () {
              SidebarController().navigateToPage(context, Friends());
            },
          ),
          ListTile(
            leading: Icon(Icons.note),
            title: Text('Notes'),
            onTap: () {
              SidebarController().navigateToPage(context, Notes(noteController: NoteController()));
            },
          ),
          ListTile(
            leading: Icon(Icons.link_rounded),
            title: Text('Quick Links'),
            onTap: () {
              SidebarController().navigateToPage(context, SocialLinks());
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Schedule Planning'),
            onTap: () {
              SidebarController().navigateToPage(context, SchedulePlanning());
            },
          ),
          ListTile(
            leading: Icon(Icons.emoji_emotions),
            title: Text('Memes'),
            onTap: () {
              SidebarController().navigateToPage(context, MemesScreen());
            },
          ),
          const SizedBox(height: 30),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              LoginController().logout(context);
            },
          ),
          const Divider(),
          const SizedBox(height: 10),
          Consumer<ThemeNotifier>(
            builder: (context, themeNotifier, child) {
              return ListTile(
                leading: Icon(themeNotifier.isDarkMode
                    ? Icons.dark_mode
                    : Icons.light_mode),
                title: Text(themeNotifier.isDarkMode ? 'Dark Mode' : 'Light Mode'),
                onTap: () {
                  themeNotifier.toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
