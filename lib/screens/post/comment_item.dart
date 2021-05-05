import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/services/database_service.dart';
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
                    child: Column(
                      children: [
                        Flex(
                          direction: Axis.horizontal,
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

                            Visibility(
                              visible: comment.isAccepted,
                              child: Padding(
                                padding: EdgeInsets.only(left: 12.0),
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.greenAccent[400],
                                  size: 30.0,
                                ),
                              ),
                            )
                          ]
                        ),

                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
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
                        ),
                        
                      ],
                    ),
                  ),
                ),

              ]
            ),
          ),

          // Visibility(
          //   visible: comment.isAccepted,
          //   child: Padding(
          //     padding: EdgeInsets.only(left: 12.0),
          //     child: Icon(
          //       Icons.check_circle,
          //       color: Colors.greenAccent[400],
          //       size: 30.0,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}