// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:brew_crew/screens/authenticate/authenticate.dart';
import 'package:brew_crew/screens/authenticate/verify_email.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/models/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);
    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return VerifyEmailPage();
    }
  }
}
