import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/authenticate/auth.dart';
import 'package:cstalk_clone/screens/nav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    UserObject user = Provider.of<UserObject>(context);
    
    if (user != null) {

      return Nav();

    } else {

      return Auth();

    }
  }
}