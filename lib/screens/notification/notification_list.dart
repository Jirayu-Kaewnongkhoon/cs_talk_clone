import 'package:cstalk_clone/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final notificationList = Provider.of<List<NotificationObject>>(context) ?? [];
    
    return ListView.builder(
      itemCount: /* notificationList.length */2,
      itemBuilder: (context, index) {
        
        // NotificationObject notification = notificationList[index];

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            leading: Icon(
              true ? Icons.reply : Icons.check_circle,
              color: Colors.orangeAccent,
              size: 30.0,
            ),
            title: Text('Name', style: TextStyle(fontWeight: FontWeight.bold,)),
            subtitle: Text(
              true ? 'reply on your question \"ADADADADAD\"' : 'accepted your answer on question \"ADADADADAD\"'),
            isThreeLine: false,
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: { 'postID': ''});
            },
          ),
        );
      },
    );
  }
}