import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umate/view/login.dart';
import 'package:umate/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:umate/firebase_options.dart';
import 'package:umate/model/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          title: 'UMate',
          debugShowCheckedModeBanner: false,
          home: const dynaLand(),
        );
      },
    );
  }
}

class dynaLand extends StatelessWidget {
  const dynaLand({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return LogIn();
          }
        },
      ),
    );
  }
}
