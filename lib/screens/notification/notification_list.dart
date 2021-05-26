import 'package:cstalk_clone/models/notification.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/notification_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final notificationList = Provider.of<List<NotificationObject>>(context) ?? [];
    final uid = Provider.of<UserObject>(context).uid;
    
    return ListView.builder(
      itemCount: notificationList.length,
      itemBuilder: (context, index) {
        
        NotificationObject notification = notificationList[index];

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Card(
            elevation: 0.5,
            margin: EdgeInsets.symmetric(vertical: 1.0),
            color: !notification.isActivate ? Colors.orange[50] : Colors.white,
            child: StreamBuilder<Post>(
              stream: PostService(postID: notification.postID).postByID,
              builder: (context, postSnapshot) {

                return StreamBuilder<UserData>(
                  stream: UserService(uid: notification.userID).userData,
                  builder: (context, userSnapshot) {

                    if (postSnapshot.hasData && userSnapshot.hasData) {

                      Post post = postSnapshot.data;
                      UserData userData = userSnapshot.data;
                      
                      return ListTile(
                        leading: Icon(
                          notification.type == 'reply' 
                          ? Icons.reply 
                          : notification.type == 'accept' 
                          ? Icons.check_circle
                          : notification.type == 'up' 
                          ? Icons.arrow_circle_up
                          : Icons.arrow_circle_down,
                          color: Colors.orangeAccent,
                          size: 30.0,
                        ),
                        title: Text(userData.name, style: TextStyle(fontWeight: FontWeight.bold,)),
                        subtitle: Text(
                          notification.type == 'reply' 
                          ? 'reply on your question \"${post.postTitle}\"' 
                          : notification.type == 'accept' 
                          ? 'accepted your answer on question \"${post.postTitle}\"'
                          : notification.type == 'up' 
                          ? 'upvote your answer on question \"${post.postTitle}\"'
                          : 'downvote your answer on question \"${post.postTitle}\"',
                          maxLines: post.postTitle.length >= 20 ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: post.postTitle.length >= 20,
                        trailing: notification.isActivate ? null : Icon(
                          Icons.circle,
                          color: Colors.orangeAccent,
                          size: 12.0,
                        ),
                        onTap: () async {
                          Navigator.pushNamed(context, '/detail', arguments: notification.postID);
                          await NotificationService(
                            uid: uid,
                            notificationID: notification.notificationID,
                          ).updateNotificaionStatus();
                        },
                      );

                    }

                    return NotificationSkeleton();
                  }
                );
              }
            ),
          ),
        );
      },
    );
  }
}