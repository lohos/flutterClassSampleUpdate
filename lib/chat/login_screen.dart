import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 引入 flutter_secure_storage 包
import 'rounded_button.dart'; // 自定義按鈕組件
import 'chat_screen.dart';
import '../constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _storage = FlutterSecureStorage();
  final mTextController = TextEditingController();
  final mTextControllerPass = TextEditingController();
  late String email = '';
  late String password = '';
  bool showSpinner = false;
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail(); // 在初始化時加載存儲的 email
  }

  Future<void> _loadUserEmail() async {
    String? storedEmail = await _storage.read(key: 'userEmail');
    if (storedEmail != null) {
      setState(() {
        email = storedEmail;
        mTextController.text = email;
        rememberMe = true; // 如果存儲了 email，則勾選 checkbox
      });
    }
  }

  Future<void> _storeUserEmail(String email) async {
    await _storage.write(key: 'userEmail', value: email);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('登入失敗'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('確定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        title: Text("login"), // 顯示暱稱
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
                    hintText: 'Enter your email',
                  ),
                  controller: mTextController, // 自動填充 email
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                  },
                  controller: mTextControllerPass,
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text('儲存帳號'),
                  ],
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  title: 'Log In',
                  colour: Colors.lightBlueAccent,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        if (rememberMe) {
                          await _storeUserEmail(email); // 存儲 email
                        } else {
                          await _storage.delete(
                              key: 'userEmail'); // 清除已存儲的 email
                          mTextController.clear();
                          mTextControllerPass.clear();
                        }
                        Navigator.pushNamed(context, ChatScreen.id);
                      } else {
                        _showErrorDialog('無法登入，帳號或密碼輸入不正確。'); // 顯示錯誤提示對話框
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e);
                      _showErrorDialog(
                          '${e.message}\n[${e.code}]'); // 顯示錯誤提示對話框
                    } finally {
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
