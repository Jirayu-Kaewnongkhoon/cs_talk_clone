import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  String postDetail = '';

  void _onCreatePost() async {
    await DatabaseService(uid: 'test').createPost(postDetail);
    Navigator.pop(context);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Create Post'),
  //       centerTitle: true,
  //       actions: [
  //         Visibility(
  //           visible: postDetail.length != 0,
  //           child: FlatButton(
  //             onPressed: _onCreatePost,
  //             child: Text('POST')
  //           ),
  //         ),
  //       ],
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           Form(
  //             child: TextFormField(
  //               decoration: InputDecoration(
  //                 hintText: 'Have any question ?',
  //                 enabledBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent
  //                   ),
  //                 ),
  //                 focusedBorder: OutlineInputBorder(
  //                   borderSide: BorderSide(
  //                     color: Colors.transparent
  //                   ),
  //                 ),
  //               ),
  //               maxLines: 20,
  //               onChanged: (value) {
  //                 setState(() {
  //                   postDetail = value;
  //                 });
  //               },
  //             ),
  //           ),
            
  //           // Row(
  //           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           //   children: [
  //           //     IconButton(
  //           //       icon: Icon(Icons.ac_unit),
  //           //       onPressed: () {},
  //           //     ),
  //           //     IconButton(
  //           //       icon: Icon(Icons.ac_unit),
  //           //       onPressed: () {},
  //           //     ),
  //           //     IconButton(
  //           //       icon: Icon(Icons.ac_unit),
  //           //       onPressed: () {},
  //           //     ),
  //           //   ],
  //           // ),

  //           Row(
  //             children: [
  //               Expanded(
  //                 child: FlatButton.icon(
  //                   onPressed: () {}, 
  //                   icon: Icon(Icons.add_photo_alternate), 
  //                   label: Text('Upload Image'),
  //                   color: Colors.orange[300],
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }
  
  @override
  Widget build(BuildContext context) {
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
        
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [
        //     IconButton(
        //       icon: Icon(Icons.ac_unit),
        //       onPressed: () {},
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.ac_unit),
        //       onPressed: () {},
        //     ),
        //     IconButton(
        //       icon: Icon(Icons.ac_unit),
        //       onPressed: () {},
        //     ),
        //   ],
        // ),

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
                onPressed: postDetail.length == 0 ? null : _onCreatePost, 
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
