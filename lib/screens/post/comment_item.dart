import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/comment_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {

  final Comment comment;

  CommentItem({ this.comment });

  _upVote(String uid) async {

    if (!comment.upVoteList.contains(uid)) {

      comment.upVoteList.add(uid);
      comment.downVoteList.remove(uid);

    } else {

      comment.upVoteList.remove(uid);
    }

    await DatabaseService(
      postID: comment.postID,
      commentID: comment.commentID
    ).voteComment(
      upVoteList: comment.upVoteList,
      downVoteList: comment.downVoteList,
    );
    
  }

  _downVote(String uid) async {

    if (!comment.downVoteList.contains(uid)) {

      comment.downVoteList.add(uid);
      comment.upVoteList.remove(uid);

    } else {

      comment.downVoteList.remove(uid);
    }

    await DatabaseService(
      postID: comment.postID,
      commentID: comment.commentID
    ).voteComment(
      upVoteList: comment.upVoteList,
      downVoteList: comment.downVoteList,
    );

  }
  
  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;

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

                      _voteSection(uid),
                      
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

  Widget _voteSection(String uid) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 40.0,),

          TextButton.icon(
            icon: Icon(
              Icons.arrow_circle_up,
              color: comment.upVoteList.contains(uid) ? Colors.greenAccent[400] : Colors.grey,
            ),
            label: Text(
              'Up',
              style: TextStyle(
                color: comment.upVoteList.contains(uid) ? Colors.greenAccent[400] : Colors.grey,
                fontWeight: comment.upVoteList.contains(uid) ? FontWeight.bold : null,
              ),
            ), 
            onPressed: () {
              _upVote(uid);
            },
          ),
          
          SizedBox(width: 50.0,),

          TextButton.icon(
            icon: Icon(
              Icons.arrow_circle_down,
              color: comment.downVoteList.contains(uid) ? Colors.red[600] : Colors.grey,
            ),
            label: Text(
              'Down',
              style: TextStyle(
                color: comment.downVoteList.contains(uid) ? Colors.red[600] : Colors.grey,
                fontWeight: comment.downVoteList.contains(uid) ? FontWeight.bold : null,
              ),
            ), 
            onPressed: () {
              _downVote(uid);
            },
          ),
        ],
      ),
    );
  }
}