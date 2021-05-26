import 'package:cstalk_clone/models/menu.dart';
import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/screens/other/edit_profile.dart';
import 'package:cstalk_clone/screens/other/post_history.dart';
import 'package:cstalk_clone/screens/skeleton/profile_skeleton.dart';
import 'package:cstalk_clone/services/auth_service.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Other extends StatefulWidget {
  @override
  _OtherState createState() => _OtherState();
}

class _OtherState extends State<Other> {

  List<Menu> _menuList = [
    Menu('Edit Profile', EditProfile(), Icons.edit),
    Menu('Post History', PostHistory(), Icons.history),
    Menu('Log out', null, Icons.exit_to_app),
  ];

  Future<void> _onMenuClick(Menu menu) async {

    if (menu.menuName == 'Log out') {

      await AuthService().logout();
      return;
    }

    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => menu.menuPage
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;
    
    return Container(
      child: Column(
        children: [
          _profile(uid),

          SizedBox(height: 24.0,),

          Expanded(child: _menu()),
        ],
      ),
    );
  }

  Widget _profile(String uid) {
    return StreamBuilder<UserData>(
      stream: UserService(uid: uid).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;
          
          return Container(
            padding: EdgeInsets.fromLTRB(8.0, 24.0, 8.0, 8.0),
            child: Column(
              children: [

                CircleAvatar(
                  radius: 45.0,
                  backgroundImage: userData.imageUrl != null ? NetworkImage(userData.imageUrl) : null,
                ),

                SizedBox(height: 16.0,),

                Text(
                  userData.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19.0,
                  ),
                ),

              ],
            ),
          );
        }

        return ProfileSkeleton();
      }
    );
  }

  Widget _menu() {
    return Column(
      children: _menuList
        .map((menu) => Card(
          elevation: 0.5,
          margin: EdgeInsets.symmetric(vertical: 1.0),
          child: ListTile(
            leading: Icon(
              menu.menuIcon,
              color: Colors.orangeAccent,
            ),
            title: Text(menu.menuName),
            onTap: () async {
              await _onMenuClick(menu);
            },
          ),
        )).toList()
    );
  }
}