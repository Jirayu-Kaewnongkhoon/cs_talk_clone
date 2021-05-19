import 'package:cstalk_clone/models/user.dart';
import 'package:cstalk_clone/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future login(String email, String password) async {

    try {

      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      return _userFromFirebaseUser(user);

    } catch (e) {

      print('error: ${e.toString()}');

      return null;

    }
  }

  Future register(String name, String email, String password) async {

    try {

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      await UserService(uid: user.uid).updateUserData(name: name);

      return _userFromFirebaseUser(user);

    } catch (e) {

      print('error: ${e.toString()}');

      return null;

    }
  }

  Future logout() async {
    
    try {

      return await _auth.signOut();

    } catch (e) {

      print('error: ${e.toString()}');
      
      return null;

    }
  }

  UserObject _userFromFirebaseUser(User user) {
    return user != null ? UserObject(uid: user.uid) : null;
  }

  Stream<UserObject> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }
}