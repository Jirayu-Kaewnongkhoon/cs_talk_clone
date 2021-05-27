import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/post/create_post.dart';
import 'package:cstalk_clone/screens/skeleton/post_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum PostAction { edit, remove }

class PostItem extends StatelessWidget {

  final Post post;
  final bool isDetail;

  PostItem({ this.post, this.isDetail });

  String _getDateTime(int timestamp) {
    return DateFormat('d MMMM y ').add_jms().format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  void _onPostActionClick(BuildContext context, PostAction action, Post post) async {
    
    switch (action) {

      case PostAction.edit :
        _onEditPost(context, post);
        break;

      case PostAction.remove :
        await _showConfirmDialog(context);
        _onRemovePost(context);
        break;
    }
  }

  void _onEditPost(BuildContext context, Post post) async {
    showModalBottomSheet(
      isScrollControlled: true, 
      context: context, 
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 150.0,
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: CreatePost(post: post),
        );
      }
    );
  }

  void _onRemovePost(BuildContext context) async {
    await PostService(postID: post.postID).removePost();

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
              TextSpan(text: ' Your question has been deleted'),
            ]
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm to remove question?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Removed question can\'t be recovered.'),
                Text('Are you sure you want to continue?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: UserService(uid: post.ownerID).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          if (isDetail) {

            return _detailWidget(context, userData);

          } else {

            return _itemWidget(context, userData);
          }

        } else {
          
          return PostSkeleton(isDetail: isDetail);

        }
      }
    );
  }

  Widget _popupMenu(BuildContext context, Post post) {
    return PopupMenuButton<PostAction>(
      icon: Icon(Icons.more_horiz),
      onSelected: (action) => _onPostActionClick(context, action, post),
      itemBuilder: (context) => <PopupMenuEntry<PostAction>>[

        PopupMenuItem<PostAction>(
          value: PostAction.edit,
          child: Text('Edit'),
        ),

        PopupMenuItem<PostAction>(
          value: PostAction.remove,
          child: Text('Remove'),
        ),
      ],
    );
  }

  Widget _detailWidget(BuildContext context, UserData userData) {

    final uid = Provider.of<UserObject>(context).uid;

    return StreamBuilder<Post>(
      stream: PostService(postID: post.postID).postByID,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          Post post = snapshot.data;
          
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: userData.imageUrl != null ? NetworkImage(userData.imageUrl) : null,
                  ),
                  title: Text(userData.name),
                  subtitle: Text(_getDateTime(post.timestamp)),
                  trailing: uid != post.ownerID ? null : _popupMenu(context, post),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(post.postDetail),

                      post.imageUrl != null ? SizedBox(height: 8.0) : Container(),

                      post.imageUrl != null ? Image.network(post.imageUrl) : Container(),

                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Wrap(
                    spacing: 4.0,
                    children: post.tags
                      .map((tag) => 
                        InputChip(
                          backgroundColor: Colors.orange[200],
                          label: Text(
                            tag, 
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
                          },
                        )
                      ).toList()
                  ),
                ),

              ],
            ),
          );

        } else {

          return PostSkeleton(isDetail: isDetail);
        }
      }
    );
  }

  Widget _itemWidget(BuildContext context, UserData userData) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // ListTile(
          //   title: Text(post.postDetail),
          //   isThreeLine: post.tags.isNotEmpty,
          //   subtitle: Wrap(
          //     spacing: 4.0,
          //     children: post.tags
          //       .map((tag) => 
          //         InputChip(
          //           backgroundColor: Colors.orange[200],
          //           label: Text(
          //             tag, 
          //             style: TextStyle(color: Colors.grey[600]),
          //           ),
          //           onPressed: () {
          //             Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
          //           },
          //         )
          //       ).toList()
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, post.tags.isEmpty ? 8.0 : 0.0),
            child: Text(
              post.postTitle, 
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          post.tags.isNotEmpty ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 4.0,
              children: post.tags
                .map((tag) => 
                  InputChip(
                    backgroundColor: Colors.orange[200],
                    label: Text(
                      tag, 
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
                    },
                  )
                ).toList()
            ),
          ) : SizedBox(height: 25,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              // Expanded(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15.0),
              //       color: Colors.grey[100],
              //     ),
              //     child: ListTile(
              //       dense: true,
              //       title: Icon(
              //         post.acceptedCommentID != "" ? Icons.check_circle : Icons.close,
              //         color: post.acceptedCommentID != "" ? Colors.greenAccent[400] : Colors.red,
              //       ),
              //       subtitle: Center(child: Text('Accepted Answer')),
              //     ),
              //   ),
              // ),

              // Expanded(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(15.0),
              //       color: Colors.grey[100],
              //     ),
              //     child: ListTile(
              //       dense: true,
              //       contentPadding: EdgeInsets.symmetric(vertical: 0.0),
              //       title: Center(child: Text('12')),
              //       subtitle: Center(child: Text('Answer')),
              //     ),
              //   ),
              // ),

              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        post.acceptedCommentID != "" ? Icons.check_circle : Icons.close,
                        color: post.acceptedCommentID != "" ? Colors.greenAccent[400] : Colors.red,
                      ),
                      Center(child: Text('Accepted Answer')),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(height: 1,),
                      Center(child: StreamBuilder<int>(
                        stream: CommentService(postID: post.postID).totalComment,
                        builder: (context, snapshot) {

                          int totalComment = 0;

                          if (snapshot.hasData) totalComment = snapshot.data;

                          return Text('$totalComment', style: TextStyle(fontSize: 16,));
                        }
                      )),
                      SizedBox(height: 1,),
                      Center(child: Text('Total Answer')),
                    ],
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
