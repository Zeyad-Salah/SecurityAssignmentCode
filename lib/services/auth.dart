// ignore_for_file: recursive_getters, avoid_print, non_constant_identifier_names, duplicate_ignore

import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on FirebaseUser
  MyUser _userFromFirebaseUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<MyUser> get user {
    // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
// sign in with email and password

  Future signInWithEmailandPassword(String Email, String Password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: Email, password: Password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// register with email and password

  Future registerWithEmailandPassword(String Email, String Password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: Email, password: Password);
      User user = result.user;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid)
          .updateUserData('0', 'new book added');
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signout() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
