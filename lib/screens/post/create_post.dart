import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String postDetail = '';

  void _onCreatePost(String ownerID) async {
    await DatabaseService().createPost(postDetail, ownerID);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObject>(context);

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
                  _onCreatePost(user.uid);
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
}
