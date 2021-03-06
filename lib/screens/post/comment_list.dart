import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/screens/post/comment_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommentList extends StatefulWidget {

  final String postOwnerID;
  final Function onEditComment;

  CommentList({ this.postOwnerID, this.onEditComment });

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {

    final commentList = Provider.of<List<Comment>>(context) ?? [];

    return Column(
      children: commentList
        .map((comment) => 
          Column(
            children: [

              CommentItem(
                comment: comment,
                postOwnerID: widget.postOwnerID,
                onEditComment: widget.onEditComment,
              ),

              Divider(
                color: Colors.grey[200], 
                thickness: 2.0,
              ),

            ],
          )
        ).toList(),
    );
  }
}