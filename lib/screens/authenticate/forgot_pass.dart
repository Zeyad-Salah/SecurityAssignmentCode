import 'package:brew_crew/screens/authenticate/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({ Key key }) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text('Reset Password'),

    ),
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Recieve an Email to\nreset your password',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => 
                email != null && !EmailValidator.validate(email)
                ? 'Enter a valid Email'
                : null,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              icon: Icon(Icons.email_outlined),
              label: Text(
                'Reset Password',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => resetPassword,
            )
          ],
        ),
        ),
    ),
  );

  Future resetPassword() async {
    showDialog(
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
      );

    try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());

    Utils.showSnackBar('Password Reset Email Sent');
  } on FirebaseAuthException catch (e) {
    print(e);

    Utils.showSnackBar(e.message);
  }
  }
}