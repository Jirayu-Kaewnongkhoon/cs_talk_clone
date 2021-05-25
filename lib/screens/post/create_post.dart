import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreatePost extends StatefulWidget {

  final Post post;

  CreatePost({ this.post });
  
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String _postTitle = '';
  String _postDetail = '';
  List<String> _tags = [];
  File _image;

  bool _isFirstAddClick = false;
  bool _isAddClick = false;
  bool _isEdit = false;

  Post currentPost;

  final _tagController = TextEditingController();

  @override
  void initState() {
    
    if (widget.post != null) {

      // currentPost => ใช้เก็บ Post ก่อนการแก้ไข และ ใช้แสดงผล
      // widget.post => เป็นตัวที่จะถูกแก้ไข และ อัปขึ้น db
      currentPost = widget.post.clone();

      _isFirstAddClick = true;
      _tags = List<String>.from(widget.post.tags);
      _isEdit = true;
    }
    
    super.initState();
  }
  
  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _onSubmit(String ownerID) async {

    if (_isEdit) {

      await _editPost(ownerID);

    } else {

      await _createPost(ownerID);

    }

    _clearImage();

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
              TextSpan(text: ' Your question has been ' + (_isEdit ? 'updated' : 'created')),
            ]
          ),
        ),
      ),
    );
  }

  Future<void> _createPost(String ownerID) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);

      await PostService(uid: ownerID).createPost(_postTitle, _postDetail, _tags, imageUrl);

    } else {

      await PostService(uid: ownerID).createPost(_postTitle, _postDetail, _tags, null);
    }

  }

  Future<void> _editPost(String ownerID) async {

    // เช็คกรณีของการเปลี่ยนแปลงข้อมูล
    // ที่ต้องเช็คเพราะว่าเรา validate ข้อมูลจากการเปลี่ยนแปลง
    // ถ้าข้อมูลเหมือนเดิม ก็จะไม่ให้กด submit


    if (_image != null) {

      // กรณีที่อัปรูปใหม่ ก็อัปโหลดขึ้น db เลย
      String imageUrl = await StorageService().uploadImage(_image);

      widget.post.imageUrl = imageUrl;

    } else {

      // กรณีที่ไม่ได้อัปรูปใหม่ แต่เอารูปเก่าออก
      if (widget.post.imageUrl != currentPost.imageUrl) {

        widget.post.imageUrl = null;

      }
    }

    // กรณีที่เปลี่ยนแปลง postTitle
    if (_postTitle.isNotEmpty && _postTitle != currentPost.postTitle) {

      widget.post.postTitle = _postTitle;

    }

    // กรณีที่เปลี่ยนแปลง postDetail
    if (_postDetail.isNotEmpty && _postDetail != currentPost.postDetail) {

      widget.post.postDetail = _postDetail;
      
    }

    // กรณีที่เปลี่ยนแปลง tags
    if (!ListEquality().equals(_tags, currentPost.tags)) {

      widget.post.tags = _tags;
      
    }

    await PostService(postID: widget.post.postID)
        .updatePost(
          postTitle: widget.post.postTitle,
          postDetail: widget.post.postDetail,
          imageUrl: widget.post.imageUrl,
          tags: widget.post.tags,
        );
  }

  void _clearImage() {

    setState(() {
      if (_isEdit) {
        currentPost.imageUrl = null;
      }
      _image = null;
    });

  }

  bool _isValid() {

    if (_isEdit) {

      return (_postTitle.isNotEmpty && _postTitle != currentPost.postTitle)
        || (_postDetail.isNotEmpty && _postDetail != currentPost.postDetail)
        || (!ListEquality().equals(_tags, currentPost.tags))
        || _image != null
        || widget.post.imageUrl != currentPost.imageUrl;
    }

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
              initialValue: currentPost?.postTitle ?? '',
              textInputAction: TextInputAction.next,
              decoration: postInputDecoration.copyWith(
                hintText: 'Title'
              ),
              onChanged: (value) => setState(() => _postTitle = value),
            ),

            SizedBox(height: 4.0,),
            
            TextFormField(
              initialValue: currentPost?.postDetail ?? '',
              decoration: postInputDecoration.copyWith(
                hintText: 'Description'
              ),
              maxLines: 7,
              onChanged: (value) => setState(() => _postDetail = value),
            ),

            SizedBox(height: 4.0,),

            _tagSection(),

            SizedBox(height: 4.0,),

            _imageSection(),

            FlatButton.icon(
              onPressed: _getImage, 
              icon: Icon(Icons.add_photo_alternate), 
              label: Text('Upload Image'),
              color: Colors.orange[300],
            ),

            FlatButton.icon(
              onPressed: !_isValid() ? null : () {
                _onSubmit(user.uid);
              }, 
              icon: Icon(Icons.create), 
              label: Text(_isEdit ? 'Update' : 'Post'),
              color: Colors.orange[300],
            )
          ],
        ),
      ),
    );
  }

  Widget _tagSection() {
    return Container(
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
    );
  }

  Widget _imageSection() {

    if (_image != null) {

      return _showImage(Image.file(_image));

    } else {

      if (currentPost?.imageUrl != null) {

        return _showImage(Image.network(currentPost?.imageUrl));

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
}
