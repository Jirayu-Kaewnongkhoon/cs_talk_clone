import 'dart:io';

import 'package:cstalk_clone/models/comment.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/comment_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CommentItem extends StatefulWidget {

  final Comment comment;
  final String postOwnerID;
  final Function onEditComment;

  CommentItem({ this.comment, this.postOwnerID, this.onEditComment });

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {

  String _commentDetail = '';
  File _image;

  bool _isEdit = false;

  Comment currentComment;

  void _clearImage() {

    setState(() {
      if (_isEdit) {
        currentComment.imageUrl = null;
      }
      _image = null;
    });

  }

  bool _isValid() {
    return (_commentDetail.isNotEmpty && _commentDetail != currentComment.commentDetail)
      || _image != null
      || widget.comment.imageUrl != currentComment.imageUrl;
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _onUpVote(String uid) async {

    // show snackbar แจ้ง
    // ถ้าเป็น comment ตัวเอง จะกดโหวตไม่ได้
    if (uid == widget.comment.ownerID) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.info,
                    color: Colors.grey[350],
                  ),
                ),
                TextSpan(text: ' You can\'t vote for your own answer'),
              ]
            ),
          ),
        ),
      );

      return;
    }

    if (!widget.comment.upVoteList.contains(uid)) {

      widget.comment.upVoteList.add(uid);
      widget.comment.downVoteList.remove(uid);
      
      await NotificationService(
        uid: widget.comment.ownerID,
        postID: widget.comment.postID,
      ).createNotificaion('up', uid);

    } else {

      widget.comment.upVoteList.remove(uid);
    }

    await CommentService(
      postID: widget.comment.postID,
      commentID: widget.comment.commentID
    ).voteComment(
      upVoteList: widget.comment.upVoteList,
      downVoteList: widget.comment.downVoteList,
    );
    
  }

  void _onDownVote(String uid) async {

    // show snackbar แจ้ง
    // ถ้าเป็น comment ตัวเอง จะกดโหวตไม่ได้
    if (uid == widget.comment.ownerID) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.info,
                    color: Colors.grey[350],
                  ),
                ),
                TextSpan(text: ' You can\'t vote for your own answer'),
              ]
            ),
          ),
        ),
      );

      return;
    }

    if (!widget.comment.downVoteList.contains(uid)) {

      widget.comment.downVoteList.add(uid);
      widget.comment.upVoteList.remove(uid);

      await NotificationService(
        uid: widget.comment.ownerID,
        postID: widget.comment.postID,
      ).createNotificaion('down', uid);

    } else {

      widget.comment.downVoteList.remove(uid);
    }

    await CommentService(
      postID: widget.comment.postID,
      commentID: widget.comment.commentID
    ).voteComment(
      upVoteList: widget.comment.upVoteList,
      downVoteList: widget.comment.downVoteList,
    );

  }

  void _onAcceptComment(bool isAccepted, String uid) async {

    String commentID = '';

    if (!isAccepted) {
      
      commentID = widget.comment.commentID;

      await NotificationService(
        uid: widget.comment.ownerID,
        postID: widget.comment.postID,
      ).createNotificaion('accept', uid);

    } 

    await CommentService(
      postID: widget.comment.postID,
      commentID: commentID,
    ).addAcceptedComment();

  }

  void _onEditComment(BuildContext context) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);

      widget.comment.imageUrl = imageUrl;

    } else {

      if (widget.comment.imageUrl != currentComment.imageUrl) {

        widget.comment.imageUrl = null;
      }
    }

    if (_commentDetail.isNotEmpty && _commentDetail != currentComment.commentDetail) {

      widget.comment.commentDetail = _commentDetail;
      
    }

    await CommentService(
      postID: widget.comment.postID,
      commentID: widget.comment.commentID
    ).updateComment(widget.comment.commentDetail, widget.comment.imageUrl);

    // เปลี่ยน state ให้ rebuild กลับเป็น comment ปกติ
    setState(() => _isEdit = false);

    // เรียกใช้ callback จาก PostDetail
    widget.onEditComment();

    // แสดง snackbar การทำ process
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
              TextSpan(text: ' Your answer has been updated'),
            ]
          ),
        ),
      ),
    );
  }

  void _onRemoveComment(BuildContext context) async {

    await CommentService(
      postID: widget.comment.postID,
      commentID: widget.comment.commentID
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
              TextSpan(text: ' Your answer has been deleted'),
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
      stream: UserService(uid: widget.comment.ownerID).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: userData.imageUrl != null ? NetworkImage(userData.imageUrl) : null,
                ),

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
                          color: widget.comment.upVoteList.contains(uid) ? Colors.orangeAccent : Colors.grey,
                        ), 
                        onPressed: () => _onUpVote(uid),
                      ),

                      Text(widget.comment.voteCount.toString()),

                      IconButton(
                        icon: Icon(
                          Icons.arrow_drop_down, 
                          size: 30.0,
                          color: widget.comment.downVoteList.contains(uid) ? Colors.orangeAccent : Colors.grey,
                        ), 
                        onPressed: () => _onDownVote(uid),
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
                onTap: () {
                  setState(() => _isEdit = true);
                  widget.onEditComment();
                  Navigator.pop(context);

                  if (_isEdit) {
                    currentComment = widget.comment.clone();
                  }
                },
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
            onLongPress: uid != widget.comment.ownerID ? null : () => _popupMenu(context),
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
                  
                  _isEdit ? 
                    TextFormField(
                      initialValue: currentComment.commentDetail,
                      textInputAction: TextInputAction.newline,
                      autofocus: true,
                      maxLines: 7,
                      onChanged: (val) => setState(() => _commentDetail = val),
                      decoration: postInputDecoration.copyWith(
                        suffixIcon: Column(
                          children: [
                            
                            IconButton( 
                              tooltip: 'Upload Image',
                              icon: Icon(
                                Icons.add_photo_alternate,
                                color: Colors.orangeAccent,
                              ),
                              onPressed: _getImage,
                            ),

                            IconButton(
                              tooltip: 'Update',
                              icon: Icon(
                                Icons.save,
                                color: Colors.orangeAccent,
                              ),
                              onPressed: !_isValid() ? null : () => _onEditComment(context), 
                            ),
                          ],
                        ),
                      ),
                    ) : Text(widget.comment.commentDetail),

                  _isEdit ? Row(
                    children: [
                      Expanded(
                        child: FlatButton(
                          child: Text('Cancel'),
                          color: Colors.orangeAccent,
                          onPressed: () {
                            setState(() => _isEdit = false);
                            widget.onEditComment();
                          },
                        ),
                      ),
                    ],
                  ) : Container(),

                  widget.comment.imageUrl != null ? SizedBox(height: 4.0) : Container(),

                   _imageSection(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageSection() {

    if (_isEdit) {

      if (_image != null) {

        return _showImage(Image.file(_image));

      } else {

        if (currentComment.imageUrl != null) {

          return _showImage(Image.network(currentComment.imageUrl));

        }
      }

    } else {

      if (widget.comment.imageUrl != null) {

        return Image.network(widget.comment.imageUrl);

      }
    }

    return Container();
  }

  Widget _showImage(Image image) {
    return Center(
      child: Stack(
        children:[
          image,
          
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
          )
        ],
      ),
    );
  }

  Widget _acceptCommentSection(String uid) {
    return StreamBuilder<String>(
      stream: PostService(postID: widget.comment.postID).acceptedCommentID,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          String acceptedCommentID = snapshot.data;

          if (uid == widget.postOwnerID) {

            return _ownerWidget(acceptedCommentID, uid);

          } else {

            return _visitorWidget(acceptedCommentID);

          }

        }

        return Container();
      }
    );
  }

  Widget _ownerWidget(String acceptedCommentID, String uid) {

    if (acceptedCommentID.isEmpty) {

      return OutlinedButton(
        child: Text('Accept Answer'), 
        onPressed: () {
          _onAcceptComment(false, uid);
        },
      );

    }

    return Visibility(
      visible: acceptedCommentID == widget.comment.commentID,
      child: OutlinedButton.icon(
        icon: Icon(
          Icons.check_circle, 
          color: Colors.greenAccent[400],
        ), 
        label: Text('Unaccept Answer'), 
        onPressed: () {
          _onAcceptComment(true, uid);
        },
      ),
    );

  }

  Widget _visitorWidget(String acceptedCommentID) {
    return Visibility(
      visible: acceptedCommentID == widget.comment.commentID,
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