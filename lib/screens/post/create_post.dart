import 'dart:io';

import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String _postDetail = '';
  File _image;

  _onCreatePost(String ownerID) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);

      await PostService(uid: ownerID).createPost(_postDetail, imageUrl);

    } else {

      await PostService(uid: ownerID).createPost(_postDetail, null);
    }
    

    _clearImage();

    Navigator.pop(context);
  }

  _clearImage() {
    _image = null;
  }

  bool _isValid() {
    return _postDetail.isNotEmpty || _image != null;
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
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObject>(context);

    return Form(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            TextFormField(
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
                  _postDetail = value;
                });
              },
            ),

            _image != null ? Stack(
              children:[
                Image.file(
                  _image,
                  width: 75.0,
                ),
                Positioned(
                  left: 40.0,
                  bottom: 40.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.close, 
                      color: Colors.red,
                    ), 
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                  ),
                )
              ],
            ) : Container(),

            Row(
              children: [
                Expanded(
                  child: FlatButton.icon(
                    onPressed: _getImage, 
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
                    onPressed: !_isValid() ? null : () {
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
        ),
      ),
    );
  }
}
