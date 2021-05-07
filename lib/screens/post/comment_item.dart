import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/comment_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {

  final Comment comment;

  CommentItem({ this.comment });
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: comment.ownerID).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(),

                SizedBox(width: 8.0,),

                Expanded(
                  child: Column(
                    children: [

                      Flex(
                        direction: Axis.horizontal,
                        children: [

                          _commentSection(userData.name),

                          Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(
                              Icons.check_circle,
                              color: comment.isAccepted ? Colors.greenAccent[400] : Colors.transparent,
                              size: 30.0,
                            ),
                          )
                        ]
                      ),

                      _voteSection(),
                      
                    ],
                  ),
                ),

              ]
            ),
          );

        } else {

          return CommentSkeleton();
          
        }
      }
    );
  }

  Widget _commentSection(String ownerName) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              ownerName,
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 4.0),
            
            Text(comment.commentDetail),
          ],
        ),
      ),
    );
  }

  Widget _voteSection() {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 40.0,),

          TextButton.icon(
            icon: Icon(
              Icons.arrow_circle_up,
              color: comment.isUpVote ? Colors.greenAccent[400] : Colors.grey,
            ),
            label: Text(
              'Up',
              style: TextStyle(
                color: comment.isUpVote ? Colors.greenAccent[400] : Colors.grey,
                fontWeight: comment.isUpVote ? FontWeight.bold : null,
              ),
            ), 
            onPressed: () async {
              if (!comment.isUpVote || comment.isDownVote) {

                await DatabaseService(
                  postID: comment.postID,
                  commentID: comment.commentID
                ).voteComment(
                  voteCount: comment.voteCount + 1,
                  isUpVote: true,
                  isDownVote: false,
                );
                
              }
            },
          ),
          
          SizedBox(width: 50.0,),

          TextButton.icon(
            icon: Icon(
              Icons.arrow_circle_down,
              color: comment.isDownVote ? Colors.red[600] : Colors.grey,
            ),
            label: Text(
              'Down',
              style: TextStyle(
                color: comment.isDownVote ? Colors.red[600] : Colors.grey,
                fontWeight: comment.isDownVote ? FontWeight.bold : null,
              ),
            ), 
            onPressed: () async {
              if (!comment.isDownVote || comment.isUpVote) {

                await DatabaseService(
                  postID: comment.postID,
                  commentID: comment.commentID
                ).voteComment(
                  voteCount: comment.voteCount - 1,
                  isUpVote: false,
                  isDownVote: true,
                );

              }
            },
          ),
        ],
      ),
    );
  }
}