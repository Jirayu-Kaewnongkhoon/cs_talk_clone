import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/screens/home/post_item.dart';
import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {

  Post post;

  @override
  Widget build(BuildContext context) {

    post = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            PostItem(post: post),
            Text('comment'),
            Text('comment'),
            Text('comment'),
            Text('comment'),
            Text('comment'),
            Text('comment'),
          ],
        ),
      ),
    );
  }
}