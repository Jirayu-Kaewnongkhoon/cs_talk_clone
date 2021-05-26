import 'package:flutter/material.dart';

class ProfileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
      child: Column(
        children: [

          CircleAvatar(
            radius: 45.0,
          ),

          SizedBox(height: 16.0,),

          Container(
            color: Colors.grey[300],
            height: 19.0,
            width: 150.0,
          ),

        ],
      ),
    );
  }
}