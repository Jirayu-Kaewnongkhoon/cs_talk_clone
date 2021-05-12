import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/screens/home/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  @override
  Widget build(BuildContext context) {

    final postList = Provider.of<List<Post>>(context) ?? [];

    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          children: postList
            .map((post) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: post);
              },
              child: PostItem(
                post: post,
              ),
            )
          ).toList(),
        ),
      ),
      // child: ListView.builder(
      //   itemCount: postList.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {
      //         Navigator.pushNamed(context, '/detail', arguments: postList[index]);
      //       },
      //       child: PostItem(
      //         post: postList[index],
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
