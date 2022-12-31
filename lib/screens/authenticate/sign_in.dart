// ignore_for_file: deprecated_member_use, prefer_const_constructors, avoid_print, non_constant_identifier_names, unused_field, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:brew_crew/screens/authenticate/forgot_pass.dart';
import 'package:brew_crew/screens/authenticate/registar.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/screens/OTP.dart';
import 'package:brew_crew/main.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // text field state
  String Email = '';
  String Password = '';
  String Error = '';
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

//   @override
//   Widget build(BuildContext) => SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 40),
//         TextField(
//           controller: emailController,
//           cursorColor: Colors.white,
//           textInputAction: TextInputAction.next,
//           decoration: InputDecoration(labelText: 'Email'),
//         ),
//         SizedBox(height: 40),
//         TextField(
//           controller: passwordController,
//           textInputAction: TextInputAction.done,
//           decoration: InputDecoration(labelText: 'Password'),
//           obscureText: true,
//         ),
//         SizedBox(height: 40),
//         ElevatedButton.icon(
//           style: ElevatedButton.styleFrom(
//             minimumSize: Size.fromHeight(50),
//           ),
//           icon: Icon(Icons.lock_open, size: 32),
//           label: Text(
//             'Sign In',
//             style: TextStyle(fontSize: 24),
//           ),
//           onPressed: signIn,
//         )
//       ],
//     ),
//   );

//   Future signIn() async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(child: CircularProgressIndicator()));
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       print(e);
//     }

//     navigatorKey.currentState.popUntil((route) => route.isFirst);
//   }
// }
  @override
  Widget build(BuildContext context) {
   return loading
       ? Loading()
       : Scaffold(
           backgroundColor: Colors.brown[100],
          appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign in to Application'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                )
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an Email' : null,
                      onChanged: (val) {
                        setState(() => Email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: 'Password'),
                      obscureText: true,
                      validator: (val) => val.length < 6
                          ? 'Enter a password 6+ chars long'
                          : null,
                      onChanged: (val) {
                        setState(() => Password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.pink[400],
                        child: Text(
                          'Sign In',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .signInWithEmailandPassword(Email, Password);
                            if (result == null) {
                              setState(() {
                                Error =
                                    'Could Not Sign In With Those Credentials';
                                loading = false;
                              });
                            }
                          }
                        }),
                    SizedBox(height: 24),
                    GestureDetector(
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 20,
                        ),
                      ),
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()
                        )),
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      Error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, right: 10, left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text('+20'),
                  ),
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            )
                  ]),
          Container(
            margin: EdgeInsets.all(10),
            width: double.infinity,
            child: FlatButton(
              color: Colors.blue,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OTPScreen(_controller.text)));
              },
              child: Text(
                'Next',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
              ],
            )
          );
  }
}
