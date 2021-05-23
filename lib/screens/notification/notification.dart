import 'package:cstalk_clone/models/notification.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/notification/notification_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostNotification extends StatefulWidget {
  @override
  _PostNotificationState createState() => _PostNotificationState();
}

class _PostNotificationState extends State<PostNotification> {
  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;

    return StreamProvider<List<NotificationObject>>.value(
      value: NotificationService(uid: uid).notifications,
      child: Container(
        child: NotificationList(),
      ),
    );
  }
}