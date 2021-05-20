import 'dart:io';

import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String _postTitle = '';
  String _postDetail = '';
  List<String> _tags = [];
  bool _isAddClick = false;
  bool _isFirstAddClick = false;
  File _image;

  final _tagController = TextEditingController();

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _onCreatePost(String ownerID) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);

      await PostService(uid: ownerID).createPost(_postTitle, _postDetail, _tags, imageUrl);

    } else {

      await PostService(uid: ownerID).createPost(_postTitle, _postDetail, _tags, null);
    }
    
    _clearImage();

    Navigator.pop(context);
  }

  void _clearImage() {
    setState(() {
      _image = null;
    });
  }

  bool _isValid() {
    return (_postTitle.isNotEmpty && _postDetail.isNotEmpty) || _image != null;
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

  void _onEnter(String tag) {
    setState(() {
      _tags.add(tag);
      _isAddClick = false;
    });

    _tagController.clear();
  }
  
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObject>(context);

    return Form(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            TextFormField(
              textInputAction: TextInputAction.next,
              decoration: postInputDecoration.copyWith(
                hintText: 'Title'
              ),
              onChanged: (value) => setState(() => _postTitle = value),
            ),

            SizedBox(height: 4.0,),
            
            TextFormField(
              decoration: postInputDecoration.copyWith(
                hintText: 'Description'
              ),
              maxLines: 7,
              onChanged: (value) => setState(() => _postDetail = value),
            ),

            SizedBox(height: 4.0,),

            Container(
              padding: _isFirstAddClick ? EdgeInsets.all(8.0) : EdgeInsets.zero,
              color: _isFirstAddClick ? Colors.white : Colors.transparent,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 4.0,
                children: _tags
                  .map<Widget>((tag) => 
                    Chip(
                      backgroundColor: Colors.orange[200],
                      label: Text(
                        tag, 
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      deleteIcon: Icon(Icons.close),
                      onDeleted: () {
                        setState(() {
                          _tags.remove(tag);
                        });
                      },
                    )
                  ).toList()
                  ..add(
                    !_isAddClick ? 
                    InputChip(
                      label: RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Icon(
                                Icons.add, 
                                color: Colors.black,
                              ), 
                              alignment: PlaceholderAlignment.middle
                            ),
                            
                            TextSpan(
                              text: ' Add Tag', 
                              style: TextStyle(color: Colors.black)
                            ),

                            if (!_isFirstAddClick) 
                              TextSpan(
                                text: ' (Recommend)', 
                                style: TextStyle(
                                  color: Colors.grey, 
                                  fontStyle: FontStyle.italic
                                )
                              ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isAddClick = true;
                          _isFirstAddClick = true;
                        });
                      }, 
                    )
                    : ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 48.0,
                      ),
                      child: IntrinsicWidth(
                        child: TextFormField(
                          controller: _tagController,
                          decoration: textInputDecoration.copyWith(
                            fillColor: Colors.white,
                            hintText: 'Tag'
                          ),
                          onFieldSubmitted: (tag) {
                            if (tag.isNotEmpty) {
                              _onEnter(tag);
                            }
                          },
                        ),
                      ),
                    ),
                  )
              ),
            ),

            SizedBox(height: 4.0,),

            _image != null ? Center(
              child: Stack(
                children:[
                  Image.file(
                    _image,
                    width: 100.0,
                  ),
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
            ) : Container(),

            FlatButton.icon(
              onPressed: _getImage, 
              icon: Icon(Icons.add_photo_alternate), 
              label: Text('Upload Image'),
              color: Colors.orange[300],
            ),

            FlatButton.icon(
              onPressed: !_isValid() ? null : () {
                _onCreatePost(user.uid);
              }, 
              icon: Icon(Icons.create), 
              label: Text('Post'),
              color: Colors.orange[300],
            )
          ],
        ),
      ),
    );
  }
}
