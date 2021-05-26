import 'package:flutter/material.dart';

class NotificationSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: Colors.grey[300],
        size: 30.0,
      ),
      title: Container(
        color: Colors.grey[300],
        height: 14.0,
      ),
      subtitle: Container(
        color: Colors.grey[300],
        height: 14.0,
      ),
      onTap: () {},
    );
  }
}