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

  void _onUpVote(String uid) async {

    if (!comment.upVoteList.contains(uid)) {

      comment.upVoteList.add(uid);
      comment.downVoteList.remove(uid);

    } else {

      comment.upVoteList.remove(uid);
    }

    await CommentService(
      postID: comment.postID,
      commentID: comment.commentID
    ).voteComment(
      upVoteList: comment.upVoteList,
      downVoteList: comment.downVoteList,
    );
    
  }

  void _onDownVote(String uid) async {

    if (!comment.downVoteList.contains(uid)) {

      comment.downVoteList.add(uid);
      comment.upVoteList.remove(uid);

    } else {

      comment.downVoteList.remove(uid);
    }

    await CommentService(
      postID: comment.postID,
      commentID: comment.commentID
    ).voteComment(
      upVoteList: comment.upVoteList,
      downVoteList: comment.downVoteList,
    );

  }

  void _onAcceptComment(bool isAccepted) async {

    String commentID = '';

    if (!isAccepted) {
      
      commentID = comment.commentID;

    } 

    await CommentService(
      postID: comment.postID,
      commentID: commentID,
    ).addAcceptedComment();

  }

  void _onEditComment() {

  }

  void _onRemoveComment(BuildContext context) async {
    await CommentService(
      postID: comment.postID,
      commentID: comment.commentID
    ).removeComment();

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent[400],
                ),
              ),
              TextSpan(text: ' Your answer has deleted'),
            ]
          ),
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;

    return StreamBuilder<UserData>(
      stream: UserService(uid: comment.ownerID).userData,
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
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        _commentSection(context, userData.name),

                        SizedBox(height: 4.0,),

                        _acceptCommentSection(uid),
                        
                      ],
                    ),
                  ),
                ),

                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    children: [

                      IconButton(
                        icon: Icon(
                          Icons.arrow_drop_up, 
                          size: 30.0,
                          color: comment.upVoteList.contains(uid) ? Colors.orangeAccent : Colors.grey,
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
                          color: comment.downVoteList.contains(uid) ? Colors.orangeAccent : Colors.grey,
                        ), 
                        onPressed: () {
                          _onDownVote(uid);
                        }
                      ),
                      
                    ],
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

  void _popupMenu(BuildContext context) {
    showModalBottomSheet(
      context: context, 
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).viewInsets.bottom + 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                leading: Icon(
                  Icons.edit,
                  color: Colors.orangeAccent,
                ), 
                title: Text('Edit'), 
                onTap: _onEditComment,
              ),

              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                leading: Icon(
                  Icons.delete,
                  color: Colors.orangeAccent,
                ), 
                title: Text('Remove'), 
                onTap: () => _onRemoveComment(context),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _commentSection(BuildContext context, String ownerName) {

    final uid = Provider.of<UserObject>(context).uid;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onLongPress: uid != comment.ownerID ? null : () => _popupMenu(context),
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

                  comment.imageUrl != null ? SizedBox(height: 4.0) : Container(),

                  comment.imageUrl != null ? Image.network(comment.imageUrl) : Container(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _acceptCommentSection(String uid) {
    return StreamBuilder<String>(
      stream: PostService(postID: comment.postID).acceptedCommentID,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          String acceptedCommentID = snapshot.data;

          if (uid == postOwnerID) {

            return _ownerWidget(acceptedCommentID);

          } else {

            return _visitorWidget(acceptedCommentID);

          }

        }

        return Container();
      }
    );
  }

  Widget _ownerWidget(String acceptedCommentID) {

    if (acceptedCommentID.isEmpty) {

      return OutlinedButton(
        child: Text('Accept Answer'), 
        onPressed: () {
          _onAcceptComment(false);
        },
      );

    }

    return Visibility(
      visible: acceptedCommentID == comment.commentID,
      child: OutlinedButton.icon(
        icon: Icon(
          Icons.check_circle, 
          color: Colors.greenAccent[400],
        ), 
        label: Text('Unaccept Answer'), 
        onPressed: () {
          _onAcceptComment(true);
        },
      ),
    );

  }

  Widget _visitorWidget(String acceptedCommentID) {
    return Visibility(
      visible: acceptedCommentID == comment.commentID,
      child: Center(
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
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}