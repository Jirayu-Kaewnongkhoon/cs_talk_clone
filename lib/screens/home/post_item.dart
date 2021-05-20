import 'package:cstalk_clone/models/post.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/skeleton/post_skeleton.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItem extends StatelessWidget {

  final Post post;
  final bool isDetail;

  PostItem({ this.post, this.isDetail });

  String _getDateTime() {
    return DateFormat('d/MM/y').add_jms().format(DateTime.fromMillisecondsSinceEpoch(post.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream: UserService(uid: post.ownerID).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          if (isDetail) {

            return _detailWidget(context, userData);

          } else {

            return _itemWidget(context, userData);
          }

        } else {
          
          return PostSkeleton();

        }
      }
    );
  }

  Widget _detailWidget(BuildContext context, UserData userData) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ListTile(
            leading: CircleAvatar(),
            title: Text(userData.name),
            subtitle: Text(_getDateTime()),
            trailing: IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {},
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 4.0, 12.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(post.postDetail),

                post.imageUrl != null ? SizedBox(height: 8.0) : Container(),

                post.imageUrl != null ? Image.network(post.imageUrl) : Container(),

              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 4.0,
              children: post.tags
                .map((tag) => 
                  InputChip(
                    backgroundColor: Colors.orange[200],
                    label: Text(
                      tag, 
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
                    },
                  )
                ).toList()
            ),
          ),

        ],
      ),
    );
  }

  Widget _itemWidget(BuildContext context, UserData userData) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // ListTile(
          //   title: Text(post.postDetail),
          //   isThreeLine: post.tags.isNotEmpty,
          //   subtitle: Wrap(
          //     spacing: 4.0,
          //     children: post.tags
          //       .map((tag) => 
          //         InputChip(
          //           backgroundColor: Colors.orange[200],
          //           label: Text(
          //             tag, 
          //             style: TextStyle(color: Colors.grey[600]),
          //           ),
          //           onPressed: () {
          //             Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
          //           },
          //         )
          //       ).toList()
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, post.tags.isEmpty ? 8.0 : 0.0),
            child: Text(
              post.postDetail, 
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 4.0,
              children: post.tags
                .map((tag) => 
                  InputChip(
                    backgroundColor: Colors.orange[200],
                    label: Text(
                      tag, 
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/filter', arguments: { 'tag': tag });
                    },
                  )
                ).toList()
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100],
                  ),
                  child: ListTile(
                    dense: true,
                    title: Icon(
                      post.acceptedCommentID != "" ? Icons.check_circle : Icons.close,
                      color: post.acceptedCommentID != "" ? Colors.greenAccent[400] : Colors.red,
                    ),
                    subtitle: Center(child: Text('Accepted Answer')),
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100],
                  ),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                    title: Center(child: Text('12')),
                    subtitle: Center(child: Text('Answer')),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
