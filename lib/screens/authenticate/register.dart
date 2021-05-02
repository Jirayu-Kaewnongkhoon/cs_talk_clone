import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function changeScreen;

  Register({ this.changeScreen });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Text('register'),
      ),
    );
  }
}