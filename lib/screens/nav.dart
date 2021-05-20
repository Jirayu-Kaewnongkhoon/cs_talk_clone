import 'package:cstalk_clone/screens/home/home.dart';
import 'package:cstalk_clone/screens/notification/notification.dart';
import 'package:cstalk_clone/screens/other/other.dart';
import 'package:cstalk_clone/screens/post/create_post.dart';
import 'package:cstalk_clone/screens/search/search_post.dart';
import 'package:flutter/material.dart';

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
      isScrollControlled: FocusScope.of(context).hasFocus, 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CS TALK',
          style: TextStyle(
            // color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              // color: Colors.white,
            ), 
            onPressed: _showSearch,
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
