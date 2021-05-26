import 'package:cstalk_clone/services/auth_service.dart';
import 'package:cstalk_clone/shared/constants.dart';
import 'package:cstalk_clone/shared/loading.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {

  final Function changeScreen;

  Login({ this.changeScreen });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email = '';
  String password = '';

  bool isLoading = false;

  void _onLogin() async {
    setState(() => isLoading = true);

    dynamic result = await AuthService()
      .login(email.trim(), password.trim());

    if (result == null) {

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(
                    Icons.warning,
                    color: Colors.yellow[600],
                  ),
                ),
                TextSpan(text: ' Authentication failed, Please try again'),
              ]
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
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
                    hintText: 'Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12.0
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Log in'),
                        onPressed: _onLogin, 
                      ),
                    )
                  ],
                ),

                SizedBox(height: 45.0,),

                TextButton(
                  child: Text(
                    'Don\'t have an account? Sign Up',
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