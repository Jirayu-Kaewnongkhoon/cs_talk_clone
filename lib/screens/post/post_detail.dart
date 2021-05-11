import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/home/post_item.dart';
import 'package:cstalk_clone/screens/post/comment_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatefulWidget {
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  Post post;

  String commentDetail = '';

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  _onCreateComment(String uid) async {

    await CommentService(
      uid: uid,
      postID: post.postID,
    ).createComment(commentDetail);

    _commentController.clear();

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {

    post = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<UserObject>(context);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostItem(post: post),

            SizedBox(height: 4.0),
            
            StreamProvider<List<Comment>>.value(
              value: CommentService(postID: post.postID).comments,
              child: CommentList(postOwnerID: post.ownerID),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Transform.translate(
        offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
        child: BottomAppBar(
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        color: Colors.orangeAccent,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Flexible(
                    flex: 6,
                    child: TextFormField(
                      controller: _commentController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Write an answer...',
                        fillColor: Colors.grey[200],
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.orangeAccent,
                          ),
                          onPressed: () {
                            _onCreateComment(user.uid);
                          },
                        ),
                        
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.transparent
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(
                            color: Colors.transparent
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          commentDetail = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}