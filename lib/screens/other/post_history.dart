import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/home/post_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;

    return StreamProvider<List<Post>>.value(
      value: PostService(uid: uid).postsByUser,
      child: Scaffold(
        appBar: AppBar(
          title: Text('History'),
        ),
        body: PostList(),
      ),
    );
  }
}