import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/comment_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatelessWidget {

  final Comment comment;
  final String postOwnerID;

  CommentItem({ this.comment, this.postOwnerID });

  _onUpVote(String uid) async {

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

  _onDownVote(String uid) async {

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

  _onAcceptComment(bool isAccepted) async {

    String commentID = '';

    if (!isAccepted) {
      
      commentID = comment.commentID;

    } 

    await DatabaseService(
      postID: comment.postID,
      commentID: commentID,
    ).addAcceptedComment();

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
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(),

                Flexible(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      _commentSection(userData.name),

                      SizedBox(height: 4.0,),

                      _acceptCommentSection(uid),
                      
                    ],
                  ),
                ),

                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Center(
                    child: Column(
                      children: [

                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_up, 
                            size: 30.0,
                            color: comment.upVoteList.contains(uid) ? Colors.black : Colors.grey,
                          ), 
                          onPressed: () {
                            _onUpVote(uid);
                          }
                        ),

                        Text(comment.voteCount.toString()),

                        IconButton(
                          icon: Icon(
                            Icons.arrow_drop_down, 
                            size: 30.0,
                            color: comment.downVoteList.contains(uid) ? Colors.black : Colors.grey,
                          ), 
                          onPressed: () {
                            _onDownVote(uid);
                          }
                        ),
                        
                      ],
                    ),
                  )
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
    return Row(
      children: [
        Expanded(
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
        ),
      ],
    );
  }

  Widget _acceptCommentSection(String uid) {
    return StreamBuilder<String>(
      stream: FirebaseFirestore.instance.collection('posts').doc(comment.postID).snapshots().map((doc) => doc.data()['acceptedCommentID']),
      builder: (context, snapshot) {

        String acceptedCommentID = snapshot.data;

        if (uid == postOwnerID) {

          return _ownerWidget(acceptedCommentID);

        } else {

          return _visitorWidget(acceptedCommentID);

        }
      }
    );
  }

  Widget _ownerWidget(String acceptedCommentID) {

    if (acceptedCommentID == comment.commentID) {

      return OutlinedButton.icon(
        icon: Icon(
          Icons.check_circle, 
          color: Colors.greenAccent[400],
        ), 
        label: Text('Unaccept Answer'), 
        onPressed: () {
          _onAcceptComment(true);
        },
      );

    } else {

      return OutlinedButton(
        child: Text('Accept Answer'), 
        onPressed: () {
          _onAcceptComment(false);
        },
      );

    }

  }

  Widget _visitorWidget(String acceptedCommentID) {
    
    if (acceptedCommentID == comment.commentID) {

      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.check_circle, 
                    color: Colors.greenAccent[400],
                  ),
                ),
                TextSpan(
                  text: ' Accepted Answer',
                  style: TextStyle(color: Colors.black)
                ),
              ],
            ),
          ),
        ),
      );

    } else {

      return Container();

    }
  }
}