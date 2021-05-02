import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  final Function changeScreen;

  Login({ this.changeScreen });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('login'),
      ),
    );
  }
}