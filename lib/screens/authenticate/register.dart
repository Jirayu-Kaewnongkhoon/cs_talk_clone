import 'package:cstalk_clone/services/auth_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final Function changeScreen;

  Register({ this.changeScreen });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String name = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(40.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15.0,),

                Image.asset(
                  'assets/images/app_logo.png',
                  width: 200.0,
                ),
                
                SizedBox(height: 25.0,),

                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: textInputDecoration.copyWith(
                    fillColor: Colors.grey[200],
                    hintText: 'Name'
                  ),
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                ),
                
                SizedBox(height: 20.0,),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: textInputDecoration.copyWith(
                    fillColor: Colors.grey[200],
                    hintText: 'E-mail'
                  ),
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                ),
                
                SizedBox(height: 20.0,),

                TextFormField(
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  decoration: textInputDecoration.copyWith(
                    fillColor: Colors.grey[200],
                    hintText: 'Password'
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),

                SizedBox(height: 15.0,),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Sign Up'),
                        onPressed: () async {
                          await AuthService().register(name, email, password);
                        }, 
                      ),
                    )
                  ],
                ),

                
                SizedBox(height: 20.0,),

                TextButton(
                  child: Text(
                    'Already have an account? Log in',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                  onPressed: widget.changeScreen,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}