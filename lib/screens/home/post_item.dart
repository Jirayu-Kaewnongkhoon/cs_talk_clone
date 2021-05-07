import 'package:cstalk_clone/models/post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItem extends StatelessWidget {

  final Post post;

  PostItem({ this.post });

  String _getDateTime() {
    return DateFormat.yMd().add_jms().format(DateTime.fromMillisecondsSinceEpoch(post.timestamp));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [

          ListTile(
            leading: CircleAvatar(),
            title: Text(post.ownerName),
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

                SizedBox(height: 8.0),

                Image.network('https://scontent.fbkk22-3.fna.fbcdn.net/v/t1.6435-9/178794282_327468622075185_374490667859464477_n.jpg?_nc_cat=103&ccb=1-3&_nc_sid=730e14&_nc_ohc=BnLbXcMMttkAX880EvP&_nc_ht=scontent.fbkk22-3.fna&oh=9d4457ebf1ebebc1508033b9f0e9c5ed&oe=60B11ABB'),

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
                    onPressed: () {
                      // Navigator.pushNamed(context, '/detail', arguments: widget.post);
                    }
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
