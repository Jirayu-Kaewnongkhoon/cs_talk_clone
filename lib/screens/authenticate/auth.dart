import 'package:cstalk_clone/screens/authenticate/login.dart';
import 'package:cstalk_clone/screens/authenticate/register.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool showLogin = true;

  void _changeScreen() {
    setState(() => showLogin = !showLogin);
  }

  @override
  Widget build(BuildContext context) {
    
    if (showLogin) {

      return Login(changeScreen: _changeScreen);

    } else {

      return Register(changeScreen: _changeScreen);
      
    }
  }
}