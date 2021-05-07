import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {

  String uid;

  CreatePost({ this.uid });

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String postDetail = '';

  void _onCreatePost(String ownerName) async {
    await DatabaseService().createPost(postDetail, ownerName);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: widget.uid).userData,
      builder: (context, snapshot) {

        UserData userData = snapshot.data;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Have any question ?',
                  fillColor: Colors.white,
                  filled: true,

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent
                    ),
                  ),
                ),
                maxLines: 7,
                onChanged: (value) {
                  setState(() {
                    postDetail = value;
                  });
                },
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: FlatButton.icon(
                    onPressed: () {}, 
                    icon: Icon(Icons.add_photo_alternate), 
                    label: Text('Upload Image'),
                    color: Colors.orange[300],
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: FlatButton.icon(
                    onPressed: postDetail.length == 0 ? null : () {
                      _onCreatePost(userData.name);
                    }, 
                    icon: Icon(Icons.create), 
                    label: Text('Post'),
                    color: Colors.orange[300],
                  ),
                ),
              ],
            )
          ],
        );

      }
    );
  }
}
