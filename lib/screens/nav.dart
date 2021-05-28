import 'package:cstalk_clone/models/notification.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/home/home.dart';
import 'package:cstalk_clone/screens/notification/notification.dart';
import 'package:cstalk_clone/screens/other/other.dart';
import 'package:cstalk_clone/screens/post/create_post.dart';
import 'package:cstalk_clone/screens/search/search_post.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum NotificationAction { read, clear }

class Nav extends StatefulWidget {
  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {

  int _selectedScreen = 0;

  List<Widget> screens = [
    Home(),
    PostNotification(),
    Other(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void _onCreatePost() {
    showModalBottomSheet(
      isScrollControlled: true, 
      context: context, 
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height - 150.0,
          color: Colors.grey[200],
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: CreatePost(),
        );
      }
    );
  }

  void _showSearch() {
    showSearch(context: context, delegate: SearchPost());
  }

  void _onMarkAsRead(String uid) async {
    List<NotificationObject> list = await NotificationService(uid: uid).all;

    list.forEach((element) async {
      if (!element.isActivate) {
        await NotificationService(uid: uid, notificationID: element.notificationID).updateNotificaionStatus();
      }
    });
  }

  void _onClearNotification(String uid) async {

    List<NotificationObject> list = await NotificationService(uid: uid).all;

    list.forEach((element) async {
      await NotificationService(uid: uid, notificationID: element.notificationID).removeNotification();
    });
    
  }

  Widget _showPopupMenu() {
    final uid = Provider.of<UserObject>(context).uid;
    
    return PopupMenuButton<NotificationAction>(
      icon: Icon(Icons.more_vert),
      onSelected: (action) => {action == NotificationAction.read ? _onMarkAsRead(uid) : _onClearNotification(uid)},
      itemBuilder: (context) => <PopupMenuEntry<NotificationAction>>[

        PopupMenuItem<NotificationAction>(
          value: NotificationAction.read,
          child: Text('Mark all as read'),
        ),

        PopupMenuItem<NotificationAction>(
          value: NotificationAction.clear,
          child: Text('Clear all notification'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CS TALK',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Visibility(
            visible: _selectedScreen == 0,
            child: IconButton(
              icon: Icon(
                Icons.search,
              ), 
              onPressed: _showSearch,
            ),
          ),
          Visibility(
            visible: _selectedScreen == 1,
            child: _showPopupMenu(),
          )
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: screens.elementAt(_selectedScreen),
      ),
      floatingActionButton: Visibility(
        visible: _selectedScreen == 0,
        child: FloatingActionButton(
          child: Icon(Icons.create_rounded),
          onPressed: _onCreatePost,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Other',
          ),
        ],
        currentIndex: _selectedScreen,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
