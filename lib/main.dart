import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/home/post_filter.dart';
import 'package:cstalk_clone/screens/nav.dart';
import 'package:cstalk_clone/screens/post/image_preview.dart';
import 'package:cstalk_clone/screens/post/post_detail.dart';
import 'package:cstalk_clone/screens/wrapper.dart';
import 'package:cstalk_clone/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserObject>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/home': (context) => Nav(),
          '/detail': (context) => PostDetail(),
          '/filter': (context) => PostFilter(),
          '/image': (context) => ImagePreview(),
        },
      ),
    );
  }
}