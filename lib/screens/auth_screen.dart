import 'package:academind_firebase_chat/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuth(String email, String pw, String username, bool isLogin,
      BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // Log a user in
        authResult =
            await _auth.signInWithEmailAndPassword(email: email, password: pw);
      } else {
        // Create a new user
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pw);
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': username, 'email': email});
      }
    } on PlatformException catch (e) {
      var message = 'An error occurred. Please check your credentials!';
      if (e.message != null) {
        message = e.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuth, _isLoading),
    );
  }
}
