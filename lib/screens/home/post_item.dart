import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/post_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItem extends StatelessWidget {

  final Post post;

  PostItem({ this.post });

  String _getDateTime() {
    return DateFormat('d/MM/y').add_jms().format(DateTime.fromMillisecondsSinceEpoch(post.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: UserService(uid: post.ownerID).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Card(
            child: Column(
              children: [

                ListTile(
                  leading: CircleAvatar(),
                  title: Text(userData.name),
                  subtitle: Text(_getDateTime()),
                  trailing: IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(post.postDetail),

                      SizedBox(height: 8.0),

                      post.imageUrl != null ? Image.network(post.imageUrl) : Container(),

                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: FlatButton(
                          child: Icon(
                            Icons.comment,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, '/detail', arguments: widget.post);
                          }
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          );

        } else {
          
          return PostSkeleton();

        }
      }
    );
  }
}
