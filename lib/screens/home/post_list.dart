import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/screens/home/post_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final postList = Provider.of<List<Post>>(context) ?? [];

    // if (postList.isEmpty) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(
    //           Icons.question_answer, 
    //           size: 85.0, 
    //           color: Colors.grey[350],
    //         ),
    //         Text(
    //           'No questions founded',
    //           style: TextStyle(
    //             color: Colors.grey,
    //             fontWeight: FontWeight.w600
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: SingleChildScrollView(
        child: Column(
          children: postList
            .map((post) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/detail', arguments: post.postID);
              },
              child: PostItem(
                post: post,
                isDetail: false,
              ),
            )
          ).toList(),
        ),
      ),
      // child: ListView.builder(
      //   itemCount: postList.length,
      //   itemBuilder: (context, index) {
          
      //     Post post = postList[index];

      //     return GestureDetector(
      //       onTap: () {
      //         Navigator.pushNamed(context, '/detail', arguments: post);
      //       },
      //       child: PostItem(
      //         post: post,
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
