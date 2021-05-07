import 'package:flutter/material.dart';

class PostSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [

          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
            ),
            title: Container(
              color: Colors.grey[300],
              height: 14.0,
            ),
            subtitle: Container(
              color: Colors.grey[300],
              height: 14.0,
            ),
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

                SizedBox(height: 22.0),

                Container(
                  color: Colors.grey[300],
                  height: 200.0,
                )
              ],
            ),
          ),

          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: FlatButton(
                    child: Icon(
                      Icons.comment,
                      color: Colors.grey[400],
                    ),
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