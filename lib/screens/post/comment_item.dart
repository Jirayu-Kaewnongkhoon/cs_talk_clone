import 'package:cstalk_clone/models/comment.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {

  final Comment comment;

  CommentItem({ this.comment });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(),

                SizedBox(width: 8.0,),

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
                          'Name',
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

              ]
            ),
          ),

          Visibility(
            visible: true,
            child: Icon(
              Icons.check_circle,
              color: Colors.greenAccent[400],
              size: 30.0,
            ),
          )
        ],
      ),
    );
  }
}