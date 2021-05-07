import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/other/profile.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Other extends StatefulWidget {
  @override
  _OtherState createState() => _OtherState();
}

class _OtherState extends State<Other> {
  @override
  Widget build(BuildContext context) {

    // final user = Provider.of<UserObject>(context);

    return Container(
      child: Profile(),
    );
  }
}