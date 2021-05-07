import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/auth_service.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserObject>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {

        if (snapshot.hasData) {

          UserData userData = snapshot.data;

          return Column(
            children: [

              Text(userData.name),

              TextButton(
                child: Text('Log out'),
                onPressed: () async {
                  await AuthService().logout();
                },
              ),

            ],
          );

        } else {

          return Loading();

        }
        
      }
    );
  }
}