import 'dart:io';

import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/home/post_item.dart';
import 'package:cstalk_clone/screens/post/comment_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostDetail extends StatefulWidget {
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  Post post;

  String _commentDetail = '';
  File _image;

  bool _isEdit = false;

  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onEditComment() {
    setState(() {
      _isEdit = !_isEdit;
    });
  }

  void _onCreateComment(String uid) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);
      
      await CommentService(
        uid: uid,
        postID: post.postID,
      ).createComment(
        commentDetail: _commentDetail, 
        imageUrl: imageUrl
      );

    } else {

      await CommentService(
        uid: uid,
        postID: post.postID,
      ).createComment(commentDetail: _commentDetail);
    }

    if (uid != post.ownerID) {

      await NotificationService(
        uid: post.ownerID,
        postID: post.postID
      ).createNotificaion('reply', uid);
    
    }

    _commentController.clear();
    _clearImage();

    FocusScope.of(context).unfocus();
  }

  Future _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  bool _isValid() {
    return _commentDetail.isNotEmpty || _image != null;
  }

  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context).settings.arguments;
    final user = Provider.of<UserObject>(context);

    return StreamBuilder<Post>(
      stream: PostService(postID: id).postByID,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          post = snapshot.data;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                post.postTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PostItem(
                    post: post,
                    isDetail: true,
                  ),

                  SizedBox(height: 4.0),
                  
                  StreamProvider<List<Comment>>.value(
                    value: CommentService(postID: post.postID).comments,
                    child: CommentList(
                      postOwnerID: post.ownerID,
                      onEditComment: _onEditComment,
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: _image != null ? Container(
              height: 80.0,
              padding: EdgeInsets.symmetric(vertical: 4.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Center(
                child: Stack(
                  children:[
                    Image.file(_image),

                    Positioned(
                      top: -8,
                      right: -8,
                      child: IconButton(
                        icon: Icon(
                          Icons.close, 
                          color: Colors.red,
                        ), 
                        onPressed: _clearImage,
                      ),
                    ),
                  ],
                ),
              ),
            ) : Container(width: 0,),
            bottomNavigationBar: _isEdit ? null : Transform.translate(
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
                            onPressed: _getImage,
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
                                onPressed: !_isValid() ? null : () {
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
                            onChanged: (value) => setState(() => _commentDetail = value),
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

        return Scaffold(
          appBar: AppBar(
            title: Text('Question not found'),
          ),
          body: Center(
            child: Text(
              'This question is no longer available',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[400],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }
    );
  }
}