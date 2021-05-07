import 'package:flutter/material.dart';

class CommentSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[300],
          ),

          SizedBox(width: 8.0,),

          Expanded(
            child: Column(
              children: [

                Flex(
                  direction: Axis.horizontal,
                  children: [

                    _commentSection(),

                    SizedBox(width: 42.0,),
                  ]
                ),
                
              ],
            ),
          ),

        ]
      ),
    );
  }

  Widget _commentSection() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              color: Colors.grey[300],
              height: 14.0,
            ),

            SizedBox(height: 4.0),
            
            Container(
              color: Colors.grey[300],
              height: 14.0,
            ),

          ],
        ),
      ),
    );
  }
}