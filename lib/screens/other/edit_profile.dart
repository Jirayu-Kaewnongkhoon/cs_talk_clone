import 'dart:io';

import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:cstalk_clone/services/storage_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:cstalk_clone/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  String _currentName = '';
  File _image;

  bool _isValid(String name) {
    return (_currentName.isNotEmpty && _currentName != name) || _image != null;
  }

  void _clearImage() {
    _image = null;
  }

  void _resetUserData() {
    setState(() {
      _clearImage();
      _currentName = '';
    });
  }

  void _onSaveUserData(UserData userData) async {

    if (_image != null) {

      String imageUrl = await StorageService().uploadImage(_image);

      if (_currentName.isNotEmpty && _currentName != userData.name) {

        await UserService(uid: userData.uid)
          .updateUserData(
            name: _currentName,
            imageUrl: imageUrl,
          );

      } else {

        await UserService(uid: userData.uid)
          .updateUserData(
            name: userData.name,
            imageUrl: imageUrl,
          );
      }

    } else {

      await UserService(uid: userData.uid)
        .updateUserData(
          name: _currentName,
          imageUrl: userData.imageUrl,
        );

    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: RichText(
          text: TextSpan(
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent[400],
                ),
              ),
              TextSpan(text: ' Your profile has been updated'),
            ]
          ),
        ),
      ),
    );
    
    _resetUserData();
  }

  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final uid = Provider.of<UserObject>(context).uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: StreamBuilder<UserData>(
        stream: UserService(uid: uid).userData,
        builder: (context, snapshot) {

          if (snapshot.hasData) {

            UserData userData = snapshot.data;
            
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      CircleAvatar(
                        backgroundImage: _image != null 
                          ? FileImage(_image) 
                          : userData.imageUrl != null 
                          ? NetworkImage(userData.imageUrl) 
                          : null,
                        radius: 75.0,
                      ),

                      SizedBox(height: 24.0),

                      Form(
                        child: TextFormField(
                          initialValue: userData.name,
                          textAlign: TextAlign.center,
                          decoration: textInputDecoration,
                          onChanged: (val) {
                            setState(() {
                              _currentName = val;
                            });
                          },
                        ),
                      ),

                      SizedBox(height: 32.0),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              label: Text('Change image'),
                              icon: Icon(Icons.add_photo_alternate), 
                              onPressed: _getImage, 
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              label: Text('Save'),
                              icon: Icon(Icons.save), 
                              onPressed: !_isValid(userData.name) ? null : () {
                                _onSaveUserData(userData);
                              }, 
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
            
          } else {

            return Loading();
          }
        }
      ),
    );
  }
}