import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/screens/home/post_list.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: PostService().posts,
      child: Container(
        child: PostList(),
      ),
    );
  }
}
