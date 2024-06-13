import 'package:flutter/material.dart';
import 'rounded_button.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  bool isEmailVerified = false;
  late String email = "";
  late String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text("registration"), // 顯示暱稱
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 12.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                RoundedButton(
                  title: 'Verify',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        await newUser.user!.sendEmailVerification();
                        setState(() {
                          isEmailVerified = true;
                        });
                        _showVerificationSentDialog();
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      print(e.message);
                      _showErrorDialog('${e.message}\n[${e.code}]');
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                ),
                SizedBox(
                  height: 12.0,
                ),
                RoundedButton(
                  title: 'Register',
                  colour: isEmailVerified ? Colors.blueAccent : Colors.grey,
                  onPressed: isEmailVerified
                      ? () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final currentUser = _auth.currentUser;
                            if (currentUser != null) {
                              await currentUser.reload();
                              if (currentUser.emailVerified) {
                                Navigator.pushNamed(context, ChatScreen.id);
                              } else {
                                _showErrorDialog(
                                    'Please verify your email first.');
                              }
                            }
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print('register_catch: $e');
                            setState(() {
                              showSpinner = false;
                            });
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVerificationSentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Verification Email Sent'),
        content: Text(
            'A verification email has been sent to $email. Please verify your email before proceeding.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
