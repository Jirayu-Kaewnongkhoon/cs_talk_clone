import 'package:flutter/material.dart';

class PostSkeleton extends StatelessWidget {

  final bool isDetail;

  PostSkeleton({ this.isDetail });

  @override
  Widget build(BuildContext context) {
    
    if (isDetail) {

      return _detailWidget();

    } else {

      return _itemWidget();
    }

  }

  Widget _detailWidget() {
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

        ],
      ),
    );
  }

  Widget _itemWidget() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0.0),
            child: Column(
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
          
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Wrap(
              spacing: 4.0,
              children: [
                InputChip(
                  backgroundColor: Colors.grey[300],
                  label: Text(
                    '       ', 
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onPressed: () {},
                ),
                InputChip(
                  backgroundColor: Colors.grey[300],
                  label: Text(
                    '       ', 
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  onPressed: () {},
                ),
              ]
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[300],
                  ),
                ),
              ),

              Expanded(
                child: Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[300],
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