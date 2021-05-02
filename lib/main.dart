import 'package:cstalk_clone/screens/nav.dart';
import 'package:cstalk_clone/screens/post/post_detail.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      
      initialRoute: '/',
      routes: {
        '/': (context) => Nav(),
        '/detail': (context) => PostDetail(),
      },
    );
  }
}