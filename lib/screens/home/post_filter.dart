import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/screens/home/post_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostFilter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Map arguments = ModalRoute.of(context).settings.arguments;
    String tag = arguments['tag'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tag \"$tag\"'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear), 
            onPressed: () { 
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); 
            }
          )
        ],
      ),
      body: StreamProvider<List<Post>>.value(
        value: PostService(tag: tag).postsByTag,
        child: Container(
          child: PostList(),
        ),
      ),
    );
  }
}